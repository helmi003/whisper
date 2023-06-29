// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:whisper/utils/colors.dart';

class CustomTextArea extends StatelessWidget {
  final TextEditingController control;
  final String label;
  CustomTextArea(this.control, this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: TextFormField(
        maxLength: 500,
              controller: control,
              cursorColor: Theme.of(context).primaryColor,
              minLines: 6,
              keyboardType: TextInputType.multiline,
              maxLines: null,
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
                  fontSize: 14,
                  fontFamily: "Poppins")));
  }
}
