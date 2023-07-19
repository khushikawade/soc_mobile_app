// To parse this JSON data, do
//
//     final studentPlusCourseWorkModel = studentPlusCourseWorkModelFromJson(jsonString);

import 'dart:convert';
import 'package:hive/hive.dart';
part 'student_plus_course_work_model.g.dart';

@HiveType(typeId: 51)
class StudentPlusCourseWorkModel {
  @HiveField(0)
  final String? courseId;
  @HiveField(1)
  final String? id;
  @HiveField(2)
  final String? title;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final String? state;
  @HiveField(5)
  final String? alternateLink;
  @HiveField(6)
  final DateTime? creationTime;
  @HiveField(7)
  final DateTime? updateTime;
  @HiveField(8)
  final int? maxPoints;
  @HiveField(9)
  final String? workType;
  @HiveField(10)
  final String? submissionModificationMode;
  @HiveField(11)
  final bool? associatedWithDeveloper;
  @HiveField(12)
  final String? creatorUserId;
  @HiveField(13)
  final List<StudentWorkSubmission>? studentWorkSubmission;
  @HiveField(14)
  final String? studentCourseUserId;

  StudentPlusCourseWorkModel({
    this.courseId,
    this.id,
    this.title,
    this.description,
    this.state,
    this.alternateLink,
    this.creationTime,
    this.updateTime,
    this.maxPoints,
    this.workType,
    this.submissionModificationMode,
    this.associatedWithDeveloper,
    this.creatorUserId,
    this.studentWorkSubmission,
    this.studentCourseUserId
  });

  factory StudentPlusCourseWorkModel.fromRawJson(String str) =>
      StudentPlusCourseWorkModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StudentPlusCourseWorkModel.fromJson(Map<String, dynamic> json) =>
      StudentPlusCourseWorkModel(
        courseId: json["courseId"],
        id: json["id"],
        title: json["title"],
        description: json["description"],
        state: json["state"],
        alternateLink: json["alternateLink"],
        creationTime: json["creationTime"] == null
            ? null
            : DateTime.parse(json["creationTime"]),
        updateTime: json["updateTime"] == null
            ? null
            : DateTime.parse(json["updateTime"]),
        maxPoints: json["maxPoints"],
        workType: json["workType"],
        submissionModificationMode: json["submissionModificationMode"],
        associatedWithDeveloper: json["associatedWithDeveloper"],
        creatorUserId: json["creatorUserId"],
        studentWorkSubmission: json["studentWorkSubmission"] == null
            ? []
            : List<StudentWorkSubmission>.from(json["studentWorkSubmission"]!
                .map((x) => StudentWorkSubmission.fromJson(x))),
                studentCourseUserId: null
      );

  Map<String, dynamic> toJson() => {
        "courseId": courseId,
        "id": id,
        "title": title,
        "description": description,
        "state": state,
        "alternateLink": alternateLink,
        "creationTime": creationTime?.toIso8601String(),
        "updateTime": updateTime?.toIso8601String(),
        "maxPoints": maxPoints,
        "workType": workType,
        "submissionModificationMode": submissionModificationMode,
        "associatedWithDeveloper": associatedWithDeveloper,
        "creatorUserId": creatorUserId,
        "studentWorkSubmission": studentWorkSubmission == null
            ? []
            : List<dynamic>.from(studentWorkSubmission!.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 53)
class StudentWorkSubmission {
  @HiveField(0)
  final String? courseId;
  @HiveField(1)
  final String? courseWorkId;
  @HiveField(2)
  final String? id;
  @HiveField(3)
  final String? userId;
  @HiveField(4)
  final DateTime? creationTime;
  @HiveField(5)
  final DateTime? updateTime;
  @HiveField(6)
  final String? state;
  @HiveField(7)
  final int? assignedGrade;
  @HiveField(8)
  final String? alternateLink;
  @HiveField(9)
  final String? courseWorkType;
  @HiveField(10)
  final AssignmentSubmission? assignmentSubmission;
  @HiveField(11)
  final bool? associatedWithDeveloper;

  StudentWorkSubmission({
    this.courseId,
    this.courseWorkId,
    this.id,
    this.userId,
    this.creationTime,
    this.updateTime,
    this.state,
    this.assignedGrade,
    this.alternateLink,
    this.courseWorkType,
    this.assignmentSubmission,
    this.associatedWithDeveloper,
  });

  factory StudentWorkSubmission.fromRawJson(String str) =>
      StudentWorkSubmission.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StudentWorkSubmission.fromJson(Map<String, dynamic> json) =>
      StudentWorkSubmission(
        courseId: json["courseId"],
        courseWorkId: json["courseWorkId"],
        id: json["id"],
        userId: json["userId"],
        creationTime: json["creationTime"] == null
            ? null
            : DateTime.parse(json["creationTime"]),
        updateTime: json["updateTime"] == null
            ? null
            : DateTime.parse(json["updateTime"]),
        state: json["state"],
        assignedGrade: json["assignedGrade"],
        alternateLink: json["alternateLink"],
        courseWorkType: json["courseWorkType"],
        assignmentSubmission: json["assignmentSubmission"] == null
            ? null
            : AssignmentSubmission.fromJson(json["assignmentSubmission"]),
        associatedWithDeveloper: json["associatedWithDeveloper"],
      );

  Map<String, dynamic> toJson() => {
        "courseId": courseId,
        "courseWorkId": courseWorkId,
        "id": id,
        "userId": userId,
        "creationTime": creationTime?.toIso8601String(),
        "updateTime": updateTime?.toIso8601String(),
        "state": state,
        "assignedGrade": assignedGrade,
        "alternateLink": alternateLink,
        "courseWorkType": courseWorkType,
        "assignmentSubmission": assignmentSubmission?.toJson(),
        "associatedWithDeveloper": associatedWithDeveloper,
      };
}

@HiveType(typeId: 46)
class AssignmentSubmission {
  @HiveField(0)
  final List<Attachment>? attachments;

  AssignmentSubmission({
    this.attachments,
  });

  factory AssignmentSubmission.fromRawJson(String str) =>
      AssignmentSubmission.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssignmentSubmission.fromJson(Map<String, dynamic> json) =>
      AssignmentSubmission(
        attachments: json["attachments"] == null
            ? []
            : List<Attachment>.from(
                json["attachments"]!.map((x) => Attachment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "attachments": attachments == null
            ? []
            : List<dynamic>.from(attachments!.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 47)
class Attachment {
  @HiveField(0)
  final Link? link;

  Attachment({
    this.link,
  });

  factory Attachment.fromRawJson(String str) =>
      Attachment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        link: json["link"] == null ? null : Link.fromJson(json["link"]),
      );

  Map<String, dynamic> toJson() => {
        "link": link?.toJson(),
      };
}

@HiveType(typeId: 52)
class Link {
  @HiveField(0)
  final String? url;
  @HiveField(1)
  final String? title;
  @HiveField(2)
  final String? thumbnailUrl;

  Link({
    this.url,
    this.title,
    this.thumbnailUrl,
  });

  factory Link.fromRawJson(String str) => Link.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        title: json["title"],
        thumbnailUrl: json["thumbnailUrl"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "title": title,
        "thumbnailUrl": thumbnailUrl,
      };
}
