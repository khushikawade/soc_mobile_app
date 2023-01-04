part of 'calender_bloc.dart';

abstract class CalenderEvent extends Equatable {
  const CalenderEvent();
}

class CalenderPageEvent extends CalenderEvent {
  final UserInformation studentProfile;
  final bool pullToRefresh;
  var isFromStudent;
  CalenderPageEvent(
      {required this.studentProfile,
      required this.pullToRefresh,
      this.isFromStudent});
  @override
  List<Object> get props => [studentProfile];
}
