// ignore_for_file: prefer_const_constructors, prefer_const_declarations, unnecessary_null_comparison, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisper/views/chat_screen.dart';
import 'package:whisper/screens/chat/group/edit_group_screen.dart';
import 'package:whisper/service/group_service.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/app_bar.dart';
import 'package:whisper/widgets/app_plus_bar.dart';
import 'package:whisper/widgets/custom_button2.dart';
import 'package:whisper/widgets/image_widget.dart';
import 'package:whisper/widgets/yes_no_widget.dart';

class GroupProfileScreen extends StatefulWidget {
  static const routeName = "/group-profile-screen";
  final String id;
  GroupProfileScreen(this.id);

  @override
  State<GroupProfileScreen> createState() => _GroupProfileScreenState();
}

class _GroupProfileScreenState extends State<GroupProfileScreen> {
  String email = FirebaseAuth.instance.currentUser!.email.toString();

  Map<String, dynamic> group = {};

  List members = [];

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    group = Provider.of<Group>(context).group;
    return Scaffold(
        appBar: group['admin'] == email
            ? appPlusBar(context, 'Group info', Icon(Icons.close), () {
                showDialog(
                    context: context,
                    builder: ((context) {
                      return YesNoWidget(
                          'Do you really want to delete this group?', () {
                        deleteGroup();
                        Navigator.pushReplacementNamed(
                            context, ChatScreen.routeName);
                      });
                    }));
              })
            : appBar(context, 'Group info'),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(color: kred.withOpacity(0.8)))
            : ListView(children: [
                SizedBox(height: 20),
                Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(120),
                      child: ImageWidget(group['photo'], 120, 120)),
                ),
                SizedBox(height: 7),
                Center(
                    child: Text(
                  group['name'],
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )),
                SizedBox(height: 27),
                Center(
                    child: Text(
                  'Group memebers:',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                )),
                SizedBox(height: 23),
                for (var member in group['members'])
                  FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .where('email', isEqualTo: member)
                          .get(),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
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
                        }
                        final user = snapshot.data!.docs.first.data();
                        members.add(member);
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, bottom: 17),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: ImageWidget(
                                        user['profilePic'], 40, 40)),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 9, right: 9),
                                  child: Text(
                                    user['fullName'],
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                group['admin'] == email
                                    ? member != email
                                        ? IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                      buildContext) {
                                                    return YesNoWidget(
                                                        "Do you want to remove '${user['fullName']}' from this group?",
                                                        () {
                                                      members.remove(member);
                                                      FirebaseFirestore.instance
                                                          .collection('groups')
                                                          .doc(widget.id)
                                                          .update({
                                                        'members': members
                                                      }).then((value) => null);
                                                      Provider.of<Group>(
                                                              context,
                                                              listen: false)
                                                          .updateGroupMembers(
                                                              members);
                                                      Navigator.of(context)
                                                          .pop();
                                                    });
                                                  });
                                            },
                                            icon: Icon(Icons.close),
                                            color:
                                                Theme.of(context).primaryColor,
                                          )
                                        : Container()
                                    : Container()
                              ]),
                        );
                      })),
                SizedBox(height: 40),
                group['admin'] == email
                    ? Center(
                        child: CustomButton2(false, 'Edit group', () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditGroupScreen(widget.id)));
                        }),
                      )
                    : Container(),
                SizedBox(height: 20),
              ]));
  }

  deleteGroup() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.id)
        .delete();
    await FirebaseStorage.instance
        .ref()
        .child("groups/${widget.id}/icon/")
        .delete();
    await FirebaseStorage.instance
        .ref()
        .child("groups/${widget.id}/Messages/")
        .delete();
    setState(() {
      isLoading = false;
    });
  }
}
