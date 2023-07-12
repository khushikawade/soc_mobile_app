// import 'package:Soc/src/globals.dart';
// import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_class.dart';
// import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_edit_skills.dart';
// import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_history.dart';
// import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_notes_section/pbis_plus_notes_student_list.dart';
// import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_staff.dart';
// import 'package:Soc/src/overrides.dart';
// import 'package:Soc/src/styles/theme.dart';
// import 'package:Soc/src/translator/translation_widget.dart';
// import 'package:Soc/src/widgets/spacer_widget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

// class PBISBottomNavBar {
//   /* ------- function to return list of widget for bottom navigation bar ------ */
//   static List<Widget> pbisBuildPersistentScreens(
//       {required VoidCallback backOnTap}) {
//     return [
//       PBISPlusClass(
//         titleIconData: IconData(
//           0xe825,
//           fontFamily: Overrides.kFontFam,
//           fontPackage: Overrides.kFontPkg,
//         ),
//         backOnTap: backOnTap,
//         isGradedPlus: false,
//       ),
//       PBISPlusHistory(
//         titleIconData: IconData(0xe824,
//             fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
//       ),
//       PBISPlusEditSkills(),
//       PBISPlusNotesStudentList(
//         titleIconData: IconData(0xe892,
//             fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
//       ),
//       PBISPlusStaff(
//         titleIconData: getStaffIconCode(),
//       ),
//     ];
//   }

//   /* ---------- function to return list of bottom navigation bar item --------- */
//   static List<PersistentBottomNavBarItem> navBarsItems(
//       {required BuildContext context}) {
//     return [
//       PersistentBottomNavBarItem(
//         icon: pbisBottomNavBarIcons(
//             IconData(0xe825,
//                 fontFamily: Overrides.kFontFam,
//                 fontPackage: Overrides.kFontPkg),
//             'Class',
//             context),
//         activeColorPrimary: AppTheme.kButtonColor,
//         inactiveColorPrimary: CupertinoColors.systemGrey,
//       ),
//       PersistentBottomNavBarItem(
//         icon: pbisBottomNavBarIcons(
//             IconData(0xe824,
//                 fontFamily: Overrides.kFontFam,
//                 fontPackage: Overrides.kFontPkg),
//             'History',
//             context),
//         activeColorPrimary: AppTheme.kButtonColor,
//         inactiveColorPrimary: CupertinoColors.systemGrey,
//       ),
//       PersistentBottomNavBarItem(
//           iconSize: 30,
//           icon: const Icon(Icons.add),
//           title: 'Edit Behavior',
//           activeColorPrimary: AppTheme.kButtonColor,
//           inactiveColorPrimary: CupertinoColors.systemGrey),
//       PersistentBottomNavBarItem(
//         icon: pbisBottomNavBarIcons(
//             IconData(0xe892,
//                 fontFamily: Overrides.kFontFam,
//                 fontPackage: Overrides.kFontPkg),
//             'Notes',
//             context),
//         activeColorPrimary: AppTheme.kButtonColor,
//         inactiveColorPrimary: CupertinoColors.systemGrey,
//       ),
//       PersistentBottomNavBarItem(
//         icon: pbisBottomNavBarIcons(getStaffIconCode(), 'Staff', context),
//         activeColorPrimary: AppTheme.kButtonColor,
//         inactiveColorPrimary: CupertinoColors.systemGrey,
//       ),
//     ];
//   }

//   /* -------------------- bottom navigation bar item widget ------------------- */
//   static Widget pbisBottomNavBarIcons(IconData iconData, title, context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Flexible(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 iconData,
//                 size: 22,
//               ),
//               SpacerWidget(2),
//               TranslationWidget(
//                 shimmerHeight: 8,
//                 message: title,
//                 fromLanguage: "en",
//                 toLanguage: Globals.selectedLanguage,
//                 builder: (translatedMessage) => Expanded(
//                   child: FittedBox(
//                     child: Text(
//                       translatedMessage.toString(),
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 2,
//                       style: Theme.of(context).textTheme.headline4!,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   /* --------- function to get staff icon code from main bottom navBar -------- */
//   static IconData getStaffIconCode() {
//     String staffIconCode = '0xe808';
//     IconData iconData = IconData(int.parse(staffIconCode),
//         fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg);
//     for (var i = 0;
//         i < Globals.appSetting.bottomNavigationC!.split(";").length;
//         i++) {
//       if (Globals.appSetting.bottomNavigationC!.split(";").contains('staff')) {
//         staffIconCode =
//             Globals.appSetting.bottomNavigationC!.split(";")[i].split("_")[1];

//         return IconData(int.parse(staffIconCode),
//             fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg);
//       }
//     }
//     return iconData;
//   }
// }

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_class.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_edit_skills.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_history.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_notes_section/pbis_plus_notes_student_list.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_staff.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class PbisPlusBottomNavBar {
  /* ------- function to return list of widget for bottom navigation bar ------ */
  static List<StatefulWidget> pbisPlusBuildPersistentScreens(
      {required VoidCallback backOnTap}) {
    List<StatefulWidget> screens = [
      PBISPlusClass(
          titleIconData: IconData(0xe825,
              fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
          backOnTap: backOnTap,
          isGradedPlus: false),
      PBISPlusHistory(
          titleIconData: IconData(0xe824,
              fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg)),
      PBISPlusEditSkills(),
      PBISPlusNotesStudentList(
          titleIconData: IconData(0xe896,
              fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg)),
      PBISPlusStaff(titleIconData: getStaffIconCode()),
    ];

    return screens;
  }

  /* ---------- function to return list of bottom navigation bar item --------- */
  static List<PersistentBottomNavBarItem> pbisPlusNavbarItems(
      {required BuildContext context}) {
    // List<PersistentBottomNavBarItem> items = [
    //   PersistentBottomNavBarItem(
    //     icon: pbisBottomNavBarIcons(
    //         IconData(0xe825,
    //             fontFamily: Overrides.kFontFam,
    //             fontPackage: Overrides.kFontPkg),
    //         'Class',
    //         context),
    //     activeColorPrimary: AppTheme.kButtonColor,
    //     inactiveColorPrimary: CupertinoColors.systemGrey,
    //   ),
    //   PersistentBottomNavBarItem(
    //     icon: pbisBottomNavBarIcons(
    //         IconData(0xe824,
    //             fontFamily: Overrides.kFontFam,
    //             fontPackage: Overrides.kFontPkg),
    //         'History',
    //         context),
    //     activeColorPrimary: AppTheme.kButtonColor,
    //     inactiveColorPrimary: CupertinoColors.systemGrey,
    //   ),
    //   PersistentBottomNavBarItem(
    //       iconSize: 30,
    //       icon: const Icon(Icons.add),
    //       title: 'Edit Behavior',
    //       activeColorPrimary: AppTheme.kButtonColor,
    //       inactiveColorPrimary: CupertinoColors.systemGrey),
    //   PersistentBottomNavBarItem(
    //     icon: pbisBottomNavBarIcons(
    //         IconData(0xe892,
    //             fontFamily: Overrides.kFontFam,
    //             fontPackage: Overrides.kFontPkg),
    //         'Notes',
    //         context),
    //     activeColorPrimary: AppTheme.kButtonColor,
    //     inactiveColorPrimary: CupertinoColors.systemGrey,
    //   ),
    //   PersistentBottomNavBarItem(
    //     icon: pbisBottomNavBarIcons(getStaffIconCode(), 'Staff', context),
    //     activeColorPrimary: AppTheme.kButtonColor,
    //     inactiveColorPrimary: CupertinoColors.systemGrey,
    //   ),
    // ];

    List<PersistentBottomNavBarItem> items = [
      PersistentBottomNavBarItem(
          icon: bottomNavBarIcons(
              iconData: IconData(0xe825,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg)),
          title: 'Class',
          activeColorPrimary: AppTheme.kButtonColor,
          inactiveColorPrimary: CupertinoColors.systemGrey),
      PersistentBottomNavBarItem(
          icon: bottomNavBarIcons(
              iconData: IconData(0xe824,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg)),
          title: 'History',
          activeColorPrimary: AppTheme.kButtonColor,
          inactiveColorPrimary: CupertinoColors.systemGrey),
      PersistentBottomNavBarItem(
          iconSize: 30,
          icon: const Icon(Icons.add),
          title: 'Edit',
          activeColorPrimary: AppTheme.kButtonColor,
          inactiveColorPrimary: CupertinoColors.systemGrey),
      PersistentBottomNavBarItem(
          icon: bottomNavBarIcons(
              iconData: IconData(0xe896,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg)),
          title: ('Notes'),
          activeColorPrimary: AppTheme.kButtonColor,
          inactiveColorPrimary: CupertinoColors.systemGrey),
      PersistentBottomNavBarItem(
          icon: bottomNavBarIcons(
            iconData: getStaffIconCode(),
          ),
          title: 'Staff',
          activeColorPrimary: AppTheme.kButtonColor,
          inactiveColorPrimary: CupertinoColors.systemGrey)
    ];

    return items;
  }

  /* -------------------- bottom navigation bar item widget ------------------- */

  static Widget bottomNavBarIcons({required IconData iconData, Color? color}) {
    return Icon(iconData, color: color);
  }

  /* -------------------- bottom navigation bar item widget ------------------- */
  // static Widget pbisBottomNavBarIcons(IconData iconData, title, context) {
  //   return Row(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [Flexible(child: Icon(iconData, size: 22))]);
  // }

  /* --------- function to get staff icon code from main bottom navBar -------- */
  static IconData getStaffIconCode() {
    String staffIconCode = '0xe808';
    IconData iconData = IconData(int.parse(staffIconCode),
        fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg);
    for (var i = 0;
        i < Globals.appSetting.bottomNavigationC!.split(";").length;
        i++) {
      if (Globals.appSetting.bottomNavigationC!.split(";").contains('staff')) {
        staffIconCode =
            Globals.appSetting.bottomNavigationC!.split(";")[i].split("_")[1];

        return IconData(int.parse(staffIconCode),
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg);
      }
    }
    return iconData;
  }
}
