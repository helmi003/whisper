// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisper/screens/chat/group/chat_group_screen.dart';
import 'package:whisper/service/group_service.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/image_widget.dart';

class GroupScreen extends StatefulWidget {
  static const routeName = "/group-screen";
  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  TextEditingController searchbtn = TextEditingController();
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  String uid = FirebaseAuth.instance.currentUser!.uid;

  String query = '';
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      searchwidget(),
      SizedBox(height: 33),
      StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("groups")
              // .get(),
              // .where(
              //   'members',
              // )
              // .where("members", isEqualTo: email)
              .snapshots(),
          builder: ((context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child:
                      CircularProgressIndicator(color: kred.withOpacity(0.8)));
            } else if (snapshot.hasError) {
              return Center(
                child: Text('There was an error while fetching the data',
                    style: TextStyle(
                        color: kred, fontFamily: 'Poppins', fontSize: 14)),
              );
            }
            List<QueryDocumentSnapshot<Map<String, dynamic>>> groups =
                snapshot.data!.docs;
            return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: groups.length,
                itemBuilder: (BuildContext context, int index) {
                  for (var member in groups[index]['members']) {
                    if (member == email) {
                      if (query.isEmpty ||
                          groups[index]['name']
                              .toString()
                              .toLowerCase()
                              .contains(query.toLowerCase())) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 25, bottom: 17),
                          child: ListTile(
                              onTap: () {
                                Provider.of<Group>(context, listen: false)
                                    .setGroup(groups[index].data());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChatGroupScreen(groups[index].id)));
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: ImageWidget(
                                      groups[index]['photo'], 60, 60)),
                              title: Text(
                                groups[index]['name'],
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: "Poppins",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(
                                Icons.send,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.7),
                                size: 25,
                              )),
                        );
                      } else {
                        return Center(
                          child: Text(
                              "There is no user with this name '$query'",
                              style: TextStyle(
                                  color: kred,
                                  fontFamily: 'Poppins',
                                  fontSize: 14)),
                        );
                      }
                    }
                  }
                  return Center(
                    child: Text("You're not a member in any group",
                        style: TextStyle(
                            color: kred, fontFamily: 'Poppins', fontSize: 14)),
                  );
                });
          })),
    ]);
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
}
