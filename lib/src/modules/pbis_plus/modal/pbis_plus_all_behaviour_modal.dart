import 'package:hive/hive.dart';
part 'pbis_plus_all_behaviour_modal.g.dart';

// @HiveType(typeId: 46)
// class PBISPlusALLBehaviourModal {
//   @HiveField(0)
//   List<PBISPlusALLBehaviourModal>? defaultList;
//   @HiveField(1)
//   List<PBISPlusALLBehaviourModal>? customList;

//   PBISPlusALLBehaviourModal({
//     this.defaultList,
//     this.customList,
//   });

//   factory PBISPlusALLBehaviourModal.fromJson(
//     Map<String, dynamic> json,
//   ) {
//     return PBISPlusALLBehaviourModal(
//       defaultList: json['defaultList'] != null
//           ? (json['defaultList'] as List<dynamic>)
//               .map((item) => PBISPlusALLBehaviourModal.fromJson(item))
//               .toList()
//           : [],
//       customList: json['customList'] != null
//           ? (json['customList'] as List<dynamic>)
//               .map((item) => PBISPlusALLBehaviourModal.fromJson(item))
//               .toList()
//           : [],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'defaultList': defaultList?.map((item) => item.toJson()).toList(),
//       'customList': customList?.map((item) => item.toJson()).toList(),
//     };
//   }
// }

// @HiveType(typeId: 49)
// class PBISPlusALLBehaviourModal {
//   @HiveField(0)
//   int? id;
//   @HiveField(1)
//   String? behaviourId;
//   @HiveField(2)
//   String? sortingOrder;
//   @HiveField(3)
//   String? teacherId;
//   @HiveField(4)
//   String? createdAt;
//   @HiveField(5)
//   String? updatedAt;
//   @HiveField(6)
//   String? name;
//   @HiveField(7)
//   String? iconUrl;
//   @HiveField(8)
//   String? isdefault;

//   PBISPlusALLBehaviourModal({
//     required this.id,
//     required this.behaviourId,
//     required this.sortingOrder,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.teacherId,
//     required this.name,
//     required this.iconUrl,
//     required this.isdefault,
//   });

//   PBISPlusALLBehaviourModal.fromJson(Map<String, dynamic> json) {
//     id = json['Id'] ?? '';
//     behaviourId = json['Behaviour_Id'] ?? '';
//     sortingOrder = json["Sorting_Order"] ?? "";
//     teacherId = json['Teacher_Id'] ?? "";
//     iconUrl = json['Icon_URL'].toString().contains('http')
//         ? json['Icon_URL']
//         : 'https:' + json['iconUrlC'] ?? '';
//     name = json['Name'] ?? '';
//     updatedAt = json['UpdatedAt'] ?? '';
//     createdAt = json["CreatedAt"] ?? "";
//     isdefault = json['Default'] ?? "false";
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Id'] = this.id;
//     data['Behaviour_Id'] = this.behaviourId;
//     data['Sorting_Order'] = this.sortingOrder;
//     data['Teacher_Id'] = this.teacherId;
//     data['Icon_URL'] = this.iconUrl;
//     data['Name'] = this.name;
//     data['UpdatedAt'] = this.updatedAt;
//     data['CreatedAt'] = this.createdAt;
//     data['UpdatedAt'] = this.updatedAt;
//     data['Default'] = this.isdefault;
//     return data;
//   }
// }

@HiveType(typeId: 49)
class PBISPlusALLBehaviourModal {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? activeStatusC;
  @HiveField(2)
  String? behaviorTitleC;
  @HiveField(3)
  String? mobileAppC;
  @HiveField(4)
  String? pBISBehaviorIconURLC;
  @HiveField(5)
  String? pBISBehaviorSortOrderC;
  @HiveField(6)
  String? name;
  @HiveField(7)
  String? pBISSoundC;
  @HiveField(8)
  String? createdById;
  @HiveField(9)
  String? lastModifiedById;
  @HiveField(10)
  String? ownerId;

  PBISPlusALLBehaviourModal(
      {this.id,
      this.activeStatusC,
      this.behaviorTitleC,
      this.mobileAppC,
      this.pBISBehaviorIconURLC,
      this.pBISBehaviorSortOrderC,
      this.name,
      this.pBISSoundC,
      this.createdById,
      this.lastModifiedById,
      this.ownerId});

  PBISPlusALLBehaviourModal.fromJson(Map<String, dynamic> json) {
    id = json['Id'] ?? "";
    activeStatusC = json['Active_Status__c'] ?? '';
    behaviorTitleC = json['Behavior_Title__c'] ?? '';
    mobileAppC = json['Mobile_App__c'] ?? '';
    pBISBehaviorIconURLC = json['PBIS_Behavior_Icon_URL__c'] ?? '';
    pBISBehaviorSortOrderC = json['PBIS_Behavior_Sort_Order__c'] ?? '';
    name = json['Name'] ?? "";
    pBISSoundC = json['PBIS_Sound__c'] ?? '';
    createdById = json['CreatedById'] ?? "";
    lastModifiedById = json['LastModifiedById'] ?? '';
    ownerId = json['OwnerId'] ?? '';
  }

  PBISPlusALLBehaviourModal.fromJsonForAdditionalBehaviour(
      Map<String, dynamic> json) {
    id = json['Id'] ?? '';
    activeStatusC = json['Active_Status__c'] ?? "";
    behaviorTitleC = json['Name'] ?? '';
    mobileAppC = json['Mobile_App__c'] ?? '';
    pBISBehaviorIconURLC = json['Icon_URL__c'] ?? "";
    name = json['Name'] ?? "";
    pBISSoundC = json['PBIS_Sound__c'] ?? '';
    pBISBehaviorSortOrderC = json['Sort_Order__c'] ?? '';
    createdById = json['CreatedById'] ?? '';
    lastModifiedById = json['LastModifiedById'] ?? '';
    ownerId = json['OwnerId'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Active_Status__c'] = this.activeStatusC;
    data['Behavior_Title__c'] = this.behaviorTitleC;
    data['Mobile_App__c'] = this.mobileAppC;
    data['PBIS_Behavior_Icon_URL__c'] = this.pBISBehaviorIconURLC;
    data['PBIS_Behavior_Sort_Order__c'] = this.pBISBehaviorSortOrderC;
    data['Name'] = this.name;
    data['PBIS_Sound__c'] = this.pBISSoundC;
    data['CreatedById'] = this.createdById;
    data['LastModifiedById'] = this.lastModifiedById;
    data['OwnerId'] = this.ownerId;
    return data;
  }
}
