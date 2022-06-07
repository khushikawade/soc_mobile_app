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
  CustomRubicModal(
      {this.name,
      this.score,
      this.imgBase64,
      this.imgUrl,
      this.customOrStandardRubic});
}

class RubricScoreList {
  static List<CustomRubicModal> scoringList = [
    CustomRubicModal(
        name: "NYC",
        score: '0-2',
        imgBase64: null,
        customOrStandardRubic: "Standard"),
    CustomRubicModal(
        name: "Custom",
        score: '',
        imgBase64: null,
        customOrStandardRubic: "Standard"),
    CustomRubicModal(
        name: "NYC",
        score: '0-3',
        imgBase64: null,
        customOrStandardRubic: "Standard"),
    CustomRubicModal(
        name: "None",
        score: '',
        imgBase64: null,
        customOrStandardRubic: "Standard"),
    CustomRubicModal(
        name: "NYC",
        score: '0-4',
        imgBase64: null,
        customOrStandardRubic: "Standard"),
  ];
}
