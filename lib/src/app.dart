import 'package:Soc/login_soc.dart';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/schedule/modal/calender_list.dart';
import 'package:Soc/src/modules/schedule/modal/event.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:calendar_view/calendar_view.dart';
import 'startup.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  // HiveDbServices _hiveDbServices = HiveDbServices();
  List<CalendarEventData<Event>> staticEventList = [];

  @override
  initState() {
    FirebaseAnalyticsService.enableAnalytics();
    super.initState();
    // getTheme();
    // clearLocalDataBase();
    staticEventList = EventList.events;
    var brightness = SchedulerBinding.instance.window.platformBrightness;

    if (brightness == Brightness.dark && Globals.disableDarkMode != true) {
      Globals.themeType = 'Dark';
    } else if (brightness == Brightness.light &&
        Globals.disableDarkMode != true) {
      Globals.themeType = 'Light';
    }
    var window = WidgetsBinding.instance.window;
    window.onPlatformBrightnessChanged = () {
      WidgetsBinding.instance.handlePlatformBrightnessChanged();
      // This callback is called every time the brightness changes.
      var brightness = window.platformBrightness;

      if (brightness == Brightness.dark && Globals.disableDarkMode != true) {
        Globals.themeType = 'Dark';
      }
      if (brightness == Brightness.light && Globals.disableDarkMode != true) {
        Globals.themeType = 'Light';
      }
    };
    WidgetsBinding.instance.addObserver(this);
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

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
        var brightness = SchedulerBinding.instance.window.platformBrightness;
        if (brightness == Brightness.dark && Globals.disableDarkMode != true) {
          Globals.themeType = 'Dark';
        }
        if (brightness == Brightness.light && Globals.disableDarkMode != true) {
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
        initial: Globals.disableDarkMode == true
            ? AdaptiveThemeMode.light
            : AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => CalendarControllerProvider<Event>(
            controller: EventController<Event>()..addAll(staticEventList),
            child: MaterialApp(
                navigatorKey: Globals.navigatorKey,
                debugShowCheckedModeBanner: false,
                scaffoldMessengerKey: Globals.rootScaffoldMessengerKey,
                title: 'Solved',
                theme: theme,
                darkTheme: darkTheme,
                home: StartupPage(
                    isOcrSection:
                        Overrides.STANDALONE_GRADED_APP //Standalone app
                    //false,  /For standard app
                    ),
                //  home: SchoolIDLogin(),
                navigatorObservers: [
                  FirebaseAnalyticsService().appAnalyticsObserver()
                ])));
  }
}
