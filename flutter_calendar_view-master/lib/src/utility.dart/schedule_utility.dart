import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ScheduleUtility {
  static bool getTimeDiffrence(
      {required String startTime, required String endTime}) {
    var startDateTime = DateTime(
        _now.year,
        _now.month,
        _now.day,
        startTime.contains("PM") && int.parse(startTime.split(':')[0]) != 12
            ? int.parse(startTime.split(':')[0]) + 12
            : int.parse(startTime.split(':')[0]),
        int.parse(startTime.split(':')[1].split(' ')[0]));

    var endDateTime = DateTime(
        _now.year,
        _now.month,
        _now.day,
        endTime.contains("PM") && int.parse(endTime.split(':')[0]) != 12
            ? int.parse(endTime.split(':')[0]) + 12
            : int.parse(endTime.split(':')[0]),
        int.parse(endTime.split(':')[1].split(' ')[0]));
    final v = endDateTime.difference(startDateTime).inMinutes;
    return v <= 15;
  }
}

DateTime get _now => DateTime.now();
