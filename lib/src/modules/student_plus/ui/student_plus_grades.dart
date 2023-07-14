import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/modules/student_plus/bloc/student_plus_bloc.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_course_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_grades_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/modules/student_plus/ui/student_plus_grades_details.dart';
import 'package:Soc/src/modules/student_plus/ui/student_plus_search_page.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_app_bar.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_app_search_bar.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_family_student_list.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bouncing_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class StudentPlusGradesPage extends StatefulWidget {
  final StudentPlusDetailsModel studentDetails;
  final String sectionType;
  const StudentPlusGradesPage(
      {Key? key, required this.studentDetails, required this.sectionType})
      : super(key: key);

  @override
  State<StudentPlusGradesPage> createState() => individual();
}

class individual extends State<StudentPlusGradesPage> {
  static const double _kLabelSpacing = 20.0;
  FocusNode myFocusNode = new FocusNode();
  final _controller = TextEditingController(); // textController for search
  final ValueNotifier<String> selectedValue = ValueNotifier<String>('');
  final StudentPlusBloc _studentPlusBloc = StudentPlusBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _studentPlusBloc.add(widget.sectionType == 'Staff' ||
            widget.sectionType == 'Family'
        ? FetchStudentGradesEvent(studentId: widget.studentDetails.studentIdC)
        : FetchStudentGradesWithClassroomEvent(
            studentId: widget.studentDetails.studentIdC));
    // : FetchStudentGradesEvent(studentId: widget.studentDetails.studentIdC));
    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        "student_plus_grades_screen");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'student_plus_grades_screen',
        screenClass: 'StudentPlusGradesPage');

    PlusUtility.updateLogs(
        activityType: 'STUDENT+',
        userType: 'Teacher',
        activityId: '53',
        description: 'Student+ Grades Screen',
        operationResult: 'Success');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: StudentPlusAppBar(
             sectionType:widget.sectionType,
            titleIconCode: 0xe823,
            refresh: (v) {
              setState(() {});
            },
          ),
          body: Container(
            padding: EdgeInsets.symmetric(
                horizontal: StudentPlusOverrides.kSymmetricPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpacerWidget(StudentPlusOverrides.KVerticalSpace / 4),
                // SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
                PlusScreenTitleWidget(
                    kLabelSpacing: _kLabelSpacing,
                    text: StudentPlusOverrides.studentGradesPageTitle),
                SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
                widget.sectionType == "Student"
                    ? Container()
                    : PlusAppSearchBar(
                        sectionName: 'STUDENT+',
                        hintText:
                            '${widget.studentDetails.firstNameC ?? ''} ${widget.studentDetails.lastNameC ?? ''}',
                        onTap: () async {
                          if (widget.sectionType == "Family") {
                            showModalBottomSheet(
                              useRootNavigator: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(42),
                                  topRight: Radius.circular(42),
                                ),
                              ),
                              builder: (_) => LayoutBuilder(builder:
                                  (BuildContext context,
                                      BoxConstraints constraints) {
                                return StudentPlusFamilyStudentList(
                                  height: MediaQuery.of(context).size.height *
                                      0.4, //0.45,
                                  currentIndex: 3,
                                );
                              }),
                            );
                          } else {
                            var result = await pushNewScreen(context,
                                screen: StudentPlusSearchScreen(
                                    fromStudentPlusDetailPage: true,
                                    index: 3,
                                    studentDetails: widget.studentDetails),
                                withNavBar: false,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.fade);
                            if (result == true) {
                              Utility.closeKeyboard(context);
                            }
                          }
                        },
                        isMainPage: false,
                        autoFocus: false,
                        controller: _controller,
                        kLabelSpacing: _kLabelSpacing,
                        focusNode: myFocusNode,
                        onItemChanged: null,
                      ),

                //       GradesWidget()
                BlocConsumer<StudentPlusBloc, StudentPlusState>(
                  bloc: _studentPlusBloc,
                  listener: (context, state) {
                    if (state is StudentPlusGradeSuccess) {
                      if (state.chipList.length > 0) {
                        selectedValue.value = state.chipList[0];
                      }
                    }
                  },
                  builder: (BuildContext contxt, StudentPlusState state) {
                    if (state is StudentPlusLoading) {
                      return Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator.adaptive(
                            backgroundColor: AppTheme.kButtonColor,
                          ));
                    } else if (state is StudentPlusGradeSuccess) {
                      return
                          // state.obj.length > 0 || state.courseList.length > 0
                          //     ?
                          GradesWidget(
                              chipList: state.chipList,
                              obj: state.obj,
                              courseList: state.courseList);
                      // : Expanded(
                      //     child: NoDataFoundErrorWidget(
                      //       errorMessage:
                      //           StudentPlusOverrides.gradesErrorMessage,
                      //       //  marginTop: 0,
                      //       isResultNotFoundMsg: false,
                      //       isNews: false,
                      //       isEvents: false,
                      //       isSearchpage: true,
                      //     ),
                      //   );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget GradesWidget({
    required List<StudentPlusGradeModel> obj,
    required List<String> chipList,
    required List<StudentPlusCourseModel> courseList,
  }) {
    return ValueListenableBuilder(
      valueListenable: selectedValue,
      builder: (context, value, child) {
        return Container(
          height: widget.sectionType == "Student"
              ? MediaQuery.of(context).size.height * 0.75
              : MediaQuery.of(context).size.height * 0.62,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //SpacerWidget(StudentPlusOverrides.kSymmetricPadding / 2),
              markingPeriodHeader(),
              gradesChipListWidget(
                  chipList: chipList), // widget to grades chip List
              SpacerWidget(StudentPlusOverrides.kSymmetricPadding / 2),

              SpacerWidget(_kLabelSpacing / 2),
              HeaderTitle(), // widget to show header of list
              SpacerWidget(StudentPlusOverrides.kSymmetricPadding / 2),
              Container(
                height: widget.sectionType == "Student"
                    ? MediaQuery.of(context).size.height * 0.56
                    : MediaQuery.of(context).size.height * 0.42,
                child:
                    gradesListSectionWidget(list: obj, courseList: courseList),
              ) // widget to show grades class wise
            ],
          ),
        );
      },
    );
  }

  /* ------------------ Widget to show marking period header ------------------ */
  Widget markingPeriodHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: _kLabelSpacing / 2, vertical: _kLabelSpacing / 2),
      width: MediaQuery.of(context).size.width,
      child: Utility.textWidget(
          context: context,
          text: 'Marking Period',
          textTheme: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(fontWeight: FontWeight.bold)),
    );
  }

  /* ------------------ Widget to show grades horizontal list ------------------ */
  Widget gradesChipListWidget({required List<String> chipList}) {
    return Container(
      height: _kLabelSpacing * 1.8,
      padding: EdgeInsets.symmetric(horizontal: _kLabelSpacing / 2),
      child: ListView.builder(
        controller: null,
        itemBuilder: (BuildContext context, int index) {
          return gradesChip(chipValue: chipList[index]);
        },
        itemCount: chipList.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  /* ---------------- Widget to show individual chips of grades ---------------- */
  Widget gradesChip({required String chipValue}) {
    return GestureDetector(
      onTap: () {
        selectedValue.value = chipValue;
      },
      child: Bouncing(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.16,
          //padding: EdgeInsets.symmetric(horizontal: 20),
          margin: EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
            boxShadow: [],
            color: //Colors.transparent,
                Color(0xff000000) != Theme.of(context).backgroundColor
                    ? Color(0xffF7F8F9)
                    : Color(0xff111C20),
            border: Border.all(
                color: selectedValue.value == chipValue
                    ? AppTheme.kSelectedColor
                    : Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
              child: FittedBox(
            child: Utility.textWidget(
                text: chipValue == '1'
                    ? '1st'
                    : chipValue == '2'
                        ? '2st'
                        : chipValue == '3'
                            ? '3st'
                            : chipValue == '4'
                                ? '4st'
                                : chipValue,
                context: context,
                textTheme: Theme.of(context).textTheme.headline4),
          )),
        ),
      ),
    );
  }

  /* ---------- Widget to show vertical list of class and grade list ---------- */
  Widget gradesListSectionWidget(
      {required List<StudentPlusGradeModel> list,
      required List<StudentPlusCourseModel> courseList}) {
    List<StudentPlusGradeModel> updatedList = [];
    for (var i = 0; i < list.length; i++) {
      if (list[i].markingPeriodC == selectedValue.value) {
        //selectedValue.value
        updatedList.add(list[i]);
      }
    }
    return updatedList.length > 0 || courseList.length > 0
        ? RefreshIndicator(
            key: refreshKey,
            onRefresh: refreshPage,
            child: ListView.builder(
              //shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 25, left: 10, right: 10),
              scrollDirection: Axis.vertical,
              itemCount: selectedValue.value == "Current"
                  ? courseList.length
                  : updatedList.length,
              itemBuilder: (BuildContext context, int index) {
                return selectedValue.value == "Current"
                    ? _buildCurrentList(
                        index: index, studentPlusCourseModel: courseList[index])
                    : _buildList(
                        index: index,
                        studentPlusGradeModel: updatedList[index]);
              },
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.height * 0.1,
            child: RefreshIndicator(
              key: refreshKey,
              onRefresh: refreshPage,
              child: NoDataFoundErrorWidget(
                marginTop: MediaQuery.of(context).size.height * 0.1,
                errorMessage: StudentPlusOverrides.gradesErrorMessage,
                isResultNotFoundMsg: false,
                isNews: false,
                isEvents: false,
                isSearchpage: true,
              ),
            ),
          );
  }

  /* ----------------------------- widget used to build current widget ---------------------------- */

  Widget _buildCurrentList(
      {required int index,
      required StudentPlusCourseModel studentPlusCourseModel}) {
    return Container(
      // height: 54,
      padding: EdgeInsets.symmetric(
        horizontal: 5,
      ),
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
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StudentPlusGradesDetailPage(
                     sectionType:widget.sectionType,
                        studentPlusCourseModel: studentPlusCourseModel,
                      )));
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 5),
        minLeadingWidth: 0,
        title: Utility.textWidget(
            text: studentPlusCourseModel.name ?? '',
            context: context,
            textTheme: Theme.of(context).textTheme.headline2),
        subtitle: Utility.textWidget(
            text: studentPlusCourseModel.section == null ||
                    studentPlusCourseModel.room == null
                ? "${Utility.convertDateUSFormat(studentPlusCourseModel.updateTime.toString())}"
                : "${Utility.convertDateUSFormat(studentPlusCourseModel.updateTime.toString()) ?? ''} | ${studentPlusCourseModel.section} | ${studentPlusCourseModel.room}",
            context: context,
            textTheme: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Colors.grey)),
      ),
    );
  }

  /* ---------- Widget to show list tile (to show individual grades) ---------- */
  Widget _buildList(
      {required StudentPlusGradeModel studentPlusGradeModel,
      required int index}) {
    return Container(
      height: 54,
      padding: EdgeInsets.symmetric(
        horizontal: 5,
      ),
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
              text: studentPlusGradeModel.schoolSubjectC ?? '-',
              maxLines: 2,
              context: context,
              textTheme: Theme.of(context).textTheme.headline2!),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(
              vertical: _kLabelSpacing / 4, horizontal: _kLabelSpacing / 2),
          decoration: BoxDecoration(
            color: AppTheme.kButtonColor,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Utility.textWidget(
              text: studentPlusGradeModel.resultC ?? '-',
              context: context,
              textTheme: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
        ),
      ),
    );
  }

  /* ------------------- widget to show title of grades list ------------------ */
  Widget HeaderTitle() {
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
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Container(
                child: ListTile(
              leading: Utility.textWidget(
                  text: selectedValue.value == "Current"
                      ? "Course"
                      : StudentPlusOverrides.gradesTitleLeft,
                  context: context,
                  textTheme: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontWeight: FontWeight.bold)),
              trailing: Utility.textWidget(
                  text: selectedValue.value == "Current"
                      ? "Average"
                      : StudentPlusOverrides.gradesTitleRight,
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

  /* ------------------------- function call when pull to refresh perform ------------------------- */
  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    _studentPlusBloc.add(widget.sectionType == 'Staff' ||
            widget.sectionType == 'Family'
        ? FetchStudentGradesEvent(studentId: widget.studentDetails.studentIdC)
        : FetchStudentGradesWithClassroomEvent(
            studentId: widget.studentDetails.studentIdC));
  }
}
