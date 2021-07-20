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
  ErrorLoading copyWith({var err}) {
    return ErrorLoading(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}

// ignore: must_be_immutable
class FamiliesDataSucess extends FamilyState {
  List<FamiliesList>? obj;
  FamiliesDataSucess({
    this.obj,
  });
  FamiliesDataSucess copyWith({
    var obj,
  }) {
    return FamiliesDataSucess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class FamiliesSublistSucess extends FamilyState {
  List<FamiliesSubList>? obj;

  FamiliesSublistSucess({
    this.obj,
  });

  FamiliesSublistSucess copyWith({
    var obj,
  }) {
    return FamiliesSublistSucess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}
