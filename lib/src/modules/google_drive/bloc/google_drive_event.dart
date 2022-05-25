part of 'google_drive_bloc.dart';

abstract class GoogleDriveEvent extends Equatable {
  const GoogleDriveEvent();
}

class CreateFolderOnGoogleDriveEvent extends GoogleDriveEvent {
  final String? token;
  final String? folderName;
  //final File? filePath;
  CreateFolderOnGoogleDriveEvent({
    required this.token,
    required this.folderName, //required this.filePath
  });

  @override
  List<Object> get props => [token!, folderName!];
}

class CreateDocOnDrive extends GoogleDriveEvent {
  final String? name;

  CreateDocOnDrive({this.name});

  @override
  List<Object> get props => [];
}

class UpdateDocOnDrive extends GoogleDriveEvent {
  final List<StudentAssessmentInfo>? studentData;
  UpdateDocOnDrive({this.studentData});
  @override
  List<Object> get props => [];
}

class GetSheetFromDrive extends GoogleDriveEvent {
  GetSheetFromDrive();

  @override
  List<Object> get props => [];
}

class GetAssessmentDetail extends GoogleDriveEvent {
  final String? fileId;
  GetAssessmentDetail({this.fileId});

  @override
  List<Object> get props => [];
}
