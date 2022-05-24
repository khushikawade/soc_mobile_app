part of 'google_drive_bloc.dart';

abstract class GoogleDriveEvent extends Equatable {
  const GoogleDriveEvent();
}

class GetDriveFolderIdEvent extends GoogleDriveEvent {
  final String? token;
  final String? folderName;
  //final File? filePath;
  GetDriveFolderIdEvent({
    required this.token,
    required this.folderName, //required this.filePath
  });

  @override
  List<Object> get props => [token!, folderName!];
}

class CreateExcelSheetToDrive extends GoogleDriveEvent {
  final String? name;
  CreateExcelSheetToDrive({this.name});
  @override
  List<Object> get props => [];
}

class GetHistoryAssessmentFromDrive extends GoogleDriveEvent {
  GetHistoryAssessmentFromDrive();
  @override
  List<Object> get props => [];
}
