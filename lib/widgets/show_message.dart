// ignore_for_file: deprecated_member_use, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, use_build_context_synchronously, unnecessary_string_escapes

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:whisper/screens/chat/image_screen.dart';
import 'package:whisper/service/friend_service.dart';
import 'package:whisper/utils/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:whisper/widgets/image_widget.dart';
import 'package:whisper/widgets/yes_no_widget.dart';

class ShowMessages extends StatefulWidget {
  @override
  State<ShowMessages> createState() => _ShowMessagesState();
}

class _ShowMessagesState extends State<ShowMessages> {
  String email = FirebaseAuth.instance.currentUser!.email.toString();
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
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chatRoom")
            .doc(getChatRoomIdByUsernames(email, friend['email']))
            .collection("Messages")
            .orderBy("time")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: kred.withOpacity(0.8)),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              primary: true,
              itemBuilder: (context, i) {
                QueryDocumentSnapshot x = snapshot.data!.docs[i];
                String id = x.id;
                return x['user'] != friend['email']
                    ? x["message"].toString().length > 8 &&
                            x["message"].toString().substring(0, 8) ==
                                "https://"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 20, 20),
                                child: GestureDetector(
                                    onLongPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext buildContext) {
                                            return YesNoWidget(
                                                'Are you sure you want to delete this image?',
                                                () {
                                              deleteWidget(id, x['name']);
                                            });
                                          });
                                    },
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => ImageScreen(
                                                  image: x["message"])));
                                    },
                                    child: Container(
                                      constraints: const BoxConstraints(
                                          maxWidth: 200, maxHeight: 200),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                              x['message'],
                                            )),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: kred,
                                          width: 2,
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                    onLongPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext buildContext) {
                                            return YesNoWidget(
                                                'Are you sure you want to delete this message?',
                                                () {
                                              deleteWidget(id, '');
                                            });
                                          });
                                    },
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection("chatRoom")
                                          .doc(getChatRoomIdByUsernames(
                                              email, friend['email']))
                                          .collection("Messages")
                                          .doc(id)
                                          .update({'state': !x['state']});
                                    },
                                    child: Container(
                                      constraints:
                                          const BoxConstraints(maxWidth: 250),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          color: x['state']
                                              ? kred.withOpacity(0.8)
                                              : kred),
                                      child: Text(x["message"],
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              color: kwhite)),
                                    )),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 2),
                                  child: x['state']
                                      ? Text(date
                                                  .difference(
                                                      x["time"].toDate())
                                                  .inHours <
                                              24
                                          ? DateFormat('kk:mm')
                                              .format(x["time"].toDate())
                                          : date
                                                      .difference(
                                                          x["time"].toDate())
                                                      .inDays <
                                                  7
                                              ? '${DateFormat('EEEE').format(x["time"].toDate())} At ${DateFormat('kk:mm').format(x["time"].toDate())}'
                                              : date
                                                          .difference(x["time"]
                                                              .toDate())
                                                          .inDays <
                                                      364
                                                  ? '${DateFormat('dd MMM').format(x["time"].toDate())} At ${DateFormat('kk:mm').format(x["time"].toDate())}'
                                                  : '${DateFormat('dd MMM yyyy').format(x["time"].toDate())} At ${DateFormat('kk:mm').format(x["time"].toDate())}')
                                      : const Text(''),
                                )
                              ],
                            ),
                          )
                    : x["message"].toString().length > 8 &&
                            x["message"].toString().substring(0, 8) ==
                                "https://"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 5, bottom: 20),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: ImageWidget(
                                          friend['profilePic'], 20, 20))),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => ImageScreen(
                                                  image: x["message"])));
                                    },
                                    child: Container(
                                      constraints: const BoxConstraints(
                                          maxWidth: 200, maxHeight: 200),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                              x['message'],
                                            )),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Theme.of(context)
                                                      .scaffoldBackgroundColor ==
                                                  klightBG
                                              ? kdarkGrey
                                              : kwhite,
                                          width: 2,
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: 10, right: 5, bottom: 20),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: ImageWidget(
                                        friend['profilePic'], 20, 20)),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        FirebaseFirestore.instance
                                            .collection("chatRoom")
                                            .doc(getChatRoomIdByUsernames(
                                                email, friend['email']))
                                            .collection("Messages")
                                            .doc(id)
                                            .update({'state': !x['state']});
                                      },
                                      child: Container(
                                        constraints:
                                            const BoxConstraints(maxWidth: 250),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            border: Border.all(
                                              color: x['state']
                                                  ? kred.withOpacity(0.8)
                                                  : kred,
                                              // width: 2,
                                            )),
                                        child: Text(
                                          x["message"],
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                          .scaffoldBackgroundColor ==
                                                      klightBG
                                                  ? kdark
                                                  : kwhite),
                                        ),
                                      )),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: x['state']
                                        ? Text(date
                                                    .difference(
                                                        x["time"].toDate())
                                                    .inHours <
                                                24
                                            ? DateFormat('kk:mm')
                                                .format(x["time"].toDate())
                                            : date
                                                        .difference(
                                                            x["time"].toDate())
                                                        .inDays <
                                                    7
                                                ? '${DateFormat('EEEE').format(x["time"].toDate())} At ${DateFormat('kk:mm').format(x["time"].toDate())}'
                                                : date
                                                            .difference(
                                                                x["time"]
                                                                    .toDate())
                                                            .inDays <
                                                        364
                                                    ? '${DateFormat('dd MMM').format(x["time"].toDate())} At ${DateFormat('kk:mm').format(x["time"].toDate())}'
                                                    : '${DateFormat('dd MMM yyyy').format(x["time"].toDate())} At ${DateFormat('kk:mm').format(x["time"].toDate())}')
                                        : Text(''),
                                  )
                                ],
                              ),
                            ],
                          );
              });
        });
  }

  deleteWidget(String id, String name) async {
    if (name != '') {
      await FirebaseStorage.instance
          .ref()
          .child(
              "chatRoom/${getChatRoomIdByUsernames(email, friend['email'])}/Messages/$name")
          .delete();
    }
    await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(getChatRoomIdByUsernames(email, friend['email']))
        .collection("Messages")
        .doc(id)
        .delete();
    Navigator.of(context).pop();
  }
}
