import 'dart:async';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Utility {
  static Size displaySize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double displayHeight(BuildContext context) {
    return displaySize(context).height;
  }

  static double displayWidth(BuildContext context) {
    return displaySize(context).width;
  }

  static String formatDate(String format, String dateTime) {
    try {
      String timeFormat =
          DateFormat("$format").format(DateTime.parse(dateTime));
      return timeFormat;
    } catch (e) {
      return '';
    }
  }

  static selectDate(context, callback) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              child: CupertinoDatePicker(
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (DateTime newdate) {
                  callback(newdate);
                },
                use24hFormat: true,
                maximumDate: new DateTime.now(),
                minimumYear: 1980,
                maximumYear: new DateTime.now().year,
                minuteInterval: 1,
                mode: CupertinoDatePickerMode.date,
              ));
        });
  }

  static bool compareArrays(List array1, List array2) {
    if (array1.length == array2.length) {
      return array1.every((value) => array2.contains(value));
    } else {
      return false;
    }
  }

  static void showSnackBar(_scaffoldKey, msg, context) {
    // _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("$msg",
          style: TextStyle(
              color: Theme.of(context).backgroundColor,
              fontWeight: FontWeight.w600)),
      duration: Duration(seconds: 3),
    ));
  }

  static void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static void upliftPage(context, _scrollController) {
    var d = MediaQuery.of(context).viewInsets.bottom;
    if (d > 0) {
      Timer(
          Duration(milliseconds: 50),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
    }
  }

  static showBottomSheet(body, context) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(AppTheme.kBottomSheetModalUpperRadius),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) => Material(
        child: body,
      ),
    );
  }

  static void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  static String getUSADateFormat(picked) {
    return new DateFormat.jm().format(picked.toLocal()).toString();
  }

  String convertUSADateFormat(picked) {
    return new DateFormat.yMMMd('en_US').format(picked.toLocal()).toString();
  }

  static convertDate(date) {
    String dateNew = date.toString().substring(5).split("}")[0];

    final string = dateNew.toString();
    final formatter = DateFormat('EEE, d MMM yyyy HH:mm');
    var dateTime = formatter.parse(string);
    final DateFormat formatNew = DateFormat('dd/MM/yyyy  hh:mm');
    final String formatted = formatNew.format(dateTime);
    return formatted;
  }

  static convertDateFormat(date) {
    String dateNew = date;

    final string = dateNew.toString();
    final formatter = DateFormat('yyyy-MM-dd');
    var dateTime = formatter.parse(string);
    final DateFormat formatNew = DateFormat('dd/MM/yyyy');
    final String formatted = formatNew.format(dateTime);
    return formatted;
  }

  static getMonthFromDate(date) {
    String dateNew = date;

    final string = dateNew.toString();
    final formatter = DateFormat('yyyy-MM-dd');
    var dateTime = formatter.parse(string);
    final DateFormat formatNew = DateFormat('dd/MMM/yyyy');
    final String formatted = formatNew.format(dateTime);
    return formatted;
  }
}
