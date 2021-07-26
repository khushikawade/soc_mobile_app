import 'dart:io';

import 'package:Soc/src/app.dart';
import 'package:Soc/src/modules/home/model/recent.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = Platform.isAndroid
      ? await path_provider.getApplicationDocumentsDirectory()
      : await path_provider.getApplicationDocumentsDirectory();
  Hive
    ..init(appDocumentDirectory.path)
    ..registerAdapter(RecentAdapter());
  runApp(App());
}
