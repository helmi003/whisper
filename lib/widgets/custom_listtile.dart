// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/image_widget.dart';

class CustomListTile extends StatelessWidget {
  final String name;
  final String mesasge;
  final String photo;
  final bool active;
  final VoidCallback OnPressed;
  final IconData icon;
  const CustomListTile(this.name, this.mesasge, this.photo, this.OnPressed,
      this.active, this.icon);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: OnPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: ImageWidget(
                    photo,
                    60,
                    60)),
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
                      color: active ? kgreen : kgreyish),
                ))
          ],
        ),
        title: Text(
          name,
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontFamily: "Poppins",
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(
            mesasge,
            style: TextStyle(
                color: Theme.of(context).primaryColor.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
        ),
        trailing: Icon(
              icon,
              color: Theme.of(context).primaryColor.withOpacity(0.7),
              size: 25,
            ));
  }
}
