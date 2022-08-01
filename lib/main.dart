import 'dart:io';
import 'package:Soc/src/app.dart';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/custom/model/custom_setting.dart';
import 'package:Soc/src/modules/families/modal/sd_list.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/home/models/attributes.dart';
import 'package:Soc/src/modules/home/models/recent.dart';
import 'package:Soc/src/modules/news/model/notification_list.dart';
import 'package:Soc/src/modules/schools_directory/modal/school_directory_list.dart';
import 'package:Soc/src/modules/shared/models/shared_list.dart';
import 'package:Soc/src/modules/social/modal/item.dart';
import 'package:Soc/src/modules/students/models/student_app.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'src/modules/families/modal/calendar_event_list.dart';
import 'src/services/local_database/hive_db_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    // Not running on the web!
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive
      ..init(appDocumentDirectory.path)
      ..registerAdapter(RecentAdapter())
      ..registerAdapter(AttributesAdapter())
      ..registerAdapter(SharedListAdapter())
      ..registerAdapter(SDlistAdapter())
      ..registerAdapter(SchoolDirectoryListAdapter())
      ..registerAdapter(StudentAppAdapter())
      ..registerAdapter(NotificationListAdapter())
      ..registerAdapter(ItemAdapter())
      ..registerAdapter(AppSettingAdapter())
      ..registerAdapter(CalendarEventListAdapter())
      ..registerAdapter(CustomSettingAdapter());
  }
  clearTheme();
  await disableDarkMode();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft
  ]).then((_) {
    runApp(App());
  });
  getDeviceType();
}

Future<String> getDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  return iosInfo.model.toLowerCase();
}

getDeviceType() async {
  if (Platform.isAndroid) {
    final data = (MediaQueryData.fromWindow(WidgetsBinding.instance!.window));
    Globals.deviceType = data.size.shortestSide < 600 ? 'phone' : 'tablet';
  } else if (Platform.isIOS) {
    final deviceType = await getDeviceInfo();
    Globals.deviceType = deviceType == "ipad" ? "tablet" : "phone";
  }
}

disableDarkMode() async {
  try {
    HiveDbServices _hivedb = HiveDbServices();
    Globals.disableDarkMode =
        await _hivedb.getSingleData('disableDarkMode', 'darkMode');
    // print('-------------------dark mode disable----------------------');
   print(Globals.disableDarkMode);

  } catch (e) {}
}

// This function will clean the only theme details from SharedPreferences
clearTheme() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AdaptiveTheme.prefKey);
  } catch (e) {}
  // AdaptiveTheme.of(context).persist();
}
