import 'dart:async';

import 'package:flutter/material.dart';

class Bouncing extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPress;

  Bouncing({required this.child, Key? key, this.onPress}) : super(key: key);

  @override
  _BouncingWidgetState createState() => _BouncingWidgetState();
}

class _BouncingWidgetState extends State<Bouncing>
    with SingleTickerProviderStateMixin {
  late Animation<double> _scale;
  late AnimationController _controller;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.8)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        _controller.forward();
      },
      onPointerUp: (PointerUpEvent event) {
        _timer = Timer(Duration(milliseconds: 180), () {
          _controller.reverse();
          if (widget.onPress == null) return;
          widget.onPress!();
        });
      },
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
