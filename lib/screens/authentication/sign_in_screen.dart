// ignore_for_file: prefer_final_fields, prefer_const_constructors, use_build_context_synchronously, use_key_in_widget_constructors

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whisper/views/tab_screen.dart';
import 'package:whisper/widgets/custom_button.dart';
import 'package:whisper/widgets/custom_password_widget.dart';
import 'package:whisper/widgets/custom_text_field.dart';
import 'package:whisper/screens/authentication/forget_password_screen.dart';
import 'package:whisper/screens/authentication/sign_up_screen.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/error_message.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = "/sign_in_screen";

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  String emailError = "";
  String passwordError = "";
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        SizedBox(height: 20),
        SvgPicture.asset(
          'assets/images/access_account.svg',
          height: 250,
          width: 250,
          semanticsLabel: 'access_account',
        ),
        SizedBox(height: 64),
        CustomTextField(_email, 'Email'),
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 5, bottom: 15),
          child: Text(
            emailError,
            style: TextStyle(
              color: kred,
              fontSize: 12,
            ),
          ),
        ),
        CustomPassword(_password, 'Password', true),
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 5, bottom: 15),
          child: Text(
            passwordError,
            style: TextStyle(
              color: kred,
              fontSize: 12,
            ),
          ),
        ),
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ForgetPasswordScreen()));
            },
            child: Text(
              'Forget password?',
              style:
                  TextStyle(fontFamily: "Poppins", fontSize: 16, color: kred),
            ),
          ),
        ),
        SizedBox(height: 25),
        CustomButton(isLoading, 'Log In', login),
        SizedBox(height: 17),
        Center(
          child: RichText(
            text: TextSpan(
                text: 'Already have an account? ',
                children: [
                  TextSpan(
                    text: 'Sign Up',
                    style: TextStyle(color: kred, fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()));
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

  login() async {
    try {
      if (_email.text.isEmpty) {
        setState(() {
          emailError = "This field is empty";
          passwordError = "";
        });
      } else if (!EmailValidator.validate(_email.text)) {
        setState(() {
          emailError = "This is an incorrect email";
          passwordError = "";
        });
      } else if (_password.text.isEmpty) {
        setState(() {
          passwordError = "This field is empty";
          emailError = "";
        });
      } else {
        setState(() {
          isLoading = true;
        });
        await _auth.signInWithEmailAndPassword(
            email: _email.text, password: _password.text);
        // UserService().setUserData;
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacementNamed(context, TabScreen.routeName);
      }
    } catch (e) {
      setState(() {
          isLoading = false;
        });
      showDialog(
          context: context,
          builder: (BuildContext buildContext) {
            return ErrorMessage('Error',"The email or password is badly formatted!");
          });
    }
  }
}
