import '../../../services/local_database/hive_db_services.dart';

class UserGoogleProfile {
   static updateUserProfileIntoDB(updatedObj) {
    HiveDbServices _localdb = HiveDbServices();
    _localdb.updateListData("user_profile", 0, updatedObj);
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
