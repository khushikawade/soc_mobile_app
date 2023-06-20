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

class PBISPlusBehaviourSucess extends PBISPlusState {
  final List<PbisPlusBehaviourList> behaviourList;

  PBISPlusBehaviourSucess({required this.behaviourList});
  PBISPlusBehaviourSucess copyWith({final behaviourListj}) {
    return PBISPlusBehaviourSucess(
        behaviourList: behaviourListj ?? this.behaviourList);
  }

  @override
  List<Object> get props => [];
}

class PBISPlusSkillsSucess extends PBISPlusState {
  final List<PBISPlusSkills> skillsList;

  PBISPlusSkillsSucess({required this.skillsList});
  PBISPlusSkillsSucess copyWith({final skillsList}) {
    return PBISPlusSkillsSucess(skillsList: skillsList ?? this.skillsList);
  }

  @override
  List<Object> get props => [];
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
  PBISPlusSkillsUpdateLoading();
  @override
  List<Object> get props => [];
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
