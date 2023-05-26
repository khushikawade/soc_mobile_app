import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/assessment_history_screen.dart';
import 'package:Soc/src/modules/graded_plus/widgets/custom_intro_layout.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_class.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_staff.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/select_assessment_type_screen.dart';

class GradedPlusBottomNavBar {
  /* ------- function to return list of widget for bottom navigation bar ------ */
  static List<StatefulWidget> gradedPlusBuildPersistentScreens(
      {required VoidCallback backOnTap}) {
    List<StatefulWidget> screens = [
      PBISPlusClass(
        isGradedPlus: true,
        titleIconData: const IconData(0xe825,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        backOnTap: backOnTap,
      ),
      GradedPlusAssessmentSummary(
        isFromHomeSection: true,
        selectedFilterValue: 'All',
      ),
      GradedPlusSelectAssessmentTypeSection(),
      CustomIntroWidget(
        isFromHelp: true,
      ),
      PBISPlusStaff(
        titleIconData: getStaffIconCode(),
      )
    ];

    return Overrides.STANDALONE_GRADED_APP
        ? [
            screens[0],
            screens[2],
            screens[1],
          ]
        : screens;
  }

  /* ---------- function to return list of bottom navigation bar item --------- */
  static List<PersistentBottomNavBarItem> gradedPlusNavbarItems(
      {required BuildContext context}) {
    List<PersistentBottomNavBarItem> items = [
      PersistentBottomNavBarItem(
        icon: gardedPlusBottomNavBarIcons(
          iconData: IconData(0xe825,
              fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        ),
        title: 'Class',
        activeColorPrimary: AppTheme.kButtonColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: gardedPlusBottomNavBarIcons(
          iconData: IconData(0xe824,
              fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        ),
        title: 'History',
        activeColorPrimary: AppTheme.kButtonColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        iconSize: 30,
        icon: const Icon(Icons.add),
        title: 'Scan',
        activeColorPrimary: AppTheme.kButtonColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: gardedPlusBottomNavBarIcons(
          iconData: IconData(0xe849,
              fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        ),
        title: ('Help'),
        activeColorPrimary: AppTheme.kButtonColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: gardedPlusBottomNavBarIcons(
          iconData: getStaffIconCode(),
        ),
        title: 'Staff',
        activeColorPrimary: AppTheme.kButtonColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];

    return Overrides.STANDALONE_GRADED_APP
        ? [items[0], items[2], items[1]]
        : items;

    // return [
    //   PersistentBottomNavBarItem(
    //     icon: const Icon(Icons.home),
    //     title: ("Home"),
    //     activeColorPrimary: Colors.deepPurple,
    //     inactiveColorPrimary: Colors.grey,
    //   ),
    //   PersistentBottomNavBarItem(
    //     icon: const Icon(Icons.explore),
    //     title: ("Explore"),
    //     activeColorPrimary: Colors.deepPurple,
    //     inactiveColorPrimary: Colors.grey,
    //   ),
    //   PersistentBottomNavBarItem(
    //     icon: const Icon(Icons.add, color: Colors.white),
    //     activeColorPrimary: Colors.deepPurple,
    //     inactiveColorPrimary: Colors.grey,
    //   ),
    //   PersistentBottomNavBarItem(
    //     icon: const Icon(Icons.email),
    //     title: ("Inbox"),
    //     activeColorPrimary: Colors.deepPurple,
    //     inactiveColorPrimary: Colors.grey,
    //   ),
    //   PersistentBottomNavBarItem(
    //     icon: const Icon(Icons.shopping_bag),
    //     title: ("Shop"),
    //     activeColorPrimary: Colors.deepPurple,
    //     inactiveColorPrimary: Colors.grey,
    //   ),
    // ];
  }

  // /* -------------------- bottom navigation bar item widget ------------------- */
  // static Widget gardedPlusBottomNavBarIcons(IconData iconData, title, context) {
  //   return title == 'Scan'
  //       ? Icon(
  //           iconData,
  //         )
  //       : Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Flexible(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Icon(
  //                     iconData,
  //                   ),
  //                   SpacerWidget(2),
  //                   TranslationWidget(
  //                     shimmerHeight: 8,
  //                     message: title,
  //                     fromLanguage: "en",
  //                     toLanguage: Globals.selectedLanguage,
  //                     builder: (translatedMessage) => Expanded(
  //                       child: FittedBox(
  //                         child: Text(
  //                           translatedMessage.toString(),
  //                           overflow: TextOverflow.ellipsis,
  //                           maxLines: 2,
  //                           style: Theme.of(context).textTheme.headline4!,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         );
  // }

  /* -------------------- bottom navigation bar item widget ------------------- */
  static Widget gardedPlusBottomNavBarIcons(
      {required IconData iconData, Color? color}) {
    return Icon(
      iconData,
      color: color,
    );
  }

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
