import 'dart:io';

import 'package:Soc/src/app.dart';
<<<<<<< HEAD
import 'package:Soc/src/modules/home/model/recent.dart';
=======
import 'package:Soc/src/globals.dart';
>>>>>>> 0667e846396f0c62f003068246890e670cf34c5b
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

<<<<<<< HEAD
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = Platform.isAndroid
      ? await path_provider.getApplicationDocumentsDirectory()
      : await path_provider.getApplicationDocumentsDirectory();
  Hive
    ..init(appDocumentDirectory.path)
    ..registerAdapter(RecentAdapter());
=======
void main() {
  Globals.appNavigator = GlobalKey<NavigatorState>();
>>>>>>> 0667e846396f0c62f003068246890e670cf34c5b
  runApp(App());
}
