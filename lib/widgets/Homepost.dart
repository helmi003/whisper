// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, file_names, non_constant_identifier_names

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:whisper/screens/profile/friend_profile_screen.dart';
import 'package:whisper/views/tab_screen.dart';
import 'package:whisper/service/friend_service.dart';
import 'package:whisper/service/posts_services.dart';
import 'package:whisper/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:whisper/widgets/comment_section.dart';
import 'package:whisper/widgets/custom_text_field.dart';
import 'package:whisper/widgets/image_widget.dart';
import 'package:whisper/screens/posts/post_screen.dart';
import 'package:whisper/widgets/yes_no_widget.dart';

class HomePosts extends StatefulWidget {
  final String PostID;
  final Map<String, dynamic> shared;
  final String photo;
  final String name;
  final List tags;
  final DateTime time;
  final String message;
  final String image;
  final int likes;
  final Color color;
  final bool close;
  final VoidCallback profileButton;

  HomePosts(
      this.PostID,
      this.shared,
      this.photo,
      this.name,
      this.tags,
      this.time,
      this.message,
      this.image,
      this.likes,
      this.color,
      this.close,
      this.profileButton);

  @override
  State<HomePosts> createState() => _HomePostsState();
}

class _HomePostsState extends State<HomePosts> {
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  TextEditingController share = TextEditingController();
  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();
    final difference = date.difference(widget.time).inSeconds < 60
        ? '${date.difference(widget.time).inSeconds} sec'
        : date.difference(widget.time).inMinutes < 60
            ? '${date.difference(widget.time).inMinutes} min'
            : date.difference(widget.time).inHours < 24
                ? '${date.difference(widget.time).inHours} h'
                : date.difference(widget.time).inDays < 30
                    ? '${date.difference(widget.time).inDays} days'
                    : DateFormat('dd MMM yyyy').format(widget.time).toString();
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
      child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor == kdarkBG
                  ? kgreyish.withOpacity(0.2)
                  : kgreyish,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            widget.shared.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: GestureDetector(
                            onTap: () async {
                              if (widget.shared['email'] == email) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TabScreen(4)));
                              } else {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .where('email',
                                        isEqualTo: widget.shared['email'])
                                    .get()
                                    .then((value) {
                                  Provider.of<Friend>(context, listen: false)
                                      .setFriend(value.docs.first.data(),
                                          value.docs.first.id);
                                }).whenComplete(() => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FriendProfileScreen())));
                              }
                            },
                            child: RichText(
                                text: TextSpan(
                                    text: "${widget.shared['name']} ",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: "Poppins",
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    children: [
                                  TextSpan(
                                      text: "Shared this post",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.8),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500))
                                ])),
                          ),
                        ),
                        widget.shared['message'] == ""
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: ReadMoreText(
                                  "${widget.shared['message']}",
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
                        Divider(
                          endIndent: 18,
                          indent: 18,
                          thickness: 1,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(height: 12)
                      ])
                : SizedBox(height: 12),
            ListTile(
                leading: Transform.translate(
                  offset: Offset(0, widget.tags.isEmpty ? 0 : -10),
                  child: GestureDetector(
                      onTap: widget.profileButton,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: ImageWidget(widget.photo, 60, 60))),
                ),
                title: widget.tags.isEmpty
                    ? GestureDetector(
                        onTap: widget.profileButton,
                        child: Text(widget.name,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontFamily: "Poppins",
                                fontSize: 16,
                                fontWeight: FontWeight.bold)))
                    : RichText(
                        text: TextSpan(
                            text: widget.name,
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.profileButton,
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
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.8),
                                )),
                            for (var i = 0; i < widget.tags.length; i++)
                              if (i < widget.tags.length - 1) ...[
                                TextSpan(
                                    text: "${widget.tags[i]['name']}, ",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .where('email',
                                                isEqualTo: widget.tags[i]
                                                    ['email'])
                                            .get()
                                            .then((value) {
                                          Provider.of<Friend>(context,
                                                  listen: false)
                                              .setFriend(
                                                  value.docs.first.data(),
                                                  value.docs.first.id);
                                        });
                                        if (widget.tags[i]['email'] == email) {
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
                                    text: widget.tags[i]['name'],
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .where('email',
                                                isEqualTo: widget.tags[i]
                                                    ['email'])
                                            .get()
                                            .then((value) {
                                          Provider.of<Friend>(context,
                                                  listen: false)
                                              .setFriend(
                                                  value.docs.first.data(),
                                                  value.docs.first.id);
                                        });
                                        if (widget.tags[i]['email'] == email) {
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
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.8),
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
                trailing: widget.close
                    ? Container(
                        constraints: const BoxConstraints(maxWidth: 25),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext buildContext) {
                                  return YesNoWidget(
                                      'Are you sure that you want to delete this post?',
                                      () {
                                    deletePost();
                                  });
                                });
                          },
                          child: Icon(Icons.close,
                              color: Theme.of(context).primaryColor),
                        ),
                      )
                    : null),
            GestureDetector(
              onTap: () {
                Provider.of<PostServices>(context, listen: false).setPost(
                    widget.PostID,
                    widget.photo,
                    widget.name,
                    widget.tags,
                    widget.time,
                    widget.message,
                    widget.image,
                    widget.likes,
                    widget.color,
                    widget.close);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PostScreen()));
              },
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.message == ""
                        ? SizedBox(
                            height: 5,
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(39, 5, 39, 5),
                            child: ReadMoreText(
                              widget.message,
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
                    widget.image != ""
                        ? Center(child: ImageWidget(widget.image, 180, 240))
                        : Container(),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 39, top: 9, bottom: 11),
              child: Text(
                widget.likes == 1
                    ? '${widget.likes} Like'
                    : '${widget.likes} Likes',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 39, right: 39, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: likeButton,
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: widget.color,
                        ),
                        Text(
                          ' Like',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12),
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
                        ),
                        Text(
                          ' Comment',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      shareBottomSheet();
                    },
                    child: Row(
                      children: [
                        Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(pi),
                            child: Icon(
                              Icons.reply,
                              color: Theme.of(context).primaryColor,
                            )),
                        Text(
                          ' Share',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ])),
    );
  }

  likeButton() {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.PostID)
        .get()
        .then((value) {
      List list = value['likedBy'];
      if (list.contains(email)) {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.PostID)
            .update({'likes': widget.likes - 1});
        list.remove(email);
        FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.PostID)
            .update({'likedBy': list});
      } else {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.PostID)
            .update({'likes': widget.likes + 1});
        list.add(email);
        FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.PostID)
            .update({'likedBy': list});
      }
    });
  }

  deletePost() {
    FirebaseFirestore.instance.collection("posts").doc(widget.PostID).delete();
    Navigator.of(context).pop();
  }

  commentButton() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: ((builder) => CommentBottomSheet(widget.PostID)));
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
                    onTap: (){
                      shareButton();
                    },
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
                      "Instantly bring ${widget.name}'s post to your feeds",
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

  shareButton() {
    showModalBottomSheet(
        context: context,
        builder: ((context) {
          return Padding(
              padding: EdgeInsets.all(10),
              child: CustomTextField(share, 'Write something...'));
        }));
  }
}
