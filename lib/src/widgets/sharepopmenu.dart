import 'package:flutter/material.dart';
import 'package:share/share.dart';

// // // _onShareWithEmptyOrigin(BuildContext context) async {
// // //   RenderBox? box = context.findRenderObject() as RenderBox;
// // //   final String body = "text";
// // //   // "Hi, I downloaded the PS 456 Bronx Bears app. You should check it out! Download the app at https://play.google.com/store/apps/details?id=com.app.p1676CB";
// // //   final subject = "sub";
// // //   await Share.share(body,
// // //       subject: subject,
// // //       sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
// // // }

// // class SharePopWidget extends StatelessWidget {
// //   String text;
// //   String sub;
// //   BuildContext context;
// //   SharePopWidget(this.text, this.sub, this.context);

// //   @override
// //   Widget build(BuildContext context) {
// //     // TODO: implement build
// //     throw UnimplementedError();
// //   }
// // }

// // typedef ColorCallback =   _onShareWithEmptyOrigin(BuildContext context)  {
// //     RenderBox? box = context.findRenderObject() as RenderBox;
// //     final String body = "text";
// //     // "Hi, I downloaded the PS 456 Bronx Bears app. You should check it out! Download the app at https://play.google.com/store/apps/details?id=com.app.p1676CB";
// //     final subject = "sub";
// //     await Share.share(body,
// //         subject: subject,
// //         sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
// //   };
// //   @override
// //   Widget build(BuildContext context) {
// //     return _onShareWithEmptyOrigin(context);
// //   }
// // }

// class SharePopWidget extends StatefulWidget {
//   String text;
//   String sub;
//   BuildContext context;
//   SharePopWidget(this.text, this.sub, this.context);
//   method() => createState()._onShareWithEmptyOrigin(context);

//   @override
//   _SharePopWidgetState createState() => _SharePopWidgetState();
// }

// class _SharePopWidgetState extends State<SharePopWidget> {
//   // methodInSharePopWidget() => print("method in page 2");

//   _onShareWithEmptyOrigin(BuildContext context) async {
//     RenderBox? box = context.findRenderObject() as RenderBox;
//     final String body = "text";
//     // "Hi, I downloaded the PS 456 Bronx Bears app. You should check it out! Download the app at https://play.google.com/store/apps/details?id=com.app.p1676CB";
//     final subject = "sub";
//     await Share.share(body,
//         subject: subject,
//         sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
//   }

//   @override
//   Widget build(BuildContext context) => Container();
// }

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

// class Page1 extends StatefulWidget {
//   @override
//   _Page1State createState() => _Page1State();
// }

// class _Page1State extends State<Page1> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: RaisedButton(
//           child: Text("Call page 2 method"),
//           onPressed: () => Page2().method(),
//         ),
//       ),
//     );
//   }
// }

// class Page2 extends StatefulWidget {
//   method() => createState()._onShareWithEmptyOrigin();

//   @override
//   _Page2State createState() => _Page2State();
// }

// class _Page2State extends State<Page2> {
//   _onShareWithEmptyOrigin(BuildContext context) async {
//     RenderBox? box = context.findRenderObject() as RenderBox;
//     final String body = "text";
//     // "Hi, I downloaded the PS 456 Bronx Bears app. You should check it out! Download the app at https://play.google.com/store/apps/details?id=com.app.p1676CB";
//     final subject = "sub";
//     await Share.share(body,
//         subject: subject,
//         sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: RaisedButton(
//           child: Text("Call page 2 method"),
//           onPressed: () => Page2().method(),
//         ),
//       ),
//     );
//   }
// }
