// To parse this JSON data, do
//
//     final studentPlusGradeModel = studentPlusGradeModelFromJson(jsonString);

import 'dart:convert';
import 'package:hive/hive.dart';
part 'student_plus_grades_model.g.dart';

StudentPlusGradeModel studentPlusGradeModelFromJson(String str) =>
    StudentPlusGradeModel.fromJson(json.decode(str));

String studentPlusGradeModelToJson(StudentPlusGradeModel data) =>
    json.encode(data.toJson());

@HiveType(typeId: 42)
class StudentPlusGradeModel {
  StudentPlusGradeModel({
    this.id,
    this.academicYearC,
    this.dbnC,
    this.gradeC,
    this.markTypeC,
    this.markingPeriodC,
    this.officialClassC,
    this.osisC,
    this.ownerId,
    this.resultC,
    this.schoolSubjectC,
    this.sectionIdC,
    this.studentC,
    this.studentNameC,
    this.subjectC,
    this.name,
  });
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? academicYearC;
  @HiveField(2)
  final String? dbnC;
  @HiveField(3)
  final String? gradeC;
  @HiveField(4)
  final String? markTypeC;
  @HiveField(5)
  final String? markingPeriodC;
  @HiveField(6)
  final String? officialClassC;
  @HiveField(7)
  final String? osisC;
  @HiveField(8)
  final String? ownerId;
  @HiveField(9)
  final String? resultC;
  @HiveField(10)
  final String? schoolSubjectC;
  @HiveField(11)
  final String? sectionIdC;
  @HiveField(12)
  final String? studentC;
  @HiveField(13)
  final String? studentNameC;
  @HiveField(14)
  final String? subjectC;
  @HiveField(15)
  final String? name;

  factory StudentPlusGradeModel.fromJson(Map<String, dynamic> json) =>
      StudentPlusGradeModel(
        id: json["Id"],
        academicYearC: json["Academic_year__c"],
        dbnC: json["DBN__c"],
        gradeC: json["Grade__c"],
        markTypeC: json["Mark_Type__c"],
        markingPeriodC: json["Marking_Period__c"],
        officialClassC: json["Official_Class__c"],
        osisC: json["OSIS__c"],
        ownerId: json["OwnerId"],
        resultC: json["Result__c"],
        schoolSubjectC: json["School_Subject__c"],
        sectionIdC: json["Section_ID__c"],
        studentC: json["Student__c"],
        studentNameC: json["Student_Name__c"],
        subjectC: json["Subject__c"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Academic_year__c": academicYearC,
        "DBN__c": dbnC,
        "Grade__c": gradeC,
        "Mark_Type__c": markTypeC,
        "Marking_Period__c": markingPeriodC,
        "Official_Class__c": officialClassC,
        "OSIS__c": osisC,
        "OwnerId": ownerId,
        "Result__c": resultC,
        "School_Subject__c": schoolSubjectC,
        "Section_ID__c": sectionIdC,
        "Student__c": studentC,
        "Student_Name__c": studentNameC,
        "Subject__c": subjectC,
        "Name": name,
      };
}
