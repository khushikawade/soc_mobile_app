import 'dart:ffi';

import 'attributes.dart';
import 'package:hive/hive.dart';
part 'custom_setting.g.dart';

@HiveType(typeId: 11)
class CustomSetting {
  @HiveField(0)
  Attributes? attributes;
  @HiveField(1)
  String? id;
  @HiveField(2)
  final String? bannerColorC;
  @HiveField(3)
  final String? bannerImageC;
  @HiveField(4)
  String? lastModifiedDate;
  @HiveField(5)
  String? lastModifiedById;
  @HiveField(6)
  String? ownerId;
  @HiveField(7)
  String? name;
  @HiveField(8)
  String? createdDate;
  @HiveField(9)
  String? customAppC;
  @HiveField(10)
  String? sectionIconC;
  @HiveField(11)
  String? selectionTitleC;
  @HiveField(12)
  double? sortOrderC;
  @HiveField(13)
  String? standardSectionC;
  @HiveField(14)
  String? typeOfSectionC;
  @HiveField(15)
  bool? isDeleted;
  @HiveField(16)
  String? systemModstamp;
  @HiveField(17)
  dynamic lastActivityDate;
  @HiveField(18)
  String? lastViewedDate;
  @HiveField(19)
  String? lastReferencedDate;
  @HiveField(20)
  String? connectionReceivedId;
  @HiveField(21)
  String? connectionSentId;
  @HiveField(22)
  String? schoolAppC;

  CustomSetting({
    this.attributes,
    this.id,
    this.bannerColorC,
    this.bannerImageC,
    this.lastModifiedDate,
    this.lastModifiedById,
    this.ownerId,
    this.name,
    this.createdDate,
    this.customAppC,
    this.sectionIconC,
    this.selectionTitleC,
    this.sortOrderC,
    this.standardSectionC,
    this.typeOfSectionC,
    this.isDeleted,
    this.systemModstamp,
    this.lastActivityDate,
    this.lastViewedDate,
    this.lastReferencedDate,
    this.connectionReceivedId,
    this.connectionSentId,
    this.schoolAppC,
  });

  factory CustomSetting.fromJson(Map<String, dynamic> json) => CustomSetting(
        attributes: json['attributes'] == null
            ? null
            : Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
        id: json['Id'] as String?,
        bannerColorC: json['Banner_color__c'],
        bannerImageC: json['Banner_Image_URL__c'],
        lastModifiedDate: json['LastModifiedDate'],
        lastModifiedById: json['LastModifiedById'],
        ownerId: json['OwnerId'],
        name: json['Name'],
        createdDate: json['CreatedDate'],
        sectionIconC: json['Section_icon_URL__c'],
        selectionTitleC: json['Section_Title__c'],
        sortOrderC: double.parse(json['Sort_Order__c'] ?? '100'),
        standardSectionC: json['Standard_section__c'],
        typeOfSectionC: json['Type_of_section__c'],
        lastActivityDate: json['LastActivityDate'],
        isDeleted: json['IsDeleted'].toString().toLowerCase() == 'true'
            ? true
            : false as bool?,
        customAppC: json['Custom_App_Section__c'],
        systemModstamp: json['SystemModstamp'],
        lastViewedDate: json['LastViewedDate'],
        lastReferencedDate: json['LastReferencedDate'],
        connectionReceivedId: json['ConnectionReceivedId'],
        connectionSentId: json['ConnectionSentId'],
        schoolAppC: json['School_App__c'],
      );

  Map<String, dynamic> toJson() => {
        'attributes': attributes?.toJson(),
        'Id': id,
        'Banner_color__c': bannerColorC,
        'Banner_Image_URL__c': bannerImageC,
        'LastModifiedDate': lastModifiedDate,
        'LastModifiedById': lastModifiedById,
        'OwnerId': ownerId,
        'IsDeleted': isDeleted,
        'Name': name,
        'CreatedDate': createdDate,
        'LastActivityDate': lastActivityDate,
        'LastViewedDate': lastViewedDate,
        'LastReferencedDate': lastReferencedDate,
        'School_App__c': schoolAppC,
        'Section_icon_URL__c': sectionIconC,
        'Section_Title__c': selectionTitleC,
        'Sort_Order__c': sortOrderC,
        'Standard_section__c': standardSectionC,
        'Type_of_section__c': typeOfSectionC,
        'Custom_App_Section__c': customAppC,
        'SystemModstamp': systemModstamp,
        'ConnectionReceivedId': connectionReceivedId,
        'ConnectionSentId': connectionSentId,
      };

  CustomSetting copyWith({
    Attributes? attributes,
    String? id,
    final String? bannerColorC,
    final String? bannerImageC,
    String? lastModifiedDate,
    String? lastModifiedById,
    String? ownerId,
    String? name,
    String? createdDate,
    String? customAppC,
    String? sectionIconC,
    String? selectionTitleC,
    double? sortOrderC,
    String? standardSectionC,
    String? typeOfSectionC,
    bool? isDeleted,
    String? systemModstamp,
    dynamic lastActivityDate,
    String? lastViewedDate,
    String? lastReferencedDate,
    String? connectionReceivedId,
    String? connectionSentId,
    String? schoolAppC,
  }) {
    return CustomSetting(
      attributes: attributes ?? this.attributes,
      id: id ?? this.id,
      bannerColorC: bannerColorC ?? this.bannerColorC,
      bannerImageC: bannerImageC ?? this.bannerImageC,
      ownerId: ownerId ?? this.ownerId,
      isDeleted: isDeleted ?? this.isDeleted,
      name: name ?? this.name,
      createdDate: createdDate ?? this.createdDate,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
      lastModifiedById: lastModifiedById ?? this.lastModifiedById,
      systemModstamp: systemModstamp ?? this.systemModstamp,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      lastViewedDate: lastViewedDate ?? this.lastViewedDate,
      lastReferencedDate: lastReferencedDate ?? this.lastReferencedDate,
      schoolAppC: schoolAppC ?? this.schoolAppC,
      sectionIconC: sectionIconC ?? this.sectionIconC,
      selectionTitleC: selectionTitleC ?? this.selectionTitleC,
      sortOrderC: sortOrderC ?? this.sortOrderC,
      standardSectionC: standardSectionC ?? this.standardSectionC,
      typeOfSectionC: typeOfSectionC ?? this.typeOfSectionC,
      customAppC: customAppC ?? this.customAppC,
      connectionReceivedId: connectionReceivedId ?? this.connectionReceivedId,
      connectionSentId: connectionSentId ?? this.connectionSentId,
    );
  }
}
