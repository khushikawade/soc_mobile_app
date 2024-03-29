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
  final bool? isFromRecent;
  final String? recordType;
  final String? recordId;
  final String? objectName;
  //bool? isRecentRecord;
  GetRecordByID(
      {@required this.recordId,
      required this.objectName,
      required this.recordType,
      required this.isFromRecent
      //  required this.isRecentRecord
      });

  @override
  List<Object> get props => [
        recordId!, objectName!, recordType!, // isRecentRecord!
      ];

  @override
  String toString() =>
      'GlobalSearchEvent { referenceId: $recordId!,referenceTitle: ${objectName!},objectType:$recordType }';
}

class VerifyUserWithDatabase extends HomeEvent {
  final String? acountId;
  VerifyUserWithDatabase({required this.acountId});

  @override
  List<Object> get props => [acountId!];

  @override
  String toString() => 'GlobalSearchEvent { keyword: $acountId}';
}
