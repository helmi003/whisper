// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/app_bar.dart';

class DarkModeScreen extends StatefulWidget {
  @override
  _DarkModeScreenState createState() => _DarkModeScreenState();
}

class _DarkModeScreenState extends State<DarkModeScreen> {
  bool darkmode = true;
  dynamic savedThemeMode;

  @override
  void initState() {
    super.initState();
    getCurrentTheme();
  }

  Future getCurrentTheme() async {
    savedThemeMode = await AdaptiveTheme.getThemeMode();
    if (savedThemeMode.toString() == 'AdaptiveThemeMode.dark') {
      setState(() {
        darkmode = true;
      });
    } else {
      setState(() {
        darkmode = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Change theme color'),
      body: SwitchListTile(
        title: Text(darkmode ? 'Dark mode' : 'Light mode',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: "Poppins",
                fontSize: 14,
                fontWeight: FontWeight.bold)),
        activeColor: kred,
        secondary: darkmode
            ? Icon(Icons.nightlight_round,
                color: Theme.of(context).primaryColor)
            : Icon(Icons.light_mode, color: Theme.of(context).primaryColor),
        value: darkmode,
        onChanged: (bool value) {
          if (value == true) {
            AdaptiveTheme.of(context).setDark();
          } else {
            AdaptiveTheme.of(context).setLight();
          }
          setState(() {
            darkmode = value;
          });
        },
      ),
    );
  }
}
