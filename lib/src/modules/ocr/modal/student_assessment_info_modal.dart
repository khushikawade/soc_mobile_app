class StudentAssessmentInfo {
  String? studentName;
  String? studentId;
  String? studentGrade;
  String? pointpossible;

  StudentAssessmentInfo({
    this.studentName,
    this.studentId,
    this.studentGrade,
    this.pointpossible,
  });

  factory StudentAssessmentInfo.fromJson(Map<String, dynamic> json) =>
      StudentAssessmentInfo(
          studentName: json['Name'] as String?,
          studentId: json['Name'] as String?,
          studentGrade: json['PointsEarned'] as String?,
          pointpossible: json['PointPossible'] as String?);
}
