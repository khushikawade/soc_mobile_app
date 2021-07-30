import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/setting/sharepage.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:flutter/material.dart';

class ShareButtonWidget extends StatelessWidget {
  static const double _kLabelSpacing = 17.0;
  SharePopUp obj = new SharePopUp();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(_kLabelSpacing),
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
              child: Text("Share this app"),
            ),
          ),
          SizedBox(
            width: _kLabelSpacing / 2,
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {
                final String body =
                    "Description of the problem: [Please describe the issue you are encountering here...] \nApp: Bronx Bears 1.10.0.0(1.2021.521.1630) \nDevice : ${Globals.manufacturer} ${Globals.release ?? ""} ${Globals.name ?? ""} ${Globals.model} \nuser/release-keys OS : ${Globals.baseOS} \nLocale :${Globals.myLocale}${Globals.countrycode != "" ? "_" "${Globals.countrycode}" : ""}  \nDeployment time : - \nDeployment: - \nUserToken : ${Globals.deviceID} \nDeviceToken : ${Globals.deviceToken} \nDrawingNo. : -";
                final subject = "Problem with the PS 456 Bronx Bears-app";
                obj.callFunction(context, body, subject);
              },
              child: Text("I need support"),
            ),
          ),
        ],
      ),
    );
  }
}
