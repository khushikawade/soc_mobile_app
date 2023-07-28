part of 'google_presentation_bloc.dart';

abstract class GoogleSlidesPresentationState extends Equatable {
  const GoogleSlidesPresentationState();
}

class GoogleSlidesPresentationInitial extends GoogleSlidesPresentationState {
  @override
  List<Object> get props => [];
}

class StudentPlusGooglePresentationSearchSuccess
    extends GoogleSlidesPresentationState {
  final String googlePresentationFileId;
  StudentPlusGooglePresentationSearchSuccess(
      {required this.googlePresentationFileId});

  @override
  List<Object> get props => [];
}

class GoogleSlidesPresentationErrorState extends GoogleSlidesPresentationState {
  final String? errorMsg;

  GoogleSlidesPresentationErrorState({
    this.errorMsg,
  });
  @override
  List<Object> get props => [];
}

class StudentPlusCreateAndUpdateSlideSuccess
    extends GoogleSlidesPresentationState {
  StudentPlusCreateAndUpdateSlideSuccess();

  @override
  List<Object> get props => [];
}

class GetGooglePresentationURLSuccess extends GoogleSlidesPresentationState {
  final String googlePresentationFileUrl;

  GetGooglePresentationURLSuccess({required this.googlePresentationFileUrl});

  @override
  List<Object> get props => [];
}

class GooglePresentationLoading extends GoogleSlidesPresentationState {
  GooglePresentationLoading();

  @override
  List<Object> get props => [];
}

class StudentPlusCreateStudentWorkGooglePresentationSuccess
    extends GoogleSlidesPresentationState {
  final String googlePresentationFileId;
  StudentPlusCreateStudentWorkGooglePresentationSuccess(
      {required this.googlePresentationFileId});

  @override
  List<Object> get props => [];
}

class StudentPlusUpdateStudentWorkGooglePresentationSuccess
    extends GoogleSlidesPresentationState {
  final StudentPlusDetailsModel studentDetails;
  //isSaveStudentGooglePresentationWorkOnDataBase //Require to manage API call on UI to either(true) need to save or not(false)
  final bool isSaveStudentGooglePresentationWorkOnDataBase;
  StudentPlusUpdateStudentWorkGooglePresentationSuccess(
      {required this.studentDetails,
      required this.isSaveStudentGooglePresentationWorkOnDataBase});

  @override
  List<Object> get props => [];
}
