// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:whisper/utils/colors.dart';

class SettingsContent extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback OnPressed;
  const SettingsContent(this.icon, this.text, this.OnPressed);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: OnPressed,
      child: Container(
        decoration: BoxDecoration(
            color: kgreyish, borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
          child: Row(
            children: [
              Icon(icon, size: 24.2, color: kdark),
              SizedBox(width: 20),
              Text(text,
                  style: TextStyle(
                      color: kdark,
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }
}
