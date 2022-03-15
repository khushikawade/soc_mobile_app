import 'dart:async';
import 'dart:io';

// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:Soc/src/globals.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
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
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  // WebViewController webViewController;
  String? checkUrlChange;
  @override
  void initState() {
    super.initState();
    checkUrlChange = widget.url;
    // _getPermission();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
          key: refreshKey,
          child: OfflineBuilder(
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
                    ? ListView(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                            Container(
                              // height: webHight + 20,
                              height: MediaQuery.of(context).size.height,
                              // width: MediaQuery.of(context).size.width,
                              child: WebView(
                                //gestureRecognizers: Set()..add(Factory<VerticalDragGestureRecognizer>(()=>VerticalDragGestureRecognizer())),
                                gestureRecognizers: Set()
                                  ..add(Factory<VerticalDragGestureRecognizer>(
                                      () => VerticalDragGestureRecognizer()
                                        ..onDown =
                                            (DragDownDetails dragDownDetails) {
                                          Globals.webViewController1!
                                              .getScrollY()
                                              .then((value) {
                                            if (value == 0 &&
                                                dragDownDetails.globalPosition
                                                        .direction <
                                                    1) {
                                              refreshPage();
                                            }
                                          });
                                        })),

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
                                  _controller.complete(webViewController);
                                  Globals.webViewController1 =
                                      webViewController;
                                },
                              ),
                            ),
                          ])
                    : NoInternetErrorWidget(
                        connected: connected, issplashscreen: false);
              },
              child: Container()),
          onRefresh: refreshPage),
    );
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    Globals.webViewController1!.reload();
    if (checkUrlChange == widget.url) {
      Globals.webViewController1!.reload();
      checkUrlChange = widget.url;
    } else {
      Globals.webViewController1!.loadUrl(widget.url);
      checkUrlChange = widget.url;
    }
  }

  // String? hight;
  // double webHight = 400; //default some value
  // Future funcThatMakesAsyncCall() async {
  //   var result = await Globals.webViewController1!
  //       .evaluateJavascript('document.body.scrollHeight');
  //   //here we call javascript for get browser data
  //   setState(
  //     () {
  //       hight = result;
  //     },
  //   );
  // }

  // _getPermission() async {
  //   await Permission.storage.request();
  // }
}
