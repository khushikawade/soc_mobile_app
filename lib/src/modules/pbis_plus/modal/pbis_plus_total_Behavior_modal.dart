import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';

class PBISPlusTotalBehaviorModal {
  String? schoolAppC;
  String? studentId;
  String? teacherEmail;
  String? studentEmail;
  List<BehaviorList>? behaviorList;
  String? createdAt;
  String? classroomCourseId;

  PBISPlusTotalBehaviorModal(
      {this.schoolAppC,
      this.studentId,
      this.teacherEmail,
      this.studentEmail,
      this.behaviorList,
      this.createdAt});

  PBISPlusTotalBehaviorModal.fromJson(Map<String, dynamic> json) {
    schoolAppC = json['School_App__c'] ?? '';
    studentId = json['Student_Id'] ?? '';
    teacherEmail = json['Teacher_Email'] ?? '';
    studentEmail = json['Student_Email'] ?? '';
    if (json['BehaviorList'] != null) {
      behaviorList = <BehaviorList>[];
      json['BehaviorList'].forEach((v) {
        behaviorList!.add(new BehaviorList.fromJson(v));
      });
    }
    createdAt = json['CreatedAt'] ?? '';
    classroomCourseId = json['Classroom_Course_Id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['School_App__c'] = this.schoolAppC;
    data['Student_Id'] = this.studentId;
    data['Teacher_Email'] = this.teacherEmail;
    data['Student_Email'] = this.studentEmail;
    if (this.behaviorList != null) {
      data['BehaviorList'] = this.behaviorList!.map((v) => v.toJson()).toList();
    }
    data['CreatedAt'] = this.createdAt;
    data['Classroom_Course_Id'] = this.classroomCourseId;

    return data;
  }
}
