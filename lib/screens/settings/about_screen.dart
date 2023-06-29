// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/app_bar.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool developers = false;
  bool connection = false;
  bool privacy = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'About'),
      body: ListView(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 113,
            width: 115,
          ),
          SizedBox(height: 10),
          Center(
            child: RichText(
                text: TextSpan(
                    text: 'Welcome to ',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        color: Theme.of(context).primaryColor),
                    children: <TextSpan>[
                  TextSpan(
                      text: 'Whisper',
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kred))
                ])),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
            child: Text(
              "Description:",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Text(
              "It is a mobile app available on iPhone and Android. People can add and share posts with their friends. They can also view, comment and like them. In addition They can make phone calls and send messages or even pictures  including groups of people. It is flexible, functional, and enjoyable for everyone.",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
            child: Text(
              "Type:",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Text(
              "Social media application",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
            child: Text(
              "Other information:",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 25, left: 25),
            child: Container(
              decoration: BoxDecoration(
                  color: kgreyish, borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                onTap: () {
                  setState(() {
                    developers = !developers;
                  });
                },
                title: Text('Developers team',
                    style: TextStyle(
                        color: kdark,
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                trailing: Icon(
                    developers
                        ? Icons.keyboard_arrow_down
                        : Icons.navigate_next,
                    size: 24.2,
                    color: kdark),
              ),
            ),
          ),
          !developers
              ? SizedBox(height: 10)
              : Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 10),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: kgreyish,
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Helmi Ben Romdhane',
                                style: TextStyle(
                                    color: kdark,
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                'software engineering student \nMobile & Web Developer \nBackend & Frontend Developer \n22 years old',
                                style: TextStyle(
                                  color: kdark,
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                )),
                          ],
                        ),
                        Image.asset(
                          'assets/images/helmi.png',
                          height: 123,
                          width: 92,
                        ),
                      ],
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(right: 25, left: 25),
            child: Container(
              decoration: BoxDecoration(
                  color: kgreyish, borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                onTap: () {
                  setState(() {
                    connection = !connection;
                  });
                },
                title: Text('Build connection & community',
                    style: TextStyle(
                        color: kdark,
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                trailing: Icon(
                    connection
                        ? Icons.keyboard_arrow_down
                        : Icons.navigate_next,
                    size: 24.2,
                    color: kdark),
              ),
            ),
          ),
          !connection
              ? SizedBox(height: 10)
              : Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 10),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: kgreyish,
                        borderRadius: BorderRadius.circular(16)),
                    child: Text(
                        'Our services help people connect, and when they’re at their best, they bring people closer together.',
                        style: TextStyle(
                          color: kdark,
                          fontFamily: "Poppins",
                          fontSize: 14,
                        )),
                  )),
          Padding(
            padding: const EdgeInsets.only(right: 25, left: 25),
            child: Container(
              decoration: BoxDecoration(
                  color: kgreyish, borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                onTap: () {
                  setState(() {
                    privacy = !privacy;
                  });
                },
                title: Text('Keep people safe & Protect privacy',
                    style: TextStyle(
                        color: kdark,
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                trailing: Icon(
                    privacy ? Icons.keyboard_arrow_down : Icons.navigate_next,
                    size: 24.2,
                    color: kdark),
              ),
            ),
          ),
          !privacy
              ? SizedBox(height: 10)
              : Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 10),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: kgreyish,
                        borderRadius: BorderRadius.circular(16)),
                    child: Text(
                        'We have a responsibility to promote the best of what people can do together by keeping people safe and preventing harm.',
                        style: TextStyle(
                          color: kdark,
                          fontFamily: "Poppins",
                          fontSize: 14,
                        )),
                  ))
        ],
      ),
    );
  }
}
