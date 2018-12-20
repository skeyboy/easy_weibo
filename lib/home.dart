import 'package:easy_weibo/model/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  String title;
  var tokenInfo;

  Home({Key key, this.tokenInfo, this.title});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  bool _refresh = false;

  int _counter = 0;
  EventChannel _eventChannel =
      const EventChannel("App/Event/token", const StandardMethodCodec());
  dynamic _timeLineValue;
  List<TimeLine> _timeLines = new List();

  void _getMore() {
    _page = _page + 1;
    _fetch();
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller = new ScrollController();

    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _getMore();
      }
    });
    _fetch();
  }

  int _page = 1;
  int _count = 50;
  ScrollController _controller;

  Future _fetch() async {
    var time_line =
        "https://api.weibo.com/2/statuses/home_timeline.json?page=$_page&count=$_count&&access_token=" +
            widget.tokenInfo['access_token'];
    print(time_line);

    final response = await new http.Client().get(time_line);
    if (response.statusCode == 200) {
      HomeModel homeModel = HomeModel(response.body);

      //判断获取的是否为空
      if (homeModel.statuses.isEmpty) {
      } else {
        setState(() {
          var tmpItems = homeModel.statuses.map((item) {
            return item;
          });

          if (_refresh) {
            _timeLines..insertAll(0, tmpItems);
          } else {
            _timeLines..addAll(tmpItems);
          }
          _refresh = false;

          _timeLineValue = response.body;
        });
      }
    } else {
      setState(() {
        _timeLineValue = response.body;
      });
    }

    return response.body;
  }

  Widget _centerView() {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('$_timeLineValue'),
          Text(
            'You have pushed the button this many times:',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _timeLines.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLines.isEmpty) {
      return Scaffold(
        body: _centerView(),
      );
    } else {
      return Scaffold(
          body: ListView.builder(
            itemBuilder: (BuildContext ctx, int index) {
              TimeLine timeLine = _timeLines[index];
              return timeLine.buildTimelineRow(context);
            },
            itemCount: _timeLines.length,
            controller: _controller,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _controller.animateTo(0,
                  duration: Duration(milliseconds: 500), curve: Curves.linear);
              setState(() {
                _refresh = false;
//                _fetch();
              });
            },
            child: Icon(Icons.arrow_upward),
          ));
    }
  }
}
