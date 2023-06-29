// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisper/screens/chat/friend/chat_messages_screen.dart';
import 'package:whisper/service/friend_service.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/custom_listtile.dart';

class FriendScreen extends StatefulWidget {
  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  TextEditingController searchbtn = TextEditingController();
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  String uid = FirebaseAuth.instance.currentUser!.uid;

  String query = '';
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      searchwidget(),
      SizedBox(height: 33),
      StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .collection("friends")
              .where('request',isEqualTo: "accepted")
              .snapshots(),
          builder: ((context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child:
                      CircularProgressIndicator(color: kred.withOpacity(0.8)));
            } else if (snapshot.hasError) {
              return Center(
                child: Text('There was an error while fetching the data',
                    style: TextStyle(
                        color: kred, fontFamily: 'Poppins', fontSize: 14)),
              );
            }  else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text("You don't have friends yet",
                    style: TextStyle(
                        color: kred, fontFamily: 'Poppins', fontSize: 14)),
              );
            }
            return ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  ...snapshot.data!.docs
                      .map((QueryDocumentSnapshot<Object?> data) {
                    final String userEmail = data["email"];
                    return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .where('email', isEqualTo: userEmail)
                            .get(),
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
                          } else if (query.isEmpty ||
                              snapshot.data!.docs.first['fullName']
                                  .toString()
                                  .toLowerCase()
                                  .contains(query.toLowerCase())) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 25, bottom: 17),
                              child: CustomListTile(
                                  snapshot.data!.docs.first['fullName'],
                                  snapshot.data!.docs.first['title'],
                                  snapshot.data!.docs.first['profilePic'], () {
                                Provider.of<Friend>(context, listen: false)
                                    .setFriend(
                                        snapshot.data!.docs.first.data(),snapshot.data!.docs.first.id);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChatMessagesScreen()));
                              }, snapshot.data!.docs.first['status'],
                                  Icons.send),
                            );
                          }
                          return Center(
                            child: Text(
                                "There is no user with this name '$query'",
                                style: TextStyle(
                                    color: kred,
                                    fontFamily: 'Poppins',
                                    fontSize: 14)),
                          );
                        }));
                  })
                ]);
          })),
    ]);
  }

  searchwidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: TextField(
          cursorColor: Theme.of(context).scaffoldBackgroundColor == kdarkBG
              ? kwhite
              : kdark,
          onChanged: (val) {
            setState(() {
              query = val;
            });
          },
          controller: searchbtn,
          style: TextStyle(
              color: Theme.of(context).scaffoldBackgroundColor == kdarkBG
                  ? kwhite
                  : kdark,
              fontSize: 16,
              fontFamily: "Poppins"),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            fillColor: Theme.of(context).scaffoldBackgroundColor == kdarkBG
              ? kgreyish.withOpacity(0.2)
              : kwhite,
            hintStyle: TextStyle(
                fontSize: 12, color: kdarkGrey, fontFamily: 'Poppins'),
            hintText: "Search...",
            prefixIcon: Icon(Icons.search, color: kdarkGrey),
            suffixIcon: searchbtn.text.isNotEmpty
                ? GestureDetector(
                    child: Icon(Icons.close, color: kred),
                    onTap: () {
                      searchbtn.clear();
                      setState(() {
                        query = '';
                      });
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  )
                : null,
            filled: true,
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: kwhite,
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(color: kwhite)),
          )),
    );
  }
}
