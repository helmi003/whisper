// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, use_build_context_synchronously

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whisper/views/tab_screen.dart';
import 'package:whisper/service/posts_services.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/custom_text_area.dart';
import 'package:whisper/screens/posts/tag_friend.dart';
import 'package:whisper/widgets/settings_content.dart';

class AddPostScreen extends StatefulWidget {
  @override
  State<AddPostScreen> createState() => _AddPostState();
}

class _AddPostState extends State<AddPostScreen> {
  File? _image;
  String errorMessage = "";
  bool isLoading = false;
  String downloadURL = "";
  final imagePicker = ImagePicker();
  List<Map<String, dynamic>> tags = [];
  TextEditingController message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    tags = Provider.of<PostServices>(context).tags;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text(
          'Add new post',
          style: TextStyle(
              fontFamily: "Poppins",
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: addPost,
          ),
        ],
        leading: IconButton(
            onPressed: () {
              Provider.of<PostServices>(context, listen: false)
                  .tagedFriends([]);
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).primaryColor,
              size: 30,
            )),
        elevation: 0,
      ),
      body: isLoading
          ? CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            )
          : ListView(children: [
              SizedBox(height: 20),
              CustomTextArea(message, 'Write someting...'),
              errorMessage == ""
                  ? Container()
                  : Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 40, top: 5, bottom: 5),
                            child: Text(
                              errorMessage,
                              style: TextStyle(
                                color: kred,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              _image != null
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
                      child: Center(
                          child: Stack(children: [
                        Image.file(_image!,
                            height: 180,
                            width: MediaQuery.of(context).size.width),
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
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 15),
                child: SettingsContent(Icons.image, 'Gallery', () {
                  takePhoto(ImageSource.gallery);
                }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 15),
                child: SettingsContent(Icons.camera_alt, 'Camera', () {
                  takePhoto(ImageSource.camera);
                }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 15),
                child: SettingsContent(Icons.local_offer, 'Tag someone', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TagFriendScreen()));
                }),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, bottom: 5),
                child: Text(
                  'Tags:',
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              tags.isEmpty
                  ? Center(
                      child: Text(
                        'There is no Taged friends yet',
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: kred.withOpacity(0.8)),
                      ),
                    )
                  : Container(),
              for (var tag in tags)
                Row(children: [
                  SizedBox(width: 25),
                  Text(tag['name'],
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Theme.of(context).primaryColor)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          tags.removeWhere(
                              (item) => item['email'] == tag['email']);
                        });
                      },
                      icon: Icon(Icons.close,
                          color: Theme.of(context).primaryColor))
                ]),
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

  addPost() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    if (downloadURL == "" && message.text == "") {
      setState(() {
        errorMessage =
            "The post can't be empty, you should write something or add an image or both";
      });
    } else {
      setState(() {
        errorMessage = "";
        isLoading = true;
      });
      if (_image != null) {
        final imgId = DateTime.now().millisecondsSinceEpoch.toString();
        Reference reference = FirebaseStorage.instance
            .ref()
            .child('Posts/images/$uid')
            .child("post_$imgId");
        await reference.putFile(_image!);
        downloadURL = await reference.getDownloadURL();
      }
      await PostServices().addPost(message.text, downloadURL, tags);
      Provider.of<PostServices>(context, listen: false).tagedFriends([]);
      Navigator.pushReplacementNamed(context, TabScreen.routeName);
      setState(() {
        isLoading = false;
      });
    }
  }
}
