import 'package:hive/hive.dart';
part 'pbis_plus_total_behaviour_modal.g.dart';

@HiveType(typeId: 55)
class PBISPlusTotalBehaviourModal {
  @HiveField(0)
  String? schoolId;
  @HiveField(1)
  String? studentId;
  @HiveField(2)
  String? teacherEmail;
  @HiveField(3)
  String? studentEmail;
  @HiveField(4)
  List<InteractionCounts>? interactionCounts;
  @HiveField(5)
  String? createdAt;

  PBISPlusTotalBehaviourModal(
      {this.schoolId,
      this.studentId,
      this.teacherEmail,
      this.studentEmail,
      this.interactionCounts,
      this.createdAt});

  PBISPlusTotalBehaviourModal.fromJson(Map<String, dynamic> json) {
    schoolId = json['School_Id'] ?? '';
    studentId = json['Student_Id'] ?? '';
    teacherEmail = json['Teacher_Email'] ?? '';
    studentEmail = json['Student_Email'] ?? '';
    if (json['Interaction_Counts'] != null) {
      interactionCounts = <InteractionCounts>[];
      json['Interaction_Counts'].forEach((v) {
        interactionCounts!.add(new InteractionCounts.fromJson(v));
      });
    }
    createdAt = json['CreatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['School_Id'] = this.schoolId;
    data['Student_Id'] = this.studentId;
    data['Teacher_Email'] = this.teacherEmail;
    data['Student_Email'] = this.studentEmail;
    if (this.interactionCounts != null) {
      data['Interaction_Counts'] =
          this.interactionCounts!.map((v) => v.toJson()).toList();
    }
    data['CreatedAt'] = this.createdAt;
    return data;
  }
}

@HiveType(typeId: 56)
class InteractionCounts {
  @HiveField(0)
  String? behaviourId;
  @HiveField(1)
  int? behaviorCount;

  InteractionCounts({this.behaviourId, this.behaviorCount});

  InteractionCounts.fromJson(Map<String, dynamic> json) {
    behaviourId = json['Behaviour_Id'] ?? '';
    behaviorCount = json['Behavior_Count'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Behaviour_Id'] = this.behaviourId;
    data['Behavior_Count'] = this.behaviorCount;
    return data;
  }
}
