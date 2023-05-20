//custom floating action button
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

class GradedPlusCustomFloatingActionButton extends StatelessWidget {
  GradedPlusCustomFloatingActionButton(
      {Key? key,
      required this.onPressed,
      this.backgroundColor = AppTheme.kButtonColor,
      this.title = 'Click Me',
      this.icon,
      this.fabWidth})
      : super(key: key);

  final VoidCallback onPressed;
  final Color? backgroundColor;
  final String? title;
  final Widget? icon;
  final double? fabWidth;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: FloatingActionButton.extended(
          isExtended: true,
          extendedPadding: EdgeInsets.symmetric(horizontal: 20),
          backgroundColor: backgroundColor,
          onPressed: onPressed,
          icon: icon,
          label: Container(
            alignment: Alignment.center,
            width: fabWidth,
            child: Utility.textWidget(
                context: context,
                text: title!,
                textTheme: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(color: Theme.of(context).backgroundColor)),
          )),
    );
  }
}
