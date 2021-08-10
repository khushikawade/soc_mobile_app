import 'package:Soc/src/globals.dart';
import 'package:flutter/material.dart';

class NoDataIconWidget extends StatelessWidget {
  static const double _kIconSize = 45.0;

  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 250,
      child: Image.asset('assets/images/no_data_icon.png', fit: BoxFit.fill),
    );
  }
}
