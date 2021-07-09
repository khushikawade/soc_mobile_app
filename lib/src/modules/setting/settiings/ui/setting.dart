import 'package:app/src/locale/app_translations.dart';
import 'package:app/src/modules/home/ui/drawer.dart';
import 'package:app/src/overrides.dart';
import 'package:app/src/styles/theme.dart';
import 'package:app/src/widgets/customerappbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static const double _kLabelSpacing = 18.0;
  bool _lights = false;

  //style
  final TextStyle headingtextStyle = TextStyle(
    height: 1.5,
    fontFamily: "Roboto Medium",
    fontSize: 16,
    color: AppTheme.kFontColor2,
  );

  final TextStyle textStyle = TextStyle(
    height: 1.5,
    fontFamily: "Roboto Regular",
    fontSize: 16,
    color: AppTheme.kAccentColor,
  );

  Widget _buildHeading(String tittle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(
              top: _kLabelSpacing / 2, bottom: _kLabelSpacing / 2),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: AppTheme.kOnPrimaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: _kLabelSpacing),
            child: Text(tittle, style: headingtextStyle),
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
                  });
                },
                activeColor: Color(0xff548952),
                activeTrackColor: Color(0xffCDECE1),
                inactiveThumbColor: Color(0xff548952),
                inactiveTrackColor: Color(0xffd4d4d4),
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
            leading: Text("Enable Notification", style: textStyle),
            trailing: _buildSwitch(),
          ),
        )
      ],
    );
  }

  Widget _buildtext() {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            leading: Text("Open Source licences", style: textStyle),
          ),
        )
      ],
    );
  }

  Widget buttomButtonsWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _kLabelSpacing,
        vertical: _kLabelSpacing / 2,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {},
              child: Text("Share this app"),
            ),
          ),
          SizedBox(
            width: _kLabelSpacing / 2,
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {},
              child: Text("I need support"),
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: _kLabelSpacing / 2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                const IconData(0xe80d,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color: Color(0xff171717),
                size: 20,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeading("Push Notifcation"),
            _buildNotification(),
            _buildHeading("Acknowledgements"),
            _buildtext(),
            Expanded(child: Container()),
            buttomButtonsWidget(),
          ],
        ),
      ),
    );
  }
}
