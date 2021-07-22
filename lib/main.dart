import 'package:Soc/src/app.dart';
import 'package:Soc/src/globals.dart';
import 'package:flutter/material.dart';

void main() {
  Globals.appNavigator = GlobalKey<NavigatorState>();
  runApp(App());
}
