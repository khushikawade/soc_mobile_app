import 'package:Soc/src/widgets/app_bar.dart';
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
  void initState() {
    print(widget.url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: CustomAppBarWidget(
          isSearch: false,
          isShare: true,
          sharedpopBodytext: widget.url.toString(),
          sharedpopUpheaderText: "Please checkout this link",
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
