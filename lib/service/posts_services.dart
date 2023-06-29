import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:whisper/model/post.dart';

class PostServices with ChangeNotifier {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  List<Map<String, dynamic>> posts = [];
  Map<String, dynamic> post = {};
  List<Map<String, dynamic>> tags = [];
  Future<List<Post>> getPostsList() {
    try {
      Future<List<Post>> posts = FirebaseFirestore.instance
          .collection("posts")
          .snapshots()
          .map((dynamic item) => Post.fromJson(item))
          .toList();
      return posts;
    } catch (e) {
      rethrow;
    }
  }

  checkLikes(String id, String uid) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(id)
        .collection('likedBy')
        .doc(uid)
        .snapshots();
  }

  addPost(String message, String photo, List tags) async {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    FirebaseFirestore.instance.collection("posts").add({
      'owner': email,
      'message': message,
      'photo': photo,
      'tags': tags,
      'time': DateTime.now(),
      'likes': 0,
      'likedBy': []
    });
  }

  setPosts(posts1) {
    posts = posts1;
    notifyListeners();
  }

  setPost(String postID, String photo, String name, List tags, DateTime time,
      String message, String image, int likes, Color color, bool close) {
    post = {
      "PostID": postID,
      "photo": photo,
      "name": name,
      "tags": tags,
      "time": time,
      "message": message,
      "image": image,
      "likes": likes,
      "color": color,
      "close": close
    };
    notifyListeners();
  }

  changePostLikeColor(Color color) {
    post['color'] = color;
    notifyListeners();
  }

  addPostLike(int nb) {
    post['likes'] = nb;
    notifyListeners();
  }

  tagedFriends(List<Map<String, dynamic>> tags2) {
    tags = tags2;
    notifyListeners();
  }
}
