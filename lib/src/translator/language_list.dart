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
    'Russian',
    'Amharic',
    'Arabic',
    'Basque',
    'Bengali',
    'English(UK)',
    'Portuguese (Brazil)',
    'Bulgarian',
    'Catalan',
    'Cherokee',
    'Croatian',
    'Czech',
    'Danish',
    'Dutch',
    'Estonian',
    'Filipino',
    'Finnish',
    'Greek',
    'Gujarati',
    'Hebrew',
    'Hindi',
    'Hungarian',
    'Icelandic',
    'Indonesian',
    'Japanese',
    'Kannada',
    'Korean',
    'Latvian',
    'Lithuanian',
    'Malay',
    'Malayalam',
    'Marathi',
    'Norwegian',
    'Polish',
    'Portuguese (Portugal)',
    'Romanian',
    'Serbian',
    'Chinese(PRC)',
    'Slovak',
    'Slovenian',
    'Swahili',
    'Tamil',
    'Telugu',
    'Thai',
    'Chinese (Taiwan)',
    'Turkish',
    'Urdu',
    'Ukrainian',
    'Vietnamese',
    'Welsh',
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
      case 'Amharic':
        return 'am';
      case 'Arabic':
        return 'ar';
      case 'Basque':
        return 'eu';
      case 'Bengali':
        return 'bn';
      case 'English(UK)':
        return 'en-GB';
      case 'Portuguese (Brazil)':
        return 'pt-BR';
      case 'Bulgarian':
        return 'bg';
      case 'Catalan':
        return 'ca';
      case 'Cherokee':
        return 'chr';
      case 'Croatian':
        return 'hr';
      case 'Czech':
        return 'cs';
      case 'Danish':
        return 'da';
      case 'Dutch':
        return 'nl';
      case 'Estonian':
        return 'et';
      case 'Filipino':
        return 'fil';
      case 'Finnish':
        return 'fi';
      case 'Greek':
        return 'el';
      case 'Gujarati':
        return 'gu';
      case 'Hebrew':
        return 'iw';
      case 'Hindi':
        return 'hi';
      case 'Hungarian':
        return 'hu';
      case 'Icelandic':
        return 'is';
      case 'Indonesian':
        return 'id';
      case 'Japanese':
        return 'ja';
      case 'Kannada':
        return 'kn';
      case 'Korean':
        return 'ko';
      case 'Latvian':
        return 'lv';
      case 'Lithuanian':
        return 'lt';
      case 'Malay':
        return 'ms';
      case 'Malayalam':
        return 'ml';
      case 'Marathi':
        return 'mr';
      case 'Norwegian':
        return 'no';
      case 'Polish':
        return 'pl';
      case 'Portuguese (Portugal)':
        return 'pt-PT';
      case 'Romanian':
        return 'ro';
      case 'Serbian':
        return 'sr';
      case 'Chinese(PRC)':
        return 'zh-CN';
      case 'Slovak':
        return 'sk';
      case 'Slovenian':
        return 'sl';
      case 'Swahili':
        return 'sw';
      case 'Tamil':
        return 'ta';
      case 'Telugu':
        return 'te';
      case 'Thai':
        return 'th';
      case 'Chinese (Taiwan)':
        return 'zh-TW';
      case 'Turkish':
        return 'tr';
      case 'Urdu':
        return 'ur';
      case 'Ukrainian':
        return 'uk';
      case 'Vietnamese':
        return 'vi';
      case 'Welsh':
        return 'cy';
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
