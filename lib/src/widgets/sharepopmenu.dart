import 'package:flutter/material.dart';
import 'package:share/share.dart';

class MySharePopup extends StatefulWidget {
  const MySharePopup({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SharePopupState();
}

class SharePopupState extends State<MySharePopup> {
  _onShareWithEmptyOrigin(BuildContext context) async {
    RenderBox? box = context.findRenderObject() as RenderBox;
    final String body = "text";
    // "Hi, I downloaded the PS 456 Bronx Bears app. You should check it out! Download the app at https://play.google.com/store/apps/details?id=com.app.p1676CB";
    final subject = "sub";
    await Share.share(body,
        subject: subject,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Widget build(BuildContext context) {
    return Container();
  }
}
