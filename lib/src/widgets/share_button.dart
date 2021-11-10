import 'package:Soc/src/globals.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/i_need_support_widget.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:flutter/material.dart';

class ShareButtonWidget extends StatelessWidget {
  final String? language;
  ShareButtonWidget({Key? key, required this.language}) : super(key: key);
  static const double _kLabelSpacing = 17.0;
  final SharePopUp obj = new SharePopUp();
  final UrlLauncherWidget objurl = new UrlLauncherWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: _kLabelSpacing,
          bottom: _kLabelSpacing * 2,
          right: _kLabelSpacing,
          left: _kLabelSpacing),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {
                obj.callFunction(
                    context,
                    "Hi, I downloaded the PS 456 Bronx Bears app. You should check it out! Download the app at https://play.google.com/store/apps/details?id=com.app.p1676CB",
                    "Love the PS 456 Bronx Bears app!");
              },
              child: Globals.selectedLanguage != null &&
                      Globals.selectedLanguage != "English" &&
                      Globals.selectedLanguage != ""
                  ? Container(
                      child: TranslationWidget(
                        message: "Share this app",
                        fromLanguage: "en",
                        toLanguage: language,
                        builder: (translatedMessage) => Text(
                          translatedMessage.toString(),
                        ),
                      ),
                    )
                  : Text("Share this app"),
            ),
          ),
          SizedBox(
            width: _kLabelSpacing / 2,
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {
                // final String body =
                //   'Description of the problem: [Please describe the issue you are encountering here...] \nApp: Bronx Bears 1.10.0.0(1.2021.521.1630) \nDevice :${Globals.iosInfo.systemName}??${Globals.androidInfo.manufacturer} ${Globals.iosInfo.systemVersion}??${Globals.androidInfo.version.release} ${Globals.iosInfo.name}?? '
                //   ' ${Globals.iosInfo.model}??${Globals.androidInfo.model} \nuser/release-keys OS : ${Globals.baseOS} \nLocale :${Globals.myLocale}${Globals.myLocale!.countryCode!} != "" ? "_" "  ${Globals.myLocale!.countryCode!}" : ""}  \nDeployment time : - \nDeployment: - \nUserToken : ${Globals.deviceID}  \nDeviceToken : ${Globals.androidInfo.androidId} \nDrawingNo. : -';
                iNeedSupport(context);
              },
              child: Globals.selectedLanguage != null &&
                      Globals.selectedLanguage != "English" &&
                      Globals.selectedLanguage != ""
                  ? Container(
                      child: TranslationWidget(
                        message: "I need support ",
                        fromLanguage: "en",
                        toLanguage: language,
                        builder: (translatedMessage) => Text(
                          translatedMessage.toString(),
                        ),
                      ),
                    )
                  : Text("I need support"),
            ),
          ),
        ],
      ),
    );
  }
}
