import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_common_behavior_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_student_list_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_total_Behavior_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pibs_plus_history_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_appbar.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PBISPlusUtility {
  static var f = NumberFormat.compact();
  // static final _digitRoundOffAbbreviations = ['k', 'M', 'B', 'T'];

  static final LocalDatabase<ClassroomCourse> classroomLocalDb =
      LocalDatabase(PBISPlusOverrides.pbisPlusClassroomDB);

  static final LocalDatabase<PBISPlusCommonBehaviorModal> customUserBehaviorDB =
      LocalDatabase(
          PBISPlusOverrides.PbisPlusTeacherCustomBehaviorLocalDbTable);

  static final LocalDatabase<PBISPlusHistoryModal> pbisPlusHistoryDB =
      LocalDatabase(PBISPlusOverrides.PBISPlusHistoryDB);

  static final LocalDatabase<PBISPlusNotesUniqueStudentList>
      _pbisPlusStudentListDB =
      LocalDatabase(PBISPlusOverrides.pbisPlusStudentListDB);

// //Used to round off any digit greater than 999
//   static String numberAbbreviationFormat(value) {
//     try {
//       if (value < 1000) return '$value';
//       final exp = (value / 1e3).floor();
//       final suffixIndex = (exp - 1) % _digitRoundOffAbbreviations.length;
//       final suffix = _digitRoundOffAbbreviations[suffixIndex];
//       final truncated = (value / (1e3 * exp)).toStringAsFixed(1);
//       return '$truncated$suffix';
//     } catch (e) {
//       return value;
//     }
//   }

//Used to round off any digit greater than 999

  static String numberAbbreviationFormat(value) {
    try {
      return f.format(value).toString();
    } catch (e) {
      return value ?? '0';
    }
  }

  static Color oppositeBackgroundColor({required BuildContext context}) {
    return Color(0xff000000) != Theme.of(context).backgroundColor
        ? Color(0xff111C20)
        : Color(0xffF7F8F9);
  }

  static PreferredSizeWidget pbisAppBar(
      {required BuildContext context,
      required IconData titleIconData,
      required title,
      required GlobalKey<ScaffoldState> scaffoldKey,
      bool? isGradedPlus,
      required ValueChanged? refresh}) {
    return PBISPlusAppBar(
        scaffoldKey: scaffoldKey,
        title: title,
        titleIconData: titleIconData,
        isGradedPlus: isGradedPlus,
        refresh: refresh);
  }

  static String convertDateString(String? dateString) {
    final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    final outputFormat = DateFormat('MM/dd/yyyy');

    final date = dateString?.isNotEmpty == true
        ? inputFormat.parse(dateString!)
        : DateTime.now();

    return outputFormat.format(date);
  }

  static int getStudentTotalCounts(
      {required ClassroomStudents student,
      required bool? isCustomBehavior,
      required List<PBISPlusCommonBehaviorModal> teacherCustomBehaviorList}) {
    try {
      int totalCounts = 0;

      if (isCustomBehavior == true && teacherCustomBehaviorList.isNotEmpty) {
        for (PBISPlusCommonBehaviorModal CustomBehavior
            in teacherCustomBehaviorList) {
          for (BehaviorList Behavior in student.profile!.behaviorList ?? []) {
            if (Behavior.id == CustomBehavior.id) {
              var score = Behavior.behaviorCount ?? 0;
              totalCounts += score;
              break;
            }
          }
        }
      } else {
        totalCounts = student.profile!.behaviorList!
            .where((behavior) => behavior.defaultBehavior == true)
            .map((behavior) => behavior.behaviorCount ?? 0)
            .fold(0, (sum, count) => sum + count);
      }

      return totalCounts ?? 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*-------------------------------------------------getCustomValue----------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  static isCustomBehaviour() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final storedValue = pref.getBool(Strings.isCustomBehavior);
      if (storedValue != null) {
        PBISPlusOverrides.isCustomBehavior.value = storedValue;
      }
    } catch (e) {}
  }

  static playSound(String audioPath) {
    try {
      AudioPlayer().play(AssetSource(audioPath));
    } catch (e) {
      print(e);
    }
  }

  static cleanPbisPlusDataOnLogOut() async {
    try {
      //clear custom user behavior data
      await classroomLocalDb.clear();
      //clear custom user behavior data
      await customUserBehaviorDB.clear();
      //clear pbis Plus history data
      await pbisPlusHistoryDB.clear();

      // clear pbis plus student notes data
      await _pbisPlusStudentListDB.clear();

      //set toggle button off
      await setToggleValue(value: false);
    } catch (e) {
      print(
          "-------------------caught error while cleanig pbis plus data setToggleValue method = cleanPbisPlusDataOnLogOut ------------------------");
      print(e);
    }
  }

  static setToggleValue({bool? value}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool(Strings.isCustomBehavior,
          value ?? PBISPlusOverrides.isCustomBehavior.value);
    } catch (e) {
      print(
          "-------------------caught error while cleanig pbis plus data method = {setToggleValue} ------------------------");
    }
  }
}
