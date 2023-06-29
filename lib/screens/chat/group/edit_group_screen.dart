// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whisper/screens/profile/group_profile_screen.dart';
import 'package:whisper/service/group_service.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/app_plus_bar.dart';
import 'package:whisper/widgets/bottom_sheet_camera.dart';
import 'package:whisper/widgets/custom_listtile.dart';
import 'package:whisper/widgets/custom_text_field.dart';
import 'package:whisper/widgets/image_widget.dart';

class EditGroupScreen extends StatefulWidget {
  final String id;
  EditGroupScreen(this.id);

  @override
  State<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  TextEditingController searchbtn = TextEditingController();
  TextEditingController name = TextEditingController();
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String query = '';
  String nameError = '';
  File? _photo;
  List members = [];
  bool isLoading = false;
  ImagePicker imagePicker = ImagePicker();
  Map<String, dynamic> group = {};
  @override
  Widget build(BuildContext context) {
    group = Provider.of<Group>(context).group;
    members = List.from(group['members']);
    return Scaffold(
      appBar: appPlusBar(
          context,
          'Edit group',
          Icon(
            Icons.done,
            color: Theme.of(context).primaryColor,
          ), () {
        createGroup();
      }),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: kred.withOpacity(0.8)))
          : ListView(
              children: [
                SizedBox(height: 20),
                CustomTextField(
                    name = TextEditingController(text: group['name']),
                    'Group name'),
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 5, bottom: 10),
                  child: Text(
                    nameError,
                    style: TextStyle(
                      color: kred,
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, bottom: 23),
                  child: Text(
                    'Group Image:',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
                Center(
                    child: Stack(
                  children: [
                    _photo != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(90),
                            child: Container(
                              constraints:
                                  BoxConstraints(maxHeight: 90, maxWidth: 90),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(
                                  _photo!,
                                ),
                              )),
                            ))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(90),
                            child: ImageWidget(group['photo'], 90, 90)),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(16),
                                        topLeft: Radius.circular(16)),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  context: context,
                                  builder: ((builder) => BottomSheetCamera(() {
                                        takephoto(
                                          ImageSource.camera,
                                        );
                                      }, () {
                                        takephoto(
                                          ImageSource.gallery,
                                        );
                                      })));
                            },
                            icon: Icon(Icons.camera_alt,
                                color: Theme.of(context).primaryColor)))
                  ],
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 22, bottom: 17),
                  child: Text(
                    'Group members:',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
                ListView.builder(
                  itemCount: members.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .where('email', isEqualTo: members[index])
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
                          } else if (members.length == 1) {
                            return Center(
                              child: Text('No members in this group yet',
                                  style: TextStyle(
                                      color: kred,
                                      fontFamily: 'Poppins',
                                      fontSize: 14)),
                            );
                          } else if (members[index] == email) {
                            return Container();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 25, bottom: 17),
                            child: CustomListTile(
                                snapshot.data!.docs.first['fullName'],
                                snapshot.data!.docs.first['title'],
                                snapshot.data!.docs.first['profilePic'], () {
                              if (members.contains(
                                  snapshot.data!.docs.first['email'])) {
                                setState(() {
                                  members.remove(
                                      snapshot.data!.docs.first['email']);
                                  Provider.of<Group>(context, listen: false)
                                      .updateGroupMembers(members);
                                });
                              } else {
                                setState(() {
                                  members
                                      .add(snapshot.data!.docs.first['email']);
                                  Provider.of<Group>(context, listen: false)
                                      .updateGroupMembers(members);
                                });
                              }
                            }, snapshot.data!.docs.first['status'],
                                Icons.close),
                          );
                        }));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 22, bottom: 17),
                  child: Text(
                    'Add members to the group:',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
                searchwidget(),
                SizedBox(height: 17),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(uid)
                        .collection("friends")
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
                          child: Text("You don't have friends yet",
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
                            ...snapshot.data!.docs
                                .map((QueryDocumentSnapshot<Object?> data) {
                              final String userEmail = data["email"];
                              return FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('users')
                                      .where('email', isEqualTo: userEmail)
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
                                    } else if (members.contains(userEmail)) {
                                      return Container();
                                    } else if (query.isEmpty ||
                                        snapshot.data!.docs.first['fullName']
                                            .toString()
                                            .toLowerCase()
                                            .contains(query.toLowerCase())) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 25, bottom: 17),
                                        child: CustomListTile(
                                            snapshot
                                                .data!.docs.first['fullName'],
                                            snapshot.data!.docs.first['title'],
                                            snapshot.data!.docs
                                                .first['profilePic'], () {
                                          if (members.contains(snapshot
                                              .data!.docs.first['email'])) {
                                            setState(() {
                                              members.remove(snapshot
                                                  .data!.docs.first['email']);
                                              Provider.of<Group>(context,
                                                      listen: false)
                                                  .updateGroupMembers(members);
                                            });
                                          } else {
                                            setState(() {
                                              members.add(snapshot
                                                  .data!.docs.first['email']);
                                              Provider.of<Group>(context,
                                                      listen: false)
                                                  .updateGroupMembers(members);
                                            });
                                          }
                                        }, snapshot.data!.docs.first['status'],
                                            Icons.add_circle_outline),
                                      );
                                    }
                                    return Center(
                                      child: Text(
                                          "There is no user with this name '$query'",
                                          style: TextStyle(
                                              color: kred,
                                              fontFamily: 'Poppins',
                                              fontSize: 14)),
                                    );
                                  }));
                            })
                          ]);
                    })),
              ],
            ),
    );
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

  takephoto(ImageSource source) async {
    final pick = await imagePicker.pickImage(source: source);
    if (pick != null) {
      setState(() {
        _photo = File(pick.path);
      });
    }
  }

  createGroup() async {
    if (name.text == '') {
      setState(() {
        nameError = "The group name should not be empty";
      });
    } else {
      setState(() {
        isLoading = true;
      });
      String photo = group['photo'];
      if (_photo != null) {
        final imgId = DateTime.now().millisecondsSinceEpoch.toString();
        Reference reference = FirebaseStorage.instance
            .ref()
            .child("groups/${widget.id}/icon/$imgId");
        await reference.putFile(_photo!);
        photo = await reference.getDownloadURL();
      }
      FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.id)
          .update({'name': name.text, 'members': members, 'photo': photo});
      Provider.of<Group>(context, listen: false)
          .updateGroup(members, name.text, photo);
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacementNamed(context, GroupProfileScreen.routeName);
    }
  }
}
