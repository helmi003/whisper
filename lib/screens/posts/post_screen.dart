// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:whisper/screens/profile/friend_profile_screen.dart';
import 'package:whisper/views/tab_screen.dart';
import 'package:whisper/service/friend_service.dart';
import 'package:whisper/service/posts_services.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/app_bar.dart';
import 'package:whisper/widgets/app_plus_bar.dart';
import 'package:whisper/widgets/comment_section.dart';
import 'package:whisper/widgets/image_widget.dart';
import 'package:whisper/widgets/yes_no_widget.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Map<String, dynamic> post = {};
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  @override
  Widget build(BuildContext context) {
    post = Provider.of<PostServices>(context).post;
    DateTime date = DateTime.now();
    final difference = date.difference(post['time']).inSeconds < 60
        ? '${date.difference(post['time']).inSeconds} sec'
        : date.difference(post['time']).inMinutes < 60
            ? '${date.difference(post['time']).inMinutes} min'
            : date.difference(post['time']).inHours < 24
                ? '${date.difference(post['time']).inHours} h'
                : date.difference(post['time']).inDays < 30
                    ? '${date.difference(post['time']).inDays} days'
                    : DateFormat('dd MMM yyyy').format(post['time']).toString();

    return Scaffold(
      appBar: post['close']
          ? appPlusBar(context, 'Post details', Icon(Icons.close), () {
              showDialog(
                  context: context,
                  builder: (BuildContext buildContext) {
                    return YesNoWidget(
                        'Are you sure that you want to delete this post?', () {
                      deletePost();
                    });
                  }).whenComplete(() => Navigator.of(context).pop());
            })
          : appBar(context, 'Post details'),
      body: ListView(children: [
        ListTile(
          leading: Transform.translate(
            offset: Offset(0, post['tags'].isEmpty ? 0 : -10),
            child: GestureDetector(
                onTap: profileScreen,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: ImageWidget(post['photo'], 60, 60))),
          ),
          title: post['tags'].isEmpty
              ? GestureDetector(
                  onTap: profileScreen,
                  child: Text(post['name'],
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                )
              : RichText(
                  text: TextSpan(
                      text: post['name'],
                      recognizer: TapGestureRecognizer()..onTap = profileScreen,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                      TextSpan(
                          text: ' with ',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.8),
                          )),
                      for (var i = 0; i < post['tags'].length; i++)
                        if (i < post['tags'].length - 1) ...[
                          TextSpan(
                              text: "${post['tags'][i]['name']}, ",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .where('email',
                                          isEqualTo: post['tags'][i]['email'])
                                      .get()
                                      .then((value) {
                                    Provider.of<Friend>(context, listen: false)
                                        .setFriend(value.docs.first.data(),
                                            value.docs.first.id);
                                  });
                                  if (post['tags'][i]['email'] == email) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TabScreen(4)));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FriendProfileScreen()));
                                  }
                                },
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              )),
                        ] else ...[
                          TextSpan(
                              text: post['tags'][i]['name'],
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .where('email',
                                          isEqualTo: post['tags'][i]['email'])
                                      .get()
                                      .then((value) {
                                    Provider.of<Friend>(context, listen: false)
                                        .setFriend(value.docs.first.data(),
                                            value.docs.first.id);
                                  });
                                  if (post['tags'][i]['email'] == email) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TabScreen(4)));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FriendProfileScreen()));
                                  }
                                },
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.8),
                              )),
                        ]
                    ])),
          subtitle: Row(
            children: [
              RichText(
                text: TextSpan(
                    text: difference,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' . ',
                      )
                    ]),
              ),
              Icon(
                Icons.public,
                color: Theme.of(context).primaryColor.withOpacity(0.5),
              )
            ],
          ),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          post['message'] == ""
              ? SizedBox(
                  height: 5,
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                  child: ReadMoreText(
                    post['message'],
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    trimLines: 2,
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
          post['image'] != ""
              ? Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Center(
                      child: ImageWidget(
                          post['image'],
                          MediaQuery.of(context).size.height * 0.6,
                          MediaQuery.of(context).size.width)),
                )
              : Container(),
        ]),
        Padding(
          padding: const EdgeInsets.only(left: 25, top: 9, bottom: 80),
          child: Text(
            post['likes'] == 1
                ? '${post['likes']} Like'
                : '${post['likes']} Likes',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
        ),
      ]),
      bottomSheet: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: likeButton,
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: post['color'],
                      size: 30,
                    ),
                    Text(
                      ' Like',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 16),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: commentButton,
                child: Row(
                  children: [
                    Icon(
                      Icons.chat,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                    Text(
                      ' Comment',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 16),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  shareButton();
                },
                child: Row(
                  children: [
                    Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(pi),
                        child: Icon(
                          Icons.reply,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        )),
                    Text(
                      ' Share',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  profileScreen() {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(post['PostID'])
        .get()
        .then((value) {
      if (value['owner'] == email) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TabScreen(4)));
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: value['owner'])
            .get()
            .then((value) {
          Provider.of<Friend>(context, listen: false)
              .setFriend(value.docs.first.data(), value.docs.first.id);
        });

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => FriendProfileScreen()));
      }
    });
  }

  likeButton() {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(post['PostID'])
        .get()
        .then((value) {
      List list = value['likedBy'];
      if (list.contains(email)) {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(post['PostID'])
            .update({'likes': post['likes'] - 1});
        list.remove(email);
        FirebaseFirestore.instance
            .collection('posts')
            .doc(post['PostID'])
            .update({'likedBy': list});
        Provider.of<PostServices>(context, listen: false)
            .addPostLike(post['likes'] - 1);
      } else {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(post['PostID'])
            .update({'likes': post['likes'] + 1});
        list.add(email);
        FirebaseFirestore.instance
            .collection('posts')
            .doc(post['PostID'])
            .update({'likedBy': list});
        Provider.of<PostServices>(context, listen: false)
            .addPostLike(post['likes'] + 1);
      }
    });
    Provider.of<PostServices>(context, listen: false).changePostLikeColor(
        post['color'] == kred ? Theme.of(context).primaryColor : kred);
  }

  deletePost() {
    FirebaseFirestore.instance.collection("posts").doc(post['PostID']).delete();
    Navigator.of(context).pop();
  }

  commentButton() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: ((builder) => CommentBottomSheet(post['PostID'])));
  }

  shareButton() {
    shareBottomSheet();
  }

  shareBottomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(16), topLeft: Radius.circular(16)),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        context: context,
        builder: ((builder) => SizedBox(
              height: 230,
              child: Column(
                children: [
                  Divider(
                    indent: 150,
                    endIndent: 150,
                    thickness: 4,
                    color: Theme.of(context).primaryColor,
                    height: 50,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.edit_note,
                      size: 45,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      'Share',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    subtitle: Text(
                      'Share post but with your own thoughts',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(pi),
                        child: Icon(
                          Icons.reply,
                          size: 45,
                          color: Theme.of(context).primaryColor,
                        )),
                    title: Text(
                      'Repost',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    subtitle: Text(
                      "Instantly bring ${post['name']}'s post to your feeds",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}
