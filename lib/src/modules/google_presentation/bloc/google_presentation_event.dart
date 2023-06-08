part of 'google_presentation_bloc.dart';

abstract class GoogleSlidesPresentationEvent extends Equatable {
  const GoogleSlidesPresentationEvent();
}

class SearchStudentPresentationStudentPlus
    extends GoogleSlidesPresentationEvent {
  final StudentPlusDetailsModel studentDetails;
  final String studentPlusDriveFolderId;

  SearchStudentPresentationStudentPlus({
    required this.studentPlusDriveFolderId,
    required this.studentDetails,
  });

  @override
  List<Object> get props => [];
}

class StudentPlusCreateAndUpdateNewSlidesToGooglePresentation
    extends GoogleSlidesPresentationEvent {
  final StudentPlusDetailsModel studentDetails;
  final List<StudentPlusWorkModel> allRecords;
  final String googlePresentationFileId;

  StudentPlusCreateAndUpdateNewSlidesToGooglePresentation(
      {required this.studentDetails,
      required this.allRecords,
      required this.googlePresentationFileId});

  @override
  List<Object> get props => [];
}

class GetStudentPlusPresentationURL extends GoogleSlidesPresentationEvent {
  final StudentPlusDetailsModel studentDetails;
  final String studentPlusDriveFolderId;
  GetStudentPlusPresentationURL({
    required this.studentPlusDriveFolderId,
    required this.studentDetails,
  });

  @override
  List<Object> get props => [];
}
