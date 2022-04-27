part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class SearchLoading extends HomeState {}

class RefrenceSearchLoading extends HomeState {}

class BottomNavigationBarSuccess extends HomeState {
  final obj;
  BottomNavigationBarSuccess({this.obj});
  BottomNavigationBarSuccess copyWith({final obj}) {
    return BottomNavigationBarSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class GlobalSearchSuccess extends HomeState {
  final obj;
  GlobalSearchSuccess({this.obj});
  GlobalSearchSuccess copyWith({final obj}) {
    return GlobalSearchSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class HomeErrorReceived extends HomeState {
  final err;
  HomeErrorReceived({this.err});
  HomeErrorReceived copyWith({final err}) {
    return HomeErrorReceived(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}

class ReferenceGlobalSearchSucess extends HomeState {
  final String? objectName;
  final String? objectType;
  final obj;
  ReferenceGlobalSearchSucess({this.obj, this.objectName, this.objectType});
  ReferenceGlobalSearchSucess copyWith(
      {final obj, final objectName, final objectType}) {
    return ReferenceGlobalSearchSucess(
        obj: obj ?? this.obj,
        objectName: objectName ?? this.objectName,
        objectType: objectType ?? this.objectType);
  }
}
