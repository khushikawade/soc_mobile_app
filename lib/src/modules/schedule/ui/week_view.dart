import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/schedule/bloc/calender_bloc.dart';
import 'package:Soc/src/modules/schedule/common_widget/animatedcontainer.dart';
import 'package:Soc/src/modules/schedule/common_widget/common_header.dart';
import 'package:Soc/src/modules/schedule/modal/blackOutDate_modal.dart';
import 'package:Soc/src/modules/schedule/modal/contweek.dart';
import 'package:Soc/src/modules/schedule/ui/day_view.dart';
import 'package:Soc/src/modules/schedule/ui/schedule_event_builder.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../modal/event.dart';
import '../modal/schedule_modal.dart';

class WeekViewPage extends StatefulWidget {
  bool? value;
  final List<Schedule> schedules;
  UserInformation studentProfile;

  final List<BlackoutDate> blackoutDate;
  WeekViewPage(
    bool bool, {
    Key? key,
    required this.blackoutDate,
    required this.schedules,
    required this.studentProfile,
  }) : super(key: key);

  @override
  State<WeekViewPage> createState() => _WeekViewPageState();
}

class _WeekViewPageState extends State<WeekViewPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  AppLifecycleState? state;
  List<CalendarEventData<Event>> staticEventList = [];
  bool showViewChangeArea = false;
  bool showicon = false;
  bool isContainer1Open = false;
  List<String> blocdate = [];
  List<int> blocmonth = [];
  List<String> blackoutWeekDay = [];
  bool isAnimationContainerOpen = false;
  DateTime _date = DateTime.now();

  EventController _controller = EventController();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  CalenderBloc _calenderBloc = CalenderBloc();
  @override
  void initState() {
    super.initState();
    //  addEvent(_date);
    _callEventBuilder(_date);
    AppConstants.height = isContainer1Open ? 0 : 0;
    WidgetsBinding.instance.addObserver(this);

    FirebaseAnalyticsService.addCustomAnalyticsEvent("Week_view_calendar");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'Week_view_calendar', screenClass: 'WeekViewPage');
  }

  @override
  void dispose() {
    // TODO: implement dispose\
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
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
              return WeekView(
                  scrollOffset: 1650.0,
                  onEventTap: (list, date) => _navigateToDayView(date: date),
                  startDay: WeekDays.sunday,
                  showWeekends: true,
                  heightPerMinute: 3.5,
                  liveTimeIndicatorSettings: HourIndicatorSettings(
                      color: Theme.of(context).colorScheme.primaryVariant),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  onPageChange: (date, page) {
                    if (_date.month == date.month) return;
                    _date = date;
                    _callEventBuilder(date);
                    setState(() {});
                  },
                  weekDayBuilder: (date) {
                    bool isToday = date.compareWithoutTime(DateTime.now());
                    return GestureDetector(
                      onTap: () => _navigateToDayView(date: date),
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: isToday
                              ? Color(0xff000000) ==
                                      Theme.of(context).backgroundColor
                                  ? AppTheme.kDarkModeIconColor
                                  : AppTheme.kLightModeIconColor
                              : Colors.transparent,
                          child: Text(
                            "${Constants.weekTitles[date.weekday - 1]}\n${date.day.toString()}",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(color: isToday ? Colors.white : null),
                          ),
                        ),
                      ),
                    );
                  },
                  weekPageHeaderBuilder: (startDate, endDate) {
                    return Column(
                      children: [
                        dayTitle(startDate, endDate),
                        AnimatedSize(
                            vsync: this,
                            duration: Duration(milliseconds: 250),
                            curve: Curves.fastOutSlowIn,
                            child: isAnimationContainerOpen
                                ? commonContainer(
                                    context,
                                    blackoutDate: widget.blackoutDate,
                                    schedules: widget.schedules,
                                    index: 2,
                                    callback: (e) {
                                      if (e == true) {
                                        setState(() {
                                          isAnimationContainerOpen =
                                              !isAnimationContainerOpen;

                                          // 25;
                                        });
                                      }
                                    },
                                    studentProfile: widget.studentProfile,
                                  )
                                : Container()
                            //     : Container(),
                            )
                      ],
                    );
                  },
                  controller: _controller,
                  pullToRefresh: onPullToRefresh);
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

  Widget dayTitle(DateTime startDate, DateTime endDate) {
    return WeekHeader(
      studentProfile: widget.studentProfile,
      backgroundColor: Theme.of(context).colorScheme.background,
      startDate: startDate,
      endDate: endDate,
      onNextDay: () {
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
      setState(() {});
    }
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

class AppConstants {
  static BorderRadius borderRadius = BorderRadius.circular(0);
  static double height = 0;
  static double fontsize = 0;
  static double size = 0;
}
