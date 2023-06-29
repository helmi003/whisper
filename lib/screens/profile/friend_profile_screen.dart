// ignore_for_file: prefer_const_constructors, prefer_const_declarations, non_constant_identifier_names, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:whisper/views/profile_screen.dart';
import 'package:whisper/service/friend_service.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/app_bar.dart';
import 'package:whisper/widgets/custom_button2.dart';
import 'package:whisper/widgets/image_widget.dart';
import 'package:whisper/widgets/Homepost.dart';
import 'package:whisper/widgets/social.dart';
import 'package:whisper/widgets/yes_no_widget.dart';

class FriendProfileScreen extends StatefulWidget {
  @override
  State<FriendProfileScreen> createState() => _FriendProfileScreenState();
}

class _FriendProfileScreenState extends State<FriendProfileScreen> {
  Map<String, dynamic> friend = {};
  bool isLoading = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  @override
  Widget build(BuildContext context) {
    friend = Provider.of<Friend>(context).friend;
    return Scaffold(
        appBar: appBar(context, 'Friend profile'),
        body: ListView(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 244,
                child: Stack(
                  children: [
                    ImageWidget(friend['bgPic'], 145,
                        MediaQuery.of(context).size.width),
                    Positioned(
                        bottom: 0,
                        left: 25,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(120),
                            child:
                                ImageWidget(friend['profilePic'], 120, 120))),
                    Positioned(
                      top: 157,
                      left: 160,
                      child: Text(friend['fullName'],
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor)),
                    ),
                    Positioned(
                      top: 184,
                      left: 160,
                      child: Text('${friend['friends']} Friends',
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
                              .format(friend['birthday'].toDate())
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
              friend['title'] != ""
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(25, 12, 25, 0),
                      child: Text(friend['title'],
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor)),
                    )
                  : Container(),
              friend['bio'] != ""
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 25, top: 10, bottom: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            constraints: BoxConstraints(maxWidth: 200),
                            child: ReadMoreText(
                              friend['bio'],
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
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('friends')
                      .where('email', isEqualTo: friend['email'])
                      .get(),
                  builder: ((context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: CircularProgressIndicator(
                              color: kred.withOpacity(0.8)));
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomButton2(isLoading, 'Send friend request', () {
                              addFriend(friend['id']);
                            }),
                          ],
                        ),
                      );
                    } else if (snapshot.data!.docs
                        .where((QueryDocumentSnapshot<Object?> element) =>
                            element['email']
                                .toString()
                                .contains(friend['email']) &&
                            element['request'].toString().contains("waiting"))
                        .isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomButton2(isLoading, 'Accept request', () {
                              showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return YesNoWidget(
                                        "Do you want to accept ${friend['fullName']}'s friend request",
                                        () {
                                      acceptFriendRequest(friend['id']);
                                    });
                                  }));
                            }),
                            SizedBox(height: 5),
                            CustomButton2(isLoading, 'Remove request', () {
                              showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return YesNoWidget(
                                        "Are you sure you want to remove the friend request?",
                                        () {
                                      removeFriendRequest(friend['id']);
                                    });
                                  }));
                            }),
                          ],
                        ),
                      );
                    } else if (snapshot.data!.docs
                        .where((QueryDocumentSnapshot<Object?> element) =>
                            element['email']
                                .toString()
                                .contains(friend['email']) &&
                            element['request'].toString().contains("requested"))
                        .isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomButton2(isLoading, 'Remove request', () {
                              showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return YesNoWidget(
                                        "Are you sure you want to remove the friend request?",
                                        () {
                                      removeFriendRequest(friend['id']);
                                    });
                                  }));
                            }),
                          ],
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomButton2(isLoading, 'Remove friend', () {
                            showDialog(
                                context: context,
                                builder: ((context) {
                                  return YesNoWidget(
                                      "Are you sure you want to remove '${friend['fullName']}'",
                                      () {
                                    deleteFriend(friend['id']);
                                  });
                                }));
                          }),
                        ],
                      ),
                    );
                  })),
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
                child: friend['socials'].isNotEmpty
                    ? Row(
                        children: friend['socials'].map<Widget>((social) {
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
              )
            ],
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
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .where('owner', isEqualTo: friend['email'])
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
                      return HomePosts(
                          posts[index].id,
                          posts[index].data().containsKey('shared')
                              ? posts[index]['shared']
                              : {},
                          friend['profilePic'],
                          friend['fullName'],
                          posts[index]['tags'],
                          posts[index]['time'].toDate(),
                          posts[index]['message'],
                          posts[index]['photo'],
                          posts[index]['likes'],
                          posts[index]['likedBy'].contains(email)
                              ? kred
                              : Theme.of(context).primaryColor,
                          posts[index]['owner'] == friend['email']
                              ? true
                              : false, () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen()));
                      });
                    });
              })),
        ]));
  }

  addFriend(String id) {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("friends")
        .doc(id)
        .set({"email": friend['email'], "request": "requested","type":"sender"});
    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("friends")
        .doc(uid)
        .set({"email": email, "request": "waiting","type":"receiver"});
    setState(() {
      isLoading = false;
    });
  }

  deleteFriend(String id) {
    setState(() {
      isLoading = true;
    });
    int nb1 = 0;
    int nb2 = 0;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('friends')
        .doc(id)
        .delete();
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('friends')
        .doc(uid)
        .delete();
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
      setState(() {
        nb1 = value['friends'];
      });
    });
    FirebaseFirestore.instance.collection("users").doc(id).get().then((value) {
      setState(() {
        nb2 = value['friends'];
      });
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'friends': nb1 - 1});
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'friends': nb2 - 1});
    Navigator.of(context).pop();
    setState(() {
      isLoading = false;
    });
  }

  removeFriendRequest(String id) {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('friends')
        .doc(id)
        .delete();
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('friends')
        .doc(uid)
        .delete();
    Navigator.of(context).pop();
    setState(() {
      isLoading = false;
    });
  }

  acceptFriendRequest(String id) {
    setState(() {
      isLoading = true;
    });
    int nb1 = 0;
    int nb2 = 0;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('friends')
        .doc(id)
        .update({"request": "accepted"});
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('friends')
        .doc(uid)
        .update({"request": "accepted"});
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
      setState(() {
        nb1 = value['friends'];
      });
    });
    FirebaseFirestore.instance.collection("users").doc(id).get().then((value) {
      setState(() {
        nb2 = value['friends'];
      });
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'friends': nb1 + 1});
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'friends': nb2 + 1});
    Navigator.of(context).pop();
    setState(() {
      isLoading = false;
    });
  }
}
