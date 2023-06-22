import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_class.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_history.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_notes_section/pbis_plus_notes.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_staff.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class PBISBottomNavBar {
  /* ------- function to return list of widget for bottom navigation bar ------ */
  static List<Widget> pbisBuildPersistentScreens(
      {required VoidCallback backOnTap}) {
    return [
      PBISPlusClass(
        titleIconData: IconData(0xe825,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        backOnTap: backOnTap,
      ),
      PBISPlusHistory(
        titleIconData: IconData(0xe824,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
      ),
      PBISPlusStaff(
        titleIconData: getStaffIconCode(),
      ),
      PBISPlusNotes(
        titleIconData: IconData(0xe824,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
      ),
    ];
  }

  /* ---------- function to return list of bottom navigation bar item --------- */
  static List<PersistentBottomNavBarItem> navBarsItems(
      {required BuildContext context}) {
    return [
      PersistentBottomNavBarItem(
        icon: pbisBottomNavBarIcons(
            IconData(0xe825,
                fontFamily: Overrides.kFontFam,
                fontPackage: Overrides.kFontPkg),
            'Class',
            context),
        activeColorPrimary: AppTheme.kButtonColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: pbisBottomNavBarIcons(
            IconData(0xe824,
                fontFamily: Overrides.kFontFam,
                fontPackage: Overrides.kFontPkg),
            'History',
            context),
        activeColorPrimary: AppTheme.kButtonColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: pbisBottomNavBarIcons(getStaffIconCode(), 'Staff', context),
        activeColorPrimary: AppTheme.kButtonColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: pbisBottomNavBarIcons(getStaffIconCode(), 'Notes', context),
        activeColorPrimary: AppTheme.kButtonColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  /* -------------------- bottom navigation bar item widget ------------------- */
  static Widget pbisBottomNavBarIcons(IconData iconData, title, context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 22,
              ),
              SpacerWidget(2),
              TranslationWidget(
                shimmerHeight: 8,
                message: title,
                fromLanguage: "en",
                toLanguage: Globals.selectedLanguage,
                builder: (translatedMessage) => Expanded(
                  child: FittedBox(
                    child: Text(
                      translatedMessage.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.headline4!,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
