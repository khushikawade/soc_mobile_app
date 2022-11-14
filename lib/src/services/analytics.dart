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
}
