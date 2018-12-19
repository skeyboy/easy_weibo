import 'dart:convert' as json;

import 'package:easy_weibo/utility/utility.dart';
import 'package:flutter/material.dart';

import 'retweeted_status.dart';
import 'user.dart';

class HomeModel {
  List<TimeLine> statuses;
  List<dynamic> advertises;
  List<dynamic> ad;

  bool hasvisible;
  int previous_cursor;
  int next_cursor;
  int total_number;
  int interval;
  int uve_blank;
  int since_id;
  int max_id;
  int has_unread;

  HomeModel(jsonStr) {
    var home_timeline = json.jsonDecode(jsonStr);
    hasvisible = home_timeline["hasvisible"];
    previous_cursor = home_timeline["previous_cursor"];
    next_cursor = home_timeline["next_cursor"];
    total_number = home_timeline["total_number"];
    interval = home_timeline["interval"];
    uve_blank = home_timeline["uve_blank"];
    since_id = home_timeline["since_id"];

    max_id = home_timeline["max_id"];
    since_id = home_timeline["since_id"];
    statuses = new List();

    for (var item in home_timeline['statuses']) {
      statuses.add(TimeLine(item));
    }
  }

  @override
  String toString() {
    // TODO: implement toString
    return super.toString() + '$statuses';
  }
}

class TimeLine {
  String created_at;
  int id;
  String text;
  int textLength;
  int source_allowclick;
  int source_type;
  String source;
  List<String> pic_urls;

  User user;
  RetweetedStatus retweeted_status;

  TimeLine(jsonObj) {
    created_at = jsonObj['created_at'];
    source = jsonObj['source'];

    text = jsonObj['text'];

    user = User(jsonObj['user']);
    if (jsonObj['retweeted_status'] != null) {
      retweeted_status = RetweetedStatus(jsonObj['retweeted_status']);
    }

    source_type = jsonObj['source_type'];
    pic_urls = new List();
    //图片
    for (var item in jsonObj['pic_urls']) {
      pic_urls.add(item['thumbnail_pic']);
    }
  }

  @override
  String toString() {
    // TODO: implement toString
    return super.toString() + '$text';
  }

  Widget _buildPics() {
    if (pic_urls == null) {
      return Text('');
    }
    var items = pic_urls.map<Padding>((String url) {
      return Padding(
          padding: EdgeInsets.all(5),
          child: Image.network(
            url,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ));
    }).toList();

    return Padding(
      padding: EdgeInsets.only(left: 65, top: 5, bottom: 5, right: 65),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: items,
      ),
    );
  }

  //底部工具栏

  Widget _buildBottom() {
    return Padding(
      padding: EdgeInsets.only(
        left: 100,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: IconButton(icon: Icon(Icons.share), onPressed: () {}),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: IconButton(icon: Icon(Icons.comment), onPressed: () {}),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: IconButton(icon: Icon(Icons.favorite), onPressed: () {}),
          ),
        ],
      ),
    );
  }

  Widget buildTimelineRow() {
    //从<a href=\"http://weibo.com/\" rel=\"nofollow\">小掌 iPhone 7</a>提取
    String subSource = sourceFormat(this.source);

    Widget reTweeted;
    if (this.retweeted_status != null) {
      reTweeted = this.retweeted_status.buildReTweeted();
    } else {
      reTweeted = Text('none');
    }
    print(this.retweeted_status);

    String crateTime = this.created_at;

    var row = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Image.network(
          this.user.profile_image_url,
          width: 65,
          height: 65,
        ),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //ToDo
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    this.user.name,
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text('$crateTime  $subSource')
                ],
              ),
              Text(
                this.text,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ],
    );

    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[row, _buildPics(), reTweeted, _buildBottom()],
    );
  }
}
