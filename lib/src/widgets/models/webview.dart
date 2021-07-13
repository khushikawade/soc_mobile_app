// import 'dart:async';

// import 'package:Soc/src/modules/user/ui/login.dart';
// import 'package:Soc/src/styles/theme.dart';
// import 'package:Soc/src/widgets/app_bar.dart';
// import 'package:Soc/src/widgets/bearIconwidget.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

// import '../../overrides.dart';

// // import 'dart:html';

// // class WebViewPage extends StatefulWidget {
// //   WebViewPage({Key? key, required this.url}) : super(key: key);
// //   final String url;
// //   @override
// //   _WebViewState createState() => _WebViewState();
// // }

// // // class _WebViewState extends State<WebView> {
// // //   int _selectedIndex = 0;
// // //   static const double _kLabelSpacing = 16.0;
// // //   Completer<WebViewController> _controller = Completer<WebViewController>();
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _selectedIndex = widget.index;

// // //     //initDynamicLinks();
// // //   }

// // //   //STYLE
// // //   static const _kPopMenuTextStyle = TextStyle(
// // //       fontFamily: "Roboto Regular", fontSize: 14, color: Color(0xff474D55));

// // //   body(context, _selectedIndex) {
// // //     if (_selectedIndex == 0) {
// // //       // return Container();
// // //     } else if (_selectedIndex == 1) {
// // //       return LoginPage();
// // //     } else if (_selectedIndex == 2) {
// // //       // return EventPage();
// // //     } else if (_selectedIndex == 3) {
// // //       // return FormPage();
// // //     } else if (_selectedIndex == 4) {
// // //       // return StaffListPage();
// // //     } else if (_selectedIndex == 5) {
// // //       return Container();
// // //     } else if (_selectedIndex == 6) {
// // //       return Container();
// // //     } else if (_selectedIndex == 7) {
// // //       return Container();
// // //     } else if (_selectedIndex == 8) {
// // //       return Container();
// // //     } else if (_selectedIndex == 9) {
// // //       // return Resources();
// // //     } else if (_selectedIndex == 10) {
// // //       return Container();
// // //     } else if (_selectedIndex == 11) {
// // //       // return ContactPage();
// // //     } else if (_selectedIndex == 12) {
// // //       // return NycResource();
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: CustomAppBarWidget(),
// // //       body: body(context, _selectedIndex),
// // //     );
// // //   }
// // // }

// // // class MyWebView extends StatefulWidget {
// // //   final url;
// // //   final title;
// // //   MyWebView({Key? key, @required this.url, @required this.title})
// // //       : super(key: key);
// // //   @override
// // //   _MyWebViewState createState() => _MyWebViewState();
// // // }

// // // class _MyWebViewState extends State<MyWebView> {
// // //   FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

// // //   double lineProgress = 0.0;

// // //   void initState() {
// // //     super.initState();
// // //     flutterWebviewPlugin.onProgressChanged.listen((progress) {
// // //       print(progress);
// // //       setState(() {
// // //         lineProgress = progress;
// // //       });
// // //     });
// // //   }

// // //   void dispose() {
// // //     flutterWebviewPlugin.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return WebviewScaffold(
// // //       appBar: AppBar(
// // //         backgroundColor: Colors.green,
// // //         title: Text(widget.title),
// // //         bottom: PreferredSize(
// // //           child: _progressBar(lineProgress, context),
// // //           preferredSize: Size.fromHeight(3.0),
// // //         ),
// // //       ),
// // //       url: widget.url,
// // //     );
// // //   }

// // //   _progressBar(double progress, BuildContext context) {
// // //     return LinearProgressIndicator(
// // //       backgroundColor: Colors.white70.withOpacity(0),
// // //       value: progress == 1.0 ? 0 : progress,
// // //       valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
// // //     );
// // //   }
// // // }

// // // ignore: avoid_web_libraries_in_flutter
// // //

// // class _WebViewState extends State<WebViewPage> {
// //   FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

// //   String? url;
// //   bool isLoading = true;
// //   final _key = UniqueKey();
// //   double lineProgress = 0.0;

// //   WebViewState() {
// //     this.url = widget.url;
// //   }

// //   @override
// //   void dispose() {
// //     flutterWebviewPlugin.dispose();
// //     super.dispose();
// //   }

// //   void initState() {
// //     super.initState();
// //     flutterWebviewPlugin.onProgressChanged.listen((progress) {
// //       print(progress);
// //       setState(() {
// //         lineProgress = progress;
// //       });
// //     });

// //     _progressBar(double progress, BuildContext context) {
// //       return LinearProgressIndicator(
// //         backgroundColor: Colors.white70.withOpacity(0),
// //         value: progress == 1.0 ? 0 : progress,
// //         valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
// //       );
// //     }

// //     @override
// //     Widget build(BuildContext context) {
// //       return Scaffold(
// //         backgroundColor: Colors.black,
// //         appBar: AppBar(
// //           backgroundColor: Colors.green,
// //           title: Text("THIS"),
// //           bottom: PreferredSize(
// //             child: _progressBar(lineProgress, context),
// //             preferredSize: Size.fromHeight(3.0),
// //           ),
// //         ),
// //         body: Stack(
// //           children: <Widget>[
// //             WebView(
// //               key: _key,
// //               initialUrl:
// //                   "https://pub.dev/packages/flutter_webview_plugin/install",
// //               javascriptMode: JavascriptMode.unrestricted,
// //               onPageFinished: (finish) {
// //                 setState(() {
// //                   isLoading = false;
// //                 });
// //               },
// //             ),
// //             isLoading
// //                 ? Container(
// //                     color: Colors.black,
// //                     child: Center(
// //                       child: CircularProgressIndicator(),
// //                     ),
// //                   )
// //                 : Stack(),
// //           ],
// //         ),
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     // TODO: implement build
// //     throw UnimplementedError();
// //   }
// // }

// class MyWebView extends StatefulWidget {
//   final url;
//   final title;
//   MyWebView({Key? key, @required this.url, @required this.title})
//       : super(key: key);
//   @override
//   _MyWebViewState createState() => _MyWebViewState();
// }

// class _MyWebViewState extends State<MyWebView> {
//   FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

//   double lineProgress = 0.0;

//   void initState() {
//     super.initState();
//     flutterWebviewPlugin.onProgressChanged.listen((progress) {
//       print(progress);
//       setState(() {
//         lineProgress = progress;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     flutterWebviewPlugin.dispose();
//     super.dispose();
//   }

//   WebViewController? controllerGlobal;

//   Future<bool> _exitApp(BuildContext context) async {
//     if (await controllerGlobal!.canGoBack()) {
//       print("onwill goback");
//       controllerGlobal!.goBack();
//       return Future.value(true);
//     } else {
//       Scaffold.of(context).showSnackBar(
//         const SnackBar(content: Text("No back history item")),
//       );
//       return Future.value(false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: WebviewScaffold(
//         appBar: AppBar(
//           elevation: 0.0,
//           leading: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 15.0, left: 10),
//                 child: IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: Icon(
//                     const IconData(0xe813,
//                         fontFamily: Overrides.kFontFam,
//                         fontPackage: Overrides.kFontPkg),
//                     color: Color(0xff171717),
//                     size: 20,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           title: SizedBox(width: 100.0, height: 50.0, child: BearIconWidget()),
//           bottom: PreferredSize(
//             child: _progressBar(lineProgress, context),
//             preferredSize: Size.fromHeight(4.0),
//           ),
//         ),
//         withLocalStorage: true,
//         url: "https://www.google.com/",
//         initialChild: Container(
//             child: Center(
//           child: CircularProgressIndicator(
//             valueColor:
//                 new AlwaysStoppedAnimation<Color>(AppTheme.kAccentColor),
//           ),
//         )),
//       ),
//     );
//   }

//   // _cicularprogress() {
//   //   return CircularProgressIndicator(
//   //     valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
//   //   );
//   // }

//   _progressBar(double progress, BuildContext context) {
//     return LinearProgressIndicator(
//       minHeight: 2.0,
//       backgroundColor: AppTheme.kIndicatorBackColor,
//       value: progress == 1.0 ? 0 : progress,
//       valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.kIndicatorColor),
//     );
//   }
// }
