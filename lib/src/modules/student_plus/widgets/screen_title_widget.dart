import 'package:Soc/src/services/utility.dart';
import 'package:flutter/material.dart';

class StudentPlusScreenTitleWidget extends StatelessWidget {
  final double kLabelSpacing;
  final String text;
  const StudentPlusScreenTitleWidget(
      {Key? key, required this.kLabelSpacing, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: kLabelSpacing / 2),
      child: Utility.textWidget(text: text, context: context),
    );
  }
}
