// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

class SubjectList {
  SubjectList({
    this.subjectNameC,
    this.id,
  });

  String? subjectNameC;

  String? id;

  factory SubjectList.fromRawJson(String str) => SubjectList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubjectList.fromJson(Map<String, dynamic> json) => SubjectList(
        subjectNameC:
            json["Subject_Name__c"] == null ? null : json["Subject_Name__c"],
        id: json["Id"] == null ? null : json["Id"],
      );

  Map<String, dynamic> toJson() => {
        "Subject_Name__c": subjectNameC == null ? null : subjectNameC,
        "Id": id == null ? null : id,
      };
}
