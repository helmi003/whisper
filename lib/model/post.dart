class Post {
  final String photo;
  final String name;
  final String time;
  final String message;
  final String image;
  final int likes;
  // final List<Map<String, dynamic>> comments;
  Post(
    this.photo,
    this.name,
    this.time,
    this.message,
    this.image,
    this.likes,
    // this.comments
  );

   Post.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        photo = json['photo'],
        time = json['time'],
        message = json['message'],
        image = json['image'],
        likes = json['likes'];
        // comments = json['comments'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'photo': photo,
        'time': time,
        'message': message,
        'image': image,
        'likes': likes,
        // 'comments': comments,
      };
}
