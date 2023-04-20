part of 'pbis_plus_bloc.dart';

abstract class PBISPlusEvent extends Equatable {
  const PBISPlusEvent();
}

class PBISPlusImportRoster extends PBISPlusEvent {
  PBISPlusImportRoster();
  @override
  List<Object> get props => [];
}

// class GetPBISTotalInteractionsByTeacher extends PBISPlusEvent {
//   GetPBISTotalInteractionsByTeacher();
//   @override
//   List<Object> get props => [];
// }

class AddPBISInteraction extends PBISPlusEvent {
  final context;
  final scaffoldKey;
  final String? studentId;
  final String? classroomCourseId;
  final int? engaged;
  final int? niceWork;
  final int? helpful;

  AddPBISInteraction(
      {required this.context,
      required this.scaffoldKey,
      required this.studentId,
      required this.classroomCourseId,
      this.engaged,
      this.niceWork,
      this.helpful});

  @override
  List<Object> get props =>
      [studentId!, classroomCourseId!, engaged!, niceWork!, helpful!];
}

class GetPBISPlusHistory extends PBISPlusEvent {
  GetPBISPlusHistory();
  @override
  List<Object> get props => [];
}

class AddPBISHistory extends PBISPlusEvent {
  final String? type; //Sheet //Classroom
  final String? url;
  final String? studentEmail;
  final String? classroomCourseName;

  AddPBISHistory(
      {required this.type,
      required this.url,
      this.studentEmail,
      this.classroomCourseName});

  @override
  List<Object> get props => [type!, url!, studentEmail!, classroomCourseName!];
}

/* ---------------- Event to get student details using email ---------------- */
class GetPBISPlusStudentDashboardLogs extends PBISPlusEvent {
  final String studentId;

  GetPBISPlusStudentDashboardLogs({required this.studentId});

  @override
  List<Object> get props => [studentId];
}
