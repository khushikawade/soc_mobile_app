import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/ui/iconsmenu.dart';
import 'package:Soc/src/modules/setting/information.dart';
import 'package:Soc/src/modules/setting/setting.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/language_list.dart';
import 'package:Soc/src/translator/lanuage_selector.dart';
import 'package:Soc/src/widgets/app_logo_widget.dart';
import 'package:Soc/src/widgets/searchbuttonwidget.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  static const double _kIconSize = 35.0;
  static const double height = 60;
  static const double _kLabelSpacing = 16.0;
  String language1 = Translations.supportedLanguages.first;
  String language2 = Translations.supportedLanguages.last;
  var item;
  final ValueNotifier<String> languageChanged =
      ValueNotifier<String>("English");

  @override
  Size get preferredSize => Size.fromHeight(height);

  Widget _buildPopupMenuWidget(BuildContext context) {
    return PopupMenuButton<IconMenu>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      icon: Icon(
        const IconData(0xe806,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        color: AppTheme.kIconColor2,
        size: Globals.deviceType == "phone" ? 20 : 28,
      ),
      onSelected: (value) {
        switch (value) {
          case IconsMenu.Information:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => InformationPage(
                          appbarTitle: 'Information',
                          htmlText: '',
                          isbuttomsheet: true,
                          ishtml: true,
                        )));
            break;
          case IconsMenu.Setting:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingPage(
                          appbarTitle: '',
                          isbuttomsheet: true,
                        )));
            break;
          case IconsMenu.Permissions:
            AppSettings.openAppSettings();
            break;
        }
      },
      itemBuilder: (context) => IconsMenu.items
          .map((item) => PopupMenuItem<IconMenu>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: _kLabelSpacing / 4, vertical: 0),
                child: Text(
                  item.text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Color(0xff474D55)),
                ),
              )))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      // child:
      return AppBar(
          backgroundColor: Colors.white,
          leadingWidth: _kIconSize,
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(IconData(0xe800,
                fontFamily: Overrides.kFontFam,
                fontPackage: Overrides.kFontPkg)),
            onPressed: () {
              LanguageSelector(context, item, (language) {
                if (language != null) {
                  setState(() {
                    Globals.selectedLanguage = language;
                    languageChanged.value = language;
                  });
                }
              });
            },
          ),

          //     GestureDetector(
          //   onTap: () {
          //     LanguageSelector(context, item, (language) {
          //       if (language != null) {
          //         setState(() {
          //           Globals.selectedLanguage = language;
          //           languageChanged.value = language;
          //         });
          //       }
          //     });
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.all(12.0),
          //     child: const Icon(IconData(0xe800,
          //         fontFamily: Overrides.kFontFam,
          //         fontPackage: Overrides.kFontPkg)),
          //   ),
          // ),
          title: SizedBox(width: 100.0, height: 60.0, child: AppLogoWidget()),
          actions: <Widget>[
            SearchButtonWidget(
              language: 'English',
            ),
            _buildPopupMenuWidget(context),
          ]);
    });
  }
}
