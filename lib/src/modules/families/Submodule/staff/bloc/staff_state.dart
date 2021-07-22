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

class ErrorLoading extends StaffState {
  final err;
  ErrorLoading({this.err});
  ErrorLoading copyWith({var err}) {
    return ErrorLoading(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}

// ignore: must_be_immutable
class StaffDataSucess extends StaffState {
  List<Stafflist>? obj;
  StaffDataSucess({
    this.obj,
  });
  StaffDataSucess copyWith({
    var obj,
  }) {
    return StaffDataSucess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class StaffsublistSucess extends StaffState {
  List<Staffsublist>? obj;

  StaffsublistSucess({
    this.obj,
  });

  StaffsublistSucess copyWith({
    var obj,
  }) {
    return StaffsublistSucess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}
