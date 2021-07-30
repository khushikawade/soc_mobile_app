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

  // static final List<String> supportedCodes = [
  //   'en',
  //   'fr',
  //   'it',
  //   'ru',
  //   'es',
  //   'de',
  // ];

  static String supportedLanguagesCodes(String language) {
    switch (language) {
      case 'English':
        return 'en';
      case 'French':
        return 'fr';
      case 'Italian':
        return 'it';
      case 'Russian':
        return 'ru';
      case 'Spanish':
        return 'es';
      case 'German':
        return 'de';
      default:
        return 'en';
    }
  }

  // returns the list of supported Locales
  // Iterable<Locale> supportedLocales() =>
  //     supportedCodes.map<Locale>((language) => Locale(language, ""));

  // function to be invoked when changing the language
  static late LocaleChangeCallback onLocaleChanged;
}

Translations application = Translations();

typedef void LocaleChangeCallback(Locale locale);
