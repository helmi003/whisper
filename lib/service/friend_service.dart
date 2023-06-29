import 'package:flutter/cupertino.dart';

class Friend with ChangeNotifier {
  Map<String, dynamic> friend = {};
  List<Map<String, dynamic>> friends = [];

  setFriend(Map<String, dynamic> friend2,String id) {
    friend = friend2;
    friend['id'] = id;
    notifyListeners();
  }

  List<Map<String, dynamic>> setFriends(List<Map<String, dynamic>> friends2) {
    friends = friends2;
    notifyListeners();
    return friends;
  }
}
