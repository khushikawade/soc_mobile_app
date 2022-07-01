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
  final List<HistoryAssessment>? obj;

  GoogleDriveGetSuccess({this.obj});

  GoogleDriveGetSuccess copyWith({final obj}) {
    return GoogleDriveGetSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [obj!];
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
  final obj;
  ExcelSheetCreated({
    required this.obj,
  });
  ExcelSheetCreated copyWith({
    final obj,
  }) {
    return ExcelSheetCreated(
      obj: obj ?? this.obj,
    );
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
  ErrorState({this.errorMsg});
  @override
  List<Object> get props => [];
}

class ShareLinkRecived extends GoogleDriveState {
  final String? shareLink;
  ShareLinkRecived({required this.shareLink});
  @override
  List<Object> get props => [];
}

class RefreshAuthenticationTokenSuccessState extends GoogleDriveState {
  RefreshAuthenticationTokenSuccessState();
  @override
  List<Object> get props => [];
}
