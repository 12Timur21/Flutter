class User {
  late int userId;
  late int id;
  late String title;
  late String body;

  User({required userId, required id, required title, required body});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'id': id,
        'title': title,
        'body': body,
      };
}
