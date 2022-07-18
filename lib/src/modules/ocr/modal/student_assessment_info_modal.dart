import 'dart:typed_data';

import 'package:hive/hive.dart';
part 'student_assessment_info_modal.g.dart';

@HiveType(typeId: 21)
class StudentAssessmentInfo {
  @HiveField(0)
  String? studentName;
  @HiveField(1)
  String? studentId;
  @HiveField(2)
  String? studentGrade;
  @HiveField(3) //pointsEarned
  String? pointpossible;
  @HiveField(4)
  String? grade;
  @HiveField(5)
  String? subject;
  @HiveField(6)
  String? learningStandard;
  @HiveField(7)
  String? subLearningStandard;
  @HiveField(8)
  String? scoringRubric;
  @HiveField(9)
  String? customRubricImage;
  @HiveField(10)
  String? assessmentImage;
  @HiveField(11)
  String? className;
  @HiveField(12)
  String? questionImgUrl;
  @HiveField(13)
  bool? isSavedOnDashBoard;
  @HiveField(14)
  String? assessmentImgPath;

  StudentAssessmentInfo(
      {this.studentName,
      this.studentId,
      this.studentGrade,
      this.pointpossible,
      this.grade,
      this.subject,
      this.learningStandard,
      this.subLearningStandard,
      this.scoringRubric,
      this.customRubricImage,
      this.assessmentImage,
      this.className,
      this.questionImgUrl,
      this.isSavedOnDashBoard,
      this.assessmentImgPath});

  factory StudentAssessmentInfo.fromJson(Map<String, dynamic> json) =>
      StudentAssessmentInfo(
          studentName: json['Name'] as String?,
          studentId: json['Id'] as String?,
          studentGrade: json['Points Earned'] as String?,
          pointpossible: json['Point Possible'] as String?,
          grade: json['Grade'] as String?,
          subject: json['Subject'] as String?,
          learningStandard: json['Learning Standard'] as String?,
          subLearningStandard:
              json['NY Next Generation Learning Standard'] as String?,
          scoringRubric: json['Scoring Rubric'] as String?,
          customRubricImage: json['Custom Rubric Image'] as String?,
          className: json['Class Name'] as String?,
          assessmentImage: json['Assessment Image'] as String?,
          questionImgUrl: json['Assessment Question Img'] as String?,
          isSavedOnDashBoard: json['Saved on Dashboard']);
}
