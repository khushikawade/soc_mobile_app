part of 'calender_bloc.dart';

abstract class CalenderState extends Equatable {
  const CalenderState();
}

class CalenderInitial extends CalenderState {
  @override
  List<Object> get props => [];
}

class CalenderLoading extends CalenderState {
  CalenderLoading();
  @override
  List<Object> get props => [];
}

class CalenderError extends CalenderState {
  final err;
  CalenderError({this.err});
  CalenderError copyWith({final err}) {
    return CalenderError(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}

class CalenderSuccess extends CalenderState {
  final List<Schedule> scheduleObjList;
  final List<BlackoutDate> blackoutDateobjList;
  final bool pullToRefresh;
  final UserInformation studentProfile;
  CalenderSuccess(
      {required this.scheduleObjList,
      required this.blackoutDateobjList,
      required this.pullToRefresh,
      required this.studentProfile});
  CalenderSuccess copyWith(
      {final scheduleObjList,
      final blackoutDateobjList,
      final pullToRefresh,
      final studentProfile}) {
    return CalenderSuccess(
        scheduleObjList: scheduleObjList ?? this.scheduleObjList,
        blackoutDateobjList: blackoutDateobjList ?? this.blackoutDateobjList,
        pullToRefresh: pullToRefresh ?? this.pullToRefresh,
        studentProfile: studentProfile ?? this.studentProfile);
  }

  @override
  List<Object> get props =>
      [scheduleObjList, blackoutDateobjList, pullToRefresh, studentProfile];
}

class CalenderEmptyState extends CalenderState {
  CalenderEmptyState();
  @override
  List<Object> get props => [];
}
