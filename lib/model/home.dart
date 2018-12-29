import 'dart:convert' as json;

import 'package:easy_weibo/create.dart';
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
  String idstr;
  String text;
  int textLength;
  int source_allowclick;
  int source_type;
  int attitudes_count;

  //评论
  int comments_count;

//  转发
  int reposts_count;

  String source;
  List<String> pic_urls;

  User user;
  RetweetedStatus retweeted_status;

  TimeLine(jsonObj) {
    id = jsonObj["id"];
    idstr = jsonObj["idstr"];

    created_at = jsonObj['created_at'];
    source = jsonObj['source'];

    text = jsonObj['text'];

    user = User(jsonObj['user']);
    if (jsonObj['retweeted_status'] != null) {
      retweeted_status = RetweetedStatus(jsonObj['retweeted_status']);
    }

    source_type = jsonObj['source_type'];
    var tmpCommentsCount = jsonObj['comments_count'];
    if (tmpCommentsCount == null || tmpCommentsCount == 0) {
      comments_count = 1;
    } else {
      comments_count = tmpCommentsCount;
    }
    var tmprepostsCount = jsonObj['reposts_count'];
    if (tmprepostsCount == null || tmprepostsCount == 0) {
      reposts_count = 1;
    } else {
      reposts_count = tmprepostsCount;
    }

    attitudes_count = jsonObj['attitudes_count'];

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

  Widget _buildPics(BuildContext ctx) {
    if (pic_urls == null) {
      return Text('');
    }
    return Container(
        margin: EdgeInsets.only(left: 65),
        child: buildPics(ctx, pic_urls,
            (List<String> pics, int index, String url) async {
          //TODO 图片点击回调

          var items = pics.map<Container>((String aUrl) {
            return Container(
              child: Image.network(aUrl),
            );
          }).toList();

//          Navigator.push(ctx, new MaterialPageRoute(builder: (_) {
//            return new Scaffold(
//              body: GridView.count(
//                crossAxisCount: items.length,
//                children: items,
//              ),
//            );
//          }));
        }));
  }

  //底部工具栏

  Widget _buildBottom(BuildContext ctx, Widget aWidget, String access_token) {
    return Padding(
      padding: EdgeInsets.only(
        left: 65,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: GestureDetector(
                onTap: () {
                  // TODO
                },
                child: Chip(
                    label: Text('$reposts_count'), avatar: Icon(Icons.share))),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: GestureDetector(
                onTap: () {
                  // TODO 发送评论
                  Navigator.push(ctx, new MaterialPageRoute(builder: (_) {
                    return Create(
                      timeLineWidget: aWidget,
                      timeLine: this,
                      access_token: access_token,
                    );
                  }));
                },
                child: Chip(
                    label: Text('$comments_count'),
                    avatar: Icon(Icons.comment))),
          ),

          ///attitudes_count
          Padding(
            padding: EdgeInsets.all(5),
            child: GestureDetector(
                onTap: () {
                  // TODO
                },
                child: Chip(
                    label: Text('$attitudes_count'),
                    avatar: Icon(Icons.thumb_up))),
          ),
        ],
      ),
    );
  }

  Widget buildTimelineRow(
      BuildContext ctx, String access_token, TimeLine timeLine) {
    //从<a href=\"http://weibo.com/\" rel=\"nofollow\">小掌 iPhone 7</a>提取
    String subSource = sourceFormat(this.source);

    Widget reTweeted;
    if (this.retweeted_status != null) {
      reTweeted = this.retweeted_status.buildReTweeted(ctx);
    } else {
      reTweeted = Text('');
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

    var aItem = new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        row,
        _buildPics(ctx),
        reTweeted,
      ],
    );

    var content = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[aItem, _buildBottom(ctx, aItem, access_token)],
    );

    return GestureDetector(
      child: content,
      onTap: () {
        Navigator.push(ctx, new MaterialPageRoute(builder: (_) {
          return Create(
            timeLineWidget: aItem,
            access_token: access_token,
            timeLine: timeLine,
          );
        }));
      },
    );
  }
}
