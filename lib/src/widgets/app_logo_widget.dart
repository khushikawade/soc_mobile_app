import 'package:Soc/src/globals.dart';
import 'package:flutter/material.dart';

class AppLogoWidget extends StatelessWidget {
  static const double _kIconSize = 45.0;

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
            height:
                Globals.deviceType == "phone" ? _kIconSize : _kIconSize * 1.2,
            width: Globals.deviceType == "phone"
                ? _kIconSize * 1.75
                : _kIconSize * 1.95,
            child: Padding(
              padding: const EdgeInsets.only(top: 7.0),
              child: Image.asset(
                'assets/images/bear.png',
                fit: BoxFit.fill,
                height: Globals.deviceType == "phone"
                    ? _kIconSize * 1.2
                    : _kIconSize * 1.4,
                width: Globals.deviceType == "phone"
                    ? _kIconSize * 2
                    : _kIconSize * 2.2,
              ),
            )),
      ],
    );
  }
}
