// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../calendar_view.dart';
import '../constants.dart';
import '../typedefs.dart';


class CalendarPageHeader extends StatefulWidget {
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

  /// Common header for month and day view In this header user can define format
  /// in which date will be displayed by providing [dateStringBuilder] function.
  const CalendarPageHeader({
    Key? key,
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
  }) : super(key: key);

  @override
  State<CalendarPageHeader> createState() => _CalendarPageHeaderState();
}

class _CalendarPageHeaderState extends State<CalendarPageHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: widget.onPreviousDay,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            icon: Icon(
              Icons.chevron_left,
              size: 30,
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: widget.onTitleTapped,
              child: Text(
                widget.dateStringBuilder(widget.date,
                    secondaryDate: widget.secondaryDate),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //  InkWell(
                //  child://Icons.calendar_today_outlined
                Icon(
                  widget.icon,
                ),
                //onTap: () {
                //_showPopupMenu(context, widget.titleGet);
                //  },
                //  )
                // IconButton(
                //   onPressed: onNextDay,
                //   splashColor: Colors.transparent,
                //   focusColor: Colors.transparent,
                //   hoverColor: Colors.transparent,
                //   highlightColor: Colors.transparent,
                //   padding: const EdgeInsets.symmetric(
                //       horizontal: 20.0, vertical: 10.0),
                //   icon: Icon(
                //     Icons.chevron_right,
                //     size: 30,
                //     color: iconColor,
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
