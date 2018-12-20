import 'package:flutter/material.dart';

class PicScanner extends StatelessWidget {
  final List<String> pics;
  final int index;

  PicScanner({Key key, this.pics, this.index});

  void _handleArrowButtonPress(BuildContext context, int delta) {
    final TabController controller = DefaultTabController.of(context);
    if (!controller.indexIsChanging)
      controller
          .animateTo((controller.index + delta).clamp(0, pics.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text("$pics $index"),
      ),
    );

    final TabController controller = DefaultTabController.of(context);
    final Color color = Theme.of(context).accentColor;
    return Column(
      children: <Widget>[
        Container(
            margin: const EdgeInsets.only(top: 16.0),
            child: Row(children: <Widget>[
              IconButton(
                  icon: const Icon(Icons.chevron_left),
                  color: color,
                  onPressed: () {
                    _handleArrowButtonPress(context, -1);
                  },
                  tooltip: 'Page back'),
              TabPageSelector(controller: controller),
              IconButton(
                  icon: const Icon(Icons.chevron_right),
                  color: color,
                  onPressed: () {
                    _handleArrowButtonPress(context, 1);
                  },
                  tooltip: 'Page forward')
            ], mainAxisAlignment: MainAxisAlignment.spaceBetween)),
        Expanded(
          child: IconTheme(
            data: IconThemeData(
              size: 128.0,
              color: color,
            ),
            child: TabBarView(
                children: pics.map<Container>((String url) {
              return Container(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  child: Center(
                    child: FadeInImage.assetNetwork(
                      height: 200,
                      width: 200,
                      placeholder: 'assets/default_bmiddle.gif',
                      image: url,
                    ),
                  ),
                ),
              );
            }).toList()),
          ),
        ),
      ],
    );
  }
}
