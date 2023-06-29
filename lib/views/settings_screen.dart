// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:whisper/screens/authentication/sign_in_screen.dart';
import 'package:whisper/screens/settings/about_screen.dart';
import 'package:whisper/screens/settings/change_password_screen.dart';
import 'package:whisper/screens/settings/contact_us_screen.dart';
import 'package:whisper/screens/settings/help_report_center_screen.dart';
import 'package:whisper/screens/settings/change_languages_screen.dart';
import 'package:whisper/service/user_service.dart';
import 'package:whisper/widgets/settings_content.dart';
import 'package:whisper/widgets/tab_app_bar.dart';
import '../screens/settings/dark_mode_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: tabAppBar(context, 'Settings', Icons.settings),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Column(
          children: [
            SettingsContent(Icons.language, 'Language', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LanguagesScreen()));
            }),
            SizedBox(height: 20),
            SettingsContent(Icons.dark_mode, 'Dark mode', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DarkModeScreen()));
            }),
            SizedBox(height: 20),
            SettingsContent(Icons.key, 'Change password', () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen()));
            }),
            SizedBox(height: 20),
            SettingsContent(Icons.contact_mail, 'Contact us', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ContactUsScreen()));
            }),
            SizedBox(height: 20),
            SettingsContent(Icons.support, 'Help & Report center', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HelpReportCenterScreen()));
            }),
            SizedBox(height: 20),
            SettingsContent(Icons.info, 'About', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutScreen()));
            }),
            SizedBox(height: 20),
            SettingsContent(Icons.logout, 'Log Out', () {
              UserService().signOut;
              Navigator.pushReplacementNamed(context, SignInScreen.routeName);
            }),
          ],
        ),
      )),
    );
  }
}
