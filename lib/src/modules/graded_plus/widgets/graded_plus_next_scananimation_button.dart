import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

class GradedPlusNextScanAnimationButton extends StatefulWidget {
  final Duration animationDuration;
  final double height;
  final double width;
  final double borderRadius;
  bool animationStart;

  GradedPlusNextScanAnimationButton(
      {this.animationDuration = const Duration(milliseconds: 1000),
      this.height = 30,
      this.width = 130.0,
      this.borderRadius = 10.0,
      required this.animationStart});

  @override
  _GradedPlusNextScanAnimationButtonState createState() =>
      _GradedPlusNextScanAnimationButtonState();
}

class _GradedPlusNextScanAnimationButtonState
    extends State<GradedPlusNextScanAnimationButton> {
  // double _animatedWidth = 0.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Stack(
        children: [
          Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              color: Color.fromARGB(255, 144, 231, 224),
            ),
          ),
          AnimatedContainer(
            duration: widget.animationDuration,
            height: widget.height,
            //   width: MediaQuery.of(context).size.width * 0.3,
            width: widget.animationStart ? widget.width : 0.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: AppTheme.kButtonColor),
          ),
          Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              color: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.play_arrow,
                  color: Colors.black87,
                ),
                Text(
                  'Next Scan',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
