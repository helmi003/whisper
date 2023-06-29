// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisper/screens/profile/friend_profile_screen.dart';
import 'package:whisper/views/tab_screen.dart';
import 'package:whisper/service/friend_service.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/new_post.dart';
import '../widgets/Homepost.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        SizedBox(height: 20),
        FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('users')
                .where('email', isEqualTo: email)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                    child: CircularProgressIndicator(
                        color: kred.withOpacity(0.8)));
              }
              return NewPost(snapshot.data!.docs.first['profilePic']);
            }),
        Divider(
          color: kdarkGrey,
          height: 60,
          thickness: 2,
          indent: 25,
          endIndent: 25,
        ),
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .orderBy(
                  'time',
                  descending: true,
                )
                .snapshots(),
            builder: ((context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                        color: kred.withOpacity(0.8)));
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('There was an error while fetching the data',
                      style: TextStyle(
                          color: kred, fontFamily: 'Poppins', fontSize: 14)),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('There is no posts yet',
                      style: TextStyle(
                          color: kred, fontFamily: 'Poppins', fontSize: 14)),
                );
              }
              List<QueryDocumentSnapshot<Map<String, dynamic>>> posts =
                  snapshot.data!.docs;
              return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .where('email', isEqualTo: posts[index]['owner'])
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Center(
                                child: CircularProgressIndicator(
                                    color: kred.withOpacity(0.8)));
                          }
                          // QuerySnapshot<Map<String, dynamic>> _query =
                          // await FirebaseFirestore.instance.collection('collectionPath').get();
                          // if (test.isEmpty) {}
                          return HomePosts(
                              posts[index].id,
                              posts[index].data().containsKey('shared')
                                  ? posts[index]['shared']
                                  : {},
                              snapshot.data!.docs.first['profilePic'],
                              snapshot.data!.docs.first['fullName'],
                              posts[index]['tags'],
                              posts[index]['time'].toDate(),
                              posts[index]['message'],
                              posts[index]['photo'],
                              posts[index]['likes'],
                              posts[index]['likedBy'].contains(email)
                                  ? kred
                                  : Theme.of(context).primaryColor,
                              posts[index]['owner'] == email ? true : false,
                              () {
                            if (snapshot.data!.docs.first['email'] == email) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TabScreen(4)));
                            } else {
                              Provider.of<Friend>(context, listen: false)
                                  .setFriend(snapshot.data!.docs.first.data(),
                                      snapshot.data!.docs.first.id);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FriendProfileScreen()));
                            }
                          });
                        });
                  });
            })),
      ]),
    );
  }
}
