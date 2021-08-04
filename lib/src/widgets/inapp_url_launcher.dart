import 'package:Soc/src/globals.dart';
import 'package:Soc/src/widgets/app_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppUrlLauncer extends StatefulWidget {
  final String title;
  final String url;
  final bool? hideHeader;
  bool isbuttomsheet;
  String? language;
  @override
  InAppUrlLauncer(
      {Key? key,
      required this.title,
      required this.url,
      this.hideHeader,
      required this.isbuttomsheet,
      required this.language})
      : super(key: key);
  _InAppUrlLauncerState createState() => new _InAppUrlLauncerState();
}

class _InAppUrlLauncerState extends State<InAppUrlLauncer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: CustomAppBarWidget(
        isSearch: false,
        isShare: true,
        appBarTitle: widget.title,
        sharedpopBodytext: widget.url.toString(),
        sharedpopUpheaderText: "Please checkout this link",
        language: Globals.selectedLanguage,
      ),
      body: WebView(
        initialUrl: '${widget.url}',
      ),
    );
  }
}
