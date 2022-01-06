import 'package:hive/hive.dart';
// part 'recent.g.dart';

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
  @HiveField(10)
  String? schoolId;
  @HiveField(11)
  String? dept;
  @HiveField(12)
  dynamic descriptionC;
  @HiveField(13)
  String? emailC;
  @HiveField(14)
  String? imageUrlC;
  @HiveField(15)
  String? phoneC;
  @HiveField(16)
  String? webURLC;
  @HiveField(17)
  String? address;
  @HiveField(18)
  final geoLocation;
  @HiveField(19)
  final statusC;
  @HiveField(20)
  final sortOrder;
  @HiveField(20)
  String? calendarId;


  Recent(
      this.hiveobjid,
      this.titleC,
      this.appURLC,
      this.urlC,
      this.id,
      this.name,
      this.pdfURL,
      this.rtfHTMLC,
      this.typeC,
      this.deepLink,
      this.schoolId,
      this.dept,
      this.descriptionC,
      this.emailC,
      this.imageUrlC,
      this.phoneC,
      this.webURLC,
      this.address,
      this.geoLocation,
      this.statusC,
      this.sortOrder,this.calendarId);
}
