part of 'google_classroom_bloc.dart';

abstract class GoogleClassroomState extends Equatable {
  const GoogleClassroomState();
}

class GoogleClassroomInitial extends GoogleClassroomState {
  @override
  List<Object> get props => [];
}

class GoogleClassroomLoading extends GoogleClassroomState {
  @override
  List<Object> get props => [];
}

class GoogleClassroomErrorState extends GoogleClassroomState {
  final String? errorMsg;
  final isAssessmentSection;
  GoogleClassroomErrorState({this.errorMsg, this.isAssessmentSection});
  @override
  List<Object> get props => [];
}

class GoogleClassroomCourseListSuccess extends GoogleClassroomState {
  final List<GoogleClassroomCourses>? obj;

  GoogleClassroomCourseListSuccess({this.obj});

  GoogleClassroomCourseListSuccess copyWith({final obj}) {
    return GoogleClassroomCourseListSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [obj!];
}

// class GoogleClassroomStudentListSuccess extends GoogleClassroomState {
//   final List<GoogleClassroomStudents>? obj;

//   GoogleClassroomStudentListSuccess({this.obj});

//   GoogleClassroomStudentListSuccess copyWith({final obj}) {
//     return GoogleClassroomStudentListSuccess(obj: obj ?? this.obj);
//   }

//   @override
//   List<Object> get props => [obj!];
// }

class CreateClassroomCourseWorkSuccess extends GoogleClassroomState {
  CreateClassroomCourseWorkSuccess();

  @override
  List<Object> get props => [];
}
