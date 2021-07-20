part of 'staff_bloc.dart';

abstract class StaffState extends Equatable {
  const StaffState();
}

class StaffInitial extends StaffState {
  @override
  List<Object> get props => [];
}

class Loading extends StaffState {
  @override
  List<Object> get props => [];
}

class Errorinloading extends StaffState {
  final err;
  Errorinloading({this.err});
  Errorinloading copyWith({var err}) {
    return Errorinloading(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}

// ignore: must_be_immutable
class StaffDataSucess extends StaffState {
  List<StaffList>? obj;
  List<StaffList>? subFolder;

  StaffDataSucess({this.obj, this.subFolder});

  StaffDataSucess copyWith({var obj, var subFolder}) {
    return StaffDataSucess(
        obj: obj ?? this.obj, subFolder: subFolder ?? this.subFolder);
  }

  @override
  List<Object> get props => [];
}
