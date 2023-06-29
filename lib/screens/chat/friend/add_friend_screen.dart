// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisper/screens/profile/friend_profile_screen.dart';
import 'package:whisper/service/friend_service.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/app_bar.dart';
import 'package:whisper/widgets/custom_listtile2.dart';
import 'package:whisper/widgets/yes_no_widget.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  TextEditingController searchbtn = TextEditingController();
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String query = '';
  bool refreshPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context, 'Add new friend'),
        body: refreshPage
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : ListView(children: [
                SizedBox(height: 20),
                searchwidget(),
                SizedBox(height: 33),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .where('email', isNotEqualTo: email)
                        .snapshots(),
                    builder: ((context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: CircularProgressIndicator(
                                color: kred.withOpacity(0.8)));
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                              'There was an error while fetching the data',
                              style: TextStyle(
                                  color: kred,
                                  fontFamily: 'Poppins',
                                  fontSize: 14)),
                        );
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text("There is no users yet",
                              style: TextStyle(
                                  color: kred,
                                  fontFamily: 'Poppins',
                                  fontSize: 14)),
                        );
                      }
                      return ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            ...snapshot.data!.docs.map((data) {
                              final String userEmail = data["email"];
                              return FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(uid)
                                      .collection("friends")
                                      .get(),
                                  builder: ((context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                          child: CircularProgressIndicator(
                                              color: kred.withOpacity(0.8)));
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                            'There was an error while fetching the data',
                                            style: TextStyle(
                                                color: kred,
                                                fontFamily: 'Poppins',
                                                fontSize: 14)),
                                      );
                                    } else if (snapshot.data!.docs
                                        .where((QueryDocumentSnapshot<Object?>
                                                element) =>
                                            element['email']
                                                .toString()
                                                .contains(userEmail) &&
                                            element['request']
                                                .toString()
                                                .contains("accepted"))
                                        .isNotEmpty) {
                                      return Container();
                                    } else if (query.isEmpty ||
                                        data['fullName']
                                            .toString()
                                            .toLowerCase()
                                            .contains(query.toLowerCase())) {
                                      if (snapshot.data!.docs
                                          .where((QueryDocumentSnapshot<Object?>
                                                  element) =>
                                              element['email']
                                                  .toString()
                                                  .contains(userEmail) &&
                                              element['request']
                                                  .toString()
                                                  .contains("requested"))
                                          .isNotEmpty) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 25, bottom: 17),
                                          child: CustomListTile2(
                                              data['fullName'],
                                              data['title'],
                                              data['profilePic'],
                                              () {
                                                Provider.of<Friend>(context,
                                                        listen: false)
                                                    .setFriend(data.data(),data.id);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FriendProfileScreen()));
                                              },
                                              data['status'],
                                              Icons.close,
                                              () {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                        buildContext) {
                                                      return YesNoWidget(
                                                          "Do you want to remove the friend request?",
                                                          () {
                                                        removeFriendRequest(
                                                            data.id);
                                                      });
                                                    });
                                              }),
                                        );
                                      } else if (snapshot.data!.docs
                                          .where((QueryDocumentSnapshot<Object?>
                                                  element) =>
                                              element['email']
                                                  .toString()
                                                  .contains(userEmail) &&
                                              element['request']
                                                  .toString()
                                                  .contains("waiting"))
                                          .isNotEmpty) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 25, bottom: 17),
                                          child: CustomListTile2(
                                              data['fullName'],
                                              data['title'],
                                              data['profilePic'],
                                              () {
                                                Provider.of<Friend>(context,
                                                        listen: false)
                                                    .setFriend(data.data(),data.id);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FriendProfileScreen()));
                                              },
                                              data['status'],
                                              Icons.done,
                                              () {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                        buildContext) {
                                                      return YesNoWidget(
                                                          "Do you want to accept ${data['fullName']}'s friend request?",
                                                          () {
                                                        acceptFriendRequest(
                                                          data.id,
                                                        );
                                                      });
                                                    });
                                              }),
                                        );
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 25, bottom: 17),
                                          child: CustomListTile2(
                                              data['fullName'],
                                              data['title'],
                                              data['profilePic'],
                                              () {
                                                Provider.of<Friend>(context,
                                                        listen: false)
                                                    .setFriend(data.data(),data.id);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FriendProfileScreen()));
                                              },
                                              data['status'],
                                              Icons.add_circle_outline,
                                              () {
                                                addFriend(
                                                    data.id, data['email']);
                                              }),
                                        );
                                      }
                                    } else if (snapshot.data!.docs
                                        .where((QueryDocumentSnapshot<Object?>
                                                element) =>
                                            element['email']
                                                .toString()
                                                .toLowerCase()
                                                .contains(query.toLowerCase()))
                                        .isEmpty) {
                                      return Center(
                                        child: Text(
                                            "There is no user with this name '$query'",
                                            style: TextStyle(
                                                color: kred,
                                                fontFamily: 'Poppins',
                                                fontSize: 14)),
                                      );
                                    }
                                    return Container();
                                  }));
                            })
                          ]);
                    })),
              ]));
  }

  searchwidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: SizedBox(
        height: 40,
        child: TextField(
            cursorColor: Theme.of(context).scaffoldBackgroundColor == kdarkBG
                ? kwhite
                : kdark,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            controller: searchbtn,
            style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor == kdarkBG
                    ? kwhite
                    : kdark,
                fontSize: 16,
                fontFamily: "Poppins"),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              fillColor: Theme.of(context).scaffoldBackgroundColor == kdarkBG
                ? kgreyish.withOpacity(0.2)
                : kwhite,
              hintStyle: TextStyle(
                  fontSize: 12, color: kdarkGrey, fontFamily: 'Poppins'),
              hintText: "Search...",
              prefixIcon: Icon(Icons.search, color: kdarkGrey),
              suffixIcon: searchbtn.text.isNotEmpty
                  ? GestureDetector(
                      child: Icon(Icons.close, color: kred),
                      onTap: () {
                        searchbtn.clear();
                        setState(() {
                          query = '';
                        });
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    )
                  : null,
              filled: true,
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(
                    color: kwhite,
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: kwhite)),
            )),
      ),
    );
  }

  addFriend(String id, String mail) async {
    setState(() {
      refreshPage = true;
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("friends")
        .doc(id)
        .set({"email": mail, "request": "requested","type":"sender"});
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("friends")
        .doc(uid)
        .set({"email": email, "request": "waiting","type":"receiver"});
    setState(() {
      refreshPage = false;
    });
  }

  removeFriendRequest(String id) async {
    setState(() {
      refreshPage = true;
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("friends")
        .doc(id)
        .delete();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("friends")
        .doc(uid)
        .delete();
    Navigator.of(context).pop();
    setState(() {
      refreshPage = false;
    });
  }

  acceptFriendRequest(String id) async {
    setState(() {
      refreshPage = true;
    });
    int nb1 = 0;
    int nb2 = 0;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('friends')
        .doc(id)
        .update({"request": "accepted"});
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('friends')
        .doc(uid)
        .update({"request": "accepted"});
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
      setState(() {
        nb1 = value['friends'];
      });
    });
    FirebaseFirestore.instance.collection("users").doc(id).get().then((value) {
      setState(() {
        nb2 = value['friends'];
      });
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'friends': nb1+ 1});
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'friends': nb2 + 1});
    Navigator.of(context).pop();
    setState(() {
      refreshPage = false;
    });
  }
}
