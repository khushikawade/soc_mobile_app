import 'package:Soc/src/app.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/share_button.dart';
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
  // final TextStyle _kheadingStyle = TextStyle(
  //   height: 1.5,
  //   fontFamily: "Roboto Medium",
  //   fontSize: 16,
  //   color: AppTheme.kFontColor2,
  // );

  final TextStyle textStyle = TextStyle(
    height: 1.5,
    fontFamily: "Roboto Regular",
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppTheme.kAccentColor,
  );

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
                  });
                },
                activeColor: Color(0xff548952),
                activeTrackColor: Color(0xffCDECE1),
                inactiveThumbColor: AppTheme.kIndicatorColor,
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
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              leading: Text("Open Source licences", style: textStyle),
            ),
          )
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
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
            SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: 100.0,
                child: ButtonWidget()),
          ],
        ),
      ),
    );
  }
}
