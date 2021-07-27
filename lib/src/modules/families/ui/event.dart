import 'package:Soc/src/modules/families/ui/calendar.dart';
import 'package:Soc/src/modules/families/ui/eventdescition.dart';
import 'package:Soc/src/modules/families/ui/test.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/sliderpagewidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'eventmodal.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  static const double _kLabelSpacing = 15.0;

  // final TextStyle headingtextStyle = TextStyle(
  //   height: 1.5,
  //   fontFamily: "Roboto Medium",
  //   fontSize: 16,
  //   color: AppTheme.kFontColor2,
  // );

  // final TextStyle datetextStyle = TextStyle(
  //   height: 1.5,
  //   fontFamily: "Roboto Medium",
  //   fontSize: 22,
  //   fontWeight: FontWeight.w600,
  //   color: AppTheme.kAccentColor,
  // );

  // final TextStyle monthtextStyle = TextStyle(
  //   height: 1.5,
  //   fontFamily: "Roboto Regular",
  //   fontSize: 16,
  //   fontWeight: FontWeight.normal,
  //   color: AppTheme.kAccentColor,
  // );

  // final TextStyle eventtextStyle = TextStyle(
  //   height: 1.5,
  //   fontFamily: "Roboto Bold",
  //   fontWeight: FontWeight.bold,
  //   fontSize: 16,
  //   color: AppTheme.kAccentColor,
  // );

  // final TextStyle timeStamptextStyle = TextStyle(
  //   height: 1.5,
  //   fontFamily: "Roboto Regular",
  //   fontSize: 13,
  //   color: AppTheme.kAccentColor,
  // );

  static const List<EventModel> EventModelList = const <EventModel>[
    const EventModel(
      date: '13',
      month: 'SEP',
      eventLink:
          'https://calendar.google.com/calendar/u/0/r/week/2021/7/15?eid=NmoxMTlhbTRmYzduMzZvbW8ydHNucTQyOGggYXNod2ludGhha3VyNDk4QG0&ctok=YXNod2ludGhha3VyNDk4QGdtYWlsLmNvbQ',
      headline: 'First Day Of School',
      timestamp: '13/09/2021',
    ),
    const EventModel(
      date: '16',
      month: 'SEP',
      eventLink:
          'https://calendar.google.com/calendar/u/0/r/week/2021/7/15?eid=NmoxMTlhbTRmYzduMzZvbW8ydHNucTQyOGggYXNod2ludGhha3VyNDk4QG0&ctok=YXNod2ludGhha3VyNDk4QGdtYWlsLmNvbQ',
      headline: 'Yom kippur:School Closed',
      timestamp: '16/09/2021 20:39',
    ),
    const EventModel(
      date: '11',
      month: 'OCT',
      eventLink:
          'https://calendar.google.com/calendar/u/0/r/week/2021/7/15?eid=NmoxMTlhbTRmYzduMzZvbW8ydHNucTQyOGggYXNod2ludGhha3VyNDk4QG0&ctok=YXNod2ludGhha3VyNDk4QGdtYWlsLmNvbQ',
      headline: 'Indigenous People Day:Schools',
      timestamp: '11/10/2021 1:39',
    ),
    const EventModel(
      date: '02',
      month: 'NOV',
      eventLink:
          'https://calendar.google.com/calendar/u/0/r/week/2021/7/15?eid=NmoxMTlhbTRmYzduMzZvbW8ydHNucTQyOGggYXNod2ludGhha3VyNDk4QG0&ctok=YXNod2ludGhha3VyNDk4QGdtYWlsLmNvbQ',
      headline: 'Election Day:Fully Remote Asy..',
      timestamp: '02/11/2021 20:39',
    ),
    const EventModel(
      date: '18',
      month: 'NOV',
      eventLink:
          'https://calendar.google.com/calendar/u/0/r/week/2021/7/15?eid=NmoxMTlhbTRmYzduMzZvbW8ydHNucTQyOGggYXNod2ludGhha3VyNDk4QG0&ctok=YXNod2ludGhha3VyNDk4QGdtYWlsLmNvbQ',
      headline: 'Conference: Half Day for Students',
      timestamp: '18/11/2021 1:39',
    ),
    const EventModel(
      date: '25',
      month: 'NOV',
      eventLink:
          'https://calendar.google.com/calendar/u/0/r/week/2021/7/15?eid=NmoxMTlhbTRmYzduMzZvbW8ydHNucTQyOGggYXNod2ludGhha3VyNDk4QG0&ctok=YXNod2ludGhha3VyNDk4QGdtYWlsLmNvbQ',
      headline: 'Election Day: Fully Remote, Asy…',
      timestamp: '25/11/2021 - 26/11/2021',
    ),
    const EventModel(
      date: '24',
      month: 'DEC',
      eventLink:
          'https://calendar.google.com/calendar/u/0/r/week/2021/7/15?eid=NmoxMTlhbTRmYzduMzZvbW8ydHNucTQyOGggYXNod2ludGhha3VyNDk4QG0&ctok=YXNod2ludGhha3VyNDk4QGdtYWlsLmNvbQ',
      headline: 'Thanks giving Recess:School',
      timestamp: '25/11/2021 - 26/11/2021',
    ),
    const EventModel(
      date: '17',
      month: 'JAN',
      eventLink:
          'https://calendar.google.com/calendar/u/0/r/week/2021/7/15?eid=NmoxMTlhbTRmYzduMzZvbW8ydHNucTQyOGggYXNod2ludGhha3VyNDk4QG0&ctok=YXNod2ludGhha3VyNDk4QGdtYWlsLmNvbQ',
      headline: 'Rev. Dr. Martin Luther king Jr… ',
      timestamp: '17/01/2022',
    ),
  ];

  _launchURL(obj) async {
    if (await canLaunch(obj)) {
      await launch(obj);
    } else {
      throw 'Could not launch ${obj}';
    }
  }

  Widget _buildList(int index) {
    return InkWell(
      onTap: () {
        // _launchURL('');
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => SliderWidget(
        //               obj: EventModelList,
        //               issocialpage: false,
        //               iseventpage: true,
        //               currentIndex: index,
        //               date: '',
        //             )));

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => IntentTest()));
      },
      child: Container(
          decoration: BoxDecoration(
            border: (index % 2 == 0)
                ? Border.all(color: AppTheme.kListBackgroundColor2)
                : Border.all(color: Theme.of(context).backgroundColor),
            borderRadius: BorderRadius.circular(0.0),
            color: (index % 2 == 0)
                ? AppTheme.kListBackgroundColor2
                : Theme.of(context).backgroundColor,
          ),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: _kLabelSpacing * 2, vertical: _kLabelSpacing / 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildDate(index),
                  HorzitalSpacerWidget(_kLabelSpacing),
                  _builEvent(index),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildHeading(String tittle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(
              top: _kLabelSpacing / 1.5, bottom: _kLabelSpacing / 1.5),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(
              width: 0,
            ),
            color: AppTheme.kOnPrimaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: _kLabelSpacing),
            child: Text(tittle, style: Theme.of(context).textTheme.headline3),
          ),
        ),
      ],
    );
  }

  Widget _buildDate(int index) {
    return Column(
      children: [
        Text(
          EventModelList[index].date,
          style: Theme.of(context).textTheme.headline5,
        ),
        Text(
          EventModelList[index].month,
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(fontWeight: FontWeight.normal, height: 1.5),
        )
      ],
    );
  }

  Widget _builEvent(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          EventModelList[index].headline,
          style: Theme.of(context).textTheme.headline2!.copyWith(height: 1.5),
        ),
        SpacerWidget(_kLabelSpacing / 2),
        _builTimeStamp(index),
      ],
    );
  }

  Widget _builTimeStamp(int index) {
    return Row(
      children: [
        Text(
          EventModelList[index].timestamp,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeading("Upcoming"),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return _buildList(index);
                },
              ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
