import 'attributes.dart';

class StudentApp {
  Attributes? attributes;
  String? titleC;
  String? appIconC; //App_Icon_URL__c
  String? appUrlC;
  String? deepLinkC;
  String? id;
  String? name;
  String? appFolderc;
  final sortOrder;
  final status;
  final isFolder;

  StudentApp(
      {this.attributes,
      this.titleC,
      this.appIconC,
      this.appUrlC,
      this.deepLinkC,
      this.id,
      this.name,
      this.appFolderc,
      this.sortOrder,
      this.status,
      this.isFolder
      });

  factory StudentApp.fromJson(Map<String, dynamic> json) => StudentApp(
        attributes: json['attributes'] == null
            ? null
            : Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
        titleC: json['Title__c'] as String?,
        appIconC: json['App_Icon_URL__c'] as String?,
        appUrlC: json['App_URL__c'] as String?,
        deepLinkC: json['Deep_Link__c'] as String?,
        id: json['Id'] as String?,
        name: json['Name'] as String?,
        appFolderc: json['App_Folder__c'] as String?,
        sortOrder: json['Sort_Order__c'],
        status:json['Active_Status__c'],
        isFolder:json['Is_Folder__c']
      );

  Map<String, dynamic> toJson() => {
        'attributes': attributes?.toJson(),
        'Title__c': titleC,
        'App_Icon__c': appIconC,
        'App_URL__c': appUrlC,
        'Deep_Link__c': deepLinkC,
        'Id': id,
        'Name': name,
        'App_Folder__c': appFolderc,
        'Sort_Order__c': sortOrder,
        'Active_Status__c':status,
        'Is_Folder__c':isFolder
      };
}
