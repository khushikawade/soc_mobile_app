// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:calendar_view/src/utility.dart/schedule_utility.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../extensions.dart';
import 'common_components.dart';

/// This class defines default tile to display in day view.
class RoundedEventTile extends StatefulWidget {
  /// Title of the tile.
  final String title;

  /// Description of the tile.
  final String description;
  final String titlefordate;
  final String enddatetext;

  /// Background color of tile.
  /// Default color is [Colors.blue]
  final Color backgroundColor;

  /// If same tile can have multiple events.
  /// In most cases this value will be 1 less than total events.
  final int totalEvents;

  /// Padding of the tile. Default padding is [EdgeInsets.zero]
  final EdgeInsets padding;

  /// Margin of the tile. Default margin is [EdgeInsets.zero]
  final EdgeInsets margin;

  /// Border radius of tile.
  final BorderRadius borderRadius;

  /// Style for title
  final TextStyle? titleStyle;

  /// Style for description
  final TextStyle? descriptionStyle;

  /// This is default tile to display in day view.
  const RoundedEventTile({
    Key? key,
    required this.title,
    required this.titlefordate,
    required this.enddatetext,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.description = "",
    this.borderRadius = BorderRadius.zero,
    this.totalEvents = 1,
    this.backgroundColor = Colors.blue,
    this.titleStyle,
    this.descriptionStyle,
  }) : super(key: key);

  @override
  State<RoundedEventTile> createState() => _RoundedEventTileState();
}

class _RoundedEventTileState extends State<RoundedEventTile> {
  @override
  Widget build(BuildContext context) {
    final isSmallPeriod = ScheduleUtility.getTimeDiffrence(
        startTime: widget.titlefordate, endTime: widget.enddatetext);
    return Container(
      padding: widget.padding,
      margin:
          widget.title.contains('holiday') ? widget.margin * 5 : widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
      ),
      child: widget.title.contains('holiday')
          ? Center(
              child: RotatedBox(
                quarterTurns: -3,
                child: Text(
                  widget.title.replaceAll('holiday', ''),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        color: Theme.of(context).colorScheme.primaryVariant,
                        letterSpacing: 4,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            )
          : isSmallPeriod
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: listOfWidget(isSmallPeriod),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: listOfWidget(isSmallPeriod)),
    );
  }

  List<Widget> listOfWidget(bool isRow) {
    return [
      if (widget.titlefordate.isNotEmpty)
        Expanded(
          flex: 0,
          child: FittedBox(
            child: Text(
              widget.titlefordate,
              style: // widget.titleStyle ??
                  Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      if (widget.title.isNotEmpty)
        Expanded(
          flex: 5,
          child: Padding(
            padding: isRow
                ? EdgeInsets.only(left: 5.0, right: 5.0)
                : EdgeInsets.zero,
            child: Align(
              alignment: !isRow ? Alignment.centerLeft : Alignment.center,
              child: FittedBox(
                child: Text(
                  !isRow ? widget.title : widget.title.replaceAll('\n', ' '),
                  style: widget.titleStyle ??
                      TextStyle(
                        fontSize: 12,
                        color: widget.backgroundColor.accent,
                      ),
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ),
        ),
      // if (widget.description.isNotEmpty)
      //   Flexible(
      //     child: Padding(
      //       padding: const EdgeInsets.only(bottom: 15.0),
      //       child: Text(
      //         widget.description,
      //         style: widget.descriptionStyle ??
      //             TextStyle(
      //               fontSize: 14,
      //               color: widget.backgroundColor.accent.withAlpha(200),
      //             ),
      //       ),
      //     ),
      //   ),
      // if (widget.totalEvents > 1)
      //   Expanded(
      //     child: Text(
      //       "+${widget.totalEvents - 1} more",
      //       style: (widget.descriptionStyle ??
      //               TextStyle(
      //                 color: widget.backgroundColor.accent
      //                     .withAlpha(200),
      //               ))
      //           .copyWith(fontSize: 14),
      //     ),
      //   ),
      if (widget.enddatetext.isNotEmpty)
        Expanded(
          flex: 0,
          child: FittedBox(
            child: Text(
              widget.enddatetext,
              style: //widget.titleStyle ??
                  Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
    ];
  }
}

/// A header widget to display on day view.
class DayPageHeader extends CalendarPageHeader {
  /// A header widget to display on day view.
  const DayPageHeader({
    Key? key,
    VoidCallback? onNextDay,
    AsyncCallback? onTitleTapped,
    VoidCallback? onPreviousDay,
    final VoidCallback? titleGet,
    Future<String> Function()? CallbackAction,
    Color iconColor = Constants.black,
    Color backgroundColor = Constants.headerBackground,
    IconData iconData = Icons.calendar_today,
    required DateTime date,
  }) : super(
          key: key,
          date: date,
          backgroundColor: backgroundColor,
          iconColor: iconColor,
          icon: iconData,
          onNextDay: onNextDay,
          titleGet: titleGet,
          onPreviousDay: onPreviousDay,
          onTitleTapped: onTitleTapped,
          dateStringBuilder: DayPageHeader._dayStringBuilder,
        );
  static String _dayStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      "${date.day}/${date.month}/${date.year}";
}

class DefaultTimeLineMark extends StatelessWidget {
  /// Defines time to display
  final DateTime date;

  /// Text style for time string.
  final TextStyle? markingStyle;

  /// Time marker for timeline used in week and day view.
  const DefaultTimeLineMark({
    Key? key,
    required this.date,
    this.markingStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -7.5),
      child: Text(
        "${((date.hour - 1) % 12) + 1} ${date.hour ~/ 12 == 0 ? "am" : "pm"}",
        textAlign: TextAlign.right,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
