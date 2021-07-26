import 'package:flutter/material.dart';

class EventModel {
  const EventModel(
      {required this.date,
      required this.month,
      required this.eventLink,
      required this.headline,
      required this.timestamp});

  final String date;
  final String month;
  final String eventLink;
  final String headline;
  final String timestamp;
}
