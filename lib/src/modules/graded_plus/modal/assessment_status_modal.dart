class AssessmentStatusModel {
  bool excelSheetPrepared;
  bool slidePrepared;
  bool saveAssessmentResultToDashboard;
  bool saveGoogleClassroom;

  AssessmentStatusModel({
    required this.excelSheetPrepared,
    required this.slidePrepared,
    required this.saveAssessmentResultToDashboard,
    required this.saveGoogleClassroom,
  });
}
