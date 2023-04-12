import 'dart:async';
import 'dart:io';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as inAppWebView;
import 'package:url_launcher/url_launcher.dart';
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
  final bool? hideAppbar; //To hide the appbar
  // final bool? hideShare; //To hide share icon only from appbar
  final bool isBottomSheet;
  final String? language;
  final bool? isCustomMainPageWebView;
  // final callBackFunction;
  // final bool? zoomEnabled; //To enable or disable the zoom functionality

  @override
  InAppUrlLauncer({
    Key? key,
    required this.title,
    required this.url,
    required this.isBottomSheet,
    required this.language,
    this.hideAppbar,
    // this.hideShare,
    // this.zoomEnabled,
    this.isiFrame,
    this.isCustomMainPageWebView,
    // this.callBackFunction
  }) : super(key: key);
  _InAppUrlLauncerState createState() => new _InAppUrlLauncerState();
}

class _InAppUrlLauncerState extends State<InAppUrlLauncer> {
  bool? isErrorState = false;
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
            appBar: widget.hideAppbar != true
                ? CustomAppBarWidget(
                    isSearch: false,
                    isShare: true, //widget.hideShare != true ? true : false,
                    appBarTitle: widget.title,
                    sharedPopBodyText: widget.url.toString(),
                    sharedPopUpHeaderText: "Please checkout this link",
                    language: Globals.selectedLanguage,
                  )
                : null,
            body: _webViewWidget());
  }

  Widget _iOSWebView() => Container(
        //height is used to manage the bottom web content to not hide
        height: MediaQuery.of(context).size.height * 0.775,
        child: WebView(
          // userAgent: 'random',
          // zoomEnabled: widget.zoomEnabled == null
          //     ? true
          //     : widget.zoomEnabled!,
          initialCookies: [],
          backgroundColor: Theme.of(context).backgroundColor,
          onProgress: (progress) {
            if (progress >= 50) {
              setState(() {
                isLoading = false;
              });
            }
          },
          gestureNavigationEnabled: widget.isiFrame == true ? true : false,
          initialUrl: widget.isiFrame == true
              ? Uri.dataFromString('${widget.url}', mimeType: 'text/html')
                  .toString()
              : '${widget.url}',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            Globals.webViewController1 = webViewController;
            _controller.complete(webViewController);
          },
          navigationDelegate: (NavigationRequest request) {
            // widget.callBackFunction(request.url);
            //print(request);
            return NavigationDecision.navigate;
          },
        ),
      );

  Widget _androidWebView() => Container(
        child: inAppWebView.InAppWebView(
          initialUrlRequest: inAppWebView.URLRequest(
              url: widget.isiFrame == true
                  ? Uri.dataFromString('${widget.url}', mimeType: 'text/html')
                  : Uri.parse(widget.url)),
          // initialUserScripts: UnmodifiableListView<UserScript>([]),
          // initialOptions: inAppWebView.options,
          // pullToRefreshController: pullToRefreshController,

          onWebViewCreated: (controller) {
            // webViewController = controller;
          },
          onLoadStart: (controller, url) {
            // setState(() {
            //   widget.url = url.toString();
            //   urlController.text = widget.url;
            // });
          },
          androidOnPermissionRequest: (controller, origin, resources) async {
            return inAppWebView.PermissionRequestResponse(
                resources: resources,
                action: inAppWebView.PermissionRequestResponseAction.GRANT);
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var uri = navigationAction.request.url!;

            if (![
              "http",
              "https",
              "file",
              "chrome",
              "data",
              "javascript",
              "about"
            ].contains(uri.scheme)) {
              if (await canLaunchUrl(Uri.parse(widget.url))) {
                // Launch the App
                await launchUrl(Uri.parse(widget.url));
                // and cancel the request
                return inAppWebView.NavigationActionPolicy.CANCEL;
              }
            }

            return inAppWebView.NavigationActionPolicy.ALLOW;
          },
          onLoadStop: (controller, url) async {
            // pullToRefreshController.endRefreshing();
            // setState(() {
            //   isLoading = false;
            // });
          },
          onLoadError: (controller, url, code, message) {
            // pullToRefreshController.endRefreshing();
          },
          onLoadHttpError: (controller, url, code, message) {
            // setState(() {
            //   showLoader = false;
            // });
          },
          onProgressChanged: (controller, progress) {
            //print(progress);
            if (progress >= 65) {
              if (isLoading == false) return;
              setState(() {
                isLoading = false;
              });
            }
          },
          onUpdateVisitedHistory: (controller, url, androidIsReload) {
            // setState(() {
            //   widget.url = url.toString();
            //   urlController.text = widget.url;
            // });
          },
          onConsoleMessage: (controller, consoleMessage) {
            //print(consoleMessage);
          },
        ),
      );

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
                  // height: MediaQuery.of(context).size.height,
                  color: Colors.transparent,
                  padding: EdgeInsets.only(
                      bottom: (Globals.isAndroid == true
                          ? (widget.isCustomMainPageWebView == true
                              ? MediaQuery.of(context).size.height * 0.01
                              : MediaQuery.of(context).size.height * 0.031)
                          : MediaQuery.of(context).size.height *
                              0.024)), // To manage web page crop issue together with bottom nav bar.
                  child: Stack(
                    children: [
                      Platform.isAndroid &&
                              widget.isiFrame !=
                                  true //To support iFrame in android
                          ? _androidWebView()
                          : _iOSWebView(),
                      isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
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
