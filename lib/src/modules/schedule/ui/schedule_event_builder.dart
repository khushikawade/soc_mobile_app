import 'package:Soc/src/modules/schedule/bloc/calender_bloc.dart';
import 'package:Soc/src/modules/schedule/modal/blackOutDate_modal.dart';
import 'package:Soc/src/modules/schedule/modal/schedule_modal.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleEventBuilder {
  static List<CalendarEventData<Event>> eventPrepration(
      {required DateTime date,
      required List<BlackoutDate> blackoutDateList,
      required List<Schedule> scheduleList}) {
    final CalenderBloc _calenderBloc = CalenderBloc();
    List<CalendarEventData<Event>> staticEventList = [];
    if (scheduleList.isEmpty) {
      return [];
    }
    DateTime scheduleStartDate = scheduleList[0].scheduleStartDatec != null
        ? DateTime.parse(scheduleList[0].scheduleStartDatec!)
        : DateTime(2000, 1, 1);

    DateTime scheduleEndDate = scheduleList[0].scheduleEndDatec != null
        ? DateTime.parse(scheduleList[0].scheduleEndDatec!)
        : DateTime(2040, 1, 1);

    int days = DateTime(date.year, date.month + 1, 0).day;

    // print(days);
    // var contain = blackoutDateList
    //     .where((element) => element.startDateC!.month == date.month);
    blackoutDateList.sort((a, b) => a.startDateC!.compareTo(b.startDateC!));
    for (int dateIndex = 1; dateIndex <= days; dateIndex++) {
      if (DateTime(date.year, date.month, dateIndex + 1)
              .isAfter(scheduleStartDate) &&
          DateTime(date.year, date.month, dateIndex - 1)
              .isBefore(scheduleEndDate)) {
        for (int i = 0; i < scheduleList.length; i++) {
          String _currentDay = DateFormat('EEEE').format(DateTime(
            date.year,
            date.month,
            dateIndex,
          ));
          var startDate;
          var endDate;
          var inputFormat = DateFormat('HH:mm:ss');
          // var number = scheduleList[i].monPeriodC;
          var number =
              _calenderBloc.getDaysPeriodsNumber(scheduleList[i], _currentDay);
          // print(number);
          if (number == "0" &&
              scheduleList[i].period0StartTimeC != null &&
              scheduleList[i].period0EndTimeC != null) {
            startDate = inputFormat.parse(scheduleList[i].period0StartTimeC!);
            endDate = inputFormat.parse(scheduleList[i].period0EndTimeC!);
          }
          if (number == "1" &&
              scheduleList[i].period1StartTimeC != null &&
              scheduleList[i].period1EndTimeC != null) {
            startDate = inputFormat.parse(scheduleList[i].period1StartTimeC!);
            endDate = inputFormat.parse(scheduleList[i].period1EndTimeC!);
          } else if (number == "2" &&
              scheduleList[i].period2StartTimeC != null &&
              scheduleList[i].period2EndTimeC != null) {
            startDate = inputFormat.parse(scheduleList[i].period2StartTimeC!);
            endDate = inputFormat.parse(scheduleList[i].period2EndTimeC!);
          } else if (number == "3" &&
              scheduleList[i].period3StartTimeC != null &&
              scheduleList[i].period3EndTimeC != null) {
            startDate = inputFormat.parse(scheduleList[i].period3StartTimeC!);
            endDate = inputFormat.parse(scheduleList[i].period3EndTimeC!);
          } else if (number == "4" &&
              scheduleList[i].period4StartTimeC != null &&
              scheduleList[i].period4EndTimeC != null) {
            startDate = inputFormat.parse(scheduleList[i].period4StartTimeC!);
            endDate = inputFormat.parse(scheduleList[i].period4EndTimeC!);
          } else if (number == "5" &&
              scheduleList[i].period5StartTimeC != null &&
              scheduleList[i].period5EndTimeC != null) {
            startDate = inputFormat.parse(scheduleList[i].period5StartTimeC!);
            endDate = inputFormat.parse(scheduleList[i].period5EndTimeC!);
          } else if (number == "6" &&
              scheduleList[i].period6StartTimeC != null &&
              scheduleList[i].period6EndTimeC != null) {
            startDate = inputFormat.parse(scheduleList[i].period6StartTimeC!);
            endDate = inputFormat.parse(scheduleList[i].period6EndTimeC!);
          } else if (number == "7" &&
              scheduleList[i].period7StartTimeC != null &&
              scheduleList[i].period7EndTimeC != null) {
            startDate = inputFormat.parse(scheduleList[i].period7StartTimeC!);
            endDate = inputFormat.parse(scheduleList[i].period7EndTimeC!);
          } else if (number == "8" &&
              scheduleList[i].period8StartTimeC != null &&
              scheduleList[i].period8EndTimeC != null) {
            startDate = inputFormat.parse(scheduleList[i].period8StartTimeC!);
            endDate = inputFormat.parse(scheduleList[i].period8EndTimeC!);
          } else if (number == "9" &&
              scheduleList[i].period9StartTimeC != null &&
              scheduleList[i].period9EndTimeC != null) {
            startDate = inputFormat.parse(scheduleList[i].period9StartTimeC!);
            endDate = inputFormat.parse(scheduleList[i].period9EndTimeC!);
          } else if (number == "10" &&
              scheduleList[i].period10StartTimeC != null &&
              scheduleList[i].period10EndTimeC != null) {
            startDate = inputFormat.parse(scheduleList[i].period10StartTimeC!);
            endDate = inputFormat.parse(scheduleList[i].period10EndTimeC!);
          }

          List<BlackoutDate> blackoutDateListNew = [];
          for (int index = 0; index < blackoutDateList.length; index++) {
            if (blackoutDateList[index].startDateC! ==
                    blackoutDateList[index].endDateC &&
                blackoutDateList[index].startDateC!.month == date.month &&
                blackoutDateList[index].startDateC!.year == date.year) {
              blackoutDateListNew.add(blackoutDateList[index]);
            } else if (blackoutDateList[index].startDateC!.month ==
                    date.month &&
                blackoutDateList[index].startDateC!.year == date.year) {
              List<DateTime> _list = Utility.getDaysInBetween(
                  blackoutDateList[index].startDateC!,
                  blackoutDateList[index].endDateC!);
              for (int j = 0; j < _list.length; j++) {
                if (_list[j].year == date.year) {
                  BlackoutDate blackoutDate = BlackoutDate();
                  blackoutDate.startDateC = _list[j];
                  blackoutDate.endDateC = _list[j];
                  blackoutDate.titleC = blackoutDateList[index].titleC;
                  blackoutDateListNew.add(blackoutDate);
                }
              }
            }
            if (blackoutDateList[index].endDateC!.month == 1 &&
                blackoutDateList[index].startDateC!.month == 12 &&
                blackoutDateList[index].endDateC!.year == date.year &&
                blackoutDateList[index].endDateC!.month == date.month) {
              List<DateTime> _list = Utility.getDaysInBetween(
                  blackoutDateList[index].startDateC!,
                  blackoutDateList[index].endDateC!);
              for (int j = 0; j < _list.length; j++) {
                if (_list[j].year == date.year) {
                  BlackoutDate blackoutDate = BlackoutDate();
                  blackoutDate.startDateC = _list[j];
                  blackoutDate.endDateC = _list[j];
                  blackoutDate.titleC = blackoutDateList[index].titleC;
                  blackoutDateListNew.add(blackoutDate);
                }
              }
            }
          }

          if (blackoutDateListNew.isNotEmpty) {
            for (int blackOutIndex = 0;
                blackOutIndex < blackoutDateListNew.length;
                blackOutIndex++) {
              if ((_currentDay.contains('Sunday') &&
                  _currentDay.contains('Saturday'))) {
              } else if (blackoutDateListNew[blackOutIndex].startDateC!.day ==
                      dateIndex &&
                  (!_currentDay.contains('Sunday') &&
                      !_currentDay.contains('Saturday'))) {
                if (i == 0) {
                  if (blackoutDateListNew[blackOutIndex].endDateC != null &&
                      blackoutDateListNew[blackOutIndex].startDateC != null) {
                    staticEventList.add(
                      CalendarEventData(
                          date: DateTime(
                              date.year, date.month, dateIndex, 00, 00),
                          startTime: DateTime(
                              blackoutDateListNew[blackOutIndex]
                                  .startDateC!
                                  .year,
                              blackoutDateListNew[blackOutIndex]
                                  .startDateC!
                                  .month,
                              blackoutDateListNew[blackOutIndex]
                                  .startDateC!
                                  .day,
                              0,
                              05),
                          endTime: DateTime(
                              blackoutDateListNew[blackOutIndex].endDateC!.year,
                              blackoutDateListNew[blackOutIndex]
                                  .endDateC!
                                  .month,
                              blackoutDateListNew[blackOutIndex].endDateC!.day,
                              23,
                              50),
                          endDate: DateTime(
                              blackoutDateListNew[blackOutIndex].endDateC!.year,
                              blackoutDateListNew[blackOutIndex]
                                  .endDateC!
                                  .month,
                              blackoutDateListNew[blackOutIndex].endDateC!.day,
                              23,
                              50),
                          fontsize: 13,
                          description:
                              "${blackoutDateListNew[blackOutIndex].titleC!}holiday",
                          title:
                              "${blackoutDateListNew[blackOutIndex].titleC!}holiday",
                          color: Colors.grey.withOpacity(0.8)),
                    );
                  }
                }
                //break;
              } else {
                List<int> dayList = [];
                for (int x = 0; x < blackoutDateListNew.length; x++) {
                  dayList.add(blackoutDateListNew[x].startDateC!.day);
                }
                if (!dayList.contains(dateIndex) &&
                    blackOutIndex == 0 &&
                    (!_currentDay.contains('Sunday') &&
                        !_currentDay.contains('Saturday'))) {
                  // print(number);
                  // print(startDate);
                  // print(endDate);
                  if (startDate != null && endDate != null) {
                    staticEventList.add(
                      CalendarEventData(
                          date: DateTime(date.year, date.month, dateIndex,
                              startDate.hour, startDate.minute),
                          startTime: DateTime(date.year, date.month, dateIndex,
                              startDate.hour, startDate.minute),
                          endTime: DateTime(date.year, date.month, dateIndex,
                              endDate.hour, endDate.minute),
                          description:
                              '${_calenderBloc.getPeriod(scheduleList[i], _currentDay)}${_calenderBloc.getabrasion(scheduleList[i], _currentDay)}\n${_calenderBloc.getRoom(scheduleList[i], DateTime(date.year, date.month, dateIndex))}\n${_calenderBloc.getTeacher(scheduleList[i], _currentDay)}',
                          title:
                              '${_calenderBloc.getPeriod(scheduleList[i], _currentDay)}${_calenderBloc.getSubject(scheduleList[i], _currentDay)}\n${_calenderBloc.getRoom(scheduleList[i], date)}\n${_calenderBloc.getTeacher(scheduleList[i], _currentDay)}',
                          color: _calenderBloc.getDayColor(
                              scheduleList[i], _currentDay)),
                    );
                  } else {
                    // print(number);
                    // print(i);
                  }
                }
                // dateIndex++;
              }
            }
          } else if ((!_currentDay.contains('Sunday') &&
              !_currentDay.contains('Saturday'))) {
            staticEventList.add(
              CalendarEventData(
                  date: DateTime(date.year, date.month, dateIndex,
                      startDate.hour, startDate.minute),
                  startTime: DateTime(date.year, date.month, dateIndex,
                      startDate.hour, startDate.minute),
                  endTime: DateTime(date.year, date.month, dateIndex,
                      endDate.hour, endDate.minute),
                  description:
                      '${_calenderBloc.getPeriod(scheduleList[i], _currentDay)}${_calenderBloc.getabrasion(scheduleList[i], _currentDay)}\n${_calenderBloc.getRoom(scheduleList[i], DateTime(date.year, date.month, dateIndex))}\n${_calenderBloc.getTeacher(scheduleList[i], _currentDay)}',
                  title:
                      '${_calenderBloc.getPeriod(scheduleList[i], _currentDay)}${_calenderBloc.getSubject(scheduleList[i], _currentDay)}\n${_calenderBloc.getRoom(scheduleList[i], DateTime(date.year, date.month, dateIndex))}\n${_calenderBloc.getTeacher(scheduleList[i], _currentDay)}',
                  color:
                      _calenderBloc.getDayColor(scheduleList[i], _currentDay)),
            );
            // break;
          }
        }
      }

      //   }
    }

    staticEventList.forEach((element) {
      if (element.title != null) {
        staticEventList.sort((a, b) => a.title.compareTo(b.title));
      }
    });
    // print(staticEventList.length);
    return staticEventList;
  }
}
