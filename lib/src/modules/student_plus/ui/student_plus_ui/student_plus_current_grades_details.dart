// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/student_plus/bloc/student_plus_bloc.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_course_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_course_work_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_utility.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_app_bar.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentPlusGradesDetailPage extends StatefulWidget {
  final StudentPlusCourseModel studentPlusCourseModel;
  final String sectionType;
  const StudentPlusGradesDetailPage(
      {Key? key,
      required this.studentPlusCourseModel,
      required this.sectionType})
      : super(key: key);

  @override
  State<StudentPlusGradesDetailPage> createState() =>
      _StudentPlusGradesDetailPageState();
}

class _StudentPlusGradesDetailPageState
    extends State<StudentPlusGradesDetailPage> {
  final StudentPlusBloc _studentPlusBloc = StudentPlusBloc();
  static const double _kLabelSpacing = 20.0;
  ScrollController _scrollController = ScrollController();
  List<StudentPlusCourseWorkModel> paginationList = [];
  String? nextPageToken = '';

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_scrollListener);
    _studentPlusBloc.add(FetchStudentCourseWorkEvent(
        studentUserId: widget.studentPlusCourseModel.studentUserId,
        courseWorkId: widget.studentPlusCourseModel.id ?? ''));
    // TODO: implement initState
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
            sectionType: widget.sectionType,
            titleIconCode: 0xe883,
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
                PlusScreenTitleWidget(
                    kLabelSpacing: _kLabelSpacing,
                    text: widget.studentPlusCourseModel.name ?? '',
                    backButton: true),
                SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
                HeaderTitle(),
                gradesListSectionWidget()
              ],
            ),
          ),
        ),
      ],
    );
  }

  /* ---------- Widget to show vertical list of class and grade list ---------- */
  Widget gradesListSectionWidget() {
    return BlocBuilder<StudentPlusBloc, StudentPlusState>(
      bloc: _studentPlusBloc,
      builder: (context, state) {
        if (state is StudentPlusLoading) {
          return Center(
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Center(
                      child: CircularProgressIndicator.adaptive(
                    backgroundColor: AppTheme.kButtonColor,
                  ))));
        } else if (state is StudentPlusCourseWorkSuccess) {
          if (state.obj.length > 0) {
            paginationList = [];
            paginationList.addAll(state.obj);
            nextPageToken = state.nextPageToken == ''
                ? null
                : state.nextPageToken; // null define no next page
          }
          return paginationList.length > 0
              ? Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 25, left: 10, right: 10),
                    scrollDirection: Axis.vertical,
                    itemCount: paginationList.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildCurrentList(
                        studentPlusCourseWorkModel:
                            paginationList.length == index
                                ? StudentPlusCourseWorkModel()
                                : paginationList[index],
                        index: index,
                      );
                    },
                  ),
                )
              : Expanded(
                  child: NoDataFoundErrorWidget(
                    errorMessage: StudentPlusOverrides.gradesErrorMessage,
                    //  marginTop: 0,
                    isResultNotFoundMsg: false,
                    isNews: false,
                    isEvents: false,
                    isSearchpage: true,
                  ),
                );
        } else {
          return SizedBox();
        }
      },
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
                  text: "Assignment",
                  context: context,
                  textTheme: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontWeight: FontWeight.bold)),
              trailing: Utility.textWidget(
                  text: "Marks",
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

  Widget _buildCurrentList(
      {required int index,
      required StudentPlusCourseWorkModel studentPlusCourseWorkModel}) {
    return paginationList.length == index
        ? Container(
            padding: EdgeInsets.only(top: 15),
            child: nextPageToken == null
                ? StudentPlusUtility.allCaughtUp(context: context)
                : Center(
                    child: Platform.isIOS
                        ? CupertinoActivityIndicator(
                            color: Theme.of(context).primaryColor,
                          )
                        : Container(
                            margin: EdgeInsets.only(bottom: 15),
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator.adaptive(
                              strokeWidth: 3,
                              backgroundColor: AppTheme.kButtonColor,
                            ),
                          ),
                  ))
        : Container(
            // height: 54,
            padding: EdgeInsets.symmetric(
              horizontal: 5,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0.0),
                color: (index % 2 == 0)
                    ? Theme.of(context).colorScheme.background ==
                            Color(0xff000000)
                        ? AppTheme.klistTilePrimaryDark
                        : AppTheme
                            .klistTilePrimaryLight //Theme.of(context).colorScheme.background
                    : Theme.of(context).colorScheme.background ==
                            Color(0xff000000)
                        ? AppTheme.klistTileSecoandryDark
                        : AppTheme
                            .klistTileSecoandryLight //Theme.of(context).colorScheme.secondary,
                ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5),
              minLeadingWidth: 0,
              title: Utility.textWidget(
                  text: studentPlusCourseWorkModel.title ?? '',
                  context: context,
                  textTheme: Theme.of(context).textTheme.headline2),
              subtitle: Utility.textWidget(
                  text: studentPlusCourseWorkModel.studentWorkSubmission !=
                              null &&
                          studentPlusCourseWorkModel
                                  .studentWorkSubmission!.length >
                              0 &&
                          studentPlusCourseWorkModel
                                  .studentWorkSubmission![0].assignedGrade !=
                              null
                      ? "${Utility.convertDateUSFormat(studentPlusCourseWorkModel.updateTime.toString())} || Graded"
                      : "${Utility.convertDateUSFormat(studentPlusCourseWorkModel.updateTime.toString())} || Assigned",
                  context: context,
                  textTheme: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Colors.grey)),
              trailing: Container(
                child: Utility.textWidget(
                    text: studentPlusCourseWorkModel
                                    .studentWorkSubmission !=
                                null &&
                            studentPlusCourseWorkModel
                                    .studentWorkSubmission!.length >
                                0 &&
                            studentPlusCourseWorkModel
                                    .studentWorkSubmission![0].assignedGrade !=
                                null
                        ? '${studentPlusCourseWorkModel.studentWorkSubmission![0].assignedGrade}/${studentPlusCourseWorkModel.maxPoints}'
                        : '-/${studentPlusCourseWorkModel.maxPoints}',
                    context: context,
                    textTheme: Theme.of(context).textTheme.headline2!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.kButtonColor)),
              ),
            ),
          );
  }

/* ---------- 'localDb' use to manage pagination in case to data showing from local db ---------- */
  _scrollListener() {
    if (_scrollController.position.atEdge &&
        nextPageToken != '' &&
        nextPageToken != null &&
        nextPageToken != 'localDb') {
      // print("updating new list ");
      _studentPlusBloc.add(GetStudentCourseWorkListByPaginationEvent(
          studentUserId: widget.studentPlusCourseModel.studentUserId,
          courseWorkId: widget.studentPlusCourseModel.id ?? '',
          nextPageToken: nextPageToken,
          oldList: paginationList));
    }
  }
}
