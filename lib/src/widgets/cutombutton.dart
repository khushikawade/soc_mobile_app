import 'package:flutter/material.dart';
import 'package:app/src/styles/theme.dart';

class Custombuttom extends StatelessWidget {
  String label;
  Color bakcolor;
  final double _kbuttonsize;

  Custombuttom(this.label, this.bakcolor, this._kbuttonsize);

  final TextStyle buttonstyle = TextStyle(
    height: 1.5,
    fontFamily: "Roboto Regular",
    fontSize: 14,
    color: AppTheme.kFontColor2,
  );

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: _kbuttonsize,
        alignment: Alignment.center,
        color: bakcolor,
        child:
            new Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          new Text(
            label,
            style: buttonstyle,
          ),
        ]),
      ),
    );
  }
}
