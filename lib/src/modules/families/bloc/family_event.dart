part of 'family_bloc.dart';

abstract class FamilyEvent extends Equatable {
  const FamilyEvent();
}

class FamiliesEvent extends FamilyEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'SocialButtonPressed';
}

class FamiliesSublistEvent extends FamilyEvent {
  final String? id;

  FamiliesSublistEvent({
    @required this.id,
  });

  @override
  List<Object> get props => [id!];

  @override
  String toString() => 'GlobalSearchEvent { keyword: $id}';
}

class SDevent extends FamilyEvent {
  final String? categoryId;
  SDevent({
    this.categoryId,
  });
  @override
  List<Object> get props => [categoryId!];

  @override
  String toString() => 'SDButtonPressed';
}

class CalendarListEvent extends FamilyEvent {
  String ?calendarId;
  CalendarListEvent(this.calendarId);
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Calendar';
}
