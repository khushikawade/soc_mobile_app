import 'package:hive/hive.dart';
part 'user_info.g.dart';
@HiveType(typeId: 15)
class UserInfo {
  @HiveField(0)
  String? userName;
  @HiveField(1)
  String? userEmail;
  @HiveField(2)
  String? profilePicture;

  UserInfo({
    this.userName,
    this.userEmail,
    this.profilePicture,
  });
}