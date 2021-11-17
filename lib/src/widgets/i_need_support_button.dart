import 'package:Soc/src/globals.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/i_need_support_widget.dart';
import 'package:flutter/material.dart';

class NeedSupportWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
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
}
