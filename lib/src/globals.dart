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
  static List pointsList = [1, 2, 3, 4];
  static List pointsEarnedList = [0, 1, 2];
  static List scoringList = [
    'NYS 0-2',
    'Custom',
    'NYS 0-3',
    'None',
    'NYS 0-4',
  ];
  static List subjectDetailsList = [
    'NY-3.OA.1 Interpret Products of whole numbers',
    'NY-3.OA.2  Interpret whole-number quotients of whole numbers.',
    'NY-3.OA.3. Use multiplication and division within 100 to solve word problems…',
    'NY-3.OA.4 Determine unknown whole number in multiplication or division…'
  ];
  static List nycDetailsList = [
    'N&OBase Ten',
    'Geometry',
    'N&OFractions',
    'Measurement'
  ];
  static List subjectList = ['Maths', 'Science', 'ELA', '+'];
  static List classList = [
    'K',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '?',
    '+'
  ];
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
  static List ocrResultIcons = [0xe876, 0xe871, 0xe873, 0xe870];
  static List ocrResultIconsName = [
    "Share",
    "Add to drive",
    "History",
    "Download"
  ];
  static List finishedList = [
    "Scan another assessment",
    "View all assessment results"
  ];
  static List gradeList = [];
  static bool iscameraPopup = true;
}
