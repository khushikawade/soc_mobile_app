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

  NotificationList(
      {this.id, this.contents, this.headings, this.url, this.image, this.completedAt});
}
