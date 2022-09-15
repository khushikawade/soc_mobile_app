import 'dart:io';

import 'package:hive/hive.dart';
part 'custom_rubic_modal.g.dart';

@HiveType(typeId: 20)
class CustomRubicModal {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? score;
  @HiveField(2)
  String? imgBase64;
  @HiveField(3)
  String? imgUrl;
  @HiveField(4)
  String? customOrStandardRubic;
  @HiveField(5)
  String? filePath;
  CustomRubicModal(
      {this.name,
      this.score,
      this.imgBase64,
      this.imgUrl,
      this.customOrStandardRubic,
      this.filePath});
}

class RubricScoreList {
  static List<CustomRubicModal> scoringList = [
    CustomRubicModal(
        name: "NYS",
        score: '0-2',
        imgBase64: null,
        imgUrl: null,
        customOrStandardRubic: "Standard",
        filePath: null),
    CustomRubicModal(
        name: "Custom",
        score: '',
        imgBase64: null,
        imgUrl: null,
        customOrStandardRubic: "Standard",
        filePath: null),
    CustomRubicModal(
        name: "NYS",
        score: '0-3',
        imgBase64: null,
        imgUrl: null,
        customOrStandardRubic: "Standard",
        filePath: null),
    CustomRubicModal(
        name: "None",
        score: '',
        imgBase64: null,
        imgUrl: null,
        customOrStandardRubic: "Standard",
        filePath: null),
    CustomRubicModal(
        name: "NYS",
        score: '0-4',
        imgBase64: null,
        imgUrl: null,
        customOrStandardRubic: "Standard",
        filePath: null),
  ];
}
