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

class PBISPlusImportRosterSuccess extends PBISPlusState {
  final List<ClassroomCourse> googleClassroomCourseList;
  PBISPlusImportRosterSuccess({required this.googleClassroomCourseList});
  @override
  List<Object> get props => [];
}

class PBISPlusHistorySuccess extends PBISPlusState {
  final List<PBISPlusHistoryModal> pbisHistoryData;
  PBISPlusHistorySuccess({required this.pbisHistoryData});
  @override
  List<Object> get props => [];
}
