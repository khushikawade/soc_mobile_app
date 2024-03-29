import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_graph_methods.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CommonLineGraphWidget extends StatefulWidget {
  final StudentPlusDetailsModel studentDetails;

  final String graphType;
  final bool isMathsSection;

  const CommonLineGraphWidget(
      {Key? key,
      required this.studentDetails,
      required this.graphType,
      required this.isMathsSection})
      : super(key: key);

  @override
  State<CommonLineGraphWidget> createState() => _CommonLineGraphWidgetState();
}

class _CommonLineGraphWidgetState extends State<CommonLineGraphWidget> {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
          gridData: FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                  sideTitles: widget.graphType == 'nys'
                      ? _nycGraphBottomTitles
                      : _iReadyBottomTitles,
                  drawBehindEverything: true),
              leftTitles: AxisTitles(
                sideTitles: widget.graphType == 'nys'
                    ? _nycGraphLeftTitles
                    : _iReadyLeftTitles,
              ),
              topTitles: AxisTitles(drawBehindEverything: false),
              rightTitles: AxisTitles(drawBehindEverything: false)),
          borderData: FlBorderData(
              border: Border(
                  bottom: BorderSide(
                      color:
                          Color(0xff000000) != Theme.of(context).backgroundColor
                              ? Color(0xff111C20)
                              : Color(0xffF7F8F9),
                      width: 1)),
              show: true),
          maxX: widget.graphType == 'nys'
              ? 2024
              : 3, //  widget.isIReadyGraph == true ? 3 : 2023,
          minX: widget.graphType == 'nys'
              ? 2021
              : 0, // widget.isIReadyGraph == true ? 0 : 2021,
          maxY: widget.graphType == 'nys'
              ? 5
              : 110, // widget.isIReadyGraph == true ? 110 : 5,
          minY: widget.graphType == 'nys'
              ? 0.5
              : 0, // widget.isIReadyGraph == true ? 0 : 0.5,
          showingTooltipIndicators:
              StudentPlusGraphMethod.showingTooltipIndicators(
            context: context,
            graphType: widget.graphType,
            isMathSection: widget.isMathsSection,
            studentDetails: widget.studentDetails,
          ),
          lineTouchData: LineTouchData(
            enabled: false, // false because it will show always
            getTouchedSpotIndicator:
                (LineChartBarData barData, List<int> spotIndexes) {
              return spotIndexes.map((index) {
                return TouchedSpotIndicatorData(
                  FlLine(
                    color: Colors.transparent,
                  ),
                  FlDotData(
                    show: false,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                      radius: 8,
                      color: Colors.transparent,
                      strokeWidth: 1,
                      strokeColor: Colors.transparent,
                    ),
                  ),
                );
              }).toList();
            },
            touchTooltipData: widget.graphType != 'nys'
                ? LineTouchTooltipData(
                    tooltipBgColor: AppTheme.kButtonColor
                        .withOpacity(0.2), // Color(0xFFE9E9E9),
                    //Colors.grey, // Colors.blue.withOpacity(0.4),
                    tooltipRoundedRadius: 5,
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    tooltipHorizontalAlignment: FLHorizontalAlignment.center,
                    tooltipPadding: EdgeInsets.all(5),
                    getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                      return lineBarsSpot.map((lineBarSpot) {
                        return LineTooltipItem(
                          lineBarSpot.y.toInt().toString(),
                          Theme.of(context).textTheme.headline4!.copyWith(
                              color: widget.graphType == 'map'
                                  ? StudentPlusGraphMethod.mapTooltipColor(
                                      value: StudentPlusGraphMethod
                                          .mapColorValue(
                                              x: lineBarSpot.x,
                                              isMathsSection:
                                                  widget.isMathsSection,
                                              studentInfo:
                                                  widget.studentDetails))
                                  : StudentPlusGraphMethod.iReadyTooltipColor(
                                      type: lineBarSpot.x == 1.0
                                          ? 'BOY'
                                          : (lineBarSpot.x == 2.0
                                              ? 'MOY'
                                              : 'EOY'),
                                      value: StudentPlusGraphMethod
                                          .iReadyColorValue(
                                              x: lineBarSpot.x,
                                              isMathsSection:
                                                  widget.isMathsSection,
                                              studentInfo:
                                                  widget.studentDetails))),
                        );
                      }).toList();
                    },
                  )
                : LineTouchTooltipData(
                    tooltipBgColor: AppTheme.kButtonColor.withOpacity(0.2),
                    tooltipRoundedRadius: 5,
                    fitInsideHorizontally: false,
                    fitInsideVertically: true,
                    tooltipHorizontalAlignment: FLHorizontalAlignment.center,
                    tooltipPadding: EdgeInsets.all(5),
                    getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                      return lineBarsSpot.map((lineBarSpot) {
                        return LineTooltipItem(
                            '', Theme.of(context).textTheme.headline4!,
                            children: [
                              TextSpan(
                                text: lineBarSpot.y.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                        color: StudentPlusGraphMethod
                                            .nysTooltipColor(
                                                value: lineBarSpot.y),
                                        fontWeight: FontWeight.bold),
                              ),
                              lineBarSpot.y ==
                                          (widget.isMathsSection == true
                                              ? double.parse(widget
                                                      .studentDetails
                                                      .nysMathPredictionC ??
                                                  '0')
                                              : double.parse(widget
                                                      .studentDetails
                                                      .nysElaPredictionC ??
                                                  '0')) &&
                                      (lineBarSpot.x == 2024.0)
                                  ? TextSpan(
                                      text: '\n' + 'Prediction',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!,
                                    )
                                  : TextSpan()
                            ]);
                      }).toList();
                    },
                  ),
          ),
          lineBarsData: StudentPlusGraphMethod.graphLineBarsData(
              context: context,
              graphType: widget.graphType,
              isMathSection: widget.isMathsSection,
              studentDetails: widget.studentDetails)),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                  Nys graph Bottom Titles                                   */
  /* -------------------------------------------------------------------------- */

  SideTitles get _nycGraphBottomTitles => SideTitles(
        showTitles: true,
        interval: 1,
        reservedSize: Globals.deviceType == 'phone' ? 45 : 65,
        getTitlesWidget: (value, meta) {
          String text = '';
          String grade = '';
          switch (value.toString()) {
            // case '2020.0':
            //   text = '19-20';
            //   grade = "grade ${widget.studentDetails.grade19_20 ?? ''}";
            //   break;
            case '2021.0':
              text = '20-21';
              grade = "grade ${widget.studentDetails.grade20_21 ?? ''}";
              break;
            case '2022.0':
              text = '21-22';
              grade = "grade ${widget.studentDetails.grade21_22 ?? ''}";
              break;
            case '2023.0':
              text = '22-23';
              grade = "grade ${widget.studentDetails.grade22_23 ?? ''}";
              break;
            case '2024.0':
              text = '23-24';
              grade = "grade ${widget.studentDetails.gradeC ?? ''}";
              break;
          }

          return Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Utility.textWidget(
                    text: text,
                    context: context,
                    textTheme: Theme.of(context).textTheme.headline4),
                Utility.textWidget(
                    text: grade,
                    context: context,
                    textTheme: Theme.of(context).textTheme.subtitle2)
              ],
            ),
          );
        },
      );

  /* -------------------------------------------------------------------------- */
  /*                           IReady Side Titles                               */
  /* -------------------------------------------------------------------------- */
  SideTitles get _nycGraphLeftTitles => SideTitles(
        showTitles: true,
        interval: 0.5,
        reservedSize: Globals.deviceType == 'phone' ? 35 : 45,
        getTitlesWidget: (value, meta) {
          String text = value.toString();
          return text == '0.0' || text == '5.0' || text == '0.5'
              ? Container()
              : Utility.textWidget(
                  text: text,
                  context: context,
                  textTheme: Theme.of(context).textTheme.headline4);
        },
      );

  /* -------------------------------------------------------------------------- */
  /*                           IReady graph side tiles                          */
  /* -------------------------------------------------------------------------- */

  SideTitles get _iReadyBottomTitles => SideTitles(
        showTitles: true,
        interval: 1,
        reservedSize: Globals.deviceType == 'phone' ? 45 : 65,
        //reservedSize: 25,
        getTitlesWidget: (value, meta) {
          String text = '';

          switch (value.toString()) {
            case '0.0':
              text = '22-23' + "\n" + ' EOY';
              break;
            case '1.0':
              text = '23-24' + "\n" + ' BOY';
              break;
            case '2.0':
              text = '23-24' + "\n" + ' MOY';
              break;
            case '3.0':
              text = '23-24' + "\n" + ' EOY';
              break;
          }
          return FittedBox(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(text,
                  //  context: context,
                  style: Theme.of(context).textTheme.subtitle1),
            ),
          );
        },
      );
  SideTitles get _iReadyLeftTitles => SideTitles(
        showTitles: true,
        interval: 20,
        reservedSize: 35,
        // reservedSize: 20,
        getTitlesWidget: (value, meta) {
          String text = value.toInt().toString();

          return (text.length == 2 || text.length == 3) && value <= 100
              ? Utility.textWidget(
                  text: text,
                  //  maxLines: 1,
                  context: context,
                  textTheme: Theme.of(context).textTheme.headline4)
              : Container();
        },
      );
}
