// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

PreferredSizeWidget tabAppBar(BuildContext context, String text,IconData icon) {
  return AppBar(
    toolbarHeight: 80,
    backgroundColor: Theme.of(context).primaryColorDark,
    title: Text(
      text,
      style: TextStyle(
          fontFamily: "Poppins",
          color: Theme.of(context).primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.bold),
    ),
    leading: Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Icon(
        icon,
        color: Theme.of(context).primaryColor,
        size: 30,
      ),
    ),
    elevation: 0,
  );
}
