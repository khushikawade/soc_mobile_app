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
  final String studentId;
  GetStudentPlusDetails({
    required this.studentId,
  });
  @override
  List<Object> get props => [studentId];
  @override
  String toString() => '$studentId';
}


/* ---------------- Event use to trigger student grade details --------------- */
class FetchStudentGradesEvent extends StudentPlusEvent {
  final String? studentId;
  FetchStudentGradesEvent({
    @required this.studentId,
  });

  @override
  List<Object> get props => [studentId!];

  @override
  String toString() => 'GlobalSearchEvent { keyword: $studentId}';
}
