import 'package:hive/hive.dart';

part 'item.g.dart';

@HiveType(typeId: 8)
class Item {
  @HiveField(0)
  final title;
  @HiveField(1)
  final description;
  @HiveField(2)
  final link;
  @HiveField(3)
  final guid;
  @HiveField(4)
  final creator;
  @HiveField(5)
  final pubDate;
  @HiveField(6)
  final content;
  @HiveField(7)
  final mediaContent;
  @HiveField(8)
  final enclosure;
  @HiveField(9)
  dynamic id;
  @HiveField(10)
  int? likeCount;
  @HiveField(11)
  int? thanksCount;
  @HiveField(12)
  int? helpfulCount;
  @HiveField(13)
  int? shareCount;
  @HiveField(14)
  dynamic completedAt;
  
  

  Item(
      {this.title,
      this.description,
      this.link,
      this.guid,
      this.creator,
      this.pubDate,
      this.content,
      this.mediaContent,
      this.enclosure,
      this.id,
      this.likeCount = 0,
      this.completedAt,
      this.thanksCount = 0,
      this.helpfulCount = 0,
      this.shareCount = 0});
}
