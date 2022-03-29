part of 'social_bloc.dart';

abstract class SocialEvent extends Equatable {
  const SocialEvent();
}

class SocialPageEvent extends SocialEvent {
  final String? action;

  SocialPageEvent({required this.action});

  List<Object> get props => [action!];
}

// class FetchSocialActionCount extends SocialEvent {
//   final bool? isDetailPage;

//   FetchSocialActionCount({
//     required this.isDetailPage,
//   });
//   List<Object> get props => [isDetailPage!];
// }

class SocialAction extends SocialEvent {
  final String? id;
  final String? title;
  final int? like;
  final int? thanks;
  final int? helpful;
  final int? shared;

  SocialAction(
      {required this.id,
      required this.title,
      this.like,
      this.thanks,
      this.helpful,
      this.shared});

  @override
  List<Object> get props => [id!, title!, like!, thanks!, helpful!, shared!];
}
