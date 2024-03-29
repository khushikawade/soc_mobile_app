//custom floating action button
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

class PlusCustomFloatingActionButton extends StatelessWidget {
  Widget? icon;
  PlusCustomFloatingActionButton({Key? key, required this.onPressed, this.icon})
      : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: 60,
        margin: EdgeInsets.only(bottom: 30),
        child: FloatingActionButton(
          backgroundColor: AppTheme.ksaveAndShareButton,
          onPressed: onPressed,
          child: icon ??
              Icon(
                  IconData(0xe868,
                      fontFamily: Overrides.kFontFam,
                      fontPackage: Overrides.kFontPkg),
                  color: Theme.of(context).backgroundColor),
        ));
  }
}
