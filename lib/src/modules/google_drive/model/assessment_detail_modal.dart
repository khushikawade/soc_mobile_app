import 'dart:convert';

import 'package:hive/hive.dart';
part 'assessment_detail_modal.g.dart';

@HiveType(typeId: 17)
class AssessmentDetails {
  AssessmentDetails(
      {this.dateC,
      this.nameC,
      this.rubricC,
      this.schoolC,
      this.schoolYearC,
      this.standardC,
      this.subjectC,
      this.teacherC,
      this.typeC,
      this.assessmentId,
      this.id,
      this.googleFileId,
      this.sessionId,
      this.teacherEmail,
      this.teacherContactId,this.createdAsPremium,this.assessmentType});
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? dateC;
  @HiveField(2)
  String? nameC;
  @HiveField(3)
  String? rubricC;
  @HiveField(4)
  String? schoolC;
  @HiveField(5)
  String? schoolYearC;
  @HiveField(6)
  String? standardC;
  @HiveField(7)
  String? subjectC;
  @HiveField(8)
  String? teacherC;
  @HiveField(9)
  String? typeC;
  @HiveField(10)
  String? assessmentId;
  @HiveField(11)
  String? id;
  @HiveField(12)
  String? googleFileId;
  @HiveField(13)
  String? sessionId;
  @HiveField(14)
  String? teacherEmail;
  @HiveField(15)
  String? teacherContactId;
  @HiveField(16)
  String? createdAsPremium;
  @HiveField(17)
  String? assessmentType;
  




  factory AssessmentDetails.fromRawJson(String str) =>
      AssessmentDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssessmentDetails.fromJson(Map<String, dynamic> json) => AssessmentDetails(
        dateC: json["Date__c"] == null ? null : json["Date__c"],
        nameC: json["Name__c"] == null ? null : json["Name__c"],
        rubricC: json["Rubric__c"] == null ? null : json["Rubric__c"],
        schoolC: json["School__c"] == null ? null : json["School__c"],
        schoolYearC:
            json["School_year__c"] == null ? null : json["School_year__c"],
        standardC: json["Standard__c"],
        subjectC: json["Subject__c"] == null ? null : json["Subject__c"],
        teacherC: json["Teacher__c"],
        typeC: json["Type__c"],
        assessmentId: json["Assessment_Id"],
        id: json["Id"],
        googleFileId: json["Google_File_Id"],
        sessionId: json["Session_Id"],
        teacherContactId: json["Teacher_Contact_Id"],
        teacherEmail: json["Teacher_Email"],
        createdAsPremium:json["Created_As_Premium"] ?? "false", 
        assessmentType: json["Assessment_Type"] ?? 'Constructed Response',
      );

  Map<String, dynamic> toJson() => {
        "Date__c": dateC == null ? null : dateC,
        "Name__c": nameC == null ? null : nameC,
        "Rubric__c": rubricC == null ? null : rubricC,
        "School__c": schoolC == null ? null : schoolC,
        "School_year__c": schoolYearC == null ? null : schoolYearC,
        "Standard__c": standardC,
        "Subject__c": subjectC == null ? null : subjectC,
        "Teacher__c": teacherC,
        "Type__c": typeC,
        "Assessment_Id": assessmentId,
        "Id": id,
        "Google_File_Id": googleFileId,
        "Session_Id": sessionId,
        "Teacher_Contact_Id": teacherContactId,
        "Teacher_Email": teacherEmail,
        "Created_As_Premium":createdAsPremium,
        "Assessment_Type":assessmentType
      };
}
