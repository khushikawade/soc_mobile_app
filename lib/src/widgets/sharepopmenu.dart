import 'package:flutter/material.dart';
import 'package:share/share.dart';

class SharePopUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SharePopupState();
  void callFunction(BuildContext context, String body, String header) {
    SharePopupState._onShare(context, body, header);
  }
}

class SharePopupState extends State<SharePopUp> {
  static String? body1;
  static String? subject1;

  static _onShare(BuildContext context, String body1, String header1) async {
    RenderBox? box = context.findRenderObject() as RenderBox;
    final String body = body1;
    final subject = header1;
    await Share.share(body,
        subject: subject,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
