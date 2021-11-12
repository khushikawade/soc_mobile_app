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
  final String? schoolId;
  final String? like;
  final String? thanks;
  final String? helpful;
  final String? shared;

  NewsAction(
      {required this.notificationId,
      required this.schoolId,
      this.like,
      this.thanks,
      this.helpful,
      this.shared});

  @override
  List<Object> get props =>
      [notificationId!, schoolId!, like!, thanks!, helpful!, shared!];
}

class FetchActionCountList extends NewsEvent {
  List<Object> get props => [];
}
