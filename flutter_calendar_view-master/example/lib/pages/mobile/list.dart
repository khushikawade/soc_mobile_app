import 'package:calendar_view/calendar_view.dart';

import 'package:flutter/cupertino.dart';

import '../../model/event.dart';

DateTime get _now => DateTime.now();

class EventList {
  static List<CalendarEventData<Event>> events = [
    CalendarEventData(
        date: _now,
        event: Event(title: "Joe's Birthday"),
        title: "Project meeting",
        description: "Today is project meeting.",
        startTime: DateTime(_now.year, _now.month, _now.day, 18, 30),
        endTime: DateTime(_now.year, _now.month, _now.day, 22),
        color: Color.fromARGB(244, 214, 82, 159)),
    CalendarEventData(
        date: _now,
        event: Event(title: "Joe's Birthday"),
        title: "Important meeting",
        description: "Important meeting.",
        startTime: DateTime(_now.year, _now.month, _now.day, 22, 30),
        endTime: DateTime(_now.year, _now.month, _now.day, 23),
        color: Color.fromARGB(244, 82, 214, 170)),
    CalendarEventData(
        date: _now,
        event: Event(title: "Joe's Birthday"),
        title: "Test",
        description: "Today is a physics test.",
        startTime: DateTime(_now.year, _now.month, _now.day, 01, 30),
        endTime: DateTime(_now.year, _now.month, _now.day, 04),
        color: Color.fromARGB(244, 106, 82, 214)),
    CalendarEventData(
        date: _now.add(Duration(days: 1)),
        startTime: DateTime(_now.year, _now.month, _now.day, 18),
        endTime: DateTime(_now.year, _now.month, _now.day, 19),
        event: Event(title: "Wedding anniversary"),
        title: "Wedding anniversary",
        description: "Attend uncle's wedding anniversary.",
        color: Color.fromARGB(244, 162, 230, 116)),
    CalendarEventData(
        date: _now,
        startTime: DateTime(_now.year, _now.month, _now.day, 14),
        endTime: DateTime(_now.year, _now.month, _now.day, 17),
        event: Event(title: "Football Tournament"), //Football Tournament
        title: "Football Tournament",
        description: "Go to football tournament.",
        color: Color.fromARGB(244, 227, 20, 141)),
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
            16),
        event: Event(title: "Team Meeting"),
        title: "Team Meeting",
        description: "Team Meeting",
        color: Color.fromARGB(244, 76, 20, 229)),
    CalendarEventData(
        date: _now.subtract(Duration(days: 2)),
        startTime: DateTime(
            _now.subtract(Duration(days: 2)).year,
            _now.subtract(Duration(days: 2)).month,
            _now.subtract(Duration(days: 2)).day,
            10),
        endTime: DateTime(
            _now.subtract(Duration(days: 2)).year,
            _now.subtract(Duration(days: 2)).month,
            _now.subtract(Duration(days: 2)).day,
            12),
        event: Event(title: "Chemistry Viva"),
        title: "Chemistry Viva",
        description: "Today is Joe's birthday.",
        color: Color.fromARGB(244, 241, 0, 48)),
  ];
}
