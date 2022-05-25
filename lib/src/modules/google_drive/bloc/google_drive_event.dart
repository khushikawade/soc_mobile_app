part of 'google_drive_bloc.dart';

abstract class GoogleDriveEvent extends Equatable {
  const GoogleDriveEvent();
}

class GetDriveFolderIdEvent extends GoogleDriveEvent {
  final String? token;
  final String? folderName;
  final bool?fetchHistory;
  //final File? filePath;
  GetDriveFolderIdEvent({
    required this.token,
    required this.folderName, //required this.filePath
    this.fetchHistory
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

class UpdateDocOnDrive extends GoogleDriveEvent {
  final List<StudentAssessmentInfo>? studentData;
  UpdateDocOnDrive({this.studentData});
  @override
  List<Object> get props => [];
}

class GetHistoryAssessmentFromDrive extends GoogleDriveEvent {
  GetHistoryAssessmentFromDrive();

  @override
  List<Object> get props => [];
}

class GetAssessmentDetail extends GoogleDriveEvent {
  final String? fileId;
  GetAssessmentDetail({this.fileId});

  @override
  List<Object> get props => [];
}
