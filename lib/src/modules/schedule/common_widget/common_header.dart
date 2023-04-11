import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/graded_plus/widgets/user_profile.dart';
import 'package:Soc/src/modules/schedule/modal/blackOutDate_modal.dart';
import 'package:Soc/src/modules/schedule/modal/contweek.dart';
import 'package:Soc/src/modules/schedule/modal/schedule_modal.dart';
import 'package:Soc/src/modules/students/ui/student.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:bubble_showcase/bubble_showcase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CalendarHeader extends StatefulWidget implements PreferredSizeWidget {
  /// When user taps on right arrow.
  final VoidCallback? onNextDay;

  /// When user taps on left arrow.
  final VoidCallback? onPreviousDay;
  final VoidCallback? titleGet;

  /// When user taps on title.
  final AsyncCallback? onTitleTapped;

  final Future<String> Function()? CallbackAction;

  /// Date of month/day.
  final DateTime date;

  /// Secondary date. This date will be used when we need to define a
  /// range of dates.
  /// [date] can be starting date and [secondaryDate] can be end date.
  final DateTime? secondaryDate;

  /// Provides string to display as title.
  final StringProvider dateStringBuilder;

  /// backgeound color of header.
  final Color backgroundColor;

  /// Color of icons at both sides of header.
  final Color iconColor;
  final IconData? icon;
  UserInformation? studentProfile;

  /// Common header for month and day view In this header user can define format
  /// in which date will be displayed by providing [dateStringBuilder] function.
  CalendarHeader(
      {Key? key,
      required this.date,
      required this.dateStringBuilder,
      this.CallbackAction,
      this.onNextDay,
      this.titleGet,
      this.onTitleTapped,
      this.icon,
      this.onPreviousDay,
      this.secondaryDate,
      this.backgroundColor = Constants.headerBackground,
      this.iconColor = Constants.black,
      required this.studentProfile})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);
  @override
  final Size preferredSize;
  @override
  State<CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      actions: [
        IconButton(
          onPressed: widget.onNextDay,
          icon: Icon(widget.icon,
              color: Color(0xff000000) == Theme.of(context).backgroundColor
                  ? AppTheme.kDarkModeIconColor
                  : AppTheme.kLightModeIconColor),
        ),
        // Icon(
        //   widget.icon,
        // ),
        IconButton(
          onPressed: () {
            _showPopUp(widget.studentProfile!);
            //print("profile url");
          },
          icon: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(60),
            ), //
            child: CachedNetworkImage(
              // height: 30,
              fit: BoxFit.cover,
              imageUrl: widget.studentProfile!.profilePicture!,
              placeholder: (context, url) =>
                  CupertinoActivityIndicator(animating: true, radius: 10),
            ),
          ),
        ),
      ],
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.chevron_left,
            size: 35,
            color: Color(0xff000000) == Theme.of(context).backgroundColor
                ? AppTheme.kDarkModeIconColor
                : AppTheme.kLightModeIconColor),
      ),
      title: InkWell(
        onTap: widget.onTitleTapped,
        child: FittedBox(
          child: Text(
            widget.dateStringBuilder(widget.date,
                secondaryDate: widget.secondaryDate),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline2!.copyWith(
                fontWeight: FontWeight.w400,
                color: Color(0xff000000) == Theme.of(context).backgroundColor
                    ? AppTheme.kDarkModeIconColor
                    : AppTheme.kLightModeIconColor),
          ),
        ),
      ),
    );
  }

  _showPopUp(UserInformation userInformation) {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return CustomDialogBox(
              isUserInfoPop: true,
              profileData: userInformation,
              onSignOut: () async {
                clearUser();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => HomePage(
                              index: Globals.controller!.index,
                            )),
                    (_) => false);
              });
        });
  }

  Future<bool> clearUser() async {
    try {
      LocalDatabase<UserInformation> _localDb =
          LocalDatabase('student_profile');
      await _localDb.clear();
      await _localDb.close();
      String? _scheduleObjectName = "${Strings.scheduleObjectDetails}";
      String? _blackoutDateObjectName = "${Strings.blackoutDateObjectDetails}";
      LocalDatabase<Schedule> _scheduleObjectLocalDb =
          LocalDatabase(_scheduleObjectName);

      LocalDatabase<BlackoutDate> _blackoutDateObjectLocalDb =
          LocalDatabase(_blackoutDateObjectName);
      await _scheduleObjectLocalDb.clear();
      await _scheduleObjectLocalDb.close();
      await _blackoutDateObjectLocalDb.clear();
      await _blackoutDateObjectLocalDb.clear();
      return true;
    } catch (e) {
      return false;
    }
  }
}

class DayHeader extends CalendarHeader {
  /// A header widget to display on day view.
  DayHeader(
      {Key? key,
      VoidCallback? onNextDay,
      AsyncCallback? onTitleTapped,
      VoidCallback? onPreviousDay,
      final VoidCallback? titleGet,
      Future<String> Function()? CallbackAction,
      Color iconColor = Constants.black,
      Color backgroundColor = Constants.headerBackground,
      IconData iconData = Icons.calendar_today,
      required DateTime date,
      required UserInformation? studentProfile})
      : super(
            key: key,
            date: date,
            backgroundColor: backgroundColor,
            iconColor: iconColor,
            icon: iconData,
            onNextDay: onNextDay,
            titleGet: titleGet,
            onPreviousDay: onPreviousDay,
            onTitleTapped: onTitleTapped,
            dateStringBuilder: DayHeader._dayStringBuilder,
            studentProfile: studentProfile);
  static String _dayStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      "${date.month}/${date.day}/${date.year}";
}

class MonthHeader extends CalendarHeader {
  /// A header widget to display on month view.
  MonthHeader(
      {Key? key,
      VoidCallback? onNextMonth,
      AsyncCallback? onTitleTapped,
      VoidCallback? onPreviousMonth,
      Color iconColor = Constants.black,
      Color backgroundColor = Constants.headerBackground,
      IconData iconData = Icons.calendar_month_outlined,
      required DateTime date,
      required UserInformation? studentProfile})
      : super(
            key: key,
            date: date,
            onNextDay: onNextMonth,
            icon: iconData,
            onPreviousDay: onPreviousMonth,
            onTitleTapped: onTitleTapped,
            iconColor: iconColor,
            backgroundColor: backgroundColor,
            dateStringBuilder: MonthHeader._monthStringBuilder,
            studentProfile: studentProfile);
  static String _monthStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      Utility.convertTimestampToDateFormat(date, 'MMM yyyy');
}

class WeekHeader extends CalendarHeader {
  /// A header widget to display on week view.
  WeekHeader(
      {Key? key,
      VoidCallback? onNextDay,
      AsyncCallback? onTitleTapped,
      VoidCallback? onPreviousDay,
      required DateTime startDate,
      required DateTime endDate,
      IconData iconData = Icons.calendar_month_sharp,
      Color backgroundColor = Constants.headerBackground,
      required UserInformation? studentProfile})
      : super(
            key: key,
            date: startDate,
            backgroundColor: backgroundColor,
            secondaryDate: endDate,
            onNextDay: onNextDay,
            icon: iconData,
            onPreviousDay: onPreviousDay,
            onTitleTapped: onTitleTapped,
            dateStringBuilder: WeekHeader._weekStringBuilder,
            studentProfile: studentProfile);
  static String _weekStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      "${date.month}/${date.day}/${date.year} to "
      "${secondaryDate != null ? "${secondaryDate.month}/" "${secondaryDate.day}/${secondaryDate.year}" : ""}";
}
