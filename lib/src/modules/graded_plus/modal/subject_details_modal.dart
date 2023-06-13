// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';
import 'package:hive/hive.dart';
part 'subject_details_modal.g.dart';

@HiveType(typeId: 19)
class SubjectDetailList {
  SubjectDetailList(
      {this.descriptionC,
      this.lastModifiedById,
      this.ownerId,
      this.name,
      this.domainCodeC,
      this.subjectC, //subject id
      this.titleC,
      this.id, //standard id
      this.gradeC,
      this.domainNameC,
      this.subDomainC,
      this.subSubDomainC,
      this.standardAndDescriptionC,
      this.subjectNameC,
      this.dateTime});
  @HiveField(0)
  String? descriptionC;
  @HiveField(1)
  String? lastModifiedById;
  @HiveField(2)
  String? ownerId;
  @HiveField(3)
  String? name;
  @HiveField(4)
  String? domainCodeC;
  @HiveField(5)
  String? subjectC;
  @HiveField(6)
  String? titleC;
  @HiveField(7)
  String? id;
  @HiveField(8)
  String? gradeC;
  @HiveField(9)
  String? domainNameC;
  @HiveField(10)
  String? subDomainC;
  @HiveField(11)
  String? subSubDomainC;
  @HiveField(12)
  String? standardAndDescriptionC;
  @HiveField(13)
  String? subjectNameC;
  @HiveField(14)
  DateTime? dateTime;

  factory SubjectDetailList.fromRawJson(String str) =>
      SubjectDetailList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubjectDetailList.fromJson(Map<String, dynamic> json) =>
      SubjectDetailList(
        descriptionC:
            json["Description__c"] == null ? null : json["Description__c"],
        lastModifiedById:
            json["LastModifiedById"] == null ? null : json["LastModifiedById"],
        ownerId: json["OwnerId"] == null ? null : json["OwnerId"],
        name: json["Name"] == null ? null : json["Name"],
        domainCodeC:
            json["Domain_Code__c"] == null ? null : json["Domain_Code__c"],
        subjectC: json["Subject__c"] == null ? null : json["Subject__c"],
        titleC: json["Title__c"],
        id: json["Id"] == null ? null : json["Id"],
        gradeC: json["Grade__c"],
        domainNameC: json["Domain_Name__c"],
        subDomainC: json["Sub_Domain__c"],
        subSubDomainC: json["Sub_Sub_Domain__c"],
        standardAndDescriptionC: json["Standard_and_Description__c"],
        subjectNameC: json["Subject_Name__c"],
      );

  Map<String, dynamic> toJson() => {
        "Description__c": descriptionC == null ? null : descriptionC,
        "LastModifiedById": lastModifiedById == null ? null : lastModifiedById,
        "OwnerId": ownerId == null ? null : ownerId,
        "Name": name == null ? null : name,
        "Domain_Code__c": domainCodeC == null ? null : domainCodeC,
        "Subject__c": subjectC == null ? null : subjectC,
        "Title__c": titleC,
        "Id": id == null ? null : id,
        "Grade__c": gradeC,
        "Domain_Name__c": domainNameC,
        "Sub_Domain__c": subDomainC,
        "Sub_Sub_Domain__c": subSubDomainC,
        "Standard_and_Description__c": standardAndDescriptionC,
        "Subject_Name__c": subjectNameC,
      };
}
