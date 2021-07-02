import 'package:app/src/locale/app_translations.dart';
import 'package:app/src/locale/application.dart';
import 'package:app/src/services/shared_preference.dart';
import 'package:app/src/services/utility.dart';
import 'package:app/src/styles/theme.dart';
import 'package:app/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class LanguageSelector {
  final SharedPreferencesFn _sharedPref = SharedPreferencesFn();
  String? selectedLanguage;

  LanguageSelector(context, onLanguageChanged) {
    geLanguage(context, onLanguageChanged);
  }

  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };

  void setLanguage(language, context, onLanguageChanged) async {
    application.onLocaleChanged(Locale(languagesMap[language]));
    selectedLanguage = languagesMap[language];
    await _sharedPref.setString('selected_language', languagesMap[language]);
    onLanguageChanged(language);
    Navigator.pop(context);
  }

  geLanguage(context, onLanguageChanged) async {
    String _languageCode = await _sharedPref.getString('selected_language');
    selectedLanguage = _languageCode;
    if (selectedLanguage == null) {
      Locale myLocale = Localizations.localeOf(context);
      selectedLanguage = myLocale.languageCode;
    }
    _openSettingsBottomSheet(context, onLanguageChanged);
  }

  Widget _listTile(String language, context, onLanguageChanged) => Container(
        margin: EdgeInsets.only(left: 30, right: 30, bottom: 12),
        color: AppTheme.kListTileColor,
        child: RadioListTile(
          contentPadding: EdgeInsets.zero,
          // activeColor: ,
          value: selectedLanguage == languagesMap[language] ? true : false,
          onChanged: (dynamic val) {
            setLanguage(language, context, onLanguageChanged);
          },
          groupValue: true,
          title:
              Text(language, style: Theme.of(context).textTheme.caption),
        ),
      );

  _openSettingsBottomSheet(context, onLanguageChanged) {
    Utility.showBottomSheet(
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 30, left: 30, right: 15, bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      AppTranslations.of(context)!.text('change_language'),
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontSize: AppTheme.kBottomSheetTitleSize),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ),
              _buildLanguagesList(context, onLanguageChanged),
              SpacerWidget(30)
            ],
          ),
        ),
        context);
  }

  _buildLanguagesList(context, onLanguageChanged) {
    return Column(
      children: languagesList
          .map<Widget>((i) => _listTile(i, context, onLanguageChanged))
          .toList(),
    );
  }
}
