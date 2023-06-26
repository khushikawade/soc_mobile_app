part of 'pbis_plus_bloc.dart';

abstract class PBISPlusState extends Equatable {
  const PBISPlusState();
}

class PBISPlusInitial extends PBISPlusState {
  @override
  List<Object> get props => [];
}

class PBISPlusLoading extends PBISPlusState {
  @override
  List<Object> get props => [];
}

class PBISErrorState extends PBISPlusState {
  final error;
  PBISErrorState({
    this.error,
  });
  @override
  List<Object> get props => [];
}

class PBISPlusImportRosterSuccess extends PBISPlusState {
  final List<ClassroomCourse> googleClassroomCourseList;
  PBISPlusImportRosterSuccess({required this.googleClassroomCourseList});
  @override
  List<Object> get props => [];
}

class AddPBISInteractionSuccess extends PBISPlusState {
  final obj;
  AddPBISInteractionSuccess({this.obj});
  AddPBISInteractionSuccess copyWith({final obj}) {
    return AddPBISInteractionSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}
// class PBISPlusTotalInteractionByTeacherSuccess extends PBISPlusState {
//   final List<PBISPlusTotalInteractionByTeacherModal> pbisTotalInteractionList;
//   PBISPlusTotalInteractionByTeacherSuccess(
//       {required this.pbisTotalInteractionList});
//   @override
//   List<Object> get props => [];
// }

class PBISPlusHistorySuccess extends PBISPlusState {
  final List<PBISPlusHistoryModal> pbisHistoryList;
  List<PBISPlusHistoryModal> pbisClassroomHistoryList;
  List<PBISPlusHistoryModal> pbisSheetHistoryList;
  PBISPlusHistorySuccess(
      {required this.pbisHistoryList,
      required this.pbisClassroomHistoryList,
      required this.pbisSheetHistoryList});
  @override
  List<Object> get props => [];
}

class AddPBISHistorySuccess extends PBISPlusState {
  AddPBISHistorySuccess();
  @override
  List<Object> get props => [];
}

/* --------------------- state to return student details -------------------- */
class PBISPlusStudentDashboardLogSuccess extends PBISPlusState {
  final List<PBISPlusTotalInteractionModal> pbisStudentInteractionList;
  PBISPlusStudentDashboardLogSuccess(
      {required this.pbisStudentInteractionList});
  @override
  List<Object> get props => [];
}

class PBISPlusResetSuccess extends PBISPlusState {
  PBISPlusResetSuccess();
  @override
  List<Object> get props => [];
}

class PBISPlusInitialImportRosterSuccess extends PBISPlusState {
  final List<ClassroomCourse> googleClassroomCourseList;
  PBISPlusInitialImportRosterSuccess({required this.googleClassroomCourseList});
  @override
  List<Object> get props => [];
}

class PBISPlusClassRoomShimmerLoading extends PBISPlusState {
  final List<ClassroomCourse> shimmerCoursesList;
  PBISPlusClassRoomShimmerLoading({required this.shimmerCoursesList});
  @override
  List<Object> get props => [];
}

class PbisPlusAdditionalBehaviourSuccess extends PBISPlusState {
  final List<PBISPlusGenricBehaviourModal> additionalbehaviourList;

  PbisPlusAdditionalBehaviourSuccess({required this.additionalbehaviourList});
  PbisPlusAdditionalBehaviourSuccess copyWith({final additionalbehaviourList}) {
    return PbisPlusAdditionalBehaviourSuccess(
        additionalbehaviourList: additionalbehaviourList ?? this.additionalbehaviourList);
  }

  @override
  List<Object> get props => [];
}

class PBISPlusSkillsSucess extends PBISPlusState {
  final List<PBISPlusGenricBehaviourModal> skillsList;

  PBISPlusSkillsSucess({required this.skillsList});
  PBISPlusSkillsSucess copyWith({final skillsList}) {
    return PBISPlusSkillsSucess(skillsList: skillsList ?? this.skillsList);
  }

  @override
  List<Object> get props => [skillsList];
}

class PBISPlusSkillsLoading extends PBISPlusState {
  PBISPlusSkillsLoading();
  @override
  List<Object> get props => [];
}

class PBISPlusSkillsError extends PBISPlusState {
  final error;

  PBISPlusSkillsError({required this.error});
  PBISPlusSkillsError copyWith({final error}) {
    return PBISPlusSkillsError(error: error ?? this.error);
  }

  @override
  List<Object> get props => [];
}

class PBISPlusSkillsUpdateLoading extends PBISPlusState {
  final List<PBISPlusGenricBehaviourModal> skillsList;

  PBISPlusSkillsUpdateLoading({required this.skillsList});
  PBISPlusSkillsUpdateLoading copyWith({final skillsList}) {
    return PBISPlusSkillsUpdateLoading(
        skillsList: skillsList ?? this.skillsList);
  }

  @override
  List<Object> get props => [skillsList];
}

class PBISPlusSkillsUpdateError extends PBISPlusState {
  PBISPlusSkillsUpdateError();
  @override
  List<Object> get props => [];
}

class PBISPlusSkillsDeleteLoading extends PBISPlusState {
  PBISPlusSkillsDeleteLoading();
  @override
  List<Object> get props => [];
}

class GetPBISSkillsUpdateNameLoading extends PBISPlusState {
  GetPBISSkillsUpdateNameLoading();
  @override
  List<Object> get props => [];
}

class PBISPlusSkillsDeleteError extends PBISPlusState {
  PBISPlusSkillsDeleteError();
  @override
  List<Object> get props => [];
}

class PBISPlusSkillsListUpdateError extends PBISPlusState {
  PBISPlusSkillsListUpdateError();
  @override
  List<Object> get props => [];
}

class PBISPlusStudentNotesShimmer extends PBISPlusState {
  PBISPlusStudentNotesShimmer();
  @override
  List<Object> get props => [];
}

class PBISPlusStudentNotesSucess extends PBISPlusState {
  final List<PBISPlusStudentNotes> studentNotes;

  PBISPlusStudentNotesSucess({required this.studentNotes});
  PBISPlusStudentNotesSucess copyWith({final studentNotes}) {
    return PBISPlusStudentNotesSucess(
        studentNotes: studentNotes ?? this.studentNotes);
  }

  @override
  List<Object> get props => [];
}

class PBISPlusStudentNotesError extends PBISPlusState {
  final error;

  PBISPlusStudentNotesError({required this.error});
  PBISPlusStudentNotesError copyWith({final error}) {
    return PBISPlusStudentNotesError(error: error ?? this.error);
  }

  @override
  List<Object> get props => [];
}

class GetPBISPlusAdditionalBehaviourLoading extends PBISPlusState {
  GetPBISPlusAdditionalBehaviourLoading();
  @override
  List<Object> get props => [];
}
