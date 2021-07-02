import 'package:app/src/modules/home/ui/home.dart';
import 'package:app/src/modules/user/ui/login.dart';
import 'package:app/src/services/shared_preference.dart';
import 'package:app/src/styles/theme.dart';
import 'package:app/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'locale/app_translations_delegate.dart';
import 'locale/application.dart';

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
      home: LoginPage(),
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
