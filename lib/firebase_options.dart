// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB2SQfdLM2JY5Yx-HaCE-Ue6LzUMzuXvI8',
    appId: '1:675468736684:android:9243189aa0ff6910abc709',
    messagingSenderId: '675468736684',
    projectId: 'app-07x151',
    storageBucket: 'app-07x151.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD0xlNYl1ELDV3SYe_IBhR6KOjQmCIYt0o',
    appId: '1:675468736684:ios:e4f8e48602f1bf4aabc709',
    messagingSenderId: '675468736684',
    projectId: 'app-07x151',
    storageBucket: 'app-07x151.appspot.com',
    androidClientId: '675468736684-co9bviqql6hvnfogc88173lt4j1skug9.apps.googleusercontent.com',
    iosClientId: '675468736684-3c0vfd6pun6ohr0s8d6u0bod81f7m4oe.apps.googleusercontent.com',
    iosBundleId: 'com.jhs151hh6432q',
  );
}
