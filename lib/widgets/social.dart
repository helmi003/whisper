// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whisper/widgets/error_message.dart';

class SocialWidget extends StatelessWidget {
  final String icon;
  final String link;
  final VoidCallback OnLongPress;
  const SocialWidget(this.icon, this.link, this.OnLongPress);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 25),
      child: GestureDetector(
        onTap: () async {
          final url = Uri.parse(link);
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          } else {
            showDialog(
                context: context,
                builder: ((context) {
                  return ErrorMessage('Error','Sorry this link is unvailable :(');
                }));
          }
        },
        onLongPress: OnLongPress,
        child: SvgPicture.asset(
          'assets/images/$icon.svg',
          height: 22,
          width: 22,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
