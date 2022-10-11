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
    // final Animation<double> _animation = CurvedAnimation(
    //   parent: controller!,

    //   //reverseCurve: Curve(),

    //   // Use whatever curve you would like, for more details refer to the Curves class
    //   curve: Curves.linear,
    // );

    return RotationTransition(
      alignment: Alignment.center,
      turns: turnsTween.animate(controller!), // _animation,

      // filterQuality: FilterQuality.medium,
      child: Icon(iconData, size: 22, color: Theme.of(context).backgroundColor),
    );
  }
}
