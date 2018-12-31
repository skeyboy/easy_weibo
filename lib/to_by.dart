import 'dart:convert';

import 'package:easy_weibo/model/comments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ToBy extends StatefulWidget {
  String access_token;

  ToBy({Key key, @required this.access_token});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ToByState();
  }
}

class _ToByState extends State<ToBy> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _filter_by_author = 0;
  TabBarView _tabBarView;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (int index) {
              setState(() {
                _filter_by_author = index;
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<int>(
                  child: Text("所有的"),
                  value: 0,
                ),
                PopupMenuItem<int>(
                  child: Text("我关注的"),
                  value: 1,
                ),
                PopupMenuItem<int>(
                  child: Text("陌生人"),
                  value: 2,
                ),
              ];
            },
          )
        ],
        centerTitle: true,
        title: TabBar(
          isScrollable: true,
          indicatorColor: Colors.red,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black38,
          tabs: [
            Tab(
              text: "收到的",
              icon: Icon(Icons.airline_seat_flat_angled),
            ),
            Tab(
              text: "发出的",
              icon: Icon(Icons.airline_seat_flat_angled),
            ),
            Tab(
              text: "所有的",
              icon: Icon(Icons.select_all),
            )
          ],
          controller: _tabController,
        ),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
              child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              ToByMine(
                access_token: widget.access_token,
                filter_by_author: _filter_by_author,
                url: "https://api.weibo.com/2/comments/to_me.json",
              ),
              ToByMine(
                access_token: widget.access_token,
                filter_by_author: _filter_by_author,
                url: "https://api.weibo.com/2/comments/by_me.json",
              ),
              ToByMine(
                  access_token: widget.access_token,
                  filter_by_author: _filter_by_author,
                  url: "https://api.weibo.com/2/comments/timeline.json")
            ],
          ))
        ],
      ),
    );
  }
}

class ToByMine extends StatefulWidget {
  String access_token;
  String url;
  int filter_by_author;

  ToByMine(
      {Key key,
      @required this.url,
      @required this.filter_by_author = 0,
      @required this.access_token});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ToByMineState();
  }
}

class _ToByMineState extends State<ToByMine> {
  int _page = 1;
  List<Comment> _comments = List();

  void clear() {
    _comments.clear();
  }

  Future _fetch() async {
    var url =
        "${widget.url}?access_token=${widget.access_token}&page=${_page}&filter_by_author=${widget.filter_by_author}";

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
    return SafeArea(
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
    ));
  }
}
