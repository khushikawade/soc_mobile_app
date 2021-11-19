import 'package:Soc/src/globals.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:flutter/material.dart';
import 'package:mailto/mailto.dart';

class NeedSupportWidget extends StatelessWidget {
  @override
  // final UrlLauncherWidget objurl = new UrlLauncherWidget();
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        iNeedSupport(context);
      },
      child: Globals.selectedLanguage != null &&
              Globals.selectedLanguage != "English" &&
              Globals.selectedLanguage != ""
          ? Container(
              child: TranslationWidget(
                message: "I Need Support",
                fromLanguage: "en",
                toLanguage: Globals.selectedLanguage,
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                ),
              ),
            )
          : Text("I Need Support"),
    );
  }

// Removed informations : DrawingNo. : -' \nDeployment time : - \nDeployment: -
  void iNeedSupport(BuildContext context) {
    final String body =
        '''Description of the problem: [Please describe the issue you are encountering here...] \nApp: Bronx Bears 1.10.0.0(1.2021.521.1630) \nDevice : ${Globals.manufacturer} ${Globals.systemVersion}${Globals.versionRelease} ${Globals.name} 
         ${Globals.model} \nUser/Release-keys OS : ${Globals.baseOS} \nLocale : ${Globals.myLocale!}  \nUserToken : ${Globals.deviceID}  \nDeviceToken : ${Globals.deviceToken} ''';
    final subject = "Problem with the PS 456 Bronx Bears-app";
    launchMailto(subject, body);
  }

  launchMailto(subject, body) async {
    final mailtoLink = Mailto(
      to: ["admin@solvedconsulting.com"],
      cc: [],
      subject: subject,
      body: body,
    );
    // await launch('$mailtoLink');
    await Utility.launchUrlOnExternalBrowser('$mailtoLink');
  }
}
