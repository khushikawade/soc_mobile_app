import 'package:Soc/src/globals.dart';

import 'local_database/local_db.dart';
import '../modules/graded_plus/modal/user_info.dart';

class UserGoogleProfile {
  static LocalDatabase<UserInformation> _localDb =
      LocalDatabase('user_profile');

  static Future<List<UserInformation>> getUserProfile() async {
    try {
      await _localDb.openBox('user_profile');
      List<UserInformation> _userInformation = await _localDb.getData();
      print(" get user profile is successfully ");
      // await _localDb.close();
      return _userInformation;
    } catch (e) {
      print(" get user profile is FAILED ");
      throw (e);
    }
  }

  static Future<void> clearUserProfile() async {
    try {
      await _localDb.clear();
      print("user profile is successfully clean");
    } catch (e) {
      print("user profile is FAILED clean");
      throw (e);
    }
  }

  static Future<void> updateUserProfile(
      UserInformation _userInformation) async {
    try {
      await clearUserProfile();

      // If Salesforce Single Sign-On (SSO) is enabled, refreshToken is not required. However, some API expects a refreshToken.
      // To accommodate this requirement, assign the same authorizationToken value to refreshToken.
      if (Globals.appSetting.enableGoogleSSO == "true") {
        print(" ------------SSO IS ENABLED-----");
        _userInformation.refreshToken = _userInformation.authorizationToken;
      } else {
        print(" ------------SSO IS DISABLED-----");
      }

      await _localDb.addData(_userInformation);
      // await _localDb.close();

      // print("NEW authorizationToken : ${_userInformation.authorizationToken}");

      print("user profile is successfully UDAPTED");
    } catch (e) {
      print(e);
      print("user profile is UDAPTE FAILED");
      throw (e);
    }
  }
}
