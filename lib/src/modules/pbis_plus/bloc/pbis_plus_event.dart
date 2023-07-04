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

// class AddPBISInteraction extends PBISPlusEvent {
//   final context;
//   final scaffoldKey;
//   final String? studentId;
//   final String? studentEmail;
//   final String? classroomCourseId;
//   final int? engaged;
//   final int? niceWork;
//   final int? helpful;

//   AddPBISInteraction(
//       {required this.context,
//       required this.scaffoldKey,
//       required this.studentId,
//       required this.studentEmail,
//       required this.classroomCourseId,
//       this.engaged,
//       this.niceWork,
//       this.helpful});

//   @override
//   List<Object> get props =>
//       [studentId!, classroomCourseId!, engaged!, niceWork!, helpful!];
// }

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

// class GetPBISSkillsDeleteItem extends PBISPlusEvent {
//   final PBISPlusCommonBehaviorModal item;

//   GetPBISSkillsDeleteItem({
//     required this.item,
//   });

//   @override
//   List<Object> get props => [item];
// }

// class GetPBISSkillsUpdateList extends PBISPlusEvent {
//   final PBISPlusGenricBehaviorModal item;
//   final List<PBISPlusGenricBehaviorModal> olditem;
//   int index;
//   GetPBISSkillsUpdateList(
//       {required this.item, required this.index, required this.olditem});

//   @override
//   List<Object> get props => [item, index, olditem];
// }

// ignore: must_be_immutable
class GetPBISPlusStudentNotes extends PBISPlusEvent {
  List<PBISPlusStudentList>? studentNotesList;
  GetPBISPlusStudentNotes({
    this.studentNotesList,
  });

  @override
  List<Object> get props => [studentNotesList!];
}

class GetPBISPlusStudentNotesSearchEvent extends PBISPlusEvent {
  final String searchKey;
  final List<PBISPlusStudentList> studentNotes;
  GetPBISPlusStudentNotesSearchEvent({
    required this.searchKey,
    required this.studentNotes,
  });

  @override
  List<Object> get props => [
        searchKey,
        studentNotes,
      ];
}

class GetPBISPlusStudentNotesList extends PBISPlusEvent {
  final String studentId;
  final String teacherid;
  final String dbn;
  GetPBISPlusStudentNotesList({
    required this.studentId,
    required this.teacherid,
    required this.dbn,
  });

  @override
  List<Object> get props => [studentId, teacherid, dbn];
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

  PBISPlusDeleteTeacherCustomBehavior({
    required this.behavior,
  });

  @override
  List<Object> get props => [behavior];
}

class PBISPlusAddTeacherCustomBehavior extends PBISPlusEvent {
  final PBISPlusCommonBehaviorModal behavior;
  // final List<PBISPlusCommonBehaviorModal> oldbehavior;
  final int? index;
  PBISPlusAddTeacherCustomBehavior({
    required this.behavior,
    this.index,
    //required this.oldbehavior
  });

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

  PbisPlusAddPBISInteraction(
      {required this.context,
      required this.scaffoldKey,
      required this.studentId,
      required this.studentEmail,
      required this.classroomCourseId,
      required this.behaviour});

  @override
  List<Object> get props => [studentId!, classroomCourseId!, behaviour!];
}
