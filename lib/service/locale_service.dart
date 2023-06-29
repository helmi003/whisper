// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';

class LocaleServices extends ChangeNotifier {
  late Locale _locale = Locale('en');
  Locale get locale => _locale;
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
