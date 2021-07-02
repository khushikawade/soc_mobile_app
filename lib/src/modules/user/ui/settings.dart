import 'package:app/src/locale/app_translations.dart';
import 'package:app/src/locale/application.dart';
import 'package:app/src/modules/user/ui/lanuage_selector.dart';
import 'package:app/src/modules/user/ui/user_profile.dart';
import 'package:app/src/services/shared_preference.dart';
import 'package:app/src/styles/theme.dart';
import 'package:app/src/widgets/app_bar_with_overlapped_body.dart';
import 'package:app/src/widgets/back_button_widget.dart';
import 'package:app/src/widgets/icon_selector.dart';
import 'package:app/src/widgets/models/custom_app_bar.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SharedPreferencesFn _sharedPref = SharedPreferencesFn();
  String? selectedLanguage;

  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;
  final Map<dynamic, dynamic> languagesMap = {
    languageCodesList[0]: languagesList[0],
    languageCodesList[1]: languagesList[1],
  };

  final ValueNotifier<String?> _currentLanguage = ValueNotifier<String?>('');

  @override
  void initState() {
    super.initState();
    geLanguage();
  }

  _naviage(path) {
    switch (path) {
      case 'language_selector':
        LanguageSelector(context, (newLanguage) {
          _currentLanguage.value = newLanguage;
        });
        break;
      case 'user_profile':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UserProfilePage()));
        break;
      default:
    }
  }

  geLanguage() async {
    String _languageCode = await _sharedPref.getString('selected_language');
    selectedLanguage = _languageCode;
    if (selectedLanguage == null) {
      Locale myLocale = Localizations.localeOf(context);
      selectedLanguage = myLocale.languageCode;
    }
    _currentLanguage.value = languagesMap[selectedLanguage];
  }

  Widget _listItem(title, leading, path, {trailing}) => Card(
        child: ListTile(
            title: Text(
              title ?? '',
              style: Theme.of(context).textTheme.caption,
            ),
            leading: leading,
            onTap: () => _naviage(path),
            trailing: trailing),
      );

  Widget _languageNameIndicatorTrailing() => Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder(
              builder: (BuildContext context, String? value, Widget? child) {
                return Text("${_currentLanguage.value}",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Theme.of(context).colorScheme.secondary));
              },
              valueListenable: _currentLanguage,
              child: Container(),
            ),
            Icon(Icons.keyboard_arrow_right,
                color: Theme.of(context).colorScheme.primary)
          ],
        ),
      );

  Widget _body() => Container(
        child: Padding(
          padding: const EdgeInsets.only(left: AppTheme.kBodyPadding, right: AppTheme.kBodyPadding),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _listItem(
                    AppTranslations.of(context)!.text('select_language'),
                    IconSelectorWidget(
                      'language_icon',
                      'asset',
                    ),
                    'language_selector',
                    trailing: _languageNameIndicatorTrailing()),
                _listItem(
                    AppTranslations.of(context)!.text('profile'),
                    IconSelectorWidget('profile_icon', 'asset'),
                    'user_profile'),
                _listItem(
                    AppTranslations.of(context)!.text('app_information'),
                    IconSelectorWidget('informative_icon', 'asset'),
                    'app_info'),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return OverlappedAppBar(
      topOverFlow: 30.0,
      customAppBar: CustomAppBar(
          leading: BackButtonWidget(),
          title: AppTranslations.of(context)!.text('settings'),
          subtitle: 'Team bedrijfsbureau'),
      body: _body(),
    );
  }
}
