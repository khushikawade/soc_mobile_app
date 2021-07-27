import 'dart:async';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bearIconwidget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/internalbuttomnavigation.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../overrides.dart';

class SoicalPageWebview extends StatefulWidget {
  SoicalPageWebview({
    Key? key,
    required this.link,
    required this.isSocialpage,
  }) : super(key: key);
  String link;
  bool isSocialpage;

  @override
  _SoicalPageWebviewState createState() => _SoicalPageWebviewState();
}

class _SoicalPageWebviewState extends State<SoicalPageWebview> {
  String url = "";
  static const double _kPadding = 16.0;

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
        } else if (state.type == WebViewState.abortLoad) {
        } else if (state.type == WebViewState.startLoad) {}
      }
    });
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    super.dispose();
    flutterWebviewPlugin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: url,
      withJavascript: false,
      withZoom: false,
      hidden: true,
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
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                //   Icon(
                //     Icons.arrow_back_ios_new,
                //     color: AppTheme.kBlackColor,
                //     size: 20,
                //   ),
                //   SizedBox(width: _kPadding / 2),
                //   Icon(
                //     Icons.arrow_forward_ios_rounded,
                //     color: AppTheme.kBlackColor,
                //     size: 20,
                //   ),
                // ]),
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

                // widget.isbuttomsheet && Globals.homeObjet != null
                //     ? InternalButtomNavigationBar()
                //     : null
              ],
            )));
  }

  _onShareWithEmptyOrigin(BuildContext context) async {
    RenderBox? box = context.findRenderObject() as RenderBox;
    final String body = "hey, check out this site!" + url.toString();

    await Share.share(body,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
