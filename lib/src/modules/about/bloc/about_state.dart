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

// ignore: must_be_immutable
class AboutDataSucess extends AboutState {
  List<AboutList>? obj;
  AboutDataSucess({
    this.obj,
  });
  AboutDataSucess copyWith({
    final obj,
  }) {
    return AboutDataSucess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}


class AboutSublistSucess extends AboutState {
  List<AboutSubList>? obj;
  AboutSublistSucess({
    this.obj,
  });
  AboutSublistSucess copyWith({
    final obj,
  }) {
    return AboutSublistSucess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}