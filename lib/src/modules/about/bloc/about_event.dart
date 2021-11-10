part of 'about_bloc.dart';

abstract class AboutEvent extends Equatable {
  const AboutEvent();
}

class AboutStaffDirectoryEvent extends AboutEvent {
  @override
  List<Object> get props => [];
}

