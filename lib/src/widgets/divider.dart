import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  final double margin;
  DividerWidget(this.margin);
  Widget build(BuildContext context) {
    return Container(
      height: 0.50,
      margin: EdgeInsets.symmetric(horizontal: margin),
      decoration: BoxDecoration(
        color: AppTheme.kDividerColor,
      ),
    );
  }
}
