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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(color: Colors.white70, fontSize: 20),
          overflow: TextOverflow.ellipsis,
        ),
        _buildPics()
      ],
    );
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
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ));
    }).toList();

    return Padding(
      padding: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: items,
      ),
    );
  }
}
