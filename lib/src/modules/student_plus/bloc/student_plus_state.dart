part of 'student_plus_bloc.dart';

abstract class StudentPlusState extends Equatable {
  const StudentPlusState();
  @override
  List<Object> get props => [];
}

class StudentPlusInitial extends StudentPlusState {}

class StudentPlusLoading extends StudentPlusState {}

class StudentPlusGetDetailsLoading extends StudentPlusState {}

/* -------------------- state use to return student search details --------------- */
class StudentPlusSearchSuccess extends StudentPlusState {
  final List<StudentPlusSearchModel> obj;
  StudentPlusSearchSuccess({required this.obj});
  StudentPlusSearchSuccess copyWith({final obj}) {
    return StudentPlusSearchSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

/* ----------------------- state use to return student work ---------------------- */
class StudentPlusWorkSuccess extends StudentPlusState {
  final List<StudentPlusWorkModel> obj;
  StudentPlusWorkSuccess({required this.obj});
  StudentPlusWorkSuccess copyWith({final obj}) {
    return StudentPlusWorkSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

/* ------------------------ state use to return error ----------------------- */
class StudentPlusErrorReceived extends StudentPlusState {
  final err;
  StudentPlusErrorReceived({this.err});
  StudentPlusErrorReceived copyWith({final err}) {
    return StudentPlusErrorReceived(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}

/* ------------------ State to get student details from id ------------------ */
class StudentPlusInfoSuccess extends StudentPlusState {
  final StudentPlusDetailsModel obj;
  StudentPlusInfoSuccess({required this.obj});
  StudentPlusInfoSuccess copyWith({final obj}) {
    return StudentPlusInfoSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

/* ----------------------- state use to return grade ---------------------- */
class StudentPlusGradeSuccess extends StudentPlusState {
  final List<StudentPlusGradeModel> obj;
  final List<StudentPlusCourseModel> courseList;
  final List<String> chipList;
  StudentPlusGradeSuccess(
      {required this.obj, required this.chipList, required this.courseList});
  StudentPlusGradeSuccess copyWith({final obj}) {
    return StudentPlusGradeSuccess(
        obj: obj ?? this.obj, chipList: chipList, courseList: courseList);
  }

  @override
  List<Object> get props => [];
}

/* ----------------------- state use to return  Course student work ---------------------- */
class StudentPlusCourseWorkSuccess extends StudentPlusState {
  final List<StudentPlusCourseWorkModel> obj;

  StudentPlusCourseWorkSuccess({
    required this.obj,
  });
  StudentPlusCourseWorkSuccess copyWith({final obj}) {
    return StudentPlusCourseWorkSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class SaveStudentGooglePresentationWorkEventSuccess extends StudentPlusState {
  StudentPlusDetailsModel studentDetails;
  SaveStudentGooglePresentationWorkEventSuccess({required this.studentDetails});

  @override
  List<Object> get props => [];
}

/* --------------------------- State to return student search by email -------------------------- */
class StudentPlusSearchByEmailSuccess extends StudentPlusState {
  final StudentPlusDetailsModel obj;
  StudentPlusSearchByEmailSuccess({required this.obj});
  StudentPlusSearchByEmailSuccess copyWith({final obj}) {
    return StudentPlusSearchByEmailSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}