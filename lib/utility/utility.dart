import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String sourceFormat(String source) {
  String subSource = new RegExp(">([^<]*)<").stringMatch(source);

  subSource = subSource.substring(1, subSource.length - 2);
  return subSource;
}

// onTap  onTap(picUrls, index, url);
Widget buildPics(BuildContext context, List<String> picUrls, Function onTap) {
  if (picUrls == null) {
    return Text('');
  }
  var index = 0;
  var items = picUrls.map<Pic>((String url) {
    return Pic(
      index: index++,
      url: url.replaceRange("http://wx1.sinaimg.cn/".length,
          "http://wx1.sinaimg.cn/thumbnail".length, "bmiddle"),
      picTaped: (int index, String url) {
        print(url);
        print(context);

        if (onTap != null) {
          onTap(picUrls, index, url);
        }
      },
    );
  }).toList();
  return Wrap(
    spacing: 5,
    runSpacing: 5,
    children: items,
  );
}

class Pic extends StatefulWidget {
  int index;
  String url;

  //作为pic图片的容器
  Function picTaped;

  Pic({Key key, this.index, this.url, this.picTaped});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PicState();
  }
}

class _PicState extends State<Pic> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: FadeInImage.assetNetwork(
          height: 200,
          width: 200,
          placeholder: 'assets/default_bmiddle.gif',
          image: widget.url,
        ),
      ),
      onTap: () {
        widget.picTaped(widget.index, widget.url);
      },
    );
  }
}
