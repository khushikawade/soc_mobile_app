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
  final String? grade;
  final bool? isSearchPage;
  final String? subjectSelected;
  FatchSubjectDetails(
      {required this.type,
      required this.keyword,
      this.isSearchPage,
      this.grade,
      this.subjectSelected});

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
  final String? grade;
  final bool? isSearchPage;
  final String? subjectSelected;
  SearchSubjectDetails(
      {required this.type,
      required this.keyword,
      required this.searchKeyword,
      this.isSearchPage,
      this.grade,
      this.subjectSelected});

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
  final List<StudentAssessmentInfo> resultList;
  final bool isHistoryAssessmentSection;
  final String? assessmentSheetPublicURL;
  final String? fileId;
  final String? assessmentId;
  
  SaveAssessmentToDashboard(
      {required this.assessmentName,
      required this.rubricScore,
      required this.subjectId,
      required this.schoolId,
      required this.standardId,
      required this.scaffoldKey,
      required this.context,
      this.previouslyAddedListLength,
      required this.resultList,
      required this.isHistoryAssessmentSection,
      required this.assessmentSheetPublicURL,
      required this.assessmentId,
      this.fileId,
     });

  @override
  List<Object> get props => [];
}

class SaveAndGetAssessmentID extends OcrEvent {
  final String assessmentName;
  final String rubricScore;
  final String subjectId;
  final String schoolId;
  final String standardId;
  final String fileId;
  final String sessionId;
  final scaffoldKey;
  final context;
  final String? teacherContactId;
  final String? teacherEmail;

  SaveAndGetAssessmentID(
      {required this.assessmentName,
      required this.rubricScore,
      required this.subjectId,
      required this.schoolId,
      required this.standardId,
      required this.scaffoldKey,
      required this.context,
      required this.sessionId,
      required this.fileId,
       required this.teacherContactId,
      required this.teacherEmail});

  @override
  List<Object> get props => [];
}

class FetchStudentDetails extends OcrEvent {
  final String ossId;

  FetchStudentDetails({required this.ossId});

  @override
  List<Object> get props => [ossId];

  //String toString() => 'GlobalSearchEvent { keyword: $base64}';
}

class GetDashBoardStatus extends OcrEvent {
  final String fileId;

  GetDashBoardStatus({required this.fileId});

  @override
  List<Object> get props => [fileId];

  @override
  String toString() => 'GlobalSearchEvent { keyword: $fileId}';
}

class FetchRecentSearch extends OcrEvent {
  final String? type;
  final String? className;
  final String? subjectName;
  // final String? type;

  FetchRecentSearch(
      {required this.type, required this.className, required this.subjectName});

  @override
  List<Object> get props => [];

  //String toString() => 'GlobalSearchEvent { keyword: $base64}';
}
class LogUserActivityEvent extends OcrEvent{
  final String? sessionId;
  final String? teacherId;
  final String? activityId;
  final String? accountId;
  final String? accountType;
  final String? dateTime;
  final String? description;
  final String? operationResult;
  // final String? type;

  LogUserActivityEvent(
      {required this.sessionId, required this.teacherId, required this.activityId, required this.accountId, required this.accountType, required this.dateTime, required this.description, required this.operationResult});

  @override
  List<Object> get props => [];
}
