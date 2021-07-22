import 'package:Soc/src/modules/families/Submodule/staff/modal/models/attributes.dart';

class StaffList {
  Attributes? attributes;
  dynamic titleC;
  String? imageUrlC;
  String? id;
  String? name;
  dynamic descriptionC;
  String? emailC;
  var sortOrderC;
  String? phoneC;

  StaffList({
    this.attributes,
    this.titleC,
    this.imageUrlC,
    this.id,
    this.name,
    this.descriptionC,
    this.emailC,
    this.sortOrderC,
    this.phoneC,
  });

  factory StaffList.fromJson(Map<String, dynamic> json) => StaffList(
        attributes: json['attributes'] == null
            ? null
            : Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
        titleC: json['Title__c'],
        imageUrlC: json['Image_URL__c'] as String?,
        id: json['Id'] as String?,
        name: json['Name'] as String?,
        descriptionC: json['Description__c'],
        emailC: json['Email__c'] as String?,
        sortOrderC: json['Sort_Order__c'] as int?,
        phoneC: json['Phone__c'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'attributes': attributes?.toJson(),
        'Title__c': titleC,
        'Image_URL__c': imageUrlC,
        'Id': id,
        'Name': name,
        'Description__c': descriptionC,
        'Email__c': emailC,
        'Sort_Order__c': sortOrderC,
        'Phone__c': phoneC,
      };
}
