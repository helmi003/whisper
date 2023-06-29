// ignore_for_file: prefer_const_constructors, prefer_const_declarations, unnecessary_null_comparison, use_key_in_widget_constructors, use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whisper/views/tab_screen.dart';
import 'package:whisper/service/user_service.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/app_bar.dart';
import 'package:whisper/widgets/bottom_sheet_camera.dart';
import 'package:whisper/widgets/custom_button2.dart';
import 'package:whisper/widgets/custom_text_area.dart';
import 'package:whisper/widgets/custom_text_field.dart';
import 'package:whisper/widgets/image_widget.dart';
import 'package:whisper/widgets/social.dart';
import 'package:intl/intl.dart';
import 'package:whisper/widgets/yes_no_widget.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController fullName = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController link = TextEditingController();
  final items = [
    'Social',
    'instagram',
    'facebook',
    'youtube',
    'twitter',
    'github',
    'linkedin',
    'website'
  ];
  DateTime birthday = DateTime.now();
  String val = "Social";
  String socialError = "";
  File? _profil;
  File? _bgPic;
  final imagePicker = ImagePicker();
  String fullName2 = "";
  String bio2 = "";
  String profilePic = "";
  String bgPic = "";
  String title2 = "";
  bool isLoading = false;
  bool isLoading2 = false;
  List socials = [];
  int nb = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context, 'Edit profile'),
        body: ListView(children: [
          FutureBuilder(
              future:
                  FirebaseFirestore.instance.collection('users').doc(uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                      child: CircularProgressIndicator(
                          color: kred.withOpacity(0.8)));
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('There was an error while fetching the data',
                        style: TextStyle(
                            color: kred, fontFamily: 'Poppins', fontSize: 14)),
                  );
                }
                fullName2 = snapshot.data!['fullName'];
                bio2 = snapshot.data!['bio'];
                profilePic = snapshot.data!['profilePic'];
                bgPic = snapshot.data!['bgPic'];
                nb > 0 ? null : birthday = snapshot.data!['birthday'].toDate();
                title2 = snapshot.data!['title'];
                socials = snapshot.data!['socials'];
                return Column(children: [
                  SizedBox(
                    height: 244,
                    child: Stack(
                      children: [
                        _bgPic != null
                            ? Container(
                                constraints: BoxConstraints(
                                    maxHeight: 145,
                                    maxWidth:
                                        MediaQuery.of(context).size.width),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                    _bgPic!,
                                  ),
                                )),
                              )
                            : ImageWidget(
                                bgPic, 145, MediaQuery.of(context).size.width),
                        Positioned(
                            bottom: 103,
                            right: 6,
                            child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(16),
                                            topLeft: Radius.circular(16)),
                                      ),
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      context: context,
                                      builder: ((builder) =>
                                          BottomSheetCamera(() {
                                            takephoto(ImageSource.camera, 'bg');
                                          }, () {
                                            takephoto(
                                                ImageSource.gallery, 'bg');
                                          })));
                                },
                                child: Icon(Icons.camera_alt, color: kwhite))),
                        Positioned.fill(
                            child: Align(
                          alignment: Alignment.bottomCenter,
                          child: _profil != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(120),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxHeight: 120, maxWidth: 120),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(
                                        _profil!,
                                      ),
                                    )),
                                  ))
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(120),
                                  child: ImageWidget(profilePic, 120, 120)),
                        )),
                        Positioned.fill(
                            bottom: 10,
                            left: 50,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(16),
                                                topLeft: Radius.circular(16)),
                                          ),
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          context: context,
                                          builder: ((builder) =>
                                              BottomSheetCamera(() {
                                                takephoto(ImageSource.camera,
                                                    'profil');
                                              }, () {
                                                takephoto(ImageSource.gallery,
                                                    'profil');
                                              })));
                                    },
                                    child: Icon(Icons.camera_alt,
                                        color: kwhite)))),
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  CustomTextField(
                      fullName = TextEditingController(text: fullName2),
                      'Name'),
                  SizedBox(height: 6),
                  CustomTextField(
                      title = TextEditingController(text: title2), 'Title'),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          DateFormat('dd-MM-yyyy').format(birthday).toString()),
                      SizedBox(width: 20),
                      CustomButton2(false, 'Birth date', () {
                        showDatePicker(
                                context: context,
                                initialDate: birthday,
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now())
                            .then((date) {
                          setState(() {
                            nb++;
                            birthday = date as DateTime;
                          });
                        });
                      })
                    ],
                  ),
                  SizedBox(height: 10),
                  CustomTextArea(
                      bio = TextEditingController(text: bio2), 'Bio'),
                  SizedBox(height: 20),
                  Center(
                    child: CustomButton2(isLoading, 'Done', updateProfile),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Socials:',
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  isLoading2
                      ? CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        )
                      : socials.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  top: 17, left: 30, bottom: 18),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: socials.map((social) {
                                    return SocialWidget(
                                        social['icon'], social['link'], () {
                                      deleteSocial(social['icon']);
                                    });
                                  }).toList()),
                            )
                          : Center(
                              child: Text(
                                'There is no socials yet',
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: kred.withOpacity(0.8)),
                              ),
                            ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 115,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                icon: Icon(Icons.expand_more,
                                    color: Theme.of(context).primaryColor),
                                items: items.map(builMenuItem).toList(),
                                value: val,
                                onChanged: (value) =>
                                    setState(() => val = value as String)),
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                                height: 40,
                                child: CustomTextField(link, 'Link'))),
                        GestureDetector(
                          onTap: addSocial,
                          child: Icon(Icons.add_circle_outline,
                              color: Theme.of(context).primaryColor),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, top: 5, bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            socialError,
                            style: TextStyle(
                              color: kred,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]);
              }),
        ]));
  }

  DropdownMenuItem<String> builMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              fontFamily: "Poppins",
              fontSize: 16),
        ),
      );

  takephoto(ImageSource source, String image) async {
    final pick = await imagePicker.pickImage(source: source);
    setState(() {
      if (pick != null && image == 'profil') {
        _profil = File(pick.path);
      } else if (pick != null && image == 'bg') {
        _bgPic = File(pick.path);
      }
    });
  }

  updateProfile() async {
    setState(() {
      isLoading = true;
    });
    if (_profil != null) {
      final imgId = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = FirebaseStorage.instance
          .ref()
          .child('Profile/images/$uid')
          .child("post_$imgId");

      await reference.putFile(_profil!);
      profilePic = await reference.getDownloadURL();
    }
    if (_bgPic != null) {
      final imgId = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = FirebaseStorage.instance
          .ref()
          .child('Profile/images/$uid')
          .child("post_$imgId");
      await reference.putFile(_bgPic!);
      bgPic = await reference.getDownloadURL();
    }
    await UserService().updateUser(
        uid, fullName.text, bio.text, profilePic, bgPic, birthday, title.text);
    Navigator.pushReplacementNamed(context, TabScreen.routeName);
    setState(() {
      isLoading = false;
    });
  }

  addSocial() async {
    bool test = false;
    for (var element in socials) {
      if (element['icon'] == val) {
        test = true;
        break;
      }
    }
    if (val == "Social") {
      setState(() {
        socialError = "Select a social first";
      });
    } else if (test) {
      socialError =
          "This social already exists either delete it or add another one";
    } else if (link.text.isEmpty) {
      setState(() {
        socialError = "This link should not be empty";
      });
    } else {
      setState(() {
        isLoading2 = true;
      });
      socials.add({'icon': val, 'link': link.text});
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .update({'socials': socials});
      Navigator.pushReplacementNamed(context, TabScreen.routeName);
      setState(() {
        isLoading2 = false;
      });
    }
  }

  deleteSocial(String icon) {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return YesNoWidget("Do you really want to delete this social?",
              () async {
            setState(() {
              isLoading2 = true;
            });
            socials.removeWhere((element) => element["icon"] == icon);
            await FirebaseFirestore.instance
                .collection("users")
                .doc(uid)
                .update({'socials': socials});
            Navigator.pushReplacementNamed(context, TabScreen.routeName);
            setState(() {
              isLoading2 = false;
            });
          });
        });
  }
}
