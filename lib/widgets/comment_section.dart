// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whisper/screens/profile/friend_profile_screen.dart';
import 'package:whisper/views/tab_screen.dart';
import 'package:whisper/service/friend_service.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/custom_text_field.dart';
import 'package:whisper/widgets/image_widget.dart';
import 'package:whisper/widgets/yes_no_widget.dart';

class CommentBottomSheet extends StatefulWidget {
  final String id;
  CommentBottomSheet(this.id);
  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  TextEditingController comment = TextEditingController();
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  String commentID = "";
  String name = "";
  String emailReplier = "";
  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();
    return DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.9,
        minChildSize: 0.2,
        builder: ((context, scrollController) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            padding: EdgeInsets.only(top: 20),
            child: Scaffold(
              body: ListView(controller: scrollController, children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("posts")
                        .doc(widget.id)
                        .collection('comments')
                        .orderBy('time')
                        .snapshots(),
                    builder: (context, snapshot) {
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
                          child: Text('There is no comments yet',
                              style: TextStyle(
                                  color: kred,
                                  fontFamily: 'Poppins',
                                  fontSize: 14)),
                        );
                      }
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          comments = snapshot.data!.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: comments.length,
                        itemBuilder: (BuildContext context, int index) {
                          DateTime time = comments[index]['time'].toDate();
                          return FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('users')
                                  .where('email',
                                      isEqualTo: comments[index]["email"])
                                  .get(),
                              builder: ((context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> commenter =
                                      snapshot.data!.docs.first.data();
                                  String userID = snapshot.data!.docs.first.id;
                                  return Column(children: [
                                    GestureDetector(
                                      onLongPress: () {
                                        if (comments[index]['email'] == email) {
                                          showDialog(
                                              context: context,
                                              builder: ((context) {
                                                return YesNoWidget(
                                                    'Are you sure,that you want to delete this comment?',
                                                    () {
                                                  deleteComment(
                                                      comments[index].id);
                                                });
                                              }));
                                        }
                                      },
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 20, 20),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(right: 5),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      if (comments[index]
                                                              ['email'] ==
                                                          email) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        TabScreen(
                                                                            4)));
                                                      } else {
                                                        Provider.of<Friend>(
                                                                context,
                                                                listen: false)
                                                            .setFriend(
                                                                commenter,
                                                                userID);
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        FriendProfileScreen()));
                                                      }
                                                    },
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
                                                        child: ImageWidget(
                                                            commenter[
                                                                'profilePic'],
                                                            40,
                                                            40)),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5,
                                                          horizontal: 10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                          color: kred),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          GestureDetector(
                                                              onTap: () async {
                                                                if (comments[
                                                                            index]
                                                                        [
                                                                        'email'] ==
                                                                    email) {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              TabScreen(4)));
                                                                } else {
                                                                  Provider.of<Friend>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .setFriend(
                                                                          commenter,
                                                                          userID);
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              FriendProfileScreen()));
                                                                }
                                                              },
                                                              child: Text(
                                                                commenter[
                                                                    'fullName'],
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Theme.of(context).scaffoldBackgroundColor ==
                                                                            klightBG
                                                                        ? kdark
                                                                        : kwhite),
                                                              )),
                                                          Text(
                                                            comments[index]
                                                                ['comment'],
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 14,
                                                                color: Theme.of(context)
                                                                            .scaffoldBackgroundColor ==
                                                                        klightBG
                                                                    ? kdark
                                                                    : kwhite),
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 55),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    date
                                                                .difference(
                                                                    time)
                                                                .inSeconds <
                                                            60
                                                        ? '${date.difference(time).inSeconds} sec'
                                                        : date
                                                                    .difference(
                                                                        time)
                                                                    .inMinutes <
                                                                60
                                                            ? '${date.difference(time).inMinutes} min'
                                                            : date
                                                                        .difference(
                                                                            time)
                                                                        .inHours <
                                                                    24
                                                                ? '${date.difference(time).inHours} h'
                                                                : date.difference(time).inDays <
                                                                        30
                                                                    ? '${date.difference(time).inDays} days'
                                                                    : DateFormat(
                                                                            'dd MMM yyyy')
                                                                        .format(
                                                                            time)
                                                                        .toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 14,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                  SizedBox(width: 20),
                                                  GestureDetector(
                                                      onTap: () async {
                                                        await likeButton(
                                                            comments[index].id,
                                                            comments[index]
                                                                ['likes'],
                                                            comments[index]
                                                                ['likedBy']);
                                                      },
                                                      child: RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "${comments[index]['likes']}",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: comments[index]
                                                                            [
                                                                            'likedBy']
                                                                        .contains(
                                                                            email)
                                                                    ? kred
                                                                    : Theme.of(
                                                                            context)
                                                                        .primaryColor),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                text: comments[index]
                                                                            [
                                                                            'likes'] <=
                                                                        1
                                                                    ? ' Like'
                                                                    : ' Likes',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        14,
                                                                    color: comments[index]['likedBy'].contains(
                                                                            email)
                                                                        ? kred
                                                                        : Theme.of(context)
                                                                            .primaryColor),
                                                              )
                                                            ]),
                                                      )),
                                                  SizedBox(width: 20),
                                                  GestureDetector(
                                                    onTap: () {
                                                      comment.text =
                                                          "@${commenter['fullName']} ";
                                                      setState(() {
                                                        commentID =
                                                            comments[index].id;
                                                        name =
                                                            "@${commenter['fullName']} ";
                                                      });
                                                    },
                                                    child: Text(
                                                      'Reply',
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('posts')
                                            .doc(widget.id)
                                            .collection('comments')
                                            .doc(comments[index].id)
                                            .collection('replies')
                                            .orderBy('time')
                                            .snapshots(),
                                        builder: ((context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        color: kred
                                                            .withOpacity(0.8)));
                                          } else if (snapshot.hasError) {
                                            return Center(
                                              child: Text(
                                                  'There was an error while fetching the data',
                                                  style: TextStyle(
                                                      color: kred,
                                                      fontFamily: 'Poppins',
                                                      fontSize: 14)),
                                            );
                                          }
                                          List<
                                                  QueryDocumentSnapshot<
                                                      Map<String, dynamic>>>
                                              replies = snapshot.data!.docs;
                                          return ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: replies.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index2) {
                                                DateTime time2 = replies[index2]
                                                        ['time']
                                                    .toDate();
                                                return FutureBuilder(
                                                    future: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .where('email',
                                                            isEqualTo:
                                                                replies[index2]
                                                                    ["email"])
                                                        .get(),
                                                    builder:
                                                        ((context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        Map<String, dynamic>
                                                            replier = snapshot
                                                                .data!
                                                                .docs
                                                                .first
                                                                .data();
                                                        String userID2 =
                                                            snapshot.data!.docs
                                                                .first.id;
                                                        return Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 40),
                                                          child:
                                                              GestureDetector(
                                                            onLongPress: () {
                                                              if (replies[index2]
                                                                      [
                                                                      'email'] ==
                                                                  email) {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        ((context) {
                                                                      return YesNoWidget(
                                                                          'Are you sure,that you want to delete this reply?',
                                                                          () {
                                                                        deleteReply(
                                                                            comments[index].id,
                                                                            replies[index2].id);
                                                                      });
                                                                    }));
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          20,
                                                                          0,
                                                                          20,
                                                                          20),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.only(right: 5),
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            if (replies[index2]['email'] ==
                                                                                email) {
                                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => TabScreen(4)));
                                                                            } else {
                                                                              Provider.of<Friend>(context, listen: false).setFriend(replier, userID2);
                                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => FriendProfileScreen()));
                                                                            }
                                                                          },
                                                                          child: ClipRRect(
                                                                              borderRadius: BorderRadius.circular(40),
                                                                              child: ImageWidget(replier['profilePic'], 40, 40)),
                                                                        ),
                                                                      ),
                                                                      Flexible(
                                                                        child: Container(
                                                                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                                            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)), color: kred),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                GestureDetector(
                                                                                    onTap: () async {
                                                                                      if (replies[index2]['email'] == email) {
                                                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => TabScreen(4)));
                                                                                      } else {
                                                                                        Provider.of<Friend>(context, listen: false).setFriend(replier, userID2);
                                                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => FriendProfileScreen()));
                                                                                      }
                                                                                    },
                                                                                    child: Text(
                                                                                      replier['fullName'],
                                                                                      style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).scaffoldBackgroundColor == klightBG ? kdark : kwhite),
                                                                                    )),
                                                                                RichText(
                                                                                    text: TextSpan(
                                                                                        text: "@${replies[index2]['repliyedTo']['name']}",
                                                                                        recognizer: TapGestureRecognizer()
                                                                                          ..onTap = () {
                                                                                            if (replies[index2]['repliyedTo']['email'] == email) {
                                                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => TabScreen(4)));
                                                                                            } else {
                                                                                              FirebaseFirestore.instance.collection("users").where('email', isEqualTo: replies[index2]['repliyedTo']['email']).get().then((value) {
                                                                                                Provider.of<Friend>(context, listen: false).setFriend(value.docs.first.data(), value.docs.first.id);
                                                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => FriendProfileScreen()));
                                                                                              });
                                                                                            }
                                                                                          },
                                                                                        style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Theme.of(context).scaffoldBackgroundColor == klightBG ? kdark : kwhite, fontWeight: FontWeight.bold),
                                                                                        children: [
                                                                                      TextSpan(text: " ${replies[index2]['reply']}", style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Theme.of(context).scaffoldBackgroundColor == klightBG ? kdark : kwhite, fontWeight: FontWeight.w400))
                                                                                    ])),
                                                                              ],
                                                                            )),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            55),
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          date.difference(time2).inSeconds < 60
                                                                              ? '${date.difference(time2).inSeconds} sec'
                                                                              : date.difference(time2).inMinutes < 60
                                                                                  ? '${date.difference(time2).inMinutes} min'
                                                                                  : date.difference(time2).inHours < 24
                                                                                      ? '${date.difference(time2).inHours} h'
                                                                                      : date.difference(time2).inDays < 30
                                                                                          ? '${date.difference(time2).inDays} days'
                                                                                          : DateFormat('dd MMM yyyy').format(time2).toString(),
                                                                          style: TextStyle(
                                                                              fontFamily: 'Poppins',
                                                                              fontSize: 14,
                                                                              color: Theme.of(context).primaryColor),
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                20),
                                                                        GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              await likeReplyButton(comments[index].id, replies[index2].id, replies[index2]['likes'], replies[index2]['likedBy']);
                                                                            },
                                                                            child:
                                                                                RichText(
                                                                              text: TextSpan(text: "${replies[index2]['likes']}", style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500, color: replies[index2]['likedBy'].contains(email) ? kred : Theme.of(context).primaryColor), children: <TextSpan>[
                                                                                TextSpan(
                                                                                  text: replies[index2]['likes'] <= 1 ? ' Like' : ' Likes',
                                                                                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 14, color: replies[index2]['likedBy'].contains(email) ? kred : Theme.of(context).primaryColor),
                                                                                )
                                                                              ]),
                                                                            )),
                                                                        SizedBox(
                                                                            width:
                                                                                20),
                                                                        GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              comment.text = "@${replier['fullName']} ";
                                                                              setState(() {
                                                                                commentID = comments[index].id;
                                                                                name = "@${replier['fullName']} ";
                                                                                emailReplier = replier['email'];
                                                                              });
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'Reply',
                                                                              style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      return Container();
                                                    }));
                                              });
                                        })),
                                  ]);
                                }
                                return Container();
                              }));
                        },
                      );
                    }),
                SizedBox(height: 60)
              ]),
              bottomSheet: Container(
                  color: Theme.of(context).primaryColorDark,
                  padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                                height: 40,
                                child: CustomTextField(comment, 'Comment...'))),
                        IconButton(
                            onPressed: () async {
                              if (comment.text.isNotEmpty) {
                                if (comment.text.contains('@') && commentID!="") {
                                  await addReply(commentID,
                                      comment.text.substring(name.length - 1),);
                                } else {
                                  await addComment();
                                }
                                comment.clear();
                              }
                            },
                            icon: Icon(
                              Icons.send,
                              color: kred,
                              size: 30,
                            )),
                      ],
                    ),
                  )),
            ))));
  }

  addComment() {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.id)
        .collection('comments')
        .doc()
        .set({
      'email': email,
      'comment': comment.text,
      'time': DateTime.now(),
      'likes': 0,
      'likedBy': []
    });
  }

  likeButton(String commentID, int likes, List likedBy) {
    List list = likedBy;
    if (list.contains(email)) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.id)
          .collection('comments')
          .doc(commentID)
          .update({'likes': likes - 1});
      list.remove(email);
      FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.id)
          .collection('comments')
          .doc(commentID)
          .update({'likedBy': list});
    } else {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.id)
          .collection('comments')
          .doc(commentID)
          .update({'likes': likes + 1});
      list.add(email);
      FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.id)
          .collection('comments')
          .doc(commentID)
          .update({'likedBy': list});
    }
  }

  deleteComment(String commentID) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.id)
        .collection('comments')
        .doc(commentID)
        .delete();
    Navigator.of(context).pop();
  }

  addReply(String commentID, String reply) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.id)
        .collection('comments')
        .doc(commentID)
        .collection('replies')
        .doc()
        .set({
      'email': email,
      'reply': reply,
      'repliyedTo': {
        'name': name.substring(1, name.length - 1),
        'email': emailReplier
      },
      'time': DateTime.now(),
      'likes': 0,
      'likedBy': []
    });
    setState(() {
      name = "";
      commentID = "";
      emailReplier="";
    });
  }

  likeReplyButton(String commentID, String replyID, int likes, List likedBy) {
    List list = likedBy;
    if (list.contains(email)) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.id)
          .collection('comments')
          .doc(commentID)
          .collection('replies')
          .doc(replyID)
          .update({'likes': likes - 1});
      list.remove(email);
      FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.id)
          .collection('comments')
          .doc(commentID)
          .collection('replies')
          .doc(replyID)
          .update({'likedBy': list});
    } else {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.id)
          .collection('comments')
          .doc(commentID)
          .collection('replies')
          .doc(replyID)
          .update({'likes': likes + 1});
      list.add(email);
      FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.id)
          .collection('comments')
          .doc(commentID)
          .collection('replies')
          .doc(replyID)
          .update({'likedBy': list});
    }
  }

  deleteReply(String commentID, String replyID) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.id)
        .collection('comments')
        .doc(commentID)
        .collection('replies')
        .doc(replyID)
        .delete();
    Navigator.of(context).pop();
  }
}
