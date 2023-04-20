import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PBISPlusUtility {
  static final _digitRoundOffAbbreviations = ['k', 'M', 'B', 'T'];

//Used to round off any digit greater than 999
  static String numberAbbreviationFormat(int value) {
    if (value < 1000) return '$value';
    final exp = (value / 1e3).floor();
    final suffixIndex = (exp - 1) % _digitRoundOffAbbreviations.length;
    final suffix = _digitRoundOffAbbreviations[suffixIndex];
    final truncated = (value / (1e3 * exp)).toStringAsFixed(1);
    return '$truncated$suffix';
  }

  static Color oppositeBackgroundColor({required BuildContext context}) {
    return Color(0xff000000) != Theme.of(context).backgroundColor
        ? Color(0xff111C20)
        : Color(0xffF7F8F9);
  }

  static PreferredSizeWidget pbisAppBar(
      BuildContext context, IconData titleIconData) {
    return PBISPlusAppBar(
      title: 'Class',
      titleIconData: titleIconData,
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
}
