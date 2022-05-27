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
    _localDb.close();
    return _userInformation;
  }

  static Future<void> clearUserProfile() async {
    LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
    _localDb.clear();
  }
}
