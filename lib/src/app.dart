import 'package:Soc/src/locale/app_translations_delegate.dart';
import 'package:Soc/src/locale/application.dart';
import 'package:Soc/src/routes.dart';
import 'package:Soc/src/services/shared_preference.dart';
import 'package:Soc/src/modules/user/ui/startup.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    checkForSetLanguage();
    application.onLocaleChanged = onLocaleChange;
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
      title: 'Solved',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      home: StartupPage(),
      localizationsDelegates: [
        _newLocaleDelegate!,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
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
