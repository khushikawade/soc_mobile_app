part of 'student_plus_bloc.dart';

abstract class StudentPlusState extends Equatable {
  const StudentPlusState();
  @override
  List<Object> get props => [];
}

class StudentPlusInitial extends StudentPlusState {}

class StudentPlusLoading extends StudentPlusState {}

/* -------------------- state use to return student search details --------------- */
class StudentPlusSearchSuccess extends StudentPlusState {
  final List<StudentPlusDetailsModel> obj;
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
