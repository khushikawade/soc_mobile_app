import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_student_dashbord.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/ui/student_plus_exams.dart';
import 'package:Soc/src/modules/student_plus/ui/student_plus_grades.dart';
import 'package:Soc/src/modules/student_plus/ui/student_plus_info.dart';
import 'package:Soc/src/modules/student_plus/ui/student_plus_pbis.dart';
import 'package:Soc/src/modules/student_plus/ui/student_plus_work.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class StudentPlusBottomNavBar {
  /* ------- function to return list of widget for bottom navigation bar ------ */
  static List<Widget> buildScreens(
      {required StudentPlusDetailsModel studentInfo}) {
    List<Widget> _screens = [];
    _screens.add(StudentPlusInfoScreen(
      studentDetails: studentInfo,
    ));
    _screens.add(StudentPlusExamsScreen(
      studentDetails: studentInfo,
    ));
    _screens.add(StudentPlusWorkScreen(
      studentDetails: studentInfo,
    ));
    _screens.add(StudentPlusGradesPage(
      studentDetails: studentInfo,
    ));
    _screens.add(StudentPlusPBISScreen(
      studentDetails: studentInfo,
      index: 4,
    )
        // studentInfo.emailC == null
        //     ? NoDataFoundErrorWidget(
        //         isResultNotFoundMsg: true, isNews: false, isEvents: false)
        //     : PBISPlusStudentDashBoard(
        //         isValueChangeNotice: isValueChangeNotice,
        //         isFromStudentPlus: true,
        //         studentValueNotifier: studentValueNotifier,
        //         StudentDetailWidget: Column(),
        //         onValueUpdate: (ValueNotifier<ClassroomStudents> data) {},
        //         heroTag: '',
        //         scaffoldKey: scaffoldKey,
        //       ),
        );
    _screens.add(Container());

    return _screens;
  }

  /* ---------- function to return list of bottom navigation bar item --------- */
  static List<PersistentBottomNavBarItem> navBarsItems(
      {required BuildContext context}) {
    List<PersistentBottomNavBarItem> persistentBottomNavBarItemList = [];
    persistentBottomNavBarItemList.add(PersistentBottomNavBarItem(
      icon: bottomIcon("0xe883", '   Info', context),
      activeColorPrimary: AppTheme.kButtonColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ));
    persistentBottomNavBarItemList.add(PersistentBottomNavBarItem(
      icon: bottomIcon("0xe881", 'Exams', context),
      activeColorPrimary: AppTheme.kButtonColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ));
    persistentBottomNavBarItemList.add(PersistentBottomNavBarItem(
      icon: bottomIcon("0xe885", 'Work', context),
      activeColorPrimary: AppTheme.kButtonColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ));
    persistentBottomNavBarItemList.add(PersistentBottomNavBarItem(
      icon: bottomIcon("0xe823", 'Grades', context),
      activeColorPrimary: AppTheme.kButtonColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ));
    persistentBottomNavBarItemList.add(
      PersistentBottomNavBarItem(
        icon: bottomIcon("0xe825", 'PBIS+', context),
        activeColorPrimary: AppTheme.kButtonColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    );
    persistentBottomNavBarItemList.add(PersistentBottomNavBarItem(
      icon: bottomIcon(getStaffIconCode(), 'Staff', context),
      activeColorPrimary: AppTheme.kButtonColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ));

    return persistentBottomNavBarItemList;
  }

  /* --------- function to get staff icon code from main bottom navBar -------- */
  static String getStaffIconCode() {
    String staffIconCode = '0xe808';
    for (var i = 0;
        i < Globals.appSetting.bottomNavigationC!.split(";").length;
        i++) {
      if (Globals.appSetting.bottomNavigationC!.split(";").contains('staff')) {
        staffIconCode =
            Globals.appSetting.bottomNavigationC!.split(";")[i].split("_")[1];
        return staffIconCode;
      }
    }
    return staffIconCode;
  }

  /* -------------------- bottom navigation bar item widget ------------------- */
  static Widget bottomIcon(iconData, title, context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Column(
            children: [
              Icon(
                IconData(int.parse(iconData),
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                // size: 22,
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
}
