part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NotificationList>? obj;
  NewsLoaded({this.obj});
  NewsLoaded copyWith({final obj}) {
    return NewsLoaded(obj: obj ?? this.obj);
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

class NewsCountLenghtSuccess extends NewsState {
  final List<NotificationList>? obj;
  NewsCountLenghtSuccess({this.obj});
  NewsCountLenghtSuccess copyWith({final obj}) {
    return NewsCountLenghtSuccess(obj: obj ?? this.obj);
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
