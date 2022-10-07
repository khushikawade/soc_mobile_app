part of 'calender_bloc.dart';

abstract class CalenderState extends Equatable {
  const CalenderState();
}

class CalenderInitial extends CalenderState {
  @override
  List<Object> get props => [];
}

class Loading extends CalenderState {
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

class CalenderSucces extends CalenderState {
  final List<Schedule> scheduleObjList;
  final List<BlackoutDate> blackoutDateobjList;
  final bool pullToRefresh;
  CalenderSucces(
      {required this.scheduleObjList,
      required this.blackoutDateobjList,
      required this.pullToRefresh});
  CalenderSucces copyWith(
      {final scheduleObjList, final blackoutDateobjList, final pullToRefresh}) {
    return CalenderSucces(
        scheduleObjList: scheduleObjList ?? this.scheduleObjList,
        blackoutDateobjList: blackoutDateobjList ?? this.blackoutDateobjList,
        pullToRefresh: pullToRefresh ?? this.pullToRefresh);
  }

  @override
  List<Object> get props => [scheduleObjList];
}
