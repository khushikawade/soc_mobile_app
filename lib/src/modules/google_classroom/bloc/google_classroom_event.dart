// ignore_for_file: must_be_immutable

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

class CreateClassRoomCourseWork extends GoogleClassroomEvent {
  final String title;
  final String pointPossible;
  GoogleClassroomCourses studentClassObj;
  //get local store stduentinfoassessmentList
  LocalDatabase<StudentAssessmentInfo> studentAssessmentInfoDb;
  final bool? isFromHistoryAssessmentScanMore;
  final bool? isEditStudentInfo;

  CreateClassRoomCourseWork(
      {required this.title,
      required this.pointPossible,
      required this.studentClassObj,
      required this.studentAssessmentInfoDb,
      this.isFromHistoryAssessmentScanMore,
      this.isEditStudentInfo});
  @override
  List<Object> get props => [];
}

class GetClassroomCourseWorkURL extends GoogleClassroomEvent {
  GoogleClassroomCourses? obj;
  GetClassroomCourseWorkURL({required this.obj});
  @override
  List<Object> get props => [];
}

class CreatePBISClassroomCoursework extends GoogleClassroomEvent {
  final String pointPossible;
  final List<ClassroomCourse> courseAndStudentList;
  //get local store stduentinfoassessmentList
  final List<ClassRoomStudentProfile>? studentAssessmentInfoDb;

  CreatePBISClassroomCoursework({
    required this.pointPossible,
    required this.courseAndStudentList,
    this.studentAssessmentInfoDb,
  });
  @override
  List<Object> get props => [];
}

//Graded + Standard Apps
class CreateClassroomCourseWorkForStandardApp extends GoogleClassroomEvent {
  final String title;
  final String pointPossible;
  ClassroomCourse studentClassObj;
  LocalDatabase<StudentAssessmentInfo> studentAssessmentInfoDb;
  final bool? isFromHistoryAssessmentScanMore;
  final bool? isEditStudentInfo;

  CreateClassroomCourseWorkForStandardApp(
      {required this.title,
      required this.pointPossible,
      required this.studentClassObj,
      required this.studentAssessmentInfoDb,
      this.isFromHistoryAssessmentScanMore,
      this.isEditStudentInfo});
  @override
  List<Object> get props => [];
}
