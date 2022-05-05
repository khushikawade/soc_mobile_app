part of 'ocr_bloc.dart';

abstract class OcrEvent extends Equatable {
  const OcrEvent();
  @override
  List<Object> get props => [];
}

class FetchTextFromImage extends OcrEvent {
  List<Object> get props => [];
}

class AuthenticateEmail extends OcrEvent {
  final String? email;
  AuthenticateEmail({required this.email});
  
  @override
  List<Object> get props => [email!];
}


// class GlobalSearchEventOffline extends OcrEvent {
//   final String? keyword;
//   GlobalSearchEventOffline({
//     @required this.keyword,
//   });

//   @override
//   List<Object> get props => [keyword!];

//   @override
//   String toString() => 'GlobalSearchEvent { keyword: $keyword}';
// }
