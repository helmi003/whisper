// ignore_for_file: prefer_const_constructors, prefer_const_declarations, unnecessary_null_comparison, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:whisper/screens/profile/friend_profile_screen.dart';
import 'package:whisper/service/friend_service.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/app_bar.dart';
import 'package:whisper/widgets/custom_button2.dart';
import 'package:whisper/widgets/image_widget.dart';

class FriendMessagesProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> friend = Provider.of<Friend>(context).friend;
    return Scaffold(
        appBar: appBar(context, 'Friend info'),
        body: ListView(children: [
          SizedBox(
            height: 244,
            child: Stack(
              children: [
                ImageWidget(
                    friend['bgPic'], 145, MediaQuery.of(context).size.width),
                Positioned.fill(
                    child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(120),
                      child: ImageWidget(friend['profilePic'], 120, 120)),
                )),
              ],
            ),
          ),
          SizedBox(height: 7),
          Center(
              child: Text(
            friend['fullName'],
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 16),
          )),
          SizedBox(height: 7),
          Center(
              child: Text(
            DateFormat('dd/MM/yyyy').format(friend['birthday'].toDate()),
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14),
          )),
          SizedBox(height: 7),
          Center(
              child: Text(
            friend['title'],
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14),
          )),
          SizedBox(height: 7),
          Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Center(
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
              )),
          SizedBox(height: 30),
          Center(
            child: CustomButton2(false, 'View profile', () {
              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FriendProfileScreen()));
            }),
          ),
          SizedBox(height: 20),
        ]));
  }
}
