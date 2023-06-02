import 'package:flutter/material.dart';

class ResultSummeryDetailModel {
  double? width;
  String? value; //Response Value //0,1,2,3,4, //A,B,C,D,E
  String? pointPossible;
  int? count;
  Color? color;

  ResultSummeryDetailModel(
      {this.count, this.width, this.value, this.color, this.pointPossible});
}
