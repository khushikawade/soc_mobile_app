import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';

import 'event.dart';

DateTime get _now => DateTime.now();

class EventList {
  static List<CalendarEventData<Event>> events = [
    CalendarEventData(
        date: _now,
        event: Event(title: "Joe's Birthday"),
        title: "P1-Geometery \nRoom202 \nMr.Perez\nUnit Assesment:7/21/22",
        description: "",
        startTime: DateTime(_now.year, _now.month, _now.day, 06, 00),
        endTime: DateTime(_now.year, _now.month, _now.day, 06, 45), // 09, 10
        color: Color.fromARGB(244, 82, 214, 214)),
    CalendarEventData(
        date: _now,
        startTime: DateTime(_now.year, _now.month, _now.day, 09, 15),
        endTime: DateTime(_now.year, _now.month, _now.day, 11, 55),
        event: Event(title: "Wedding anniversary"),
        title: "P2-Computer-Science \nRoom303 \nMr.Johnson",
        description: "",
        color: Color.fromARGB(244, 3, 247, 190)),

    CalendarEventData(
        date: _now,
        event: Event(title: "Joe's Birthday"),
        title: "P3-Civil-litracy \nRoom209 \nMr's.Gofrido",
        description: "",
        startTime: DateTime(_now.year, _now.month, _now.day, 12, 10),
        endTime: DateTime(_now.year, _now.month, _now.day, 15),
        color: Color.fromARGB(244, 214, 118, 0)),

    CalendarEventData(
        date: _now.subtract(Duration(days: 2)),
        startTime: DateTime(
            _now.subtract(Duration(days: 2)).year,
            _now.subtract(Duration(days: 2)).month,
            _now.subtract(Duration(days: 2)).day,
            14),
        endTime: DateTime(
            _now.subtract(Duration(days: 2)).year,
            _now.subtract(Duration(days: 2)).month,
            _now.subtract(Duration(days: 2)).day,
            17),
        event: Event(title: "Team Meeting"),
        title: "P1-Geometery \nRoom202 \nMr.Perez\nUnit Assesment:7/21/22",
        description: "",
        color: Color.fromARGB(244, 76, 20, 229)),
    CalendarEventData(
        date: _now.subtract(Duration(days: 2)),
        startTime: DateTime(_now.year, _now.month, _now.day, 10),
        endTime: DateTime(_now.year, _now.month, _now.day, 13),
        event: Event(title: "Chemistry Viva"),
        title: "P2-Computer-Science \nRoom303 \nMr.Johnson",
        description: "",
        color: Color.fromARGB(244, 255, 0, 195)),
    CalendarEventData(
        date: _now,
        startTime: DateTime(
            _now.add(Duration(days: 1)).year,
            _now.add(Duration(days: 1)).month,
            _now.add(Duration(days: 1)).day,
            18),
        endTime: DateTime(
            _now.add(Duration(days: 1)).year,
            _now.add(Duration(days: 1)).month,
            _now.add(Duration(days: 1)).day,
            21),
        event: Event(title: "Team Meeting"),
        title: "P2-Computer-Science \nRoom303 \nMr.Johnson",
        description: "",
        color: Color.fromARGB(244, 255, 0, 0)),

    //========

    CalendarEventData(
        date: _now.add(Duration(days: 1)),
        startTime: DateTime(
            _now.add(Duration(days: 1)).year,
            _now.add(Duration(days: 1)).month,
            _now.add(Duration(days: 1)).day,
            14),
        endTime: DateTime(
            _now.add(Duration(days: 1)).year,
            _now.add(Duration(days: 1)).month,
            _now.add(Duration(days: 1)).day,
            17),
        event: Event(title: "Team Meeting"),
        title: "P1-Geometery \nRoom202 \nMr.Perez\nUnit Assesment:7/21/22",
        description: "",
        color: Color.fromARGB(244, 3, 252, 144)),
    CalendarEventData(
        date: _now.add(Duration(days: 1)),
        startTime: DateTime(
            _now.add(Duration(days: 1)).year,
            _now.add(Duration(days: 1)).month,
            _now.add(Duration(days: 1)).day,
            18),
        endTime: DateTime(
            _now.add(Duration(days: 1)).year,
            _now.add(Duration(days: 1)).month,
            _now.add(Duration(days: 1)).day,
            21),
        event: Event(title: "Team Meeting"),
        title: "P2-Computer-Science \nRoom303 \nMr.Johnson",
        description: "",
        color: Color.fromARGB(244, 255, 0, 0)),
    CalendarEventData(
        date: _now.add(Duration(days: 1)),
        startTime: DateTime(
            _now.add(Duration(days: 1)).year,
            _now.add(Duration(days: 1)).month,
            _now.add(Duration(days: 1)).day,
            12),
        endTime: DateTime(
            _now.add(Duration(days: 1)).year,
            _now.add(Duration(days: 1)).month,
            _now.add(Duration(days: 1)).day,
            15),
        event: Event(title: "Team Meeting"),
        title: "P2-Computer-Science \nRoom303 \nMr.Johnson",
        description: "",
        color: Color.fromARGB(244, 255, 113, 4)),
    CalendarEventData(
        date: _now.add(Duration(days: 1)),
        startTime: DateTime(
            _now.add(Duration(days: 1)).year,
            _now.add(Duration(days: 1)).month,
            _now.add(Duration(days: 1)).day,
            12),
        endTime: DateTime(
            _now.add(Duration(days: 1)).year,
            _now.add(Duration(days: 1)).month,
            _now.add(Duration(days: 1)).day,
            15),
        event: Event(title: "Team Meeting"),
        title: "P3-Computer-Science \nRoom303 \nMr.Johnson",
        description: "",
        color: Color.fromARGB(244, 255, 113, 4)),
  ];
}
