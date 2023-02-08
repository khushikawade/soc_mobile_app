part of 'google_drive_bloc.dart';

abstract class GoogleDriveState extends Equatable {
  const GoogleDriveState();
}

class GoogleDriveInitial extends GoogleDriveState {
  @override
  List<Object> get props => [];
}

class GoogleDriveLoading extends GoogleDriveState {
  @override
  List<Object> get props => [];
}

class GoogleDriveLoading2 extends GoogleDriveState {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class GoogleDriveGetSuccess extends GoogleDriveState {
  final List<HistoryAssessment> obj;
  final String? nextPageLink;

  GoogleDriveGetSuccess({required this.obj, this.nextPageLink});

  GoogleDriveGetSuccess copyWith({final obj}) {
    return GoogleDriveGetSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [obj];
}

class QuestionImageSuccess extends GoogleDriveState {
  final String? questionImageUrl;

  QuestionImageSuccess({required this.questionImageUrl});

  QuestionImageSuccess copyWith({final questionImageUrl}) {
    return QuestionImageSuccess(
        questionImageUrl: questionImageUrl ?? this.questionImageUrl);
  }

  @override
  List<Object> get props => [questionImageUrl!];
}

// class GoogleNoAssessment extends GoogleDriveState {
//   @override
//   List<Object> get props => [];
// }

// ignore: must_be_immutable
class AssessmentDetailSuccess extends GoogleDriveState {
  List<StudentAssessmentInfo> obj;
  String? webContentLink;
  AssessmentDetailSuccess({required this.obj, required this.webContentLink});
  AssessmentDetailSuccess copyWith({final obj, final webContentLink}) {
    return AssessmentDetailSuccess(
        obj: obj ?? this.obj,
        webContentLink: webContentLink ?? this.webContentLink);
  }

  @override
  List<Object> get props => [];
}

class ExcelSheetCreated extends GoogleDriveState {
  ExcelSheetCreated();
  ExcelSheetCreated copyWith({
    final obj,
  }) {
    return ExcelSheetCreated();
  }

  @override
  List<Object> get props => [];
}

class GoogleFolderCreated extends GoogleDriveState {
  final obj;
  GoogleFolderCreated({
    this.obj,
  });
  GoogleFolderCreated copyWith({
    final obj,
  }) {
    return GoogleFolderCreated(
      obj: obj ?? this.obj,
    );
  }

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class GoogleSuccess extends GoogleDriveState {
  bool? assessmentSection;
  GoogleSuccess({this.assessmentSection});
  @override
  List<Object> get props => [];
}

class ErrorState extends GoogleDriveState {
  final String? errorMsg;
  final isAssessmentSection;
  ErrorState({this.errorMsg, this.isAssessmentSection});
  @override
  List<Object> get props => [];
}

class ShareLinkReceived extends GoogleDriveState {
  final String? shareLink;
  ShareLinkReceived({required this.shareLink});
  @override
  List<Object> get props => [];
}

class RefreshAuthenticationTokenSuccessState extends GoogleDriveState {
  RefreshAuthenticationTokenSuccessState();
  @override
  List<Object> get props => [];
}

class ImageToAwsBucketSuccess extends GoogleDriveState {
  final String? bucketImageUrl;
  CustomRubricModal customRubricModal;
  ImageToAwsBucketSuccess(
      {required this.bucketImageUrl, required this.customRubricModal});
      
        @override
        // TODO: implement props
        List<Object?> get props => throw UnimplementedError();
}

class GoogleSlideCreated extends GoogleDriveState {
  final String? slideFiledId;
  GoogleSlideCreated({required this.slideFiledId});

  @override
  List<Object> get props => [];
}

class AddBlankSlidesOnDriveSuccess extends GoogleDriveState {
  AddBlankSlidesOnDriveSuccess();

  @override
  List<Object> get props => [];
}

class GoogleAssessmentImagesOnSlidesUpdated extends GoogleDriveState {
  GoogleAssessmentImagesOnSlidesUpdated();

  @override
  List<Object> get props => [];
}

class ShowLoadingDialog extends GoogleDriveState {
  @override
  List<Object> get props => [];
}

class GoogleSheetUpdateOnScanMoreSuccess extends GoogleDriveState {
  final List<StudentAssessmentInfo> list;
  GoogleSheetUpdateOnScanMoreSuccess({required this.list});
  @override
  List<Object> get props => [];
}

class RecallTheEvent extends GoogleDriveState {
  @override
  List<Object> get props => [];
}

class UpdateAssignmentDetailsOnSlideSuccess extends GoogleDriveState {
  UpdateAssignmentDetailsOnSlideSuccess();
  @override
  List<Object> get props => [];
}
class AddAndUpdateAssessmentImageToSlidesOnDriveSuccess extends GoogleDriveState {
  AddAndUpdateAssessmentImageToSlidesOnDriveSuccess();

  @override
  List<Object> get props => [];
}