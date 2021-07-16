part of 'social_bloc.dart';

abstract class SocialState extends Equatable {
  const SocialState();
}

class SocialInitial extends SocialState {
  @override
  List<Object> get props => [];
}

class Loading extends SocialState {
  @override
  List<Object> get props => [];
}

class Errorinloading extends SocialState {
  final err;
  Errorinloading({this.err});
  Errorinloading copyWith({var err}) {
    return Errorinloading(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}

// ignore: must_be_immutable
class SocialDataSucess extends SocialState {
  List<Item>? obj;

  SocialDataSucess({this.obj});

  SocialDataSucess copyWith({var obj}) {
    return SocialDataSucess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}
