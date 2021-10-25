part of 'staff_bloc.dart';

abstract class StaffEvent extends Equatable {
  const StaffEvent();
}

class StaffPageEvent extends StaffEvent {
  @override
  List<Object> get props => [];
}

class StaffSubListEvent extends StaffEvent {
  final String? id;

  StaffSubListEvent({
    @required this.id,
  });

  @override
  List<Object> get props => [id!];

  @override
  String toString() => 'GlobalSearchEvent { keyword: $id}';
}
