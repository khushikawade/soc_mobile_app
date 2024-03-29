// import 'package:Soc/src/overrides.dart';
// import 'package:Soc/src/services/utility.dart';
// import 'package:Soc/src/styles/theme.dart';
// import 'package:flutter/material.dart';

// class StudentPlusScreenTitleWidget extends StatelessWidget {
//   final double kLabelSpacing;
//   final String text;
//   final bool? backButton;
//   const StudentPlusScreenTitleWidget(
//       {Key? key,
//       required this.kLabelSpacing,
//       required this.text,
//       this.backButton = false})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 0, horizontal: kLabelSpacing / 2),
//       child: Row(
//         children: [
//           if (backButton == true)
//             IconButton(
//               alignment: Alignment.centerLeft,
//               padding: EdgeInsets.zero,
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               icon: Icon(
//                 IconData(0xe80d,
//                     fontFamily: Overrides.kFontFam,
//                     fontPackage: Overrides.kFontPkg),
//                 color: AppTheme.kButtonColor,
//               ),
//             ),
//           Utility.textWidget(
//               text: text,
//               context: context,
//               textTheme: Theme.of(context)
//                   .textTheme
//                   .headline5!
//                   .copyWith(fontWeight: FontWeight.w700)),
//         ],
//       ),
//     );
//   }
// }
