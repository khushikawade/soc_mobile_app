part of 'ocr_bloc.dart';

abstract class OcrState extends Equatable {
  const OcrState();
  @override
  List<Object> get props => [];
}

class OcrInitial extends OcrState {}

class OcrLoading extends OcrState {}

class SearchLoading extends OcrState {}

class FetchTextFromImageSuccess extends OcrState {
  String? schoolId;
  String? grade;
  FetchTextFromImageSuccess({required this.schoolId,required this.grade});
  FetchTextFromImageSuccess copyWith({final schoolId}) {
    return FetchTextFromImageSuccess(schoolId: schoolId ?? this.schoolId, grade: grade ?? this.grade);
  }

  @override
  List<Object> get props => [];
}

class OcrErrorReceived extends OcrState {
  final err;
  OcrErrorReceived({this.err});
  OcrErrorReceived copyWith({final err}) {
    return OcrErrorReceived(err: err ?? this.err);
  }

  @override
  List<Object> get props => [err];
}
