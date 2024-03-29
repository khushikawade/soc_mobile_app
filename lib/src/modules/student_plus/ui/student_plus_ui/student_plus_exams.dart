// ignore_for_file: deprecated_member_use

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/modules/student_plus/bloc/student_plus_bloc.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_regents_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_graph_methods.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_bottomsheet.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_searchbar_and_dropdown_widget.dart';
import 'package:Soc/src/modules/student_plus/widgets/common_graph_widget.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_app_bar.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_utility.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentPlusExamsScreen extends StatefulWidget {
  final StudentPlusDetailsModel studentDetails;
  final String sectionType;

  const StudentPlusExamsScreen(
      {Key? key, required this.studentDetails, required this.sectionType})
      : super(key: key);

  @override
  State<StudentPlusExamsScreen> createState() => _StudentPlusExamsScreenState();
}

class _StudentPlusExamsScreenState extends State<StudentPlusExamsScreen> {
  static const double _kLabelSpacing = 20.0;
  // final _controller = TextEditingController();
  FocusNode myFocusNode = new FocusNode();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  StudentPlusBloc _studentPlusBloc = StudentPlusBloc();
  List<StudentRegentsModel>? shimmerList;
  @override
  void initState() {
    super.initState();
    generateShimmerData();
    if (checkIsRegents() || widget.studentDetails.gradeC == "8") {
      _studentPlusBloc.add(
          GetStudentRegentsList(studentId: widget.studentDetails.id ?? ''));
    }

    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        "student_plus_exams_screen");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'student_plus_exams_screen',
        screenClass: 'StudentPlusExamsScreen');
  }

  void generateShimmerData() {
    shimmerList = List.generate(5, (index) {
      return StudentRegentsModel(
        id: "${index + 1}",
        academicYearC: "${index + 1}",
        createdById: "${index + 1}",
        examC: "${index + 1}",
        lastModifiedById: "${index + 1}",
        osisC: "${index + 1}",
        ownerId: "${index + 1}",
        name: "${index + 1}",
        resultC: "${index + 1}",
        studentC: "${index + 1}",
        createdAt: "${index + 1}",
        updatedAt: "${index + 1}"
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CommonBackgroundImgWidget(),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: StudentPlusAppBar(
              sectionType: widget.sectionType,
              refresh: (v) {
                setState(() {});
              },
              titleIconCode: 0xe881),
          body: body()
          // Container()
          )
    ]);
  }

  Widget body() {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: StudentPlusOverrides.kSymmetricPadding),
        child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpacerWidget(StudentPlusOverrides.KVerticalSpace / 4),
              PlusScreenTitleWidget(
                  kLabelSpacing: _kLabelSpacing,
                  text: StudentPlusOverrides.studentPlusExamsTitle),
              SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
              widget.sectionType == "Student"
                  ? Container()
                  : StudentPlusSearchBarAndDropdown(
                      index: 1,
                      sectionType: widget.sectionType,
                      studentDetails: widget.studentDetails),
              //tabWidget(),
              if (checkIsRegents()) ...[
                regentsTitleWidget(),
                SpacerWidget(_kLabelSpacing / 2),
                regentsHeaderTitle(), // widget to show header of list
                SpacerWidget(StudentPlusOverrides.kSymmetricPadding / 2),
                blocRegentsBuilder()
              ] else
                // Container()
                tabWidget()
            ]));
  }

  /* ------------------------------ bloc builder for Regents details ------------------------------ */
  Widget blocRegentsBuilder() {
    return BlocBuilder(
        bloc: _studentPlusBloc,
        builder: (context, state) {
          if (state is StudentPlusRegentsLoading) {
            return Container(
              height: widget.sectionType == 'Student'
                  ? widget.studentDetails.gradeC == "8"
                      ? MediaQuery.of(context).size.height * 0.53
                      : MediaQuery.of(context).size.height * 0.58
                  : widget.studentDetails.gradeC == "8"
                      ? MediaQuery.of(context).size.height * 0.46
                      : MediaQuery.of(context).size.height * 0.5,
              child: ShimmerLoading(
                  isLoading: true,
                  child:
                      regentsListWidget(list: shimmerList!, isLoading: true)),
            );
          } else if (state is StudentPlusRegentsSuccess) {
            return Container(
                //Added condition to manage height according to search bar in Students section //Families and Staff section height is same
                height: widget.sectionType == 'Student'
                    ? widget.studentDetails.gradeC == "8"
                        ? MediaQuery.of(context).size.height * 0.53
                        : MediaQuery.of(context).size.height * 0.58
                    : widget.studentDetails.gradeC == "8"
                        ? MediaQuery.of(context).size.height * 0.46
                        : MediaQuery.of(context).size.height * 0.5,
                child: regentsListWidget(list: state.obj, isLoading: false));
          } else {
            return Container();
          }
        });
  }

  /* ---------- Widget to show vertical list of Regents list ---------- */
  Widget regentsListWidget(
      {required List<StudentRegentsModel> list, required bool isLoading}) {
    return list.length > 0
        ? RefreshIndicator(
            key: refreshKey,
            onRefresh: refreshPage,
            child: ListView.builder(
                //  physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: 25, left: 10, right: 10),
                scrollDirection: Axis.vertical,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildListTile(
                      index: index,
                      studentPlusGradeModel: list[index],
                      isLoading: isLoading);
                }))
        : RefreshIndicator(
            key: refreshKey,
            onRefresh: refreshPage,
            child: ListView(children: [Container()]));
  }

  /* ------------------ Widget to show marking period header ------------------ */
  Widget regentsTitleWidget() {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: _kLabelSpacing / 2, vertical: _kLabelSpacing / 2),
        width: MediaQuery.of(context).size.width,
        child: Utility.textWidget(
            context: context,
            text: 'Regents',
            textTheme: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(fontWeight: FontWeight.bold)));
  }

  /* ------------------- widget to show title of regents list ------------------ */
  Widget regentsHeaderTitle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            height: 50.0,
            margin: const EdgeInsets.only(bottom: 6.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Theme.of(context).backgroundColor == Color(0xff000000)
                    ? Color(0xff162429)
                    : Color(0xffF7F8F9),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                      offset: Offset(0.0, 1.0),
                      blurRadius: 6.0)
                ]),
            child: Container(
                child: ListTile(
              leading: Utility.textWidget(
                  text: "Exam",
                  context: context,
                  textTheme: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontWeight: FontWeight.bold)),
              trailing: Utility.textWidget(
                  text: "Score",
                  context: context,
                  textTheme: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontWeight: FontWeight.bold)),
            )),
          ),
        ),
      ),
    );
  }

  Widget tabWidget() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: DefaultTabController(
            length: widget.studentDetails.gradeC == "8" ? 3 : 2,
            child: ListView(shrinkWrap: true, children: [
              TabBar(
                  onTap: (i) {
                    print(i);
                    if (i == 0) {
                      PlusUtility.updateLogs(
                          activityType: 'STUDENT+',
                          userType: 'Teacher',
                          activityId: '50',
                          description: 'Student+ MATH Screen',
                          operationResult: 'Success');
                    }
                    if (i == 1) {
                      PlusUtility.updateLogs(
                          activityType: 'STUDENT+',
                          userType: 'Teacher',
                          activityId: '51',
                          description: 'Student+ ELA Screen',
                          operationResult: 'Success');
                    }
                  },
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Theme.of(context)
                      .colorScheme
                      .primaryVariant, //should be : Theme.of(context).colorScheme.primary,
                  indicatorColor: AppTheme.kButtonColor,
                  unselectedLabelColor:
                      Globals.themeType == "Dark" ? Colors.grey : Colors.black,
                  unselectedLabelStyle: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.primaryVariant,
                  ),
                  labelStyle: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primaryVariant,
                  ),
                  tabs: [
                    Tab(text: "MATH"),
                    Tab(text: "ELA"),
                    if (widget.studentDetails.gradeC == "8")
                      Tab(text: "REGENTS")
                  ]),
              Container(
                  height: Globals.deviceType == "phone" &&
                          MediaQuery.of(context).orientation ==
                              Orientation.portrait
                      ? (widget.sectionType == "Student"
                          ? MediaQuery.of(context).size.height * 0.7
                          : MediaQuery.of(context).size.height * 0.57) //61
                      : Globals.deviceType == "phone" &&
                              MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                          ? MediaQuery.of(context).size.height * 0.65
                          : MediaQuery.of(context).size.height * 0.75,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.grey, width: 0.5))),
                  child: TabBarView(children: <Widget>[
                    Tab(child: tabScreenWidget(isMathSection: true)),
                    Tab(child: tabScreenWidget(isMathSection: false)),
                    //--------------------------------------------------------------------------
                    if (widget.studentDetails.gradeC == "8")
                      Tab(
                          child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                            // regentsTitleWidget(),
                            SpacerWidget(_kLabelSpacing / 2),
                            regentsHeaderTitle(), // widget to show header of list
                            SpacerWidget(
                                StudentPlusOverrides.kSymmetricPadding / 2),
                            blocRegentsBuilder()
                          ]))
                    //--------------------------------------------------------------------------
                  ]))
            ])));
  }

  /* -------------- Widget return exam tab view for ELA and MATH ------------- */
  Widget tabScreenWidget({required bool isMathSection}) {
    return ListView(
      shrinkWrap: true,
      children: [
        SpacerWidget(_kLabelSpacing),
        nysWidget(isMathSection),
        SpacerWidget(10),
        gradeLevelWidget(isMathSection),
        SpacerWidget(_kLabelSpacing),
        mapLevelWidget(isMathSection)
      ],
    );
  }

  Widget nysWidget(isMathSection) {
    return Column(children: [
      Center(
          child: Utility.textWidget(
              text: 'NYS',
              context: context,
              textTheme: Theme.of(context).textTheme.headline5)),
      SizedBox(
        height: _kLabelSpacing / 2,
      ),
      /* -------------------------- NYS graph widget card ------------------------- */
      nysGraphWidget(isMathSection: isMathSection),
      SpacerWidget(_kLabelSpacing * 2),
      Container(
          height: 2,
          color: StudentPlusUtility.oppositeBackgroundColor(context: context)),
      SpacerWidget(_kLabelSpacing),
      Center(
          child: Utility.textWidget(
              text: 'iReady Grade-Level',
              context: context,
              textTheme: Theme.of(context).textTheme.headline5)),
      SpacerWidget(_kLabelSpacing),
      SchoolYearTitleWidget()
    ]);
  }

  Widget gradeLevelWidget(isMathSection) {
    return Column(children: [
      GradeLevelWidget(
          isMathsSection: isMathSection,
          isMapSection: false,
          graphType: 'iready'),
      SpacerWidget(_kLabelSpacing),
      Row(children: [
        HeadingWidget(isInfoIcon: true, title: 'iReady Percentile'),
        IconButton(
            padding: EdgeInsets.only(top: 2),
            onPressed: () {
              FirebaseAnalyticsService.addCustomAnalyticsEvent(
                  'iReady Percentile info STUDENT+'
                      .toLowerCase()
                      .replaceAll(" ", "_"));

              StudentPlusCommonBottomSheet.showBottomSheet(
                  title: 'iReady Percentile',
                  kLabelSpacing: _kLabelSpacing,
                  context: context,
                  text: StudentPlusOverrides.examScreenPopupText);
            },
            icon: Icon(Icons.info,
                size: Globals.deviceType == 'tablet' ? 35 : null,
                color: Color(0xff000000) != Theme.of(context).backgroundColor
                    ? Color(0xff111C20)
                    : Color(0xffF7F8F9) //Colors.grey.shade400,
                ))
      ]),
      percentileGraphWidget(isMathsSection: isMathSection, graphType: 'iready'),
      SpacerWidget(_kLabelSpacing * 2)
    ]);
  }

  Widget mapLevelWidget(isMathSection) {
    return Column(children: [
      Container(
          height: 2,
          color: StudentPlusUtility.oppositeBackgroundColor(context: context)),
           SpacerWidget(_kLabelSpacing),
      Center(
          child: Utility.textWidget(
              text: 'MAP Grade-Level',
              context: context,
              textTheme: Theme.of(context).textTheme.headline5)),
      SpacerWidget(_kLabelSpacing),
      SchoolYearTitleWidget(),
      SpacerWidget(10),
      GradeLevelWidget(
          isMathsSection: isMathSection, isMapSection: true, graphType: 'map'),
      SpacerWidget(_kLabelSpacing),
      Row(children: [
        HeadingWidget(isInfoIcon: true, title: 'MAP Percentile'),
        IconButton(
            padding: EdgeInsets.only(top: 2),
            onPressed: () {
              FirebaseAnalyticsService.addCustomAnalyticsEvent(
                  'MAP Percentile info STUDENT+'
                      .toLowerCase()
                      .replaceAll(" ", "_"));

              StudentPlusCommonBottomSheet.showBottomSheet(
                  title: 'MAP Percentile',
                  kLabelSpacing: _kLabelSpacing,
                  context: context,
                  text: StudentPlusOverrides.examScreenPopupText);
            },
            icon: Icon(Icons.info,
                size: Globals.deviceType == 'tablet' ? 35 : null,
                color: Color(0xff000000) != Theme.of(context).backgroundColor
                    ? Color(0xff111C20)
                    : Color(0xffF7F8F9) //Colors.grey.shade400,
                ))
      ]),
      percentileGraphWidget(isMathsSection: isMathSection, graphType: 'map'),
      SpacerWidget(_kLabelSpacing * 2)
    ]);
  }

  Widget nysGraphWidget({required bool isMathSection}) {
    return Card(
      color: Color(0xff000000) != Theme.of(context).backgroundColor
          ? Color(0xffF7F8F9)
          : Color.fromARGB(255, 12, 20, 23),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      elevation: 10.0,
      shadowColor: Theme.of(context).backgroundColor,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 40, bottom: 20, top: 0),
        height: MediaQuery.of(context).size.height * 0.55,
        child: CommonLineGraphWidget(
          graphType: 'nys',
          isMathsSection: isMathSection,
          studentDetails: widget.studentDetails,
        ),
      ),
    );
  }

  Widget percentileGraphWidget(
      {required bool isMathsSection, required String graphType}) {
    return Card(
      color: Color(0xff000000) != Theme.of(context).backgroundColor
          ? Color(0xffF7F8F9)
          : Color.fromARGB(255, 12, 20, 23),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 10.0,
      shadowColor: Color(0xff000000) != Theme.of(context).backgroundColor
          ? Colors.white
          : Colors.black,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 30, bottom: 20, top: 30),
        height: MediaQuery.of(context).size.height * 0.40, //0.40
        width: MediaQuery.of(context).size.width * 0.9,
        child: CommonLineGraphWidget(
          graphType: graphType,
          studentDetails: widget.studentDetails,
          isMathsSection: isMathsSection,
        ),
      ),
    );
  }

  Widget SchoolYearTitleWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Utility.textWidget(
              text: 'Previous \nSchool Year',
              context: context,
              textTheme: Theme.of(context).textTheme.headline4),
          Container(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.04),
            child: Utility.textWidget(
                text: 'Current School Year',
                context: context,
                textTheme: Theme.of(context).textTheme.headline4),
          ),
        ],
      ),
    );
  }

  Widget GradeLevelWidget(
      {required bool isMathsSection,
      required bool isMapSection,
      required String graphType}) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: Theme.of(context).colorScheme.secondary,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            child: Container(
                alignment: Alignment.centerLeft,
                child: circularSchoolYearWidget(
                    graphType: graphType,
                    isPreviousYear: true,
                    isMathSection: isMathsSection,
                    centreText: isMathsSection
                        ? (isMapSection
                            ? widget.studentDetails.MAPmathPreviousSyEOY ?? 'NA'
                            : widget.studentDetails.mathPreviousSyEOY ?? 'NA')
                        : (isMapSection
                            ? widget.studentDetails.MAPELAPreviousSyEOY ?? 'NA'
                            : widget.studentDetails.ELAPreviousSyEOY ?? 'NA'),
                    subTitle: 'EOY')),
          ),
          Container(
              child: Container(
                  alignment: Alignment.centerRight,
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    circularSchoolYearWidget(
                        graphType: graphType,
                        isPreviousYear: false,
                        isMathSection: isMathsSection,
                        centreText: isMathsSection
                            ? (isMapSection
                                ? widget.studentDetails.MAPmathCurrentSyBOY ??
                                    'NA'
                                : widget.studentDetails.mathCurrentSyBOY ??
                                    'NA')
                            : (isMapSection
                                ? widget.studentDetails.MAPELACurrentSyBOY ??
                                    'NA'
                                : widget.studentDetails.ELACurrentSyBOY ??
                                    'NA'),
                        subTitle: 'BOY'),
                    SizedBox(
                      width: 7,
                    ),
                    circularSchoolYearWidget(
                        graphType: graphType,
                        isPreviousYear: false,
                        isMathSection: isMathsSection,
                        centreText: isMathsSection
                            ? (isMapSection
                                ? widget.studentDetails.MAPmathCurrentSyMOY ??
                                    'NA'
                                : widget.studentDetails.mathCurrentSyMOY ??
                                    'NA')
                            : (isMapSection
                                ? widget.studentDetails.MAPELACurrentSyMOY ??
                                    'NA'
                                : widget.studentDetails.ELACurrentSyMOY ??
                                    'NA'),
                        subTitle: 'MOY'),
                    SizedBox(
                      width: 7,
                    ),
                    circularSchoolYearWidget(
                        graphType: graphType,
                        isPreviousYear: false,
                        isMathSection: isMathsSection,
                        centreText: isMathsSection
                            ? (isMapSection
                                ? widget.studentDetails.MAPmathCurrentSyEOY ??
                                    'NA'
                                : widget.studentDetails.mathCurrentSyEOY ??
                                    'NA')
                            : (isMapSection
                                ? widget.studentDetails.MAPELACurrentSyEOY ??
                                    'NA'
                                : widget.studentDetails.ELACurrentSyEOY ??
                                    'NA'),
                        subTitle: 'EOY')
                  ])))
        ]));
  }

  Widget HeadingWidget({required String title, required bool isInfoIcon}) {
    return Container(
        padding: EdgeInsets.only(left: 20),
        child: Utility.textWidget(
            text: title,
            context: context,
            textTheme: Theme.of(context).textTheme.headline5));
  }

  Widget circularSchoolYearWidget(
      {required String centreText,
      required String graphType,
      required String subTitle,
      required bool isMathSection,
      required bool isPreviousYear}) {
    return Column(
      children: [
        SpacerWidget(10),
        CircleAvatar(
            backgroundColor: graphType == 'map'
                ? StudentPlusGraphMethod.mapTooltipColor(value: centreText)
                : StudentPlusGraphMethod.iReadyTooltipColor(
                    type: subTitle,
                    value: StudentPlusGraphMethod.iReadyColorValue(
                        isMathsSection: isMathSection,
                        studentInfo: widget.studentDetails,
                        x: subTitle == 'BOY'
                            ? 1.0
                            : (subTitle == 'MOY'
                                ? 2.0
                                : (isPreviousYear == true ? 0.0 : 3.0)))),
            // Color(0xff000000) != Theme.of(context).backgroundColor
            //     ? Color(0xff111C20)
            //     : Color(0xffF7F8F9),
            radius: MediaQuery.of(context).size.width * 0.07,
            child: Container(
                width: MediaQuery.of(context).size.width * 0.12,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Center(
                    child: FittedBox(
                  fit: BoxFit.cover,
                  child: Utility.textWidget(
                      text: centreText.split(' ').length > 1
                          ? "${centreText.split(' ')[0]} \n ${centreText.split(' ')[1]}"
                          : centreText.toLowerCase() == 'below'
                              ? StudentPlusUtility.convertToSentenceCase(
                                  centreText)
                              : centreText,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      context: context,
                      textTheme: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.black)),
                )))),
        SpacerWidget(10),
        Text(subTitle,
            //  context: context,
            style: Theme.of(context).textTheme.headline4)
      ],
    );
  }

  /* ---------- Widget to show list tile (to show Regents) ---------- */
  Widget _buildListTile(
      {required StudentRegentsModel studentPlusGradeModel,
      required int index,
      required bool isLoading}) {
    return Container(
        height: 54,
        margin: isLoading ? EdgeInsets.symmetric(vertical: 5) : EdgeInsets.zero,
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0.0),
            color: (index % 2 == 0)
                ? Theme.of(context).colorScheme.background == Color(0xff000000)
                    ? AppTheme.klistTilePrimaryDark
                    : AppTheme
                        .klistTilePrimaryLight //Theme.of(context).colorScheme.background
                : Theme.of(context).colorScheme.background == Color(0xff000000)
                    ? AppTheme.klistTileSecoandryDark
                    : AppTheme
                        .klistTileSecoandryLight //Theme.of(context).colorScheme.secondary,
            ),
        child: ListTile(
            leading: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Utility.textWidget(
                    text: studentPlusGradeModel.examC ?? '-',
                    maxLines: 2,
                    context: context,
                    textTheme: Theme.of(context).textTheme.headline2!)),
            trailing: Container(
                padding: EdgeInsets.symmetric(
                    vertical: _kLabelSpacing / 4,
                    horizontal: _kLabelSpacing / 2),
                decoration: BoxDecoration(
                    color: StudentPlusUtility.getRegentsColors(
                        studentPlusGradeModel.resultC ?? "0"),
                    borderRadius: BorderRadius.circular(20.0)),
                child: Utility.textWidget(
                    text: studentPlusGradeModel.resultC != null &&
                                studentPlusGradeModel.resultC!.toLowerCase() ==
                                    'waiver' ||
                            studentPlusGradeModel.resultC!.toLowerCase() == 'w'
                        ? "W"
                        : studentPlusGradeModel.resultC ?? '-',
                    context: context,
                    textTheme: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black)))));
  }

  /* ------------------------- function call when pull to refresh perform ------------------------- */
  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    if (checkIsRegents() || widget.studentDetails.gradeC == "8") {
      _studentPlusBloc.add(
          GetStudentRegentsList(studentId: widget.studentDetails.id ?? ''));
    }
  }

  bool checkIsRegents() {
    if (widget.studentDetails.gradeC == "9" ||
        widget.studentDetails.gradeC == "10" ||
        widget.studentDetails.gradeC == "11" ||
        widget.studentDetails.gradeC == "12") {
      return true;
    } else {
      return false;
    }
  }
}
