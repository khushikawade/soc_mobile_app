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
  List<Records>? obj;

  StudentDataSucess({this.obj});

  StudentDataSucess copyWith({var obj}) {
    return StudentDataSucess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}
