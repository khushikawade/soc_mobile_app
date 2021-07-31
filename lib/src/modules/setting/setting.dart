import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/setting/licenceinfo.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/internalbuttomnavigation.dart';
import 'package:Soc/src/widgets/share_button.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  String? language;
  bool isbuttomsheet;
  String appbarTitle;
  SettingPage(
      {Key? key,
      required this.language,
      required this.isbuttomsheet,
      required this.appbarTitle})
      : super(key: key);
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static const double _kLabelSpacing = 18.0;
  bool _lights = true;
  bool? push;
  UrlLauncherWidget urlobj = new UrlLauncherWidget();
  @override
  void initState() {
    super.initState();
    OneSignal.shared
        .getDeviceState()
        .then((value) => {pushState(value!.pushDisabled)});
  }

  pushState(data) async {
    SharedPreferences pushStatus = await SharedPreferences.getInstance();
    pushStatus.setBool("push", data);
    setState(() {
      push = pushStatus.getBool("push")!;
    });

    print(push);

    if (push == null) {
      push = true;
    }
  }

  Widget _buildHeading(String tittle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: _kLabelSpacing / 1.5),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: AppTheme.kOnPrimaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: _kLabelSpacing),
            child: widget.language != null && widget.language != "English"
                ? TranslationWidget(
                    message: tittle,
                    fromLanguage: "en",
                    toLanguage: widget.language,
                    builder: (translatedMessage) => Text(
                        translatedMessage.toString(),
                        style: Theme.of(context).textTheme.headline3),
                  )
                : Text(tittle, style: Theme.of(context).textTheme.headline3),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitch() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Transform.scale(
            scale: 1.0,
            child: Padding(
              padding: const EdgeInsets.only(left: _kLabelSpacing * 1.5),
              child: Switch(
                value: _lights,
                onChanged: (bool value) async {
                  setState(() {
                    _lights = value;
                    bool status = !_lights;
                    OneSignal.shared.disablePush(push!);
                  });
                  //
                },
                activeColor: AppTheme.kactivebackColor,
                activeTrackColor: AppTheme.kactiveTrackColor,
                inactiveThumbColor: AppTheme.kIndicatorColor,
                inactiveTrackColor: AppTheme.kinactiveTrackColor,
              ),
            ),
          ),
        ]);
  }

  Widget _buildNotification() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.language != null && widget.language != "English"
            ? Container(
                padding: EdgeInsets.all(16),
                child: TranslationWidget(
                  message: "Enable Notification",
                  fromLanguage: "en",
                  toLanguage: widget.language,
                  builder: (translatedMessage) => Padding(
                    padding: const EdgeInsets.only(left: _kLabelSpacing),
                    child: Text(translatedMessage.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(fontWeight: FontWeight.normal)),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: _kLabelSpacing),
                child: Text("Enable Notification",
                    style: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(fontWeight: FontWeight.normal)),
              ),
        _buildSwitch(),
      ],
    );
  }

  Widget _buildLicence() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Licenceinfo(
                      language: widget.language,
                    )));

        // urlobj.callurlLaucher(context, "https://www.google.com/");
      },
      child: Container(
        padding: EdgeInsets.all(16),
        child: widget.language != null && widget.language != "English"
            ? TranslationWidget(
                message: "Open Source licences",
                fromLanguage: "en",
                toLanguage: widget.language,
                builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(fontWeight: FontWeight.normal)),
              )
            : Text("Open Source licences",
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(fontWeight: FontWeight.normal)),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          appBarTitle: 'Setting',
          isSearch: false,
          isShare: false,
          sharedpopBodytext: '',
          sharedpopUpheaderText: '',
          language: widget.language,
        ),
        body: Container(
            child: ListView(
          children: [
            _buildHeading("Push Notifcation"),
            _buildNotification(),
            _buildHeading("Acknowledgements"),
            _buildLicence(),
            HorzitalSpacerWidget(_kLabelSpacing * 20),
            SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: 100.0,
                child: ShareButtonWidget(
                  language: widget.language,
                )),
          ],
        )),
        bottomNavigationBar: widget.isbuttomsheet && Globals.homeObjet != null
            ? InternalButtomNavigationBar()
            : null);
  }
}
