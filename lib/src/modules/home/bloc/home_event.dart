part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class FetchStandardNavigationBar extends HomeEvent {
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

class GlobalSearchEventOffline extends HomeEvent {
  final String? keyword;
  GlobalSearchEventOffline({
    @required this.keyword,
  });

  @override
  List<Object> get props => [keyword!];

  @override
  String toString() => 'GlobalSearchEvent { keyword: $keyword}';
}

class GetRecordByID extends HomeEvent {
  final String ?recordType;
  final String? recordId;
  final String? objectName;

  GetRecordByID(
      {@required this.recordId, required this.objectName, required this.recordType});

  @override
  List<Object> get props => [recordId!, objectName!,recordType!];

  @override
  String toString() =>
      'GlobalSearchEvent { referenceId: $recordId!,referenceTitle: ${objectName!},objectType:$recordType }';
}
