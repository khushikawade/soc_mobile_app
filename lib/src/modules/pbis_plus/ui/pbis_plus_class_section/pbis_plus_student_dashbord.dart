import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_total_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_student_card_modal.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_appbar.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_background_img.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_bottom_sheet.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_fab.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_app_bar.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PBISPlusStudentDashBoard extends StatefulWidget {
  ValueNotifier<ClassroomStudents> studentValueNotifier;
  final String heroTag;
  final Key scaffoldKey;
  final bool? isFromStudentPlus; // to check user from student plus or PBIS plus
  Column StudentDetailWidget;
  final Function(ValueNotifier<ClassroomStudents>) onValueUpdate;

  ValueNotifier<bool> isValueChangeNotice = ValueNotifier<bool>(false);

  PBISPlusStudentDashBoard(
      {Key? key,
      required this.heroTag,
      required this.scaffoldKey,
      this.isFromStudentPlus,
      required this.studentValueNotifier,
      required this.StudentDetailWidget,
      required this.onValueUpdate,
      required this.isValueChangeNotice})
      : super(key: key);

  @override
  State<PBISPlusStudentDashBoard> createState() =>
      _PBISPlusStudentDashBoardState();
}

class _PBISPlusStudentDashBoardState extends State<PBISPlusStudentDashBoard> {
  final double profilePictureSize = 45;
  final double circleSize = 35;
  final PBISPlusBloc _bloc = PBISPlusBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  void initState() {
    //  Event call to get dashboard details of interaction
    _bloc.add(GetPBISPlusStudentDashboardLogs(
        studentId: widget.isFromStudentPlus == true
            ? widget.studentValueNotifier.value.profile!.emailAddress!
            : widget.studentValueNotifier.value.profile!.id ?? ''));
    super.initState();
  }

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
                      ),
                body: body(context),
                floatingActionButton: floatingActionButton(
                  context,
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.miniEndDocked,
              ),
            ],
          );
  }

  Widget body(BuildContext context) {
    return Column(
      children: [
        // widget.isFromStudentPlus == true
        BlocBuilder<PBISPlusBloc, PBISPlusState>(
            bloc: _bloc,
            builder: (BuildContext contxt, PBISPlusState state) {
              if (state is PBISPlusLoading) {
                return PBISPlusStudentCardModal(
                    isLoading: widget.isFromStudentPlus == true ? true : false,
                    isFromDashboardPage: true,
                    heroTag: widget.heroTag,
                    onValueUpdate: widget.onValueUpdate,
                    scaffoldKey: widget.scaffoldKey,
                    studentValueNotifier: widget.studentValueNotifier,
                    isFromStudentPlus: widget.isFromStudentPlus,
                    classroomCourseId: '');
              } else if (state is PBISPlusStudentDashboardLogSuccess) {
                if (widget.isFromStudentPlus == true) {
                  updateActionCountStudentPlusModuleWidget(
                    pbisHistoryData: state.pbisStudentInteractionList,
                  );
                }
                return PBISPlusStudentCardModal(
                    isLoading: false,
                    isFromDashboardPage: true,
                    heroTag: widget.heroTag,
                    onValueUpdate: widget.onValueUpdate,
                    scaffoldKey: widget.scaffoldKey,
                    studentValueNotifier: widget.studentValueNotifier,
                    isFromStudentPlus: widget.isFromStudentPlus,
                    classroomCourseId: '');
              } else {
                // In case of student email not found in STUDENT+ Module

                List<PBISPlusTotalInteractionModal> pbisHistoryData = [];
                updateActionCountStudentPlusModuleWidget(
                  pbisHistoryData: pbisHistoryData,
                );
                return PBISPlusStudentCardModal(
                    isLoading: false,
                    isFromDashboardPage: true,
                    heroTag: widget.heroTag,
                    onValueUpdate: widget.onValueUpdate,
                    scaffoldKey: widget.scaffoldKey,
                    studentValueNotifier: widget.studentValueNotifier,
                    isFromStudentPlus: widget.isFromStudentPlus,
                    classroomCourseId: '');
              }
            }),

        // to remove hero widget for STUDENT+
        Container(
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height * 0.41,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
          ),
          child: BlocBuilder<PBISPlusBloc, PBISPlusState>(
              bloc: _bloc,
              builder: (BuildContext contxt, PBISPlusState state) {
                if (state is PBISPlusLoading) {
                  return Center(
                      child: CircularProgressIndicator.adaptive(
                    backgroundColor: AppTheme.kButtonColor,
                  ));
                } else if (state is PBISPlusStudentDashboardLogSuccess) {
                  return state.pbisStudentInteractionList.length > 0
                      ? RefreshIndicator(
                          key: refreshKey,
                          onRefresh: refreshPage,
                          child: ListView(
                            children: [
                              FittedBox(
                                  child: _buildDataTable(
                                      list: state.pbisStudentInteractionList)),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          key: refreshKey,
                          onRefresh: refreshPage,
                          child: NoDataFoundErrorWidget(
                              marginTop:
                                  MediaQuery.of(context).size.height * 0.06,
                              isResultNotFoundMsg: true,
                              isNews: false,
                              isEvents: false),
                        );
                } else {
                  //  shows in condition where email is not not their in case of student plus
                  return RefreshIndicator(
                    key: refreshKey,
                    onRefresh: refreshPage,
                    child: NoDataFoundErrorWidget(
                        // marginTop: MediaQuery.of(context).size.height * 0.1,
                        isResultNotFoundMsg: true,
                        isNews: false,
                        isEvents: false),
                  );
                }
              }),
        ),
      ],
    );
  }

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

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    _bloc.add(GetPBISPlusStudentDashboardLogs(
        studentId: widget.isFromStudentPlus == true
            ? widget.studentValueNotifier.value.profile!.emailAddress!
            : widget.studentValueNotifier.value.profile!.id ?? ''));
  }

  DataTable _buildDataTable(
          {required List<PBISPlusTotalInteractionModal> list}) =>
      DataTable(
        headingRowHeight: 90,
        dataRowHeight: 60,
        dataTextStyle: Theme.of(context).textTheme.headline2,
        showBottomBorder: false,
        headingTextStyle: Theme.of(context)
            .textTheme
            .headline2!
            .copyWith(fontWeight: FontWeight.bold),
        headingRowColor: MaterialStateColor.resolveWith(
            (states) => Color.fromRGBO(50, 52, 67, 1)),
        dividerThickness: 5.0,
        border: TableBorder(
          horizontalInside: BorderSide(
            width: 2.0,
            color: Colors.white,
          ),
        ),
        columns: PBISPlusDataTableModal.PBISPlusDataTableHeadingRaw.map(
            (PBISPlusDataTableModal item) {
          return buildDataColumn(item);
        }).toList(),
        rows: List<DataRow>.generate(
            list.length, (index) => buildDataRow(index, list)),
      );

  DataColumn buildDataColumn(PBISPlusDataTableModal item) => DataColumn(
          label: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.iconData,
            color: item.color,
            size: 35,
          ),
          Padding(padding: EdgeInsets.only(top: 5)),
          Utility.textWidget(
            context: context,
            text: item.title,
            textTheme: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ));

  DataRow buildDataRow(int index, List<PBISPlusTotalInteractionModal> list) =>
      DataRow(
        color: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          return Theme.of(context).backgroundColor; // Use the default value.
        }),
        cells: [
          DataCell(Utility.textWidget(
            text:
                PBISPlusUtility.convertDateString(list[index].createdAt ?? ''),
            context: context,
            textAlign: TextAlign.center,
            textTheme: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          )),
          DataCell(Utility.textWidget(
            context: context,
            text: (list[index].engaged ?? 0).toString(),
            textAlign: TextAlign.center,
            textTheme: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          )),
          DataCell(Utility.textWidget(
            context: context,
            text: (list[index].niceWork ?? 0).toString(),
            textAlign: TextAlign.center,
            textTheme: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          )),
          DataCell(Utility.textWidget(
            context: context,
            text: (list[index].helpful ?? 0).toString(),
            textAlign: TextAlign.center,
            textTheme: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          )),
          DataCell(
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: EdgeInsets.only(left: 2),
              decoration: BoxDecoration(
                boxShadow: [],
                color: Color.fromRGBO(148, 148, 148, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Utility.textWidget(
                    context: context,
                    text: sumOfInteraction(
                      engaged: list[index].engaged ?? 0,
                      niceWork: list[index].niceWork ?? 0,
                      helpful: list[index].helpful ?? 0,
                    ),
                    textAlign: TextAlign.center,
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ],
      );

  String sumOfInteraction(
      {required int engaged, required int niceWork, required int helpful}) {
    int sum = engaged + niceWork + helpful;
    return sum.toString();
  }

  Widget floatingActionButton(
    BuildContext context,
  ) =>
      PBISPlusCustomFloatingActionButton(
        onPressed: () {
          _modalBottomSheetMenu();
        },
      );

  void _modalBottomSheetMenu() => showModalBottomSheet(
        useRootNavigator: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        // animationCurve: Curves.easeOutQuart,
        elevation: 10,
        context: context,
        builder: (BuildContext context) {
          return PBISPlusBottomSheet(
            googleClassroomCourseworkList: [], //No list is required since no list is used from this bottomsheet
            content: false,
            height: 100,
            title: '',
            padding: EdgeInsets.fromLTRB(30, 10, 10, 10),
          );
        },
      );
}
