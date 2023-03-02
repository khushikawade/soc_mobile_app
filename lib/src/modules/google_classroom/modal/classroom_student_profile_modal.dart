class ClassRoomStudentProfile {
  String? studentId;
  String? studentAssessmentImage;
  int? earnedPoint;

  ClassRoomStudentProfile(
      {required this.studentId,
      required this.studentAssessmentImage,
      required this.earnedPoint,
      String? id});

  ClassRoomStudentProfile.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];

    studentAssessmentImage = json['studentAssessmentImage'];
    earnedPoint = json['EarnedPoint'];
  }

  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        'studentAssessmentImage': studentAssessmentImage,
        'EarnedPoint': earnedPoint,
      };

  Map<String, dynamic> editStudentInfotoJson() => {
        'studentId': studentId,
        // 'studentAssessmentImage': studentAssessmentImage,
        'EarnedPoint': earnedPoint,
      };
}
