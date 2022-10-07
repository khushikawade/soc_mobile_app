// To parse this JSON data, do
//
//     final modelCalender = modelCalenderFromJson(jsonString?);

import 'dart:convert';

import 'package:Soc/src/modules/schedule/modal/blackOutDate_modal.dart';
import 'package:Soc/src/modules/schedule/modal/schedule_modal.dart';

ModelCalender modelCalenderFromJson(String? str) =>
    ModelCalender.fromJson(json.decode(str!));

String? modelCalenderToJson(ModelCalender data) => json.encode(data.toJson());

class ModelCalender {
  ModelCalender({
    this.statusCode,
    this.body,
  });

  int? statusCode;
  Body? body;

  factory ModelCalender.fromJson(Map<String?, dynamic> json) => ModelCalender(
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        body: json["body"] == null ? null : Body.fromJson(json["body"]),
      );

  Map<String?, dynamic> toJson() => {
        "statusCode": statusCode == null ? null : statusCode,
        "body": body == null ? null : body!.toJson(),
      };
}

class Body {
  Body({
    this.schedules,
    this.blackoutDates,
  });

  List<Schedule>? schedules;
  List<BlackoutDate>? blackoutDates;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        schedules: json["schedules"] == null
            ? null
            : List<Schedule>.from(
                json["schedules"].map((x) => Schedule.fromJson(x))),
        blackoutDates: json["blackoutDates"] == null
            ? null
            : List<BlackoutDate>.from(
                json["blackoutDates"].map((x) => BlackoutDate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "schedules": schedules == null
            ? null
            : List<dynamic>.from(schedules!.map((x) => x.toJson())),
        "blackoutDates": blackoutDates == null
            ? null
            : List<dynamic>.from(blackoutDates!.map((x) => x.toJson())),
      };
}
