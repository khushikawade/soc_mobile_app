import 'dart:ui';

class Translations {
  static final Translations _application = Translations._internal();

  factory Translations() {
    return _application;
  }

  Translations._internal();

  static final List<String> supportedLanguages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Russian'
  ];

  static final List<String> supportedLanguagesCodes = [
    'en',
    'fr',
    'it',
    'ru',
    'es',
    'de',
  ];

  //returns the list of supported Locales
  Iterable<Locale> supportedLocales() =>
      supportedLanguagesCodes.map<Locale>((language) => Locale(language, ""));

  //function to be invoked when changing the language
  static late LocaleChangeCallback onLocaleChanged;
}

Translations application = Translations();

typedef void LocaleChangeCallback(Locale locale);
