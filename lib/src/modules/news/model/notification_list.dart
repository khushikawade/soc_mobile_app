import 'package:hive/hive.dart';
part 'notification_list.g.dart';

@HiveType(typeId: 7)
class NotificationList {
  @HiveField(0)
  String? id;
  @HiveField(1)
  final contents;
  @HiveField(2)
  final headings;
  @HiveField(3)
  final url;
  @HiveField(4)
  String? image;
  @HiveField(5)
  dynamic completedAt;
  @HiveField(6)
  int? thanksCount;
  @HiveField(7)
  int? helpfulCount;
  @HiveField(8)
  int? shareCount;
  @HiveField(9)
  int? likeCount;
  @HiveField(10)
  dynamic completedAtTimestamp;
  @HiveField(11)
  int? supportCount;
  @HiveField(12)
  int? viewCount;

  NotificationList(
      {this.id,
      this.contents,
      this.headings,
      this.url,
      this.image,
      this.likeCount = 0,
      this.completedAt,
      this.thanksCount = 0,
      this.helpfulCount = 0,
      this.shareCount = 0,
      this.completedAtTimestamp,
      this.supportCount = 0,
      this.viewCount = 0});
}
