// To parse this JSON data, do
//
//     final studentRegentsModel = studentRegentsModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
part 'student_plus_regents_model.g.dart';

@HiveType(typeId: 58)
class StudentRegentsModel {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? academicYearC;
  @HiveField(2)
  final String? createdById;
  @HiveField(3)
  final String? examC;
  @HiveField(4)
  final String? lastModifiedById;
  @HiveField(5)
  final String? osisC;
  @HiveField(6)
  final String? ownerId;
  @HiveField(7)
  final String? name;
  @HiveField(8)
  final String? resultC;
  @HiveField(9)
  final String? studentC;
  @HiveField(10)
  final String? createdAt;
  @HiveField(11)
  final String? updatedAt;

  StudentRegentsModel({
    this.id,
    this.academicYearC,
    this.createdById,
    this.examC,
    this.lastModifiedById,
    this.osisC,
    this.ownerId,
    this.name,
    this.resultC,
    this.studentC,
    this.createdAt,
    this.updatedAt,
  });

  factory StudentRegentsModel.fromRawJson(String str) =>
      StudentRegentsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StudentRegentsModel.fromJson(Map<String, dynamic> json) =>
      StudentRegentsModel(
        id: json["Id"],
        academicYearC: json["Academic_Year__c"],
        createdById: json["CreatedById"],
        examC: json["Exam__c"],
        lastModifiedById: json["LastModifiedById"],
        osisC: json["OSIS__c"],
        ownerId: json["OwnerId"],
        name: json["Name"],
        resultC: json["Result__c"],
        studentC: json["Student__c"],
        createdAt: json["CreatedAt"],
        updatedAt: json["UpdatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Academic_Year__c": academicYearC,
        "CreatedById": createdById,
        "Exam__c": examC,
        "LastModifiedById": lastModifiedById,
        "OSIS__c": osisC,
        "OwnerId": ownerId,
        "Name": name,
        "Result__c": resultC,
        "Student__c": studentC,
        "CreatedAt": createdAt,
        "UpdatedAt": updatedAt,
      };
}
