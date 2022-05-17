part of 'google_drive_bloc.dart';

abstract class GoogleDriveEvent extends Equatable {
  const GoogleDriveEvent();
}

class CreateFolderOnGoogleDriveEvent extends GoogleDriveEvent {
  final String? token;
  final String? folderName;
  CreateFolderOnGoogleDriveEvent(
      {required this.token, required this.folderName});

  @override
  List<Object> get props => [token!, folderName!];
}

class CreateDoc extends GoogleDriveEvent {
  // final String? token;
  // final String? folderName;
  CreateDoc();

  @override
  List<Object> get props => [];
}
