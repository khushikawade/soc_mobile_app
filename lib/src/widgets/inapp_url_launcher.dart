import 'dart:async';
import 'dart:io';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class InAppUrlLauncer extends StatefulWidget {
  final bool? isiFrame;
  final String title;
  final String url;
  final bool? hideHeader;
  final bool isbuttomsheet;
  final String? language;
  @override
  InAppUrlLauncer(
      {Key? key,
      required this.title,
      required this.url,
      required this.isbuttomsheet,
      required this.language,
      this.hideHeader,
      this.isiFrame})
      : super(key: key);
  _InAppUrlLauncerState createState() => new _InAppUrlLauncerState();
}

class _InAppUrlLauncerState extends State<InAppUrlLauncer> {
  bool? iserrorstate = false;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    _getPermission();
    //  if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  String u = "https://formstack.io/133A5";
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

              return connected
                  ? Padding(
                      padding: const EdgeInsets.only(
                          bottom:
                              30.0), // To manage web page crop issue together with bottom nav bar.
                      child: 
                      WebviewScaffold(
                        supportMultipleWindows: true,
                        withJavascript: true,
                        withLocalUrl: true,
                        withLocalStorage: true,
                        allowFileURLs: true,
                        url: widget.isiFrame==true?
                        Uri.dataFromString(widget.url,mimeType: 'text/html').toString():
                         widget.url,
                      )

                      //  WebView(
                      //   gestureNavigationEnabled:
                      //       widget.isiFrame == true ? true : false,
                      //   initialUrl: widget.isiFrame == true
                      //       ? Uri.dataFromString(u,
                      //               mimeType: 'text/html')
                      //           .toString()
                      //       : u,
                      //   javascriptMode: JavascriptMode.unrestricted,
                      //   onWebViewCreated:
                      //       (WebViewController webViewController) {
                      //     _controller.complete(webViewController);
                      //   },

                      // ),
                      )
                  : NoInternetErrorWidget(
                      connected: connected, issplashscreen: false);
            },
            child: Container()));
  }

  _getPermission() async {
    await Permission.storage.request();
  }
}
