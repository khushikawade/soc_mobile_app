import '../ui/../models/staff_sublist_attributes.dart';

class StaffSubList {
  StaffSubListAttributes? attributes;
  String? titleC;
  dynamic appIconC;
  String? appIconUrlC;
  dynamic urlC;
  String? id;
  String? name;
  String? typeC;
  String? rtfHTMLC;
  String? pdfURL;
  final sortOredr;
  final status;

  StaffSubList(
      {this.attributes,
      this.titleC,
      this.appIconC,
      this.appIconUrlC,
      this.urlC,
      this.id,
      this.name,
      this.pdfURL,
      this.rtfHTMLC,
      this.typeC,
      this.sortOredr,
      this.status
      });

  factory StaffSubList.fromJson(Map<String, dynamic> json) => StaffSubList(
        attributes: json['attributes'] == null
            ? null
            : StaffSubListAttributes.fromJson(
                json['attributes'] as Map<String, dynamic>),
        titleC: json['Title__c'] as String?,
        appIconC: json['App_Icon__c'] as String?,
        appIconUrlC: json['App_Icon_URL__c'] as String?,
        urlC: json['URL__c'] as String?,
        pdfURL: json['PDF_URL__c'] as String?,
        id: json['Id'] as String?,
        name: json['Name'] as String?,
        rtfHTMLC: json['RTF_HTML__c'] as String?,
        typeC: json['Type__c'] as String?,
        sortOredr: json['Sort_Order__c'],
        status: json['Active_Status__c'] 
      );

  Map<String, dynamic> toJson() => {
        'attributes': attributes?.toJson(),
        'Title__c': titleC,
        'App_Icon__c': appIconC,
        'App_Icon_URL__c':appIconUrlC,
        'URL__c': urlC,
        'PDF_URL__c': pdfURL,
        'Id': id,
        'Name': name,
        'RTF_HTML__c': rtfHTMLC,
        'Type__c': typeC,
        'Sort_Order__c': sortOredr,
        'Active_Status__c':status
      };
}
