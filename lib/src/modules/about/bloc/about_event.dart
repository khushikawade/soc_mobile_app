part of 'about_bloc.dart';

abstract class AboutEvent extends Equatable {
  const AboutEvent();
}

class AboutStaffDirectoryEvent extends AboutEvent {
  @override
  List<Object> get props => [];

  // @override
  // String toString() => 'AboutButtonPressed';
}

class AboutSublistEvent extends AboutEvent {
  final String? id;

  AboutSublistEvent({
    @required this.id,
  });
  @override
  List<Object> get props => [id!];
  @override
  String toString() => 'GlobalSearchEvent { keyword: $id}';
}

class SDevent extends AboutEvent {
  @override
  List<Object> get props => [];
  @override
  String toString() => 'SocialButtonPressed';
}

class CalendarListEvent extends AboutEvent {
  @override
  List<Object> get props => [];
  @override
  String toString() => 'Calendar';
}
