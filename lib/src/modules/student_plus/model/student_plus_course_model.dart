// To parse this JSON data, do
//
//     final studentPlusCourseModel = studentPlusCourseModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
part 'student_plus_course_model.g.dart';

@HiveType(typeId: 43)
class StudentPlusCourseModel {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String? descriptionHeading;
  @HiveField(3)
  final String? ownerId;
  @HiveField(4)
  final DateTime? creationTime;
  @HiveField(5)
  final DateTime? updateTime;
  @HiveField(6)
  final String? enrollmentCode;
  @HiveField(7)
  final String? courseState;
  @HiveField(8)
  final String? alternateLink;
  @HiveField(9)
  final String? teacherGroupEmail;
  @HiveField(10)
  final String? courseGroupEmail;
  @HiveField(11)
  final TeacherFolder? teacherFolder;
  @HiveField(12)
  final bool? guardiansEnabled;
  @HiveField(13)
  final String? calendarId;
  @HiveField(14)
  final String? section;
  @HiveField(15)
  final String? room;
  final GradebookSettings? gradebookSettings;

  StudentPlusCourseModel(
      {this.id,
      this.name,
      this.descriptionHeading,
      this.ownerId,
      this.creationTime,
      this.updateTime,
      this.enrollmentCode,
      this.courseState,
      this.alternateLink,
      this.teacherGroupEmail,
      this.courseGroupEmail,
      this.teacherFolder,
      this.guardiansEnabled,
      this.calendarId,
      this.gradebookSettings,
      this.room,
      this.section});

  factory StudentPlusCourseModel.fromRawJson(String str) =>
      StudentPlusCourseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StudentPlusCourseModel.fromJson(Map<String, dynamic> json) =>
      StudentPlusCourseModel(
        id: json["id"],
        name: json["name"],
        section: json["section"],
        descriptionHeading: json["descriptionHeading"],
        room: json["room"],
        ownerId: json["ownerId"],
        creationTime: json["creationTime"] == null
            ? null
            : DateTime.parse(json["creationTime"]),
        updateTime: json["updateTime"] == null
            ? null
            : DateTime.parse(json["updateTime"]),
        enrollmentCode: json["enrollmentCode"],
        courseState: json["courseState"],
        alternateLink: json["alternateLink"],
        teacherGroupEmail: json["teacherGroupEmail"],
        courseGroupEmail: json["courseGroupEmail"],
        teacherFolder: json["teacherFolder"] == null
            ? null
            : TeacherFolder.fromJson(json["teacherFolder"]),
        guardiansEnabled: json["guardiansEnabled"],
        calendarId: json["calendarId"],
        gradebookSettings: json["gradebookSettings"] == null
            ? null
            : GradebookSettings.fromJson(json["gradebookSettings"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "section": section,
        "descriptionHeading": descriptionHeading,
        "room": room,
        "ownerId": ownerId,
        "creationTime": creationTime?.toIso8601String(),
        "updateTime": updateTime?.toIso8601String(),
        "enrollmentCode": enrollmentCode,
        "courseState": courseState,
        "alternateLink": alternateLink,
        "teacherGroupEmail": teacherGroupEmail,
        "courseGroupEmail": courseGroupEmail,
        "teacherFolder": teacherFolder?.toJson(),
        "guardiansEnabled": guardiansEnabled,
        "calendarId": calendarId,
        "gradebookSettings": gradebookSettings?.toJson(),
      };
}

class GradebookSettings {
  final String? calculationType;
  final String? displaySetting;

  GradebookSettings({
    this.calculationType,
    this.displaySetting,
  });

  factory GradebookSettings.fromRawJson(String str) =>
      GradebookSettings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GradebookSettings.fromJson(Map<String, dynamic> json) =>
      GradebookSettings(
        calculationType: json["calculationType"],
        displaySetting: json["displaySetting"],
      );

  Map<String, dynamic> toJson() => {
        "calculationType": calculationType,
        "displaySetting": displaySetting,
      };
}

class TeacherFolder {
  final String? id;
  final String? title;
  final String? alternateLink;

  TeacherFolder({
    this.id,
    this.title,
    this.alternateLink,
  });

  factory TeacherFolder.fromRawJson(String str) =>
      TeacherFolder.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TeacherFolder.fromJson(Map<String, dynamic> json) => TeacherFolder(
        id: json["id"],
        title: json["title"],
        alternateLink: json["alternateLink"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "alternateLink": alternateLink,
      };
}
