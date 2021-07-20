import 'attributes.dart';

class StaffList {
  Attributes? attributes;
  String? titleC;
  dynamic appIconC;
  dynamic urlC;
  String? id;
  String? name;

  StaffList({
    this.attributes,
    this.titleC,
    this.appIconC,
    this.urlC,
    this.id,
    this.name,
  });

  factory StaffList.fromJson(Map<String, dynamic> json) => StaffList(
        attributes: json['attributes'] == null
            ? null
            : Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
        titleC: json['Title__c'] as String?,
        appIconC: json['App_Icon__c'],
        urlC: json['URL__c'],
        id: json['Id'] as String?,
        name: json['Name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'attributes': attributes?.toJson(),
        'Title__c': titleC,
        'App_Icon__c': appIconC,
        'URL__c': urlC,
        'Id': id,
        'Name': name,
      };
}
