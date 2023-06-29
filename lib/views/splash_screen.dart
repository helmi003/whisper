// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whisper/screens/authentication/sign_in_screen.dart';
import 'package:whisper/screens/starting/get_Started_screen.dart';
import 'package:whisper/views/tab_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  bool isloggedin = false;

  // checkAuthentification() async {
  //   _auth.authStateChanges().listen((user) {
  //     if (user == null) {
  //       Navigator.pushReplacementNamed(context, GetStartedScreen.routeName);
  //     }
  //   });
  // }

  getUser() async {
    User? firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    if (!mounted) return;
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      if (!mounted) return;
      setState(() {
        user = firebaseUser!;
        isloggedin = true;
      });
    }
  }

  @override
  void initState() {
    getUser();
    // checkAuthentification();
    Future.delayed(const Duration(seconds: 2), () async {
      try {
        if (isloggedin) {
          // await context.read<UserService>().getUserData();
          // Provider.of<UserService>(context, listen: false).getUserData();
          Navigator.pushReplacementNamed(context, TabScreen.routeName);
        } else {
          Navigator.pushReplacementNamed(context, SignInScreen.routeName);
        }
      } catch (e) {
        print(e.toString());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Image.asset(
        'assets/images/splash_screen.png',
        height: 273,
        width: 278,
      )),
    );
  }
}
