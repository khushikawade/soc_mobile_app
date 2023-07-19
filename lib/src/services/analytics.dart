import 'dart:isolate';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_plus_utilty.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

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
          'premiumUser': "true", //Globals.isPremiumUser.toString(),
          'teacherId': await OcrUtility.getTeacherId() ?? '',
          'deviceId': Globals.deviceID ?? 'Virtual Device',
          'platform': Globals.isAndroid! ? 'Android' : 'iOS',
          'deviceType': Globals.deviceType
        });
  }

  static firebaseCrashlytics(error, stack, reason) async {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    FlutterError.onError = (errorDetails) async {
      await FirebaseCrashlytics.instance
          .recordFlutterFatalError(error ?? errorDetails);
      await FirebaseCrashlytics.instance
          .recordFlutterError(error ?? errorDetails);
    };

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics

    // PlatformDispatcher.instance.onError = (err, stk) {
    //   FirebaseCrashlytics.instance
    //       .recordError(error ?? err, stack ?? stk, fatal: true, reason: reason);
    //   return true;
    // };

// To catch errors that happen outside of the Flutter context, install an error listener on the current Isolate:
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
        fatal: true,
      );
    }).sendPort);
  }
}
