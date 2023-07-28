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

class GetPBISPlusCustomBehavior extends PBISPlusEvent {
  GetPBISPlusCustomBehavior();
  @override
  List<bool> get props => [];
}

class PBISPlusGetAdditionalBehavior extends PBISPlusEvent {
  PBISPlusGetAdditionalBehavior();
  @override
  List<Object> get props => [];
}

class GetPBISSkillsUpdateName extends PBISPlusEvent {
  final PBISPlusCommonBehaviorModal item;
  final String newName;

  GetPBISSkillsUpdateName({required this.item, required this.newName});

  @override
  List<Object> get props => [item, newName];
}

class GetPBISPlusStudentList extends PBISPlusEvent {
  final List<PBISPlusNotesUniqueStudentList>? studentNotesList;
  GetPBISPlusStudentList({this.studentNotesList});

  @override
  List<Object> get props => [studentNotesList!];
}

class PBISPlusNotesSearchStudent extends PBISPlusEvent {
  final String searchKey;
  final List<PBISPlusNotesUniqueStudentList> studentNotes;
  PBISPlusNotesSearchStudent(
      {required this.searchKey, required this.studentNotes});

  @override
  List<Object> get props => [searchKey, studentNotes];
}

class GetPBISPlusNotes extends PBISPlusEvent {
  final String studentId;

  GetPBISPlusNotes({required this.studentId});

  @override
  List<Object> get props => [studentId];
}

class AddPBISPlusStudentNotes extends PBISPlusEvent {
  final String? studentId;
  final String? studentName;
  final String? studentEmail;
  final String? teacherId;
  final String? schoolId;
  final String? schoolDbn;
  final String? notes;

  AddPBISPlusStudentNotes(
      {required this.studentId,
      required this.studentName,
      required this.studentEmail,
      required this.teacherId,
      required this.schoolId,
      required this.schoolDbn,
      required this.notes});

  @override
  List<Object> get props => [
        studentId!,
        studentName!,
        studentEmail!,
        teacherId!,
        schoolId!,
        schoolDbn!,
        notes!
      ];
}

class PBISPlusGetDefaultSchoolBehavior extends PBISPlusEvent {
  PBISPlusGetDefaultSchoolBehavior();

  @override
  List<Object> get props => [];
}

class PBISPlusGetTeacherCustomBehavior extends PBISPlusEvent {
  PBISPlusGetTeacherCustomBehavior();

  @override
  List<Object> get props => [];
}

class PBISPlusDeleteTeacherCustomBehavior extends PBISPlusEvent {
  final PBISPlusCommonBehaviorModal behavior;

  PBISPlusDeleteTeacherCustomBehavior({required this.behavior});

  @override
  List<Object> get props => [behavior];
}

class PBISPlusAddAndUpdateTeacherCustomBehavior extends PBISPlusEvent {
  final PBISPlusCommonBehaviorModal behavior;
  // final List<PBISPlusCommonBehaviorModal> oldbehavior;
  final int? index;
  PBISPlusAddAndUpdateTeacherCustomBehavior(
      {required this.behavior, this.index});

  @override
  List<Object> get props => [behavior];
}

class PbisPlusAddPBISInteraction extends PBISPlusEvent {
  final context;
  final scaffoldKey;
  final String? studentId;
  final String? studentEmail;
  final String? classroomCourseId;
  final PBISPlusCommonBehaviorModal? behaviour;
  final bool? isCustomBehavior;

  PbisPlusAddPBISInteraction(
      {required this.context,
      required this.scaffoldKey,
      required this.studentId,
      required this.studentEmail,
      required this.classroomCourseId,
      required this.behaviour,
      required this.isCustomBehavior});

  @override
  List<Object> get props => [studentId!, classroomCourseId!, behaviour!];
}

class PBISPlusGetMoreStudentDashboardLogs extends PBISPlusEvent {
  final String studentId;
  final String classroomCourseId;
  final bool? isStudentPlus;
  List<PBISPlusStudentDashboardTotalBehaviourModal> pbisStudentInteractionList;

  PBISPlusGetMoreStudentDashboardLogs(
      {required this.pbisStudentInteractionList,
      required this.studentId,
      required this.classroomCourseId,
      required this.isStudentPlus});

  @override
  List<Object> get props => [pbisStudentInteractionList];
}
