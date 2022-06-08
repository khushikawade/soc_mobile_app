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
  AssessmentDetailSuccess({required this.obj});
  AssessmentDetailSuccess copyWith({final obj}) {
    return AssessmentDetailSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}
