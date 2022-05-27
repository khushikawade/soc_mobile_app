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
//   String? title;
//   String? description;
//   String? fileid;
//   final label;
//   HistoryAssessment({this.title, this.description, this.fileid, this.label});

//   factory HistoryAssessment.fromJson(Map<String, dynamic> json) => HistoryAssessment(
//       title: json['title'] as String?,
//       description: json['description'] as String?,
//       fileid: json['id'] as String?,
//       label: json['labels'] 
//       );
}
