import '../../staff_directory/modal/../../families/modal/sd_attributes.dart';

class SDlist {
  SDAttributes? attributes;
  dynamic designation;
  String? imageUrlC;
  String? id;
  String? name;
  dynamic descriptionC;
  String? emailC;
  dynamic sortOrderC;
  String? phoneC;

  SDlist({
    this.attributes,
    this.designation,
    this.imageUrlC,
    this.id,
    this.name,
    this.descriptionC,
    this.emailC,
    this.sortOrderC,
    this.phoneC,
  });

  factory SDlist.fromJson(Map<String, dynamic> json) => SDlist(
        attributes: json['attributes'] == null
            ? null
            : SDAttributes.fromJson(json['attributes'] as Map<String, dynamic>),
        designation: json['Title__c'],
        imageUrlC: json['Image_URL__c'] as String?,
        id: json['Id'] as String?,
        name: json['Name__c'] as String?,
        descriptionC: json['Description__c'],
        emailC: json['Email__c'] as String?,
        sortOrderC: json['Sort_Order__c'],
        phoneC: json['Phone__c'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'attributes': attributes?.toJson(),
        'Title__c': designation,
        'Image_URL__c': imageUrlC,
        'Id': id,
        'Name__c': name,
        'Description__c': descriptionC,
        'Email__c': emailC,
        'Sort_Order__c': sortOrderC,
        'Phone__c': phoneC,
      };
}
