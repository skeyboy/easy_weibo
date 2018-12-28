import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String sourceFormat(String source) {
  String subSource = new RegExp(">([^<]*)<").stringMatch(source);
  print(subSource);
  if (subSource == null) {
    return source;
  }
  subSource = subSource.substring(1, subSource.length - 2);
  return subSource;
}

String largePic(String thubnail) {
  return thubnail.replaceRange("http://wx1.sinaimg.cn/".length,
      "http://wx1.sinaimg.cn/thumbnail".length, "large");
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
      picTaped: (int selectedIndex, String url) {
        print(url);
        print(context);
        Navigator.push(context, new MaterialPageRoute(builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: Text("预览"),
              centerTitle: true,
            ),
            body: Hero(
              tag: "pic",
              child: Center(
                child: GridView.count(
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  crossAxisCount: 3,
                  children: picUrls.map<GestureDetector>((String aUrl) {
                    var item = FadeInImage.assetNetwork(
                        placeholder: "images/default_bmiddle.gif",
                        imageScale: .3,
                        image: aUrl);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          final TabController controller =
                              DefaultTabController.of(context);
                          TabPageSelector(controller: controller);
                          final Color color = Theme.of(context).accentColor;

                          void _handleArrowButtonPress(
                              BuildContext context, int delta) {
                            final TabController controller =
                                DefaultTabController.of(context);
                            if (!controller.indexIsChanging)
                              controller.animateTo((controller.index + delta)
                                  .clamp(0, picUrls.length - 1));
                          }

                          var tabVc = DefaultTabController(
                            initialIndex: selectedIndex,
                            length: picUrls.length,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: IconTheme(
                                    data: IconThemeData(
                                      size: 128.0,
                                      color: Colors.white,
                                    ),
                                    child: TabBarView(
                                        controller: controller,
                                        children:
                                            picUrls.map<Widget>((String item) {
                                          return Container(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Card(
                                              child: Center(
                                                child: FadeInImage.assetNetwork(
                                                  placeholder:
                                                      "images/default_bmiddle.gif",
                                                  imageScale: 1,
                                                  image: largePic(item),
                                                  fit: BoxFit.scaleDown,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList()),
                                  ),
                                ),
                                Container(
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          IconButton(
                                              icon: const Icon(
                                                  Icons.chevron_left),
                                              color: color,
                                              onPressed: () {
                                                _handleArrowButtonPress(
                                                    context, -1);
                                              },
                                              tooltip: 'Page back'),
                                          TabPageSelector(
                                              controller: controller),
                                          IconButton(
                                              icon: const Icon(
                                                  Icons.chevron_right),
                                              color: color,
                                              onPressed: () {
                                                _handleArrowButtonPress(
                                                    context, 1);
                                              },
                                              tooltip: 'Page forward')
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween)),
                              ],
                            ),
                          );

                          return Scaffold(
                            body: Center(child: tabVc),
                            appBar: AppBar(
                              title: Text("浏览"),
                              centerTitle: true,
                            ),
                          );
                        }));
                      },
                      child: item,
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        }));

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
          height: 100,
          width: 100,
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
