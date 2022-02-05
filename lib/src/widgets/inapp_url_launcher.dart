import 'dart:async';
import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
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
  late InAppWebViewController webView;
  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewGroupOptions _options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useOnDownloadStart: true,
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  bool? iserrorstate = false;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
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

              return connected
                  ? Padding(
                      padding: const EdgeInsets.only(
                          bottom:
                              100.0), // To manage web page crop issue together with bottom nav bar.
                      child: InAppWebView(
                        //initialUserScripts:JavascriptMode.unrestricted,
                        key: webViewKey,
                        initialUrlRequest:
                            URLRequest(url: Uri.parse(widget.url)),
                        initialOptions: _options,
                        pullToRefreshController: pullToRefreshController,
                        onWebViewCreated: (controller) {
                          webViewController = controller;
                        },
                        onLoadStart: (controller, url) {
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                          });
                        },
                        androidOnPermissionRequest:
                            (controller, origin, resources) async {
                          return PermissionRequestResponse(
                              resources: resources,
                              action: PermissionRequestResponseAction.GRANT);
                        },
                        shouldOverrideUrlLoading:
                            (controller, navigationAction) async {
                          // var uri = navigationAction.request.url!;

                          return NavigationActionPolicy.ALLOW;
                        },
                        onLoadStop: (controller, url) async {
                          pullToRefreshController.endRefreshing();
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                          });
                        },
                        onLoadError: (controller, url, code, message) {
                          pullToRefreshController.endRefreshing();
                        },
                        onDownloadStart: (controller, url) async {
                          print(controller);
                          print("onDownloadStart $url");
                          final taskId = await FlutterDownloader.enqueue(
                            url:'http://ovh.net/files/1Mio.dat'
                              ,
                            savedDir:
                                (await getExternalStorageDirectory())!.path,
                            showNotification:
                                true, // show download progress in status bar (for Android)
                            openFileFromNotification:
                                true, // click on notification to open downloaded file (for Android)
                          );
                        },
                        onProgressChanged: (controller, progress) {
                          if (progress == 100) {
                            pullToRefreshController.endRefreshing();
                          }
                          setState(() {
                            this.progress = progress / 100;
                            urlController.text = this.url;
                          });
                        },
                        onUpdateVisitedHistory:
                            (controller, url, androidIsReload) {
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                          });
                        },
                        onConsoleMessage: (controller, consoleMessage) {
                          print(consoleMessage);
                        },
                      ),
                    )

                  //    WebView(
                  //     gestureNavigationEnabled:
                  //         widget.isiFrame == true ? true : false,
                  //     initialUrl: widget.isiFrame == true
                  //         ? Uri.dataFromString('${widget.url}',
                  //                 mimeType: 'text/html')
                  //             .toString()
                  //         : '${widget.url}',
                  //     javascriptMode: JavascriptMode.unrestricted,
                  //     onWebViewCreated:
                  //         (WebViewController webViewController) {
                  //       _controller.complete(webViewController);
                  //     },
                  //   ),
                  // )
                  : NoInternetErrorWidget(
                      connected: connected, issplashscreen: false);
            },
            child: Container()));
  }
}
