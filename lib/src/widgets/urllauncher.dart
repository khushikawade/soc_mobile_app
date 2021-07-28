import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UrlLauncherState();
  void callurlLaucher(BuildContext context, url) {
    UrlLauncherState._launchURL(url);
  }
}

class UrlLauncherState extends State<UrlLauncherWidget> {
  static _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
