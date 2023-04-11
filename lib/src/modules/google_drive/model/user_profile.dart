import '../../../services/local_database/hive_db_services.dart';
import '../../../services/local_database/local_db.dart';
import '../../graded_plus/modal/user_info.dart';

class UserGoogleProfile {
  // static updateUserProfileIntoDB(updatedObj) async {
  //   HiveDbServices _localdb = HiveDbServices();
  //   await _localdb.updateListData("user_profile", 0, updatedObj);
  // }

  static Future<List<UserInformation>> getUserProfile() async {
    LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
    List<UserInformation> _userInformation = await _localDb.getData();
    if (_userInformation.isNotEmpty) {
      //print(_userInformation[0].authorizationToken);
      //print(_userInformation[0].profilePicture);
      //print(_userInformation[0].refreshToken);
      //print(_userInformation[0].userEmail);
      //print(_userInformation[0].userName);
    }
    //  await _localDb.close();
    return _userInformation;
  }

  static Future<void> clearUserProfile() async {
    try {
      LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
      await _localDb.clear();
    } catch (e) {
      return;
    }
  }

  static Future<void> updateUserProfile(
      UserInformation _userInformation) async {
    await clearUserProfile();
    LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
    await _localDb.addData(_userInformation);
    await _localDb.close();
  }
}
