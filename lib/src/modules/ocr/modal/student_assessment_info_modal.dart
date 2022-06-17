class StudentAssessmentInfo {
  String? studentName;
  String? studentId;
  String? studentGrade; //pointsEarned
  String? pointpossible;
  String? grade;
  String? subject;
  String? learningStandard;
  String? subLearningStandard;
  String? scoringRubric;
  String? customRubricImage;
  String? assessmentImage;
  String? className;
  String? questionImgUrl;
  String? isSavedOnDashBoard;
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
      this.isSavedOnDashBoard});

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
