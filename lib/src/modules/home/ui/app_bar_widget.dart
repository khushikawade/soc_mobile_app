import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/ui/iconsmenu.dart';
import 'package:Soc/src/modules/setting/information.dart';
import 'package:Soc/src/modules/setting/setting.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/translator/language_list.dart';
import 'package:Soc/src/translator/lanuage_selector.dart';
import 'package:Soc/src/widgets/app_logo_widget.dart';
import 'package:Soc/src/widgets/searchbuttonwidget.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final double _kIconSize = Globals.deviceType == "phone" ?35:45.0;
  final double height = 60;
  final double _kLabelSpacing = 16.0;
  final String language1 = Translations.supportedLanguages.first;
  final String language2 = Translations.supportedLanguages.last;
  final ValueNotifier<String> languageChanged =
      ValueNotifier<String>("English");
  final ValueChanged? refresh;

  AppBarWidget({Key? key, required this.refresh}) : super(key: key);

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
                padding: EdgeInsets.symmetric(
                    horizontal: _kLabelSpacing / 4, vertical: 0),
                child: Text(
                  item.text,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(),
                ),
              )))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return AppBar(
          automaticallyImplyLeading: false,
           leadingWidth: _kIconSize,
          elevation: 0.0,
          leading: 
          Container(
            padding: EdgeInsets.only(left: 10),
            child: GestureDetector(
              child: Image(image: AssetImage("assets/images/gtranslate.png"),),
              // Icon(
              //   IconData(0xe822,
              //       fontFamily: Overrides.kFontFam,
              //       fontPackage: Overrides.kFontPkg),
              //   size: Globals.deviceType == "phone" ? 32 : 40,
              // ),
              onTap: () {
                setState(() {});
                LanguageSelector(context, (language) {
                  if (language != null) {
                    setState(() {
                      Globals.selectedLanguage = language;
                      Globals.languageChanged.value = language;
                    });
                    refresh!(true);
                  }
                });
              },
            ),
          ),
          title: AppLogoWidget(),//SizedBox(width: 100.0, height: 60.0, child: AppLogoWidget()),
          actions: <Widget>[
            SearchButtonWidget(
              language: 'English',
            ),
            _buildPopupMenuWidget(context),
          ]);
    });
  }
}
