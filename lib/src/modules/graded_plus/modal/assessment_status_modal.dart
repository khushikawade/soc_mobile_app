class AssessmentStatusModel {
  bool? excelSheetPrepared;
  bool? slidePrepared;
  bool? saveAssessmentResultToDashboard;
  bool googleClassRoomIsUpdated;
  AssessmentStatusModel(
      {required this.excelSheetPrepared,
      required this.slidePrepared,
      required this.saveAssessmentResultToDashboard,
      required this.googleClassRoomIsUpdated});
}
