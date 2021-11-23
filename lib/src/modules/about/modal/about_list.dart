import 'package:Soc/src/modules/about/modal/sd_attributes.dart';

class AboutList {
  SDAttributes? attributes;
  dynamic titleC;
  String? id;
  String? name;
  dynamic sortOrderC;
  String? urlC;
  String? appIconUrlC;
  String? pdfURL;
  String? rtfHTMLC;
  String? typeC;
  final statusC;

  AboutList(
      {this.attributes,
      this.titleC,
      this.id,
      this.name,
      this.sortOrderC,
      this.urlC,
      this.appIconUrlC,
      this.pdfURL,
      this.rtfHTMLC,
      this.typeC,
      this.statusC});

  factory AboutList.fromJson(Map<String, dynamic> json) => AboutList(
        attributes: json['attributes'] == null
            ? null
            : SDAttributes.fromJson(json['attributes'] as Map<String, dynamic>),
        titleC: json['Title__c'],
        appIconUrlC: json['App_Icon_URL__c'] as String?,
        id: json['Id'] as String?,
        name: json['Name'] as String?,
        rtfHTMLC: json['RTF_HTML__c'] as String?,
        typeC: json['Type__c'] as String?,
        pdfURL: json['PDF_URL__c'] as String?,
        sortOrderC: json['Sort_Order__c'],
        urlC: json['URL__c'] as String?,
        statusC: json['Active_Status__c'],
      );

  Map<String, dynamic> toJson() => {
        'attributes': attributes?.toJson(),
        'Title__c': titleC,
        'PDF_URL__c': pdfURL,
        'Id': id,
        'Name': name,
        'RTF_HTML__c': rtfHTMLC,
        'Type__c': typeC,
        'Sort_Order__c': sortOrderC,
        'App_Icon_URL__c': appIconUrlC,
        'URL__c': urlC,
        'Active_Status__c': statusC
      };
}
