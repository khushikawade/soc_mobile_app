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

// ignore: must_be_immutable
class GoogleDriveGetSuccess extends GoogleDriveState {
  List<Assessment> obj;
  GoogleDriveGetSuccess({required this.obj});
  GoogleDriveGetSuccess copyWith({final obj}) {
    return GoogleDriveGetSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class GoogleNoAssessment extends GoogleDriveState {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class AssessmentSuccess extends GoogleDriveState {
  List<StudentAssessmentInfo> obj;
  AssessmentSuccess({required this.obj});
  AssessmentSuccess copyWith({final obj}) {
    return AssessmentSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}
