// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whisper/views/tab_screen.dart';
import 'package:whisper/widgets/custom_button2.dart';
import 'package:whisper/model/slider_content.dart';
import 'package:whisper/utils/colors.dart';

class SliderScreen extends StatefulWidget {
  static const routeName = "/slider-screen";
  const SliderScreen({super.key});

  @override
  State<SliderScreen> createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 60),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        contents[i].image,
                        height: 300,
                      ),
                      SizedBox(height: 60),
                      Text(
                        contents[i].description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            color: kdarkGrey),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                (index) => buildDot(index, context),
              ),
            ),
          ),
          SizedBox(height: 64),
          currentIndex == 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomButton2(false, 'Previous', () {
                      _controller.previousPage(
                        duration: Duration(milliseconds: 800),
                        curve: Curves.easeIn,
                      );
                    }),
                    SizedBox(width: 17),
                    CustomButton2(false, 'Next', () {
                      _controller.nextPage(
                        duration: Duration(milliseconds: 800),
                        curve: Curves.easeIn,
                      );
                    }),
                  ],
                )
              : CustomButton2(false, currentIndex == 2 ? 'finish' : 'Next', () {
                  if (currentIndex == 2) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TabScreen(0)));
                  }
                  _controller.nextPage(
                    duration: Duration(milliseconds: 800),
                    curve: Curves.easeIn,
                  );
                }),
          SizedBox(height: 19),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TabScreen(0)));
            },
            child: Text(
              "Skip",
              style: TextStyle(
                  color: kred,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          SizedBox(height: 25)
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 15,
      width: currentIndex == index ? 30 : 15,
      margin: index == 2
          ? null
          : currentIndex == index
              ? EdgeInsets.only(right: 31)
              : EdgeInsets.only(right: 36),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
