part of 'pbis_plus_bloc.dart';

abstract class PBISPlusEvent extends Equatable {
  const PBISPlusEvent();
}

class PBISPlusImportRoster extends PBISPlusEvent {
  final bool isGradedPlus;
  PBISPlusImportRoster({
    required this.isGradedPlus,
  });
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
  final String? studentEmail;
  final String? classroomCourseId;
  final int? engaged;
  final int? niceWork;
  final int? helpful;

  AddPBISInteraction(
      {required this.context,
      required this.scaffoldKey,
      required this.studentId,
      required this.studentEmail,
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
  // final String? studentEmail;
  final String? classroomCourseName;

  AddPBISHistory(
      {required this.type,
      required this.url,
      // this.studentEmail,
      this.classroomCourseName});

  @override
  List<Object> get props => [type!, url!, classroomCourseName!];
}

/* ---------------- Event to get student details using email ---------------- */
class GetPBISPlusStudentDashboardLogs extends PBISPlusEvent {
  final String studentId;
  final String classroomCourseId;
  final bool? isStudentPlus;

  GetPBISPlusStudentDashboardLogs(
      {required this.studentId,
      required this.classroomCourseId,
      required this.isStudentPlus});

  @override
  List<Object> get props => [studentId];
}

class PBISPlusResetInteractions extends PBISPlusEvent {
  final String type;
  final List<ClassroomCourse>
      selectedRecords; //Can contain Classroom Course ids or Student ids

  PBISPlusResetInteractions({
    required this.type,
    required this.selectedRecords,
  });
  @override
  List<Object> get props => [];
}

class GetPBISPlusCustomBehaviour extends PBISPlusEvent {
  GetPBISPlusCustomBehaviour();
  @override
  List<bool> get props => [];
}

class GetPBISPlusAdditionalBehaviour extends PBISPlusEvent {
  GetPBISPlusAdditionalBehaviour();
  @override
  List<Object> get props => [];
}

class GetPBISSkillsUpdateName extends PBISPlusEvent {
  final PBISPlusGenericBehaviourModal item;
  final String newName;

  GetPBISSkillsUpdateName({required this.item, required this.newName});

  @override
  List<Object> get props => [item, newName];
}

class DeletePBISBehavior extends PBISPlusEvent {
  final PBISPlusGenericBehaviourModal item;

  DeletePBISBehavior({required this.item});

  @override
  List<Object> get props => [item];
}

class UpdatePBISBehavior extends PBISPlusEvent {
  final PBISPlusGenericBehaviourModal item;
  final List<PBISPlusGenericBehaviourModal> olditem;
  int index;
  UpdatePBISBehavior(
      {required this.item, required this.index, required this.olditem});

  @override
  List<Object> get props => [item, index, olditem];
}


class GetPBISPlusStudentList extends PBISPlusEvent {
  List<PBISPlusStudentList>? studentNotesList;
  GetPBISPlusStudentList({
    this.studentNotesList,
  });

  @override
  List<Object> get props => [studentNotesList!];
}

class PBISPlusNotesSearchStudentList extends PBISPlusEvent {
  final String searchKey;
  final List<PBISPlusStudentList> studentNotes;
  PBISPlusNotesSearchStudentList({
    required this.searchKey,
    required this.studentNotes,
  });

  @override
  List<Object> get props => [
        searchKey,
        studentNotes,
      ];
}

class GetPBISPlusNotes extends PBISPlusEvent {
  final String studentId;
  final String teacherid;
  final String dbn;
  GetPBISPlusNotes({
    required this.studentId,
    required this.teacherid,
    required this.dbn,
  });

  @override
  List<Object> get props => [studentId, teacherid, dbn];
}

// class AddPBISPlusStudentNotesList extends PBISPlusEvent {
//   final String studentId;
//   final String studentName;
//   final String studentEmail;
//   final String studentEmail;
//   final String studentEmail;
//   GetPBISPlusNotes({
//     required this.studentId,
//     required this.teacherid,
//     required this.dbn,
//   });

//   @override
//   List<Object> get props => [studentId, teacherid, dbn];
// }
 
 class AddPBISPlusStudentNotes extends PBISPlusEvent {
final  String studentId;
 final String studentName;
 final String studentEmail;
 final String teacherId;
 final String schoolId;
 final String schoolDbn;
 final String notes;
  
  GetPBISPlusNotes({
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.teacherid,
    required this.schoolId,
    required this.schoolDbn,
    required this.notes,
  });

  @override
  List<Object> get props => [studentId, studentName, studentEmail,teacherId,schoolId,schoolDbn,notes];
}