import 'package:Soc/src/globals.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/widgets/custom_icon_widget.dart';
import 'package:flutter/material.dart';

class AppLogoWidget extends StatelessWidget {
  final double? marginLeft;

  AppLogoWidget({
    Key? key,
    required this.marginLeft,
  }) : super(key: key);

  static const double _kIconSize = 50;

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          right: Overrides.STANDALONE_GRADED_APP == true ? 0 : 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              //width: 130,
              padding: EdgeInsets.only(left: marginLeft ?? 0),
              height:
                  Globals.deviceType == "phone" ? _kIconSize : _kIconSize * 1.2,
              child: Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: ClipRRect(
                      child: CustomIconWidget(
                          darkModeIconUrl: null,
                          iconUrl: Globals.appSetting.appLogoC)))),
        ],
      ),
    );
  }
}
