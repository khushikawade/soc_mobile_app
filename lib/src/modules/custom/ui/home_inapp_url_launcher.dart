import 'dart:async';
import 'dart:io';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:Soc/src/globals.dart';
import 'package:flutter/rendering.dart';
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
                  child: ListView(children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: WebView(
                        gestureNavigationEnabled:
                            widget.isiFrame == true ? true : false,
                        initialUrl: widget.isiFrame == true
                            ? Uri.dataFromString(widget.url,
                                    mimeType: 'text/html')
                                .toString()
                            : widget.url,
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated:
                            (WebViewController webViewController) {
                          _controller.complete(Globals.webViewController);
                          
                        },
                      ),
                    ),
                  ]),
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
