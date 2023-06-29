// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:whisper/widgets/custom_button.dart';
import 'package:whisper/screens/authentication/sign_up_screen.dart';
import 'package:whisper/utils/colors.dart';

class GetStartedScreen extends StatelessWidget {
  static const routeName = "/gte-started-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        SizedBox(height: 20),
        Image.asset(
          'assets/images/logo.png',
          height: 203,
          width: 206,
        ),
        SizedBox(height: 55),
        Center(
          child: RichText(
              text: TextSpan(
                  text: 'Welcome to ',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                      color: Theme.of(context).primaryColor),
                  children: <TextSpan>[
                TextSpan(
                    text: 'Whisper',
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: kred))
              ])),
        ),
        SizedBox(height: 55),
        Padding(
          padding: const EdgeInsets.fromLTRB(29, 0, 29, 0),
          child: Text(
            'Whisper will simplify your communication with your friends',
            style: TextStyle(
                fontFamily: "Poppins", fontSize: 16, color: kdarkGrey),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 160),
        Padding(
          padding: const EdgeInsets.only(bottom: 66),
          child: CustomButton(false, 'Get Started', () {
            Navigator.pushReplacementNamed(context, SignUpScreen.routeName);
          }),
        )
      ]),
    );
  }
}
