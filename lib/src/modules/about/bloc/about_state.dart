part of 'about_bloc.dart';

abstract class AboutState extends Equatable {
  const AboutState();
}

class AboutInitial extends AboutState {
  @override
  List<Object> get props => [];
}

class AboutLoading extends AboutState {
  @override
  List<Object> get props => [];
}

class ErrorLoading extends AboutState {
  final err;
  ErrorLoading({this.err});
  ErrorLoading copyWith({final err}) {
    return ErrorLoading(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}

class AboutDataSuccess extends AboutState {
  final List<SharedList>? obj;
  AboutDataSuccess({
    this.obj,
  });
  AboutDataSuccess copyWith({
    final obj,
  }) {
    return AboutDataSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class AboutSublistSuccess extends AboutState {
  final List<SharedList>? obj;
  AboutSublistSuccess({
    this.obj,
  });
  AboutSublistSuccess copyWith({
    final obj,
  }) {
    return AboutSublistSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}
