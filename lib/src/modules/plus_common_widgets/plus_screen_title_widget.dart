import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

class PlusScreenTitleWidget extends StatelessWidget {
  final double kLabelSpacing;
  final String text;
  final bool? backButton;
  final Function()? backButtonOnTap;

  const PlusScreenTitleWidget(
      {Key? key,
      required this.kLabelSpacing,
      required this.text,
      this.backButton = false,
      this.backButtonOnTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: kLabelSpacing / 2),
      child: Row(
        children: [
          if (backButton == true)
            IconButton(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.zero,
              onPressed: backButtonOnTap ??
                  () {
                    Navigator.of(context).pop();
                  },
              icon: Icon(
                IconData(0xe80d,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color: AppTheme.kButtonColor,
              ),
            ),
          Container(
            width: MediaQuery.of(context).size.width * 0.72,
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Utility.textWidget(
                  text: text,
                  context: context,
                  textAlign: TextAlign.left,
                  textTheme: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
