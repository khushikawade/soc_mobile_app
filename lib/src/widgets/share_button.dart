import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/setting/sharepage.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:flutter/material.dart';

class ShareButtonWidget extends StatelessWidget {
  String? language;
  ShareButtonWidget({Key? key, required this.language}) : super(key: key);
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SharePage(),
                  ),
                );
              },
              child: language != null && language != "English"
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
                final String body =
                    "Description of the problem: [Please describe the issue you are encountering here...] \nApp: Bronx Bears 1.10.0.0(1.2021.521.1630) \nDevice : ${Globals.manufacturer} ${Globals.release ?? ""} ${Globals.name ?? ""} ${Globals.model} \nuser/release-keys OS : ${Globals.baseOS} \nLocale :${Globals.myLocale}${Globals.countrycode != "" ? "_" "${Globals.countrycode}" : ""}  \nDeployment time : - \nDeployment: - \nUserToken : ${Globals.deviceID} \nDeviceToken : ${Globals.deviceToken} \nDrawingNo. : -";
                final subject = "Problem with the PS 456 Bronx Bears-app";
                obj.callFunction(context, body, subject);
              },
              child: language != null && language != "English"
                  ? Container(
                      child: TranslationWidget(
                        message: "I need support",
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
