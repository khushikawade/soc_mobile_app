import 'package:hive/hive.dart';

part 'recent.g.dart';

@HiveType(typeId: 6)
class Recent {
  @HiveField(0)
  int? hiveobjid;
  @HiveField(1)
  String? titleC;
  // dynamic appIconC;
  @HiveField(2)
  String? appURLC;
  @HiveField(3)
  String? urlC;
  @HiveField(4)
  String? id;
  @HiveField(5)
  String? name;
  @HiveField(6)
  String? typeC;
  @HiveField(7)
  String? rtfHTMLC;
  @HiveField(8)
  String? pdfURL;
  @HiveField(9)
  String? deepLink;

  Recent(this.hiveobjid, this.titleC, this.appURLC, this.urlC, this.id,
      this.name, this.pdfURL, this.rtfHTMLC, this.typeC, this.deepLink);
}
