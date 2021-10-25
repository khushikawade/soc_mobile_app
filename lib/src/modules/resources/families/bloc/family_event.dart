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

// class SDevent extends FamilyEvent {
//   @override
//   List<Object> get props => [];

//   @override
//   String toString() => 'SocialButtonPressed';
// }

// class CalendarListEvent extends FamilyEvent {
//   @override
//   List<Object> get props => [];

//   @override
//   String toString() => 'Calendar';
// }
