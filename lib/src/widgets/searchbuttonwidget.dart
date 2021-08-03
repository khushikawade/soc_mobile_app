import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/ui/search.dart';
import 'package:Soc/src/overrides.dart';
import 'package:flutter/material.dart';

class SearchButtonWidget extends StatelessWidget {
  static const double _kIconSize = 45.0;
  String? language;
  SearchButtonWidget({
    Key? key,
    required this.language,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchPage(
                        isbuttomsheet: true,
                        language: language,
                      )));
        },
        icon: Icon(
          const IconData(0xe805,
              fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
          size: Globals.deviceType == "phone" ? 22 : 30,
        ));
  }
}
