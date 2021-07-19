import 'package:Soc/src/locale/app_translations_delegate.dart';
import 'package:Soc/src/locale/application.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/routes.dart';
import 'package:Soc/src/services/shared_preference.dart';
import 'package:Soc/src/startup.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  AppTranslationsDelegate? _newLocaleDelegate;
  final SharedPreferencesFn _sharedPref = SharedPreferencesFn();

  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    checkForSetLanguage();
    application.onLocaleChanged = onLocaleChange;
    //

    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId(Overrides.PUSH_APP_ID);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
  }

  checkForSetLanguage() async {
    String _languageCode = await _sharedPref.getString('selected_language');
    if (_languageCode != null && _languageCode != '') {
      _newLocaleDelegate =
          AppTranslationsDelegate(newLocale: Locale(_languageCode));
    } else {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      // home: LoginPage(),
      home: StartupPage(),
      localizationsDelegates: [
        _newLocaleDelegate!,
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: application.supportedLocales(),
      routes: routes,
    );
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }
}
