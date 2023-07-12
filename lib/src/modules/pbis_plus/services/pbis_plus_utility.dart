import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_appbar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  static playSound(String audioPath) {
    try {
      AudioPlayer().play(AssetSource(audioPath));
    } catch (e) {
      print(e);
    }
  }
}
