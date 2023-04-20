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
