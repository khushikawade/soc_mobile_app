part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();
  @override
  List<Object> get props => [];
}

class FetchNotificationList extends NewsEvent {
  List<Object> get props => [];
}

class NewsAction extends NewsEvent {
  final String? notificationId;
  final int? like;
  final int? thanks;
  final int? helpful;
  final int? shared;

  NewsAction(
      {required this.notificationId,
      this.like,
      this.thanks,
      this.helpful,
      this.shared});

  @override
  List<Object> get props =>
      [notificationId!, like!, thanks!, helpful!, shared!];
}

class FetchActionCountList extends NewsEvent {
  List<Object> get props => [];
}
