// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisper/screens/profile/friend_profile_screen.dart';
import 'package:whisper/service/friend_service.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/image_widget.dart';
import 'package:whisper/widgets/yes_no_widget.dart';

class NotifcationFriendsScreen extends StatefulWidget {
  const NotifcationFriendsScreen({super.key});

  @override
  State<NotifcationFriendsScreen> createState() =>
      _NotifcationFriendsScreenState();
}

class _NotifcationFriendsScreenState extends State<NotifcationFriendsScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  bool isLoading1 = false;
  bool isLoading2 = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('friends')
            .get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
                child:
                    CircularProgressIndicator(color: kred.withOpacity(0.8)));
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("You don't have friends yet",
                  style: TextStyle(
                      color: kred, fontFamily: 'Poppins', fontSize: 14)),
            );
          }
          List<QueryDocumentSnapshot<Map<String, dynamic>>> friends =
              snapshot.data!.docs;
          return ListView.builder(
              itemCount: friends.length,
              itemBuilder: ((context, index) {
                return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("users")
                        .doc(friends[index].id)
                        .get(),
                    builder: ((context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: CircularProgressIndicator(
                                color: kred.withOpacity(0.8)));
                      } else if (friends[index]['request'] == 'waiting') {
                        return GestureDetector(
                          onTap: () async {
                            Provider.of<Friend>(context, listen: false)
                                .setFriend(
                                    snapshot.data!.data()!, snapshot.data!.id);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FriendProfileScreen()));
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 25, right: 25),
                              child: Row(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: ImageWidget(
                                          snapshot.data!.data()!['profilePic'],
                                          60,
                                          60)),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                            text: TextSpan(
                                                text: snapshot.data!
                                                    .data()!['fullName'],
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontFamily: "Poppins",
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: [
                                              TextSpan(
                                                text:
                                                    " sent you a friend request",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontFamily: "Poppins",
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ])),
                                        Text(
                                          snapshot.data!.data()!['title'],
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.8),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                                height: 45,
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                decoration: BoxDecoration(
                                                    color: kred,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                child: TextButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            buildContext) {
                                                          return YesNoWidget(
                                                              "Do you want to accept ${snapshot.data!.data()!['fullName']}'s friend request?",
                                                              () {
                                                            confirmFriend(
                                                              snapshot.data!.id,
                                                            );
                                                          });
                                                        });
                                                  },
                                                  child: isLoading1
                                                      ? CircularProgressIndicator(
                                                          color: kwhite,
                                                        )
                                                      : Text(
                                                          'Confirm',
                                                          style: TextStyle(
                                                              color: kwhite,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  "Poppins"),
                                                        ),
                                                )),
                                            Container(
                                                height: 45,
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                decoration: BoxDecoration(
                                                    color: kwhite,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                child: TextButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            buildContext) {
                                                          return YesNoWidget(
                                                              "Do you want to remove ${snapshot.data!.data()!['fullName']}'s friend request?",
                                                              () {
                                                            declineFriend(
                                                                snapshot
                                                                    .data!.id);
                                                          });
                                                        });
                                                  },
                                                  child: isLoading2
                                                      ? CircularProgressIndicator(
                                                          color: kred,
                                                        )
                                                      : Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                              color: kred,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  "Poppins"),
                                                        ),
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        );
                      } else if (friends[index]['request'] == 'accepted' &&
                          friends[index]['type'] == 'sender') {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: ImageWidget(
                                    snapshot.data!.data()!['profilePic'],
                                    60,
                                    60)),
                            title: Text(
                              "${snapshot.data!.data()!['fullName']} accepted your friend request",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }
                      return Container();
                    }));
              }));
        }));
  }

  confirmFriend(String id) {
    setState(() {
      isLoading1 = true;
    });
    Navigator.of(context).pop();
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
    setState(() {
      isLoading1 = false;
    });
  }

  declineFriend(String id) async {
    setState(() {
      isLoading2 = true;
    });
    Navigator.of(context).pop();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("friends")
        .doc(id)
        .delete();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("friends")
        .doc(uid)
        .delete();
    setState(() {
      isLoading2 = false;
    });
  }
}
