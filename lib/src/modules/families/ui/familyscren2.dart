// import 'package:Soc/src/modules/families/Submodule/aboutus/ui/aboutus.dart';
// import 'package:Soc/src/modules/families/Submodule/contact/ui/contact.dart';
// import 'package:Soc/src/modules/families/Submodule/event/ui/event.dart';
// import 'package:Soc/src/modules/families/Submodule/form/ui/forms.dart';
// import 'package:Soc/src/modules/families/Submodule/nyc/ui/nycresource.dart';
// import 'package:Soc/src/modules/families/Submodule/resource/ui/resource.dart';
// import 'package:Soc/src/modules/families/Submodule/staff/ui/stafflist.dart';
// import 'package:Soc/src/modules/user/ui/login.dart';
// import 'package:Soc/src/styles/theme.dart';
// import 'package:Soc/src/widgets/app_bar.dart';
// import 'package:Soc/src/widgets/inapp_url_launcher.dart';
// import 'package:Soc/src/widgets/mapwidget.dart';
// import 'package:Soc/src/widgets/models/webview.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

// class FamilyPage2 extends StatefulWidget {
//   FamilyPage2({Key? key, required this.index}) : super(key: key);
//   final int index;
//   @override
//   _FamilyPage2State createState() => _FamilyPage2State();
// }

// class _FamilyPage2State extends State<FamilyPage2> {
//   final flutterWebviewPlugin = FlutterWebviewPlugin();
//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     flutterWebviewPlugin.close();
//     super.initState();
//     _selectedIndex = widget.index;
//   }

//   //STYLE
//   // static const _kPopMenuTextStyle = TextStyle(
//   //     fontFamily: "Roboto Regular", fontSize: 14, color: Color(0xff474D55));

//   // Top-Section Widget

//   // void _onItemTap(int index) {
//   //   setState(() {
//   //     _selectedIndex = index;
//   //   });
//   // }

//   @override
//   void dispose() {
//     flutterWebviewPlugin.dispose();
//     super.dispose();
//   }

//   selectedScreenBody(context, _selectedIndex) {
//     if (_selectedIndex == 0) {
//       // return AboutusPage();
//     } else if (_selectedIndex == 1) {
//       return WebviewScaffold(
//         url: "https://www.google.com/",

//         withLocalStorage: true,
//         withJavascript: true,
//         withZoom: true,
//         initialChild: Container(
//             child: Center(
//           child: CircularProgressIndicator(
//             valueColor:
//                 new AlwaysStoppedAnimation<Color>(AppTheme.kAccentColor),
//           ),
//         )),

//         // title: "THIS",
//       );
//     } else if (_selectedIndex == 2) {
//       return EventPage();
//     } else if (_selectedIndex == 3) {
//       return FormPage();
//     } else if (_selectedIndex == 4) {
//       return StaffListPage();
//     } else if (_selectedIndex == 5) {
//       return Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (BuildContext context) => InAppUrlLauncer(
//                     title: "",
//                     url: "www.google.com",
//                   )));
//     } else if (_selectedIndex == 6) {
//       return Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (BuildContext context) => InAppUrlLauncer(
//                     title: "",
//                     url: "www.google.com",
//                   )));
//     } else if (_selectedIndex == 7) {
//       return Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (BuildContext context) => InAppUrlLauncer(
//                     title: "",
//                     url: "www.google.com",
//                   )));
//     } else if (_selectedIndex == 8) {
//       return Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (BuildContext context) => InAppUrlLauncer(
//                     title: "",
//                     url: "www.google.com",
//                   )));
//     } else if (_selectedIndex == 9) {
//       return Resources();
//     } else if (_selectedIndex == 10) {
//       return Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (BuildContext context) => InAppUrlLauncer(
//                     title: "",
//                     url: "www.google.com",
//                   )));
//     } else if (_selectedIndex == 11) {
//       return ContactPage();
//     } else if (_selectedIndex == 12) {
//       return NycResource();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBarWidget(
//         isnewsDescription: false,
//       ),
//       body: selectedScreenBody(context, _selectedIndex),
//     );
//   }
// }
