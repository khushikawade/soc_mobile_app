import 'dart:io';

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:open_apps_settings/open_apps_settings.dart';
import 'package:open_apps_settings/settings_enum.dart';
import '../../../services/utility.dart';

class CommonPopupWidget extends StatefulWidget {
  final Orientation? orientation;
  final BuildContext? context;
  final String? message;
  final String? title;
  final bool? isAccessDenied;
  CommonPopupWidget(
      {Key? key,
      required this.orientation,
      required this.context,
      required this.message,
      required this.title,
      this.isAccessDenied})
      : super(key: key);

  @override
  State<CommonPopupWidget> createState() => _CommonPopupWidgetState();
}

class _CommonPopupWidgetState extends State<CommonPopupWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(
        child: Container(
          padding: Globals.deviceType == 'phone'
              ? null
              : const EdgeInsets.only(top: 10.0),
          height: Globals.deviceType == 'phone' ? null : 50,
          width: Globals.deviceType == 'phone'
              ? null
              : widget.orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width / 2
                  : MediaQuery.of(context).size.height / 2,
          child: TranslationWidget(
              message: widget.title,
              fromLanguage: "en",
              toLanguage: Globals.selectedLanguage,
              builder: (translatedMessage) {
                return Text(translatedMessage.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(color: AppTheme.kButtonColor));
              }),
        ),
      ),
      content: TranslationWidget(
          message: widget.message,
          fromLanguage: "en",
          toLanguage: Globals.selectedLanguage,
          builder: (translatedMessage) {
            return Linkify(
                onOpen: (link) => Utility.launchUrlOnExternalBrowser(link.url),
                options: LinkifyOptions(humanize: false),
                textAlign: TextAlign.center,
                linkStyle: TextStyle(
                  color: Colors.blue,
                ),
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(color: Colors.black),
                text: translatedMessage.toString());
          }),
      actions: <Widget>[
        Container(
          height: 1,
          width: MediaQuery.of(context).size.height,
          color: Colors.grey.withOpacity(0.2),
        ),
        Center(
          child: TextButton(
            child: TranslationWidget(
                message: "Got It",
                fromLanguage: "en",
                toLanguage: Globals.selectedLanguage,
                builder: (translatedMessage) {
                  return Text(translatedMessage.toString(),
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: AppTheme.kButtonColor,
                          ));
                }),
            onPressed: () async {
              if (widget.isAccessDenied == true) {
                //To pop 2 times to navigate back to the home screen in case of camera access denied
                int count = 0;
                Navigator.of(context).popUntil((_) {
                  if (Platform.isAndroid) {
                    return count++ >= 3;
                  } else {
                    return count++ >= 2;
                  }
                });

                //To open the app setting for permission access
                OpenAppsSettings.openAppsSettings(
                    settingsCode: SettingsCode.APP_SETTINGS);
              } else {
                //Globals.iscameraPopup = false;
                Navigator.pop(context, false);
              }
            },
          ),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
