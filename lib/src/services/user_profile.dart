import 'local_database/local_db.dart';
import '../modules/graded_plus/modal/user_info.dart';

class UserGoogleProfile {
  // static updateUserProfileIntoDB(updatedObj) async {
  //   HiveDbServices _localdb = HiveDbServices();
  //   await _localdb.updateListData("user_profile", 0, updatedObj);
  // }

  static Future<List<UserInformation>> getUserProfile() async {
    LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
    await _localDb.openBox('user_profile');
    List<UserInformation> _userInformation = await _localDb.getData();

    await _localDb.close();
    return _userInformation;
  }

  static Future<void> clearUserProfile() async {
    try {
      LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
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
      await clearUserProfile();
      LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
      await _localDb.addData(_userInformation);
      await _localDb.close();
      print(_userInformation.userEmail);
      print(
          " gradedPlusGoogleDriveFolerId ${_userInformation.gradedPlusGoogleDriveFolerId}");
      print(
          " pbisPlusGoogleDriveFolerId ${_userInformation.pbisPlusGoogleDriveFolerId}");
      print(
          " studentPlusGoogleDriveFolerId ${_userInformation.studentPlusGoogleDriveFolerId}");
      print("user profile is successfully UDAPTED");
    } catch (e) {
      print("user profile is UDAPTED FAILED");
      throw (e);
    }
  }
}
