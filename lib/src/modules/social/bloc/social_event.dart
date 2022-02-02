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

class FetchSocialActionCount extends SocialEvent {
  final bool? isDetailPage;

  FetchSocialActionCount({
    required this.isDetailPage,
  });
  List<Object> get props => [isDetailPage!];
}

class SocialAction extends SocialEvent {
  final String? id;
  final int? like;
  final int? thanks;
  final int? helpful;
  final int? shared;

  SocialAction(
      {required this.id, this.like, this.thanks, this.helpful, this.shared});

  @override
  List<Object> get props => [id!, like!, thanks!, helpful!, shared!];
}
