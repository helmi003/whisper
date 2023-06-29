// ignore_for_file: prefer_const_constructors, prefer_const_declarations, non_constant_identifier_names, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:whisper/screens/profile/edit_profile_screen.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/custom_button2.dart';
import 'package:whisper/widgets/image_widget.dart';
import 'package:whisper/widgets/new_post.dart';
import 'package:whisper/widgets/Homepost.dart';
import 'package:whisper/widgets/social.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      FutureBuilder(
          future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                  child:
                      CircularProgressIndicator(color: kred.withOpacity(0.8)));
            } else if (snapshot.hasError) {
              return Center(
                child: Text('There was an error while fetching the data',
                    style: TextStyle(
                        color: kred, fontFamily: 'Poppins', fontSize: 14)),
              );
            }
            final user = snapshot.data!.data();
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 244,
                  child: Stack(
                    children: [
                      ImageWidget(snapshot.data!['bgPic'], 145,
                          MediaQuery.of(context).size.width),
                      Positioned(
                          bottom: 0,
                          left: 25,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(120),
                              child: ImageWidget(
                                  snapshot.data!['profilePic'], 120, 120))),
                      Positioned(
                        top: 157,
                        left: 160,
                        child: Text(snapshot.data!['fullName'],
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor)),
                      ),
                      Positioned(
                        top: 184,
                        left: 160,
                        child: Text('${snapshot.data!['friends']} Friends',
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor)),
                      ),
                      Positioned(
                        top: 208,
                        left: 160,
                        child: Text(
                            DateFormat('dd/MM/yyyy')
                                .format(snapshot.data!['birthday'].toDate())
                                .toString(),
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor)),
                      ),
                    ],
                  ),
                ),
                snapshot.data!['title'] != ""
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(25, 12, 25, 0),
                        child: Text(snapshot.data!['title'],
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor)),
                      )
                    : Container(),
                snapshot.data!['bio'] != ""
                    ? Padding(
                        padding:
                            const EdgeInsets.only(left: 25, top: 10, bottom: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              constraints: BoxConstraints(maxWidth: 200),
                              child: ReadMoreText(
                                snapshot.data!['bio'],
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: kdarkGrey),
                                trimLines: 4,
                                textAlign: TextAlign.justify,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: "Show more",
                                trimExpandedText: " Show less",
                                lessStyle: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
                                moreStyle: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomButton2(false, 'Edit profile', () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileScreen()));
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 5, 0, 17),
                  child: Text(
                    'Socials:',
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 17),
                  child: snapshot.data!['socials'].isNotEmpty
                      ? Row(
                          children:
                              snapshot.data!['socials'].map<Widget>((social) {
                          return SocialWidget(
                              social['icon'], social['link'], () {});
                        }).toList())
                      : Center(
                          child: Text(
                            'There is no socials yet',
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: kred.withOpacity(0.8)),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, bottom: 7),
                  child: Text(
                    'Posts:',
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                NewPost(snapshot.data!['profilePic']),
                Divider(
                  color: kdarkGrey,
                  height: 50,
                  thickness: 2,
                  indent: 20,
                  endIndent: 25,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("posts")
                        .where('owner', isEqualTo: snapshot.data!['email'])
                        .snapshots(),
                    builder: ((context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: CircularProgressIndicator(
                                color: kred.withOpacity(0.8)));
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                              'There was an error while fetching the data',
                              style: TextStyle(
                                  color: kred,
                                  fontFamily: 'Poppins',
                                  fontSize: 14)),
                        );
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text('There is no posts yet',
                              style: TextStyle(
                                  color: kred,
                                  fontFamily: 'Poppins',
                                  fontSize: 14)),
                        );
                      }
                      List<QueryDocumentSnapshot<Map<String, dynamic>>> posts =
                          snapshot.data!.docs;
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: posts.length,
                          itemBuilder: (BuildContext context, int index) {
                            return HomePosts(
                              posts[index].id,
                              posts[index].data().containsKey('shared')?posts[index]['shared']:{},
                                user!['profilePic'],
                                user['fullName'],
                                posts[index]['tags'],
                                posts[index]['time'].toDate(),
                                posts[index]['message'],
                                posts[index]['photo'],
                                posts[index]['likes'],
                                posts[index]['likedBy'].contains(user['email'])
                                    ? kred
                                    : Theme.of(context).primaryColor,
                                posts[index]['owner'] == email ? true : false,
                                () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreen()));
                            });
                          });
                    })),
              ],
            );
          }),
    ]));
  }
}
