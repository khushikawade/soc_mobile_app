// import 'attributes.dart';

// class StaffList {
//   Attributes? attributes;
//   String? titleC;
//   dynamic appIconC;
//   String? appIconUrlC;
//   dynamic urlC;
//   String? appUrlC;
//   String? id;
//   String? name;
//   String? typeC;
//   String? rtfHTMLC;
//   String? pdfURL;
//   String? calendarId;
//   String? bannerimagec;
//   final sortOrder;
//   final status;

//   StaffList(
//       {this.attributes,
//       this.titleC,
//       this.appIconC,
//       this.urlC,
//       this.id,
//       this.appIconUrlC,
//       this.name,
//       this.pdfURL,
//       this.rtfHTMLC,
//       this.typeC,
//       this.sortOrder,
//       this.calendarId,
//       this.status,
//       this.appUrlC,
//       this.bannerimagec});

//   factory StaffList.fromJson(Map<String, dynamic> json) => StaffList(
//       attributes: json['attributes'] == null
//           ? null
//           : Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
//       titleC: json['Title__c'] as String?,
//       appIconUrlC: json['App_Icon_URL__c'] as String?,
//       appIconC: json['App_Icon__c'] as String?,
//       urlC: json['URL__c'] as String?,
//       appUrlC: json['URL__c'] as String?,
//       pdfURL: json['PDF_URL__c'] as String?,
//       id: json['Id'] as String?,
//       name: json['Name'] as String?,
//       rtfHTMLC: json['RTF_HTML__c'] as String?,
//       typeC: json['Type__c'] as String?,
//       calendarId: json['Calendar_Id__c'] as String?,
//       sortOrder: json['Sort_Order__c'],
//       status: json['Active_Status__c'],
//       bannerimagec: json['Banner_Image_c']);

//   Map<String, dynamic> toJson() => {
//         'attributes': attributes?.toJson(),
//         'Title__c': titleC,
//         'App_Icon__c': appIconC,
//         'URL__c': urlC,
//         'PDF_URL__c': pdfURL,
//         'Id': id,
//         'Name': name,
//         'RTF_HTML__c': rtfHTMLC,
//         'Type__c': typeC,
//         'Calendar_Id__c': calendarId,
//         'Sort_Order__c': sortOrder,
//         'App_Icon_URL__c': appIconUrlC,
//         'Active_Status__c': status,
//       };
// }
