import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

// class PlusScreenTitleWidget extends StatelessWidget {
//   final double kLabelSpacing;
//   final String text;
//   final bool? backButton;
//   final bool? isTrailingIcon;
//   final Function()? backButtonOnTap;

//   const PlusScreenTitleWidget(
//       {Key? key,
//       required this.kLabelSpacing,
//       required this.text,
//       this.isTrailingIcon,
//       this.backButton = false,
//       this.backButtonOnTap})
//       : super(key: key);
class PlusScreenTitleWidget extends StatefulWidget {
  final double kLabelSpacing;
  final String text;
  final bool? backButton;
  final bool? isTrailingIcon;
  final Function()? backButtonOnTap;

  const PlusScreenTitleWidget({
    Key? key,
    required this.kLabelSpacing,
    required this.text,
    this.isTrailingIcon,
    this.backButton = false,
    this.backButtonOnTap,
  }) : super(key: key);

  @override
  _PlusScreenTitleWidgetState createState() => _PlusScreenTitleWidgetState();
}

class _PlusScreenTitleWidgetState extends State<PlusScreenTitleWidget> {
  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 0, horizontal: widget.kLabelSpacing / 2),
      child: Row(
        children: <Widget>[
          if (widget.backButton == true)
            IconButton(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.zero,
              onPressed: widget.backButtonOnTap ??
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
            width: widget.isTrailingIcon == true
                ? MediaQuery.of(context).size.width * 0.6
                : MediaQuery.of(context).size.width * 0.75,
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Utility.textWidget(
                  text: widget.text,
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
