import 'package:easy_weibo/model/user.dart';

class CommentModel {
  var comments = [];

  CommentModel(jsonObj) {
    for (var comment in jsonObj["comments"]) {
      comments.add(Comment(comment));
    }
  }
}

class Comment {
  String text;
  User user;

  Comment(jsonObj) {
    text = jsonObj["text"];
    user = User(jsonObj["user"]);
  }
}
