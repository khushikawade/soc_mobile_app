import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/ui/list_assessment_summary.dart';
import 'package:Soc/src/modules/graded_plus/ui/select_assessment_type.dart';
import 'package:Soc/src/modules/graded_plus/widgets/custom_intro_layout.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_class.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_staff.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class GradedBottomNavBar {
  /* ------- function to return list of widget for bottom navigation bar ------ */
  static List<StatefulWidget> gradedPlusBuildPersistentScreens() {
    List<StatefulWidget> screens = [
      PBISPlusClass(
        titleIconData: const IconData(0xe825,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        backOnTap: (() {}),
      ),
      AssessmentSummary(
        isFromHomeSection: true,
        selectedFilterValue: 'All',
      ),
      SelectAssessmentType(),
      CustomIntroWidget(),
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
  static List<PersistentBottomNavBarItem> gradedPlusnavBarsItems(
      {required BuildContext context}) {
    List<PersistentBottomNavBarItem> items = [
      PersistentBottomNavBarItem(
        icon: gardedPlusBottomNavBarIcons(
            IconData(0xe825,
                fontFamily: Overrides.kFontFam,
                fontPackage: Overrides.kFontPkg),
            'Class',
            context),
        activeColorPrimary: AppTheme.kButtonColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: gardedPlusBottomNavBarIcons(
            IconData(0xe824,
                fontFamily: Overrides.kFontFam,
                fontPackage: Overrides.kFontPkg),
            'History',
            context),
        activeColorPrimary: AppTheme.kButtonColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: gardedPlusBottomNavBarIcons(
            IconData(0xe875,
                fontFamily: Overrides.kFontFam,
                fontPackage: Overrides.kFontPkg),
            'Scan',
            context),
        activeColorPrimary: AppTheme.kButtonColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: gardedPlusBottomNavBarIcons(
            IconData(0xe849,
                fontFamily: Overrides.kFontFam,
                fontPackage: Overrides.kFontPkg),
            'Help',
            context),
        activeColorPrimary: AppTheme.kButtonColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: gardedPlusBottomNavBarIcons(getStaffIconCode(), 'Staff', context),
        activeColorPrimary: AppTheme.kButtonColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];

    return Overrides.STANDALONE_GRADED_APP
        ? [items[0], items[2], items[1]]
        : items;
  }

  /* -------------------- bottom navigation bar item widget ------------------- */
  static Widget gardedPlusBottomNavBarIcons(IconData iconData, title, context) {
    return title == 'Scan'
        ? Icon(
            iconData,
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      iconData,
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
