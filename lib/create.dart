import 'dart:convert';

import 'package:easy_weibo/model/comments.dart';
import 'package:easy_weibo/model/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Create extends StatelessWidget {
  final Widget timeLineWidget;
  final TimeLine timeLine;
  final String access_token;

  Create(
      {Key key,
      @required this.timeLineWidget,
      @required this.timeLine,
      @required this.access_token})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (timeLine.user == null) {
      return Scaffold(
        body: Center(
          child: Text("${timeLine.user}"),
        ),
      );
    }

    String name = timeLine.user.name;

    return Scaffold(
      appBar: AppBar(
        title: Text("评论${timeLine.idstr}"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              this.timeLineWidget,
              Container(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '留个痕迹',
                        helperText: "输入",
                        labelText: 'Life story',
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              Commnets(
                access_token: access_token,
                id: timeLine.id,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Commnets extends StatefulWidget {
  final String access_token;
  var id;

  Commnets({this.access_token, this.id});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CommentsSate();
  }
}

class _CommentsSate extends State<Commnets> {
  var _page = 1;
  var _comments = null;
  CommentModel commnetModel;

  Future<String> fetchdata() async {
    var url =
        "https://api.weibo.com/2/comments/show.json?access_token=${widget.access_token}&page=${_page}&id=${widget.id}";
    print(url);

    var response = await http.Client().get(url);

    if (response.statusCode == 200) {
      setState(() {
        _comments = response.body;
        var jsonMap = json.decode(_comments);
        commnetModel = CommentModel(jsonMap);
      });
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (_comments == null) {
      return Center(
        child: Text("loading…"),
      );
    }
    return Column(
      children: commnetModel.comments.map<Widget>((item) {
        Comment aItem = item;
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    aItem.text,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  )
                ],
              ))
            ],
          ),
        );

//        return Text(item.text);
      }).toList(),
    );
  }
}
