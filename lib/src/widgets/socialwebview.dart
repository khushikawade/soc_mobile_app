import 'package:Soc/src/globals.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/app_logo_widget.dart';
import 'package:Soc/src/widgets/backbuttonwidget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../overrides.dart';

class SocialPageWebview extends StatefulWidget {
  SocialPageWebview({
    Key? key,
    required this.link,
    required this.isSocialpage,
    required this.isbuttomsheet,
  }) : super(key: key);
  final String link;
  final bool isSocialpage;
  final bool isbuttomsheet;

  @override
  _SocialPageWebviewState createState() => _SocialPageWebviewState();
}

class _SocialPageWebviewState extends State<SocialPageWebview> {
  String url = "";
  static const double _kPadding = 16.0;
  UrlLauncherWidget urlobj = new UrlLauncherWidget();
  // final flutterWebviewPlugin = new FlutterWebviewPlugin();
  WebViewController? _webViewController;
  bool? iserrorstate = false;
  // StreamSubscription<WebViewStateChanged>?
  //     _onchanged; // here we checked the url state if it loaded or start Load or abort Load

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
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: BackButtonWidget(),
          title: //SizedBox(width: 100.0, height: 60.0, child:
              AppLogoWidget(
            marginLeft: 55,
          ),
          //),
          actions: [
            widget.isSocialpage
                ? IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: () {
                      reloadWebView();
                    },
                    icon: Icon(
                      IconData(0xe80f,
                          fontFamily: Overrides.kFontFam,
                          fontPackage: Overrides.kFontPkg),
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
                      // urlobj.callurlLaucher(context, url);
                      Utility.launchUrlOnExternalBrowser(url);
                    },
                    icon: Icon(
                      IconData(0xe80e,
                          fontFamily: Overrides.kFontFam,
                          fontPackage: Overrides.kFontPkg),
                      size: Globals.deviceType == "phone" ? 20 : 28,
                    ))
                : Container(height: 0),
            HorzitalSpacerWidget(_kPadding / 1.5),
          ],
        ),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(bottom: 25),
          child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            initialUrl: widget.link,
          ),
        ));
  }

  void reloadWebView() {
    _webViewController?.reload();
  }
}
