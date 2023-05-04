import 'package:Soc/src/globals.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math; // import this

class SpinningIconButton extends AnimatedWidget {
  final VoidCallback? onPressed;
  final IconData? iconData;
  final AnimationController? controller;
  SpinningIconButton({Key? key, this.controller, this.iconData, this.onPressed})
      : super(key: key, listenable: controller!);

  Widget build(BuildContext context) {
    final Tween<double> turnsTween = Tween<double>(
      begin: 1,
      end: 0,
    );

    return RotationTransition(
      alignment: Alignment.center,
      turns: turnsTween.animate(controller!), // _animation,

      child: Icon(iconData,
          size: Globals.deviceType == "phone" ? 22 : 30,
          color: Theme.of(context).backgroundColor),
    );
  }
}
