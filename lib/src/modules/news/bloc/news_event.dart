part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();
  @override
  List<Object> get props => [];
}

class FetchNotificationList extends NewsEvent {
  List<Object> get props => [];
}

class NewsCountLength extends NewsEvent {
  List<Object> get props => [];
}

class NewsAction extends NewsEvent {
  final context;
  final scaffoldKey;
  final String? notificationId;
  final String? notificationTitle;
  final int? like;
  final int? thanks;
  final int? helpful;
  final int? shared;
  final int? support;
  NewsAction(
      {required this.notificationId,
      required this.notificationTitle,
      this.like,
      this.thanks,
      this.helpful,
      this.shared,
      required this.context,
      required this.scaffoldKey,
      this.support});

  @override
  List<Object> get props =>
      [notificationId!, notificationTitle!, like!, thanks!, helpful!, shared!];
}

class FetchActionCountList extends NewsEvent {
  final bool? isDetailPage;
  FetchActionCountList({
    required this.isDetailPage,
  });

  @override
  List<Object> get props => [isDetailPage!];
}

class UpdateNotificationList extends NewsEvent {
  final List<NotificationList>? list;
  UpdateNotificationList({this.list});
  List<Object> get props => [];
}

