// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/app_bar.dart';
import 'package:whisper/widgets/custom_button2.dart';
import 'package:whisper/widgets/custom_text_area.dart';
import 'package:whisper/widgets/custom_text_field.dart';
import 'package:whisper/widgets/error_message.dart';
import 'package:whisper/widgets/settings_content.dart';

class HelpReportCenterScreen extends StatefulWidget {
  const HelpReportCenterScreen({super.key});

  @override
  State<HelpReportCenterScreen> createState() => _HelpReportCenterScreenState();
}

class _HelpReportCenterScreenState extends State<HelpReportCenterScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController _type = TextEditingController();
  TextEditingController _message = TextEditingController();
  String typeError = "";
  String messageError = "";
  bool isLoading = false;
  final imagePicker = ImagePicker();
  String downloadURL = "";
  File? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Help & Report center'),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
          child: Text(
            "Hi, how can we help you ?",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
          child: Text(
            "If you're facing any problem while using our app or inappropriate content like spam, scam, bug, fake news or accounts, violence, abusive... You can provide the nature of the problem, your message about it, and screenshots (if necessary).",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontFamily: 'Poppins',
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35, right: 25, top: 10),
          child: Text(
            'Type:',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
        ),
        CustomTextField(_type, 'Type of problem'),
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 5),
          child: Text(
            typeError,
            style: TextStyle(
              color: kred,
              fontSize: 12,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35, right: 25),
          child: Text(
            'Message:',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
        ),
        CustomTextArea(_message, 'Write something...'),
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 5),
          child: Text(
            messageError,
            style: TextStyle(
              color: kred,
              fontSize: 12,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
          child: SettingsContent(Icons.image, 'Photo/Screenshot', () {
            takePhoto(ImageSource.gallery);
          }),
        ),
        _image != null
            ? Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 15),
                child: Center(
                    child: Stack(children: [
                  Image.file(_image!,
                      height: 180, width: MediaQuery.of(context).size.width),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              _image = null;
                            });
                          },
                          icon: Icon(Icons.close,
                              color: Theme.of(context).primaryColor))),
                ])),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton2(isLoading, 'Send', sendInfo),
              SizedBox(width: 25),
            ],
          ),
        )
      ]),
    );
  }

  takePhoto(ImageSource source) async {
    final pick = await imagePicker.pickImage(source: source);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      }
    });
  }

  sendInfo() async {
    if (_type.text.isEmpty) {
      setState(() {
        typeError = "the type should not be empty";
        messageError = "";
      });
    } else if (_message.text.isEmpty) {
      setState(() {
        typeError = "";
        messageError = "the message should not be empty";
      });
    } else {
      setState(() {
        typeError = "";
        messageError = "";
        isLoading = true;
      });
      if (_image != null) {
        final imgId = DateTime.now().millisecondsSinceEpoch.toString();
        Reference reference = FirebaseStorage.instance
            .ref()
            .child('Help-Report/images/$uid')
            .child("post_$imgId");
        await reference.putFile(_image!);
        downloadURL = await reference.getDownloadURL();
      }
      FirebaseFirestore.instance.collection('help-report').add({
        "type": _type.text,
        "message": _message.text,
        "screenshot": downloadURL,
      });
      showDialog(
          context: context,
          builder: ((context) {
            return ErrorMessage('Success',
                'Your message has been sent successfuly, we will try our best to answear you asap, please be patient');
          }));
      setState(() {
        isLoading = false;
      });
    }
  }
}
