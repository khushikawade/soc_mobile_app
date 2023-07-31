import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:hive/hive.dart';
part 'pbis_plus_total_Behavior_modal.g.dart';

@HiveType(typeId: 59)
class PBISPlusTotalBehaviorModal {
  @HiveField(0)
  String? schoolAppC;
  @HiveField(1)
  String? studentId;
  @HiveField(2)
  String? teacherEmail;
  @HiveField(3)
  String? studentEmail;
  @HiveField(4)
  List<BehaviorList>? behaviorList;
  @HiveField(5)
  String? createdAt;
  @HiveField(6)
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
    behaviorList = <BehaviorList>[];
    if (json['BehaviorList'] != null) {
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
