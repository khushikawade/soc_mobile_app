import 'package:flutter/material.dart';

class HorzitalSpacerWidget extends StatelessWidget {
  final double width;
  HorzitalSpacerWidget(this.width);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}
