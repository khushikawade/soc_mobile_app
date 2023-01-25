import 'package:Soc/src/services/utility.dart';
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
  final sortOrderC;
  @HiveField(7)
  String? phoneC;
  @HiveField(8)
  String? status;
  @HiveField(9)
  String? darkModeIconC;
  @HiveField(10)
  String? groupingC;
  @HiveField(11)
  final groupSortOrder;
  @HiveField(12)
  String? groupImageURL;
  @HiveField(13)
  String? isFolderC;
  @HiveField(14)
  String? appFolderC;
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
      this.status,
      this.darkModeIconC,
      this.groupingC,
      this.groupSortOrder,
      this.groupImageURL,
      this.isFolderC,
      this.appFolderC});

  factory SDlist.fromJson(Map<String, dynamic> json) => SDlist(
      // attributes: json['attributes'] == null
      //     ? null
      //     : SDAttributes.fromJson(json['attributes'] as Map<String, dynamic>),
      designation: Utility.utf8convert(json['Title__c']),
      imageUrlC: json['Image_URL__c'] as String?,
      id: json['Id'] as String?,
      name: Utility.utf8convert(json['Name__c'] as String?),
      descriptionC: Utility.utf8convert(json['Description__c']),
      emailC: json['Email__c'] as String?,
      sortOrderC: double.parse(json['Sort_Order__c'] ?? '100'),
      phoneC: json['Phone__c'] as String?,
      status: json['Active_Status__c'] ?? 'Show',
      darkModeIconC: json['Dark_Mode_Icon__c'],
      groupingC: json['Grouping__c'],
      groupSortOrder: double.parse(json['Group_Sort_Order__c'] ?? '100'),
      groupImageURL: json['Group_Image_URL__c'],
      appFolderC: json['App_Folder__c'] as String?,
      isFolderC: json['Is_Folder__c'] as String?);

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
        'Dark_Mode_Icon__c': darkModeIconC,
        'Grouping__c': groupingC,
        'Group_Sort_Order__c': groupSortOrder,
        'Group_Image_URL__c': groupImageURL,
        "Is_Folder__c": isFolderC
      };
}
