// import 'dart:async';
// import 'dart:io';
// import 'package:Soc/src/globals.dart';
// import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
// import 'package:Soc/src/modules/home/models/app_setting.dart';
// import 'package:Soc/src/styles/theme.dart';
// import 'package:Soc/src/widgets/empty_container_widget.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:Soc/src/widgets/network_error_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_offline/flutter_offline.dart';

// class HomeInAppUrlLauncher extends StatefulWidget {
//   final bool? isiFrame;
//   final String url;

//   final String? language;
//   @override
//   HomeInAppUrlLauncher(
//       {Key? key, required this.url, required this.language, this.isiFrame})
//       : super(key: key);
//   _HomeInAppUrlLauncherState createState() => new _HomeInAppUrlLauncherState();
// }

// class _HomeInAppUrlLauncherState extends State<HomeInAppUrlLauncher> {
//   bool? iserrorstate = false;
//   final Completer<WebViewController> _controller =
//       Completer<WebViewController>();
//   String? checkUrlChange;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     checkUrlChange = widget.url;
//     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: OfflineBuilder(
//           connectivityBuilder: (
//             BuildContext context,
//             ConnectivityResult connectivity,
//             Widget child,
//           ) {
//             final bool connected = connectivity != ConnectivityResult.none;
//             if (connected) {
//               if (iserrorstate == true) {
//                 iserrorstate = false;
//               }
//             } else if (!connected) {
//               iserrorstate = true;
//             }

//             return connected
//                 ?Container(
//                       color: Colors.transparent,
//                       padding: const EdgeInsets.only(
//                           bottom:
//                               30.0), // To manage web page crop issue together with bottom nav bar.
//                       child: Stack(
//                         children: [
//                           WebView(
//                             initialCookies: [],
//                             backgroundColor: Theme.of(context).backgroundColor,
//                             onProgress: (progress) {
//                               if (progress >= 50) {
//                                 setState(() {
//                                   isLoading = false;
//                                 });
//                               }
//                             },
//                             gestureNavigationEnabled:
//                                 widget.isiFrame == true ? true : false,
//                             initialUrl: widget.isiFrame == true
//                                 ? Uri.dataFromString('${widget.url}',
//                                         mimeType: 'text/html')
//                                     .toString()
//                                 : '${widget.url}',
//                             javascriptMode: JavascriptMode.unrestricted,
//                             onWebViewCreated:
//                                 (WebViewController webViewController) {
//                               _controller.complete(webViewController);
//                             },
//                           ),
//                           isLoading
//                               ? Center(
//                                   child: CircularProgressIndicator(
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .primaryVariant,
//                                   ),
//                                 )
//                               : Stack(),
//                         ],
//                       ),
//                     )
//                 : NoInternetErrorWidget(
//                     connected: connected, issplashscreen: false);
//           },
//           child: Container()),
//     );
//   }

 
// }
