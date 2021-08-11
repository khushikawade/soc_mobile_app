import 'package:Soc/src/globals.dart';
import 'package:flutter/material.dart';

class ErrorIconWidget extends StatelessWidget {
  static const double _kIconSize = 45.0;

  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 250,
        width: 250,
        child: Image.asset('assets/images/error_icon.png', fit: BoxFit.fill),
      ),
    );
  }
}
