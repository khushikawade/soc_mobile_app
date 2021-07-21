import '../modal/sub_attributes.dart';

class FamiliesSubList {
  SubAttributes? attributes;
  String? titleC;
  String? appUrlC;
  String? pdfURL;
  String? id;
  String? name;
  String? rtfHTMLC;
  String? typeC;
  var sortOredr;

  FamiliesSubList(
      {this.attributes,
      this.titleC,
      this.appUrlC,
      this.pdfURL,
      this.id,
      this.name,
      this.rtfHTMLC,
      this.typeC,
      this.sortOredr});

  factory FamiliesSubList.fromJson(Map<String, dynamic> json) =>
      FamiliesSubList(
        attributes: json['attributes'] == null
            ? null
            : SubAttributes.fromJson(
                json['attributes'] as Map<String, dynamic>),
        titleC: json['Title__c'] as String?,
        appUrlC: json['URL__c'] as String?,
        pdfURL: json['PDF_URL__c'] as String?,
        id: json['Id'] as String?,
        name: json['Name'] as String?,
        rtfHTMLC: json['RTF_HTML__c'] as String?,
        typeC: json['Type__c'] as String?,
        sortOredr: json['Sort_Order__c'],
      );

  Map<String, dynamic> toJson() => {
        'attributes': attributes?.toJson(),
        'Title__c': titleC,
        'URL__c': appUrlC,
        'PDF_URL__c': pdfURL,
        'Id': id,
        'Name': name,
        'RTF_HTML__c': rtfHTMLC,
        'Type__c': typeC,
        'Sort_Order__c': sortOredr
      };
}