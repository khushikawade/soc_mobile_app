part of 'student_plus_bloc.dart';

abstract class StudentPlusEvent extends Equatable {
  const StudentPlusEvent();
  @override
  List<Object> get props => [];
}

/* ------------------- Event use to trigger student search ------------------ */
class StudentPlusSearchEvent extends StudentPlusEvent {
  final String? keyword;
  StudentPlusSearchEvent({
    @required this.keyword,
  });

  @override
  List<Object> get props => [keyword!];

  @override
  String toString() => 'GlobalSearchEvent { keyword: $keyword}';
}

/* ---------------- Event use to trigger student work details --------------- */
class FetchStudentWorkEvent extends StudentPlusEvent {
  final String? studentId;
  FetchStudentWorkEvent({
    @required this.studentId,
  });

  @override
  List<Object> get props => [studentId!];

  @override
  String toString() => 'GlobalSearchEvent { keyword: $studentId}';
}

/* ------------------ Event use to trigger student details from id ------------------ */
class GetStudentPlusDetails extends StudentPlusEvent {
  final String studentIdC;
  GetStudentPlusDetails({
    required this.studentIdC,
  });
  @override
  List<Object> get props => [studentIdC];
  @override
  String toString() => '$studentIdC';
}

/* ---------------- Event use to trigger student grade details --------------- */
class FetchStudentGradesEvent extends StudentPlusEvent {
  final String? studentId;
  final String? studentEmail;
  FetchStudentGradesEvent(
      {@required this.studentId, required this.studentEmail});

  @override
  List<Object> get props => [studentId!];

  @override
  String toString() => 'GlobalSearchEvent { keyword: $studentId}';
}

class SaveStudentGooglePresentationWorkEvent extends StudentPlusEvent {
  final StudentPlusDetailsModel studentDetails;
  final String filterName;
  int? studentGooglePresentationRecordId;
  SaveStudentGooglePresentationWorkEvent(
      {required this.studentDetails,
      required this.filterName,
      required this.studentGooglePresentationRecordId});

  @override
  List<Object> get props => [studentDetails!];
}

/* ------------------------ Event use to trigger student search by email ------------------------ */
class StudentPlusSearchByEmail extends StudentPlusEvent {
  StudentPlusSearchByEmail();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'GlobalSearchEvent { keyword: }';
}

/* ---------------- Event use to trigger student current grade details --------------- */
class FetchStudentCourseWorkEvent extends StudentPlusEvent {
  final String courseWorkId;
  final String? studentUserId;
  FetchStudentCourseWorkEvent(
      {required this.courseWorkId, required this.studentUserId});
  @override
  List<Object> get props => [];
  @override
  String toString() => '';
}

/* ---------------- Event use to trigger update current student grade details --------------- */
class GetStudentCourseWorkListByPaginationEvent extends StudentPlusEvent {
  final String courseWorkId;
  final String? nextPageToken;
  final String? studentUserId;
  final List<StudentPlusCourseWorkModel> oldList;
  GetStudentCourseWorkListByPaginationEvent(
      {required this.courseWorkId,
      required this.nextPageToken,
      required this.oldList,
      required this.studentUserId});
  @override
  List<Object> get props => [];
  @override
  String toString() => '';
}

/* ---------------- Event use to trigger student work details --------------- */
class FetchStudentGradesWithClassroomEvent extends StudentPlusEvent {
  final String? studentId;
  final String? studentEmail;
  FetchStudentGradesWithClassroomEvent({
    @required this.studentId,
    required this.studentEmail
  });

  @override
  List<Object> get props => [studentId!];

  @override
  String toString() => 'GlobalSearchEvent { keyword: $studentId}';
}

/* ---------------- Event use to trigger get otp for family login --------------- */
class SendOtpFamilyLogin extends StudentPlusEvent {
  final String emailId;
  SendOtpFamilyLogin({required this.emailId});
  @override
  List<Object> get props => [];
  @override
  String toString() => '';
}

/* ---------------- Event use to trigger Check otp for family login --------------- */
class VerifyOtpFamilyLogin extends StudentPlusEvent {
  final String emailId;
  final String otp;
  VerifyOtpFamilyLogin({required this.emailId, required this.otp});
  @override
  List<Object> get props => [];
  @override
  String toString() => '';
}

/* ---------------- Event use to trigger get student list for family login --------------- */
class GetStudentListFamilyLogin extends StudentPlusEvent {
  GetStudentListFamilyLogin();
  @override
  List<Object> get props => [];
  @override
  String toString() => '';
}

/* ---------------- Event use to trigger get student google presentation details --------------- */
class GetStudentPlusWorkGooglePresentationDetails extends StudentPlusEvent {
  final StudentPlusDetailsModel studentDetails;

  final String schoolDBN;
  final String filterName;

  GetStudentPlusWorkGooglePresentationDetails(
      {required this.studentDetails,
      required this.schoolDBN,
      required this.filterName});
}

/* ---------------- Event use to trigger get Regents list in Exam section --------------- */
class GetStudentRegentsList extends StudentPlusEvent {
  final String studentId;
  GetStudentRegentsList({required this.studentId});
  @override
  List<Object> get props => [];
  @override
  String toString() => '';
}
