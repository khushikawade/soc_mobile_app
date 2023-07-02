// To parse this JSON data, do
//
//     final pbisPlusAddNotes = pbisPlusAddNotesFromJson(jsonString);

import 'dart:convert';

PbisPlusAddNotes pbisPlusAddNotesFromJson(String str) => PbisPlusAddNotes.fromJson(json.decode(str));

String pbisPlusAddNotesToJson(PbisPlusAddNotes data) => json.encode(data.toJson());

class PbisPlusAddNotes {
    int id;
    String studentC;
    String teacherC;
    String dbnC;
    String schoolAppC;
    String studentName;
    String studentEmail;
    String notes;
    DateTime createdAt;
    DateTime updatedAt;

    PbisPlusAddNotes({
        required this.id,
        required this.studentC,
        required this.teacherC,
        required this.dbnC,
        required this.schoolAppC,
        required this.studentName,
        required this.studentEmail,
        required this.notes,
        required this.createdAt,
        required this.updatedAt,
    });

    factory PbisPlusAddNotes.fromJson(Map<String, dynamic> json) => PbisPlusAddNotes(
        id: json["Id"],
        studentC: json["Student__c"],
        teacherC: json["Teacher__c"],
        dbnC: json["DBN__c"],
        schoolAppC: json["School_App__c"],
        studentName: json["Student_Name"],
        studentEmail: json["Student_Email"],
        notes: json["Notes"],
        createdAt: DateTime.parse(json["CreatedAt"]),
        updatedAt: DateTime.parse(json["UpdatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "Student__c": studentC,
        "Teacher__c": teacherC,
        "DBN__c": dbnC,
        "School_App__c": schoolAppC,
        "Student_Name": studentName,
        "Student_Email": studentEmail,
        "Notes": notes,
        "CreatedAt": createdAt.toIso8601String(),
        "UpdatedAt": updatedAt.toIso8601String(),
    };
}
