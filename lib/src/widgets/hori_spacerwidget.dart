import 'package:flutter/material.dart';

class HorizontalSpacerWidget extends StatelessWidget {
  final double width;
  HorizontalSpacerWidget(this.width);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}
