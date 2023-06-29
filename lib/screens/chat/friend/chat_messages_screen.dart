// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, depend_on_referenced_packages, use_key_in_widget_constructors, unnecessary_string_escapes, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whisper/screens/profile/friend_messages_profile_screen.dart';
import 'package:whisper/views/tab_screen.dart';
import 'package:whisper/service/friend_service.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/custom_text_field.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:path/path.dart' as pth;
import 'package:whisper/widgets/image_widget.dart';
import 'package:whisper/widgets/show_message.dart';

class ChatMessagesScreen extends StatefulWidget {
  static const routeName = "/chat";
  @override
  _ChatMessagesScreenState createState() => _ChatMessagesScreenState();
}

class _ChatMessagesScreenState extends State<ChatMessagesScreen> {
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  TextEditingController msg = TextEditingController();

  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;

  getChatRoomIdByUsernames(String a, String b) {
    if (a.compareTo(b) == 1) {
      return "$a\_$b";
    } else {
      return "$b\_$a";
    }
  }

  Map<String, dynamic> friend = {};

  @override
  Widget build(BuildContext context) {
    friend = Provider.of<Friend>(context).friend;
    DateTime date = DateTime.now();
    final difference = date
                .difference(friend['statusTime'].toDate())
                .inSeconds <
            60
        ? 'Active ${date.difference(friend['statusTime'].toDate()).inSeconds} sec ago'
        : date.difference(friend['statusTime'].toDate()).inMinutes < 60
            ? 'Active ${date.difference(friend['statusTime'].toDate()).inMinutes} min ago'
            : date.difference(friend['statusTime'].toDate()).inHours < 24
                ? 'Active ${date.difference(friend['statusTime'].toDate()).inHours} h ago'
                : date.difference(friend['statusTime'].toDate()).inDays < 30
                    ? 'Active ${date.difference(friend['statusTime'].toDate()).inDays} days ago'
                    : 'Active since ${DateFormat('dd MMM yyyy').format(friend['statusTime'].toDate()).toString()}';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        toolbarHeight: 80,
        title: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: ImageWidget(friend['profilePic'], 40, 40)),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      constraints:
                          const BoxConstraints(maxWidth: 14, maxHeight: 14),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).scaffoldBackgroundColor),
                    )),
                Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      constraints:
                          const BoxConstraints(maxWidth: 10, maxHeight: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: friend['status'] ? kgreen : kgreyish),
                    ))
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend['fullName'],
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  friend['status'] ? 'Active' : difference,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: "Poppins",
                      fontSize: 14),
                ),
              ],
            )
          ],
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TabScreen(2)));
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).primaryColor,
              size: 30,
            )),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FriendMessagesProfileScreen()));
                },
                icon: Icon(
                  Icons.info,
                  color: Theme.of(context).primaryColor,
                  size: 30,
                )),
          )
        ],
        elevation: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(
              "Now you can send messages, photos or even make make a call.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16, color: kdarkGrey, fontFamily: 'Poppins'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 85),
            child: ShowMessages(),
          ),
        ],
      ),
      bottomSheet: Container(
        color: Theme.of(context).primaryColorDark,
        padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
        child: SafeArea(
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    takephoto(ImageSource.camera);
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    color: kred,
                  )),
              IconButton(
                  onPressed: () {
                    takephoto(ImageSource.gallery);
                  },
                  icon: Icon(Icons.image, color: kred)),
              Expanded(
                  child: SizedBox(
                      height: 40, child: CustomTextField(msg, 'Message...'))),
              IconButton(
                  onPressed: () {
                    if (msg.text.isNotEmpty) {
                      FirebaseFirestore.instance
                          .collection("chatRoom")
                          .doc(getChatRoomIdByUsernames(email, friend['email']))
                          .collection("Messages")
                          .doc()
                          .set({
                        "message": msg.text.trim(),
                        "user": email,
                        "time": DateTime.now(),
                        "state": false,
                        "name": "Message"
                      });
                      msg.clear();
                    }
                  },
                  icon: Icon(
                    Icons.send,
                    color: kred,
                    size: 30,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future takephoto(ImageSource source) async {
    final pick = await imagePicker.pickImage(source: source);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
        ProgressDialog pd = ProgressDialog(context: context);
        pd.show(
            elevation: 0,
            max: 100,
            progressType: ProgressType.normal,
            msg: 'En cours...',
            progressValueColor: kred.withOpacity(0.8),
            progressBgColor: Colors.transparent,
            msgTextAlign: TextAlign.start,
            msgColor: kdark);
        uploadImage(_image!).then((value) => pd.close());
      }
    });
  }

  Future uploadImage(File _image) async {
    final fileName = pth.basename(_image.path);
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference reference = FirebaseStorage.instance.ref().child(
        "chatRoom/${getChatRoomIdByUsernames(email, friend['email'])}/Messages/$fileName");

    await reference.putFile(_image);
    downloadURL = await reference.getDownloadURL();

    await firebaseFirestore
        .collection("chatRoom")
        .doc(getChatRoomIdByUsernames(email, friend['email']))
        .collection("Messages")
        .doc()
        .set({
      "message": downloadURL,
      "user": email,
      "time": DateTime.now(),
      "name": fileName
    });
  }
}
