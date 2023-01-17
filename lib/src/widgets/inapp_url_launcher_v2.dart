// import 'dart:collection';
// import 'dart:io';
// // import 'package:permission_handler/permission_handler.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:Soc/src/globals.dart';
// import 'package:Soc/src/widgets/app_bar.dart';
// import 'package:Soc/src/widgets/network_error_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_offline/flutter_offline.dart';
// import 'package:url_launcher/url_launcher.dart';

// class InAppUrlLauncerV2 extends StatefulWidget {
//   final bool? isiFrame;
//   final String title;
//   final String url;
//   final bool? hideAppbar; //To hide the appbar
//   // final bool? hideShare; //To hide share icon only from appbar
//   final bool isBottomSheet;
//   final String? language;
//   final bool? isCustomMainPageWebView;
//   // final callBackFunction;
//   // final bool? zoomEnabled; //To enable or disable the zoom functionality

//   @override
//   InAppUrlLauncerV2({
//     Key? key,
//     required this.title,
//     required this.url,
//     required this.isBottomSheet,
//     required this.language,
//     this.hideAppbar,
//     // this.hideShare,
//     // this.zoomEnabled,
//     this.isiFrame,
//     this.isCustomMainPageWebView,
//     // this.callBackFunction
//   }) : super(key: key);
//   _InAppUrlLauncerV2State createState() => new _InAppUrlLauncerV2State();
// }

// class _InAppUrlLauncerV2State extends State<InAppUrlLauncerV2> {
//   bool? isErrorState = false;
//   InAppWebViewController? webViewController;
//   InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
//       crossPlatform: InAppWebViewOptions(
//           useShouldOverrideUrlLoading: true,
//           mediaPlaybackRequiresUserGesture: false),
//       android: AndroidInAppWebViewOptions(
//         useHybridComposition: true,
//       ),
//       ios: IOSInAppWebViewOptions(
//         allowsInlineMediaPlayback: true,
//       ));

//   late PullToRefreshController pullToRefreshController;
//   late ContextMenu contextMenu;

//   bool showLoader = true;
//   final urlController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     // _getPermission();

//     pullToRefreshController = PullToRefreshController(
//       options: PullToRefreshOptions(
//         color: Colors.blue,
//       ),
//       onRefresh: () async {
//         if (Platform.isAndroid) {
//           webViewController?.reload();
//         } else if (Platform.isIOS) {
//           webViewController?.loadUrl(
//               urlRequest: URLRequest(url: await webViewController?.getUrl()));
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.isCustomMainPageWebView == true
//         ? _webViewWidget()
//         : Scaffold(
//             appBar: widget.hideAppbar != true
//                 ? CustomAppBarWidget(
//                     isSearch: false,
//                     isShare: true, //widget.hideShare != true ? true : false,
//                     appBarTitle: widget.title,
//                     sharedPopBodyText: widget.url.toString(),
//                     sharedPopUpHeaderText: "Please checkout this link",
//                     language: Globals.selectedLanguage,
//                   )
//                 : null,
//             body: _webViewWidget());
//   }

//   Widget _webViewWidget() {
//     return OfflineBuilder(
//         connectivityBuilder: (
//           BuildContext context,
//           ConnectivityResult connectivity,
//           Widget child,
//         ) {
//           final bool connected = connectivity != ConnectivityResult.none;

//           if (connected) {
//             if (isErrorState == true) {
//               isErrorState = false;
//             }
//           } else if (!connected) {
//             isErrorState = true;
//           }

//           return connected
//               ? Container(
//                   color: Colors.transparent,
//                   padding: const EdgeInsets.only(
//                     bottom: 30.0,
//                   ), // To manage web page crop issue together with bottom nav bar.
//                   child: Stack(
//                     children: [
//                       Stack(
//                         children: [
//                           InAppWebView(
//                             // key: webViewKey,
//                             // contextMenu: contextMenu,
//                             initialUrlRequest:
//                                 URLRequest(url: Uri.parse(widget.url)),
//                             // initialFile: "assets/index.html",
//                             initialUserScripts:
//                                 UnmodifiableListView<UserScript>([]),
//                             initialOptions: options,

//                             pullToRefreshController: pullToRefreshController,
//                             onWebViewCreated: (controller) {
//                               webViewController = controller;
//                             },
//                             onLoadStart: (controller, url) {
//                               // setState(() {
//                               //   widget.url = url.toString();
//                               //   urlController.text = widget.url;
//                               // });
//                             },
//                             androidOnPermissionRequest:
//                                 (controller, origin, resources) async {
//                               return PermissionRequestResponse(
//                                   resources: resources,
//                                   action:
//                                       PermissionRequestResponseAction.GRANT);
//                             },
//                             shouldOverrideUrlLoading:
//                                 (controller, navigationAction) async {
//                               var uri = navigationAction.request.url!;

//                               if (![
//                                 "http",
//                                 "https",
//                                 "file",
//                                 "chrome",
//                                 "data",
//                                 "javascript",
//                                 "about"
//                               ].contains(uri.scheme)) {
//                                 if (await canLaunchUrl(Uri.parse(widget.url))) {
//                                   // Launch the App
//                                   await launchUrl(Uri.parse(widget.url));
//                                   // and cancel the request
//                                   return NavigationActionPolicy.CANCEL;
//                                 }
//                               }

//                               return NavigationActionPolicy.ALLOW;
//                             },
//                             onLoadStop: (controller, url) async {
//                               setState(() {
//                                 showLoader = false;
//                               });
//                               pullToRefreshController.endRefreshing();
//                             },
//                             onLoadError: (controller, url, code, message) {
//                               setState(() {
//                                 showLoader = false;
//                               });
//                               pullToRefreshController.endRefreshing();
//                             },
//                             onLoadHttpError: (controller, url, code, message) {
//                               setState(() {
//                                 showLoader = false;
//                               });
//                             },
//                             // onProgressChanged: (controller, progress) {
//                             //   // if (progress == 100) {
//                             //   //   setState(() {});
//                             //   //   pullToRefreshController.endRefreshing();
//                             //   // }
//                             //   // setState(() {
//                             //   //   this.progress = progress / 100;
//                             //   //   urlController.text = widget.url;
//                             //   // });
//                             // },
//                             onUpdateVisitedHistory:
//                                 (controller, url, androidIsReload) {
//                               // setState(() {
//                               //   widget.url = url.toString();
//                               //   urlController.text = widget.url;
//                               // });
//                             },
//                             onConsoleMessage: (controller, consoleMessage) {
//                               //print(consoleMessage);
//                             },
//                           ),
//                           showLoader
//                               ? Center(child: CircularProgressIndicator())
//                               : Container()
//                         ],
//                       ),
//                     ],
//                   ),
//                 )
//               : NoInternetErrorWidget(
//                   connected: connected, issplashscreen: false);
//         },
//         child: Container());
//   }

//   _getPermission() async {
//     await Permission.storage.request();
//   }
// }
