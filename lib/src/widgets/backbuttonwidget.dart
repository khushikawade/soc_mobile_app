import 'package:Soc/src/globals.dart';
import 'package:Soc/src/overrides.dart';
import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 5.0,
          ),
          child: Container(
            padding: const EdgeInsets.all(0.0),
            width: 40.0,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                const IconData(0xe80d,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                size: Globals.deviceType == "phone" ? 20 : 28,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
