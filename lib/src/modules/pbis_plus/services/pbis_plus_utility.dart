import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_appbar.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PBISPlusUtility {
  static final _digitRoundOffAbbreviations = ['k', 'M', 'B', 'T'];

//Used to round off any digit greater than 999
  static String numberAbbreviationFormat(value) {
    try {
      if (value < 1000) return '$value';
      final exp = (value / 1e3).floor();
      final suffixIndex = (exp - 1) % _digitRoundOffAbbreviations.length;
      final suffix = _digitRoundOffAbbreviations[suffixIndex];
      final truncated = (value / (1e3 * exp)).toStringAsFixed(1);
      return '$truncated$suffix';
    } catch (e) {
      return value;
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
      bool? isGradedPlus}) {
    return PBISPlusAppBar(
      scaffoldKey: scaffoldKey,
      title: title,
      titleIconData: titleIconData,
      isGradedPlus: isGradedPlus,
    );
  }

  static String convertDateString(String? dateString) {
    final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    final outputFormat = DateFormat('MM/dd/yyyy');

    final date = dateString?.isNotEmpty == true
        ? inputFormat.parse(dateString!)
        : DateTime.now();

    return outputFormat.format(date);
  }

  static String getStudentTotalCounts(ClassroomStudents student) {
    try {
      // Get the total counts
      int? totalCounts = student.profile!.behaviorList!
          .map((behavior) => behavior.score ?? 0)
          .reduce((sum, count) => sum + count);

      return totalCounts?.toString() ?? "0";
    } catch (e) {
      //  print(e);
      return "0";
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
}
