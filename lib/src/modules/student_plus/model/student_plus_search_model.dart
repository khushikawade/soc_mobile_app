// To parse this JSON data, do // //
//final studentPlusSearchModel = studentPlusSearchModelFromJson(jsonString);
import 'dart:convert';
import 'package:hive/hive.dart';
part 'student_plus_search_model.g.dart';

StudentPlusSearchModel studentPlusSearchModelFromJson(String str) =>
    StudentPlusSearchModel.fromJson(json.decode(str));
String studentPlusSearchModelToJson(StudentPlusSearchModel data) =>
    json.encode(data.toJson());

@HiveType(typeId: 39)
class StudentPlusSearchModel {
  StudentPlusSearchModel({
    this.id,
    this.firstNameC,
    this.lastNameC,
    this.classC,
  });
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? firstNameC;
  @HiveField(2)
  final String? lastNameC;
  @HiveField(3)
  final String? classC;
  factory StudentPlusSearchModel.fromJson(Map<String, dynamic> json) =>
      StudentPlusSearchModel(
        id: json["Id"],
        firstNameC: json["First_Name__c"],
        lastNameC: json["last_Name__c"],
        classC: json["Class__c"],
      );
  Map<String, dynamic> toJson() => {
        "Id": id,
        "First_Name__c": firstNameC,
        "last_Name__c": lastNameC,
        "Class__c": classC,
      };
}
