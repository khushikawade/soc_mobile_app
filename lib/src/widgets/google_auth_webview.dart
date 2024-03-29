import 'dart:async';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class GoogleAuthWebview extends StatefulWidget {
  final bool? isiFrame;
  final String title;
  final String url;
  final bool? hideAppbar; //To hide the appbar
  final bool? hideShare; //To hide share icon only from appbar
  final bool isBottomSheet;
  final String? language;
  final bool? isCustomMainPageWebView;
  // final callBackFunction;
  final bool? zoomEnabled; //To enable or disable the zoom functionality

  @override
  GoogleAuthWebview({
    Key? key,
    required this.title,
    required this.url,
    required this.isBottomSheet,
    required this.language,
    this.hideAppbar,
    this.hideShare,
    this.zoomEnabled,
    this.isiFrame,
    this.isCustomMainPageWebView,
    // this.callBackFunction
  }) : super(key: key);
  _GoogleAuthWebviewState createState() => new _GoogleAuthWebviewState();
}

class _GoogleAuthWebviewState extends State<GoogleAuthWebview> {
  bool? isErrorState = false;
  bool isLoading = true;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  // Globals.webViewController1 = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
    //To clear the account session from the web browser
    Globals.webViewController1!.clearCache();
    final cookieManager = CookieManager();
    cookieManager.clearCookies();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isCustomMainPageWebView == true
        ? _webViewWidget()
        : Scaffold(
            appBar: widget.hideAppbar != true
                ? CustomAppBarWidget(
                    isSearch: false,
                    isShare: widget.hideShare != true ? true : false,
                    appBarTitle: widget.title,
                    sharedPopBodyText: widget.url.toString(),
                    sharedPopUpHeaderText: "Please checkout this link",
                    language: Globals.selectedLanguage,
                  )
                : null,
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
            if (isErrorState == true) {
              isErrorState = false;
            }
          } else if (!connected) {
            isErrorState = true;
          }

          return connected
              ? Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(
                    bottom: 30.0,
                  ), // To manage web page crop issue together with bottom nav bar.
                  child: Stack(
                    children: [
                      new WebView(
                        userAgent: 'random',
                        zoomEnabled: widget.zoomEnabled == null
                            ? true
                            : widget.zoomEnabled!,
                        initialCookies: [],
                        backgroundColor: Theme.of(context).backgroundColor,
                        onProgress: (progress) {
                          if (progress >= 30) {
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

                          webViewController.clearCache();
                          final cookieManager = CookieManager();
                          cookieManager.clearCookies();
                        },
                        navigationDelegate: (NavigationRequest request) {
                          // widget.callBackFunction(request.url);
                          //print("Changed URL::::::");
                          //print(request.url);
                          if (request.url.toString().contains('success')) {
                            //(request.url.toString().contains('displayName')) {
                            Navigator.pop(context, request.url);
                          }
                          return NavigationDecision.navigate;
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
                  connected: connected, isSplashScreen: false);
        },
        child: Container());
  }
}
