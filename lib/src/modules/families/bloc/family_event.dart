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
