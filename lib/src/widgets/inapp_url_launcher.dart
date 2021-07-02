import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppUrlLauncer extends StatefulWidget {
  final String title;
  final String url;
  final bool? hideHeader;
  @override
  InAppUrlLauncer(
      {Key? key, required this.title, required this.url, this.hideHeader})
      : super(key: key);
  _InAppUrlLauncerState createState() => new _InAppUrlLauncerState();
}

class _InAppUrlLauncerState extends State<InAppUrlLauncer> {
  // launchUrl(url) async {
  //   if (await canLaunch(url)) {
  //     setState(() {
  //       _flag = false;
  //     });
  //     await launch(url);
  //     setState(() {
  //       _flag = true;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style:
                TextStyle(color: Theme.of(context).appBarTheme.foregroundColor),
          ),
        ),
        body: WebView(
          initialUrl: '${widget.url}',
        ));
  }

  @override
  void dispose() {
    // _controller();
    // _animation1.di
    super.dispose();
  }
}
