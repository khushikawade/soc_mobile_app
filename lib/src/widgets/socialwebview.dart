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
  bool isLoading = true;
  WebViewController? _webViewController;
  bool? iserrorstate = false;

  @override
  void initState() {
    super.initState();
    url = widget.link;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: BackButtonWidget(),
          title: AppLogoWidget(
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
          height: MediaQuery.of(context).size.height-50,
          child: ListView(
            shrinkWrap: true,
            
            children: [
              WebView(
initialCookies: [],

                                backgroundColor: Theme.of(context).backgroundColor,
                                onProgress: (progress) {
                                  if (progress >= 50) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },

                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                initialUrl: widget.link,
              ),
            ],
          ),
        ));
  }

  void reloadWebView() {
    _webViewController?.reload();
  }
}
