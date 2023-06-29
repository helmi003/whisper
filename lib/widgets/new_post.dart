// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:whisper/views/profile_screen.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/screens/posts/add_post_screen.dart';
import 'package:whisper/widgets/image_widget.dart';

class NewPost extends StatelessWidget {
  final String photo;
  NewPost(this.photo);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Row(
        children: [
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: ImageWidget(photo, 60, 60))),
          SizedBox(width: 17),
          Expanded(
            child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddPostScreen()));
                },
                child: Container(
                  padding: EdgeInsets.only(left: 15, top: 17, bottom: 17),
                  decoration: BoxDecoration(
                      color:
                          Theme.of(context).scaffoldBackgroundColor == kdarkBG
                              ? kgreyish.withOpacity(0.2)
                              : kwhite,
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Text(
                    "What's on your mind?",
                    style: TextStyle(
                        fontFamily: "Poppins", fontSize: 12, color: kdarkGrey),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
