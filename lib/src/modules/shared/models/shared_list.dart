import 'package:Soc/src/services/utility.dart';
import 'package:hive/hive.dart';
part 'shared_list.g.dart';

@HiveType(typeId: 2)
class SharedList {
  @HiveField(0)
  String? titleC;
  @HiveField(1)
  String? appIconC;
  @HiveField(2)
  String? appIconUrlC;
  @HiveField(3)
  String? appUrlC;
  @HiveField(4)
  String? pdfURL;
  @HiveField(5)
  String? id;
  @HiveField(6)
  String? name;
  @HiveField(7)
  String? rtfHTMLC;
  @HiveField(8)
  String? typeC;
  @HiveField(9)
  String? calendarId;
  @HiveField(10)
  final sortOrder;
  @HiveField(11)
  final status;

  SharedList(
      {
      // this.attributes,
      this.titleC,
      this.appIconC,
      this.appUrlC,
      this.pdfURL,
      this.id,
      this.name,
      this.rtfHTMLC,
      this.appIconUrlC,
      this.typeC,
      this.calendarId,
      this.sortOrder,
      this.status});

  factory SharedList.fromJson(Map<String, dynamic> json) => SharedList(
      titleC: Utility.utf8convert(json['Title__c'] as String?),
      appIconC: json['App_Icon__c'] as String?,
      appIconUrlC: json['App_Icon_URL__c'] as String?,
      appUrlC: json['URL__c'] as String?,
      pdfURL: json['PDF_URL__c'] as String?,
      id: json['Id'] as String?,
      name: json['Name'] as String?,
      rtfHTMLC: json['RTF_HTML__c'] as String?,
      typeC: json['Type__c'] as String?,
      calendarId: json['Calendar_Id__c'] as String?,
      sortOrder: double.parse(json['Sort_Order__c'] ?? '100' ),
      status: json['Active_Status__c'] ?? 'Show');

  Map<String, dynamic> toJson() => {
        // 'attributes': attributes?.toJson(),
        'Title__c': titleC,
        'App_Icon__c': appIconC,
        'URL__c': appUrlC,
        'PDF_URL__c': pdfURL,
        'Id': id,
        'Name': name,
        'RTF_HTML__c': rtfHTMLC,
        'Type__c': typeC,
        'Calendar_Id__c': calendarId,
        'Sort_Order__c': sortOrder,
        'App_Icon_URL__c': appIconUrlC,
        'Active_Status__c': status,
      };
}
