part of 'school_bloc.dart';

abstract class SchoolDirectoryState extends Equatable {
  const SchoolDirectoryState();
}

class SchoolDirectoryInitial extends SchoolDirectoryState {
  @override
  List<Object> get props => [];
}

class SchoolDirectoryLoading extends SchoolDirectoryState {
  @override
  List<Object> get props => [];
}

class SchoolDirectoryErrorLoading extends SchoolDirectoryState {
  final err;
  SchoolDirectoryErrorLoading({this.err});
  SchoolDirectoryErrorLoading copyWith({final err}) {
    return SchoolDirectoryErrorLoading(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}

class SchoolDirectoryDataSuccess extends SchoolDirectoryState {
  final List<SchoolDirectoryList>? obj;
  SchoolDirectoryDataSuccess({
    this.obj,
  });
  SchoolDirectoryDataSuccess copyWith({
    final obj,
  }) {
    return SchoolDirectoryDataSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}
