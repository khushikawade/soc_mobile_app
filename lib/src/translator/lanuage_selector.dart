import 'package:Soc/src/services/shared_preference.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/language_list.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class LanguageSelector {
  final SharedPreferencesFn _sharedPref = SharedPreferencesFn();
  String? selectedLanguage;

  LanguageSelector(context, item, onLanguageChanged) {
    geLanguage(context, onLanguageChanged);
  }

  static final List<String> languagesList = Translations.supportedLanguages;

  void setLanguage(language, context, onLanguageChanged) async {
    selectedLanguage = language;
    await _sharedPref.setString('selected_language', language);
    onLanguageChanged(language);
    print(language);
    Navigator.pop(context);
  }

  geLanguage(context, onLanguageChanged) async {
    String _languageCode = await _sharedPref.getString('selected_language');
    selectedLanguage = _languageCode;
    if (selectedLanguage == null) {
      // Locale myLocale = Localizations.localeOf(context);
      selectedLanguage = "English";
    }
    _openSettingsBottomSheet(context, onLanguageChanged);
  }

  Widget _listTile(String language, context, onLanguageChanged) => Container(
        margin: EdgeInsets.only(left: 30, right: 30, bottom: 12),
        color: AppTheme.kListTileColor,
        child: RadioListTile(
          contentPadding: EdgeInsets.zero,
          value: selectedLanguage == language ? true : false,
          onChanged: (dynamic val) {
            setLanguage(language, context, onLanguageChanged);
          },
          groupValue: true,
          title: Text(language, style: Theme.of(context).textTheme.caption),
        ),
      );

  _openSettingsBottomSheet(context, onLanguageChanged) {
    Utility.showBottomSheet(
        SingleChildScrollView(
          child: Container(
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
                        "Select language",
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
