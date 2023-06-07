part of 'google _slides_presentation_bloc.dart';

abstract class GoogleSlidesPresentationState extends Equatable {
  const GoogleSlidesPresentationState();
}

class GoogleSlidesPresentationInitial extends GoogleSlidesPresentationState {
  @override
  List<Object> get props => [];
}

class StudentPlusGooglePresentationIsAvailableSuccess
    extends GoogleSlidesPresentationState {
  final String googlePresentationFileId;
  StudentPlusGooglePresentationIsAvailableSuccess(
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

class StudentPlusUpdateNewSldiesOnGooglePresentationSuccess
    extends GoogleSlidesPresentationState {
  StudentPlusUpdateNewSldiesOnGooglePresentationSuccess();

  @override
  List<Object> get props => [];
}

class StudentPlusGetGooglePresentationSuccess
    extends GoogleSlidesPresentationState {
  final String googlePresentationFileUrl;

  StudentPlusGetGooglePresentationSuccess(
      {required this.googlePresentationFileUrl});

  @override
  List<Object> get props => [];
}

class StudentPlusGooglePresentationLoading
    extends GoogleSlidesPresentationState {
  StudentPlusGooglePresentationLoading();

  @override
  List<Object> get props => [];
}
