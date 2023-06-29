import 'package:flutter/cupertino.dart';

class Group with ChangeNotifier {
  Map<String, dynamic> group = {};

  setGroup(Map<String, dynamic> group2) {
    group = group2;
    notifyListeners();
  }

  updateGroupMembers(List memebers) {
    group['members'] = memebers;
    notifyListeners();
  }

  updateGroup(List memebers, String name, String photo) {
    group['members'] = memebers;
    group['name'] = name;
    group['photo'] = photo;
    notifyListeners();
  }
}
