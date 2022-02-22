import 'package:hive/hive.dart';
part 'student_app.g.dart';

@HiveType(typeId: 5)
class StudentApp {
  @HiveField(0)
  String? titleC;
  @HiveField(1)
  String? appIconC; //App_Icon_URL__c
  @HiveField(2)
  String? appUrlC;
  @HiveField(3)
  String? deepLinkC;
  @HiveField(4)
  String? id;
  @HiveField(5)
  String? name;
  @HiveField(6)
  String? appFolderc;
  @HiveField(7)
  final sortOrder;
  @HiveField(8)
  final status;
  @HiveField(9)
  final isFolder;

  StudentApp(
      {this.titleC,
      this.appIconC,
      this.appUrlC,
      this.deepLinkC,
      this.id,
      this.name,
      this.appFolderc,
      this.sortOrder,
      this.status,
      this.isFolder});

  factory StudentApp.fromJson(Map<String, dynamic> json) => StudentApp(
      titleC: json['Title__c'] as String?,
      appIconC: json['App_Icon_URL__c'] as String?,
      appUrlC: json['App_URL__c'] as String?,
      deepLinkC: json['Deep_Link__c'] as String?,
      id: json['Id'] as String?,
      name: json['Name'] as String?,
      appFolderc: json['App_Folder__c'] as String?,
      sortOrder: double.parse(json['Sort_Order__c'] ?? '100'),
      status: json['Active_Status__c'],
      isFolder: json['Is_Folder__c']);

  Map<String, dynamic> toJson() => {
        'Title__c': titleC,
        'App_Icon__c': appIconC,
        'App_URL__c': appUrlC,
        'Deep_Link__c': deepLinkC,
        'Id': id,
        'Name': name,
        'App_Folder__c': appFolderc,
        'Sort_Order__c': sortOrder,
        'Active_Status__c': status,
        'Is_Folder__c': isFolder
      };
}
