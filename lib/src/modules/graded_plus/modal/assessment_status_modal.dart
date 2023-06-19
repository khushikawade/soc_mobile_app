class LoadingStatusModel {
  bool? excelSheetPrepared;
  bool? slidePrepared;
  bool? saveAssessmentResultToDashboard;
  bool googleClassroomPrepared;
  LoadingStatusModel(
      {required this.excelSheetPrepared,
      required this.slidePrepared,
      required this.saveAssessmentResultToDashboard,
      required this.googleClassroomPrepared});
}
