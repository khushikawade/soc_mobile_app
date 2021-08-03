class Translations {
  // static final Translations _application = Translations._internal();

  // factory Translations() {
  //   return _application;
  // }

  // Translations._internal();

  static final List<String> supportedLanguages = [
    'Afrikaans',
    'Albanian',
    'Amharic',
    'Arabic',
    'Armenian',
    'Azerbaijani',
    'Basque',
    'Belarusian',
    'Bengali',
    'Bosnian',
    'Bulgarian',
    'Catalan',
    'Cebuano',
    'Chinese (Simplified)',
    'Chinese (Traditional)',
    'Corsican',
    'Croatian',
    'Czech',
    'Danish',
    'Dutch',
    'English',
    // 'English(UK)',
    'Esperanto',
    'Estonian',
    'Finnish',
    'French',
    'Frisian',
    'Galician',
    'Georgian',
    'German',
    'Greek',
    'Gujarati',
    'Haitian Creole',
    'Hausa',
    'Hawaiian',
    'Hebrew',
    'Hindi',
    'Hmong',
    'Hungarian',
    'Icelandic',
    'Igbo',
    'Indonesian',
    'Irish',
    'Italian',
    'Japanese',
    'Javanese',
    'Kannada',
    'Kazakh',
    'Khmer',
    'Kinyarwanda',
    'Korean',
    'Kurdish',
    'Kyrgyz',
    'Lao',
    'Latin',
    'Latvian',
    'Lithuanian',
    'Luxembourgish',
    'Macedonian',
    'Malagasy',
    'Malay',
    'Malayalam',
    'Maltese',
    'Maori',
    'Marathi',
    'Mongolian',
    'Myanmar (Burmese)',
    'Nepali',
    'Norwegian',
    'Nyanja (Chichewa)',
    'Odia (Oriya)',
    'Pashto',
    'Persian',
    'Polish',
    'Portuguese (Portugal)',
    'Portuguese (Brazil)',
    'Punjabi',
    'Romanian',
    'Russian',
    'Samoan',
    'Scots Gaelic',
    'Serbian',
    'Sesotho',
    'Shona',
    'Sindhi',
    'Sinhala (Sinhalese)',
    'Slovak',
    'Slovenian',
    'Somali',
    'Spanish',
    'Sundanese',
    'Swahili',
    'Swedish',
    'Tagalog (Filipino)	',
    'Tajik',
    'Tamil',
    'Tatar',
    'Telugu',
    'Thai',
    'Turkish',
    'Turkmen',
    'Ukrainian',
    'Urdu',
    'Uyghur',
    'Uzbek',
    'Vietnamese',
    'Welsh',
    'Xhosa',
    'Yiddish',
    'Yoruba',
    'Zulu'
  ];

  static String supportedLanguagesCodes(String language) {
    switch (language) {
      case 'Afrikaans':
        return 'af';
      case 'Albanian':
        return 'sq';
      case 'Armenian':
        return 'hy';
      case 'Azerbaijani':
        return 'az';
      case 'Belarusian':
        return 'be';
      case 'Bosnian':
        return 'bs';
      case 'Cebuano':
        return 'ceb';
      case 'Chinese (Simplified)':
        return 'zh';
      case 'Chinese (Traditional)':
        return 'zh-TW';
      case 'Corsican':
        return 'co';
      case 'Esperanto':
        return 'eo';
      case 'Frisian':
        return 'fy';
      case 'Galician':
        return 'gl';
      case 'Georgian':
        return 'ka';
      case 'Haitian Creole':
        return 'ht';
      case 'Hausa':
        return 'ha';
      case 'Hawaiian':
        return 'haw';
      case 'Hmong':
        return 'hmn';
      case 'Igbo':
        return 'ig';
      case 'Irish':
        return 'ga';
      case 'Javanese':
        return 'jv';
      case 'Kazakh':
        return 'kk';
      case 'Khmer':
        return 'km';
      case 'Kinyarwanda':
        return 'rw';
      case 'Kurdish':
        return 'ku';
      case 'Kyrgyz':
        return 'ky';
      case 'Lao':
        return 'lo';
      case 'Latin':
        return 'la';
      case 'Luxembourgish':
        return 'lb';
      case 'Macedonian':
        return 'mk';
      case 'Malagasy':
        return 'mg';
      case 'Maltese':
        return 'mt';
      case 'Maori':
        return 'mi';
      case 'Mongolian':
        return 'mn';
      case 'Myanmar (Burmese)':
        return 'my';
      case 'Nepali':
        return 'ne';
      case 'Nyanja (Chichewa)':
        return 'ny';
      case 'Odia (Oriya)':
        return 'or';
      case 'Pashto':
        return 'ps';
      case 'Persian':
        return 'fa';
      case 'Punjabi':
        return 'pa';
      case 'Samoan':
        return 'sm';
      case 'Scots Gaelic':
        return 'gd';
      case 'Sesotho':
        return 'st';
      case 'Shona':
        return 'sn';
      case 'Sindhi':
        return 'sd';
      case 'Sinhala (Sinhalese)':
        return 'si';
      case 'Somali':
        return 'so';
      case 'Sundanese':
        return 'su';
      case 'Swedish':
        return 'sv';
      case 'Tagalog (Filipino)':
        return 'tl';
      case 'Tajik':
        return 'tg';
      case 'Tatar':
        return 'tt';
      case 'Turkmen':
        return 'tk';
      case 'Urdu':
        return 'ur';
      case 'Uyghur':
        return 'ug';
      case 'Uzbek':
        return 'uz';
      case 'Xhosa':
        return 'xh';
      case 'Yiddish':
        return 'yi';
      case 'Yoruba':
        return 'yo';
      case 'Zulu':
        return 'zu';
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
        return 'en-gb';
      case 'Portuguese (Brazil)':
        return 'pt-br';
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
}
