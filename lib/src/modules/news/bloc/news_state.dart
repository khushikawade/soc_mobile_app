part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoading2 extends NewsState {}

class NewsDataSuccess extends NewsState {
  final List<Item>? obj;
  final bool isLoading;

  NewsDataSuccess({
    this.obj,
    required this.isLoading,
  });
  NewsDataSuccess copyWith({
    final obj,
    final isLoading,
  }) {
    return NewsDataSuccess(
      obj: obj ?? this.obj,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [];
}

class NewsInitialState extends NewsState {
  final List<Item>? obj;
  NewsInitialState({
    this.obj,
  });
  NewsInitialState copyWith({
    final obj,
  }) {
    return NewsInitialState(
      obj: obj ?? this.obj,
    );
  }

  @override
  List<Object> get props => [];
}

class NewsActionSuccess extends NewsState {
  var obj;
  NewsActionSuccess({this.obj});
  NewsActionSuccess copyWith({final obj}) {
    return NewsActionSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class NewsCountLengthSuccess extends NewsState {
  final List<Item>? obj;
  NewsCountLengthSuccess({this.obj});
  NewsCountLengthSuccess copyWith({final obj}) {
    return NewsCountLengthSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class ActionCountSuccess extends NewsState {
  final List<NotificationList>? obj;
  ActionCountSuccess({this.obj});
  ActionCountSuccess copyWith({final obj}) {
    return ActionCountSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class NewsErrorReceived extends NewsState {
  final err;
  NewsErrorReceived({this.err});
  NewsErrorReceived copyWith({final err}) {
    return NewsErrorReceived(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}

class UpdatedNewsLoaded extends NewsState {
  final List<NotificationList>? obj;
  final bool isLoading;
  UpdatedNewsLoaded({this.obj, required this.isLoading});
  UpdatedNewsLoaded copyWith({final obj, final isLoading}) {
    return UpdatedNewsLoaded(
        obj: obj ?? this.obj, isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object> get props => [];
}
