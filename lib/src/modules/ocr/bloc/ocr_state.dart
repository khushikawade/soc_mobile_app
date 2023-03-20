part of 'ocr_bloc.dart';

abstract class OcrState extends Equatable {
  const OcrState();
  @override
  List<Object> get props => [];
}

class OcrInitial extends OcrState {}

class OcrLoading extends OcrState {}

class OcrLoading2 extends OcrState {}

class SearchLoading extends OcrState {}

class SaveSubjectListDetailsSuccess extends OcrState {}

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
  final List<StateListObject>? obj;
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

class RecentListSuccess extends OcrState {
  final List<SubjectDetailList>? obj;
  RecentListSuccess({
    this.obj,
  });
  RecentListSuccess copyWith({
    obj,
  }) {
    return RecentListSuccess(obj: obj ?? this.obj);
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

class SuccessStudentDetails extends OcrState {
  final String studentName;
  SuccessStudentDetails({required this.studentName});
  SuccessStudentDetails copyWith({final obj}) {
    return SuccessStudentDetails(studentName: obj ?? this.studentName);
  }

  @override
  List<Object> get props => [];
}

class AssessmentIdSuccess extends OcrState {
  String? obj;
  AssessmentIdSuccess({this.obj});
  AssessmentIdSuccess copyWith({final obj}) {
    return AssessmentIdSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [obj!];
}

class AssessmentDashboardStatus extends OcrState {
  int? resultRecordCount;
  GoogleClassroomCourses? assessmentObj;
  AssessmentDashboardStatus(
      {this.resultRecordCount, required this.assessmentObj});
  AssessmentDashboardStatus copyWith(
      {final obj, final recordCount, final assessmentId}) {
    return AssessmentDashboardStatus(
        resultRecordCount: recordCount ?? this.resultRecordCount,
        assessmentObj: assessmentId ?? this.assessmentObj);
  }

  @override
  List<Object> get props => [];
}

class GetRubricPdfSuccess extends OcrState {
  List<RubricPdfModal>? objList;

  GetRubricPdfSuccess({
    this.objList,
  });
  GetRubricPdfSuccess copyWith({
    final objList,
  }) {
    return GetRubricPdfSuccess(
      objList: objList ?? this.objList,
    );
  }

  @override
  List<Object> get props => [objList!];
}

// ---------- State to updated ui according to State List ----------
class StateListFetchSuccessfully extends OcrState {
  final List<String> stateList;
  StateListFetchSuccessfully({required this.stateList});

  @override
  List<Object> get props => [];
}

// ---------- State to Confirm subject list save to localDb according to state selection ----------
class SubjectDetailsListSaveSuccessfully extends OcrState {
  @override
  List<Object> get props => [];
}

// ---------- State to Return Local State search result ----------
class LocalStateSearchResult extends OcrState {
  final List<String> stateList;
  LocalStateSearchResult({required this.stateList});
  @override
  List<Object> get props => [];
}

//LocalStateSearchEvent
class NoRubricAvailable extends OcrState {}
