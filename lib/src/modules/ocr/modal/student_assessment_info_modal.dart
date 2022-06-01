class StudentAssessmentInfo {
  String? studentName;
  String? studentId;
  String? studentGrade;
  String? pointpossible;
  String? grade;
  String? subject;
  String? learningStandard;
  String? subLearningStandard;
  String? scoringRubric;
  StudentAssessmentInfo(
      {this.studentName,
      this.studentId,
      this.studentGrade,
      this.pointpossible,
      this.grade,
      this.subject,
      this.learningStandard,
      this.subLearningStandard,
      this.scoringRubric});

  factory StudentAssessmentInfo.fromJson(Map<String, dynamic> json) =>
      StudentAssessmentInfo(
        studentName: json['Name'] as String?,
        studentId: json['Id'] as String?,
        studentGrade: json['PointsEarned'] as String?,
        pointpossible: json['PointPossible'] as String?,
        grade: json['Grade'] as String,
        subject: json['Subject'] as String,
        learningStandard: json['Learning Standard'] as String,
        subLearningStandard: json['Sub Learning Standard'] as String,
        scoringRubric: json['Scoring Rubric'] as String,
      );
}
