part of 'social_bloc.dart';

abstract class SocialEvent extends Equatable {
  const SocialEvent();
}

class SocialPageEvent extends SocialEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'SocialButtonPressed';
}

class FetchActionSocailCountList extends SocialEvent {
  List<Object> get props => [];
}

class SocialAction extends SocialEvent {
  final String? guid;
   var pubDate;
  final int? like;
  final int? thanks;
  final int? helpful;
  final int? shared;

  SocialAction(
      {required this.guid,
      required this.pubDate,
      this.like,
      this.thanks,
      this.helpful,
      this.shared});

  @override
  List<Object> get props =>
      [guid!, pubDate!, like!, thanks!, helpful!, shared!];
}
