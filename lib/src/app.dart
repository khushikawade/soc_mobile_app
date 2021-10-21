import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/user/ui/startup.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
<<<<<<< HEAD
<<<<<<< HEAD

=======
// import 'package:showcaseview/showcaseview.dart';
>>>>>>> eb02c6c7ee91a7f84e6a7cdfc957095266600431
=======
import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';
// import 'package:showcaseview/showcaseview.dart';
>>>>>>> dev_production

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static FirebaseAnalytics analytics = new FirebaseAnalytics();
  static FirebaseAnalyticsObserver  observer = new FirebaseAnalyticsObserver(analytics: analytics);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: AppTheme.lightTheme,
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: Globals.rootScaffoldMessengerKey,
        title: 'Adaptive Theme Demo',
        theme: theme,
        darkTheme: darkTheme,
        navigatorObservers: <NavigatorObserver>[observer],
        home: StartupPage(analytics:analytics, observer:observer),
        // ShowCaseWidget(
        //     builder: Builder(builder: (context) => StartupPage()),
        //     onStart: (index, key) {
        //       print('onStart: $index, $key');
        //     },
        //     onComplete: (index, key) {
        //       print('onComplete: $index, $key');
        //     }),
      ),
    );
  }
}

