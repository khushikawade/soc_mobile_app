part of 'school_bloc.dart';

abstract class SchoolDirectoryEvent extends Equatable {
  const SchoolDirectoryEvent();
}

// class SchoolDirectoryListEvent extends SchoolDirectoryEvent {
//   @override
//   List<Object> get props => [];
// }
class SchoolDirectoryListEvent extends SchoolDirectoryEvent {
  final String? customerRecordId; //Custom record Id
  final bool? isSubMenu;

  SchoolDirectoryListEvent({this.customerRecordId, required this.isSubMenu});

  @override
  List<Object> get props => [customerRecordId!, isSubMenu!];
}
