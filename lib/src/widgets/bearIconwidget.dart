import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

class BearIconWidget extends StatelessWidget {
  static const double _kIconSize = 36.0;

  final TextStyle buttonstyle = TextStyle(
    height: 1.5,
    fontFamily: "Roboto Regular",
    fontSize: 14,
    color: AppTheme.kFontColor2,
  );

  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
              height: _kIconSize,
              width: _kIconSize * 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Image.asset(
                  'assets/images/bear.png',
                  fit: BoxFit.fill,
                  height: _kIconSize,
                  width: _kIconSize * 2,
                ),
              )),
        ],
      ),
    );
  }
}
