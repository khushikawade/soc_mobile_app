import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

class CircularCustomButton extends StatelessWidget {
  Color? backgroundColor;
  Color? borderColor;
  Color? textColor;
  String? text;
  Function? onClick;
  Enum? buttonType;
  Enum? buttonSize;
  EdgeInsets? padding;
  Size? size;
  bool? isBusy;
  dynamic model;
  double? buttonRadius;

  CircularCustomButton(
      {Key? key,
      Color? borderColor,
      Color? textColor,
      required String? text,
      required Function? onClick,
      Enum? buttonType,
      Enum? buttonSize,
      EdgeInsets? padding,
      Size? size,
      required Color? backgroundColor,
      required bool? isBusy,
      required double? buttonRadius})
      : super(key: key) {
    this.text = text ?? 'Press';
    this.backgroundColor = backgroundColor ?? AppTheme.kButtonColor;
    this.borderColor = borderColor ?? backgroundColor ?? AppTheme.kButtonColor;
    this.textColor = textColor ?? Colors.white;
    this.onClick = onClick ?? () => {};
    this.padding = padding ?? EdgeInsets.zero;
    this.size = size ?? Size(140, 40);
    this.isBusy = isBusy ?? false;
    this.buttonRadius = buttonRadius ?? 64;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding!,
        child: ElevatedButton(
          onPressed: () {
            onClick!();
          },
          style: ElevatedButton.styleFrom(
              foregroundColor: AppTheme.kButtonColor,
              minimumSize: size,
              backgroundColor: backgroundColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(buttonRadius!),
                  side: BorderSide(color: borderColor!)),
              enableFeedback: false,
              animationDuration: Duration.zero,
              fixedSize: const Size(0, 20)),
          child: Text((text!),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: textColor, fontSize: 12)),
        ));
  }
}
