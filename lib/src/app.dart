import 'package:Soc/src/modules/user/ui/startup.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
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

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Solved',
  //     debugShowCheckedModeBanner: false,
  //     theme: AppTheme.lightTheme,
  //     darkTheme: AppTheme.lightTheme,
  //     home: StartupPage(),
  //   );
  // }
  // Adaptive Theme starts

 Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: AppTheme.lightTheme,
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Adaptive Theme Demo',
        theme: theme,
        darkTheme: darkTheme,
        home: StartupPage(),
      ),
    );
  }
}
