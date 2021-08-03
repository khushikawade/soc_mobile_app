import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';

class TranslationAPI {
  static final _apiKey = 'AIzaSyC4k5dqrfVndHy9vwBDjJf0l29mOb1J9Mk';

  static Future<String> translate(String message, String toLanguageCode) async {
    final response = await http.post(
      Uri.parse(
          'https://translation.googleapis.com/language/translate/v2?target=$toLanguageCode&key=$_apiKey&q=$message&format=text'),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final translations = body['data']['translations'] as List;
      final translation = translations.first;

      return translation['translatedText'];
      //HtmlUnescape().convert(translation['translatedText']);
    } else {
      throw Exception();
    }
  }

  static Future<String> translate2(
      String message, String fromLanguageCode, String toLanguageCode) async {
    final translation = await GoogleTranslator().translate(
      message,
      from: fromLanguageCode,
      to: toLanguageCode,
    );

    return translation.text;
  }
}
