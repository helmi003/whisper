// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisper/screens/posts/post_screen.dart';
import 'package:whisper/service/posts_services.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/image_widget.dart';

class NotifcationPostsScreen extends StatefulWidget {
  const NotifcationPostsScreen({super.key});

  @override
  State<NotifcationPostsScreen> createState() => _NotifcationPostsScreenState();
}

class _NotifcationPostsScreenState extends State<NotifcationPostsScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('friends')
            .where('request', isEqualTo: 'accepted')
            .get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
                child: CircularProgressIndicator(color: kred.withOpacity(0.8)));
          } else if (snapshot.data!.docs.isEmpty) {
            return Container();
          }
          List<QueryDocumentSnapshot<Map<String, dynamic>>> friends =
              snapshot.data!.docs;
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: ((context, index1) {
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
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
                      }
                      List<QueryDocumentSnapshot<Map<String, dynamic>>> posts =
                          snapshot.data!.docs;
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: posts.length,
                            itemBuilder: ((context, index2) {
                              if (posts[index2]['owner'] !=
                                  friends[index1]['email']) {
                                return Container();
                              }
                              return FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('users')
                                      .where('email',
                                          isEqualTo: friends[index1]['email'])
                                      .get(),
                                  builder: ((context, snapshot) {
                                    if (snapshot.connectionState !=
                                        ConnectionState.done) {
                                      return Center(
                                          child: CircularProgressIndicator(
                                              color: kred.withOpacity(0.8)));
                                    }
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: ListTile(
                                        onTap: () {
                                          Provider.of<PostServices>(context,
                                                  listen: false)
                                              .setPost(
                                            posts[index2].id,
                                            snapshot
                                                .data!.docs.first['profilePic'],
                                            snapshot
                                                .data!.docs.first['fullName'],
                                            posts[index2]['tags'],
                                            posts[index2]['time'].toDate(),
                                            posts[index2]['message'],
                                            posts[index2]['photo'],
                                            posts[index2]['likes'],
                                            posts[index2]['likedBy']
                                                    .contains(email)
                                                ? kred
                                                : Theme.of(context)
                                                    .primaryColor,
                                            posts[index2]['owner'] == email
                                                ? true
                                                : false,
                                          );
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PostScreen()));
                                        },
                                        leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                            child: ImageWidget(
                                                snapshot.data!.docs
                                                    .first['profilePic'],
                                                60,
                                                60)),
                                        title: RichText(
                                            text: TextSpan(
                                                text: snapshot.data!.docs
                                                    .first['fullName'],
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontFamily: "Poppins",
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: [
                                              TextSpan(
                                                text: " add a new post",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontFamily: "Poppins",
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ])),
                                        subtitle: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          child: RichText(
                                              text: TextSpan(
                                                  text: posts[index2]
                                                      ['message'],
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.8),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  children: [
                                                TextSpan(
                                                  text: " ...See more",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontFamily: "Poppins",
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ])),
                                        ),
                                      ),
                                    );
                                  }));
                            })),
                      );
                    }));
              }));
        }));
  }
}
