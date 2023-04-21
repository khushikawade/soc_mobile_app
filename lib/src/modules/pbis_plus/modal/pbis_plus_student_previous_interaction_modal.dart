// import 'package:hive/hive.dart';
// part 'pbis_plus_student_previous_interaction_modal.g.dart';

// @HiveType(typeId: 40)
// class PBISPlusStudentPreviousInteractionModal {
//   @HiveField(0)
//   String? schoolId;
//   @HiveField(1)
//   String? studentId;
//   @HiveField(2)
//   String? teacherEmail;
//   @HiveField(3)
//   int? engaged;
//   @HiveField(4)
//   int? niceWork;
//   @HiveField(5)
//   int? helpful;

//   PBISPlusStudentPreviousInteractionModal(
//       {this.schoolId,
//       this.studentId,
//       this.teacherEmail,
//       this.engaged,
//       this.niceWork,
//       this.helpful});

//   PBISPlusStudentPreviousInteractionModal.fromJson(Map<String, dynamic> json) {
//     schoolId = json['School_Id'] ?? '';
//     studentId = json['Student_Id'] ?? '';
//     teacherEmail = json['Teacher_Email'] ?? '';
//     engaged = json['Engaged'] ?? 0;
//     niceWork = json['Nice_Work'] ?? 0;
//     helpful = json['Helpful'] ?? 0;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['School_Id'] = this.schoolId;
//     data['Student_Id'] = this.studentId;
//     data['Teacher_Email'] = this.teacherEmail;
//     data['Engaged'] = this.engaged;
//     data['Nice_Work'] = this.niceWork;
//     data['Helpful'] = this.helpful;
//     return data;
//   }
// }