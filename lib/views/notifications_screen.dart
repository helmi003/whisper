// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:whisper/screens/notification/notifcation_friends_screen.dart';
import 'package:whisper/utils/colors.dart';

import '../screens/notification/notifcation_posts_screen.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).primaryColorDark,
        elevation: 0,
        bottom: TabBar(
          labelColor:Theme.of(context).primaryColor,
          unselectedLabelColor:Theme.of(context).primaryColor.withOpacity(0.6),
          indicatorWeight:4,
          indicatorColor:kred,
          controller: _controller,
          tabs: [
            Tab(
                child: Text('Posts',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold))),
            Tab(
                child: Text('Friends',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold))),
          ],
        ),
      ),
      body: TabBarView(controller: _controller, children: [
        NotifcationPostsScreen(),
        NotifcationFriendsScreen(),
      ]),
    );
  }
}
