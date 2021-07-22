part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class FetchBottomNavigationBar extends HomeEvent {
  List<Object> get props => [];
}

class GlobalSearchEvent extends HomeEvent {
  final String? keyword;

  GlobalSearchEvent({
    @required this.keyword,
  });

  @override
  List<Object> get props => [keyword!];

  @override
  String toString() => 'GlobalSearchEvent { keyword: $keyword}';
}
