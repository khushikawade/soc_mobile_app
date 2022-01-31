import 'dart:convert';

import 'package:Soc/src/modules/home/models/search_attributes.dart';

class SearchList {
  // SearchAttributes? attributes;
  String? titleC;
  dynamic appIconC;
  dynamic appURLC;
  dynamic urlC;
  String? id;
  String? rtfHTMLC;
  // String? schoolId;
  // String? dept;
  dynamic descriptionC;
  String? emailC;
  String? imageUrlC;
  String? phoneC;
  String? webURLC;
  String? address;
  final geoLocation;
  final statusC;
  double? sortOrder;
  String? name;
  String? typeC;
  String? pdfURL;
  String? deepLink;
  String? calendarId;
  String? objectName;

  SearchList(
      {
      // this.attributes,
      this.titleC,
      this.appIconC,
      this.appURLC,
      this.urlC,
      this.id,
      this.rtfHTMLC,
      // this.schoolId,
      // this.dept,
      this.descriptionC,
      this.emailC,
      this.imageUrlC,
      this.phoneC,
      this.webURLC,
      this.address,
      this.geoLocation,
      this.statusC,
      this.sortOrder,
      this.name,
      this.typeC,
      this.pdfURL,
      this.deepLink,
      this.calendarId,
      this.objectName});

  factory SearchList.fromJson(Map<String, dynamic> json) => SearchList(
        // attributes: json['attributes'] == null
        //     ? null
        //     : SearchAttributes.fromJson(
        //         json['attributes'] as Map<String, dynamic>),
        titleC: json['Title__c'] as String?,
        appIconC: json['Icon_URL'] as String?,
        // appIconC: json['App_Icon__c'] as String?,
        appURLC: json['App_URL__c'] as String?,
        urlC: json['URL__c'] as String?,
        id: json['Id'] as String?,
        rtfHTMLC: json['RTF_HTML__c'] as String?,
        // schoolId: json['School_App__c'] as String?,
        // dept: json['Department__c'] as String?,
        descriptionC: json['Description__c'],
        emailC: json['Email__c'] as String?,
        imageUrlC: json['Image_URL__c'] as String?,
        phoneC: json['Phone__c'] as String?,
        webURLC: json['Website_URL__c'] as String?,
        address: json['Contact_Address__c'] as String?,
        geoLocation: json['Contact_Office_Location__c'],
        statusC: json['Active_Status__c'],
        sortOrder: double.parse(json['Sort_Order__c']),
        name: json['Name'] as String?,
        typeC: json['Type__c'] as String?,
        pdfURL: json['PDF_URL__c'] as String?,
        deepLink: json['Deep_Link__c'] as String?,
        calendarId: json['Calendar_Id__c'] as String?,
        objectName: json['ObjectName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        // 'attributes': attributes?.toJson(),
        'Title__c': titleC,
        'Icon_URL': appIconC,
        // 'App_Icon__c': appIconC,
        "App_URL__c": appURLC,
        'URL__c': urlC,
        'Id': id,
        'RTF_HTML__c': rtfHTMLC,
        // 'School_App__c': schoolId,
        // 'Department__c': dept,
        'Description__c': descriptionC,
        'Email__c': emailC,
        'Image_URL__c': imageUrlC,
        'Phone__c': phoneC,
        'Website_URL__c': webURLC,
        'Contact_Address__c': address,
        'Contact_Office_Location__c': geoLocation,
        'Active_Status__c': statusC,
        'Sort_Order__c': sortOrder,
        'Name': name,
        'PDF_URL__c': pdfURL,
        'Type__c': typeC,
        'Deep_Link__c': deepLink,
        'Calendar_Id__c': calendarId,
        'ObjectName': objectName
      };
}
