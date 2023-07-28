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
      PBISPlusEditSkills(
          titleIconData: const IconData(0xe898,
              fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg)),
      PBISPlusNotesStudentList(
          titleIconData: IconData(0xe895,
              fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg)),
      PBISPlusStaff(titleIconData: getStaffIconCode()),
    ];

    return screens;
  }

  /* ---------- function to return list of bottom navigation bar item --------- */
  static List<PersistentBottomNavBarItem> pbisPlusNavbarItems(
      {required BuildContext context}) {
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
              iconData: IconData(0xe895,
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
    return Icon(iconData, color: color, size: 24);
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
