import 'package:Soc/src/modules/ocr/modal/user_info.dart';
import 'package:Soc/src/modules/schedule/modal/blackOutDate_modal.dart';
import 'package:Soc/src/modules/schedule/modal/schedule_modal.dart';
import 'package:Soc/src/modules/schedule/ui/day_view.dart';
import 'package:Soc/src/modules/schedule/ui/month_view.dart';
import 'package:Soc/src/modules/schedule/ui/week_view.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

Widget commonContainer(BuildContext context,
    {required List<BlackoutDate> blackoutDate,
    required List<Schedule> schedules,
    required int index,
    required callback(bool),
    required UserInformation studentProfile}) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setStatecheck) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              child: Column(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: index == 1
                        ? Color(0xff000000) == Theme.of(context).backgroundColor
                            ? AppTheme.kDarkModeIconColor
                            : AppTheme.kLightModeIconColor
                        : Colors.grey,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Utility.textWidget(
                    text: 'Day',
                    context: context,
                    textTheme: TextStyle(),
                  ),
                ],
              ),
              onTap: () {
                setStatecheck(
                  () {},
                );
                if (index != 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DayViewPage(
                              date: ValueNotifier(DateTime.now()),
                              studentProfile: studentProfile,
                              blackoutDateList: blackoutDate,
                              schedulesList: schedules,
                            )),
                  );
                } else {
                  callback(true);
                }
              },
            ),
            InkWell(
              child: Column(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    color: index == 2
                        ? Color(0xff000000) == Theme.of(context).backgroundColor
                            ? AppTheme.kDarkModeIconColor
                            : AppTheme.kLightModeIconColor
                        : Colors.grey,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Utility.textWidget(
                    text: 'Week',
                    context: context,
                    textTheme: TextStyle(),
                  ),
                ],
              ),
              onTap: () {
                if (index != 2) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WeekViewPage(
                              false,
                              schedules: schedules,
                              blackoutDate: blackoutDate,
                              studentProfile: studentProfile,
                            )),
                  );
                } else {
                  callback(true);
                }
              },
            ),
            InkWell(
              child: Column(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: index == 3
                        ? Color(0xff000000) == Theme.of(context).backgroundColor
                            ? AppTheme.kDarkModeIconColor
                            : AppTheme.kLightModeIconColor
                        : Colors.grey,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Utility.textWidget(
                    text: 'Month',
                    context: context,
                    textTheme: TextStyle(),
                  ),
                ],
              ),
              onTap: () {
                setStatecheck(
                  () {
                    if (index != 3) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MonthViewPage(
                                  schedules: schedules,
                                  blackoutDate: blackoutDate,
                                  isContainer1Open: false,
                                  studentProfile: studentProfile,
                                )),
                      );
                    } else {
                      callback(true);
                    }
                  },
                );
              },
            )
          ],
        ),
      );
    },
  );
}
