import 'package:Soc/src/globals.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
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
  bool? iserrorstate = false;

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
        body: OfflineBuilder(
            connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
            ) {
              final bool connected = connectivity != ConnectivityResult.none;

              if (connected) {
                if (iserrorstate == true) {
                  iserrorstate = false;
                }
              } else if (!connected) {
                iserrorstate = true;
              }

              return new Stack(fit: StackFit.expand, children: [
                connected
                    ? WebView(
                        initialUrl: '${widget.url}',
                      )
                    : NoInternetErrorWidget(
                        connected: connected, issplashscreen: false),
              ]);
            },
            child: Container()));
  }
}
