// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:whisper/utils/colors.dart';

class CustomPassword extends StatefulWidget {
  final TextEditingController control;
  final String label;
  bool obscureText;

  CustomPassword(this.control, this.label, this.obscureText);

  @override
  State<CustomPassword> createState() => _CustomPasswordState();
}

class _CustomPasswordState extends State<CustomPassword> {
  void _toggle() {
    setState(() {
      widget.obscureText = !widget.obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: TextFormField(
          controller: widget.control,
          cursorColor: Theme.of(context).primaryColor,
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            fillColor: Theme.of(context).scaffoldBackgroundColor == kdarkBG
                ? kgreyish.withOpacity(0.2)
                : kwhite,
            filled: true,
            border: InputBorder.none,
            hintText: widget.label,
            suffix: InkWell(
                onTap: _toggle,
                child: Icon(widget.obscureText
                    ? Icons.visibility_off
                    : Icons.visibility,color: Theme.of(context).primaryColor,)),
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
