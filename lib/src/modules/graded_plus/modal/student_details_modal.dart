// To parse this JSON data, do
//
//     final studentDetails = studentDetailsFromJson(jsonString);

import 'dart:convert';

class StudentDetails {
  StudentDetails({
    this.firstNameC,
    this.lastNameC,
  });

  String? firstNameC;
  String? lastNameC;

  factory StudentDetails.fromRawJson(String str) =>
      StudentDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StudentDetails.fromJson(Map<String, dynamic> json) => StudentDetails(
        firstNameC: json["First_Name__c"] ?? '' as String,
        lastNameC: json["last_Name__c"] ?? '' as String,
      );

  Map<String, dynamic> toJson() => {
        "First_Name__c": firstNameC == null ? null : firstNameC,
        "last_Name__c": lastNameC == null ? null : lastNameC,
      };
}
