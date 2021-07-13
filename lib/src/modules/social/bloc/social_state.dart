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

class DataGettedSuccessfully extends SocialState {
  List<SocialModel>? obj;

  DataGettedSuccessfully({this.obj});

  DataGettedSuccessfully copyWith({var obj}) {
    return DataGettedSuccessfully(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

// class FetchTrainingData extends SocialState {
//   // FetchTrainingData({this.obj});

//   FetchTrainingData copyWith({var obj}) {
//     return FetchTrainingData(obj: obj ?? this.obj);
//   }

//   @override
//   List<Object> get props => [obj];
// }
