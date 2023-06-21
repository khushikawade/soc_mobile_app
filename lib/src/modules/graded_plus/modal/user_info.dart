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
  String? gradedPlusGoogleDriveFolerId;
  @HiveField(7)
  String? pbisPlusGoogleDriveFolerId;
  @HiveField(8)
  String? studentPlusGoogleDriveFolerId;
  @HiveField(9)
  String? gradedPlusGoogleDriveFolerPathUrl;

  UserInformation(
      {this.userName,
      this.userEmail,
      this.profilePicture,
      this.authorizationToken,
      this.refreshToken,
      this.idToken,
      this.gradedPlusGoogleDriveFolerId,
      this.pbisPlusGoogleDriveFolerId,
      this.studentPlusGoogleDriveFolerId});
}
