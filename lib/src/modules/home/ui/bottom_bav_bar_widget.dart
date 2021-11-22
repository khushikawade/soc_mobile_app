// import 'package:Soc/src/globals.dart';
// import 'package:Soc/src/overrides.dart';
// import 'package:flutter/material.dart';

// class BottomBavBarWidget extends StatefulWidget {
//   @override
//   _BottomBavBarWidgetState createState() => _BottomBavBarWidgetState();
// }

// class _BottomBavBarWidgetState extends State<BottomBavBarWidget> {
//   final ValueNotifier<bool> indicator = ValueNotifier<bool>(false);
//   final ValueNotifier<String> langadded = ValueNotifier<String>("English");
  
//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       backgroundColor: Theme.of(context).backgroundColor,
//       type: BottomNavigationBarType.fixed,
//       // currentIndex: _selectedIndex,
//       items: Globals.homeObject["Bottom_Navigation__c"]
//           .split(";")
//           .map<BottomNavigationBarItem>((e) => BottomNavigationBarItem(
//                 icon: Column(children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ValueListenableBuilder(
//                         builder: (BuildContext context, dynamic value,
//                             Widget? child) {
//                           return Expanded(
//                             child: Text(
//                               e.split("_")[0],
//                               textAlign: TextAlign.center,
//                               style: Theme.of(context).textTheme.subtitle2,
//                             ),
//                           );
//                         },
//                         valueListenable: langadded,
//                         child: Container(),
//                       ),
//                       ValueListenableBuilder(
//                         builder: (BuildContext context, dynamic value,
//                             Widget? child) {
//                           return e.split("_")[0] == "News" &&
//                                   indicator.value == true
//                               ? Container(
//                                   height: 8,
//                                   width: 8,
//                                   margin: EdgeInsets.only(left: 3),
//                                   decoration: BoxDecoration(
//                                       color: Colors.red,
//                                       shape: BoxShape.circle),
//                                 )
//                               : Container();
//                         },
//                         valueListenable: indicator,
//                         child: Container(),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 5.0),
//                     child: Icon(
//                       IconData(int.parse(e.split("_")[1]),
//                           fontFamily: Overrides.kFontFam,
//                           fontPackage: Overrides.kFontPkg),
//                       size: Globals.deviceType == "phone" ? 24 : 32,
//                     ),
//                   ),
//                 ]),
//                 label: '', //'${e.split("_")[0]}',
//               ))
//           .toList(),
//       onTap: (index) {
//         setState(() {
//           // _selectedIndex = index;
//           Globals.internalBottombarIndex = index;
//         });
//       },
//     );
//   }
// }
