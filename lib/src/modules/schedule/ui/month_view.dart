import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/modal/user_info.dart';
import 'package:Soc/src/modules/schedule/bloc/calender_bloc.dart';
import 'package:Soc/src/modules/schedule/common_widget/animatedcontainer.dart';
import 'package:Soc/src/modules/schedule/common_widget/common_header.dart';
import 'package:Soc/src/modules/schedule/modal/blackOutDate_modal.dart';
import 'package:Soc/src/modules/schedule/ui/day_view.dart';
import 'package:Soc/src/modules/schedule/ui/schedule_event_builder.dart';

import 'package:Soc/src/modules/schedule/ui/week_view.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:calendar_view/calendar_view.dart';

// import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../modal/event.dart';
import '../modal/schedule_modal.dart';

class MonthViewPage extends StatefulWidget {
  final List<Schedule> schedules;
  final List<BlackoutDate> blackoutDate;
  UserInformation studentProfile;

  bool isContainer1Open;
  MonthViewPage(
      {Key? key,
      required this.isContainer1Open,
      required this.blackoutDate,
      required this.schedules,
      required this.studentProfile})
      : super(key: key);

  @override
  State<MonthViewPage> createState() => _MonthViewPageState();
}

class _MonthViewPageState extends State<MonthViewPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  AppLifecycleState? state;

  bool isAnimationContainerOpen = false;

  DateTime _date = DateTime.now();

  EventController _controller = EventController();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  CalenderBloc _calenderBloc = CalenderBloc();
  @override
  void initState() {
    super.initState();

    _callEventBuilder(_date);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose\
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _calenderBloc.add(CalenderPageEvent(
          studentProfile: widget.studentProfile, pullToRefresh: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<CalenderBloc, CalenderState>(
            bloc: _calenderBloc,
            builder: (BuildContext contxt, CalenderState state) {
              return Column(
                children: [
                  Expanded(
                    child: MonthView(
                        weekDaytileTextstyle:
                            Theme.of(context).textTheme.subtitle1!.copyWith(),
                        startDay: WeekDays.sunday,
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        onPageChange: (date, page) {
                          setState(() {
                            _date = date;
                            _callEventBuilder(date);
                          });
                        },
                        cellAspectRatio: 1 / 4.5,
                        headerBuilder: (date) {
                          return Column(
                            children: [
                              dayTitle(date),
                              AnimatedSize(
                                  vsync: this,
                                  duration: Duration(milliseconds: 250), //750
                                  curve: Curves.fastOutSlowIn,
                                  child: isAnimationContainerOpen
                                      ? commonContainer(context,
                                          blackoutDate: widget.blackoutDate,
                                          schedules: widget.schedules,
                                          index: 3, callback: (e) {
                                          if (e == true) {
                                            setState(() {
                                              isAnimationContainerOpen =
                                                  !isAnimationContainerOpen;
                                            });
                                          }
                                        },
                                          studentProfile: widget.studentProfile)
                                      : Container()
                                  //     : Container(),
                                  )
                            ],
                          );
                        },
                        cellBuilder: (date, event, isToday, isInMonth) {
                          return isInMonth
                              ? FilledCell(
                                  highlightRadius:
                                      Globals.deviceType == "phone" ? 11 : 20,
                                  isInMonth: isInMonth,
                                  highlightedTitleColor:
                                      Theme.of(context).colorScheme.background,
                                  highlightColor: Color(0xff000000) ==
                                          Theme.of(context).backgroundColor
                                      ? AppTheme.kDarkModeIconColor
                                      : AppTheme.kLightModeIconColor,
                                  date: date,
                                  shouldHighlight: isToday,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  onTileTap: (event, date) =>
                                      _navigateToDayView(date: date),
                                  events: event,
                                )
                              : Container();
                        },
                        onCellTap: (evets, date) =>
                            _navigateToDayView(date: date),
                        controller: _controller,
                        pullToRefresh: onPullToRefresh),
                  ),
                ],
              );
            },
            listener: (BuildContext contxt, CalenderState state) {
              if (state is CalenderSuccess) {
                widget.schedules.clear();
                widget.blackoutDate.clear();
                widget.schedules.addAll(state.scheduleObjList);
                widget.blackoutDate.addAll(state.blackoutDateobjList);
                rePrepareAllEvents(
                    date: _date,
                    scheduleDates: widget.schedules,
                    blackoutDates: widget.blackoutDate);
              }
            }));
  }

  Widget dayTitle(DateTime date) {
    return MonthHeader(
      studentProfile: widget.studentProfile,
      backgroundColor: Theme.of(context).colorScheme.background,
      date: date,
      onNextMonth: () {
        setState(() {
          isAnimationContainerOpen = !isAnimationContainerOpen;
        });
      },
    );
  }

  void _callEventBuilder(DateTime date) {
    var containe = _controller.events.where((element) =>
        element.startTime!.month == date.month &&
        element.startTime!.year == date.year);
    if (containe.isEmpty) {
      _controller.addAll(ScheduleEventBuilder.eventPrepration(
          date: date,
          blackoutDateList: widget.blackoutDate,
          scheduleList: widget.schedules));
    } else {
      print('Error while building the events');
    }
    setState(() {});
  }

  Future<void> onPullToRefresh() async {
    _calenderBloc.add(CalenderPageEvent(
        studentProfile: widget.studentProfile, pullToRefresh: true));
    refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 2));
  }

  rePrepareAllEvents(
      {required DateTime date,
      required List<BlackoutDate> blackoutDates,
      required List<Schedule> scheduleDates}) {
    _controller.dispose();
    _controller = EventController();
    _controller.addAll(ScheduleEventBuilder.eventPrepration(
        date: date,
        blackoutDateList: blackoutDates,
        scheduleList: scheduleDates));
    setState(() {});
  }

  void _navigateToDayView({required DateTime date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => DayViewPage(
                date: ValueNotifier(date),
                studentProfile: widget.studentProfile,
                schedulesList: widget.schedules,
                blackoutDateList: widget.blackoutDate,
              )),
    );
  }
}
