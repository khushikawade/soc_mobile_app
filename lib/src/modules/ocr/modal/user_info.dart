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
  
  

  UserInformation({
    this.userName,
    this.userEmail,
    this.profilePicture,
    this.authorizationToken
  });
}