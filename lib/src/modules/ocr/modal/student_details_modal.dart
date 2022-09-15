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
        firstNameC:
            json["First_Name__c"] == null ? null : json["First_Name__c"],
        lastNameC: json["last_Name__c"] == null ? null : json["last_Name__c"],
      );

  Map<String, dynamic> toJson() => {
        "First_Name__c": firstNameC == null ? null : firstNameC,
        "last_Name__c": lastNameC == null ? null : lastNameC,
      };
}
