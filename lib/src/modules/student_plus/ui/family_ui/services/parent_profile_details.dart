import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/services/local_database/local_db.dart';

class FamilyUserDetails {
  static LocalDatabase<UserInformation> _localDb =
      LocalDatabase('family_user_profile');

  static Future<List<UserInformation>> getFamilyUserProfile() async {
    try {
      await _localDb.openBox('family_user_profile');
      List<UserInformation> _userInformation = await _localDb.getData();
      print(" get family user profile is successfully ");
      // await _localDb.close();
      return _userInformation;
    } catch (e) {
      print(" get family user profile is FAILED ");
      throw (e);
    }
  }

  static Future<void> clearFamilyUserProfile() async {
    try {
      await _localDb.clear();
      print("family user profile is successfully clean");
    } catch (e) {
      print("family user profile is FAILED clean");
      throw (e);
    }
  }

  static Future<void> updateFamilyUserProfile(
      UserInformation _userInformation) async {
    try {
      await clearFamilyUserProfile();
      await _localDb.addData(_userInformation);
      print("family user profile is successfully UPDATED");
    } catch (e) {
      print(e);
      print("family user profile is UPDATE FAILED");
      throw (e);
    }
  }
}
