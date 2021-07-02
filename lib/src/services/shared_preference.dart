import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesFn {

  // set string value
  Future<void> setString(String key, String value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  // get string value
  Future<String> getString(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get(key) as FutureOr<String>? ?? '';
  }

  void clear() async {
    SharedPreferences prefs = await _getSharedPreference();
    prefs.clear();
  }

  _getSharedPreference() async {
    return await SharedPreferences.getInstance();
  }
}
