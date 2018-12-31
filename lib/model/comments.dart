import 'package:easy_weibo/model/user.dart';
import 'package:flutter/material.dart';

class CommentModel {
  List<Comment> comments = [];

  CommentModel(jsonObj) {
    for (var comment in jsonObj["comments"]) {
      comments.add(Comment(comment));
    }
  }
}

class ReplyComment {
  User user;
  String text;

  ReplyComment(jsonObj) {
    user = User(jsonObj["user"]);
    text = jsonObj["text"];
  }
}

class Comment {
  String text;
  User user;
  ReplyComment reply_comment;

  Comment(jsonObj) {
    text = jsonObj["text"];
    user = User(jsonObj["user"]);
    if (jsonObj['reply_comment'] != null) {
      reply_comment = ReplyComment(jsonObj["reply_comment"]);
    }
  }

  Widget commentBuild() {
    Comment aItem = this;
    Widget sub = Text("");

    if (reply_comment != null) {
      sub = Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        color: Colors.white10,
        child: Text(
          "${reply_comment.user.screen_name}@${reply_comment.text}",
          style: TextStyle(fontWeight: FontWeight.w200, fontSize: 20),
        ),
      );
    }
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            child: Image.network(aItem.user.profile_image_url),
          ),
          Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    aItem.user.screen_name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  Text(
                    aItem.text,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 23),
                  ),
                  sub
                ],
              ))
        ],
      ),
    );
  }
}
