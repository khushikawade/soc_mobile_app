part of 'google_presentation_bloc.dart';

abstract class GoogleSlidesPresentationEvent extends Equatable {
  const GoogleSlidesPresentationEvent();
}

// class SearchStudentPresentationStudentPlus
//     extends GoogleSlidesPresentationEvent {
//   final StudentPlusDetailsModel studentDetails;
//   final String studentPlusDriveFolderId;

//   SearchStudentPresentationStudentPlus({
//     required this.studentPlusDriveFolderId,
//     required this.studentDetails,
//   });

//   @override
//   List<Object> get props => [];
// }

// class StudentPlusCreateAndUpdateNewSlidesToGooglePresentation
//     extends GoogleSlidesPresentationEvent {
//   final StudentPlusDetailsModel studentDetails;
//   final List<StudentPlusWorkModel> allRecords;
//   final String googlePresentationFileId;

//   StudentPlusCreateAndUpdateNewSlidesToGooglePresentation(
//       {required this.studentDetails,
//       required this.allRecords,
//       required this.googlePresentationFileId});

//   @override
//   List<Object> get props => [];
// }

// class GetStudentPlusWorkPresentationURL extends GoogleSlidesPresentationEvent {
//   final StudentPlusDetailsModel studentDetails;
//   final String studentPlusDriveFolderId;
//   GetStudentPlusWorkPresentationURL({
//     required this.studentPlusDriveFolderId,
//     required this.studentDetails,
//   });

//   @override
//   List<Object> get props => [];
// }

class StudentPlusCreateGooglePresentationForStudent
    extends GoogleSlidesPresentationEvent {
  final StudentPlusDetailsModel studentDetails;
  final String studentPlusDriveFolderId;
  final String filterName;
  StudentPlusCreateGooglePresentationForStudent(
      {required this.studentPlusDriveFolderId,
      required this.studentDetails,
      required this.filterName});

  @override
  List<Object> get props => [];
}

class StudentPlusUpdateGooglePresentationForStudent
    extends GoogleSlidesPresentationEvent {
  final StudentPlusDetailsModel studentDetails;
  final List<StudentPlusWorkModel> allRecords;
  StudentPlusUpdateGooglePresentationForStudent({
    required this.studentDetails,
    required this.allRecords,
  });

  @override
  List<Object> get props => [];
}
