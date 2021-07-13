// import 'dart:async';

// import 'package:Soc/src/modules/user/ui/login.dart';
// import 'package:Soc/src/widgets/app_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// import 'dart:html';

// class WebView extends StatefulWidget {
//   WebView({Key? key, required this.index}) : super(key: key);
//   final int index;
//   @override
//   _WebViewState createState() => _WebViewState();
// }

// class _WebViewState extends State<WebView> {
//   int _selectedIndex = 0;
//   static const double _kLabelSpacing = 16.0;
//   Completer<WebViewController> _controller = Completer<WebViewController>();
//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.index;

//     //initDynamicLinks();
//   }

//   //STYLE
//   static const _kPopMenuTextStyle = TextStyle(
//       fontFamily: "Roboto Regular", fontSize: 14, color: Color(0xff474D55));

//   body(context, _selectedIndex) {
//     if (_selectedIndex == 0) {
//       // return Container();
//     } else if (_selectedIndex == 1) {
//       return LoginPage();
//     } else if (_selectedIndex == 2) {
//       // return EventPage();
//     } else if (_selectedIndex == 3) {
//       // return FormPage();
//     } else if (_selectedIndex == 4) {
//       // return StaffListPage();
//     } else if (_selectedIndex == 5) {
//       return Container();
//     } else if (_selectedIndex == 6) {
//       return Container();
//     } else if (_selectedIndex == 7) {
//       return Container();
//     } else if (_selectedIndex == 8) {
//       return Container();
//     } else if (_selectedIndex == 9) {
//       // return Resources();
//     } else if (_selectedIndex == 10) {
//       return Container();
//     } else if (_selectedIndex == 11) {
//       // return ContactPage();
//     } else if (_selectedIndex == 12) {
//       // return NycResource();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBarWidget(),
//       body: body(context, _selectedIndex),
//     );
//   }
// }

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

//   void dispose() {
//     flutterWebviewPlugin.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WebviewScaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: Text(widget.title),
//         bottom: PreferredSize(
//           child: _progressBar(lineProgress, context),
//           preferredSize: Size.fromHeight(3.0),
//         ),
//       ),
//       url: widget.url,
//     );
//   }

//   _progressBar(double progress, BuildContext context) {
//     return LinearProgressIndicator(
//       backgroundColor: Colors.white70.withOpacity(0),
//       value: progress == 1.0 ? 0 : progress,
//       valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
//     );
//   }
// }

// ignore: avoid_web_libraries_in_flutter
// 