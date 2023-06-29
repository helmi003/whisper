// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class ImageWidget extends StatelessWidget {
  final String image;
  final double maxWidth;
  final double maxHeight;
  const ImageWidget(this.image, this.maxHeight, this.maxWidth);

  @override
  Widget build(BuildContext context) {
    return image != null
        ? CachedNetworkImage(
            imageUrl: image,
            imageBuilder: (context, imageProvider) => Container(
              constraints:
                  BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
              decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => CircularProgressIndicator(
              color: kred.withOpacity(0.8),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          )
        : Container(
            constraints:
                BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
            child: Image.asset('assets/images/splash_screen.png'));
  }
}
