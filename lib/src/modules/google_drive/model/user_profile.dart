import '../../../services/local_database/hive_db_services.dart';
import '../../../services/local_database/local_db.dart';
import '../../ocr/modal/user_info.dart';

class UserGoogleProfile {
  static updateUserProfileIntoDB(updatedObj) {
    HiveDbServices _localdb = HiveDbServices();
    _localdb.updateListData("user_profile", 0, updatedObj);
  }

  static Future<List<UserInformation>> getUserProfile() async {
    LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
    List<UserInformation> _userInformation = await _localDb.getData();
    if (_userInformation.isNotEmpty) {
      print(_userInformation[0].authorizationToken);
      print(_userInformation[0].profilePicture);
      print(_userInformation[0].refreshToken);
      print(_userInformation[0].userEmail);
      print(_userInformation[0].userName);
    }
    _localDb.close();
    return _userInformation;
  }

  static Future<void> clearUserProfile() async {
    LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
    _localDb.clear();
  }
}
