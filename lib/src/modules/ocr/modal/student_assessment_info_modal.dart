import 'dart:typed_data';

import 'package:Soc/src/overrides.dart';
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
  String? pointPossible;
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
  @HiveField(15)
  String?
      slideObjectId; //slides object page ids to update the images , tables and text on slides
  @HiveField(16)
  // String? googleSlidePresentationLink;
  String? answerKey;
  @HiveField(17)
  String? studentResponseKey;
  @HiveField(18)
  String? googleSlidePresentationURL;
  @HiveField(19)
  String? uniqueId;
  @HiveField(20)
  String? isRubricChanged;
  @HiveField(21)
  String? standardDescription;
  @HiveField(22)
  String?
      googleClassRoomStudentProfileId; // student profile ids to update the classroom
  @HiveField(23)
  bool
      isgoogleClassRoomStudentProfileUpdated; // Flag indicating whether the student's profile has been updated in Google Classroom or not. True if updated, false otherwise.
  @HiveField(24)
  bool
      isSlideObjUpdated; // Flag indicating whether the student's profile has been updated in Google slides or not. True if updated, false otherwise.
  @HiveField(25)
  String?
      slideTableObjId; //slides table ids for update and edit the student records
  StudentAssessmentInfo(
      {this.studentName,
      this.studentId,
      this.studentGrade,
      this.pointPossible,
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
      this.assessmentImgPath,
      this.slideObjectId,
      this.googleSlidePresentationURL,
      this.answerKey,
      this.standardDescription,
      //this.presentationURL,
      this.studentResponseKey,
      this.isRubricChanged,
      this.uniqueId,
      this.googleClassRoomStudentProfileId,
      this.isgoogleClassRoomStudentProfileUpdated = false,
      this.isSlideObjUpdated = false,
      this.slideTableObjId});

  factory StudentAssessmentInfo.fromJson(Map<String, dynamic> json) =>
      StudentAssessmentInfo(
          studentName: json['Name'] as String?,
          studentId: Overrides.STANDALONE_GRADED_APP == true
              ? json['Email Id'] as String?
              : json['Id'] as String?,
          studentGrade: json['Points Earned'] as String?,
          pointPossible: json['Point Possible'] as String?,
          grade: json['Grade'] as String?,
          subject: json['Subject'] as String?,
          learningStandard: json['Learning Standard'] as String?,
          subLearningStandard:
              json['NY Next Generation Learning Standard'] as String?,
          scoringRubric: json['Scoring Rubric'] as String?,
          customRubricImage: json['Custom Rubric Image'] as String?,
          className: json['Class Name'] as String?,
          assessmentImage: Overrides.STANDALONE_GRADED_APP == true
              ? json['Student Work Image'] as String?
              : json['Assessment Image'] as String?,
          questionImgUrl: Overrides.STANDALONE_GRADED_APP == true
              ? json['Assessment Image'] as String?
              : json['Assessment Question Img'] as String?,
          isSavedOnDashBoard: json['Saved on Dashboard'],
          answerKey: json['Answer Key'],
          googleSlidePresentationURL: json['Presentation URL'],
          studentResponseKey: json['Student Response Key'],
          standardDescription: json['Standard Description'],
          isSlideObjUpdated: true);
}
