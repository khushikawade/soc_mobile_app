part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();
  @override
  List<Object> get props => [];
}

class FetchNotificationList extends NewsEvent {
  List<Object> get props => [];
}

class FetchNotificationCount extends NewsEvent {
  List<Object> get props => [];
}
