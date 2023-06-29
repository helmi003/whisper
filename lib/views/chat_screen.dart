// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:whisper/screens/chat/friend/add_friend_screen.dart';
import 'package:whisper/screens/chat/friend/friend_screen.dart';
import 'package:whisper/screens/chat/group/create_group_screen.dart';
import 'package:whisper/screens/chat/group/group_screen.dart';


class ChatScreen extends StatefulWidget {
  static const routeName = "/chat-screen";
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final items = ['Friends', 'Groups'];
  String val = "Friends";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 28),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 100,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                    icon: Icon(Icons.expand_more,
                        color: Theme.of(context).primaryColor),
                    items: items.map(builMenuItem).toList(),
                    value: val,
                    onChanged: (value) =>
                        setState(() => val = value as String)),
              ),
            ),
            IconButton(
                onPressed: () {
                  val == "Friends"
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddFriendScreen()))
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateGroupScreen()));
                },
                icon: Icon(Icons.add_circle_outline,
                    color: Theme.of(context).primaryColor))
          ],
        ),
      ),
      Container(child: val == 'Friends' ? FriendScreen() : GroupScreen())
    ]));
  }

  DropdownMenuItem<String> builMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              fontFamily: "Poppins",
              fontSize: 16),
        ),
      );
}
