import 'package:hive/hive.dart';
part 'translation_modal.g.dart';

@HiveType(typeId: 25)
class TranslationModal {
  @HiveField(0)
  String? toLanguageCode;
  @HiveField(1)
  String? originalText;
  @HiveField(2)
  String? translatedText;

  TranslationModal(
      {this.toLanguageCode, this.originalText, this.translatedText});
}
