import 'package:easy_weibo/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var tokenInfo;
  int _currentIndex = 0;
  final List<Widget> _pages = new List();
  EventChannel _eventChannel =
      const EventChannel("App/Event/token", const StandardMethodCodec());

  @override
  void initState() {
    // TODO: implement initState
//    _pages = new List();
    _eventChannel
        .receiveBroadcastStream("init")
        .listen(_onEvent, onError: _onError);
    super.initState();

    setState(() {
      _currentIndex = 0;
    });
  }

  // 数据接收
  void _onEvent(Object value) {
    print(value);
    setState(() {
      tokenInfo = value;
      _pages.add(Home(tokenInfo: tokenInfo));
      _pages.add(Home(
        tokenInfo: tokenInfo,
      ));
    });
  }

// 错误处理
  void _onError(dynamic) {}

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (tokenInfo == null) {
      return Scaffold(
        body: Center(
          child: Text('Loading:$tokenInfo'),
        ),
      );
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home"))
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
    );
  }
}
