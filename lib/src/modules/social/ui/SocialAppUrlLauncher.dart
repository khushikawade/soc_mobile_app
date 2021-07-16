import 'dart:async';

import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bearIconwidget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../overrides.dart';

// final webViewKey = GlobalKey<_SocialAppUrlLauncherState>();

// class SocialAppUrlLauncher extends StatefulWidget {
//   final String? url = "wwww.google.co.in";
//   final bool? hideHeader;
//   @override
//   SocialAppUrlLauncher({Key? key, this.hideHeader}) : super(key: key);
//   _SocialAppUrlLauncherState createState() => new _SocialAppUrlLauncherState();
// }

// class _SocialAppUrlLauncherState extends State<SocialAppUrlLauncher> {
//   static const double _kPadding = 16.0;
//   static const double _KButtonSize = 110.0;
//   late WebViewController _webViewController;
//   final flutterWebviewPlugin = new FlutterWebviewPlugin();

//   // launchUrl(url) async {
//   //   if (await canLaunch(url)) {
//   //     setState(() {
//   //       _flag = false;
//   //     });
//   //     await launch(url);
//   //     setState(() {
//   //       _flag = true;
//   //     });
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: AppBar(
//         elevation: 0.0,
//         leading: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 15.0, left: 10),
//               child: InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Icon(
//                   const IconData(0xe80d,
//                       fontFamily: Overrides.kFontFam,
//                       fontPackage: Overrides.kFontPkg),
//                   color: Color(0xff171717),
//                   size: 20,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         title: SizedBox(width: 100.0, height: 60.0, child: BearIconWidget()),
//         // bottom: PreferredSize(
//         //   child: _progressBar(lineProgress, context),
//         //   preferredSize: Size.fromHeight(3.0),
//         // ),
//         actions: [
//           Icon(
//             Icons.share,
//             color: AppTheme.kIconColor3,
//           ),
//           HorzitalSpacerWidget(_kPadding),
//           Icon(
//             Icons.stop_screen_share,
//             color: AppTheme.kIconColor3,
//           )
//         ],
//       ),
//       body: WebView(
//         // initialUrl: '${widget.url}',
//         initialUrl:
//             "https://stackoverflow.com/questions/57215843/how-to-reload-webview-in-flutter",
//         key: UniqueKey(),
//       ),
//       bottomSheet: buttomButtonsWidget(),
//     );
//   }

//   @override
//   void dispose() {
//     // _controller();
//     // _animation1.di
//     super.dispose();
//   }

//   Widget buttomButtonsWidget() {
//     return Container(
//       padding: EdgeInsets.all(_kPadding / 2),
//       color: AppTheme.kBackgroundColor,
//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//             IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: Icon(
//                 const IconData(0xe80c,
//                     fontFamily: Overrides.kFontFam,
//                     fontPackage: Overrides.kFontPkg),
//                 color: Color(0xffbcc5d4),
//                 size: 20,
//               ),
//             ),
//             SizedBox(width: _kPadding),
//             Icon(
//               const IconData(0xe815,
//                   fontFamily: Overrides.kFontFam,
//                   fontPackage: Overrides.kFontPkg),
//               color: AppTheme.kBlackColor,
//               size: 20,
//             ),
//           ]),
//           SizedBox(
//             width: _kPadding / 2,
//           ),
//           SizedBox(
//               width: _KButtonSize,
//               height: _KButtonSize / 2,
//               child: IconButton(
//                   onPressed: () {
//                     flutterWebviewPlugin.reloadUrl(
//                         "https://stackoverflow.com/questions/57215843/how-to-reload-webview-in-flutter");
//                     print('reload');
//                   },
//                   icon: Icon(
//                     Icons.refresh,
//                     color: AppTheme.kIconColor3,
//                   ))),
//         ],
//       ),
//     );
//   }

//   void reloadWebView() {
//     _webViewController.reload();
//   }
// }

class SocialAppUrlLauncher extends StatefulWidget {
  SocialAppUrlLauncher({Key? key, required this.link}) : super(key: key);
  String link;
  @override
  _SocialAppUrlLauncherState createState() => _SocialAppUrlLauncherState();
}

class _SocialAppUrlLauncherState extends State<SocialAppUrlLauncher> {
  String url = "https://flutter.dev/";
  static const double _kPadding = 16.0;
  static const double _KButtonSize = 110.0;

  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<WebViewStateChanged>?
      _onchanged; // here we checked the url state if it loaded or start Load or abort Load

  @override
  void initState() {
    super.initState();
    url = widget.link;
    print(url);
    _onchanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        if (state.type == WebViewState.finishLoad) {
          // if the full website page loaded
          print("loaded...");
        } else if (state.type == WebViewState.abortLoad) {
          // if there is a problem with loading the url
          print("there is a problem...");
        } else if (state.type == WebViewState.startLoad) {
          // if the url started loading
          print("start loading...");
        }
      }
    });
  }

  _launchURL(url) async {
    // const url = "${overrides.Overrides.privacyPolicyUrl}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flutterWebviewPlugin.dispose(); // disposing the webview widget
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: url,
      withJavascript: false, // run javascript
      withZoom: false, // if you want the user zoom-in and zoom-out
      hidden:
          true, // put it true if you want to show CircularProgressIndicator while waiting for the page to load
      appBar: AppBar(
        elevation: 0.0,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 10),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  const IconData(0xe80d,
                      fontFamily: Overrides.kFontFam,
                      fontPackage: Overrides.kFontPkg),
                  color: Color(0xff171717),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        title: SizedBox(width: 100.0, height: 60.0, child: BearIconWidget()),
        // bottom: PreferredSize(
        //   child: _progressBar(lineProgress, context),
        //   preferredSize: Size.fromHeight(3.0),
        // ),
        actions: [
          IconButton(
            onPressed: () {
              _onShareWithEmptyOrigin(context);
            },
            icon: Icon(
              Icons.share,
              color: AppTheme.kIconColor3,
            ),
          ),
          HorzitalSpacerWidget(_kPadding),
          IconButton(
              onPressed: () {
                _launchURL(url);
              },
              icon: Icon(
                Icons.stop_screen_share,
                color: AppTheme.kIconColor3,
              )),
        ],
      ),
      initialChild: Container(
        // but if you want to add your own waiting widget just add InitialChild
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            backgroundColor: Colors.blue,
          ),
        ),
      ),

      bottomNavigationBar: buttomButtonsWidget(),
    );
  }

  Widget buttomButtonsWidget() {
    return Container(
      padding: EdgeInsets.all(_kPadding / 2),
      color: AppTheme.kBackgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                const IconData(0xe80c,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color: Color(0xffbcc5d4),
                size: 20,
              ),
            ),
            SizedBox(width: _kPadding),
            Icon(
              const IconData(0xe815,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg),
              color: AppTheme.kBlackColor,
              size: 20,
            ),
          ]),
          SizedBox(
            width: _kPadding / 2,
          ),
          IconButton(
              onPressed: () {
                flutterWebviewPlugin.reload();
              },
              icon: Icon(
                Icons.refresh,
                color: AppTheme.kIconColor3,
              )),
        ],
      ),
    );
  }

  _onShareWithEmptyOrigin(BuildContext context) async {
    RenderBox? box = context.findRenderObject() as RenderBox;
    final String body = "hey, check ou this site!" + url.toString();

    await Share.share(body,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
