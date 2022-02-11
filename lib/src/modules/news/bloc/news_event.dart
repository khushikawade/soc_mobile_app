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
  final String? notificationTitle;
  final int? like;
  final int? thanks;
  final int? helpful;
  final int? shared;

  NewsAction(
      {required this.notificationId,
      required this.notificationTitle,
      this.like,
      this.thanks,
      this.helpful,
      this.shared});

  @override
  List<Object> get props =>
      [notificationId!,notificationTitle!, like!, thanks!, helpful!, shared!];
}

class FetchActionCountList extends NewsEvent {
  final bool? isDetailPage;
  FetchActionCountList({
    required this.isDetailPage,
  });

  @override
  List<Object> get props => [isDetailPage!];
}
