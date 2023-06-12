// To parse this JSON data, do
//
//     final StudentPlusWorkModel = StudentPlusWorkModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
part 'student_work_model.g.dart';

StudentPlusWorkModel StudentPlusWorkModelFromJson(String str) =>
    StudentPlusWorkModel.fromJson(json.decode(str));

String StudentPlusWorkModelToJson(StudentPlusWorkModel data) =>
    json.encode(data.toJson());

@HiveType(typeId: 32)
class StudentPlusWorkModel {
  StudentPlusWorkModel({
    this.assessmentId,
    this.nameC,
    this.rubricC,
    this.dateC,
    this.schoolC,
    this.teacherEmail,
    this.studentC,
    this.studentNameC,
    this.resultC,
    this.assessmentImageC,
    this.assessmentQueImageC,
    this.firstName,
    this.lastName,
    this.subjectC,
    this.assessmentType,
  });
  @HiveField(0)
  final String? assessmentId;
  @HiveField(1)
  final String? nameC;
  @HiveField(2)
  final String? rubricC;
  @HiveField(3)
  final String? dateC;
  @HiveField(4)
  final String? schoolC;
  @HiveField(5)
  final String? teacherEmail;
  @HiveField(6)
  final String? studentC;
  @HiveField(7)
  final String? studentNameC;
  @HiveField(8)
  final String? resultC;
  @HiveField(9)
  final String? assessmentImageC;
  @HiveField(10)
  final String? assessmentQueImageC;
  @HiveField(11)
  final String? firstName;
  @HiveField(12)
  final String? lastName;
  @HiveField(13)
  final String? subjectC;
  @HiveField(14)
  final String? assessmentType;

  factory StudentPlusWorkModel.fromJson(Map<String, dynamic> json) =>
      StudentPlusWorkModel(
          assessmentId: json["Assessment_Id"],
          nameC: json["Name__c"],
          rubricC: json["Rubric__c"],
          dateC: json["Date__c"] == null ? null : json["Date__c"],
          schoolC: json["School__c"],
          teacherEmail: json["Teacher_Email"],
          studentC: json["Student__c"],
          studentNameC: json["Student_Name__c"],
          resultC: json["Result__c"],
          assessmentImageC: json["Assessment_Image__c"],
          assessmentQueImageC: json["Assessment_Que_Image__c"],
          firstName: json["FirstName"],
          lastName: json["LastName"],
          subjectC: json["Subject__c"],
          assessmentType: json["Assessment_Type"]);

  Map<String, dynamic> toJson() => {
        "Assessment_Id": assessmentId,
        "Name__c": nameC,
        "Rubric__c": rubricC,
        "Date__c": dateC,
        "School__c": schoolC,
        "Teacher_Email": teacherEmail,
        "Student__c": studentC,
        "Student_Name__c": studentNameC,
        "Result__c": resultC,
        "Assessment_Image__c": assessmentImageC,
        "Assessment_Que_Image__c": assessmentQueImageC,
        "FirstName": firstName,
        "LastName": lastName,
        "Subject__c": subjectC,
        "Assessment_Type": assessmentType
      };
}
