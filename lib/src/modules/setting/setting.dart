import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/share_button.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static const double _kLabelSpacing = 18.0;
  bool _lights = true;
  UrlLauncherWidget urlobj = new UrlLauncherWidget();

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
            child: Text(tittle, style: Theme.of(context).textTheme.headline3),
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
                onChanged: (bool value) {
                  setState(() {
                    _lights = value;
                    bool status = !value;
                    OneSignal.shared.disablePush(status);
                  });
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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListTile(
            leading: Text("Enable Notification",
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(fontWeight: FontWeight.normal)),
            trailing: _buildSwitch(),
          ),
        )
      ],
    );
  }

  Widget _buildLicence() {
    return InkWell(
      onTap: () {
        urlobj.callurlLaucher(context, "https://www.google.com/");
      },
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              leading: Text("Open Source licences",
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontWeight: FontWeight.normal)),
            ),
          )
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        appBarTitle: 'Empty',
        isSearch: false,
        isShare: false,
        sharedpopBodytext: '',
        sharedpopUpheaderText: '',
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeading("Push Notifcation"),
            _buildNotification(),
            _buildHeading("Acknowledgements"),
            _buildLicence(),
            Expanded(child: Container()),
            SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: 100.0,
                child: ShareButtonWidget()),
          ],
        ),
      ),
    );
  }
}
