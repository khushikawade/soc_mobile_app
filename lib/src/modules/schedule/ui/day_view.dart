import 'package:Soc/src/modules/ocr/modal/user_info.dart';
import 'package:Soc/src/modules/schedule/bloc/calender_bloc.dart';
import 'package:Soc/src/modules/schedule/common_widget/animatedcontainer.dart';
import 'package:Soc/src/modules/schedule/common_widget/common_header.dart';
import 'package:Soc/src/modules/schedule/modal/blackOutDate_modal.dart';
import 'package:Soc/src/modules/schedule/modal/schedule_modal.dart';
import 'package:Soc/src/modules/schedule/ui/schedule_event_builder.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DayViewPage extends StatefulWidget {
  List<Schedule> schedulesList;
  List<BlackoutDate> blackoutDateList;
  UserInformation studentProfile;
  ValueNotifier<DateTime>? date;
  DayViewPage(
      {Key? key,
      required this.schedulesList,
      required this.blackoutDateList,
      required this.studentProfile,
      required this.date})
      : super(key: key);

  @override
  State<DayViewPage> createState() => _DayViewPageState();
}

class _DayViewPageState extends State<DayViewPage>
    with SingleTickerProviderStateMixin {
  bool showViewChangeArea = false;
  bool isAnimationContainerOpen = false;
  EventController _controller = EventController();
  CalenderBloc _calenderBloc = CalenderBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    if (widget.schedulesList.length == 0) {
      _calenderBloc.add(CalenderPageEvent(
          studentProfile: widget.studentProfile, pullToRefresh: false));
    } else {
      _callEventBuilder(
          date: widget.date!.value,
          scheduleDates: widget.schedulesList,
          blackoutDates: widget.blackoutDateList);
    }
  }

  _callEventBuilder(
      {required DateTime date,
      required List<BlackoutDate> blackoutDates,
      required List<Schedule> scheduleDates}) {
    var containe = _controller.events
        .where((element) => element.startTime!.month == date.month);
    if (containe.isEmpty) {
      _controller.addAll(ScheduleEventBuilder.eventPrepration(
          date: date,
          blackoutDateList: blackoutDates,
          scheduleList: scheduleDates));
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<CalenderBloc, CalenderState>(
      bloc: _calenderBloc,
      builder: (BuildContext contxt, CalenderState state) {
        return DayView(
            scrollOffset: 1400.0,
            initialDay: widget.date!.value,
            minuteSlotSize: MinuteSlotSize.minutes60,
            showVerticalLine: true,
            verticalLineOffset: 8,
            showLiveTimeLineInAllDays: false,
            heightPerMinute: 3,
            eventArranger: SideEventArranger(),
            liveTimeIndicatorSettings: HourIndicatorSettings(
              color: Theme.of(context).colorScheme.primaryVariant,
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            onPageChange: (date, page) {
              if (widget.date!.value.month == date.month) return;
              widget.date!.value = date;
              _callEventBuilder(
                  date: date,
                  blackoutDates: widget.blackoutDateList,
                  scheduleDates: widget.schedulesList);
              setState(() {});
            },
            dayTitleBuilder: (date) {
              return Column(
                children: [
                  dayTitle(date),
                  AnimatedSize(
                      vsync: this,
                      duration: Duration(milliseconds: 250),
                      curve: Curves.fastOutSlowIn,
                      child: isAnimationContainerOpen
                          ? commonContainer(
                              context,
                              blackoutDate: widget.blackoutDateList,
                              schedules: widget.schedulesList,
                              index: 1,
                              callback: (e) {
                                if (e == true) {
                                  setState(() {
                                    isAnimationContainerOpen =
                                        !isAnimationContainerOpen;
                                  });
                                }
                              },
                              studentProfile: widget.studentProfile,
                            )
                          : Container())
                ],
              );
            },
            controller: _controller,
            pullToRefresh: onPullToRefresh);
      },
      listener: (BuildContext contxt, CalenderState state) {
        if (state is CalenderSuccess) {
          widget.schedulesList.clear();
          widget.blackoutDateList.clear();
          widget.schedulesList.addAll(state.scheduleObjList);
          widget.blackoutDateList.addAll(state.blackoutDateobjList);
          if (state.pullToRefresh) {
            rePrepareAllEvents(
                date: widget.date!.value,
                scheduleDates: widget.schedulesList,
                blackoutDates: widget.blackoutDateList);
          } else {
            _callEventBuilder(
                date: widget.date!.value,
                scheduleDates: widget.schedulesList,
                blackoutDates: widget.blackoutDateList);
          }
        }
      },
    ));
  }

  Widget dayTitle(DateTime date) {
    return DayHeader(
      backgroundColor: Theme.of(context).colorScheme.background,
      date: date,
      studentProfile: widget.studentProfile,
      onNextDay: () {
        setState(() {
          isAnimationContainerOpen = !isAnimationContainerOpen;
        });
      },
    );
  }

  Future onPullToRefresh() async {
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
}
