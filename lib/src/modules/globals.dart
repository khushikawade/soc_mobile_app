import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

String? deviceType;

class Globals {
  static String? token;
  static String? linkUsername;
  static String? linkPassword;
  static bool? isOpenByLink;
  static var loggedInUser;
}
