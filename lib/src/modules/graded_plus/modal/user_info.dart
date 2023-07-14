import 'package:hive/hive.dart';
part 'user_info.g.dart';

@HiveType(typeId: 15)
class UserInformation {
  @HiveField(0)
  String? userName;
  @HiveField(1)
  String? userEmail;
  @HiveField(2)
  String? profilePicture;
  @HiveField(3)
  String? authorizationToken;
  @HiveField(4)
  String? refreshToken;
  @HiveField(5)
  String? idToken; //google sso
  @HiveField(6)
  String? gradedPlusGoogleDriveFolderId;
  @HiveField(7)
  String? pbisPlusGoogleDriveFolderId;
  @HiveField(8)
  String? studentPlusGoogleDriveFolderId;
  @HiveField(9)
  String? gradedPlusGoogleDriveFolderPathUrl;
  @HiveField(10)
  String? userType;
  @HiveField(11)
  String? familyToken;
 

  UserInformation(
      {this.userName,
      this.userEmail,
      this.profilePicture,
      this.authorizationToken,
      this.refreshToken,
      this.idToken,
      this.gradedPlusGoogleDriveFolderId,
      this.pbisPlusGoogleDriveFolderId,
      this.studentPlusGoogleDriveFolderId,
      this.gradedPlusGoogleDriveFolderPathUrl,
      this.userType,
      this.familyToken});
}
