part of 'google_drive_bloc.dart';

abstract class GoogleDriveState extends Equatable {
  const GoogleDriveState();
}

class GoogleDriveInitial extends GoogleDriveState {
  @override
  List<Object> get props => [];
}

class GoogleDriveLoading extends GoogleDriveState {
  @override
  List<Object> get props => [];
}

class GoogleDriveAccountSuccess extends GoogleDriveState {
  @override
  List<Object> get props => [];
}

class GoogleDriveAccountError extends GoogleDriveState {
  @override
  List<Object> get props => [];
}
