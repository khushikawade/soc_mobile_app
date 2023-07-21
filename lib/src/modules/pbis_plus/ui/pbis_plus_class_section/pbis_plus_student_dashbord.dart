// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:math';

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_common_behavior_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_total_behaviour_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
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
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
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
  final String? sectionType;
  // final List<PBISPlusCommonBehaviorModal>? pBISPlusCommonBehaviorList;
  final Function(ValueNotifier<ClassroomStudents>) onValueUpdate;

  ValueNotifier<bool> isValueChangeNotice = ValueNotifier<bool>(false);
  PBISPlusBloc pBISPlusBloc;

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
      required this.pBISPlusBloc,
      this.sectionType})
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
  ScrollController? _scrollController;
  final ValueNotifier<bool> isScrolledUp = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isListScrollUp = ValueNotifier<bool>(false);
  PBISPlusBloc pBISPlusBloc = PBISPlusBloc();
  ScrollController _innerScrollController = ScrollController();

  final ValueNotifier<List<PBISPlusTotalBehaviourModal>>
      pbisStudentInteractionListNotifier =
      ValueNotifier<List<PBISPlusTotalBehaviourModal>>([]);

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
      getTeacherSelectedToggleValue();
    } else {
      _scrollController = ScrollController();
      _scrollController!.addListener(_handleScroll);
    }
    _scrollController = ScrollController();
    _scrollController!.addListener(_handleScroll);
    _innerScrollController.addListener(_onScroll);

    super.initState();
  }

  void _onScroll() {
    if (_innerScrollController.position.atEdge &&
        _innerScrollController.position.pixels != 0) {
      _loadMoreLogsData();
    }
  }

  @override
  void dispose() {
    _scrollController!.removeListener(_handleScroll);

    _scrollController!.dispose();

    _innerScrollController.removeListener(_onScroll);
    _innerScrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    isScrolledUp.value = _scrollController!.offset >= 400;
    if (_scrollController?.position.pixels ==
        _scrollController?.position.maxScrollExtent) {
      isListScrollUp.value = true;
    } else if (_scrollController!.position.pixels == 0) {
      isListScrollUp.value = false;
    }
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
        ? pbisPlusBody(context)
        : Stack(children: [
            CommonBackgroundImgWidget(),
            ValueListenableBuilder(
                valueListenable: isScrolledUp,
                builder: (context, value, child) {
                  return Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: widget.isFromStudentPlus == true
                          ? StudentPlusAppBar(
                              isWorkPage: false,
                              titleIconCode: 0xe825,
                              refresh: (value) {},
                              sectionType: '',
                            )
                          : appBar(),
                      body: pbisPlusBody(context),
                      floatingActionButton: floatingActionButton(context),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.miniEndDocked);
                })
          ]);
  }

  /*--------------------------------------------------------------------------------------------------------*/
  /*--------------------------------------------------------body--------------------------------------------*/
  /*--------------------------------------------------------------------------------------------------------*/
  Widget studentPlusBody(BuildContext context) {
    return widget.isFromStudentPlus == true
        ? ListView(children: bodyFrameWidget())
        : ListView(children: bodyFrameWidget());
  }

  Widget pbisPlusBody(BuildContext context) {
    return widget.isFromStudentPlus == true
        ? buildNestedScrollView()
        : Column(
            children: [
              sectionHeader(),
              Flexible(
                child: buildNestedScrollView(),
              ),
            ],
          );
  }

  NestedScrollView buildNestedScrollView() {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[buildSliverAppBar()];
      },
      body: buildTableSection(),
    );
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
          {required List<PBISPlusTotalBehaviourModal>
              pbisStudentInteractionLogsList,
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
              horizontalInside: BorderSide(width: 2.0, color: Colors.white)),
          columns: getTableHeadersList(
                  pBISPlusCommonBehaviorList: pBISPlusCommonBehaviorList)
              .map((PBISPlusCommonBehaviorModal item) {
            return buildDataColumn(item: item);
          }).toList(),
          rows: List<DataRow>.generate(
              pbisStudentInteractionLogsList.length ?? 0,
              (index) => buildDataRow(
                  index: index,
                  pbisStudentInteractionLogsList: pbisStudentInteractionLogsList ?? [],
                  pBISPlusCommonBehaviorList: getTableHeadersList(pBISPlusCommonBehaviorList: pBISPlusCommonBehaviorList ?? []))));

  /*--------------------------------------------------------------------------------------------------------*/
  /*--------------------------------------------buildDataColumn---------------------------------------------*/
  /*--------------------------------------------------------------------------------------------------------*/

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
                        child: item.behaviorTitleC == 'Date' ||
                                item.behaviorTitleC == 'Total'
                            ? Utility.textWidget(
                                context: context,
                                text: item.behaviorTitleC ?? '',
                                textAlign: TextAlign.center,
                                textTheme: Globals.deviceType == 'phone'
                                    ? Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff000000))
                                    : Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff000000),
                                            fontSize: 16))
                            : item.pBISBehaviorIconURLC!.isNotEmpty
                                ? CachedNetworkImage(
                                    // height: Globals.deviceType == 'phone' ? 35 : 25,
                                    // width: Globals.deviceType == 'phone' ? 35 : 25,
                                    imageUrl: item.pBISBehaviorIconURLC!,
                                    placeholder: (context, url) =>
                                        ShimmerLoading(
                                            isLoading: true,
                                            child: Container()),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error))
                                : SizedBox.shrink()),
                  ]))));

  /*--------------------------------------------------------------------------------------------------------*/
  /*---------------------------------------------buildDataRow-----------------------------------------------*/
  /*--------------------------------------------------------------------------------------------------------*/

// Function to generate a DataRow widget for a given index in a table.
  DataRow buildDataRow({
    required int index, // Index of the row in the table.
    required List<PBISPlusTotalBehaviourModal>
        pbisStudentInteractionLogsList, // List of behavior modals for the entire table.
    required List<PBISPlusCommonBehaviorModal>
        pBISPlusCommonBehaviorList, // List of common behavior modals.
  }) {
    // Get the formatted creation date string or use an empty string if it's null.
    final createdAt = PBISPlusUtility.convertDateString(
        pbisStudentInteractionLogsList[index].createdAt ?? '');

    return DataRow(
      // Set the color of the DataRow to transparent.
      color: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return Colors.transparent; // Use the default value.
        },
      ),
      cells: List<DataCell>.generate(
        pBISPlusCommonBehaviorList.length,
        (int cellIndex) {
          // If the cell index is the last one (TOTAL), return a DataCell.
          if (cellIndex == (pBISPlusCommonBehaviorList.length - 1)) {
            return totalDataCell(sumOfInteraction(
                pBISPlusCommonBehaviorList: pBISPlusCommonBehaviorList,
                interactionCounts:
                    pbisStudentInteractionLogsList[index].interactionCounts ??
                        []));
          }

          // Get the count for the current cell index and convert it to a String.
          final cellCount = getCurrentCellCounts(
              pBISPlusCommonBehaviorList[cellIndex],
              pbisStudentInteractionLogsList[index].interactionCounts ?? []);

          // Return the appropriate DataCell based on the cell index.
          return dataCell(cellIndex == 0 ? createdAt : cellCount);
        },
      ),
    );
  }

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
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 16))));
  }

  totalDataCell(String? text) {
    return DataCell(Container(
        padding: Globals.deviceType == 'phone'
            ? EdgeInsets.symmetric(horizontal: 10, vertical: 5)
            : EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
        margin: EdgeInsets.only(left: 2),
        decoration: BoxDecoration(
            boxShadow: [],
            color: Color.fromRGBO(148, 148, 148, 1),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Utility.textWidget(
                  context: context,
                  text: text ?? "0",
                  textAlign: TextAlign.center,
                  textTheme: Globals.deviceType == 'phone'
                      ? Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontWeight: FontWeight.bold)
                      : Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 16))
            ])));
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
                  //TODDO
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
          {required List<PBISPlusTotalBehaviourModal>
              pbisStudentInteractionList}) =>
      showModalBottomSheet(
        useRootNavigator: true,
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
                            ? MediaQuery.of(context).size.height * 0.28 //0.45
                            : MediaQuery.of(context).size.height * 0.15,
                title: '',
                padding: EdgeInsets.fromLTRB(30, 10, 10, 10),
              );
            },
          );
        },
      );

  List<Widget> bodyFrameWidget() {
    return [buildBehaviourSection(), buildTableSection()];
  }

// add date and total on table
  List<PBISPlusCommonBehaviorModal> getTableHeadersList(
      {required final List<PBISPlusCommonBehaviorModal>
          pBISPlusCommonBehaviorList}) {
    List<PBISPlusCommonBehaviorModal> list = pBISPlusCommonBehaviorList;
    if (list[0].behaviorTitleC != "Date") {
      list.insert(0, PBISPlusCommonBehaviorModal(behaviorTitleC: "Date"));
      list.add(PBISPlusCommonBehaviorModal(behaviorTitleC: "Total"));
    }

    return list;
  }

  Widget buildTable(
      {required List<PBISPlusCommonBehaviorModal> pBISPlusCommonBehaviorList}) {
    return BlocConsumer<PBISPlusBloc, PBISPlusState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is PBISPlusStudentDashboardLogSuccess) {
            pbisStudentInteractionListNotifier.value = [];
            pbisStudentInteractionListNotifier.value =
                state.pbisStudentInteractionList;
          }
        },
        builder: (BuildContext contxt, PBISPlusState state) {
          if (state is PBISPlusLoading) {
            return Center(
                child: CircularProgressIndicator.adaptive(
              backgroundColor: AppTheme.kButtonColor,
            ));
          } else if (state is PBISPlusStudentDashboardLogSuccess) {
            return pbisStudentInteractionListNotifier.value.length > 0
                ? RefreshIndicator(
                    color: AppTheme.kButtonColor,
                    key: refreshKey,
                    onRefresh: refreshPage,
                    child: ValueListenableBuilder(
                        valueListenable: isListScrollUp,
                        builder: (context, value, child) {
                          return ValueListenableBuilder(
                              valueListenable:
                                  pbisStudentInteractionListNotifier,
                              builder: (context, value, child) {
                                return ListView(
                                    controller: _innerScrollController,
                                    padding: EdgeInsets.only(bottom: 120),
                                    physics: isListScrollUp.value
                                        ? BouncingScrollPhysics()
                                        : NeverScrollableScrollPhysics(),
                                    children: [
                                      FittedBox(
                                          child: Screenshot(
                                              controller: screenshotController,
                                              child: Material(
                                                  color: Color(0xff000000) !=
                                                          Theme.of(context)
                                                              .backgroundColor
                                                      ? Color(0xffF7F8F9)
                                                      : Color(0xff111C20),
                                                  elevation: 10,
                                                  child: Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 10),
                                                      child: _buildDataTable(
                                                          pBISPlusCommonBehaviorList:
                                                              pBISPlusCommonBehaviorList,
                                                          pbisStudentInteractionLogsList:
                                                              pbisStudentInteractionListNotifier
                                                                  .value))))),
                                      if (state.isLoading == true)
                                        buildLoaderWidget()
                                      else
                                        buildAllCaughtUp()
                                    ]);
                              });
                        }))
                : RefreshIndicator(
                    key: refreshKey,
                    onRefresh: refreshPage,
                    child: NoDataFoundErrorWidget(
                        marginTop: MediaQuery.of(context).size.height * 0.06,
                        isResultNotFoundMsg: true,
                        isNews: false,
                        isEvents: false),
                  );
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

  Widget buildBehaviourSection() {
    return Container(
      child: Screenshot(
        controller: headerScreenshotController,
        child: BlocBuilder<PBISPlusBloc, PBISPlusState>(
            bloc: _bloc,
            builder: (BuildContext contxt, PBISPlusState state) {
              if (state is PBISPlusLoading) {
                return PBISPlusStudentCardModal(
                    studentProfile: widget.studentProfile,
                    constraint: widget.constraint,
                    isLoading: widget.isFromStudentPlus == true ? true : false,
                    isFromDashboardPage: true,
                    heroTag: widget.heroTag,
                    onValueUpdate: widget.onValueUpdate,
                    scaffoldKey: widget.scaffoldKey,
                    studentValueNotifier: widget.studentValueNotifier,
                    isFromStudentPlus: widget.isFromStudentPlus,
                    classroomCourseId: widget.classroomCourseId!);
              } else if (state is PBISPlusStudentDashboardLogSuccess) {
                if (widget.isFromStudentPlus == true) {
                  //TODDO

                  // updateActionCountStudentPlusModuleWidget(
                  //   pbisHistoryData: state.pbisStudentInteractionList,
                  // );
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
    );
  }

  buildTableSection() {
    return Container(
        alignment: Alignment.topCenter,
        height: (widget.constraint <= 115)
            ? MediaQuery.of(context).size.height * 0.30
            : MediaQuery.of(context).size.height * 0.32,
        // height: MediaQuery.of(context).size.height * 0.50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 16, right: 16, top: 10),
        // padding: EdgeInsets.only(bottom: 40),
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
                      backgroundColor: AppTheme.kButtonColor));
            }));
  }

  buildSliverAppBar() {
    return SliverAppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        expandedHeight: widget.isFromStudentPlus == true
            ? MediaQuery.of(context).size.height / 2.0
            : MediaQuery.of(context).size.height / 1.9,
        flexibleSpace: FlexibleSpaceBar(
            background: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: buildBehaviourSection())));
  }

  appBar() {
    return PBISPlusAppBar(
        titleIconData: IconData(0xe825,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        title: "Dashboard",
        backButton: true,
        scaffoldKey: _scaffoldKey);
  }

  sectionHeader() {
    return widget.isFromStudentPlus != true
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                    alignment: Alignment.centerLeft,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                        IconData(0xe80d,
                            fontFamily: Overrides.kFontFam,
                            fontPackage: Overrides.kFontPkg),
                        color: AppTheme.kButtonColor),
                  ),
                ),
                if (isScrolledUp.value == true)
                  Expanded(
                      flex: 3,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 23),
                                child: Text(
                                  widget.studentValueNotifier.value.profile
                                          ?.name?.fullName ??
                                      '',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                ))
                          ]))
              ])
        : Container();
  }

  /*--------------------------------------------------------------------------------------------------------*/
  /*-------------------------------------------getCurrentCellCounts---------------------------------------------*/
  /*--------------------------------------------------------------------------------------------------------*/
  String getCurrentCellCounts(
    PBISPlusCommonBehaviorModal pBISPlusCommonBehavior,
    List<InteractionCounts> interactionList,
  ) {
    if (pBISPlusCommonBehavior == null) {
      return '0'; // Cell index out of bounds, return '0'.
    }

    for (var element in interactionList) {
      if (element.behaviourId == pBISPlusCommonBehavior.id) {
        return element.behaviorCount.toString();
      }
    }

    return '0'; // No match found, return '0'.
  }

  /*--------------------------------------------------------------------------------------------------------*/
  /*-------------------------------------------sumOfInteraction---------------------------------------------*/
  /*--------------------------------------------------------------------------------------------------------*/

// Function to calculate the sum of behavior counts for given common behaviors and interaction counts.
  String sumOfInteraction({
    required List<PBISPlusCommonBehaviorModal>
        pBISPlusCommonBehaviorList, // List of common behavior modals.
    required List<InteractionCounts>
        interactionCounts, // List of interaction counts, can be null.
  }) {
    try {
      int totalCounts = 0; // Initialize the total count variable to 0.

      // Iterate over each PBISPlusCommonBehaviorModal in the list.
      for (var currentBehavior in pBISPlusCommonBehaviorList) {
        // Filter the relevant InteractionCounts based on the behavior id.
        var filteredInteractions = interactionCounts.where(
            (interaction) => interaction.behaviourId == currentBehavior.id);

        // Sum the behaviorCount using the fold method.
        int behaviorCountSum = filteredInteractions.fold(
          0,
          (sum, interaction) => sum + interaction.behaviorCount!,
        );

        // Add the behaviorCount sum to the totalCounts.
        totalCounts += behaviorCountSum;
      }

      // Return the total counts as a String.
      return totalCounts.toString();
    } catch (e) {
      print(e);
      return '0';
    }
  }

  Widget buildLoaderWidget() {
    return Container(
        padding: EdgeInsets.only(top: 15, bottom: 40),
        child: Center(
          child: Platform.isIOS
              ? CupertinoActivityIndicator(
                  color: AppTheme.kButtonbackColor,
                )
              : Container(
                  margin: EdgeInsets.only(bottom: 15),
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppTheme.kButtonColor,
                  ),
                ),
        ));
  }

  Widget buildAllCaughtUp() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Row(children: [
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Divider(
                    color: Theme.of(context).colorScheme.background ==
                            Color(0xff000000)
                        ? Colors.white
                        : Colors.black,
                    height: 40,
                  )),
            ),
            Container(
              width: 50,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return RadialGradient(
                        center: Alignment.topLeft,
                        radius: 0.5,
                        colors: <Color>[
                          AppTheme.kButtonColor,
                          AppTheme.kSelectedColor,
                        ],
                        tileMode: TileMode.repeated,
                      ).createShader(bounds);
                    },
                    child: Icon(Icons.done, color: AppTheme.kButtonColor),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background ==
                            Color(0xff000000)
                        ? Color(0xff111C20)
                        : Color(0xffF7F8F9),
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppTheme.kButtonColor,
                  AppTheme.kSelectedColor,
                ]),
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                  child: Divider(
                    color: Theme.of(context).colorScheme.background ==
                            Color(0xff000000)
                        ? Colors.white
                        : Colors.black,
                    height: 40,
                  )),
            ),
          ]),
          Container(
            padding: EdgeInsets.only(top: 15),
            // height: 80,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Utility.textWidget(
                    context: context,
                    text: "You're All Caught Up",
                    textAlign: TextAlign.center,
                    textTheme: Theme.of(context).textTheme.headline1!.copyWith(
                        color: Theme.of(context).colorScheme.background ==
                                Color(0xff000000)
                            ? Colors.white
                            : Colors.black, //AppTheme.kButtonColor,
                        fontWeight: FontWeight.bold)),
                SpacerWidget(10),
                Utility.textWidget(
                    context: context,
                    text: "You've seen all available student logs",
                    // 'You\'ve fetched all the available ${selectedValue.value == 'All' ? '' : selectedValue.value} files from Graded+ Assignment',
                    textAlign: TextAlign.center,
                    textTheme: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: Colors.grey, //AppTheme.kButtonColor,
                        )),
              ],
            ),
          )
        ],
      ),
    );
  }

  _loadMoreLogsData() async {
    _bloc.add(PBISPlusGetMoreStudentDashboardLogs(
        studentId: widget.isFromStudentPlus == true
            ? widget.studentValueNotifier.value.profile!.emailAddress!
            : widget.studentValueNotifier.value.profile!.id ?? '',
        isStudentPlus: widget.isFromStudentPlus,
        classroomCourseId: widget.classroomCourseId ?? '',
        pbisStudentInteractionList: pbisStudentInteractionListNotifier.value));
  }
}
