import 'package:Soc/login_soc.dart';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

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
          title: 'Solved',
          theme: theme,
          darkTheme: darkTheme,
          //home: StartupPage(),
          home: SchoolIDLogin(),
          ),
    );
  }
}
