// --------- Modal to map State_and_Standards_Gradedplus__c Object data -----------
import 'dart:convert';
import 'package:hive/hive.dart';
part 'state_object_modal.g.dart';

StateListObject stateListObjectFromJson(String str) =>
    StateListObject.fromJson(json.decode(str));

String stateListObjectToJson(StateListObject data) =>
    json.encode(data.toJson());

@HiveType(typeId: 29)
class StateListObject {
  StateListObject({
    this.gradedplusRubricC,
    this.standardsPdfC,
    this.stateC,
    this.titleC,
    this.usedInC,
    this.id,
    this.dateTime,
  });
  @HiveField(0)
  String? gradedplusRubricC;
  @HiveField(1)
  String? standardsPdfC;
  @HiveField(2)
  String? stateC;
  @HiveField(3)
  String? titleC;
  @HiveField(4)
  String? usedInC;
  @HiveField(5)
  String? id;
  @HiveField(6)
  DateTime? dateTime;

  factory StateListObject.fromJson(Map<String, dynamic> json) =>
      StateListObject(
        gradedplusRubricC: json["Gradedplus_Rubric__c\t"],
        standardsPdfC: json["Standards_PDF__c"],
        stateC: json["State__c"] == null ? null : json["State__c"],
        titleC: json["Title__c"] == null ? null : json["Title__c"],
        usedInC: json["Used_in__c"] == null ? null : json["Used_in__c"],
        id: json["Id"] == null ? null : json["Id"],
      );

  Map<String, dynamic> toJson() => {
        "Gradedplus_Rubric__c\t": gradedplusRubricC,
        "Standards_PDF__c": standardsPdfC,
        "State__c": stateC == null ? null : stateC,
        "Title__c": titleC == null ? null : titleC,
        "Used_in__c": usedInC == null ? null : usedInC,
        "Id": id == null ? null : id,
      };
}
