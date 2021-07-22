import 'package:Soc/src/modules/home/model/search_attributes.dart';

class SearchList {
  SearchAttributes? attributes;
  // String? titleC;
  // dynamic appIconC;
  // dynamic urlC;
  String? id;
  // String? name;
  // String? typeC;
  // String? rtfHTMLC;
  // String? pdfURL;
  // var sortOredr;

  SearchList({
    this.attributes,
    // this.titleC,
    // this.appIconC,
    // this.urlC,
    this.id,
    // this.name,
    // this.pdfURL,
    // this.rtfHTMLC,
    // this.typeC,
    // this.sortOredr
  });

  factory SearchList.fromJson(Map<String, dynamic> json) => SearchList(
        attributes: json['attributes'] == null
            ? null
            : SearchAttributes.fromJson(
                json['attributes'] as Map<String, dynamic>),
        // titleC: json['Title__c'] as String?,
        // appIconC: json['App_Icon__c'] as String?,
        // urlC: json['URL__c'] as String?,
        // pdfURL: json['PDF_URL__c'] as String?,
        id: json['Id'] as String?,
        // name: json['Name'] as String?,
        // rtfHTMLC: json['RTF_HTML__c'] as String?,
        // typeC: json['Type__c'] as String?,
        // sortOredr: json['Sort_Order__c'],
      );

  Map<String, dynamic> toJson() => {
        'attributes': attributes?.toJson(),
        // 'Title__c': titleC,
        // 'App_Icon__c': appIconC,
        // 'URL__c': urlC,
        // 'PDF_URL__c': pdfURL,
        'Id': id,
        // 'Name': name,
        // 'RTF_HTML__c': rtfHTMLC,
        // 'Type__c': typeC,
        // 'Sort_Order__c': sortOredr
      };
}