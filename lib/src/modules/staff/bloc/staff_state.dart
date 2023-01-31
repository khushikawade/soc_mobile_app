part of 'staff_bloc.dart';

abstract class StaffState extends Equatable {
  const StaffState();
}

class StaffInitial extends StaffState {
  @override
  List<Object> get props => [];
}

class StaffLoading extends StaffState {
  @override
  List<Object> get props => [];
}

class ErrorInStaffLoading extends StaffState {
  final err;
  ErrorInStaffLoading({this.err});
  ErrorInStaffLoading copyWith({final err}) {
    return ErrorInStaffLoading(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}

class StaffDataSuccess extends StaffState {
  final List<SharedList>? obj;
  final List<SharedList>? subFolder;

  StaffDataSuccess({this.obj, this.subFolder});

  StaffDataSuccess copyWith({final obj, final subFolder}) {
    return StaffDataSuccess(
        obj: obj ?? this.obj, subFolder: subFolder ?? this.subFolder);
  }

  @override
  List<Object> get props => [];
}

class StaffSubListSuccess extends StaffState {
  final List<SharedList>? obj;
  final List<SharedList>? subFolder;

  StaffSubListSuccess({this.obj, this.subFolder});

  StaffSubListSuccess copyWith({final obj, final subFolder}) {
    return StaffSubListSuccess(
        obj: obj ?? this.obj, subFolder: subFolder ?? this.subFolder);
  }

  @override
  List<Object> get props => [];
}
