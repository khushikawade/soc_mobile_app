import 'package:flutter/cupertino.dart';

import 'modules/home/models/app_setting.dart';

class Globals {
  static var iosInfo;
  static var androidInfo;
  static String? token = '';
  // static bool? isOpenByLink;
  // static var loggedInUser;
  static String? baseOS;
  static String? deviceType;
  static String? deviceID;
  // static String? phone = 'phone';
  // var object;
  static int? outerBottombarIndex;
  static int? internalBottombarIndex;
  static var homeObjet;
  static late AppSetting appSetting;
  // static GlobalKey<NavigatorState>? appNavigator;
  static Locale? myLocale;
  static int? notiCount;
  static String? selectedLanguage;
}
