// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:whisper/utils/colors.dart';

class BottomSheetCamera extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback onPressed2;
  BottomSheetCamera(this.onPressed,this.onPressed2);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text("Choose your photo:",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.camera_alt,
                    color: kred,
                  ),
                  label: Text("Camera",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor))),
              TextButton.icon(
                  onPressed: onPressed2,
                  icon: Icon(
                    Icons.image,
                    color: kred,
                  ),
                  label: Text("Gallery",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor))),
            ],
          )
        ],
      ),
    );
  }
}
