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

class SocialError extends SocialState {
  final err;
  SocialError({this.err});
  SocialError copyWith({final err}) {
    return SocialError(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}

// ignore: must_be_immutable
class SocialDataSucess extends SocialState {
  List<Item>? obj;

  SocialDataSucess({this.obj});

  SocialDataSucess copyWith({final obj}) {
    return SocialDataSucess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class SocialActionSuccess extends SocialState {
  var obj;
  SocialActionSuccess({this.obj});
  SocialActionSuccess copyWith({final obj}) {
    return SocialActionSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class SocialActionCountSuccess extends SocialState {
  final obj;
  SocialActionCountSuccess({this.obj});
  SocialActionCountSuccess copyWith({final obj}) {
    return SocialActionCountSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class SocialErrorReceived extends SocialState {
  final err;
  SocialErrorReceived({this.err});
  SocialErrorReceived copyWith({final err}) {
    return SocialErrorReceived(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}