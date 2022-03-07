import 'dart:async';
import 'dart:io';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class HomeInAppUrlLauncer extends StatefulWidget {
  final bool? isiFrame;
  final String url;

  final String? language;
  @override
  HomeInAppUrlLauncer(
      {Key? key, required this.url, required this.language, this.isiFrame})
      : super(key: key);
  _HomeInAppUrlLauncerState createState() => new _HomeInAppUrlLauncerState();
}

class _HomeInAppUrlLauncerState extends State<HomeInAppUrlLauncer> {
  bool? iserrorstate = false;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    // _getPermission();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
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
              ? Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(
                        bottom:
                            30.0), // To manage web page crop issue together with bottom nav bar.
                    child:
                        //  WebviewScaffold(
                        //   mediaPlaybackRequiresUserGesture: true,
                        //   supportMultipleWindows: true,
                        //   withJavascript: true,
                        //   withLocalUrl: true,
                        //   withLocalStorage: true,
                        //   allowFileURLs: true,
                        //   url: widget.isiFrame == true
                        //       ? Uri.dataFromString(widget.url,
                        //               mimeType: 'text/html')
                        //           .toString()
                        //       : widget.url,
                        // )
                        WebView(
                      gestureNavigationEnabled:
                          widget.isiFrame == true ? true : false,
                      initialUrl: widget.isiFrame == true
                          ? Uri.dataFromString(widget.url, mimeType: 'text/html')
                              .toString()
                          : widget.url,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        _controller.complete(webViewController);
                      },
                    ),
                  ),
              )
              : NoInternetErrorWidget(
                  connected: connected, issplashscreen: false);
        },
        child: Container());
  }

  // _getPermission() async {
  //   await Permission.storage.request();
  // }
}
