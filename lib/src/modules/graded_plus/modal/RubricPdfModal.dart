import 'dart:io';

import 'package:hive/hive.dart';
part 'RubricPdfModal.g.dart';

@HiveType(typeId: 27)
class RubricPdfModal {
  RubricPdfModal({
    this.id,
    this.createdById,
    this.name,
    this.lastModifiedById,
    this.ownerId,
    this.rubricPdfC,
    this.subjectC,
    this.titleC,
    this.usedInC,
  });
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? createdById;
  @HiveField(2)
  String? name;
  @HiveField(3)
  String? lastModifiedById;
  @HiveField(4)
  String? ownerId;
  @HiveField(5)
  String? rubricPdfC;
  @HiveField(6)
  String? subjectC;
  @HiveField(7)
  String? titleC;
  @HiveField(8)
  String? usedInC;

  factory RubricPdfModal.fromJson(Map<String, dynamic> json) => RubricPdfModal(
        id: json["Id"],
        createdById: json["CreatedById"],
        name: json["Name"],
        lastModifiedById: json["LastModifiedById"],
        ownerId: json["OwnerId"],
        rubricPdfC: json["Rubric_PDF__c"],
        subjectC: json["Subject__c"],
        titleC: json["Title__c"],
        usedInC: json["Used_in__c"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "CreatedById": createdById,
        "Name": name,
        "LastModifiedById": lastModifiedById,
        "OwnerId": ownerId,
        "Rubric_PDF__c": rubricPdfC,
        "Subject__c": subjectC,
        "Title__c": titleC,
        "Used_in__c": usedInC,
      };
}
