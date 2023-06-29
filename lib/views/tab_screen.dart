// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whisper/views/chat_screen.dart';
import 'package:whisper/views/settings_screen.dart';
import 'package:whisper/utils/colors.dart';
import 'home_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class TabScreen extends StatefulWidget {
  int _selectedIndex;
  TabScreen(this._selectedIndex);
  static const routeName = "/tab-screen";
  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _screens = [
    HomeScreen(),
    NotificationScreen(),
    ChatScreen(),
    SettingsScreen(),
    ProfileScreen(),
  ];
  // int _selectedIndex = 0;

  void _selectIndex(int index) {
    setState(() {
      widget._selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void setStatus(bool status) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .update({"status": status, "statusTime": DateTime.now()});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus(true);
    } else {
      setStatus(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
            length: 4,
            child: Scaffold(
                body: IndexedStack(
                  index: widget._selectedIndex,
                  children: _screens,
                ),
                bottomNavigationBar: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16),
                  ),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: kred,
                    unselectedItemColor: kwhite,
                    onTap: _selectIndex,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          icon: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: widget._selectedIndex == 0
                                  ? Icon(Icons.home, color: kyellow)
                                  : Icon(Icons.home, color: kwhite)),
                          label: ''),
                      BottomNavigationBarItem(
                          icon: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: widget._selectedIndex == 1
                                  ? Icon(Icons.notifications, color: kyellow)
                                  : Icon(Icons.notifications, color: kwhite)),
                          label: ''),
                      BottomNavigationBarItem(
                          icon: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: widget._selectedIndex == 2
                                  ? Icon(Icons.chat, color: kyellow)
                                  : Icon(Icons.chat, color: kwhite)),
                          label: ''),
                      BottomNavigationBarItem(
                          icon: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: widget._selectedIndex == 3
                                  ? Icon(Icons.settings, color: kyellow)
                                  : Icon(Icons.settings, color: kwhite)),
                          label: ''),
                      BottomNavigationBarItem(
                          icon: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: widget._selectedIndex == 4
                                  ? Icon(Icons.person, color: kyellow)
                                  : Icon(Icons.person, color: kwhite)),
                          label: '')
                    ],
                    currentIndex: widget._selectedIndex,
                    selectedItemColor: kyellow,
                  ),
                ))));
  }
}
