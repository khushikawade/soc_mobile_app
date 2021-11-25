// class AboutSubList {
//   // SubAttributes? attributes;
//   String? titleC;
//   String? appUrlC;
//   String? appIconUrlC;
//   String? pdfURL;
//   String? id;
//   String? name;
//   String? rtfHTMLC;
//   String? typeC;
//   final sortOrder;
//   final status;

//   AboutSubList(
//       {
//       // this.attributes,
//       this.titleC,
//       this.appUrlC,
//       this.appIconUrlC,
//       this.pdfURL,
//       this.id,
//       this.name,
//       this.rtfHTMLC,
//       this.typeC,
//       this.sortOrder,
//       this.status});

//   factory AboutSubList.fromJson(Map<String, dynamic> json) => AboutSubList(
//       // attributes: json['attributes'] == null
//       //     ? null
//       //     : SubAttributes.fromJson(
//       //         json['attributes'] as Map<String, dynamic>),
//       titleC: json['Title__c'] as String?,
//       appUrlC: json['URL__c'] as String?,
//       appIconUrlC: json['App_Icon_URL__c'] as String?,
//       pdfURL: json['PDF_URL__c'] as String?,
//       id: json['Id'] as String?,
//       name: json['Name'] as String?,
//       rtfHTMLC: json['RTF_HTML__c'] as String?,
//       typeC: json['Type__c'] as String?,
//       sortOrder: json['Sort_Order__c'],
//       status: json['Active_Status__c']);

//   Map<String, dynamic> toJson() => {
//         // 'attributes': attributes?.toJson(),
//         'Title__c': titleC,
//         'URL__c': appUrlC,
//         'PDF_URL__c': pdfURL,
//         'Id': id,
//         'Name': name,
//         'RTF_HTML__c': rtfHTMLC,
//         'Type__c': typeC,

//         'Sort_Order__c': sortOrder,
//         'App_Icon_URL__c': appIconUrlC,
//         'Active_Status__c': status
//       };
// }
