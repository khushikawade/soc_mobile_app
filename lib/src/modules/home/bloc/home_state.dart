part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class BottomNavigationBarSuccess extends HomeState {
  var obj;

  BottomNavigationBarSuccess({this.obj});

  BottomNavigationBarSuccess copyWith({var obj}) {
    return BottomNavigationBarSuccess(obj: obj ?? this.obj);
  }

  @override
  List<Object> get props => [];
}

class HomeErrorReceived extends HomeState {
  final err;
  HomeErrorReceived({this.err});
  HomeErrorReceived copyWith({var err}) {
    return HomeErrorReceived(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}
