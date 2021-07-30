// import 'package:Soc/src/services/utility.dart';
// import 'package:Soc/src/styles/theme.dart';
// import 'package:Soc/src/translator/language_list.dart';
// import 'package:Soc/src/widgets/spacer_widget.dart';
// import 'package:flutter/material.dart';

// class LanguageSelector {
//   LanguageSelector(context, Translations item, onStatusChanged) {
//     _openSettingsBottomSheet(context, item, onStatusChanged);
//   }

//   _buildFilterList(context, Translations item, onStatusChanged /*, onTap*/) {
//     return _listTile(
//       "Text", context,

//       // onStatusChanged, () {
//       //   setfilter(AppTranslations.of(context).text('stop'), statusKey, context,
//       //       onStatusChanged);
//       // }
//     );
//   }

//   Widget _listTile(
//     context,
//     String status,
//     /*statusIcon,onStatusChanged, onTap*/
//   ) =>
//       Container(
//           margin: EdgeInsets.only(left: 30, right: 30, bottom: 12),
//           color: AppTheme.kListTileColor,
//           child: ListTile(
//             onTap: () {
//               // onTap();
//             },
//             // leading: statusIcon,
//             title: Text(
//               status,
//               style: Theme.of(context)
//                   .textTheme
//                   .caption!
//                   .copyWith(color: Theme.of(context).colorScheme.onSecondary),
//             ),
//           ));

//   void setfilter(status, statusKey, context, onStatusChanged) async {
//     onStatusChanged(status, statusKey);
//     Navigator.of(context).pop(true);
//   }

//   _openSettingsBottomSheet(context, Translations item, onStatusChanged) {
//     Utility.showBottomSheet(
//         Container(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(
//                   top: 30,
//                   left: 30,
//                   right: 15,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Text(
//                       "test123",
//                       style: Theme.of(context)
//                           .textTheme
//                           .headline6!
//                           .copyWith(fontSize: AppTheme.kBottomSheetTitleSize),
//                     ),
//                     IconButton(
//                         icon: Icon(
//                           Icons.close,
//                           color: Theme.of(context).colorScheme.secondary,
//                         ),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         }),
//                   ],
//                 ),
//               ),
//               SpacerWidget(30),
//               _buildFilterList(context, item, onStatusChanged),
//               SpacerWidget(30),
//             ],
//           ),
//         ),
//         context);
//   }
// }
