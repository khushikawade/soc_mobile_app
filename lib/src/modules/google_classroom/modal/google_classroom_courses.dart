import 'package:Soc/src/modules/google_classroom/modal/classroom_student_list.dart';
import 'package:hive/hive.dart';
part 'google_classroom_courses.g.dart';

@HiveType(typeId: 9)
class GoogleClassroomCourses {
  @HiveField(0)
  String? courseId;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? section;
  @HiveField(3)
  String? descriptionHeading;
  @HiveField(4)
  String? room;
  @HiveField(5)
  List? studentList = [];
  @HiveField(6)
  String? enrollmentCode;

  GoogleClassroomCourses(
      {this.courseId,
      this.name,
      this.section,
      this.descriptionHeading,
      this.room,
      this.studentList,
      this.enrollmentCode});

  factory GoogleClassroomCourses.fromJson(Map<dynamic, dynamic> json) =>
      GoogleClassroomCourses(
        courseId: json["id"] == null ? '' : json["id"],
        name: json["name"] == null ? '' : json["name"],
        section: json["section"] == '' ? null : json["section"],
        descriptionHeading: json["descriptionHeading"] == null
            ? ''
            : json["descriptionHeading"],
        room: json["room"] == null ? '' : json["room"],
        enrollmentCode: json["enrollmentCode"],
        studentList: json["students"] ?? [],
      );

  Map<String, dynamic> toJson() => {
        "id": courseId == null ? null : courseId,
        "name": name == null ? null : name,
        "section": section == null ? null : section,
        "descriptionHeading":
            descriptionHeading == null ? null : descriptionHeading,
        "room": room == null ? null : room,
        "enrollmentCode": enrollmentCode,
        "students": studentList,
      };
}
