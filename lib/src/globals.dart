import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/social/modal/item.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'modules/custom/model/custom_setting.dart';
import 'modules/news/model/notification_list.dart';

class Globals {
  static var iosInfo;
  static var androidInfo;
  static String? token = '';
  static String? baseOS;
  static String? deviceType;
  static String? deviceID;
  static int? outerBottombarIndex;
  static int? internalBottombarIndex;
  static late AppSetting appSetting;
  static List<CustomSetting>? customSetting;
  static bool? isCustomNavbar = false;
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
  static bool? isAndroid;
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
  static String? splashImageUrl;
  static int? homeIndex;
  static bool? isNetworkError = false;
  static bool? callsnackbar = true;
  static ValueNotifier<bool> hasShowcaseInitialised =
      ValueNotifier<bool>(false);
  static String? calendar_Id = "";
  static final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  static int? navIndex = 0;
  static int? socialImageIndex = 0;
  static bool? isDarkTheme;
  static bool? systemTheme;
  static String? themeType;
  static List icons = [0xe823, 0xe824, 0xe825, 0xe829];
  static List iconsName = ["Like", "Thanks", "Helpful", "Share"];
  static List<NotificationList> notificationList = [];
  static List<Item> socialList = [];
  static PackageInfo? packageInfo;
  static bool isNewTap = false;
  static BuildContext? context;
  static int? urlIndex;
  static late WebViewController? webViewController1;
  static String? homeUrl;
  static PersistentTabController? controller;
  static bool? disableDarkMode;

}
