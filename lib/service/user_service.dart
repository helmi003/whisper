// ignore_for_file: file_names, avoid_print, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserService with ChangeNotifier {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Map<String, dynamic> extractedUserData = {};
  Map<String, dynamic> user = {};
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Future addUserData(String uid, String firstName, String lastName,
      String email, String gender) async {
    return await userCollection.doc(uid).set({
      "fullName": "$firstName $lastName",
      "email": email,
      "gender": gender,
      "profilePic": gender == 'male'
          ? 'https://cdn.discordapp.com/attachments/701544492448219257/1025761088844877865/male.png'
          : 'https://cdn.discordapp.com/attachments/701544492448219257/1025761088391884831/female.png',
      'bgPic':
          'https://img.freepik.com/free-vector/desert-landscape-with-road-night_107791-10148.jpg?w=1060&t=st=1664839522~exp=1664840122~hmac=19bd79bc9191ae6ca5edde560ef1b6424d76a0c40d810fab7e1b7f134b574aea',
      "birthday": DateTime.now(),
      "status": true,
      "statusTime": DateTime.now(),
      "bio": "",
      "socials": [],
      "title": "",
      "friends": 0
    });
  }

  UserData(String uid) async {
    return userCollection.doc(uid).get();
  }

  // setUserData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await userCollection
  //       .doc(uid)
  //       .get()
  //       .then((value) => user = value.data() as Map<String, dynamic>);
  //   final extractedUserData = json.encode(user);
  //   prefs.setString('user', extractedUserData);
  //   notifyListeners();
  // }

  // getUserData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (prefs.containsKey('user')) {
  //     extractedUserData = json.decode(prefs.getString('user').toString())
  //         as Map<String, dynamic>;
  //     user = extractedUserData;
  //     notifyListeners();
  //   }
  // }

  updateUser(
    String uid,
    String fullName,
    String bio,
    String profilePic,
    String bgPic,
    DateTime birthday,
    String title,
  ) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({
      'fullName': fullName,
      'bio': bio,
      'profilePic': profilePic,
      'bgPic': bgPic,
      'birthday': birthday,
      'title': title
    }).catchError((e) {
      print(e);
    });
  }

  signOut() async {
    await auth.signOut();
  }
}
