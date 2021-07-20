part of 'staff_bloc.dart';

abstract class StaffEvent extends Equatable {
  const StaffEvent();
}

class StaffPageEvent extends StaffEvent {
  @override
  List<Object> get props => [];

  // @override
  // String toString() => 'StaffButtonPressed';
}

class StaffSubListData extends StaffEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'SocialButtonPressed';
}
