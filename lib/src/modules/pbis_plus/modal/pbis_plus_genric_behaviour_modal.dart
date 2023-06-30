import 'package:hive/hive.dart';
part 'pbis_plus_genric_behaviour_modal.g.dart';

@HiveType(typeId: 44)
class PBISPlusGenericBehaviourModal extends HiveObject {
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
  int? counter;
  @HiveField(6)
  String? behaviourId;

  PBISPlusGenericBehaviourModal({
    required this.id,
    required this.activeStatusC,
    required this.iconUrlC,
    required this.name,
    required this.sortOrderC,
    required this.counter,
    required this.behaviourId,
  });

  PBISPlusGenericBehaviourModal.fromJson(Map<String, dynamic> json) {
    id = json['Id'].toString() ?? '';
    // activeStatusC = json['activeStatusC'] ?? '';
    iconUrlC = json['Icon_URL'].toString().contains('http')
        ? json['Icon_URL']
        : 'https:' + json['Icon_URL'] ?? '';
    // photoUrl =
    //     'https://source.unsplash.com/random/200x200?sig=${generateRandomUniqueNumber().toString()}';
    name = json['Name'] ?? '';
    sortOrderC = json['Sorting_Order'] ?? '';
    counter = json['counter'] ?? 0;
    behaviourId = json['behaviourId'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['activeStatusC'] = this.activeStatusC;
    data['iconUrlC'] = this.iconUrlC;
    data['name'] = this.name;
    data['sortOrderC'] = this.sortOrderC;
    data['counter'] = this.counter;
    data['behaviourId'] = this.behaviourId;
    return data;
  }
}
