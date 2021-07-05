import 'package:app/src/locale/app_translations.dart';
import 'package:app/src/modules/home/ui/drawer.dart';
import 'package:app/src/widgets/customerappbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _lights = false;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // color: AppTheme.subHeadingbackgroundcolor,
                boxShadow: [
                  const BoxShadow(
                    // color: AppTheme.subHeadingbackgroundcolor2,
                    spreadRadius: 0,
                    blurRadius: 0,
                    offset: Offset(0, -0.5),
                  ),
                ],
              ),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Push Notification",
                  ),
                ),
              ]),
            ),
            Container(
              padding: EdgeInsets.only(top: 7, bottom: 7),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      // color: AppTheme.iconBackgroundColor,
                      shape: BoxShape.circle),
                  child: Icon(
                    const IconData(0xe811, fontFamily: 'FeverTrackingIcons'),
                    // color: AppTheme.iconColor1,
                    size: 26,
                  ),
                ),
                //minLeadingWidth: 30,
                title: Text(
                  "Reminders",
                  style: TextStyle(
                    // color: AppTheme.textColor1,
                    letterSpacing: 0,
                    fontFamily: "SF UI Display Regular",
                    // fontSize: globals.deviceType == 'phone' ? 17 : 25
                  ),
                ),
                trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Transform.scale(
                        scale: 1.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 28.0, right: 0),
                          child: CupertinoSwitch(
                            value: _lights,
                            onChanged: (bool value) {
                              setState(() {
                                _lights = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ]),
                selected: true,
                onTap: () {},
              ),
            ),
            Container(
              height: 0.7,
              margin: EdgeInsets.only(left: 65),
              decoration: BoxDecoration(
                  // color: AppTheme.dividerColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
