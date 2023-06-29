// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  CustomButton(this.isLoading, this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25,right: 25),
      child: Container(
          height: 73,
          width: MediaQuery.of(context).size.width,
          decoration:
              BoxDecoration(color: kred, borderRadius: BorderRadius.circular(16)),
          child: TextButton(
            onPressed: onPressed,
            child: isLoading
                ? CircularProgressIndicator(
                    color: kwhite,
                  )
                : Text(
                    text,
                    style: TextStyle(
                        color: kwhite,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins"
                        ),
                  ),
          )),
    );
  }
}
