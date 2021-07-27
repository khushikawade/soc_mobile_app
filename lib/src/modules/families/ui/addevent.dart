import 'package:flutter/material.dart';

import 'package:add_2_calendar/add_2_calendar.dart';

class AddeventToCalendarWidget extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  var start = DateTime.utc(2021, 08, 30, 9, 30, 0, 0, 0);

  Event buildEvent({Recurrence? recurrence}) {
    return Event(
      title: 'Janam -ashatami',
      description: 'Celebration',
      location: 'Indore',
      startDate: start,
      endDate: start.add(Duration(minutes: 40)),
      allDay: false,
      iosParams: IOSParams(
        reminder: Duration(minutes: 40),
      ),
      androidParams: AndroidParams(
        emailInvites: ["test@example.com"],
      ),
      recurrence: recurrence,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Add event to calendar example'),
        ),
        body: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: Text('Add normal event'),
              trailing: Icon(Icons.calendar_today),
              onTap: () {
                Add2Calendar.addEvent2Cal(
                  buildEvent(),
                );
              },
            ),
            Divider(),
            ListTile(
              title: const Text('Add event with recurrence 1'),
              subtitle: const Text("weekly for 3 months"),
              trailing: Icon(Icons.calendar_today),
              onTap: () {
                Add2Calendar.addEvent2Cal(buildEvent(
                  recurrence: Recurrence(
                    frequency: Frequency.weekly,
                    endDate: DateTime.now().add(Duration(days: 60)),
                  ),
                ));
              },
            ),
            Divider(),
            ListTile(
              title: const Text('Add event with recurrence 2'),
              subtitle: const Text("every 2 months for 6 times (1 year)"),
              trailing: Icon(Icons.calendar_today),
              onTap: () {
                Add2Calendar.addEvent2Cal(buildEvent(
                  recurrence: Recurrence(
                    frequency: Frequency.monthly,
                    interval: 2,
                    ocurrences: 6,
                  ),
                ));
              },
            ),
            Divider(),
            ListTile(
              title: const Text('Add event with recurrence 3'),
              subtitle:
                  const Text("RRULE (android only) every year for 10 years"),
              trailing: Icon(Icons.calendar_today),
              onTap: () {
                Add2Calendar.addEvent2Cal(buildEvent(
                  recurrence: Recurrence(
                    frequency: Frequency.yearly,
                    rRule: 'FREQ=YEARLY;COUNT=10;WKST=SU',
                  ),
                ));
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
