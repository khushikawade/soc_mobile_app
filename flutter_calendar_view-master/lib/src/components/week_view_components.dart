// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:calendar_view/src/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'common_components.dart';

class WeekPageHeader extends CalendarPageHeader {
  /// A header widget to display on week view.
  WeekPageHeader({
    Key? key,
    VoidCallback? onNextDay,
    AsyncCallback? onTitleTapped,
    VoidCallback? onPreviousDay,
    required DateTime startDate,
    required DateTime endDate,
    IconData iconData = Icons.calendar_month_sharp,
    Color backgroundColor = Constants.headerBackground,
  }) : super(
          key: key,
          date: startDate,
          backgroundColor: backgroundColor,
          secondaryDate: endDate,
          onNextDay: onNextDay,
          icon: iconData,
          onPreviousDay: onPreviousDay,
          onTitleTapped: onTitleTapped,
          dateStringBuilder: WeekPageHeader._weekStringBuilder,
        );
  static String _weekStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      "${date.day}/${date.month}/${date.year} to "
      "${secondaryDate != null ? "${secondaryDate.day}/"
          "${secondaryDate.month}/${secondaryDate.year}" : ""}";
}
