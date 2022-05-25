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
  final String? schoolId;
  final String? grade;
  FetchTextFromImageSuccess({required this.schoolId, required this.grade});
  FetchTextFromImageSuccess copyWith({final schoolId}) {
    return FetchTextFromImageSuccess(
        schoolId: schoolId ?? this.schoolId, grade: grade ?? this.grade);
  }

  @override
  List<Object> get props => [];
}

class FetchTextFromImageFailure extends OcrState {
  final String? schoolId;
  final String? grade;
  FetchTextFromImageFailure({required this.schoolId, required this.grade});
  FetchTextFromImageFailure copyWith({final schoolId}) {
    return FetchTextFromImageFailure(
        schoolId: schoolId ?? this.schoolId, grade: grade ?? this.grade);
  }

  @override
  List<Object> get props => [];
}

class EmailAuthenticationSuccess extends OcrState {
  final obj;
  EmailAuthenticationSuccess({this.obj});
  EmailAuthenticationSuccess copyWith({final obj}) {
    return EmailAuthenticationSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

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
  SubjectDataSuccess copyWith({
    obj,
  }) {
    return SubjectDataSuccess(obj: obj ?? this.obj);
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
