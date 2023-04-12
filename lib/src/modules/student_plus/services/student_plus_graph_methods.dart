import 'package:Soc/src/modules/student_plus/services/student_plus_utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StudentPlusGraphMethod {
  /* -------------------------------------------------------------------------- */
  /*             Function to create nycGraphLineBarsData details                */
  /* -------------------------------------------------------------------------- */

  static List<LineChartBarData> graphLineBarsData(
      {required BuildContext context, required bool isIReadyGraph}) {
    return [
      LineChartBarData(
          showingIndicators: showingIndicators(),
          spots: isIReadyGraph == true
              ? listIReadyFlPoint()
              : listNysFlPoint(removeLast: false),
          isCurved: false,
          barWidth: 2,
          color: StudentPlusUtility.oppositeBackgroundColor(context: context),
          dotData: FlDotData(
            show: true,
            getDotPainter: (p0, p1, p2, p3) {
              if (isIReadyGraph == true) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: Theme.of(context).colorScheme.background,
                  strokeWidth: 4,
                  strokeColor: StudentPlusUtility.oppositeBackgroundColor(
                      context: context),
                );
              } else {
                return FlDotCirclePainter(
                    radius: 7,
                    color: Theme.of(context).colorScheme.background,
                    strokeWidth: 3,
                    strokeColor: AppTheme.kButtonColor);
              }
            },
          ),
          dashArray: [8]),
      LineChartBarData(
        spots: isIReadyGraph == true
            ? listIReadyFlPoint()
            : listNysFlPoint(removeLast: true),
        isCurved: false,
        barWidth: 2,
        color: StudentPlusUtility.oppositeBackgroundColor(context: context),
        dotData: FlDotData(
          show: true,
          getDotPainter: (p0, p1, p2, p3) {
            return FlDotCirclePainter(
                radius: 7,
                color: Theme.of(context).colorScheme.background,
                strokeWidth: 3,
                strokeColor: AppTheme.kButtonColor);
          },
        ),
      ),
    ];
  }

  /* -------------------------------------------------------------------------- */
  /*                          Return graph indicator value                      */
  /* -------------------------------------------------------------------------- */

  static List<int> showingIndicators() {
    return [0, 1, 2, 3];
  }

  /* -------------------------------------------------------------------------- */
  /*                             Return nys graph point                         */
  /* -------------------------------------------------------------------------- */

  static List<FlSpot> listNysFlPoint({required bool removeLast}) {
    List<FlSpot> list = [
      // FlSpot(2020, 60),
      FlSpot(2021, 2.25),
      FlSpot(2022, 3.25),
      FlSpot(2023, 3.85),
      FlSpot(2024, 4.25),
    ];
    if (removeLast) {
      list.removeLast();
      return list;
    } else {
      return list;
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                             Return iReady graph points                     */
  /* -------------------------------------------------------------------------- */

  static List<FlSpot> listIReadyFlPoint() {
    return [
      FlSpot(0, 67),
      FlSpot(1, 71),
      FlSpot(2, 68),
      FlSpot(3, 83),
    ];
  }

  /* -------------------------------------------------------------------------- */
  /*                        Function to show tooltipIndicator                   */
  /* -------------------------------------------------------------------------- */

  static List<ShowingTooltipIndicators> showingTooltipIndicators(
      {required BuildContext context, required bool isIReadyGraph}) {
    List<ShowingTooltipIndicators> list = [];

    for (var i = 0; i < 4; i++) {
      list.add(ShowingTooltipIndicators([
        LineBarSpot(
            StudentPlusGraphMethod.graphLineBarsData(
                context: context, isIReadyGraph: isIReadyGraph)[0],
            StudentPlusGraphMethod.graphLineBarsData(
                    context: context, isIReadyGraph: isIReadyGraph)
                .indexOf(StudentPlusGraphMethod.graphLineBarsData(
                    context: context, isIReadyGraph: isIReadyGraph)[0]),
            StudentPlusGraphMethod.graphLineBarsData(
                    context: context, isIReadyGraph: isIReadyGraph)[0]
                .spots[i]),
      ]));
    }
    return list;
  }
}
