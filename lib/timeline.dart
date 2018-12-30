import 'dart:convert';

import 'package:easy_weibo/model/comments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Timeline extends StatefulWidget {
  String access_token;

  Timeline({Key key, @required this.access_token});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TimeLineState();
  }
}

class _TimeLineState extends State<Timeline> {
  int _page = 1;
  List<Comment> _comments = List();

  Future _fetch() async {
    var url =
        "https://api.weibo.com/2/comments/timeline.json?access_token=${widget.access_token}&page=${_page}";

    print(url);

    var response = await http.Client().get(url);
    print(response);

    if (response.statusCode == 200) {
      CommentModel comment = CommentModel(json.decode(response.body));
      setState(() {
        _comments..insertAll(_comments.length, comment.comments.toList());
      });
    } else {}
  }

  Future _fetchMore() {
    _fetch();
  }

  @override
  void initState() {
    // TODO: implement initState

    _controller = ScrollController();

    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _page = _page + 1;

        _fetchMore();
      }
    });

    var url =
        "https://api.weibo.com/2/comments/timeline.json?access_token=${widget.access_token}&page=${_page}";

    print(url);
    _fetch();
  }

  ScrollController _controller;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("发出的"),
          centerTitle: true,
        ),
        body: SafeArea(
            child: ListView.separated(
          itemBuilder: (BuildContext ctx, int index) {
            return _comments[index].commentBuild();
          },
          separatorBuilder: (BuildContext builder, int index) {
            return Divider(
              height: 2,
              color: Colors.grey,
            );
          },
          itemCount: _comments.length,
          controller: _controller,
        )));
  }
}
