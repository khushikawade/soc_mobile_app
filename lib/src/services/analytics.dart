import 'package:Soc/src/globals.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// class Analytics {
//   static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

//   static setUserId(String userId) async {
//     await FirebaseAnalytics.instance.setUserId(id: userId);
//   }
// }

class FirebaseAnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver appAnalyticsObserver() => FirebaseAnalyticsObserver(
        analytics: _analytics,
      );

  static Future<void> setUserId({
    String? id,
    AnalyticsCallOptions? callOptions,
  }) async {
    await Future.delayed(Duration(seconds: 5));
    await _analytics.setUserId(id: id, callOptions: callOptions);
  }

  static Future<void> enableAnalytics() async {
    await _analytics.setAnalyticsCollectionEnabled(true);
  }

  static Future<void> setCurrentScreen({
    String? screenTitle,
    String? screenClass,

    // AnalyticsCallOptions? callOptions,
  }) async {
    // await Future.delayed(Duration(seconds: 5));
    await _analytics
      ..setCurrentScreen(
          screenName: screenTitle, screenClassOverride: screenClass!);
  }

  static Future<void> logLogin({
    String? method,
    AnalyticsCallOptions? callOptions,
  }) async {
    await Future.delayed(Duration(seconds: 5));
    await _analytics.logLogin(loginMethod: method, callOptions: callOptions);
  }

  static Future<void> setUserProperty({
    required String key,
    String? value,
    AnalyticsCallOptions? callOptions,
  }) async {
    await Future.delayed(Duration(seconds: 5));
    await _analytics.setUserProperty(
        name: key, value: value ?? '', callOptions: callOptions);
  }

  static addCustomAnalyticsEvent(
    String? logName, //Map<String, Object?>? customParameter
  ) async {
    enableAnalytics();
    await _analytics.logEvent(
        name: logName!
            .replaceAll(' ', '_')
            .replaceAll(RegExp('[^A-Za-z0-9^_]'), '')
            .toLowerCase(),
        parameters: {
          'appId': Globals.appSetting.schoolNameC,
          'premiumUser': Globals.isPremiumUser,
          'teacherId': Globals.teacherId,
          'deviceId': Globals.deviceID,
          'platform': Globals.isAndroid! ? 'Android' : 'iOS',
          'deviceType': Globals.deviceType
        }
        // <String, dynamic>{
        //   'plant_name': currentPlant.name,
        //   'plant_species': currentPlant.species,
        //   'plant_group': currentPlant.group,
        //   'new_plant': widget.newPlant
        // },
        );
  }
}
