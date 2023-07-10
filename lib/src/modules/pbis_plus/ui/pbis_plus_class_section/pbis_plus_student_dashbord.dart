import 'dart:math';

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_common_behavior_modal.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_student_card_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_total_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_appbar.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_save_and_share_bottom_sheet.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_fab.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_app_bar.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/strings.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PBISPlusStudentDashBoard extends StatefulWidget {
  ValueNotifier<ClassroomStudents> studentValueNotifier;
  final String heroTag;
  final Key scaffoldKey;
  final bool? isFromStudentPlus; // to check user from student plus or PBIS plus
  Widget StudentDetailWidget;
  final String? classroomCourseId;
  final double constraint;
  final String? studentProfile;
  // final List<PBISPlusCommonBehaviorModal>? pBISPlusCommonBehaviorList;
  final Function(ValueNotifier<ClassroomStudents>) onValueUpdate;

  ValueNotifier<bool> isValueChangeNotice = ValueNotifier<bool>(false);
  PBISPlusBloc? pBISPlusBloc;

  PBISPlusStudentDashBoard(
      {Key? key,
      required this.heroTag,
      required this.scaffoldKey,
      this.isFromStudentPlus,
      required this.studentValueNotifier,
      required this.StudentDetailWidget,
      required this.onValueUpdate,
      required this.isValueChangeNotice,
      required this.classroomCourseId,
      required this.constraint,
      this.studentProfile,
      // this.pBISPlusCommonBehaviorList,
      this.pBISPlusBloc})
      : super(key: key);

  @override
  State<PBISPlusStudentDashBoard> createState() =>
      _PBISPlusStudentDashBoardState();
}

class _PBISPlusStudentDashBoardState extends State<PBISPlusStudentDashBoard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final double profilePictureSize = 45;
  final double circleSize = 35;
  final PBISPlusBloc _bloc = PBISPlusBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  ScreenshotController screenshotController =
      ScreenshotController(); // screenshot of whole list
  ScreenshotController headerScreenshotController =
      ScreenshotController(); // screenshot for header widget

  void initState() {
    //  Event call to get dashboard details of interaction
    _bloc.add(GetPBISPlusStudentDashboardLogs(
        studentId: widget.isFromStudentPlus == true
            ? widget.studentValueNotifier.value.profile!.emailAddress!
            : widget.studentValueNotifier.value.profile!.id ?? '',
        isStudentPlus: widget.isFromStudentPlus,
        classroomCourseId: widget.classroomCourseId ?? ''));

    /*-------------------------User Activity Track START----------------------------*/
    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        "pbis_plus_student_dashboard_screen");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'pbis_plus_student_dashboard_screen',
        screenClass: 'PBISPlusStudentDashBoard');
    /*-------------------------User Activity Track END----------------------------*/

    if (widget.isFromStudentPlus == true) {
      widget.pBISPlusBloc = PBISPlusBloc();
      getTeacherSelectedToggleValue();
    }

    super.initState();
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*--------------------------------------------getTeacherSelectedToggleValue------------------------------------- */
/*--------------------------------------------------------------------------------------------------------------s */
  void getTeacherSelectedToggleValue() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final storedValue = pref.getBool(Strings.isCustomBehavior);
      PBISPlusEvent event;

      if (storedValue == true) {
        event = PBISPlusGetTeacherCustomBehavior();
      } else {
        event = PBISPlusGetDefaultSchoolBehavior();
      }
      widget.pBISPlusBloc!.add(event);
    } catch (e) {}
  }

  /*--------------------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------Main Method------------------------------------------*/
  /*--------------------------------------------------------------------------------------------------------*/
  @override
  Widget build(BuildContext context) {
    return widget.isFromStudentPlus == true
        ? body(context)
        : Stack(
            children: [
              CommonBackgroundImgWidget(),
              Scaffold(
                backgroundColor: Colors.transparent,
                appBar: widget.isFromStudentPlus == true
                    ? StudentPlusAppBar(
                        isWorkPage: false,
                        titleIconCode: 0xe825,
                      ) as PreferredSizeWidget
                    : PBISPlusAppBar(
                        title: "Dashboard",
                        backButton: true,
                        scaffoldKey: _scaffoldKey,
                      ),
                body: body(context),
                floatingActionButton: floatingActionButton(context),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.miniEndDocked,
              ),
            ],
          );
  }

  /*--------------------------------------------------------------------------------------------------------*/
  /*--------------------------------------------------------body--------------------------------------------*/
  /*--------------------------------------------------------------------------------------------------------*/
  Widget body(BuildContext context) {
    return widget.isFromStudentPlus == true
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children())
        : ListView(children: children());
  }

  /*--------------------------------------------------------------------------------------------------------*/
  /*----------------------------------updateActionCountStudentPlusModuleWidget------------------------------*/
  /*--------------------------------------------------------------------------------------------------------*/

  // Function to update ValueNotifier in case of student plus
  updateActionCountStudentPlusModuleWidget(
      {required List<PBISPlusTotalInteractionModal> pbisHistoryData}) {
    int engaged = 0;
    int helpful = 0;
    int niceWork = 0;

    for (var i = 0; i < pbisHistoryData.length; i++) {
      engaged = engaged + (pbisHistoryData[i].engaged ?? 0);
      helpful = helpful + (pbisHistoryData[i].helpful ?? 0);
      niceWork = niceWork + (pbisHistoryData[i].niceWork ?? 0);
    }
    // TODOPBIS:
    // widget.studentValueNotifier.value.profile!.behavior1!.counter = engaged;
    // widget.studentValueNotifier.value.profile!.behavior2!.counter = helpful;
    // widget.studentValueNotifier.value.profile!.behavior3!.counter = niceWork;
    widget.studentValueNotifier.value.profile!.engaged = engaged;
    widget.studentValueNotifier.value.profile!.helpful = helpful;
    widget.studentValueNotifier.value.profile!.niceWork = niceWork;
  }

  /*--------------------------------------------------------------------------------------------------------*/
  /*------------------------------------------------refreshPage---------------------------------------------*/
  /*--------------------------------------------------------------------------------------------------------*/
  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    _bloc.add(GetPBISPlusStudentDashboardLogs(
        studentId: widget.isFromStudentPlus == true
            ? widget.studentValueNotifier.value.profile!.emailAddress!
            : widget.studentValueNotifier.value.profile!.id ?? '',
        isStudentPlus: widget.isFromStudentPlus,
        classroomCourseId: widget.classroomCourseId ?? ''));
  }

  /*--------------------------------------------------------------------------------------------------------*/
  /*--------------------------------------------_buildDataTable---------------------------------------------*/
  /*--------------------------------------------------------------------------------------------------------*/
  DataTable _buildDataTable(
          {required List<PBISPlusTotalInteractionModal> list,
          required List<PBISPlusCommonBehaviorModal>
              pBISPlusCommonBehaviorList}) =>
      DataTable(
          headingRowHeight: Globals.deviceType == 'phone' ? 70 : 40,
          dataRowHeight: Globals.deviceType == 'phone' ? 80 : 40,
          dataTextStyle: Theme.of(context).textTheme.headline2,
          showBottomBorder: false,
          headingTextStyle: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(fontWeight: FontWeight.bold),
          headingRowColor: MaterialStateColor.resolveWith(
              (states) => AppTheme.kButtonColor //Color.fromRGBO(50, 52, 67, 1)
              ),
          dividerThickness: 5.0,
          border: TableBorder(
            horizontalInside: BorderSide(
              width: 2.0,
              color: Colors.white,
            ),
          ),
          columns:
              getList(pBISPlusCommonBehaviorList: pBISPlusCommonBehaviorList)
                  .map((PBISPlusCommonBehaviorModal item) {
            return buildDataColumn(
              item: item,
            );
          }).toList(),
          rows: List<DataRow>.generate(
            list.length,
            (index) => buildDataRow(
                index: index,
                list: list,
                pBISPlusCommonBehaviorList: getList(
                    pBISPlusCommonBehaviorList: pBISPlusCommonBehaviorList)),
          ));

  /*--------------------------------------------------------------------------------------------------------*/
  /*--------------------------------------------buildDataColumn---------------------------------------------*/
  /*--------------------------------------------------------------------------------------------------------*/
  // DataColumn buildDataColumn(PBISPlusDataTableModal item,
  //         List<PBISPlusTotalInteractionModal> list) =>
  //     DataColumn(
  //         label: Column(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Center(
  //             widthFactor:
  //                 item.title == 'Date' && list.length > 0 ? 2.45 : null,
  //             // padding: EdgeInsets.only(left: item.title == 'Date' ? 40 : 0),
  //             child: item.title == 'Date' || item.title == 'Total'
  //                 ? Utility.textWidget(
  //                     context: context,
  //                     text: item.title,
  //                     textAlign: TextAlign.center,
  //                     textTheme: Globals.deviceType == 'phone'
  //                         ? Theme.of(context).textTheme.headline5!.copyWith(
  //                               fontWeight: FontWeight.bold,
  //                               color: Color(
  //                                 0xff000000,
  //                               ),
  //                             )
  //                         : Theme.of(context).textTheme.headline1!.copyWith(
  //                             fontWeight: FontWeight.bold,
  //                             color: Color(
  //                               0xff000000,
  //                             ),
  //                             fontSize: 16),
  //                   )
  //                 : item.imagePath.isNotEmpty
  //                     ? SvgPicture.asset(
  //                         item.imagePath,
  //                         height: Globals.deviceType == 'phone' ? 35 : 25,
  //                         width: Globals.deviceType == 'phone' ? 35 : 25,
  //                         // height: Globals.deviceType == 'phone' ? 64 : 74,
  //                         // width: Globals.deviceType == 'phone' ? 64 : 74,
  //                       )
  //                     : SizedBox.shrink()),
  //       ],
  //     ));

  DataColumn buildDataColumn({required PBISPlusCommonBehaviorModal item}) =>
      DataColumn(
          label: Container(
        padding: EdgeInsets.all(5),
        child: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  // widthFactor: item.behaviorTitleC == 'Date' ? 2.45 : null,
                  // padding: EdgeInsets.only(left: item.title == 'Date' ? 40 : 0),
                  child: item.behaviorTitleC == 'Date' ||
                          item.behaviorTitleC == 'Total'
                      ? Utility.textWidget(
                          context: context,
                          text: item.behaviorTitleC ?? '',
                          textAlign: TextAlign.center,
                          textTheme: Globals.deviceType == 'phone'
                              ? Theme.of(context).textTheme.headline5!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Color(
                                      0xff000000,
                                    ),
                                  )
                              : Theme.of(context).textTheme.headline1!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Color(
                                    0xff000000,
                                  ),
                                  fontSize: 16),
                        )
                      : item.pBISBehaviorIconURLC!.isNotEmpty
                          ? CachedNetworkImage(
                              // height: Globals.deviceType == 'phone' ? 35 : 25,
                              // width: Globals.deviceType == 'phone' ? 35 : 25,
                              imageUrl: item.pBISBehaviorIconURLC!,
                              placeholder: (context, url) => ShimmerLoading(
                                isLoading: true,
                                child: Container(),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )
                          : SizedBox.shrink()),
            ],
          ),
        ),
      ));

  /*--------------------------------------------------------------------------------------------------------*/
  /*---------------------------------------------buildDataRow-----------------------------------------------*/
  /*--------------------------------------------------------------------------------------------------------*/

  DataRow buildDataRow(
          {required int index,
          required List<PBISPlusTotalInteractionModal> list,
          required List<PBISPlusCommonBehaviorModal>
              pBISPlusCommonBehaviorList}) =>
      DataRow(
        color: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          return Theme.of(context).backgroundColor; // Use the default value.
        }),
        cells: List<DataCell>.generate(
          pBISPlusCommonBehaviorList.length,
          (int cellIndex) => dataCell(cellIndex == 0
              ? PBISPlusUtility.convertDateString(list[index].createdAt ?? '')
              :  (list[index].engaged ?? 0).toString()),
        ),

        // [

        //   dataCell(
        //       PBISPlusUtility.convertDateString(list[index].createdAt ?? '')),
        //   dataCell((list[index].engaged ?? 0).toString()),
        //   dataCell((list[index].niceWork ?? 0).toString()),
        //   dataCell((list[index].helpful ?? 0).toString()),
        //   // dataCell((list[index].participation ?? 0).toString()),
        //   // dataCell((list[index].collaboration ?? 0).toString()),
        //   // dataCell((list[index].listening ?? 0).toString()),
        //   DataCell(
        //     Container(
        //       padding: Globals.deviceType == 'phone'
        //           ? EdgeInsets.symmetric(horizontal: 10, vertical: 5)
        //           : EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
        //       margin: EdgeInsets.only(left: 2),
        //       decoration: BoxDecoration(
        //         boxShadow: [],
        //         color: Color.fromRGBO(148, 148, 148, 1),
        //         borderRadius: BorderRadius.circular(20),
        //       ),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           Utility.textWidget(
        //             context: context,
        //             text: sumOfInteraction(
        //               engaged: list[index].engaged ?? 0,
        //               niceWork: list[index].niceWork ?? 0,
        //               helpful: list[index].helpful ?? 0,
        //             ),
        //             textAlign: TextAlign.center,
        //             textTheme: Globals.deviceType == 'phone'
        //                 ? Theme.of(context)
        //                     .textTheme
        //                     .headline5!
        //                     .copyWith(fontWeight: FontWeight.bold)
        //                 : Theme.of(context).textTheme.headline1!.copyWith(
        //                     fontWeight: FontWeight.bold, fontSize: 16),
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // ],
      );
  /*--------------------------------------------------------------------------------------------------------*/
  /*-----------------------------------------------dataCell-------------------------------------------------*/
  /*--------------------------------------------------------------------------------------------------------*/

  DataCell dataCell(String? text) {
    return DataCell(Center(
      child: Utility.textWidget(
        text: text!,
        context: context,
        textAlign: TextAlign.center,
        textTheme: Globals.deviceType == 'phone'
            ? Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold)
            : Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ));
  }

  /*--------------------------------------------------------------------------------------------------------*/
  /*-------------------------------------------sumOfInteraction---------------------------------------------*/
  /*--------------------------------------------------------------------------------------------------------*/

  String sumOfInteraction(
      {required int engaged, required int niceWork, required int helpful}) {
    int sum = engaged + niceWork + helpful;
    return sum.toString();
  }

  /*--------------------------------------------------------------------------------------------------------*/
  /*-----------------------------------------floatingActionButton-------------------------------------------*/
  /*--------------------------------------------------------------------------------------------------------*/
  Widget floatingActionButton(
    BuildContext context,
  ) =>
      BlocBuilder<PBISPlusBloc, PBISPlusState>(
          bloc: _bloc,
          builder: (BuildContext contxt, PBISPlusState state) {
            if (state is PBISPlusLoading) {
              return Container();
            } else if (state is PBISPlusStudentDashboardLogSuccess) {
              return PlusCustomFloatingActionButton(
                onPressed: () {
                  _modalBottomSheetMenu(
                      pbisStudentInteractionList:
                          state.pbisStudentInteractionList);
                },
              );
            } else {
              //  shows in condition where email is not not their in case of student plus
              return Container();
            }
          });

  /*--------------------------------------------------------------------------------------------------------*/
  /*----------------------------------------_modalBottomSheetMenu-------------------------------------------*/
  /*--------------------------------------------------------------------------------------------------------*/

  void _modalBottomSheetMenu(
          {required List<PBISPlusTotalInteractionModal>
              pbisStudentInteractionList}) =>
      showModalBottomSheet(
        // useRootNavigator: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        elevation: 10,
        context: context,
        builder: (BuildContext context) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return PBISPlusBottomSheet(
                fromClassScreen: false,
                scaffoldKey: _scaffoldKey,
                screenshotController: screenshotController,
                headerScreenshotController: headerScreenshotController,
                googleClassroomCourseworkList: [], //No list is required since no list is used from this bottomsheet
                content: false,
                height:
                    constraints.maxHeight < 750 && Globals.deviceType == "phone"
                        ? MediaQuery.of(context).size.height * 0.22 //0.45
                        : Globals.deviceType == "phone"
                            ? MediaQuery.of(context).size.height * 0.19 //0.45
                            : MediaQuery.of(context).size.height * 0.15,
                title: '',
                padding: EdgeInsets.fromLTRB(30, 10, 10, 10),
              );
            },
          );
        },
      );

  List<Widget> children() {
    return [
      widget.isFromStudentPlus != true
          ? IconButton(
              alignment: Alignment.centerLeft,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                  IconData(0xe80d,
                      fontFamily: Overrides.kFontFam,
                      fontPackage: Overrides.kFontPkg),
                  color: AppTheme.kButtonColor),
            )
          : Container(),
      // widget.isFromStudentPlus == true
      Container(
        child: Screenshot(
          controller: headerScreenshotController,
          child: BlocBuilder<PBISPlusBloc, PBISPlusState>(
              bloc: _bloc,
              builder: (BuildContext contxt, PBISPlusState state) {
                if (state is PBISPlusLoading) {
                  return PBISPlusStudentCardModal(
                      studentProfile: widget.studentProfile,
                      constraint: widget.constraint,
                      isLoading:
                          widget.isFromStudentPlus == true ? true : false,
                      isFromDashboardPage: true,
                      heroTag: widget.heroTag,
                      onValueUpdate: widget.onValueUpdate,
                      scaffoldKey: widget.scaffoldKey,
                      studentValueNotifier: widget.studentValueNotifier,
                      isFromStudentPlus: widget.isFromStudentPlus,
                      classroomCourseId: widget.classroomCourseId!);
                } else if (state is PBISPlusStudentDashboardLogSuccess) {
                  if (widget.isFromStudentPlus == true) {
                    updateActionCountStudentPlusModuleWidget(
                      pbisHistoryData: state.pbisStudentInteractionList,
                    );
                  }
                  return PBISPlusStudentCardModal(
                      studentProfile: widget.studentProfile,
                      constraint: widget.constraint,
                      isLoading: false,
                      isFromDashboardPage: true,
                      heroTag: widget.heroTag,
                      onValueUpdate: widget.onValueUpdate,
                      scaffoldKey: widget.scaffoldKey,
                      studentValueNotifier: widget.studentValueNotifier,
                      isFromStudentPlus: widget.isFromStudentPlus,
                      classroomCourseId: widget.classroomCourseId!);
                } else {
                  // In case of student email not found in STUDENT+ Module
                  List<PBISPlusTotalInteractionModal> pbisHistoryData = [];
                  if (widget.isFromStudentPlus == true) {
                    updateActionCountStudentPlusModuleWidget(
                      pbisHistoryData: pbisHistoryData,
                    );
                  }
                  return PBISPlusStudentCardModal(
                      studentProfile: widget.studentProfile,
                      constraint: widget.constraint,
                      isLoading: false,
                      isFromDashboardPage: true,
                      heroTag: widget.heroTag,
                      onValueUpdate: widget.onValueUpdate,
                      scaffoldKey: widget.scaffoldKey,
                      studentValueNotifier: widget.studentValueNotifier,
                      isFromStudentPlus: widget.isFromStudentPlus,
                      classroomCourseId: widget.classroomCourseId!);
                }
              }),
        ),
      ),
      // to remove hero widget for STUDENT+
      Container(
        alignment: Alignment.topCenter,
        height: (widget.constraint <= 115)
            ? MediaQuery.of(context).size.height * 0.30
            : MediaQuery.of(context).size.height * 0.32,
        // height: MediaQuery.of(context).size.height * 0.50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5),
        ),
        child: BlocBuilder<PBISPlusBloc, PBISPlusState>(
            bloc: widget.pBISPlusBloc,
            builder: (BuildContext contxt, PBISPlusState state) {
              if (state is PBISPlusGetDefaultSchoolBehaviorSuccess) {
                return buildTable(
                    pBISPlusCommonBehaviorList:
                        state.defaultSchoolBehaviorList);
              }
              if (state is PBISPlusGetTeacherCustomBehaviorSuccess &&
                  state.teacherCustomBehaviorList.isNotEmpty) {
                return buildTable(
                    pBISPlusCommonBehaviorList:
                        state.teacherCustomBehaviorList);
              }

              return Center(
                  child: CircularProgressIndicator.adaptive(
                backgroundColor: AppTheme.kButtonColor,
              ));
            }),
      ),
    ];
  }

  List<PBISPlusCommonBehaviorModal> getList(
      {required List<PBISPlusCommonBehaviorModal> pBISPlusCommonBehaviorList}) {
    List<PBISPlusCommonBehaviorModal> list = pBISPlusCommonBehaviorList;
    if (list[0].behaviorTitleC != "Date") {
      list.insert(0, PBISPlusCommonBehaviorModal(behaviorTitleC: "Date"));
      list.add(PBISPlusCommonBehaviorModal(behaviorTitleC: "Total"));
    }

    return list;
  }

  Widget buildTable(
      {required List<PBISPlusCommonBehaviorModal> pBISPlusCommonBehaviorList}) {
    return BlocBuilder<PBISPlusBloc, PBISPlusState>(
        bloc: _bloc,
        builder: (BuildContext contxt, PBISPlusState state) {
          if (state is PBISPlusLoading) {
            return Center(
                child: CircularProgressIndicator.adaptive(
              backgroundColor: AppTheme.kButtonColor,
            ));
          } else if (state is PBISPlusStudentDashboardLogSuccess) {
            return
                // state.pbisStudentInteractionList.length > 0
                //     ?
                RefreshIndicator(
              color: AppTheme.kButtonColor,
              key: refreshKey,
              onRefresh: refreshPage,
              child: ListView(
                children: [
                  FittedBox(
                      child: Screenshot(
                    controller: screenshotController,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 80),
                      child: _buildDataTable(
                          pBISPlusCommonBehaviorList:
                              pBISPlusCommonBehaviorList,
                          list: state.pbisStudentInteractionList),
                    ),
                  )),
                ],
              ),
            );
            // : RefreshIndicator(
            //     key: refreshKey,
            //     onRefresh: refreshPage,
            //     child: NoDataFoundErrorWidget(
            //         marginTop:
            //             MediaQuery.of(context).size.height * 0.06,
            //         isResultNotFoundMsg: true,
            //         isNews: false,
            //         isEvents: false),
            //   );
          } else {
            //  shows in condition where email is not not their in case of student plus
            return RefreshIndicator(
              color: AppTheme.kButtonColor,
              key: refreshKey,
              onRefresh: refreshPage,
              child: NoDataFoundErrorWidget(
                  // marginTop: MediaQuery.of(context).size.height * 0.1,
                  isResultNotFoundMsg: true,
                  isNews: false,
                  isEvents: false),
            );
          }
        });
  }

  randomNumber() {
    var random = Random();
    int randomNumber = random.nextInt(90) + 10;
    return randomNumber.toString();
  }
}
