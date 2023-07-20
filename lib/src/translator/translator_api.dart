import 'dart:convert';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;

class TranslationAPI {
  static final _apiKey = 'AIzaSyC4k5dqrfVndHy9vwBDjJf0l29mOb1J9Mk';
  var translation;

  static Future<String> translate(
      String message, String toLanguageCode, var isUserInteraction) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://translation.googleapis.com/language/translate/v2?target=$toLanguageCode&key=$_apiKey&format=text'), //q=$message&
          body: {"q": "$message"});

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final translations = body['data']['translations'] as List;
        final translation = translations.first;
        return HtmlUnescape().convert(translation['translatedText']);
      } else {
        throw Exception();
      }
    } catch (e) {}
    return message;
  }
}
