import 'dart:convert';
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
  CustomRubicModal({this.name, this.score, this.imgBase64, this.imgUrl});
}
