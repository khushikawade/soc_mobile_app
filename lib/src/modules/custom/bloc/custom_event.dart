part of 'custom_bloc.dart';

abstract class CustomEvent extends Equatable {
  const CustomEvent();
}

class CustomsEvent extends CustomEvent {
  final String? id;

  CustomsEvent({
    @required this.id,
  });
  @override
  List<Object> get props => [id!];

  @override
  String toString() => 'SocialButtonPressed';
}

class CustomSublistEvent extends CustomEvent {
  final String? id;

  CustomSublistEvent({
    @required this.id,
  });

  @override
  List<Object> get props => [id!];

  @override
  String toString() => 'GlobalSearchEvent { keyword: $id}';
}

class SDevent extends CustomEvent {
  final String? categoryId;
  SDevent({
    this.categoryId,
  });
  @override
  List<Object> get props => [categoryId!];

  @override
  String toString() => 'SDButtonPressed';
}

class CalendarListEvent extends CustomEvent {
  final String? calendarId;
  CalendarListEvent({
    this.calendarId,
  });
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Calendar';
}
