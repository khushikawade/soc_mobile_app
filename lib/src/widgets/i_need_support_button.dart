import 'package:Soc/src/globals.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:flutter/material.dart';
import 'package:mailto/mailto.dart';

class NeedSupportWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        iNeedSupport(context);
      },
      child: Container(
        child: TranslationWidget(
          message: "I Need Support",
          fromLanguage: "en",
          toLanguage: Globals.selectedLanguage,
          builder: (translatedMessage) => Text(
            translatedMessage.toString(),
          ),
        ),
      ),
    );
  }

// Removed information's : DrawingNo. : -' \nDeployment time : - \nDeployment: -
  void iNeedSupport(BuildContext context) {
    final String body =
        '''Description of the problem : [Please describe the issue you are encountering here...] \n\nApp : ${Globals.appSetting.contactNameC} \nVersion : ${Globals.packageInfo!.version} \nBuild : ${Globals.packageInfo!.buildNumber} \nDevice : ${Globals.manufacturer} ${Globals.systemVersion} ${Globals.versionRelease} ${Globals.name} 
         ${Globals.model} \nUser/Release-keys OS : ${Globals.baseOS} \nLocale : ${Globals.myLocale!}  \nUserToken : ${Globals.deviceID}  \nDeviceToken : ${Globals.deviceToken} ''';
    final subject = "Problem with the ${Globals.appSetting.contactNameC}";
    Utility.launchMailto(subject, body);
  }
}
