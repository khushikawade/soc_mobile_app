import 'package:Soc/src/globals.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:flutter/material.dart';
import 'package:mailto/mailto.dart';

UrlLauncherWidget objurl = new UrlLauncherWidget();
void iNeedSupport(BuildContext context) {
  final String body =
      'Description of the problem: [Please describe the issue you are encountering here...] \nApp: Bronx Bears 1.10.0.0(1.2021.521.1630) \nDevice :${Globals.manufacturer} ${Globals.systemVersion}${Globals.versionRelease} ${Globals.name} '
      ' ${Globals.model} \nuser/release-keys OS : ${Globals.baseOS} \nLocale : ${Globals.myLocale!} \nDeployment time : - \nDeployment: - \nUserToken : ${Globals.deviceID}  \nDeviceToken : ${Globals.deviceToken} \nDrawingNo. : -';
  final subject = "Problem with the PS 456 Bronx Bears-app";
  launchMailto(subject, body);
  // final Uri params = Uri(
  //     scheme: 'mailto',
  //     path: Globals.appSetting.contactEmailC,
  //     queryParameters: {'subject': subject, 'body': body});

  // objurl.callurlLaucher(context, Uri.decodeFull(params.toString()));
}

launchMailto(subject, body) async {
  final mailtoLink = Mailto(
    to: ["admin@solvedconsulting.com"],//[Globals.appSetting.contactEmailC.toString()],
    cc: [],
    subject: subject,
    body: body,
  );
  // await launch('$mailtoLink');
   await Utility.launchUrlOnExternalBrowser('$mailtoLink');
}
