// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:calendar_view/src/utility.dart/schedule_utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../extensions.dart';
import 'common_components.dart';

/// This class defines default tile to display in day view.
class RoundedEventTile1 extends StatefulWidget {
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
  const RoundedEventTile1({
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
  State<RoundedEventTile1> createState() => _RoundedEventTile1State();
}

class _RoundedEventTile1State extends State<RoundedEventTile1> {
  @override
  Widget build(BuildContext context) {
    final isSmallPeriod = ScheduleUtility.getTimeDiffrence(
        startTime: widget.titlefordate, endTime: widget.enddatetext);

    return Container(
      padding: widget.padding,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
      ),
      child: widget.description.contains('holiday')
          ? RotatedBox(
              quarterTurns: -3,
              child: FittedBox(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: listOfWidget(isSmallPeriod)),
    );
  }

  List<Widget> listOfWidget(bool isRow) {
    return [
      if (widget.titlefordate.isNotEmpty)
        Expanded(
          flex: isRow ? 2 : 0,
          child: Container(
            alignment: isRow ? null : Alignment.topCenter,
            child: FittedBox(
              child: Text(
                // ignore: prefer_interpolation_to_compose_strings
                widget.titlefordate.split(' ')[0] +
                    '\n' +
                    widget.titlefordate.split(' ')[1],
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        ),
      // if (widget.title.isNotEmpty)
      //   Flexible(
      //     child: ListView(
      //       padding: EdgeInsets.only(top: 1, bottom: 1),
      //       shrinkWrap: true, //
      //       children: [
      //         Text(
      //           widget.title,
      //           textAlign: TextAlign.center,
      //           style: widget.titleStyle ??
      //               TextStyle(
      //                 fontSize: 12,
      //                 color: widget.backgroundColor.accent,
      //               ),
      //           softWrap: true,
      //           overflow: TextOverflow.fade,
      //         ),
      //       ],
      //     ),
      //   ),
      if (widget.description.isNotEmpty)
        Expanded(
          flex: 3,
          child: Container(
            margin: isRow
                ? EdgeInsets.only(left: 2.0, right: 2.0)
                : EdgeInsets.zero,
            alignment: Alignment.center,
            child: ListView(
              padding: EdgeInsets.only(top: 2, bottom: 2),
              shrinkWrap: true, //
              children: [
                if (isRow)
                  FittedBox(child: buildTextWidget())
                else
                  buildTextWidget()
              ],
            ),
          ),
        ),
      if (widget.enddatetext.isNotEmpty)
        Expanded(
          flex: isRow ? 2 : 0,
          child: Container(
            alignment: isRow ? null : Alignment.bottomCenter,
            child: FittedBox(
              child: Text(
                // ignore: prefer_interpolation_to_compose_strings
                widget.enddatetext.split(' ')[0] +
                    '\n' +
                    widget.enddatetext.split(' ')[1],
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        )
    ];
  }

  Widget buildTextWidget() {
    return Text(
      widget.description,
      textAlign: TextAlign.center,
      style: widget.titleStyle ??
          TextStyle(
            fontSize: 11,
            color: widget.backgroundColor.accent,
          ),
      softWrap: true,
      overflow: TextOverflow.fade,
    );
  }
}

/// A header widget to display on day view.
class DayPageHeader extends CalendarPageHeader {
  /// A header widget to display on day view.
  DayPageHeader({
    Key? key,
    VoidCallback? onNextDay,
    AsyncCallback? onTitleTapped,
    VoidCallback? onPreviousDay,
    Color iconColor = Constants.black,
    Color backgroundColor = Constants.headerBackground,
    required DateTime date,
  }) : super(
          key: key,
          date: date,
          backgroundColor: backgroundColor,
          iconColor: iconColor,
          onNextDay: onNextDay,
          onPreviousDay: onPreviousDay,
          onTitleTapped: onTitleTapped,
          dateStringBuilder: DayPageHeader._dayStringBuilder,
        );
  static String _dayStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      "${date.day} - ${date.month} - ${date.year}";
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
      child: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: Text(
          "${((date.hour - 1) % 12) + 1} ${date.hour ~/ 12 == 0 ? "am" : "pm"}",
          textAlign: TextAlign.right,
          style: markingStyle ?? TextStyle(fontSize: 15.0, color: Colors.black),
        ),
      ),
    );
  }
}
