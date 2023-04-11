//custom floating action button
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_icons.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

class PBISPlusCustomFloatingActionButton extends StatelessWidget {
  const PBISPlusCustomFloatingActionButton({Key? key, required this.onPressed})
      : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: 50),
            child: FloatingActionButton(
              backgroundColor: AppTheme.kButtonColor,
              onPressed: onPressed,
              child: Icon(PBISPlusIcons.PBISPlus_plus_floating,
                  color: Theme.of(context).backgroundColor),
            )),
      ],
    );
  }
}
