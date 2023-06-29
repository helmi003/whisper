// ignore_for_file: prefer_const_constructors, prefer_final_fields, use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whisper/widgets/custom_button.dart';
import 'package:whisper/widgets/custom_text_field.dart';
import 'package:whisper/utils/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:whisper/widgets/error_message.dart';
import 'sign_in_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController _email = TextEditingController();
  String emailError = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        SizedBox(height: 20),
        SvgPicture.asset(
          'assets/images/forgot_password.svg',
          semanticsLabel: 'forgot_password',
          height: 183,
          width: 285,
        ),
        SizedBox(height: 67),
        CustomTextField(_email, 'Email'),
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 5, bottom: 30),
          child: Text(
            emailError,
            style: TextStyle(
              color: kred,
              fontSize: 12,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(29, 0, 29, 0),
          child: Text(
            AppLocalizations.of(context)!.afterEnteringYourEmail,
            style: TextStyle(
                fontFamily: "Poppins", fontSize: 16, color: kdarkGrey),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 120),
        CustomButton(false, AppLocalizations.of(context)!.recover, () {
          passwordRecovery();
        }),
        SizedBox(height: 17),
        Center(
          child: RichText(
            text: TextSpan(
                text: '${AppLocalizations.of(context)!.youRememberedyouraccount} ',
                children: [
                  TextSpan(
                    text: AppLocalizations.of(context)!.signIn,
                    style: TextStyle(color: kred, fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()));
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

  passwordRecovery() {
    if (_email.text.isEmpty) {
      setState(() {
        emailError = AppLocalizations.of(context)!.theemailisnprovided;
      });
    } else if (!EmailValidator.validate(_email.text)) {
      setState(() {
        emailError = AppLocalizations.of(context)!.thisisanincorrectemail;
      });
    } else {
      setState(() {
        isLoading = true;
      });
      FirebaseAuth.instance
          .sendPasswordResetEmail(email: _email.text)
          .then((value) {
        setState(() {
          emailError = "";
        });
        setState(() {
          isLoading = false;
        });
        showDialog(
            context: context,
            builder: ((context) {
              return ErrorMessage(AppLocalizations.of(context)!.success,
                  AppLocalizations.of(context)!.emailhasbeensenttoyouremail);
            })).whenComplete(() {
          Navigator.of(context).pop();
        });
      }).catchError((error) {
        setState(() {
          emailError = AppLocalizations.of(context)!.thereisnousercorrespondingtothisemail;
        });
      });
    }
  }
}
