import 'local_database/local_db.dart';
import '../modules/graded_plus/modal/user_info.dart';

class UserGoogleProfile {
  static LocalDatabase<UserInformation> _localDb =
      LocalDatabase('user_profile');

  static Future<List<UserInformation>> getUserProfile() async {
    try {
      await _localDb.openBox('user_profile');
      List<UserInformation> _userInformation = await _localDb.getData();

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
      print("user profile is successfully cleared");
    } catch (e) {
      print("user profile is FAILED cleared");
      throw (e);
    }
  }

  static Future<void> updateUserProfile(
      UserInformation _userInformation) async {
    try {
      // await clearUserProfile();

      await _localDb.putAt(0, _userInformation);
      // await _localDb.close();
      print(_userInformation.userEmail);
      print(
          " gradedPlusGoogleDriveFolerPathUrl ${_userInformation.gradedPlusGoogleDriveFolerPathUrl}");
      print(
          " gradedPlusGoogleDriveFolerId ${_userInformation.gradedPlusGoogleDriveFolerId}");
      print(
          " pbisPlusGoogleDriveFolerId ${_userInformation.pbisPlusGoogleDriveFolerId}");
      print(
          " studentPlusGoogleDriveFolerId ${_userInformation.studentPlusGoogleDriveFolerId}");
      print("user profile is successfully UDAPTED");
    } catch (e) {
      print(e);
      print("user profile is UDAPTED FAILED");
      throw (e);
    }
  }
}
