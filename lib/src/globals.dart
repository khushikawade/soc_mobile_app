import 'package:flutter/cupertino.dart';

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

  static Locale? myLocale;
  static int? notiCount;
  static String? selectedLanguage;
  static String? appLogo;
  static bool? isnetworkexception = false;
  static ValueNotifier<bool> indicator = ValueNotifier<bool>(false);
  static ValueNotifier<String> languageChanged =
      ValueNotifier<String>("English");
  // static GlobalKey<NavigatorState>? appNavigator;
  // static String? phone = 'phone';
  // final object;
  // static bool? isOpenByLink;
  // static final loggedInUser;
}
