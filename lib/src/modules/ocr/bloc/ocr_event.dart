part of 'ocr_bloc.dart';

abstract class OcrEvent extends Equatable {
  const OcrEvent();
  @override
  List<Object> get props => [];
}

// class FetchTextFromImage extends OcrEvent {
//   List<Object> get props => [];
// }

class VerifyUserWithDatabase extends OcrEvent {
  final String? email;
  VerifyUserWithDatabase({required this.email});

  @override
  List<Object> get props => [email!];
}

class FatchSubjectDetails extends OcrEvent {
  final String? type;
  FatchSubjectDetails({required this.type});

  @override
  List<Object> get props => [type!];
}

class FetchTextFromImage extends OcrEvent {
  final String base64;
  FetchTextFromImage({
    required this.base64,
  });

  @override
  List<Object> get props => [base64];

  @override
  String toString() => 'GlobalSearchEvent { keyword: $base64}';
}
