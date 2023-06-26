import 'package:hive/hive.dart';
part 'pbis_plus_total_interaction_modal.g.dart';

@HiveType(typeId: 41)
class PBISPlusTotalInteractionModal {
  @HiveField(0)
  String? schoolId;
  @HiveField(1)
  String? studentId;
  @HiveField(2)
  String? teacherEmail;
  @HiveField(3)
  int? engaged;
  @HiveField(4)
  int? niceWork;
  @HiveField(5)
  int? helpful;
  @HiveField(6)
  String? studentEmail;
  @HiveField(7)
  String? createdAt;
  @HiveField(8)
  String? classroomCourseId;
  @HiveField(9)
  int? participation;
  @HiveField(10)
  int? collaboration;
  @HiveField(11)
  int? listening;
  PBISPlusTotalInteractionModal(
      {this.schoolId,
      this.studentId,
      this.teacherEmail,
      this.engaged,
      this.niceWork,
      this.helpful,
      this.createdAt,
      this.studentEmail,
      this.participation,
      this.collaboration,
      this.listening});

  PBISPlusTotalInteractionModal.fromJson(Map<String, dynamic> json) {
    schoolId = json['School_Id'] ?? '';
    studentId = json['Student_Id'] ?? '';
    teacherEmail = json['Teacher_Email'] ?? '';
    engaged = json['Engaged'] ?? 0;
    niceWork = json['Nice_Work'] ?? 0;
    helpful = json['Helpful'] ?? 0;
    studentEmail = json["Student_Email"];
    createdAt = json["CreatedAt"];
    classroomCourseId = json["Classroom_Course_Id"];
    participation = json['Participation'] ?? 0;
    collaboration = json['Collaboration'] ?? 0;
    listening = json['Listening'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['School_Id'] = this.schoolId;
    data['Student_Id'] = this.studentId;
    data['Teacher_Email'] = this.teacherEmail;
    data['Engaged'] = this.engaged;
    data['Nice_Work'] = this.niceWork;
    data['Helpful'] = this.helpful;
    data['Student_Email'] = this.studentEmail;
    data['CreatedAt'] = this.createdAt;
    data["Classroom_Course_Id"] = this.classroomCourseId;
    data["Participation"] = this.participation;
    data["Collaboration"] = this.collaboration;
    data["Listening"] = this.listening;
    return data;
  }
}
