part of 'family_bloc.dart';

abstract class FamilyState extends Equatable {
  const FamilyState();
}

class FamilyInitial extends FamilyState {
  @override
  List<Object> get props => [];
}

class FamilyLoading extends FamilyState {
  @override
  List<Object> get props => [];
}

class ErrorLoading extends FamilyState {
  final err;
  ErrorLoading({this.err});
  ErrorLoading copyWith({final err}) {
    return ErrorLoading(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}

class FamiliesDataSuccess extends FamilyState {
  final List<SharedList>? obj;
  FamiliesDataSuccess({
    this.obj,
  });
  FamiliesDataSuccess copyWith({
    obj,
  }) {
    return FamiliesDataSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class FamiliesSublistSuccess extends FamilyState {
  final List<SharedList>? obj;

  FamiliesSublistSuccess({
    this.obj,
  });

  FamiliesSublistSuccess copyWith({
    final obj,
  }) {
    return FamiliesSublistSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class SDDataSuccess extends FamilyState {
  final Map<String, List<SDlist>> obj;
  SDDataSuccess({
    required this.obj,
  });
  SDDataSuccess copyWith({
    final obj,
  }) {
    return SDDataSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class CalendarListSuccess extends FamilyState {
  final Map<String?, List<CalendarEventList>>? pastListobj;
  final Map<String?, List<CalendarEventList>>? futureListobj;
  final List<CalendarBannerImageModal>? calendarBannerImageList;
  CalendarListSuccess(
      {this.pastListobj, this.futureListobj, this.calendarBannerImageList});

  CalendarListSuccess copyWith({
    final obj,
  }) {
    return CalendarListSuccess(
        pastListobj: obj ?? this.pastListobj,
        futureListobj: obj ?? this.futureListobj,
        calendarBannerImageList: obj ?? this.calendarBannerImageList);
  }

  @override
  List<Object> get props => [];
}
