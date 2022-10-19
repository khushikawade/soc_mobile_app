import 'dart:io';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/social/modal/item.dart';
import 'package:Soc/src/overrides.dart';
import 'package:calendar_view/calendar_view.dart';
// import 'package:calendar_view/calendar_view.dart';
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
  static String? selectedLanguage = 'en';
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
  static int? staffIndex;

  //OCR Feature Globals
  static List pointsList = [2, 3, 4];
  static List pointsEarnedList = [0, 1, 2];
  static int lastindex = 0;
  static String teacherEmailId = '';
  static String teacherId = '';
  static String sessionId = '';
  static bool isPremiumUser = false;

  // static List subjectDetailsList = [
  //   'NY-3.OA.1 Interpret Products of whole numbers',
  //   'NY-3.OA.2  Interpret whole-number quotients of whole numbers.',
  //   'NY-3.OA.3. Use multiplication and division within 100 to solve word problems…',
  //   'NY-3.OA.4 Determine unknown whole number in multiplication or division…'
  // ];
  // static List nycDetailsList = [
  //   'N&OBase Ten',
  //   'Geometry',
  //   'N&OFractions',
  //   'Measurement'
  // ];
  // static List subjectList = ['Maths', 'Science', 'ELA', '+'];
  // static List<String> classList = [
  //   'PK',
  //   'K',
  //   '1',
  //   '2',
  //   '3',
  //   '4',
  //   '5',
  //   '6',
  //   '7',
  //   '8',
  //   '9',
  //   '10',
  //   '11',
  //   '12',
  //   '+'
  // ];
  static List ocrResultIcons = Overrides.STANDALONE_GRADED_APP == true
      ? [0xe873, 0xe871, 0xe803, 0xe876]
      : [0xe876, 0xe871, 0xe873, 0xe87a];
  // ? [0xe876, 0xe871, 0xe873, 0xe803]
  // : [0xe876, 0xe871, 0xe873, 0xe87a];
  static List ocrResultIconsName = Overrides.STANDALONE_GRADED_APP == true
      ? ["History", "Drive", "Sheet", "Share"]
      : ["Share", "Drive", "History", "Dashboard"];
  //  ? ["Share", "Drive", "History", "Sheet"]
  // : ["Share", "Drive", "History", "Dashboard"];
  // static List finishedList = [
  //   "Scan another assessment",
  //   "View all assessment results"
  // ];
  // static List ocrResultIcons = [0xe876, 0xe871, 0xe873, 0xe87a];
  // static List ocrResultIconsName = ["Share", "Drive", "History", "Dashboard"];
  static List gradeList = [];
  static bool iscameraPopup = true;
  static String? googleDriveFolderId = '';
  static String? googleDriveFolderPath;
  static String? googleExcelSheetId;
  static String? shareableLink;
  static String? pointpossible = '2';
  static String? assessmentName;
  static int? scanMoreStudentInfoLength;
  static String currentAssessmentId = '';
  static final ValueNotifier<String> updateStudentName =
      ValueNotifier<String>('');
  static String? scoringRubric;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static String? questionImgUrl;
  static File? questionImgFilePath;
  static String? historyAssessmentName = '';
  static String? historyAssessmentFileId = '';
  static late TabController tabController;
//  static EventController scheduleController = EventController();
}
