//custom floating action button
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

class GradedPlusCustomFloatingActionButton extends StatelessWidget {
  GradedPlusCustomFloatingActionButton(
      {Key? key,
      required this.onPressed,
      this.backgroundColor = AppTheme.kButtonColor,
      this.title,
      this.icon,
      this.fabWidth,
      required this.isExtended,
      this.heroTag,
      this.padding,
      this.textTheme})
      : super(key: key);

  final VoidCallback onPressed;
  final Color? backgroundColor;
  final String? title;
  final Widget? icon;
  final bool isExtended;
  final double? fabWidth;
  final String? heroTag;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textTheme;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 30),
      child: FloatingActionButton.extended(
          heroTag: heroTag,
          isExtended: isExtended,
          extendedPadding: isExtended
              ? EdgeInsets.symmetric(horizontal: 20)
              : EdgeInsets.all(10),
          backgroundColor: backgroundColor,
          onPressed: onPressed,
          icon: icon,
          label: !isExtended
              ? Container()
              : Container(
                  alignment: Alignment.center,
                  width: fabWidth,
                  child: Utility.textWidget(
                      maxLines: 1,
                      context: context,
                      text: title!,
                      textTheme: textTheme ??
                          Theme.of(context).textTheme.headline2!.copyWith(
                              color: Theme.of(context).backgroundColor)),
                )),
    );
  }
}
