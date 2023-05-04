import 'dart:io';

import 'package:hive/hive.dart';
part 'custom_rubic_modal.g.dart';

@HiveType(typeId: 20)
class CustomRubricModal {
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
  CustomRubricModal(
      {this.name,
      this.score,
      this.imgBase64,
      this.imgUrl,
      this.customOrStandardRubic,
      this.filePath});
}

class RubricScoreList {
  static List<CustomRubricModal> scoringList = [
    CustomRubricModal(
        name: "NYS",
        score: '0-2',
        imgBase64: null,
        imgUrl: null,
        customOrStandardRubic: "Standard",
        filePath: null),
    CustomRubricModal(
        name: "Custom",
        score: '',
        imgBase64: null,
        imgUrl: null,
        customOrStandardRubic: "Standard",
        filePath: null),
    CustomRubricModal(
        name: "NYS",
        score: '0-3',
        imgBase64: null,
        imgUrl: null,
        customOrStandardRubic: "Standard",
        filePath: null),
    CustomRubricModal(
        name: "None",
        score: '',
        imgBase64: null,
        imgUrl: null,
        customOrStandardRubic: "Standard",
        filePath: null),
    CustomRubricModal(
        name: "NYS",
        score: '0-4',
        imgBase64: null,
        imgUrl: null,
        customOrStandardRubic: "Standard",
        filePath: null),
  ];
}
