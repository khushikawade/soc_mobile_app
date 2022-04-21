import 'package:Soc/src/services/utility.dart';
import 'package:flutter/material.dart';

class UrlLauncherWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UrlLauncherState();
  void callurlLaucher(BuildContext context, url) {
    UrlLauncherState._launchURL(url);
  }
}

class UrlLauncherState extends State<UrlLauncherWidget> {
  static _launchURL(url) async {
    await Utility.launchUrlOnExternalBrowser(url);
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
