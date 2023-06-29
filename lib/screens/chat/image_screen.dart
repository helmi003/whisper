// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:whisper/widgets/app_bar.dart';
class ImageScreen extends StatelessWidget {
  const ImageScreen({required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, ''),
      body: Center(
        child: Image.network(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
