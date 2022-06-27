import 'package:flutter/material.dart';

class NetflixCustomButton extends StatefulWidget {
  final Duration animationDuration;
  final double height;
  final double width;
  final double borderRadius;
  final double animatedWidth;

  const NetflixCustomButton(
      {this.animationDuration = const Duration(milliseconds: 800),
      this.height = 30,
      this.width = 130.0,
      this.borderRadius = 10.0,
      required this.animatedWidth});

  @override
  _NetflixCustomButtonState createState() => _NetflixCustomButtonState();
}

class _NetflixCustomButtonState extends State<NetflixCustomButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.transparent,
      onPressed: () {},
      label: Stack(
        children: [
          Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                widget.borderRadius,
              ),
              color: Colors.grey.shade100,
            ),
          ),
          AnimatedContainer(
            duration: widget.animationDuration,
            height: widget.height,
            width: widget.animatedWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                widget.borderRadius,
              ),
              color: Colors.white,
            ),
          ),
          Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                widget.borderRadius,
              ),
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
