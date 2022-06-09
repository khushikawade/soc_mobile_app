part of 'ocr_bloc.dart';

abstract class OcrEvent extends Equatable {
  const OcrEvent();
  @override
  List<Object> get props => [];
}

// class FetchTextFromImage extends OcrEvent {
//   List<Object> get props => [];
// }

class VerifyUserWithDatabase extends OcrEvent {
  final String? email;
  VerifyUserWithDatabase({required this.email});

  @override
  List<Object> get props => [email!];
}

class FatchSubjectDetails extends OcrEvent {
  final String? type;
  final String? keyword;
  FatchSubjectDetails({required this.type, required this.keyword});

  @override
  List<Object> get props => [type!, keyword!];
}

class SaveStudentDetails extends OcrEvent {
  final String studentName;
  final String studentId;
  SaveStudentDetails({required this.studentName, required this.studentId});

  @override
  List<Object> get props => [studentName, studentId];
}

class SearchSubjectDetails extends OcrEvent {
  final String? type;
  final String? keyword;
  final String? searchKeyword;
  SearchSubjectDetails(
      {required this.type, required this.keyword, required this.searchKeyword});

  @override
  List<Object> get props => [type!];
}

class SaveSubjectListDetails extends OcrEvent {
  @override
  List<Object> get props => [];
}

class FetchTextFromImage extends OcrEvent {
  final String base64;
  final String pointPossible;
  FetchTextFromImage({required this.base64, required this.pointPossible});

  @override
  List<Object> get props => [base64, pointPossible];

  @override
  String toString() => 'GlobalSearchEvent { keyword: $base64}';
}

class SaveAssessmentToDashboard extends OcrEvent {
  final String assessmentName;
  final String rubricScore;
  final String subjectId;
  final String schoolId;
  final String standardId;
  final int? previouslyAddedListLength;
  final scaffoldKey;
  final context;
  SaveAssessmentToDashboard(
      {required this.assessmentName,
      required this.rubricScore,
      required this.subjectId,
      required this.schoolId,
      required this.standardId,
      required this.scaffoldKey,
      required this.context,
      this.previouslyAddedListLength});

  @override
  List<Object> get props => [];
}
