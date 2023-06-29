// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:whisper/utils/colors.dart';

class YesNoWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  YesNoWidget(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      title: Text('Alert',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: kred,
            fontWeight: FontWeight.bold,
          )),
      content: Text(text,
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor)),
      actions: <Widget>[
        TextButton(onPressed: () {
          Navigator.of(context).pop();
        }, child: Text('No')),
        TextButton(onPressed: onPressed, child: Text('Yes'))
      ],
    );
  }
}
