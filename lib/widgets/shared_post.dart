// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, file_names

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
import 'package:whisper/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:whisper/widgets/image_widget.dart';

class SharedPost extends StatelessWidget {
  final String photo;
  final String name;
  final List tags;
  final DateTime time;
  final String message;
  final String image;
  final int likes;
  final Color color;
  final bool close;
  final VoidCallback closeButton;
  final VoidCallback profileButton;
  final VoidCallback likeButton;
  final VoidCallback commentButton;
  final VoidCallback shareButton;

  SharedPost(
      this.photo,
      this.name,
      this.tags,
      this.time,
      this.message,
      this.image,
      this.likes,
      this.color,
      this.close,
      this.closeButton,
      this.profileButton,
      this.likeButton,
      this.commentButton,
      this.shareButton);

  @override
  Widget build(BuildContext context) {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    DateTime date = DateTime.now();
    final difference = date.difference(time).inSeconds < 60
        ? '${date.difference(time).inSeconds} sec'
        : date.difference(time).inMinutes < 60
            ? '${date.difference(time).inMinutes} min'
            : date.difference(time).inHours < 24
                ? '${date.difference(time).inHours} h'
                : date.difference(time).inDays < 30
                    ? '${date.difference(time).inDays} days'
                    : DateFormat('dd MMM yyyy').format(time).toString();
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
      child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor == kdarkBG
                  ? kgreyish.withOpacity(0.2)
                  : kgreyish,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                ListTile(
                    leading: Transform.translate(
                      offset: Offset(0, tags.isEmpty ? 0 : -10),
                      child: GestureDetector(
                          onTap: profileButton,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: ImageWidget(photo, 60, 60))),
                    ),
                    title: tags.isEmpty
                        ? Text(name,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontFamily: "Poppins",
                                fontSize: 16,
                                fontWeight: FontWeight.bold))
                        : RichText(
                            text: TextSpan(
                                text: name,
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
                                for (var i = 0; i < tags.length; i++)
                                  if (i < tags.length - 1) ...[
                                    TextSpan(
                                        text: "${tags[i]['name']}, ",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .where('email',
                                                    isEqualTo: tags[i]['email'])
                                                .get()
                                                .then((value) {
                                              Provider.of<Friend>(context,
                                                      listen: false)
                                                  .setFriend(
                                                      value.docs.first.data(),
                                                      value.docs.first.id);
                                            });
                                            if (tags[i]['email'] == email) {
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
                                        text: tags[i]['name'],
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .where('email',
                                                    isEqualTo: tags[i]['email'])
                                                .get()
                                                .then((value) {
                                              Provider.of<Friend>(context,
                                                      listen: false)
                                                  .setFriend(
                                                      value.docs.first.data(),
                                                      value.docs.first.id);
                                            });
                                            if (tags[i]['email'] == email) {
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
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                        )
                      ],
                    ),
                    trailing: close
                        ? Container(
                            constraints: const BoxConstraints(maxWidth: 25),
                            child: Transform.translate(
                                offset: Offset(0, -30),
                                child: IconButton(
                                  onPressed: closeButton,
                                  icon: Icon(Icons.close,
                                      // size: 25,
                                      color: Theme.of(context).primaryColor),
                                )),
                          )
                        : null),
                Padding(
                  padding: const EdgeInsets.fromLTRB(39, 10, 39, 10),
                  child: ReadMoreText(
                    message,
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
                image != ""
                    ? Center(child: ImageWidget(image, 180, 240))
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(left: 39, top: 9),
                  child: Text(
                    likes == 1 ? '$likes Like' : '$likes Likes',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 11),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 39, right: 39, bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: likeButton,
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: color,
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
                        onTap: shareButton,
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
}
