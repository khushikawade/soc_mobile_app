// ignore_for_file: must_be_immutable

part of 'social_bloc.dart';

abstract class SocialState extends Equatable {
  const SocialState();
}

class SocialInitial extends SocialState {
  @override
  List<Object> get props => [];
}

class Loading extends SocialState {
  @override
  List<Object> get props => [];
}

class LoadingActionCount extends SocialState {
  @override
  List<Object> get props => [];
}

class SocialError extends SocialState {
  final err;
  SocialError({this.err});
  SocialError copyWith({final err}) {
    return SocialError(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}

// ignore: must_be_immutable
class SocialDataSuccess extends SocialState {
  List<Item>? obj;
  final bool isLoading;

  SocialDataSuccess({this.obj, required this.isLoading});

  SocialDataSuccess copyWith({final obj}) {
    return SocialDataSuccess(obj: obj ?? this.obj, isLoading: isLoading);
  }

  @override
  List<Object> get props => [];
}

// class SocialReload extends SocialState {
//   final List<Item>? obj;
//   final bool isLoading;

//   SocialReload({
//     this.obj,
//     required this.isLoading
//   });

//   SocialReload copyWith({
//     final obj,
//   }) {
//     return SocialReload(
//       obj: obj ?? this.obj,
//       isLoading: isLoading
//     );
//   }

//   @override
//   List<Object> get props => [];
// }

class SocialInitialState extends SocialState {
  final List<Item>? obj;

  SocialInitialState({
    this.obj,
  });

  SocialInitialState copyWith({
    final obj,
  }) {
    return SocialInitialState(
      obj: obj ?? this.obj,
    );
  }

  @override
  List<Object> get props => [];
}

class SocialActionSuccess extends SocialState {
  var obj;
  SocialActionSuccess({this.obj});
  SocialActionSuccess copyWith({final obj}) {
    return SocialActionSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class SocialActionCountSuccess extends SocialState {
  final obj;
  SocialActionCountSuccess({this.obj});
  SocialActionCountSuccess copyWith({final obj}) {
    return SocialActionCountSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class SocialErrorReceived extends SocialState {
  final err;
  SocialErrorReceived({this.err});
  SocialErrorReceived copyWith({final err}) {
    return SocialErrorReceived(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}

// class SocialListLoaded extends SocialState {
//   final List<Item>? obj;
//   final bool? isLoading;
//   final bool isFromUpdatedNewsList;

//   SocialListLoaded({
//     this.obj,
//     required this.isLoading,
//     required this.isFromUpdatedNewsList,
//   });
//   SocialListLoaded copyWith(
//       {final obj,
//       final isLoading,
//       final isFromUpdatedLoad,
//       final rfeshnewsSection}) {
//     return SocialListLoaded(
//       obj: obj ?? this.obj,
//       isLoading: isLoading ?? this.isLoading,
//       isFromUpdatedNewsList: isFromUpdatedLoad ?? this.isFromUpdatedNewsList,
//     );
//   }

//   @override
//   List<Object> get props => [];
// }
