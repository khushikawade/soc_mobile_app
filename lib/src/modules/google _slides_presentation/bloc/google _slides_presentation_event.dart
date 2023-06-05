part of 'google _slides_presentation_bloc.dart';

abstract class GoogleSlidesPresentationEvent extends Equatable {
  const GoogleSlidesPresentationEvent();
}

class StudentPlusGooglePresentationIsAvailable
    extends GoogleSlidesPresentationEvent {
  final StudentPlusDetailsModel studentDetails;
  final String stduentPlusDriveFolderId;

  StudentPlusGooglePresentationIsAvailable({
    required this.stduentPlusDriveFolderId,
    required this.studentDetails,
  });

  @override
  List<Object> get props => [];
}

class StudentPlusUpdateNewSldiesOnGooglePresentation
    extends GoogleSlidesPresentationEvent {
  final StudentPlusDetailsModel studentDetails;
  final List<StudentPlusWorkModel> allrecords;
  final String googlePresentationFileId;

  StudentPlusUpdateNewSldiesOnGooglePresentation(
      {required this.studentDetails,
      required this.allrecords,
      required this.googlePresentationFileId});

  @override
  List<Object> get props => [];
}
