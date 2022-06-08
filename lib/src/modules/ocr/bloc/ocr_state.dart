part of 'ocr_bloc.dart';

abstract class OcrState extends Equatable {
  const OcrState();
  @override
  List<Object> get props => [];
}

class OcrInitial extends OcrState {}

class OcrLoading extends OcrState {}

class SearchLoading extends OcrState {}

class FetchTextFromImageSuccess extends OcrState {
  final String? studentId;
  final String? grade;
  final String? studentName;
  FetchTextFromImageSuccess(
      {required this.studentId,
      required this.grade,
      required this.studentName});
  FetchTextFromImageSuccess copyWith(
      {final studentId, final grade, final studentName}) {
    return FetchTextFromImageSuccess(
        studentId: studentId ?? this.studentId,
        grade: grade ?? this.grade,
        studentName: studentName ?? this.studentName);
  }

  @override
  List<Object> get props => [];
}

// class EmailAuthenticationSuccess extends OcrState {
//   final obj;
//   EmailAuthenticationSuccess({this.obj});
//   EmailAuthenticationSuccess copyWith({final obj}) {
//     return EmailAuthenticationSuccess(obj: obj ?? this.obj);
//   }

//   @override
//   List<Object> get props => [];
// }

class OcrErrorReceived extends OcrState {
  final err;
  OcrErrorReceived({this.err});
  OcrErrorReceived copyWith({final err}) {
    return OcrErrorReceived(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}

class SubjectDataSuccess extends OcrState {
  final List<SubjectDetailList>? obj;
  SubjectDataSuccess({
    this.obj,
  });
  // SubjectDataSuccess copyWith({
  //   obj,
  // }) {
  //   return SubjectDataSuccess(obj: obj ?? this.obj);
  // }

  @override
  List<Object> get props => [];
}

//SearchSubjectDetails
class SearchSubjectDetailsSuccess extends OcrState {
  final List<SubjectDetailList>? obj;
  SearchSubjectDetailsSuccess({
    this.obj,
  });
  SearchSubjectDetailsSuccess copyWith({
    obj,
  }) {
    return SearchSubjectDetailsSuccess();
  }

  @override
  List<Object> get props => [];
}

class NycDataSuccess extends OcrState {
  final List<SubjectDetailList> obj;
  NycDataSuccess({
    required this.obj,
  });

  get list => null;
  NycDataSuccess copyWith({
    obj,
  }) {
    return NycDataSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class NycSubDataSuccess extends OcrState {
  final List<SubjectDetailList>? obj;
  NycSubDataSuccess({
    this.obj,
  });
  NycSubDataSuccess copyWith({
    obj,
  }) {
    return NycSubDataSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class FetchTextFromImageFailure extends OcrState {
  final String? studentId;
  final String? studentName;
  final String? grade;

  FetchTextFromImageFailure(
      {required this.studentId,
      required this.grade,
      required this.studentName});

  FetchTextFromImageFailure copyWith(
      {final studentId, final grade, final studentName}) {
    return FetchTextFromImageFailure(
        studentId: studentId ?? this.studentId,
        grade: grade ?? this.grade,
        studentName: studentName ?? this.studentName);
  }

  @override
  List<Object> get props => [];
}


class AssessmentSavedSuccessfully extends OcrState {
  final obj;
  AssessmentSavedSuccessfully({this.obj});
  AssessmentSavedSuccessfully copyWith({final obj}) {
    return AssessmentSavedSuccessfully(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [obj];
}