import 'package:easy_weibo/utility/utility.dart';
import 'package:flutter/material.dart';

class RetweetedStatus {
  String created_at;
  String text;
  String source;
  List<String> pic_urls;

  RetweetedStatus(jsonObj) {
    text = jsonObj['text'];
    pic_urls = new List();

    for (var item in jsonObj['pic_urls']) {
      pic_urls.add(item['thumbnail_pic']);
    }
  }

  Widget buildReTweeted() {
    return Container(
      margin: EdgeInsets.only(left: 65),
      alignment: Alignment.topLeft,
//      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(color: Colors.grey, fontSize: 20),
            overflow: TextOverflow.ellipsis,
          ),
          _buildPics()
        ],
      ),
    );
  }

  Widget _buildPics() {
    if (pic_urls == null) {
      return Text('');
    }

    return buildPics(pic_urls, (List<String> pics, int index, String url) {});
  }
}
