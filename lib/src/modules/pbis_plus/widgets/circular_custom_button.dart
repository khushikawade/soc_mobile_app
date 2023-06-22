import 'package:Soc/src/globals.dart';
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
  TextStyle? style;
  CircularCustomButton({
    Key? key,
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
    required double? buttonRadius,
    TextStyle? style,
  }) : super(key: key) {
    this.text = text ?? 'Press';
    this.backgroundColor = backgroundColor ?? AppTheme.kButtonColor;
    this.borderColor = borderColor ?? backgroundColor ?? AppTheme.kButtonColor;
    this.textColor = textColor ?? Colors.white;
    this.onClick = onClick ?? () => {};
    this.padding = padding ?? EdgeInsets.zero;
    this.size = size ?? Size(140, 40);
    this.isBusy = isBusy ?? false;
    this.buttonRadius = buttonRadius ?? 64;
    this.style = style ??
        TextStyle(
          fontSize: Globals.deviceType == "phone"
              ? AppTheme.kBodyText1FontSize
              : AppTheme.kBodyText1FontSize + AppTheme.kSize,
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontFamily: 'Roboto Regular',
          height: 1.5,
        );
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
          child: isBusy!
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 14,
                      width: 14,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: AppTheme.kButtonColor,
                      )),
                )
              : Text((text!),
                  textAlign: TextAlign.center,
                  style: style ??
                      Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: textColor, fontSize: 12)),
        ));
  }
}
