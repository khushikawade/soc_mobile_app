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
                      Globals.appSetting.playStoreUrlC != null
                  ? shareButton(context, Globals.appSetting.playStoreUrlC)
                  : Globals.isAndroid == false &&
                          Globals.appSetting.appStoreUrlC != null
                      ? shareButton(context, Globals.appSetting.appStoreUrlC)
                      : Container()
              : Container(),
          SizedBox(
            width: _kLabelSpacing / 2,
          ),
          Expanded(
            child: NeedSupportWidget(),
          ),
          Globals.appSetting.playStoreUrlC == null &&
                  Globals.appSetting.appStoreUrlC == null
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
              "Hi, I downloaded the ${Globals.appSetting.contactNameC ?? ""}app. You should check it out! Download the app now at $url",
              Globals.appSetting.contactNameC != null
                  ? "Love the ${Globals.appSetting.contactNameC} app!"
                  : "");
        },
        child: Container(
          child: TranslationWidget(
            message: "Share this app",
            fromLanguage: "en",
            toLanguage: Globals.selectedLanguage,
            builder: (translatedMessage) => Text(
              translatedMessage.toString(),
            ),
          ),
        ),
      ),
    );
  }
}
