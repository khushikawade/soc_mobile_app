import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_icons.dart';
import 'package:Soc/src/modules/setting/ios_accessibility_guide_page.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/lanuage_selector.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_apps_settings/open_apps_settings.dart';
import 'package:open_apps_settings/settings_enum.dart';

class PBISPlusAppBar extends StatefulWidget implements PreferredSizeWidget {
  final IconData? titleIconData;
  final String title;
  final bool? backButton;
  PBISPlusAppBar(
      {Key? key, this.titleIconData, this.backButton, required this.title})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);
  @override
  final Size preferredSize;
  @override
  State<PBISPlusAppBar> createState() => _PBISPlusAppBarState();
}

class _PBISPlusAppBarState extends State<PBISPlusAppBar> {
  @override
  Widget build(BuildContext context) {
    Widget leading = widget.backButton == true
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  IconData(0xe80d,
                      fontFamily: Overrides.kFontFam,
                      fontPackage: Overrides.kFontPkg),
                  color: AppTheme.kButtonColor,
                ),
              ),
            ],
          )
        : Container(
            child: Row(
              children: [
                _translateButton(setState, context),
                _openPBISSettingsButton(context),
              ],
            ),
          );

    List<Widget>? actions = [
      IconButton(
        onPressed: () {},
        icon: Icon(
          widget.title == "History"
              ? IconData(0xe87d,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg)
              : IconData(0xe867,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg),
          color: AppTheme.kButtonColor,
        ),
      )
    ];

    return AppBar(
      leadingWidth: 110,
      actions: actions,
      centerTitle: true,
      leading: leading,
      title: titleBuilder(context, widget.titleIconData),
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
    );
  }

  Widget _translateButton(StateSetter setState, BuildContext context) {
    return IconButton(
        // key: _bshowcase,
        onPressed: () async {
          setState(() {});
          LanguageSelector(context, (language) {
            if (language != null) {
              setState(() {
                Globals.selectedLanguage = language;
                Globals.languageChanged.value = language;
              });
              // refresh!(true);
            }
          });
        },
        icon: Container(
          child: Image(
            width: !Overrides.STANDALONE_GRADED_APP
                ? Globals.deviceType == "phone"
                    ? 26
                    : 32
                : 28,
            height: !Overrides.STANDALONE_GRADED_APP
                ? Globals.deviceType == "phone"
                    ? 26
                    : 32
                : 28,
            image: AssetImage("assets/images/gtranslate.png"),
          ),
        ));
  }

  Widget _openPBISSettingsButton(BuildContext context) {
    return IconButton(
      iconSize: 28,
      onPressed: () async {
        if (Platform.isAndroid) {
          OpenAppsSettings.openAppsSettings(
              settingsCode: SettingsCode.ACCESSIBILITY);
        } else {
          // AppSettings.openAccessibilitySettings(asAnotherTask: true);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      IosAccessibilityGuidePage()));
        }
      },
      icon: Icon(
        FontAwesomeIcons.universalAccess,
        color: Colors.blue,
        // key: _openSettingShowCaseKey,
        size: !Overrides.STANDALONE_GRADED_APP
            ? Globals.deviceType == "phone"
                ? 25
                : 32
            : null,
      ),
    );
  }
}

Widget titleBuilder(BuildContext context, IconData? iconData) {
  final bool isDarkMode =
      Theme.of(context).colorScheme.background == Color(0xff000000);
  return Icon(
    iconData,
    color: isDarkMode ? Colors.white : Colors.black,
    // size: 22,
  );
}
