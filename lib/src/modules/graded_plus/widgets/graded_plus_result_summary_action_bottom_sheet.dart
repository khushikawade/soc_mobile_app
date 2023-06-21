import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/helper/result_action_icon_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';

class GradedPlusResultOptionBottomSheet extends StatefulWidget {
  final String? title;
  final double? height;
  // final Function({required String title}) getURlForResultSummaryIcons;
  // final Function({required String title, required String url})
  //resultSummaryIconsOnTap;
  final List<ResultSummaryIcons> resultSummaryIconsModalList;
  final Map<String, String> allUrls;
  final bool assessmentDetailPage;
  const GradedPlusResultOptionBottomSheet(
      {Key? key,
      this.title,
      this.height = 200,
      // required this.getURlForResultSummaryIcons,
      // required this.resultSummaryIconsOnTap,
      required this.resultSummaryIconsModalList,
      required this.allUrls,
      required this.assessmentDetailPage});

  @override
  State<GradedPlusResultOptionBottomSheet> createState() =>
      _GradedPlusResultOptionBottomSheetState();
}

class _GradedPlusResultOptionBottomSheetState
    extends State<GradedPlusResultOptionBottomSheet> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body() {
    return Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: Color(0xff000000) != Theme.of(context).backgroundColor
              ? Color(0xffF7F8F9)
              : Color(0xff111C20),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(left: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topRight,
              child: IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.pop(context);
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                icon: Icon(
                  Icons.clear,
                  color: AppTheme.kButtonColor,
                  size: Globals.deviceType == "phone" ? 28 : 36,
                ),
              ),
            ),
            widget?.title?.isNotEmpty ?? false
                ? Utility.textWidget(
                    context: context,
                    text: widget.title!,
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 18))
                : Container(),
            ...widget.resultSummaryIconsModalList.map(
                (ResultSummaryIcons element) =>
                    _listTileMenu(element: element)),
            SpacerWidget(20)
          ],
        ));
  }

  Widget _listTileMenu({required ResultSummaryIcons element}) {
    return ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 20,
        leading: Container(
          height: 30,
          width: 30,
          //   color: Colors.amber,
          padding: EdgeInsets.only(left: element.title != "Slides" ? 4 : 0),
          child: SvgPicture.asset(
            element.svgPath!,
            // height: 30,
            // width: 30,
            // fit: BoxFit.fill,
            color: element.title == "Dashboard"
                ? Color(0xff000000) == Theme.of(context).backgroundColor
                    ? Color(0xffF7F8F9)
                    : Color(0xff111C20)
                : null,
          ),
        ),
        title: Utility.textWidget(
            text: element.title!,
            context: context,
            textTheme: Theme.of(context).textTheme.headline3!),
        onTap: () {
          // if (element.title == "Dashboard") {
          //   Utility.launchUrlOnExternalBrowser(
          //       "https://www.${Globals.schoolDbnC}.com/");
          // } else {
          bottomIconsOnTap(
              title: element.title ?? '',
              url: widget.allUrls[element.title] ?? '');
          // }
        });
  }

  bottomIconsOnTap({required String title, required String url}) async {
    switch (title) {
      case 'Share':
        String shareLogMsg =
            'Share Button pressed from ${widget.assessmentDetailPage == true ? "Assessment History Detail Page" : "Result Summary"}';
        FirebaseAnalyticsService.addCustomAnalyticsEvent(
            shareLogMsg.toLowerCase().replaceAll(" ", "_") ?? '');
        PlusUtility.updateLogs(
            activityType: 'GRADED+',
            userType: 'Teacher',
            activityId: '13',
            sessionId: Globals.sessionId,
            // widget.assessmentDetailPage == true
            //     ? widget.obj!.sessionId
            //     : '',
            description: shareLogMsg,
            operationResult: 'Success');
        if ((url?.isNotEmpty ?? false) && (url != 'NA')) {
          Share.share(url);
        }
        break;
      case 'Dashboard':
        String dashboardLogMsg =
            'Dashboard Action Button Presses from ${widget.assessmentDetailPage == true ? "Assessment History Detail Page" : "Result Summary"}';
        //-------------------------------------------------------------------------
        FirebaseAnalyticsService.addCustomAnalyticsEvent(
            dashboardLogMsg.toLowerCase().replaceAll(" ", "_") ?? '');
        Fluttertoast.cancel();
        PlusUtility.updateLogs(
            activityType: 'GRADED+',
            userType: 'Teacher',
            activityId: '14',
            sessionId: Globals.sessionId,
            // widget.assessmentDetailPage == true
            //     ? widget.obj!.sessionId
            //     : '',
            description: dashboardLogMsg,
            operationResult: 'Success');
        //-------------------------------------------------------------------------
        Utility.launchUrlOnExternalBrowser(url);
        break;
      case 'Slides':
        String slidesLogMsg =
            "Slide Action Button pressed from ${widget.assessmentDetailPage == true ? "Assessment History Detail Page" : "Result Summary"}";
        //-------------------------------------------------------------------------
        FirebaseAnalyticsService.addCustomAnalyticsEvent(
            slidesLogMsg.toLowerCase().replaceAll(" ", "_") ?? '');
        Fluttertoast.cancel();

        PlusUtility.updateLogs(
            activityType: 'GRADED+',
            userType: 'Teacher',
            activityId: '31',
            sessionId: Globals.sessionId,
            //  widget.assessmentDetailPage == true
            //     ? widget.obj!.sessionId ?? ''
            //     : '',
            description: slidesLogMsg,
            operationResult: 'Success');
        //-------------------------------------------------------------------------
        if ((url?.isNotEmpty ?? false) && (url != 'NA')) {
          Utility.launchUrlOnExternalBrowser(url);
        }

        break;
      case "Sheets":
        if ((url?.isNotEmpty ?? false) && (url != 'NA')) {
          String sheetLogMsg =
              "Sheet Action Button pressed from ${widget.assessmentDetailPage == true ? "Assessment History Detail Page" : "Result Summary"}";
          FirebaseAnalyticsService.addCustomAnalyticsEvent(
              sheetLogMsg.toLowerCase().replaceAll(" ", "_") ?? '');
          PlusUtility.updateLogs(
              activityType: 'GRADED+',
              userType: 'Teacher',
              activityId: '32',
              sessionId: Globals.sessionId,
              //  widget.assessmentDetailPage == true
              //     ? widget.obj!.sessionId ?? ''
              //     : '',
              description: sheetLogMsg,
              operationResult: 'Success');

          await Utility.launchUrlOnExternalBrowser(url);
        }
        break;
      case "Class":
        if ((url?.isNotEmpty ?? false) && (url != 'NA')) {
          //-------------------------------------------------------------------------
          String classroomLogMsg =
              "Sheet Action Button pressed from ${widget.assessmentDetailPage == true ? "Assessment History Detail Page" : "Result Summary"}";
          FirebaseAnalyticsService.addCustomAnalyticsEvent(
              classroomLogMsg.toLowerCase().replaceAll(" ", "_") ?? '');
          PlusUtility.updateLogs(
              activityType: 'GRADED+',
              userType: 'Teacher',
              activityId: '35',
              sessionId: Globals.sessionId,
              //  widget.assessmentDetailPage == true
              //     ? widget.obj!.sessionId ?? ''
              //     : '',
              description: classroomLogMsg,
              operationResult: 'Success');
          //-------------------------------------------------------------------------
          Utility.launchUrlOnExternalBrowser(url);
        }
        break;

      default:
        print(title);
    }
    if (((url?.isEmpty ?? true) || (url == 'NA'))) {
      Utility.currentScreenSnackBar('$title is Not available ', null);
    }
  }
}
