import 'dart:io';
import 'package:Soc/firebase_options.dart';
import 'package:Soc/src/app.dart';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/custom/model/custom_setting.dart';
import 'package:Soc/src/modules/families/modal/calendar_banner_image_modal.dart';
import 'package:Soc/src/modules/families/modal/sd_list.dart';
import 'package:Soc/src/modules/google_classroom/modal/google_classroom_courses.dart';
import 'package:Soc/src/modules/google_drive/model/recent_google_file.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/home/models/attributes.dart';
import 'package:Soc/src/modules/home/models/recent.dart';
import 'package:Soc/src/modules/news/model/notification_list.dart';
import 'package:Soc/src/modules/graded_plus/modal/RubricPdfModal.dart';
import 'package:Soc/src/modules/graded_plus/modal/custom_rubic_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/state_object_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/student_details_standard_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/subject_details_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/graded_plus/ui/camera_screen.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_additional_behvaiour_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_default_behaviour_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_genric_behaviour_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_student_notes_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_total_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pibs_plus_history_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/schedule/modal/schedule_modal.dart';
import 'package:Soc/src/modules/schools_directory/modal/school_directory_list.dart';
import 'package:Soc/src/modules/shared/models/shared_list.dart';
import 'package:Soc/src/modules/social/modal/item.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_grades_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_search_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_work_model.dart';
import 'package:Soc/src/modules/students/models/student_app.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/translator/translation_modal.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:camera/camera.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/foundation.dart' show PlatformDispatcher, kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'src/modules/families/modal/calendar_event_list.dart';
import 'src/modules/google_drive/model/assessment.dart';
import 'src/modules/graded_plus/new_ui/camera_screen.dart';
import 'src/modules/schedule/modal/blackOutDate_modal.dart';
import 'src/services/local_database/hive_db_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  // Initializing Firebase Starts
  // await Firebase.initializeApp();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      name: 'SOC',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  const standaloneGradedApp = String.fromEnvironment("STANDALONE_GRADED_APP");
  if (standaloneGradedApp == "true") {
    Overrides.STANDALONE_GRADED_APP = true;
  }

  // await FirebaseAnalyticsService.firebaseCrashlytics(null, null, null);
  // Initializing Firebase Ends

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
      ..registerAdapter(CustomSettingAdapter())
      ..registerAdapter(UserInformationAdapter())
      ..registerAdapter(SubjectDetailListAdapter())
      ..registerAdapter(HistoryAssessmentAdapter())
      ..registerAdapter(CustomRubricModalAdapter())
      ..registerAdapter(TranslationModalAdapter())
      ..registerAdapter(StudentAssessmentInfoAdapter())
      ..registerAdapter(StateListObjectAdapter())
      ..registerAdapter(GoogleClassroomCoursesAdapter())
      ..registerAdapter(ScheduleAdapter())
      ..registerAdapter(BlackoutDateAdapter())
      ..registerAdapter(StudentDetailsModalAdapter())
      ..registerAdapter(RecentGoogleFileSearchAdapter())
      ..registerAdapter(CalendarBannerImageModalAdapter())
      ..registerAdapter(RubricPdfModalAdapter())
      ..registerAdapter(StudentPlusDetailsModelAdapter())
      ..registerAdapter(StudentPlusWorkModelAdapter())
      ..registerAdapter(ClassroomCourseAdapter())
      ..registerAdapter(ClassroomStudentsAdapter())
      ..registerAdapter(ClassroomProfileNameAdapter())
      ..registerAdapter(ClassroomProfileAdapter())
      ..registerAdapter(ClassroomPermissionsAdapter())
      ..registerAdapter(PBISPlusHistoryModalAdapter())
      ..registerAdapter(PBISPlusTotalInteractionModalAdapter())
      ..registerAdapter(StudentPlusSearchModelAdapter())
      ..registerAdapter(StudentPlusGradeModelAdapter())
      ..registerAdapter(PBISPlusGenricBehaviourModalAdapter())
      ..registerAdapter(PBISPlusDefaultBehaviourModalAdapter())
      ..registerAdapter(PBISPlusStudentNotesAdapter())
      ..registerAdapter(PBISPlusDefaultAndCustomBehaviourModalAdapter())
      ..registerAdapter(PbisPlusAdditionalBehaviourListAdapter());
    // ..registerAdapter(PBISPlusTotalInteractionByTeacherModalAdapter())
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
    final data = (MediaQueryData.fromWindow(WidgetsBinding.instance.window));
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
    // //print('-------------------dark mode disable----------------------');
    // //print(Globals.disableDarkMode);
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
