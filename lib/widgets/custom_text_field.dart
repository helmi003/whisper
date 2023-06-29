// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:whisper/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController control;
  final String label;
  CustomTextField(this.control, this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: TextFormField(
          controller: control,
          cursorColor: Theme.of(context).primaryColor,
          decoration: InputDecoration(
            fillColor: Theme.of(context).scaffoldBackgroundColor == kdarkBG
                ? kgreyish.withOpacity(0.2)
                : kwhite,
            filled: true,
            border: InputBorder.none,
            hintText: label,
            hintStyle: TextStyle(
                fontSize: 12, color: kdarkGrey, fontFamily: 'Poppins'),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Theme.of(context).scaffoldBackgroundColor == kdarkBG
                    ? kwhite
                    : Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Theme.of(context).scaffoldBackgroundColor == kdarkBG
                    ? kwhite
                    : Colors.transparent,
              ),
            ),
          ),
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: "Poppins")),
    );
  }
}
