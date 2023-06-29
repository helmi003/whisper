// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

PreferredSizeWidget appPlusBar(BuildContext context, String text,Icon icon,VoidCallback onPressed) {
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
    actions: <Widget>[
            IconButton(
              icon: icon,
              onPressed: onPressed,
              color: Theme.of(context).primaryColor,
            ),
          ],
    leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).primaryColor,
          size: 30,
        )),
    elevation: 0,
  );
}
