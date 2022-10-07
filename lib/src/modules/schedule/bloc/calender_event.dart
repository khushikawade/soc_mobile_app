part of 'calender_bloc.dart';

abstract class CalenderEvent extends Equatable {
  const CalenderEvent();
}

class CalenderPageEvent extends CalenderEvent {
  final String email;
  final bool pullToRefresh;
  CalenderPageEvent({required this.email, required this.pullToRefresh});
  @override
  List<Object> get props => [email];
}
