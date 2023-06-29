// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:whisper/screens/authentication/sign_in_screen.dart';
import 'package:whisper/screens/authentication/sign_up_screen.dart';
import 'package:whisper/service/locale_service.dart';
import 'package:whisper/views/chat_screen.dart';
import 'package:whisper/screens/chat/group/group_screen.dart';
import 'package:whisper/screens/profile/group_profile_screen.dart';
import 'package:whisper/screens/starting/get_Started_screen.dart';
import 'package:whisper/screens/starting/slider_screen.dart';
import 'package:whisper/views/splash_screen.dart';
import 'package:whisper/service/friend_service.dart';
import 'package:whisper/service/group_service.dart';
import 'package:whisper/service/posts_services.dart';
import 'package:whisper/service/user_service.dart';
import 'package:whisper/utils/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'views/tab_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Friend()),
      ChangeNotifierProvider(create: (_) => UserService()),
      ChangeNotifierProvider(create: (_) => PostServices()),
      ChangeNotifierProvider(create: (_) => Group()),
      ChangeNotifierProvider(create: (_) => LocaleServices()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleServices>(context).locale;
    return AdaptiveTheme(
        light: ThemeData(
            scaffoldBackgroundColor: klightBG,
            brightness: Brightness.light,
            primarySwatch: prColor,
            fontFamily: 'Poppins',
            primaryColor: kdark,
            primaryColorDark: Color(0xffE7E7F0)),
        dark: ThemeData(
          scaffoldBackgroundColor: kdarkBG,
          brightness: Brightness.dark,
          primarySwatch: prColor,
          fontFamily: 'Poppins',
          primaryColor: kwhite,
          primaryColorDark: Color(0xFF031E2F),
        ),
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
            theme: theme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,
            title: 'Whisper',
            locale: localeProvider,
            supportedLocales: [
              Locale('en'),
              Locale('fr'),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            home: SplashScreen(),
            routes: {
              SignUpScreen.routeName: (ctx) => SignUpScreen(),
              SignInScreen.routeName: (ctx) => SignInScreen(),
              TabScreen.routeName: (ctx) => TabScreen(0),
              SliderScreen.routeName: (ctx) => SliderScreen(),
              GroupScreen.routeName: (ctx) => GroupScreen(),
              ChatScreen.routeName: (ctx) => ChatScreen(),
              GroupProfileScreen.routeName: (ctx) => GroupProfileScreen(''),
              GetStartedScreen.routeName: (ctx) => GetStartedScreen(),
            }));
  }
}
