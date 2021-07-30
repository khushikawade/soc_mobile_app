import 'package:Soc/src/services/shared_preference.dart';
import 'package:Soc/src/translator/language_list.dart';
import 'package:Soc/src/translator/translator_api.dart';
import 'package:flutter/material.dart';

class TranslationWidget extends StatefulWidget {
  var message;
  final String? fromLanguage;
  final String? toLanguage;
  final Widget Function(String translation)? builder;

  TranslationWidget({
    @required this.message,
    this.fromLanguage,
    @required this.toLanguage,
    @required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  _TranslationWidgetState createState() => _TranslationWidgetState();
}

class _TranslationWidgetState extends State<TranslationWidget> {
  String? translation;
  final SharedPreferencesFn _sharedPref = SharedPreferencesFn();
  @override
  Widget build(BuildContext context) {
    // final fromLanguageCode = Translations.getLanguageCode(widget.fromLanguage);
    final toLanguageCode =
        Translations.supportedLanguagesCodes(widget.toLanguage!);
    final fromLanguageCode =
        Translations.supportedLanguagesCodes(widget.fromLanguage!);

    return FutureBuilder(
      future: TranslationAPI.translate(
          widget.message! /*, fromLanguageCode,*/, toLanguageCode),
      //future: TranslationApi.translate2(
      //    widget.message, fromLanguageCode, toLanguageCode),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return buildWaiting();
          default:
            if (snapshot.hasError) {
              translation = 'Could not translate due to Network problems';
            } else {
              translation = snapshot.data;
            }
            return widget.builder!(translation!);
        }
      },
    );
  }

  Widget buildWaiting() => translation == null
      ? Center(
          child: Container(
          height: 10,
          width: 10,
          child: CircularProgressIndicator(
            strokeWidth: 1,
            backgroundColor: Theme.of(context).accentColor,
          ),
        ))
      : widget.builder!(translation!);
}
