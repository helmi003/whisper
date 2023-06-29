// ignore_for_file: prefer_const_constructors, prefer_final_fields, use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whisper/screens/authentication/forget_password_screen.dart';
import 'package:whisper/widgets/app_bar.dart';
import 'package:whisper/widgets/custom_button.dart';
import 'package:whisper/widgets/custom_password_widget.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/error_message.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late User user;

  @override
  void initState() {
    user = auth.currentUser!;
    super.initState();
  }

  TextEditingController _currentPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  String currentPasswordError = "";
  String newPasswordError = "";
  String confirmPasswordError = "";
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Change password'),
      body: ListView(children: [
        SizedBox(height: 20),
        SvgPicture.asset(
          'assets/images/change_password.svg',
          semanticsLabel: 'change_password',
          height: 185,
          width: 250,
        ),
        SizedBox(height: 26),
        CustomPassword(_currentPassword, 'Current password', true),
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 5, bottom: 5),
          child: Text(
            currentPasswordError,
            style: TextStyle(
              color: kred,
              fontSize: 12,
            ),
          ),
        ),
        CustomPassword(_newPassword, 'New password', true),
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 5, bottom: 5),
          child: Text(
            newPasswordError,
            style: TextStyle(
              color: kred,
              fontSize: 12,
            ),
          ),
        ),
        CustomPassword(_confirmPassword, 'Confirm password', true),
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 5, bottom: 5),
          child: Text(
            confirmPasswordError,
            style: TextStyle(
              color: kred,
              fontSize: 12,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
          child: Center(
            child: Text(
              'For security reasons, you must enter your old password first so we know you are not an impostor',
              style: TextStyle(
                  fontFamily: "Poppins", fontSize: 16, color: kdarkGrey),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        CustomButton(isLoading, 'Change password', () {
          changePassword();
        }),
        SizedBox(height: 17),
        Center(
          child: RichText(
            text: TextSpan(
                text: 'Forget password? ',
                children: [
                  TextSpan(
                    text: 'Recover',
                    style: TextStyle(color: kred, fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgetPasswordScreen()));
                      },
                  )
                ],
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                )),
          ),
        ),
        SizedBox(height: 25),
      ]),
    );
  }

  changePassword() async {
    if (_currentPassword.text.isEmpty) {
      setState(() {
        currentPasswordError = "This password is required";
        newPasswordError = "";
        confirmPasswordError = "";
      });
    } else if (_newPassword.text.isEmpty) {
      setState(() {
        currentPasswordError = "";
        newPasswordError = "This password is required";
        confirmPasswordError = "";
      });
    } else if (_confirmPassword.text.isEmpty) {
      setState(() {
        currentPasswordError = "";
        newPasswordError = "";
        confirmPasswordError = "This password is required";
      });
    } else if (_newPassword.text != _confirmPassword.text) {
      setState(() {
        currentPasswordError = "";
        newPasswordError = "";
        confirmPasswordError = "This password doesn't match the new password";
      });
    } else {
      setState(() {
        isLoading = true;
      });
      await auth
          .signInWithEmailAndPassword(
              email: user.email.toString(), password: _currentPassword.text)
          .then((value) {
        user.updatePassword(_confirmPassword.text).then((value) {
          setState(() {
            currentPasswordError = "";
            newPasswordError = "";
            confirmPasswordError = "";
          });
          setState(() {
            isLoading = false;
          });
          showDialog(
              context: context,
              builder: ((context) {
                return ErrorMessage(
                    'Success', 'Your password has been successfuly changed');
              })).whenComplete(() {
            Navigator.of(context).pop();
          });
        });
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        showDialog(
            context: context,
            builder: ((context) {
              return ErrorMessage(
                  'Error', "The old password you entered is invalid!");
            }));
      });
    }
  }
}
