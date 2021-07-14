part of 'student_bloc.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();
}

class StudentPageEvent extends StudentEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'StudentButtonPressed';
}
