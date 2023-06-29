// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whisper/service/locale_service.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({super.key});

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

enum SingingCharacter { english, french }

class _LanguagesScreenState extends State<LanguagesScreen> {
  SingingCharacter? lang;
  @override
  Widget build(BuildContext context) {
    Locale loc = Provider.of<LocaleServices>(context).locale;
    lang = loc == Locale('en')
        ? SingingCharacter.english
        : SingingCharacter.french;
    return Scaffold(
      appBar: appBar(context, 'Change language'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: SvgPicture.asset(
              'assets/images/UK_flag.svg',
              semanticsLabel: 'UK_flag',
              height: 25,
            ),
            title: Text(
              AppLocalizations.of(context)!.english,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            trailing: Radio<SingingCharacter>(
              fillColor: MaterialStateColor.resolveWith((states) => kred),
              value: SingingCharacter.english,
              groupValue: lang,
              onChanged: (SingingCharacter? value) {
                setState(() {
                  lang = value;
                });
                Provider.of<LocaleServices>(context, listen: false)
                    .setLocale(Locale('en'));
              },
            ),
          ),
          ListTile(
            leading: SvgPicture.asset(
              'assets/images/FR_flag.svg',
              semanticsLabel: 'FR_flag',
              height: 30,
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                AppLocalizations.of(context)!.french,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            trailing: Radio<SingingCharacter>(
              fillColor: MaterialStateColor.resolveWith((states) => kred),
              value: SingingCharacter.french,
              groupValue: lang,
              onChanged: (SingingCharacter? value) {
                setState(() {
                  lang = value;
                });
                Provider.of<LocaleServices>(context, listen: false)
                    .setLocale(Locale('fr'));
              },
            ),
          )
        ],
      ),
    );
  }
}
