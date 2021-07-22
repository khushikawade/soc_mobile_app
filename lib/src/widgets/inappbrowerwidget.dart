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
import '../overrides.dart';

// ignore: must_be_immutable
class InAppBrowser extends StatefulWidget {
  InAppBrowser({
    Key? key,
    required this.link,
    required this.isSocialpage,
  }) : super(key: key);
  String link;
  bool isSocialpage;

  @override
  _InAppBrowserState createState() => _InAppBrowserState();
}

class _InAppBrowserState extends State<InAppBrowser> {
  String url = "";
  static const double _kPadding = 16.0;
  static const double _KButtonSize = 110.0;

  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<WebViewStateChanged>?
      _onchanged; // here we checked the url state if it loaded or start Load or abort Load

  @override
  void initState() {
    super.initState();
    url = widget.link;

    _onchanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        if (state.type == WebViewState.finishLoad) {
          // if the full website page loaded
          // print("loaded...");
        } else if (state.type == WebViewState.abortLoad) {
          // if there is a problem with loading the url
          // print("there is a problem...");
        } else if (state.type == WebViewState.startLoad) {
          // if the url started loading
          // print("start loading...");
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
                  color: AppTheme.kIconColor1,
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
          widget.isSocialpage
              ? IconButton(
                  onPressed: () {
                    _onShareWithEmptyOrigin(context);
                  },
                  icon: Icon(
                    Icons.share,
                    color: AppTheme.kIconColor3,
                  ),
                )
              : Container(),
          widget.isSocialpage
              ? IconButton(
                  onPressed: () {
                    _launchURL(url);
                  },
                  icon: Icon(
                    IconData(0xe80e,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color: AppTheme.kBlackColor,
                  ))
              : Container(),
        ],
      ),
      initialChild: Container(
        // but if you want to add your own waiting widget just add InitialChild
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            backgroundColor: AppTheme.kAccentColor,
          ),
        ),
      ),

      bottomNavigationBar: buttomButtonsWidget(),
    );
  }

  Widget buttomButtonsWidget() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(_kPadding / 2),
        color: AppTheme.kBackgroundColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Icon(
                Icons.arrow_back_ios_new,
                color: AppTheme.kBlackColor,
                size: 20,
              ),
              SizedBox(width: _kPadding / 2),
              Icon(
                Icons.arrow_forward_ios_rounded,
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
                  IconData(0xe80f,
                      fontFamily: Overrides.kFontFam,
                      fontPackage: Overrides.kFontPkg),
                  color: AppTheme.kBlackColor,
                )),
          ],
        ),
      ),
    );
  }

  Widget _conatainer() {
    return Container();
  }

  _onShareWithEmptyOrigin(BuildContext context) async {
    RenderBox? box = context.findRenderObject() as RenderBox;
    final String body = "hey, check out this site!" + url.toString();

    await Share.share(body,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
