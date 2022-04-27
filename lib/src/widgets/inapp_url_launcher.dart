import 'dart:async';
import 'dart:io';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:permission_handler/permission_handler.dart';
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
  final bool? isCustomMainPageWebView;

  @override
  InAppUrlLauncer(
      {Key? key,
      required this.title,
      required this.url,
      required this.isbuttomsheet,
      required this.language,
      this.hideHeader,
      this.isiFrame,
      this.isCustomMainPageWebView})
      : super(key: key);
  _InAppUrlLauncerState createState() => new _InAppUrlLauncerState();
}

class _InAppUrlLauncerState extends State<InAppUrlLauncer> {
  bool? iserrorstate = false;
  bool isLoading = true;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  // Globals.webViewController1 = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // _getPermission();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isCustomMainPageWebView == true
        ? _webViewWidget()
        : Scaffold(
            appBar: CustomAppBarWidget(
              isSearch: false,
              isShare: true,
              appBarTitle: widget.title,
              sharedpopBodytext: widget.url.toString(),
              sharedpopUpheaderText: "Please checkout this link",
              language: Globals.selectedLanguage,
            ),
            body: _webViewWidget());
  }

  Widget _webViewWidget() {
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
              ? Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(
                      bottom:
                          30.0), // To manage web page crop issue together with bottom nav bar.
                  child: Stack(
                    children: [
                      WebView(
                        initialCookies: [],
                        backgroundColor: Theme.of(context).backgroundColor,
                        onProgress: (progress) {
                          if (progress >= 50) {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        gestureNavigationEnabled:
                            widget.isiFrame == true ? true : false,
                        initialUrl: widget.isiFrame == true
                            ? Uri.dataFromString('${widget.url}',
                                    mimeType: 'text/html')
                                .toString()
                            : '${widget.url}',
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated:
                            (WebViewController webViewController) {
                          Globals.webViewController1 = webViewController;
                          _controller.complete(webViewController);
                        },
                      ),
                      isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryVariant,
                              ),
                            )
                          : Stack(),
                    ],
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
