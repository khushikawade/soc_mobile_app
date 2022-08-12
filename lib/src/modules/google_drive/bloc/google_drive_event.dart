part of 'google_drive_bloc.dart';

abstract class GoogleDriveEvent extends Equatable {
  const GoogleDriveEvent();
}

class GetDriveFolderIdEvent extends GoogleDriveEvent {
  final String? token;
  final String? folderName;
  final bool? fetchHistory;
  final String? refreshtoken;
  final bool? isFromOcrHome;
  final bool? assessmentSection;
  //final File? filePath;
  GetDriveFolderIdEvent(
      {required this.token,
      required this.folderName, //required this.filePath
      this.fetchHistory,
      this.refreshtoken,
      required this.isFromOcrHome,
      this.assessmentSection});

  @override
  List<Object> get props => [token!, folderName!];
}

class CreateExcelSheetToDrive extends GoogleDriveEvent {
  final String? name;
  CreateExcelSheetToDrive({this.name});
  @override
  List<Object> get props => [];
}

class UpdateDocOnDrive extends GoogleDriveEvent {
  final List<StudentAssessmentInfo>? studentData;
  final String? fileId;
  final bool isLoading;
  final bool? isCustomRubricSelcted;
  final int? selectedRubric;
  final String questionImage;

  final String? assessmentName;
  final bool? createdAsPremium;
  UpdateDocOnDrive(
      {this.studentData,
      required this.fileId,
      required this.isLoading,
      required this.questionImage,
      this.isCustomRubricSelcted,
      this.selectedRubric,
      required this.assessmentName,
      required this.createdAsPremium});
  @override
  List<Object> get props => [];
}

class GetHistoryAssessmentFromDrive extends GoogleDriveEvent {
  GetHistoryAssessmentFromDrive();

  @override
  List<Object> get props => [];
}

class UpdateHistoryAssessmentToDrive extends GoogleDriveEvent {
  final List<HistoryAssessment> obj;
  UpdateHistoryAssessmentToDrive({required this.obj});

  @override
  List<Object> get props => [];
}

class GetAssessmentDetail extends GoogleDriveEvent {
  final String? fileId;
  final String nextPageUrl;
  GetAssessmentDetail({this.fileId, required this.nextPageUrl});

  @override
  List<Object> get props => [];
}

class UpdateHistoryAssessmentFromDrive extends GoogleDriveEvent {
  final List<HistoryAssessment> obj;
  final String nextPageUrl;
  UpdateHistoryAssessmentFromDrive(
      {required this.obj, required this.nextPageUrl});

  @override
  List<Object> get props => [];
}

class ImageToAwsBucked extends GoogleDriveEvent {
  final String? imgBase64;
  final String? imgExtension;

  ImageToAwsBucked({required this.imgBase64, required this.imgExtension});

  @override
  List<Object> get props => [];
}

class AssessmentImgToAwsBucked extends GoogleDriveEvent {
  final String? imgBase64;
  final String? imgExtension;
  final String? studentId;
  final bool? isHistoryAssessmentSection;

  AssessmentImgToAwsBucked(
      {required this.imgBase64,
      required this.imgExtension,
      required this.studentId,
      required this.isHistoryAssessmentSection});

  @override
  List<Object> get props => [];
}

class QuestionImgToAwsBucked extends GoogleDriveEvent {
  final String? imgBase64;
  final String? imgExtension;

  QuestionImgToAwsBucked({
    required this.imgBase64,
    required this.imgExtension,
  });

  @override
  List<Object> get props => [];
}

class GetShareLink extends GoogleDriveEvent {
  final String? fileId;
  GetShareLink({required this.fileId});
  @override
  List<Object> get props => [];
}

class RefreshAuthenticationTokenEvent extends GoogleDriveEvent {
  RefreshAuthenticationTokenEvent();
  @override
  List<Object> get props => [];
}

class GetAssessmentSearchDetails extends GoogleDriveEvent {
  final String? keyword;

  GetAssessmentSearchDetails({
    required this.keyword,
  });

  @override
  List<Object> get props => [keyword!];
}
