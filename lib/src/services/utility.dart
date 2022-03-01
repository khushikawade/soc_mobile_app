import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class Utility {
  static Size displaySize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double displayHeight(BuildContext context) {
    return displaySize(context).height;
  }

  static String convetTimestampToDate(dynamic timestamp) {
    try {
      DateTime date =
          DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
      String dateFormat = DateFormat("MM/dd/yy").format(date);
      return dateFormat;
    } catch (e) {
      return '';
    }
  }

  static Future<String> errorImageUrl(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return imageUrl;
    } else {
      return imageUrl = '';
    }
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

  static DateTime? convertTimestampToDate(dynamic timestamp) {
    try {
      DateTime date =
          DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
      return date;
    } catch (e) {
      return null;
    }
  }

  static String convertTimestampToDateFormat(
      DateTime timestamp, String format) {
    try {
      // final String date = DateFormat(format).format(timestamp);
      final DateFormat formatter = DateFormat(format);
      final String date = formatter.format(timestamp);
      return date;
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
    // _scaffoldKey.currentState.showSnackBar(SnackBar(
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Container(
        alignment: Alignment.centerLeft,
        height: 40,
        child: TranslationWidget(
          message: msg,
          fromLanguage: "en",
          toLanguage: Globals.selectedLanguage,
          builder: (translatedMessage) => Text(translatedMessage,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Theme.of(context).backgroundColor,
                fontWeight: FontWeight.w600,
              )),
        ),
      ),
      backgroundColor: Colors.black.withOpacity(0.8),
      padding: EdgeInsets.only(
        left: 16,
      ),
      margin: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).size.height * 0.08),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
    ));
  }

  static void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static void upliftPage(context, _scrollController) {
    final d = MediaQuery.of(context).viewInsets.bottom;
    if (d > 0) {
      Timer(
          Duration(milliseconds: 50),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
    }
  }

  static showBottomSheet(body, context) {
    return showModalBottomSheet(
        // isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(AppTheme.kBottomSheetModalUpperRadius),
                topRight:
                    Radius.circular(AppTheme.kBottomSheetModalUpperRadius))),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          {
            return StatefulBuilder(
              builder: (BuildContext context,
                      StateSetter setState /*You can rename this!*/) =>
                  Material(
                child: body,
              ),
            );
          }
        });
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
    final dateTime = formatter.parse(string);
    final DateFormat formatNew = DateFormat('dd/MM/yyyy  hh:mm');
    final String formatted = formatNew.format(dateTime);
    return formatted;
  }

  static convertDateFormat(date) {
    try {
      String dateNew = date;
      final string = dateNew.toString();
      final formatter = DateFormat('yyyy-MM-dd');
      final dateTime = formatter.parse(string);
      final DateFormat formatNew = DateFormat('dd/MMM/yyyy');
      final String formatted = formatNew.format(dateTime);
      // return DateTime.parse((dateNew));
      // print(formatted);
      return formatted;
    } catch (e) {
      print(e);
    }
  }

  static convertHtmlTOText(String data) {
    String? convertedData = parseFragment(data).text;

    return convertedData;
  }

  static convertDateFormat2(date) {
    try {
      String dateNew = date;
      final string = dateNew.toString();
      final formatter = DateFormat('yyyy-MM-dd');
      final dateTime = formatter.parse(string);
      //final DateFormat formatNew = DateFormat('dd/MM/yyyy');
      final DateFormat formatNew = DateFormat('MM/dd/yyyy');

      final String formatted = formatNew.format(dateTime);
      // return DateTime.parse((dateNew));
      // print(formatted);
      return formatted;
    } catch (e) {
      print(e);
    }
  }

  static generateUniqueId(date) {
    try {
      DateTime parseDate =
          DateFormat('E, d MMM yyyy HH:mm:ss').parse(date).toLocal();
      final uniqueId = parseDate.millisecondsSinceEpoch;
      return uniqueId;
    } catch (e) {
      print(e);
    }
  }

  static getDate(date) {
    try {
      DateTime parseDate =
          new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").parse(date).toLocal();
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
      // var outputDate = outputFormat.format(inputDate);
      // print(outputDate);
      // String dateNew = date;
      // final string = dateNew.toString();
      // final formatter = DateFormat('yyyy-MM-dd');
      // final dateTime = formatter.parse(string);
      // final DateFormat formatNew = DateFormat('dd/MMM/yyyy');
      // final String formatted = dateTime.day.toString();
      // return DateTime.parse((dateNew));

      // print(formatted);
      return outputFormat;
    } catch (e) {
      print(e);
    }
  }

  static getMonthFromDate(date) {
    String dateNew = date;
    final string = dateNew.toString();
    final formatter = DateFormat('yyyy-MM-dd');
    final dateTime = formatter.parse(string);
    final DateFormat formatNew = DateFormat('dd/MMM/yyyy');
    final String formatted = formatNew.format(dateTime);
    // print(formatted);
    return formatted;
  }

  static Color getColorFromHex(String hexCode) {
    try {
      return Color(int.parse("0xff${hexCode.split('#')[1]}"));
    } catch (e) {
      return Colors.blue;
    }
  }

  static String getHTMLImgSrc(str) {
    try {
      String htmlTxt = str.replaceAll("\n", "");
      var document = parse(htmlTxt);
      var img = document.getElementsByTagName('img');
      if (img.length > 0) {
        return img[0].attributes['src']!;
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  static String parseHtml(str) {
    if (str == null) return "";
    String htmlTxt = str.replaceAll("\n", "");
    var document = parse(htmlTxt);
    return document.body!.text;
  }

  static launchUrlOnExternalBrowser(String url) async {
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
    try {
      await launch(url);
    } catch (e) {
      print(e);
    }
  }

  static Future<File> createFileFromUrl(_url, imageExtType) async {
    try {
      Uri _imgUrl = Uri.parse(_url);
      // String _fileExt = _imgUrl.query != ""
      //     ? _imgUrl.query.split('format=')[1].split("&")[0]
      //     : _imgUrl.path.split('.').last;

      String _fileExt = imageExtType != "" && imageExtType != null
          ? imageExtType.split('/').last
          : _imgUrl.query != ""
              ? _imgUrl.query.split('format=')[1].split("&")[0]
              : _imgUrl.path.split('.').last;
      String _fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Response<List<int>> rs = await Dio().get<List<int>>(
        _url,
        options: Options(responseType: ResponseType.bytes),
      );
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = new File('$dir/$_fileName.$_fileExt');
      await file.writeAsBytes(rs.data!);
      return file;
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }

  static String utf8convert(String? text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  static Future<String> sslErrorHandler(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return "No";
      } else {
        return "No";
      }
    } catch (e) {
      print(e.toString());
      if (e.toString().contains('HandshakeException')) {
        return 'Yes';
      }
      return 'No';
    }
  }
}
