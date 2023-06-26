// import 'package:hive/hive.dart';
// part 'pbis_skill_modal.g.dart';

// @HiveType(typeId: 43)
// class PBISPlusSkillsModal extends HiveObject {
//   @HiveField(0)
//   late List<PBISPlusActionInteractionModal> dataList;

//   PBISPlusSkillsModal({
//     required this.dataList,
//   });

//   PBISPlusSkillsModal.fromJson(Map<String, dynamic> json) {
//     if (json['dataList'] != null) {
//       dataList = <PBISPlusActionInteractionModal>[];
//       json['dataList'].forEach((v) {
//         dataList!.add(new PBISPlusActionInteractionModal.fromJson(v));
//       });
//     } else {
//       dataList = [];
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.dataList != null) {
//       data['dataList'] = this.dataList!.map((v) => v.toJson()).toList();
//     } else {
//       data['dataList'] = [];
//     }
//     return data;
//   }
// }

// @HiveType(typeId: 44)
// class PBISPlusActionInteractionModal extends HiveObject {
//   @HiveField(0)
//   String? id;
//   @HiveField(1)
//   String? activeStatusC;
//   @HiveField(2)
//   String? iconUrlC;
//   @HiveField(3)
//   String? name;
//   @HiveField(4)
//   String? sortOrderC;
//   @HiveField(5)
//   String? counter;

//   PBISPlusActionInteractionModal({
//     required this.id,
//     required this.activeStatusC,
//     required this.iconUrlC,
//     required this.name,
//     required this.sortOrderC,
//     required this.counter,
//   });

//   PBISPlusActionInteractionModal.fromJson(Map<String, dynamic> json) {
//     id = json['id'] ?? '';
//     activeStatusC = json['activeStatusC'] ?? '';
//     iconUrlC = json['iconUrlC'].toString().contains('http')
//         ? json['iconUrlC']
//         : 'https:' + json['iconUrlC'] ?? '';
//     // photoUrl =
//     //     'https://source.unsplash.com/random/200x200?sig=${generateRandomUniqueNumber().toString()}';
//     name = json['name'] ?? '';
//     sortOrderC = json['sortOrderC'] ?? '';
//     counter = json['counter'] ?? '0';
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['activeStatusC'] = this.activeStatusC;
//     data['iconUrlC'] = this.iconUrlC;
//     data['name'] = this.name;
//     data['sortOrderC'] = this.sortOrderC;
//     data['counter'] = this.counter;
//     return data;
//   }
// }
