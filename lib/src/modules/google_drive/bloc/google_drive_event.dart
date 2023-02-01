part of 'google_drive_bloc.dart';

abstract class GoogleDriveEvent extends Equatable {
  const GoogleDriveEvent();
}

class GetDriveFolderIdEvent extends GoogleDriveEvent {
  final String? token;
  final String? folderName;
  final bool? fetchHistory;
  final String? refreshToken;
  final bool? isFromOcrHome;
  final bool? assessmentSection;
  //final File? filePath;
  GetDriveFolderIdEvent(
      {required this.token,
      required this.folderName, //required this.filePath
      this.fetchHistory,
      this.refreshToken,
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
  final bool? isMcqSheet;
  final List<StudentAssessmentInfo>? studentData;
  final String? fileId;
  final bool isLoading;
  final bool? isCustomRubricSelected;
  final int? selectedRubric;
  final String questionImage;
  final String? assessmentName;
  final bool? createdAsPremium;

  UpdateDocOnDrive(
      {this.studentData,
      required this.fileId,
      required this.isLoading,
      required this.questionImage,
      this.isCustomRubricSelected,
      this.selectedRubric,
      required this.assessmentName,
      required this.createdAsPremium,
      required this.isMcqSheet});
  @override
  List<Object> get props => [];
}

class GetHistoryAssessmentFromDrive extends GoogleDriveEvent {
  final String? searchKeyword;

  GetHistoryAssessmentFromDrive({this.searchKeyword});
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

class ImageToAwsBucket extends GoogleDriveEvent {
  CustomRubricModal customRubricModal;
  final bool? getImageUrl;
  ImageToAwsBucket(
      {required this.customRubricModal, required this.getImageUrl});

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
  final bool slideLink;
  final String? fileId;
  GetShareLink({required this.fileId, required this.slideLink});
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

// ignore: must_be_immutable
class AddBlankSlidesOnDrive extends GoogleDriveEvent {
  bool? isScanMore;
  String? slidePresentationId;
  AddBlankSlidesOnDrive(
      {required this.slidePresentationId, required this.isScanMore});

  @override
  List<Object> get props => [];
}

class CreateSlideToDrive extends GoogleDriveEvent {
  final String? fileTitle;
  final String? excelSheetId;
  CreateSlideToDrive({required this.fileTitle, required this.excelSheetId});
  @override
  List<Object> get props => [];
}

// Event To Update Google Slide On Scan More -----------------------------------//
class UpdateGoogleSlideOnScanMore extends GoogleDriveEvent {
  final bool isFromHistoryAssessment;
  final String slidePresentationId;
  final String assessmentName;
  final int lastAssessmentLength;

  UpdateGoogleSlideOnScanMore(
      {required this.slidePresentationId,
      required this.lastAssessmentLength,
      required this.isFromHistoryAssessment,
      required this.assessmentName});
  @override
  List<Object> get props => [];
}

class UpdateAssessmentImageToSlidesOnDrive extends GoogleDriveEvent {
  final String? slidePresentationId;
  UpdateAssessmentImageToSlidesOnDrive({required this.slidePresentationId});

  @override
  List<Object> get props => [];
}

class UpdateAssignmentDetailsOnSlide extends GoogleDriveEvent {
  final String? slidePresentationId;
  final StudentAssessmentInfo studentAssessmentInfoObj;
  UpdateAssignmentDetailsOnSlide(
      {required this.slidePresentationId,
      required this.studentAssessmentInfoObj});

  @override
  List<Object> get props => [];
}
