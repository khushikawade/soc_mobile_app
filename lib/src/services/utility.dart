import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/ui/iconsmenu.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_overrides.dart';
import 'package:Soc/src/modules/graded_plus/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/graded_plus/bloc/graded_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/language_list.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/translator/translator_api.dart';
import 'package:Soc/src/widgets/google_auth_webview.dart';
import 'package:Soc/src/widgets/graded_globals.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart';
import 'package:mailto/mailto.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'user_profile.dart';
import '../modules/graded_plus/modal/user_info.dart';
import 'local_database/local_db.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:audioplayers/audioplayers.dart';

class Utility {
  final player = AudioCache();
  static bool? isOldUser = false;
  static Size displaySize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double displayHeight(BuildContext context) {
    return displaySize(context).height;
  }

  // static String convetTimestampToDate(dynamic timestamp) {
  //   try {
  //     DateTime date =
  //         DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
  //     String dateFormat = DateFormat("MM/dd/yy").format(date);
  //     return dateFormat;
  //   } catch (e) {
  //     return '';
  //   }
  // }

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

  // static String formatDate(String format, String dateTime) {
  //   try {
  //     String timeFormat =
  //         DateFormat("$format").format(DateTime.parse(dateTime));
  //     return timeFormat;
  //   } catch (e) {
  //     return '';
  //   }
  // }

  static DateTime? convertTimestampToDate(dynamic timestamp) {
    try {
      DateTime date =
          DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
      return date;
    } catch (e) {
      return null;
    }
  }

  static doVibration() async {
    try {
      await HapticFeedback.vibrate();
    } catch (e) {
      print(e);
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

  static bool compareArrays(List array1, List array2) {
    if (array1.length == array2.length) {
      return array1.every((value) => array2.contains(value));
    } else {
      return false;
    }
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

  static void setLocked() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static void setFree() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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

  static String convertUSADateFormat(picked) {
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

  static convertDateUSFormat(date) {
    try {
      String dateNew = date;
      final string = dateNew.toString();
      final formatter = DateFormat('yyyy-MM-dd');
      final dateTime = formatter.parse(string);
      final DateFormat formatNew = DateFormat('MM/dd/yyyy');
      final String formatted = formatNew.format(dateTime);

      return formatted;
    } catch (e) {
      return date.toString();
    }
  }

  static convertDateFormat(date) {
    try {
      String dateNew = date;
      final string = dateNew.toString();
      final formatter = DateFormat('yyyy-MM-dd');
      final dateTime = formatter.parse(string);
      final DateFormat formatNew = DateFormat('dd/MMM/yyyy');
      final String formatted = formatNew.format(dateTime);

      return formatted;
    } catch (e) {
      print(e);
    }
  }

  static convertHtmlTOText(String data) {
    String? convertedData = parseFragment(data).text;

    return convertedData;
  }

  // static convertDateFormat2(date) {
  //   try {
  //     String dateNew = date;
  //     final string = dateNew.toString();
  //     final formatter = DateFormat('yyyy-MM-dd');
  //     final dateTime = formatter.parse(string);

  //     final DateFormat formatNew = DateFormat('dd/MMM/yyyy');

  //     final String formatted = formatNew.format(dateTime);

  //     return formatted.replaceAll('/', ' ');
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  static generateUniqueId(date) {
    try {
      DateTime parseDate =
          DateFormat('E, d MMM yyyy HH:mm:ss').parse(date); //.toLocal();
      int uniqueId = parseDate.millisecondsSinceEpoch;
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
    try {
      await launch(url);
    } catch (e) {
      print(e);
    }
  }

  static Future<File?> createFileFromUrl(_url, imageExtType) async {
    try {
      Uri _imgUrl = Uri.parse(_url);
      // String _fileExt = _imgUrl.query != ""
      //     ? _imgUrl.query.split('format=')[1].split("&")[0]
      //     : _imgUrl.path.split('.').last;
      String _fileExt = '';
      try {
        _fileExt = imageExtType != "" && imageExtType != null
            ? imageExtType.split('/').last
            : _imgUrl.query != ""
                ? _imgUrl.query.split('format=')[1].split("&")[0]
                : _imgUrl.path.split('.').last;
      } catch (e) {
        _fileExt = imageExtType != "" && imageExtType != null
            ? imageExtType.split('/').last
            : _imgUrl.path.split('.').last;
      }
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
      //throw Exception(e);
      return null;
    }
  }

  // To parse emojis and unicodes from PostgreSQL response.
  static String utf8convert(String? text) {
    try {
      List<int> bytes = text!.codeUnits;
      return utf8.decode(bytes);
    } catch (e) {
      return text ?? '';
    }
  }

  static Widget textWidget(
      {required String text,
      TextStyle? textTheme,
      required context,
      TextAlign? textAlign,
      maxLines}) {
    return TranslationWidget(
      message: text,
      toLanguage: Globals.selectedLanguage,
      fromLanguage: "en",
      builder: (translatedMessage) => Text(
        translatedMessage.toString(),
        textAlign: textAlign ?? null,
        maxLines: maxLines ?? null,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
        style: textTheme != null
            ? textTheme
            : Theme.of(context).textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
      ),
    );
  }

  static int covertStringtoInt(String data) {
    try {
      int result = int.parse(data);
      return result;
    } catch (e) {
      return 0;
    }
  }

  static bool checkForInt(String data) {
    try {
      int result = int.parse(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  static String getCurrentDate(DateTime dateTime) {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  // static Future<String> sslErrorHandler(String url) async {
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       return "No";
  //     } else {
  //       return "No";
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     if (e.toString().contains('HandshakeException')) {
  //       return 'Yes';
  //     }
  //     return 'No';
  //   }
  // }

  static void showSnackBar(_scaffoldKey, msg, context, height) {
    try {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(
          alignment: Alignment.centerLeft,
          height: height ?? 40,
          child: TranslationWidget(
            message: msg,
            fromLanguage: "en",
            toLanguage: Globals.selectedLanguage,
            builder: (translatedMessage) => Text(translatedMessage,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                  fontWeight: FontWeight.w600,
                )),
          ),
        ),
        backgroundColor: Globals.themeType == 'Dark'
            ? Colors.white
            : Colors
                .black, //Theme.of(context).colorScheme.primaryVariant.withOpacity(0.8),
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
    } catch (e) {
      print(e);
      // print("error");
    }
  }

  static Future<bool>? currentScreenSnackBar(
    String msg,
    height, {
    double? marginFromBottom,
  }) async {
    Fluttertoast.cancel();
    final translatedMsg = await translateString(msg);
    Fluttertoast.showToast(
        msg: translatedMsg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 5,
        backgroundColor:
            Globals.themeType == 'Dark' ? Colors.white : Colors.black,
        textColor: Globals.themeType != 'Dark' ? Colors.white : Colors.black,
        fontSize: 16.0);
    return true;
  }

  static Future<bool> checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup(
          'https://ppwovzroa2.execute-api.us-east-2.amazonaws.com/production/getRecords/Standard__c');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  static void showLoadingDialog(
      {BuildContext? context,
      bool? isOCR,
      Function(StateSetter)? state,
      String? msg}) async {
    return showDialog<void>(
        useRootNavigator: false,
        context: context!,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            if (state != null) {
              state(setState);
            }
            return new WillPopScope(
                onWillPop: () async => false,
                child: SimpleDialog(
                    backgroundColor:
                        Color(0xff000000) != Theme.of(context).backgroundColor
                            ? Color(0xff111C20)
                            : Color(0xffF7F8F9), //Colors.black54,
                    children: <Widget>[
                      Container(
                        height: Globals.deviceType == 'phone' ? 80 : 100,
                        width: Globals.deviceType == 'phone'
                            ? MediaQuery.of(context).size.width * 0.4
                            : MediaQuery.of(context).size.width * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: FittedBox(
                                child: Utility.textWidget(
                                    text: msg ??
                                        // GradedGlobals.loadingMessage ??
                                        'Please Wait...',
                                    context: context,
                                    textTheme: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                          color: Color(0xff000000) !=
                                                  Theme.of(context)
                                                      .backgroundColor
                                              ? Color(0xffFFFFFF)
                                              : Color(0xff000000),
                                          fontSize: Globals.deviceType ==
                                                  "phone"
                                              ? AppTheme.kBottomSheetTitleSize
                                              : AppTheme.kBottomSheetTitleSize *
                                                  1.3,
                                        )),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: CircularProgressIndicator(
                                color: isOCR! ? AppTheme.kButtonColor : null,
                              ),
                            ),
                          ],
                        ),
                      )
                    ]));
          });
        });
  }

  static Future<bool> checkUser(
      {required BuildContext context,
      required String errorMsg,
      required GlobalKey scaffoldKey}) async {
    var themeColor = Theme.of(context).backgroundColor == Color(0xff000000)
        ? Color(0xff000000)
        : Color(0xffFFFFFF);
    //  Navigator.of(context).pop();

    Utility.currentScreenSnackBar(errorMsg, null);

    var value = await pushNewScreen(
      context,
      screen: GoogleAuthWebview(
        title: 'Google Authentication',
        url: //'https://88f5-111-118-246-106.in.ngrok.io/',
            (Globals.appSetting.authenticationURL != null ||
                    Globals.appSetting.authenticationURL!.isNotEmpty)
                ? ("${Globals.appSetting.authenticationURL}" +
                    '' + //Overrides.secureLoginURL +
                    '?' +
                    Globals.appSetting.appLogoC +
                    '?' +
                    themeColor.toString().split('0xff')[1].split(')')[0])
                : Overrides.STANDALONE_GRADED_APP
                    ? OcrOverrides.googleClassroomAuthURL!
                    : OcrOverrides.googleDriveAuthURL!,
        isBottomSheet: true,
        language: Globals.selectedLanguage,
        hideAppbar: false,
        hideShare: true,
        zoomEnabled: false,
      ),
      withNavBar: false,
    );

    if (value.toString().contains('authenticationfailure')) {
      Navigator.pop(context, false);
      Utility.showSnackBar(
          scaffoldKey,
          'You are not authorized to access the feature. Please use the authorized account.',
          context,
          50.0);
    } else if (value.toString().contains('success')) {
      value = value.split('?')[1] ?? '';

      UserInformation userInformation = await checkUserProfile(value);

      if (userInformation.userName != null) {
        await userVerificationPopUp(
          context,
          userInformation,
        );

        bool value = isOldUser!;
        isOldUser = false;
        return value;
      }
    }
    return false;
  }

  static Future<UserInformation> checkUserProfile(String profileData) async {
    List<String> profile = profileData.split('+');

    UserInformation _userInformation = UserInformation(
        userName: profile[0].toString().split('=')[1],
        userEmail: profile[1].toString().split('=')[1],
        profilePicture: profile[2].toString().split('=')[1],
        authorizationToken:
            profile[3].toString().split('=')[1].replaceAll('#', ''),
        refreshToken: profile[4].toString().split('=')[1].replaceAll('#', ''));

    // LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
    // List<UserInformation> _profileData = await _localDb.getData();

//GET CURRENT GOOGLE USER PROFILE
    List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();

//verify the current user is last user
    if (_profileData[0].userEmail == _userInformation.userEmail) {
      //Save existing user profile locally to store latest details and refreshToken
      // await _localDb.clear();
      // await _localDb.addData(_userInformation);
      // await _localDb.close();
      //UPDATE CURRENT GOOGLE USER PROFILE
      await UserGoogleProfile.updateUserProfile(_userInformation);

      return UserInformation(userName: null);
    } else {
      return _userInformation;
    }
  }

  static userVerificationPopUp(
      BuildContext context, UserInformation newUserInfo) async {
    // LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
    // List<UserInformation> _existingProfileData = await _localDb.getData();
    ////GET CURRENT GOOGLE USER PROFILE
    List<UserInformation> _existingProfileData =
        await UserGoogleProfile.getUserProfile();
    return showDialog(
        context: context,
        builder: (context) =>
            OrientationBuilder(builder: (context, orientation) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Center(
                  child: Container(
                    padding: Globals.deviceType == 'phone'
                        ? null
                        : const EdgeInsets.only(top: 10.0),
                    height: Globals.deviceType == 'phone'
                        ? null
                        : orientation == Orientation.portrait
                            ? MediaQuery.of(context).size.height / 15
                            : MediaQuery.of(context).size.width / 15,
                    width: Globals.deviceType == 'phone'
                        ? null
                        : orientation == Orientation.portrait
                            ? MediaQuery.of(context).size.width / 2
                            : MediaQuery.of(context).size.height / 2,
                    child: TranslationWidget(
                        message: "Different Account!",
                        fromLanguage: "en",
                        toLanguage: Globals.selectedLanguage,
                        builder: (translatedMessage) {
                          return Text(translatedMessage.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(color: AppTheme.kButtonColor));
                        }),
                  ),
                ),
                content: TranslationWidget(
                    message:
                        "The existing user account is '${_existingProfileData[0].userEmail}', and you are trying to log in with another account '${newUserInfo.userEmail}'. You might lose the scanned assessments if not yet saved to google drive. \nWould you like to continue with $newUserInfo ?",
                    fromLanguage: "en",
                    toLanguage: Globals.selectedLanguage,
                    builder: (translatedMessage) {
                      return Text(translatedMessage.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.black));
                    }),
                actions: <Widget>[
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.height,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        child: TranslationWidget(
                            message: "No",
                            fromLanguage: "en",
                            toLanguage: Globals.selectedLanguage,
                            builder: (translatedMessage) {
                              return Text(translatedMessage.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        color: AppTheme.kButtonColor,
                                      ));
                            }),
                        onPressed: () {
                          isOldUser = true;
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: TranslationWidget(
                            message: "Yes ",
                            fromLanguage: "en",
                            toLanguage: Globals.selectedLanguage,
                            builder: (translatedMessage) {
                              return Text(translatedMessage.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        color: Colors.red,
                                      ));
                            }),
                        onPressed: () async {
                          //UPDATE NEW CURRENT GOOGLE USER PROFILE
                          await UserGoogleProfile.updateUserProfile(
                              newUserInfo);

                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                      ),
                    ],
                  )
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              );
            }));
  }

  static Future<bool?> refreshAuthenticationToken({
    required bool isNavigator,
    String? errorMsg,
    BuildContext? context,
    GlobalKey? scaffoldKey,
  }) async {
    await Utility.checkUser(
        context: context!, errorMsg: errorMsg!, scaffoldKey: scaffoldKey!);

    if (isNavigator == true) {
      Navigator.pop(context, false);
    }
    return true;

    // if (isOldUser == true) {
    //   bool? res = await refreshAuthenticationToken(
    //       isNavigator: isNavigator,
    //       errorMsg: errorMsg,
    //       context: context,
    //       scaffoldKey: scaffoldKey);
    //   return res == true ? true : false;
    // } else {
    //   if (isNavigator == true) {
    //     print('+++++++++++++++++++++++++++++++++++++');
    //     Navigator.pop(context, false);
    //   }
    //   return true;
    // }
  }

  static Future clearStudentInfo({required String tableName}) async {
    LocalDatabase<StudentAssessmentInfo> _studentInfoDb =
        LocalDatabase(tableName);
    await _studentInfoDb.clear();
  }

  static List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  static bool? isBetween(
    DateTime date,
    DateTime fromDateTime,
    DateTime toDateTime,
  ) {
    if (date != null) {
      final isAfter = isAfterOrEqualTo(fromDateTime, date) ?? false;
      final isBefore = isBeforeOrEqualTo(toDateTime, date) ?? false;
      return isAfter && isBefore;
    }
    return null;
  }

  static bool? isAfterOrEqualTo(DateTime dateTime, DateTime date) {
    if (date != null) {
      final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
      return isAtSameMomentAs | date.isAfter(dateTime);
    }
    return null;
  }

  static bool? isBeforeOrEqualTo(DateTime dateTime, DateTime date) {
    if (date != null) {
      final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
      return isAtSameMomentAs | date.isBefore(dateTime);
    }
    return null;
  }

  static void scrollToTop({required ScrollController scrollController}) {
    scrollController.animateTo(scrollController.positions.first.minScrollExtent,
        duration: const Duration(milliseconds: 400), curve: Curves.linear);
  }

  static Future<String> getUserLocation() async {
    try {
      // Position? userLocation;

      LocationPermission permission = await Geolocator.requestPermission();

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          // forceAndroidLocationManager: true,
          timeLimit: Duration(seconds: 3));

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      String currentStateName = '';

      Placemark place = placemarks[0];

      currentStateName = "${place.administrativeArea}";
      // print(
      //     "currentStateName=============================================================================");
      // print(currentStateName);
      return currentStateName;
    } catch (e) {
      print(e);
      return '';
    }
  }

  static String getBase64FileExtension(String base64String) {
    switch (base64String.characters.first) {
      case '/':
        return 'jpeg';
      case 'i':
        return 'png';
      case 'R':
        return 'gif';
      case 'U':
        return 'webp';
      case 'J':
        return 'pdf';
      default:
        return 'unknown';
    }
  }

  // Function to update assessment details to dataBase
  static updateAssessmentToDb(
      {required List<StudentAssessmentInfo> studentInfoList,
      required String assessmentId}) async {
    OcrBloc _ocrAssessmentBloc = OcrBloc();
    List<StudentAssessmentInfo> _list = studentInfoList;
    // print("assessment ID $assessmentId");
    _list.removeWhere((element) =>
        element.uniqueId == null ||
        element.uniqueId ==
            ''); // avoid to update older assessment sheet in case of scan more
    // print(_list.length);
    _list.isNotEmpty
        ? _ocrAssessmentBloc.add(UploadAssessmentToDB(
            assessmentId: assessmentId, studentDetails: _list))
        // ignore: unnecessary_statements
        : null;
  }

//add two strings
  static String addStrings(String string1, String string2) {
    if (string1.isEmpty && string2.isEmpty) {
      return "";
    } else if (string1.isNotEmpty && string2.isNotEmpty) {
      return "$string1 $string2";
    } else {
      return string1.isNotEmpty ? string1 : string2;
    }
  }

  static launchMailto(subject, body) async {
    final mailtoLink = Mailto(
      to: ["admin@solvedconsulting.com"],
      cc: [],
      subject: subject,
      body: body,
    );
    await Utility.launchUrlOnExternalBrowser('$mailtoLink');
  }

  static Color getContrastColor(BuildContext context) {
    return Color(0xff000000) != Theme.of(context).backgroundColor
        ? Color(0xffF7F8F9)
        : Color(0xff111C20);
  }

  static getTimefromUtc(String utcdatetimeString, String cas) {
    try {
      if (utcdatetimeString != null && utcdatetimeString.isNotEmpty) {
        DateTime datetime = DateTime.parse(utcdatetimeString).toLocal();
        switch (cas) {
          case 'D':
            return DateFormat('dd/MM/yyyy').format(datetime); //Date: 28/06/2023
          case 'T':
            return DateFormat.jm().format(datetime); //Time: 9:27 AM
          case 'WD':
            return DateFormat.EEEE().format(datetime); // e.g., Wednesday
        }
      }
    } catch (e) {
      return utcdatetimeString;
    }
  }

  static Future clearStudentList({required String tableName}) async {
    LocalDatabase<StudentAssessmentInfo> _studentInfoDb =
        LocalDatabase(tableName);
    await _studentInfoDb.clear();
  }

  static translateString(String msg) async {
    try {
      final toLanguageCode =
          Translations.supportedLanguagesCodes(Globals.selectedLanguage!);
      if (toLanguageCode == 'en' || toLanguageCode == '') {
        return msg;
      } else {
        var res = await TranslationAPI.translate(msg, toLanguageCode, false);
        return res;
      }
    } catch (e) {
      return msg;
    }
  }

//Added to manage translation in richtext widget
  static Widget textSpanWidget(
      {required String text1,
      TextStyle? textTheme1,
      String? text2,
      TextStyle? textTheme2,
      required context,
      TextAlign? textAlign,
      maxLines}) {
    return TranslationWidget(
        message: text1,
        toLanguage: Globals.selectedLanguage,
        fromLanguage: "en",
        builder: (translatedText1) {
          return TranslationWidget(
              message: text2,
              toLanguage: Globals.selectedLanguage,
              fromLanguage: "en",
              builder: (translatedText2) {
                return RichText(
                    maxLines: maxLines,
                    text: TextSpan(children: [
                      TextSpan(
                          text: translatedText1.toString(),
                          style: textTheme1 != null
                              ? textTheme1
                              : Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' '),
                      TextSpan(
                          text: translatedText2.toString(),
                          style: textTheme2 != null
                              ? textTheme2
                              : Theme.of(context).textTheme.bodyText1)
                    ]));
              });
        });
  }
}
