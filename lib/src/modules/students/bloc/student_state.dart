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

class Errorinloading extends StudentState {
  final err;
  Errorinloading({this.err});
  Errorinloading copyWith({var err}) {
    return Errorinloading(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}

// ignore: must_be_immutable
class StudentDataSucess extends StudentState {
  List<StudentApp>? obj;
  List<StudentApp>? subFolder;

  StudentDataSucess({this.obj, this.subFolder});

  StudentDataSucess copyWith({var obj, var subFolder}) {
    return StudentDataSucess(
        obj: obj ?? this.obj, subFolder: subFolder ?? this.subFolder);
  }

  @override
  List<Object> get props => [];
}
