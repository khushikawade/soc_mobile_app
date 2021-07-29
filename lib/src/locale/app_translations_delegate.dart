// import 'dart:async';

// import 'package:Soc/src/translator/language_list.dart';
// import 'package:flutter/material.dart';
// import './app_translations.dart';

// class AppTranslationsDelegate extends LocalizationsDelegate<AppTranslations> {
//   final Locale? newLocale;

//   const AppTranslationsDelegate({this.newLocale});

//   @override
//   bool isSupported(Locale locale) {
//     return Translations.supportedCodes.contains(locale.languageCode);
//   }

//   @override
//   Future<AppTranslations> load(Locale locale) {
//     return AppTranslations.load(newLocale ?? locale);
//   }

//   @override
//   bool shouldReload(LocalizationsDelegate<AppTranslations> old) {
//     return true;
//   }
// }
