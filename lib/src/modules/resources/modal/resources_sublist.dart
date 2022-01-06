// class ResourcesSubList {
//   String? titleC;
//   String? appUrlC;
//   String? appIconUrlC;
//   String? pdfURL;
//   String? id;
//   String? name;
//   String? rtfHTMLC;
//   String? typeC;
//   dynamic appIconC;
//   final sortOrder;
//   final status;

//   ResourcesSubList(
//       {this.titleC,
//       this.appUrlC,
//       this.appIconUrlC,
//       this.pdfURL,
//       this.id,
//       this.name,
//       this.rtfHTMLC,
//       this.typeC,
//       this.appIconC,
//       this.sortOrder,
//       this.status});

//   factory ResourcesSubList.fromJson(Map<String, dynamic> json) =>
//       ResourcesSubList(
//           titleC: json['Title__c'] as String?,
//           appUrlC: json['URL__c'] as String?,
//           appIconUrlC: json['App_Icon_URL__c'] as String?,
//           pdfURL: json['PDF_URL__c'] as String?,
//           id: json['Id'] as String?,
//           name: json['Name'] as String?,
//           rtfHTMLC: json['RTF_HTML__c'] as String?,
//           typeC: json['Type__c'] as String?,
//           appIconC: json['App_Icon__c'],
//           sortOrder: json['Sort_Order__c'],
//           status: json['Active_Status__c']);

//   Map<String, dynamic> toJson() => {
//         'Title__c': titleC,
//         'URL__c': appUrlC,
//         'PDF_URL__c': pdfURL,
//         'Id': id,
//         'Name': name,
//         'RTF_HTML__c': rtfHTMLC,
//         'Type__c': typeC,
//         'App_Icon__c': appIconC,
//         'Sort_Order__c': sortOrder,
//         'App_Icon_URL__c': appIconUrlC,
//         'Active_Status__c': status
//       };
// }
