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
  PBISErrorState({this.error});
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
  final bool? isLoading;
  final List<PBISPlusStudentDashboardTotalBehaviourModal>
      pbisStudentInteractionList;
  PBISPlusStudentDashboardLogSuccess(
      {required this.pbisStudentInteractionList, this.isLoading = false});
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

class PBISPlusAdditionalBehaviorSuccess extends PBISPlusState {
  final List<PBISPlusCommonBehaviorModal> additionalBehaviorList;

  PBISPlusAdditionalBehaviorSuccess({required this.additionalBehaviorList});
  PBISPlusAdditionalBehaviorSuccess copyWith({final additionalBehaviorList}) {
    return PBISPlusAdditionalBehaviorSuccess(
        additionalBehaviorList:
            additionalBehaviorList ?? this.additionalBehaviorList);
  }

  @override
  List<Object> get props => [];
}

// class PBISPlusDefaultBehaviorError extends PBISPlusState {
//   final error;

//   PBISPlusDefaultBehaviorError({required this.error});
//   PBISPlusDefaultBehaviorError copyWith({final error}) {
//     return PBISPlusDefaultBehaviorError(error: error ?? this.error);
//   }

//   @override
//   List<Object> get props => [];
// }

class PBISPlusSkillsUpdateError extends PBISPlusState {
  PBISPlusSkillsUpdateError();
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

class PBISPlusStudentNotesSucess extends PBISPlusState {
  final List<PBISPlusNotesUniqueStudentList> studentNotes;
  PBISPlusStudentNotesSucess({required this.studentNotes});
  PBISPlusStudentNotesSucess copyWith({final studentNotes}) {
    return PBISPlusStudentNotesSucess(
        studentNotes: studentNotes ?? this.studentNotes);
  }

  @override
  List<Object> get props => [studentNotes];
}

// class GetPBISPlusStudentsListNoData extends PBISPlusState {
//   final error;

//   GetPBISPlusStudentsListNoData({required this.error});
//   GetPBISPlusStudentsListNoData copyWith({final error}) {
//     return GetPBISPlusStudentsListNoData(error: error ?? this.error);
//   }

//   @override
//   List<Object> get props => [];
// }

// class PBISPlusAdditionalBehaviorError extends PBISPlusState {
//   final error;
//   PBISPlusAdditionalBehaviorError({
//     this.error,
//   });
//   @override
//   List<Object> get props => [];
// }

class PBISPlusGetDefaultSchoolBehaviorSuccess extends PBISPlusState {
  final List<PBISPlusCommonBehaviorModal> defaultSchoolBehaviorList;
  final String? caughtError;

  PBISPlusGetDefaultSchoolBehaviorSuccess(
      {required this.defaultSchoolBehaviorList, this.caughtError});

  @override
  List<Object> get props => [defaultSchoolBehaviorList];
}

class PBISPlusGetTeacherCustomBehaviorSuccess extends PBISPlusState {
  final String? caughtError;
  final List<PBISPlusCommonBehaviorModal> teacherCustomBehaviorList;

  PBISPlusGetTeacherCustomBehaviorSuccess(
      {required this.teacherCustomBehaviorList, this.caughtError});

  @override
  List<Object> get props => [teacherCustomBehaviorList];
}

class PBISPlusBehaviorLoading extends PBISPlusState {
  final List<PBISPlusCommonBehaviorModal> demoBehaviorData;

  PBISPlusBehaviorLoading({required this.demoBehaviorData});

  @override
  List<Object> get props => [demoBehaviorData];
}

class PBISPlusStudentSearchSucess extends PBISPlusState {
  final List<PBISPlusNotesUniqueStudentList> sortedList;
  PBISPlusStudentSearchSucess({required this.sortedList});
  PBISPlusStudentSearchSucess copyWith({final studentNotes}) {
    return PBISPlusStudentSearchSucess(
        sortedList: studentNotes ?? this.sortedList);
  }

  @override
  List<Object> get props => [];
}

class PBISPlusNotesSucess extends PBISPlusState {
  final List<PBISStudentNotes> notesList;
  PBISPlusNotesSucess({required this.notesList});
  PBISPlusNotesSucess copyWith({final notesList}) {
    return PBISPlusNotesSucess(notesList: notesList ?? this.notesList);
  }

  @override
  List<Object> get props => [];
}

// class GetPBISPlusStudentAllNotesListError extends PBISPlusState {
//   final String error;
//   GetPBISPlusStudentAllNotesListError({required this.error});
//   GetPBISPlusStudentAllNotesListError copyWith({final error}) {
//     return GetPBISPlusStudentAllNotesListError(error: error ?? this.error);
//   }

//   @override
//   List<Object> get props => [error];
// }

class PBISPlusStudentListSucess extends PBISPlusState {
  final List<PBISPlusNotesUniqueStudentList> studentList;
  PBISPlusStudentListSucess({required this.studentList});
  PBISPlusStudentListSucess copyWith({final studentList}) {
    return PBISPlusStudentListSucess(
        studentList: studentList ?? this.studentList);
  }

  @override
  List<Object> get props => [studentList];
}

class PBISPlusAddNotesSucess extends PBISPlusState {
  PBISPlusAddNotesSucess();
  PBISPlusAddNotesSucess copyWith({final note}) {
    return PBISPlusAddNotesSucess();
  }

  @override
  List<Object> get props => [];
}

// class PBISPlusAddNotesError extends PBISPlusState {
//   final String error;
//   PBISPlusAddNotesError({required this.error});
//   PBISPlusAddNotesError copyWith({final error}) {
//     return PBISPlusAddNotesError(error: error ?? this.error);
//   }

//   @override
//   List<Object> get props => [error];
// }
class PBISPlusGetStudentBehaviorByCourseSuccess extends PBISPlusState {
  ClassroomCourse classroomCourse;
  PBISPlusGetStudentBehaviorByCourseSuccess({required this.classroomCourse});

  @override
  List<Object> get props => [];
}
