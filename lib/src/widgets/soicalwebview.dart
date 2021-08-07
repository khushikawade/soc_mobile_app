import 'dart:async';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/app_logo_widget.dart';
import 'package:Soc/src/widgets/backbuttonwidget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';

import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../overrides.dart';

class SoicalPageWebview extends StatefulWidget {
  SoicalPageWebview({
    Key? key,
    required this.link,
    required this.isSocialpage,
    required this.isbuttomsheet,
  }) : super(key: key);
  final String link;
  final bool isSocialpage;
  final bool isbuttomsheet;

  @override
  _SoicalPageWebviewState createState() => _SoicalPageWebviewState();
}

class _SoicalPageWebviewState extends State<SoicalPageWebview> {
  String url = "";
  static const double _kPadding = 16.0;
  UrlLauncherWidget urlobj = new UrlLauncherWidget();
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<WebViewStateChanged>?
      _onchanged; // here we checked the url state if it loaded or start Load or abort Load

  @override
  void initState() {
    super.initState();
    url = widget.link;
  }

  @override
  void dispose() {
    super.dispose();
    // flutterWebviewPlugin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: WebviewScaffold(
        url: url != null ? url : "www.google.com",
        // withJavascript: true,
        // withZoom: false,
        // hidden: true,
        appBar: AppBar(
          elevation: 0.0,
          leading: BackButtonWidget(),
          title: SizedBox(width: 100.0, height: 60.0, child: AppLogoWidget()),
          actions: [
            widget.isSocialpage
                ? IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: () {
                      flutterWebviewPlugin.reload();
                    },
                    icon: Icon(
                      IconData(0xe80f,
                          fontFamily: Overrides.kFontFam,
                          fontPackage: Overrides.kFontPkg),
                      // color: AppTheme.kBlackColor,
                      size: Globals.deviceType == "phone" ? 20 : 28,
                    ))
                : Container(
                    height: 0,
                  ),
            HorzitalSpacerWidget(_kPadding / 1.2),
            widget.isSocialpage
                ? IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: () {
                      final String body =
                          "Hey, check out this site! " + url.toString();
                      SharePopUp obj = new SharePopUp();
                      obj.callFunction(context, body, "");
                    },
                    icon: Icon(
                      Icons.share,
                      // color: AppTheme.kIconColor3,
                      size: Globals.deviceType == "phone" ? 18 : 26,
                    ),
                  )
                : Container(
                    height: 0,
                  ),
            HorzitalSpacerWidget(_kPadding / 1.2),
            widget.isSocialpage
                ? IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: () {
                      urlobj.callurlLaucher(context, url);
                    },
                    icon: Icon(
                      IconData(0xe80e,
                          fontFamily: Overrides.kFontFam,
                          fontPackage: Overrides.kFontPkg),
                      // color: AppTheme.kBlackColor,
                      size: Globals.deviceType == "phone" ? 20 : 28,
                    ))
                : Container(height: 0),
            HorzitalSpacerWidget(_kPadding / 1.5),
          ],
        ),
        initialChild: Container(
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget buttomButtonsWidget() {
    return SafeArea(
        child: Container(
            padding: EdgeInsets.all(_kPadding / 2),
            color: Theme.of(context).colorScheme.background,
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
                      // color: AppTheme.kBlackColor,
                      size: Globals.deviceType == "phone" ? 20 : 28,
                    )),
              ],
            )));
  }
}
