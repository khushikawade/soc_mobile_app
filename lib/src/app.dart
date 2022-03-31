import 'package:Soc/src/globals.dart';
import 'package:Soc/src/services/local_database/hive_db_services.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modules/user/ui/startup.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  HiveDbServices _hiveDbServices = HiveDbServices();

  @override
  initState() {
    super.initState();
    getTheme();
    _onNotificationTap();

    var brightness = SchedulerBinding.instance!.window.platformBrightness;

    if (brightness == Brightness.dark) {
      Globals.themeType = 'Dark';
    } else {
      Globals.themeType = 'Light';
    }
    var window = WidgetsBinding.instance!.window;
    window.onPlatformBrightnessChanged = () {
      WidgetsBinding.instance?.handlePlatformBrightnessChanged();
      // This callback is called every time the brightness changes.
      var brightness = window.platformBrightness;

      if (brightness == Brightness.dark) {
        Globals.themeType = 'Dark';
      }
      if (brightness == Brightness.light) {
        Globals.themeType = 'Light';
      }
    };
    WidgetsBinding.instance!.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    // Remove the observer
    WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
        var brightness = SchedulerBinding.instance!.window.platformBrightness;
        if (brightness == Brightness.dark) {
          Globals.themeType = 'Dark';
        }
        if (brightness == Brightness.light) {
          Globals.themeType = 'Light';
        }
        // widget is resumed
        break;
      case AppLifecycleState.inactive:
        // widget is inactive
        break;
      case AppLifecycleState.paused:
        // widget is paused
        break;
      case AppLifecycleState.detached:
        // widget is detached
        break;
    }
  }

  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: AppTheme.lightTheme,
      dark: AppTheme.darkTheme,
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: Globals.rootScaffoldMessengerKey,
        title: 'Solved',
        theme: theme,
        darkTheme: darkTheme,
        home: StartupPage(),
        //   home: SchoolIDLogin(),
      ),
    );
  }

  _onNotificationTap() {
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      this.setState(() {
        Globals.isNewTap = true;
      });
    });
  }

  getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    AdaptiveTheme.of(context).persist();
  }
}
