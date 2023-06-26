import 'package:hive/hive.dart';
part 'pbis_plus_default_behaviour_modal.g.dart';

@HiveType(typeId: 46)
class PBISPlusDefaultAndCustomBehaviourModal extends HiveObject {
  @HiveField(0)
  List<PBISPlusDefaultBehaviourModal>? defaultList;
  @HiveField(1)
  List<PBISPlusDefaultBehaviourModal>? customList;

  PBISPlusDefaultAndCustomBehaviourModal({
    this.defaultList,
    this.customList,
  });

  factory PBISPlusDefaultAndCustomBehaviourModal.fromJson(
    Map<String, dynamic> json,
  ) {
    return PBISPlusDefaultAndCustomBehaviourModal(
      defaultList: json['defaultList'] != null
          ? (json['defaultList'] as List<dynamic>)
              .map((item) => PBISPlusDefaultBehaviourModal.fromJson(item))
              .toList()
          : [],
      customList: json['customList'] != null
          ? (json['customList'] as List<dynamic>)
              .map((item) => PBISPlusDefaultBehaviourModal.fromJson(item))
              .toList()
          : [],
    );
  }
}

@HiveType(typeId: 47)
class PBISPlusDefaultBehaviourModal extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? behaviourId;
  @HiveField(2)
  String? sortingOrder;
  @HiveField(3)
  String? teacherId;
  @HiveField(4)
  String? createdAt;
  @HiveField(5)
  String? updatedAt;
  @HiveField(6)
  String? name;
  @HiveField(7)
  String? iconUrl;
  @HiveField(8)
  String? isdefault;

  PBISPlusDefaultBehaviourModal({
    required this.id,
    required this.behaviourId,
    required this.sortingOrder,
    required this.createdAt,
    required this.updatedAt,
    required this.teacherId,
    required this.name,
    required this.iconUrl,
    required this.isdefault,
  });

  PBISPlusDefaultBehaviourModal.fromJson(Map<String, dynamic> json) {
    id = json['Id'] ?? '';
    behaviourId = json['Behaviour_Id'] ?? '';
    sortingOrder = json["Sorting_Order"] ?? "";
    teacherId = json['Teacher_Id'] ?? "";
    iconUrl = json['Icon_URL'].toString().contains('http')
        ? json['Icon_URL']
        : 'https:' + json['iconUrlC'] ?? '';
    name = json['Name'] ?? '';
    updatedAt = json['UpdatedAt'] ?? '';
    createdAt = json["CreatedAt"] ?? "";
    isdefault = json['Default'] ?? "false";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Behaviour_Id'] = this.behaviourId;
    data['Sorting_Order'] = this.sortingOrder;
    data['Teacher_Id'] = this.teacherId;
    data['Icon_URL'] = this.iconUrl;
    data['Name'] = this.name;
    data['UpdatedAt'] = this.updatedAt;
    data['CreatedAt'] = this.createdAt;
    data['UpdatedAt'] = this.updatedAt;
    data['Default'] = this.isdefault;
    return data;
  }
}
