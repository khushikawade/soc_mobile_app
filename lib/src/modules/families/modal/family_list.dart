import 'package:Soc/src/modules/families/modal/family_attributes.dart';

class FamiliesList {
  // Attributes? attributes;
  String? titleC;
  String? appIconC; //
  String? appIconUrlC;
  String? appUrlC;
  String? pdfURL;
  String? id;
  String? name;
  String? rtfHTMLC;
  String? typeC;
  String? calendarId;
  final sortOredr;

  FamiliesList(
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
      this.sortOredr});

  factory FamiliesList.fromJson(Map<String, dynamic> json) => FamiliesList(
      // attributes: json['attributes'] == null
      //     ? null
      //     : Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
      titleC: json['Title__c'] as String?,
      appIconC: json['App_Icon__c'] as String?,
      appIconUrlC: json['App_Icon_URL__c'] as String?,
      appUrlC: json['URL__c'] as String?,
      pdfURL: json['PDF_URL__c'] as String?,
      id: json['Id'] as String?,
      name: json['Name'] as String?,
      rtfHTMLC: json['RTF_HTML__c'] as String?,
      typeC: json['Type__c'] as String?,
      calendarId: json['Calendar_Id__c'] as String?,
      sortOredr: json['Sort_Order__c']);

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
        'Sort_Order__c': sortOredr,
        'App_Icon_URL__c':appIconUrlC
      };
}
