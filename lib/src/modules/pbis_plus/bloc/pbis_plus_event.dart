part of 'pbis_plus_bloc.dart';

abstract class PBISPlusEvent extends Equatable {
  const PBISPlusEvent();
}

class PBISPlusImportRoster extends PBISPlusEvent {
  PBISPlusImportRoster();
  @override
  List<Object> get props => [];
}

class GetPBISPlusHistory extends PBISPlusEvent {
  GetPBISPlusHistory();
  @override
  List<Object> get props => [];
}
