import 'dart:convert';

PbisPlusBehaviourModal pbisPlusBehaviourModalFromJson(String str) =>
    PbisPlusBehaviourModal.fromJson(json.decode(str));

String pbisPlusBehaviourModalToJson(PbisPlusBehaviourModal data) =>
    json.encode(data.toJson());

class PbisPlusBehaviourModal {
  int? statusCode;
  List<PbisPlusBehaviourList>? body;

  PbisPlusBehaviourModal({
    this.statusCode,
    this.body,
  });

  factory PbisPlusBehaviourModal.fromJson(Map<String, dynamic> json) =>
      PbisPlusBehaviourModal(
        statusCode: json["statusCode"],
        body: json["body"] == null
            ? []
            : List<PbisPlusBehaviourList>.from(
                json["body"]!.map((x) => PbisPlusBehaviourList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "body": body == null
            ? []
            : List<dynamic>.from(body!.map((x) => x.toJson())),
      };
}

class PbisPlusBehaviourList {
  String? id;
  String? activeStatusC;
  String? iconUrlC;
  String? name;
  String? sortOrderC;
  String? createdById;
  String? lastModifiedById;

  PbisPlusBehaviourList({
    this.id,
    this.activeStatusC,
    this.iconUrlC,
    this.name,
    this.sortOrderC,
    this.createdById,
    this.lastModifiedById,
  });

  factory PbisPlusBehaviourList.fromJson(Map<String, dynamic> json) =>
      PbisPlusBehaviourList(
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
