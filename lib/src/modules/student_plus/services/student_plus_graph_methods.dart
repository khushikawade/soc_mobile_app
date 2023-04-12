import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StudentPlusGraphMethod {
  /* -------------------------------------------------------------------------- */
  /*             Function to create nycGraphLineBarsData details                */
  /* -------------------------------------------------------------------------- */

    static List<LineChartBarData> graphLineBarsData(
      {required BuildContext context,
      required bool isIReadyGraph,
      required StudentPlusDetailsModel studentDetails,
      required bool isMathSection}) {
    return [
      LineChartBarData(
          showingIndicators: showingIndicators(),
          spots: isIReadyGraph == true
              ? listIReadyFlPoint(
                  isMathsSection: isMathSection, studentDetails: studentDetails)
              : listNysFlPoint(
                  removeLast: false,
                  studentDetails: studentDetails,
                  isMathsSection: isMathSection),
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
            ? listIReadyFlPoint(
                isMathsSection: isMathSection, studentDetails: studentDetails)
            : listNysFlPoint(
                removeLast: true,
                studentDetails: studentDetails,
                isMathsSection: isMathSection),
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

  static List<FlSpot> listNysFlPoint(
      {required bool removeLast,
      required StudentPlusDetailsModel studentDetails,
      required bool isMathsSection}) {
    List<FlSpot> list = [
      // FlSpot(2020, 60),
      FlSpot(
          2020,
          double.parse((isMathsSection == true
                  ? studentDetails.nysMathScore2019C
                  : studentDetails.nysElaScore2019C) ??
              "0.00")),
      FlSpot(
          2021,
          double.parse((isMathsSection == true
                  ? studentDetails.nysMathScore2021C
                  : studentDetails.nysElaScore2021C) ??
              "0.00")),
      FlSpot(
          2022,
          double.parse((isMathsSection == true
                  ? studentDetails.nysMathScore2022C
                  : studentDetails.nysElaScore2022C) ??
              "0.00")),
      FlSpot(
          2023,
          double.parse((isMathsSection == true
                  ? studentDetails.nysMath2023PredictionC
                  : studentDetails.nysEla2023PredictionC) ??
              "0.00")),
    ];
    // List<FlSpot> list = [];
    // list.add(FlSpot(2020, 2.02));
    // if ((isMathsSection == true
    //         ? studentDetails.nysMathPrScore2021C
    //         : studentDetails.nysElaPrScore2021C) !=
    //     null) {
    //   list.add(
    //     FlSpot(
    //         2021,
    //         double.parse((isMathsSection == true
    //                 ? studentDetails.nysMathPrScore2021C
    //                 : studentDetails.nysElaPrScore2021C) ??
    //             "0.00")),
    //   );
    // }
    // if ((isMathsSection == true
    //         ? studentDetails.nysMathPrScore2022C
    //         : studentDetails.nysElaPrScore2022C) !=
    //     null) {
    //   list.add(
    //     FlSpot(
    //         2022,
    //         double.parse((isMathsSection == true
    //                 ? studentDetails.nysMathPrScore2022C
    //                 : studentDetails.nysElaPrScore2022C) ??
    //             "0.00")),
    //   );
    // }

    // if ((isMathsSection == true
    //         ? studentDetails.nysMath2023PredictionC
    //         : studentDetails.nysEla2023PredictionC) !=
    //     null) {
    //   list.add(FlSpot(
    //       2023,
    //       double.parse((isMathsSection == true
    //               ? studentDetails.nysMath2023PredictionC
    //               : studentDetails.nysEla2023PredictionC) ??
    //           "0.00")));
    // }
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

  static List<FlSpot> listIReadyFlPoint(
      {required StudentPlusDetailsModel studentDetails,
      required bool isMathsSection}) {
    return [
      FlSpot(
          0,
          double.parse((isMathsSection == true
                  ? studentDetails.mathPreviousSyEOYPercentile
                  : studentDetails.ELAPreviousSyEOYPercentile) ??
              "0.00")),
      FlSpot(
          1,
          double.parse((isMathsSection == true
                  ? studentDetails.mathCurrentSyBOYPercentile
                  : studentDetails.ELACurrentSyBOYPercentile) ??
              "0.00")),
      FlSpot(
          2,
          double.parse((isMathsSection == true
                  ? studentDetails.mathCurrentSyMOYPercentile
                  : studentDetails.ELACurrentSyMOYPercentile) ??
              "0.00")),
      FlSpot(
          3,
          double.parse((isMathsSection == true
                  ? studentDetails.mathCurrentSyEOYPercentile
                  : studentDetails.ELACurrentSyEOYPercentile) ??
              "0.00")),
    ];
  }

  /* -------------------------------------------------------------------------- */
  /*                        Function to show tooltipIndicator                   */
  /* -------------------------------------------------------------------------- */

  static List<ShowingTooltipIndicators> showingTooltipIndicators(
      {required BuildContext context,
      required bool isIReadyGraph,
      required StudentPlusDetailsModel studentDetails,
      required bool isMathSection}) {
    List<ShowingTooltipIndicators> list = [];

    for (var i = 0; i < 4; i++) {
      list.add(ShowingTooltipIndicators([
        LineBarSpot(
            StudentPlusGraphMethod.graphLineBarsData(
                context: context,
                isIReadyGraph: isIReadyGraph,
                isMathSection: isMathSection,
                studentDetails: studentDetails)[0],
            StudentPlusGraphMethod.graphLineBarsData(
                    context: context,
                    isIReadyGraph: isIReadyGraph,
                    isMathSection: isMathSection,
                    studentDetails: studentDetails)
                .indexOf(StudentPlusGraphMethod.graphLineBarsData(
                    context: context,
                    isIReadyGraph: isIReadyGraph,
                    isMathSection: isMathSection,
                    studentDetails: studentDetails)[0]),
            StudentPlusGraphMethod.graphLineBarsData(
                    context: context,
                    isIReadyGraph: isIReadyGraph,
                    isMathSection: isMathSection,
                    studentDetails: studentDetails)[0]
                .spots[i]),
      ]));
    }
    return list;
  }

  /* ------------------------- Nys tooltip text color ------------------------- */

  static Color nysTooltipColor({required double value}) {
    if (value >= 1.00 && value <= 1.99) {
      return Colors.red;
    } else if ((value >= 2.00 && value <= 2.99)) {
      return Colors.yellow;
    } else if ((value >= 3.00 && value <= 3.99)) {
      return Colors.green;
    } else if ((value >= 4.00 && value <= 4.99)) {
      return Colors.blue;
    } else {
      return Colors.grey;
    }
  }
}
