import 'package:bubble_showcase/bubble_showcase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'modules/home/models/app_setting.dart';

class Globals {
  static var iosInfo;
  static var androidInfo;
  static String? token = '';
  static String? baseOS;
  static String? deviceType;
  static String? deviceID;
  static int? outerBottombarIndex;
  static int? internalBottombarIndex;
  static var homeObjet;
  static late AppSetting appSetting;
  static int? newsIndex;
  static Locale? myLocale;
  static int? notiCount;
  static String? selectedLanguage;
  static String? appLogo;
  static bool? isnetworkexception = false;
  static ValueNotifier<bool> indicator = ValueNotifier<bool>(false);
  static ValueNotifier<String> languageChanged =
      ValueNotifier<String>("English");
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  static String? release = "";
  static String? manufacturer = "";
  static String? model = "";
  static String? deviceToken = "";
  static String? name = "";
  static String? systemName = "";
  static String? systemVersion = "";
  static String? versionRelease = "";
  static String? androidId = "";
  static String? countrycode = "";
  static String? splashImageUrl = "";
  static int? homeIndex;
  static bool? isNetworkError = false;
  static bool? callsnackbar = true;
  static bool? initalscreen ;
  static String? calendar_Id = "";
  static final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  static int? navIndex = 0;
}
