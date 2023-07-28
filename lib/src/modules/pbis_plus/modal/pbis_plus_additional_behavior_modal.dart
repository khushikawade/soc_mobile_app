import 'package:hive/hive.dart';
part 'pbis_plus_additional_behavior_modal.g.dart';

@HiveType(typeId: 48)
class PbisPlusAdditionalBehaviorList {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? activeStatusC;
  @HiveField(2)
  String? iconUrlC;
  @HiveField(3)
  String? name;
  @HiveField(4)
  String? sortOrderC;
  @HiveField(5)
  String? createdById;
  @HiveField(6)
  String? lastModifiedById;

  PbisPlusAdditionalBehaviorList({
    required this.id,
    required this.activeStatusC,
    required this.iconUrlC,
    required this.name,
    required this.sortOrderC,
    required this.createdById,
    required this.lastModifiedById,
  });

  factory PbisPlusAdditionalBehaviorList.fromJson(Map<String, dynamic> json) =>
      PbisPlusAdditionalBehaviorList(
        id: json["Id"] ?? null,
        activeStatusC: json["Active_Status__c"] ?? null,
        iconUrlC: json["Icon_URL__c"] ?? null,
        name: json["Name"] ?? null,
        sortOrderC: json["Sort_Order__c"] ?? null,
        createdById: json["CreatedById"] ?? null,
        lastModifiedById: json["LastModifiedById"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Active_Status__c": activeStatusC,
        "Icon_URL__c": iconUrlC,
        "Name": name,
        "Sort_Order__c": sortOrderC,
        "CreatedById": createdById,
        "LastModifiedById": lastModifiedById,
      };
}
