import 'package:Soc/src/globals.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/i_need_support_button.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:flutter/material.dart';

class ShareButtonWidget extends StatelessWidget {
  final bool isSettingPage;
  ShareButtonWidget({Key? key, required this.isSettingPage}) : super(key: key);
  static const double _kLabelSpacing = 10.0;
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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          isSettingPage
              ? Globals.isAndroid == true &&
                      Globals.homeObjet["Play_Store_URL__c"] != null
                  ? shareButton(context, Globals.homeObjet["Play_Store_URL__c"])
                  : Globals.isAndroid == false &&
                          Globals.homeObjet["App_Store_URL__c"] != null
                      ? shareButton(
                          context, Globals.homeObjet["App_Store_URL__c"])
                      : Container()
              : Container(),
          SizedBox(
            width: _kLabelSpacing / 2,
          ),
          Expanded(
            // flex: 1,
            child: NeedSupportWidget(),
          ),
          Globals.homeObjet["Play_Store_URL__c"] == null &&
                  Globals.homeObjet["App_Store_URL__c"] == null
              ? Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                )
              : Container()
        ],
      ),
    );
  }

  Widget shareButton(context, String url) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          obj.callFunction(
              context,
              "Hi, I downloaded the ${Globals.homeObjet["Contact_Name__c"] ?? ""}app. You should check it out! Download the app now at $url",
              Globals.homeObjet["Contact_Name__c"] != null
                  ? "Love the ${Globals.homeObjet["Contact_Name__c"]} app!"
                  : "");
        },
        child: Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English" &&
                Globals.selectedLanguage != ""
            ? Container(
                child: TranslationWidget(
                  message: "Share this app",
                  fromLanguage: "en",
                  toLanguage: Globals.selectedLanguage,
                  builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                  ),
                ),
              )
            : Text("Share this app"),
      ),
    );
  }
}
