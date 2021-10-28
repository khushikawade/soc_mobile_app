import 'package:Soc/src/modules/about/modal/sd_attributes.dart';

class AboutStaffDirectoryList {
  SDAttributes? attributes;
  dynamic titleC;
  String? imageUrlC;
  String? id;
  String? name;
  dynamic descriptionC;
  String? emailC;
  dynamic sortOrderC;
  String? phoneC;
  String? department;
  String? urlC;
  final statusC;

  AboutStaffDirectoryList(
      {this.attributes,
      this.titleC,
      this.imageUrlC,
      this.id,
      this.name,
      this.descriptionC,
      this.emailC,
      this.sortOrderC,
      this.phoneC,
      this.department,
      this.urlC,
      this.statusC});

  factory AboutStaffDirectoryList.fromJson(Map<String, dynamic> json) =>
      AboutStaffDirectoryList(
        attributes: json['attributes'] == null
            ? null
            : SDAttributes.fromJson(json['attributes'] as Map<String, dynamic>),
        titleC: json['Title__c'],
        imageUrlC: json['Image_URL__c'] as String?,
        id: json['Id'] as String?,
        name: json['Name__c'] as String?,
        descriptionC: json['Description__c'],
        emailC: json['Email__c'] as String?,
        sortOrderC: json['Sort_Order__c'],
        phoneC: json['Phone__c'] as String?,
        department: json['Department__c'] as String?,
        urlC: json['URL__c'] as String?,
        statusC: json['Active_Status__c'],
      );

  Map<String, dynamic> toJson() => {
        'attributes': attributes?.toJson(),
        'Title__c': titleC,
        'Image_URL__c': imageUrlC,
        'Id': id,
        'Name__c': name,
        'Description__c': descriptionC,
        'Email__c': emailC,
        'Sort_Order__c': sortOrderC,
        'Phone__c': phoneC,
        'Department__c': department,
        'URL__c': urlC,
        'Active_Status__c': statusC
      };
}
