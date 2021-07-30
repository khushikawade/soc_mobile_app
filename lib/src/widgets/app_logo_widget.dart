import 'package:flutter/material.dart';

class AppLogoWidget extends StatelessWidget {
  static const double _kIconSize = 45.0;

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
            height: _kIconSize,
            width: _kIconSize * 1.75,
            child: Padding(
              padding: const EdgeInsets.only(top: 7.0),
              child: Image.asset(
                'assets/images/bear.png',
                fit: BoxFit.fill,
                height: _kIconSize * 1.2,
                width: _kIconSize * 2,
              ),
            )),
      ],
    );
  }
}
