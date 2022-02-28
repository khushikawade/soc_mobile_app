part of 'custom_bloc.dart';

abstract class CustomState extends Equatable {
  const CustomState();
}

class CustomInitial extends CustomState {
  @override
  List<Object> get props => [];
}

class CustomLoading extends CustomState {
  @override
  List<Object> get props => [];
}

class ErrorLoading extends CustomState {
  final err;
  ErrorLoading({this.err});
  ErrorLoading copyWith({final err}) {
    return ErrorLoading(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}

// ignore: must_be_immutable
class CustomDataSucess extends CustomState {
  List<SharedList>? obj;
  CustomDataSucess({
    this.obj,
  });
  CustomDataSucess copyWith({
    obj,
  }) {
    return CustomDataSucess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class CustomSublistSuccess extends CustomState {
  List<SharedList>? obj;

  CustomSublistSuccess({
    this.obj,
  });

  CustomSublistSuccess copyWith({
    final obj,
  }) {
    return CustomSublistSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class SDDataSuccess extends CustomState {
  List<SDlist>? obj;
  SDDataSuccess({
    this.obj,
  });
  SDDataSuccess copyWith({
    final obj,
  }) {
    return SDDataSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class CalendarListSuccess extends CustomState {
  List<CalendarEventList>? pastListobj;
  List<CalendarEventList>? futureListobj;
  CalendarListSuccess({this.pastListobj, this.futureListobj});
  CalendarListSuccess copyWith({
    final obj,
  }) {
    return CalendarListSuccess(
        pastListobj: obj ?? this.pastListobj,
        futureListobj: obj ?? this.futureListobj);
  }

  @override
  List<Object> get props => [];
}
