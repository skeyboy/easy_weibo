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

  Widget buildReTweeted(BuildContext ctx) {
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
          _buildPics(ctx)
        ],
      ),
    );
  }

  Widget _buildPics(BuildContext ctx) {
    if (pic_urls == null) {
      return Text('');
    }

    return buildPics(ctx, pic_urls, (List<String> pics, int index, String url) {
      return Container(
          margin: EdgeInsets.only(left: 65),
          child: buildPics(ctx, pics,
              (List<String> pics, int index, String url) async {
            //TODO 图片点击回调
            var items = pics.map<Container>((String aUrl) {
              return Container(
                child: Image.network(aUrl),
              );
            }).toList();

            await Navigator.push(ctx,
                MaterialPageRoute(builder: (BuildContext context) {
              return DefaultTabController(
                  length: pics.length,
                  child: GridView.count(crossAxisCount: items.length));
            }));

            print(pics);
          }));
    });
  }
}
