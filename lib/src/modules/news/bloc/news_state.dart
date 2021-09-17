part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  List<NotificationList>? obj;

  NewsLoaded({this.obj});

  NewsLoaded copyWith({final obj}) {
    return NewsLoaded(obj: obj ?? this.obj);
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
