part of 'ocr_bloc.dart';

abstract class OcrEvent extends Equatable {
  const OcrEvent();
  @override
  List<Object> get props => [];
}

class FetchTextFromImage extends OcrEvent {
  List<Object> get props => [];
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
