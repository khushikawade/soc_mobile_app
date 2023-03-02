import 'dart:io';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/social/modal/item.dart';
import 'package:Soc/src/overrides.dart';
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
  // static int? outerBottombarIndex;
  // static int? internalBottombarIndex;
  static late AppSetting appSetting;
  static List<CustomSetting>? customSetting;
  static bool? isCustomNavbar = false;
  static int? newsIndex;
  static Locale? myLocale;
  static int? notiCount = 0;
  static String? selectedLanguage = 'en';
  static String? appLogo;
  // static bool? isnetworkexception = false;
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
  static String? countryCode = "";
  static String? splashImageUrl;
  static int? homeIndex;
  static bool? isNetworkError = false;
  static bool? callSnackbar = true;
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
  // static List icons = [0xe823, 0xe824, 0xe825, 0xe829, 0xe863];
  static List icons = [0xe87e, 0xe87f, 0xe880, 0xe829, 0xe882, 0xe893]; //88b
  static List iconsName = [
    "Like",
    "Thanks",
    "Helpful",
    "Share",
    "Support",
    "View"
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
  static int? staffIndex;

  //OCR Feature Globals
  static List pointsList = [2, 3, 4];
  static List pointsEarnedList = [0, 1, 2];
  static int lastIndex = 0;
  static String teacherEmailId = '';
  static String teacherId = '';
  static String sessionId = '';
  static bool isPremiumUser = false;

  static List ocrResultIcons = Overrides.STANDALONE_GRADED_APP == true
      ? [0xe873, 0xe871, 0xe803, 0xe876]
      : [0xe876, 0xe871, 0xe873, 0xe87a, 0xe80d];

  static List ocrResultIconsName = Overrides.STANDALONE_GRADED_APP == true
      ? ["History", "Drive", "Sheet", "Share"]
      : ["Share", "Drive", "History", "Dashboard", "Slide"];

  static List gradeList = [];
  static bool isCameraPopup = true;
  static String? googleDriveFolderId = '';
  static String? googleDriveFolderPath;
  static String? googleExcelSheetId;
  static String? shareableLink;
  static String? pointPossible = '2';
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
  static String? googleSlidePresentationId;
  static String? googleSlidePresentationLink;
  static String selectedFilterValue = 'All';
  static String historyAssessmentId = '';
  static bool isNewsContactPopupAppear = false; // when news popUp is on

  static String? schoolDbnC;

  static String? feedPostId =
      ''; //Used to manage the count increment only in case of id change

//  static EventController scheduleController = EventController();
}
