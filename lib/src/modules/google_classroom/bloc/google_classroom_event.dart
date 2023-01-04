part of 'google_classroom_bloc.dart';

abstract class GoogleClassroomEvent extends Equatable {
  const GoogleClassroomEvent();
}

class GetClassroomCourses extends GoogleClassroomEvent {
  @override
  List<Object> get props => [];
}

class GetClassroomStudentsByCourseId extends GoogleClassroomEvent {
  final String? courseId;
  GetClassroomStudentsByCourseId({required this.courseId});
  @override
  List<Object> get props => [];
}
