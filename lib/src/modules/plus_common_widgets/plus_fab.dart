//custom floating action button
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

class PlusCustomFloatingActionButton extends StatelessWidget {
  const PlusCustomFloatingActionButton({Key? key, required this.onPressed})
      : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        width: 40,
        margin: EdgeInsets.only(bottom: 30),
        child: FloatingActionButton(
          backgroundColor: AppTheme.kButtonColor,
          onPressed: onPressed,
          child: Icon(
              IconData(0xe868,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg),
              color: Theme.of(context).backgroundColor),
        ));
  }
}
