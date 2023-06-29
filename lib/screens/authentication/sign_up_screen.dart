// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_final_fields, unused_field, use_build_context_synchronously, use_key_in_widget_constructors

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:whisper/service/user_service.dart';
import 'package:whisper/widgets/custom_button.dart';
import 'package:whisper/widgets/custom_password_widget.dart';
import 'package:whisper/widgets/custom_text_field.dart';
import 'package:whisper/screens/authentication/sign_in_screen.dart';
import 'package:whisper/screens/starting/slider_screen.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/error_message.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = "/sign_up_screen";
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

enum SingingCharacter { male, female }

class _SignUpScreenState extends State<SignUpScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  SingingCharacter? _character = SingingCharacter.male;
  TextEditingController _FirstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  String? gender;
  bool isLoading = false;
  String lastNameError = "";
  String firstNameError = "";
  String emailError = "";
  String passwordError = "";
  String confirmPasswordError = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        SizedBox(height: 20),
        Center(
          child: Text(
            'Welcome on board!',
            style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: 39),
        CustomTextField(_FirstName, 'First name'),
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 5, bottom: 15),
          child: Text(
            firstNameError,
            style: TextStyle(
              color: kred,
              fontSize: 12,
            ),
          ),
        ),
        CustomTextField(_lastName, 'Last name'),
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 5, bottom: 15),
          child: Text(
            lastNameError,
            style: TextStyle(
              color: kred,
              fontSize: 12,
            ),
          ),
        ),
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
        CustomPassword(_confirmPassword, 'Confirm password', true),
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 5, bottom: 15),
          child: Text(
            confirmPasswordError,
            style: TextStyle(
              color: kred,
              fontSize: 12,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Text('Gender:',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor)),
        ),
        SelectRadioButton(),
        SizedBox(height: 25),
        CustomButton(isLoading, 'Register', register),
        SizedBox(height: 17),
        Center(
          child: RichText(
            text: TextSpan(
                text: 'Already have an account? ',
                children: [
                  TextSpan(
                    text: 'Sign In',
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

  Widget SelectRadioButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: ListTile(
            title: Text('Male',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor)),
            leading: Radio<SingingCharacter>(
              fillColor: MaterialStateColor.resolveWith((states) => kred),
              value: SingingCharacter.male,
              groupValue: _character,
              onChanged: (SingingCharacter? value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Text('Female',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor)),
            leading: Radio<SingingCharacter>(
              fillColor: MaterialStateColor.resolveWith((states) => kred),
              value: SingingCharacter.female,
              groupValue: _character,
              onChanged: (SingingCharacter? value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  register() async {
    try {
      if (_FirstName.text.isEmpty) {
        setState(() {
          firstNameError = "This field is empty";
          lastNameError = "";
          emailError = "";
          passwordError = "";
          confirmPasswordError = "";
        });
      } else if (_lastName.text.isEmpty) {
        setState(() {
          lastNameError = "This field is empty";
          firstNameError = "";
          emailError = "";
          passwordError = "";
          confirmPasswordError = "";
        });
      } else if (_email.text.isEmpty) {
        setState(() {
          emailError = "This field is empty";
          firstNameError = "";
          lastNameError = "";
          passwordError = "";
          confirmPasswordError = "";
        });
      } else if (!EmailValidator.validate(_email.text)) {
        setState(() {
          emailError = "This is an incorrect email";
          firstNameError = "";
          lastNameError = "";
          passwordError = "";
          confirmPasswordError = "";
        });
      } else if (_password.text.isEmpty) {
        setState(() {
          passwordError = "This field is empty";
          firstNameError = "";
          lastNameError = "";
          emailError = "";
          confirmPasswordError = "";
        });
      } else if (_confirmPassword.text.isEmpty) {
        setState(() {
          confirmPasswordError = "This field is empty";
          firstNameError = "";
          lastNameError = "";
          emailError = "";
          passwordError = "";
        });
      } else if (_password.text != _confirmPassword.text) {
        setState(() {
          confirmPasswordError = "password should match";
          firstNameError = "";
          lastNameError = "";
          emailError = "";
          passwordError = "";
        });
      } else {
        setState(() {
          isLoading = true;
        });
        await _auth.createUserWithEmailAndPassword(
            email: _email.text, password: _password.text);
        gender = _character!.name;
        String uid = FirebaseAuth.instance.currentUser!.uid;
        await UserService().addUserData(uid, _FirstName.text, _lastName.text,
            _email.text, gender.toString());
        // UserService().setUserData;
        Navigator.pushReplacementNamed(context, SliderScreen.routeName);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
          isLoading = false;
        });
      showDialog(
          context: context,
          builder: (BuildContext buildContext) {
            return ErrorMessage('Error',
                "This email is already in use by another account!");
          });
    }
  }
}
