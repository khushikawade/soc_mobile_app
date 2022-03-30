import 'package:hive/hive.dart';
part 'sd_list.g.dart';

@HiveType(typeId: 3)
class SDlist {
  // SDAttributes? attributes;
  @HiveField(0)
  dynamic designation;
  @HiveField(1)
  String? imageUrlC;
  @HiveField(2)
  String? id;
  @HiveField(3)
  String? name;
  @HiveField(4)
  dynamic descriptionC;
  @HiveField(5)
  String? emailC;
  @HiveField(6)
  dynamic sortOrderC;
  @HiveField(7)
  String? phoneC;
  @HiveField(8)
  String? status;

  SDlist(
      {
      // this.attributes,
      this.designation,
      this.imageUrlC,
      this.id,
      this.name,
      this.descriptionC,
      this.emailC,
      this.sortOrderC,
      this.phoneC,
      this.status});

  factory SDlist.fromJson(Map<String, dynamic> json) => SDlist(
      // attributes: json['attributes'] == null
      //     ? null
      //     : SDAttributes.fromJson(json['attributes'] as Map<String, dynamic>),
      designation: json['Title__c'],
      imageUrlC: json['Image_URL__c'] as String?,
      id: json['Id'] as String?,
      name: json['Name__c'] as String?,
      descriptionC: json['Description__c'],
      emailC: json['Email__c'] as String?,
      sortOrderC: json['Sort_Order__c'],
      phoneC: json['Phone__c'] as String?,
      status: json['Active_Status__c'] ?? 'Show');

  Map<String, dynamic> toJson() => {
        // 'attributes': attributes?.toJson(),
        'Title__c': designation,
        'Image_URL__c': imageUrlC,
        'Id': id,
        'Name__c': name,
        'Description__c': descriptionC,
        'Email__c': emailC,
        'Sort_Order__c': sortOrderC,
        'Phone__c': phoneC,
        'Active_Status__c': status,
      };
}
