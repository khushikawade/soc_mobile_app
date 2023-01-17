part of 'student_bloc.dart';

abstract class StudentState extends Equatable {
  const StudentState();
}

class StudentInitial extends StudentState {
  @override
  List<Object> get props => [];
}

class Loading extends StudentState {
  @override
  List<Object> get props => [];
}

class StudentError extends StudentState {
  final err;
  StudentError({this.err});
  StudentError copyWith({final err}) {
    return StudentError(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}

class StudentDataSuccess extends StudentState {
  final List<StudentApp>? obj;
  final List<StudentApp>? subFolder;

  StudentDataSuccess({this.obj, this.subFolder});

  StudentDataSuccess copyWith({final obj, final subFolder}) {
    return StudentDataSuccess(
        obj: obj ?? this.obj, subFolder: subFolder ?? this.subFolder);
  }

  @override
  List<Object> get props => [];
}
