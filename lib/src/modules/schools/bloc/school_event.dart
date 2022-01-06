part of 'school_bloc.dart';

abstract class SchoolDirectoryEvent extends Equatable {
  const SchoolDirectoryEvent();
}

class SchoolDirectoryListEvent extends SchoolDirectoryEvent {
  @override
  List<Object> get props => [];
}