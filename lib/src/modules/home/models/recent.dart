import 'package:hive/hive.dart';
part 'recent.g.dart';

@HiveType(typeId: 6)
class Recent {
  @HiveField(0)
  int? hiveobjid;
  @HiveField(1)
  String? titleC;

  @HiveField(2)
  dynamic appIconC;

  @HiveField(4)
  String? id;
  @HiveField(5)
  String? name;
  @HiveField(6)
  String? objectName;
  @HiveField(7)
  String? rtfHTMLC;
  @HiveField(8)
  String? typeC;

  // @HiveField(10)
  // String? schoolId;
  // @HiveField(11)
  // String? dept;

  // @HiveField(13)

  @HiveField(9)
  final statusC;
  @HiveField(10)
  String? urlC;
  @HiveField(11)
  String? pdfURL;
  @HiveField(12)
  final sortOrder;
  @HiveField(13)
  String? deepLink;
  @HiveField(14)
  String? appURLC;
  @HiveField(15)
  String? calendarId;
  @HiveField(16)
  String? emailC;
  @HiveField(17)
  String? imageUrlC;
  @HiveField(18)
  String? phoneC;
  @HiveField(19)
  String? webURLC;
  @HiveField(20)
  String? address;
  @HiveField(21)
  final geoLocation;
  @HiveField(22)
  dynamic descriptionC;

  Recent(
    this.hiveobjid,
    this.titleC,
    this.appIconC,
    this.id,
    this.name,
    this.objectName,
    this.rtfHTMLC,
    this.typeC,

    // this.schoolId,
    // this.dept,

    this.statusC,
    this.urlC,
    this.pdfURL,
    this.sortOrder,
    this.deepLink,
    this.appURLC,
    this.calendarId,
    this.emailC,
    this.imageUrlC,
    this.phoneC,
    this.webURLC,
    this.address,
    this.geoLocation,
    this.descriptionC,
  );
}
