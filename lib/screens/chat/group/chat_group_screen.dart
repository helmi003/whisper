// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, depend_on_referenced_packages, use_key_in_widget_constructors, unnecessary_string_escapes, no_leading_underscores_for_local_identifiers, prefer_const_constructors_in_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whisper/screens/profile/group_profile_screen.dart';
import 'package:whisper/views/tab_screen.dart';
import 'package:whisper/service/group_service.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/custom_text_field.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:path/path.dart' as pth;
import 'package:whisper/widgets/image_widget.dart';
import 'package:whisper/widgets/show_group_messages.dart';

class ChatGroupScreen extends StatefulWidget {
  final String id;
  ChatGroupScreen(this.id);
  static const routeName = "/group-chat";
  @override
  _ChatGroupScreenState createState() => _ChatGroupScreenState();
}

class _ChatGroupScreenState extends State<ChatGroupScreen> {
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  TextEditingController msg = TextEditingController();

  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;

  Map<String, dynamic> group = {};

  @override
  Widget build(BuildContext context) {
    group = Provider.of<Group>(context).group;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        toolbarHeight: 80,
        title: Row(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: ImageWidget(group['photo'], 40, 40)),
          SizedBox(
            width: 10,
          ),
          Text(
            group['name'],
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: "Poppins",
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ]),
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
                          builder: (context) => GroupProfileScreen(widget.id)));
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
            child: ShowGroupMessages(widget.id),
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
                          .collection("groups")
                          .doc(widget.id)
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
    Reference reference = FirebaseStorage.instance
        .ref()
        .child("groups/${widget.id}/Messages/$fileName");

    await reference.putFile(_image);
    downloadURL = await reference.getDownloadURL();

    await firebaseFirestore
        .collection("groups")
        .doc(widget.id)
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
