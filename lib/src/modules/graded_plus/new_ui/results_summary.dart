// ignore_for_file: must_be_immutable

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/bloc/google_classroom_bloc.dart';
import 'package:Soc/src/modules/google_classroom/services/google_classroom_globals.dart';
import 'package:Soc/src/modules/google_classroom/modal/google_classroom_courses.dart';
import 'package:Soc/src/modules/google_classroom/ui/graded_standalone_landing_page.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/services/google_authentication.dart';
import 'package:Soc/src/services/user_profile.dart';
import 'package:Soc/src/modules/graded_plus/bloc/graded_plus_bloc.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_overrides.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_plus_utilty.dart';
import 'package:Soc/src/modules/graded_plus/helper/result_action_icon_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/assessment_history_screen.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/camera_screen.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_fab.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_popup.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/graded_plus/widgets/edit_bottom_sheet.dart';
import 'package:Soc/src/modules/graded_plus/widgets/graded_plus_result_summary_action_bottom_sheet.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/graded_plus/widgets/user_profile.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_fab.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/image_popup.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../services/strings.dart';

class GradedPlusResultsSummary extends StatefulWidget {
  GradedPlusResultsSummary(
      {Key? key,
      this.obj,
      this.createdAsPremium,
      required this.assessmentDetailPage,
      this.fileId,
      this.subjectId,
      this.standardId,
      this.rubricScore,
      this.isScanMore,
      this.assessmentListLength,
      required this.shareLink,
      required this.assessmentName,
      this.historySecondTime,
      this.isMcqSheet,
      this.selectedAnswer,
      this.titleIconData})
      : super(key: key);
  final bool? assessmentDetailPage;
  String? fileId;
  // final HistoryAssessment? obj;
  final obj;
  final String? subjectId;
  final String? standardId;
  final String? rubricScore;
  final bool? isScanMore;
  final int? assessmentListLength;
  String? shareLink;
  String? assessmentName;
  bool? historySecondTime;
  final bool? createdAsPremium;
  bool? isMcqSheet;
  String? selectedAnswer;
  final IconData? titleIconData;
  @override
  State<GradedPlusResultsSummary> createState() => studentRecordList();
}

class studentRecordList extends State<GradedPlusResultsSummary> {
  static const double _KVerticalSpace = 60.0;
  GoogleDriveBloc _driveBloc = GoogleDriveBloc();
  GoogleDriveBloc _driveBloc2 = GoogleDriveBloc();
  OcrBloc _ocrBloc = OcrBloc();
  // OcrBloc _ocrAssessmentBloc =
  //     OcrBloc(); // bloc instance only use for save assessment to database
  int lastAssessmentLength = 0;

  // int? assessmentCount;
  //ScrollController _scrollController = new ScrollController();
  final ValueNotifier<bool> isScrolling = ValueNotifier<bool>(false);
  final ValueNotifier<bool> disableSlidableAction = ValueNotifier<bool>(false);
  final ValueNotifier<bool> editStudentDetailSuccess =
      ValueNotifier<bool>(false);
  final ValueNotifier<String> dashboardState = ValueNotifier<String>('');

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  int? assessmentListLength;
  ValueNotifier<int> assessmentCount = ValueNotifier<int>(0);
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);
  ValueNotifier<bool> isSuccessStateReceived = ValueNotifier<bool>(false);
  ValueNotifier<bool> infoIconValue = ValueNotifier<bool>(false);
  String? isAssessmentAlreadySaved = '';
  int? savedRecordCount;
  String? questionImageUrl;

  String? webContentLink;
  String? sheetRubricScore;
  List<StudentAssessmentInfo> historyRecordList = [];
  List iconsList = [];
  List iconsName = [];
  bool createdAsPremium = false;
  bool isMcqSheet = false;
  String? selectedAnswer;
  final editingStudentNameController = TextEditingController();
  final editingStudentIdController = TextEditingController();
  final studentScoreController = TextEditingController();
  String? pointPossible;
  String oldStudentId = ''; // Used in case of update record to dashboard

  // ValueNotifier<List<StudentAssessmentInfo>> studentRecordList =
  //     ValueNotifier([]);
  ValueNotifier<int> _listCount = ValueNotifier(0);

  LocalDatabase<StudentAssessmentInfo> _studentAssessmentInfoDb =
      LocalDatabase('student_info');
  LocalDatabase<StudentAssessmentInfo> _historystudentAssessmentInfoDb =
      LocalDatabase('history_student_info');

  String? historyAssessmentId;

  // ValueNotifier<List<bool>> dashboardWidget =
  //     ValueNotifier<List<bool>>([false, false]);

  ValueNotifier<bool> isGoogleSheetStateReceived = ValueNotifier<bool>(false);
  final ScrollController _scrollController = ScrollController();
  // GoogleDriveBloc _driveBloc3 = GoogleDriveBloc();
  // final ValueNotifier<bool> isShareLinkReceived = ValueNotifier<bool>(false);

  LocalDatabase<GoogleClassroomCourses> _googleClassRoomlocalDbForStandAlone =
      LocalDatabase(Strings.googleClassroomCoursesList);

  GoogleClassroomBloc _googleClassroomBloc = new GoogleClassroomBloc();
  final ValueNotifier<bool> classroomUrlStatus = ValueNotifier<bool>(false);

  ValueNotifier<bool> isEditPerform = ValueNotifier<bool>(false);

  LocalDatabase<ClassroomCourse> _googleClassRoomlocalDbForStandardApp =
      LocalDatabase(OcrOverrides.gradedPlusStandardClassroomDB);

  @override
  void initState() {
    updateCount();
    _initState();

    _scrollController.addListener(_scrollListener);
    if (widget.isMcqSheet != null) {
      isMcqSheet = widget.isMcqSheet!;
    }
    if (widget.selectedAnswer != null) {
      selectedAnswer = widget.selectedAnswer;
    }
    super.initState();

    FirebaseAnalyticsService.addCustomAnalyticsEvent("results_summary");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'results_summary', screenClass: 'ResultsSummary');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      OcrOverrides.gradedPlusNavBarIsHide.value = false;
    });
  }

//--------------------------------------------------------------------------------------------------------------------------
  @override
  void dispose() {
    _scrollController.removeListener(() {
      _scrollListener();
    });
    // TODO: implement dispose
    super.dispose();
  }

//--------------------------------------------------------------------------------------------------------------------------
  _scrollListener() async {
    bool isTop = _scrollController.position.pixels < 150;
    if (isTop) {
      if (isScrolling.value == false) return;
      isScrolling.value = false;
    } else {
      if (isScrolling.value == true) return;
      isScrolling.value = true;
    }
  }

//--------------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          CommonBackgroundImgWidget(),
          Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.transparent,
            appBar: CustomOcrAppBarWidget(
              commonLogoPath:
                  Color(0xff000000) == Theme.of(context).backgroundColor
                       ? "assets/images/graded+_light.png"
                            : "assets/images/graded+_dark.png",
              refresh: (v) {
                setState(() {});
              },
              iconData: widget.titleIconData,
              plusAppName: 'GRADED+',
              fromGradedPlus: true,
              onTap: () {
                Utility.scrollToTop(scrollController: _scrollController);
              },
              isSuccessState: ValueNotifier<bool>(true),
              isBackOnSuccess: isBackFromCamera,
              key: GlobalKey(),
              sessionId: widget.obj != null ? widget.obj!.sessionId : '',
              isBackButton: widget.assessmentDetailPage,
              assessmentDetailPage: widget.assessmentDetailPage,
              actionIcon: Container(
                  padding: EdgeInsets.all(8),
                  child: TextButton(
                      style: ButtonStyle(
                        alignment: Alignment.center,
                      ),
                      child: TranslationWidget(
                          message: "DONE",
                          fromLanguage: "en",
                          toLanguage: Globals.selectedLanguage,
                          builder: (translatedMessage) {
                            return Text(translatedMessage,
                                style: TextStyle(
                                    color: AppTheme.kButtonColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18));
                          }),
                      onPressed: () {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        String assignmentCompletedLogMsg =
                            "Result Summary Done Button Pressed";
                        FirebaseAnalyticsService.addCustomAnalyticsEvent(
                            assignmentCompletedLogMsg
                                    .toLowerCase()
                                    .replaceAll(" ", "_") ??
                                '');
                        PlusUtility.updateLogs(
                            activityType: 'GRADED+',
                            userType: 'Teacher',
                            activityId: '19',
                            description: assignmentCompletedLogMsg,
                            operationResult: 'Success');
                        Fluttertoast.cancel();
                        // Navigator.of(context).pushAndRemoveUntil(
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             Overrides.STANDALONE_GRADED_APP == true
                        //                 ? GradedLandingPage()
                        //                 : HomePage(
                        //                     isFromOcrSection: true,
                        //                   )),
                        //     (_) => false);
                        if (Overrides.STANDALONE_GRADED_APP) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => GradedLandingPage()),
                              (_) => false);
                        } else {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        }

                        // onFinishedPopup();
                      })),
              isResultScreen: true,
            ),
            body: body(),
            floatingActionButton: fabButton(context),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterFloat,
          ),
          //Fetch assessment details from database
          BlocListener<GoogleDriveBloc, GoogleDriveState>(
            bloc: _driveBloc,
            child: Container(),
            listener: (context, state) {
              if (state is AssessmentDetailSuccess) {
                if (state.obj.length > 0 &&
                    state.obj[0].answerKey != '' &&
                    state.obj[0].answerKey != 'NA' &&
                    state.obj[0].answerKey != null) {
                  widget.isMcqSheet = true;
                  widget.selectedAnswer = state.obj[0].answerKey;
                  isMcqSheet = true;
                  selectedAnswer = state.obj[0].answerKey;
                  print(
                      'mcq updated ----------------------------- ${widget.isMcqSheet}');
                }
                // return studentSummaryCardWidget(list: state.obj);
              }
              //return Container();
            },
          ),
          BlocListener<GoogleClassroomBloc, GoogleClassroomState>(
              bloc: _googleClassroomBloc,
              child: Container(),
              listener: (context, state) async {
                if (state is CreateClassroomCourseWorkSuccess) {
                  Navigator.of(context).pop();
                }
                if (state is GoogleClassroomErrorState) {
                  if (state.errorMsg == 'ReAuthentication is required') {
                    // await Utility.refreshAuthenticationToken(
                    //     isNavigator: true,
                    //     errorMsg: state.errorMsg!,
                    //     context: context,
                    //     scaffoldKey: scaffoldKey);
                    await Authentication.reAuthenticationRequired(
                        context: context,
                        errorMessage: state.errorMsg!,
                        scaffoldKey: scaffoldKey);
                    _googleClassroomBloc.add(CreateClassRoomCourseWork(
                        isEditStudentInfo: true,
                        studentAssessmentInfoDb: LocalDatabase('student_info'),
                        studentClassObj: GoogleClassroomOverrides
                            .studentAssessmentAndClassroomObj,
                        title: Globals.assessmentName!,
                        pointPossible: Globals.pointPossible ?? "0"));
                  } else {
                    Navigator.of(context).pop();
                    Utility.currentScreenSnackBar(
                        state.errorMsg?.toString() ?? "", null);
                  }
                }

                if (state is GetClassroomCourseWorkURLSuccess) {
                  if (!state.isLinkAvailable!) {
                    Utility.currentScreenSnackBar(
                        "Please check your internet connection and try again",
                        null);
                  }

                  GoogleClassroomOverrides.studentAssessmentAndClassroomObj
                      .courseWorkURL = state.classroomCouseWorkURL ?? '';
                  classroomUrlStatus.value = true;
                }
              })
        ],
      ),
    );
  }

//--------------------------------------------------------------------------------------------------------------------------
  Widget body() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: StudentPlusOverrides.kSymmetricPadding),
      child: Column(
        children: [
          SpacerWidget(StudentPlusOverrides.KVerticalSpace /
              (widget.assessmentDetailPage! ? 10 : 4)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PlusScreenTitleWidget(
                isTrailingIcon: true,
                kLabelSpacing: widget.assessmentDetailPage!
                    ? 0
                    : StudentPlusOverrides.kLabelSpacing / 2,
                text: 'Results Summary',
                backButton: widget.assessmentDetailPage,
              ),
              ValueListenableBuilder(
                  valueListenable: isGoogleSheetStateReceived,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return ValueListenableBuilder(
                        valueListenable: assessmentCount,
                        builder: (BuildContext context, int listCount,
                            Widget? child) {
                          return FutureBuilder(
                              future: OcrUtility.getSortedStudentInfoList(
                                  tableName: widget.assessmentDetailPage == true
                                      ? 'history_student_info'
                                      : 'student_info'),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<StudentAssessmentInfo>>
                                      snapshot) {
                                if (snapshot.hasData &&
                                        widget.assessmentDetailPage == true
                                    ? isGoogleSheetStateReceived.value
                                    : !isGoogleSheetStateReceived.value) {
                                  lastAssessmentLength =
                                      snapshot?.data?.length ?? 0;
                                  return snapshot.data != null
                                      ? Tooltip(
                                          message:
                                              "Total Scanned ${lastAssessmentLength == 0 ? 'Sheet' : 'Sheets'}",
                                          child: IconButton(
                                            onPressed: (() {}),
                                            icon: Text(
                                                '${snapshot.data!.length}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3),
                                          ),
                                        )
                                      : Container(
                                          width: 10,
                                          height: 10,
                                        );
                                }
                                return Container(
                                  width: 10,
                                  height: 10,
                                );
                              });
                        });
                  }),
            ],
          ),

          // SpacerWidget(_KVerticalSpace / 5),
          Container(
            //color: Colors.amber,
            //height: MediaQuery.of(context).size.height * 0.09,
            child: ValueListenableBuilder(
              valueListenable: infoIconValue,
              builder: (BuildContext context, bool value, Widget? child) {
                return Padding(
                  padding: EdgeInsets.only(left: 5), //EdgeInsets.only(
                  //   left: 20,
                  // ),
                  child: infoIconValue.value == true ||
                          widget.assessmentDetailPage != true
                      ? ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Utility.textWidget(
                                text: widget.assessmentDetailPage == true
                                    ? Globals.historyAssessmentName ?? ''
                                    : Globals.assessmentName ?? '',
                                context: context,
                                maxLines: 2,
                                textAlign: TextAlign.left,
                                textTheme:
                                    Theme.of(context).textTheme.headline2!),
                          ),
                          trailing: Container(
                              padding: EdgeInsets.only(left: 5),
                              child: infoWidget()))
                      : Container(),
                );
              },
              child: Container(),
            ),
          ),

          // !widget.assessmentDetailPage!
          //     ? studentSummaryCardWidget()
          //     : BlocBuilder<GoogleDriveBloc, GoogleDriveState>(
          //         bloc: _driveBloc,
          //         builder: (context, state) {
          //           if (state is AssessmentDetailSuccess) {
          //             if (state.obj.length > 0 &&
          //                 state.obj[0].answerKey != '' &&
          //                 state.obj[0].answerKey != 'NA' &&
          //                 state.obj[0].answerKey != null) {
          //               widget.isMcqSheet = true;
          //             }
          //             return studentSummaryCardWidget(list: state.obj);
          //           }
          //           return Container();
          //         },
          //       ),
          SpacerWidget(_KVerticalSpace / 5),
          !widget.assessmentDetailPage!
              ? Expanded(
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      resultTitle(),
                      ValueListenableBuilder(
                          valueListenable: isEditPerform,
                          builder: (BuildContext context, bool value,
                              Widget? child) {
                            return ValueListenableBuilder(
                                valueListenable: assessmentCount,
                                builder: (BuildContext context, int listCount,
                                    Widget? child) {
                                  return FutureBuilder(
                                      future:
                                          OcrUtility.getSortedStudentInfoList(
                                              tableName:
                                                  widget.assessmentDetailPage ==
                                                          true
                                                      ? 'history_student_info'
                                                      : 'student_info'),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<
                                                  List<StudentAssessmentInfo>>
                                              snapshot) {
                                        if (snapshot.hasData) {
                                          if (snapshot.data!.length != 0) {
                                            questionImageUrl = snapshot
                                                .data![0].questionImgUrl;
                                          }

                                          return listView(
                                            snapshot.data!,
                                          );
                                        }
                                        return Globals.isAndroid!
                                            ? CircularProgressIndicator()
                                            : CupertinoActivityIndicator(
                                                //color: Colors.white,
                                                );
                                      });
                                });
                          }),
                      BlocListener<GoogleDriveBloc, GoogleDriveState>(
                          bloc: _driveBloc2,
                          child: Container(),
                          listener: (context, state) async {
                            // if (state is GoogleDriveLoading) {
                            //   Utility.showLoadingDialog(
                            //       context: context, isOCR: true);
                            // }

                            if (state is GoogleFolderCreated) {
                              if (Overrides.STANDALONE_GRADED_APP) {
                                _googleClassroomBloc.add(
                                    CreateClassRoomCourseWork(
                                        isEditStudentInfo: true,
                                        studentAssessmentInfoDb:
                                            LocalDatabase('student_info'),
                                        studentClassObj: GoogleClassroomOverrides
                                            .studentAssessmentAndClassroomObj,
                                        title: Globals.assessmentName!,
                                        pointPossible:
                                            Globals.pointPossible ?? "0"));
                              } else {
                                //!UNCOMMENT  Navigator.of(context).pop();
                              }
                            }
                            if (state is ErrorState) {
                              if (state.errorMsg ==
                                  'ReAuthentication is required') {
                                await Utility.refreshAuthenticationToken(
                                    isNavigator: true,
                                    errorMsg: state.errorMsg!,
                                    context: context,
                                    scaffoldKey: scaffoldKey);

                                _driveBloc2.add(UpdateDocOnDrive(
                                  isMcqSheet: widget.isMcqSheet ?? false,
                                  // questionImage:
                                  //     questionImageUrl ?? "NA",

                                  assessmentName: Globals.assessmentName!,
                                  fileId: Globals.googleExcelSheetId,
                                  isLoading: true,
                                  studentData:
                                      //list2
                                      await OcrUtility.getSortedStudentInfoList(
                                          tableName:
                                              widget.assessmentDetailPage ==
                                                      true
                                                  ? 'history_student_info'
                                                  : 'student_info'),
                                ));
                              } else {
                                Navigator.of(context).pop();
                                Utility.currentScreenSnackBar(
                                    "Something Went Wrong. Please Try Again.",
                                    null);
                              }

                              // Navigator.of(context).pop();
                              // Utility.currentScreenSnackBar(
                              //     "Something Went Wrong. Please Try Again.");
                            }
                          }),
                    ],
                  ),
                )
              : BlocConsumer(
                  bloc: _driveBloc,
                  builder: (BuildContext contxt, GoogleDriveState state) {
                    if (state is GoogleDriveLoading2) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                            child: Globals.isAndroid!
                                ? CircularProgressIndicator(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryVariant,
                                  )
                                : CupertinoActivityIndicator(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryVariant,
                                    radius: 15,
                                  )),
                      );
                    }

                    if (state is AssessmentDetailSuccess) {
                      if (state.obj.length > 0) {
                        return Expanded(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            //  shrinkWrap: true,
                            children: [
                              resultTitle(),
                              FutureBuilder(
                                  future: OcrUtility.getSortedStudentInfoList(
                                      tableName:
                                          widget.assessmentDetailPage == true
                                              ? 'history_student_info'
                                              : 'student_info'),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<StudentAssessmentInfo>>
                                          snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data!.length != 0) {
                                        questionImageUrl =
                                            snapshot.data![0].questionImgUrl;
                                      }
                                      // updateAssessmentToDb(
                                      //     studentInfoList:
                                      //         snapshot.data);
                                      return listView(snapshot.data!);
                                    }
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      child: Center(
                                          child: Globals.isAndroid!
                                              ? CircularProgressIndicator(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primaryVariant,
                                                )
                                              : CupertinoActivityIndicator(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primaryVariant,
                                                  radius: 15,
                                                )),
                                    );
                                  })
                            ],
                          ),
                        );
                      } else {
                        return Expanded(
                          child: NoDataFoundErrorWidget(
                              isResultNotFoundMsg: true,
                              isNews: false,
                              isEvents: false),
                        );
                      }
                    }
                    if (state is AssessmentDetailSuccess) {
                      if (state.obj.length > 0) {
                        return Expanded(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              resultTitle(),
                              listView(
                                state.obj,
                              )
                            ],
                          ),
                        );
                      } else {
                        return Expanded(
                          child: NoDataFoundErrorWidget(
                              isResultNotFoundMsg: true,
                              isNews: false,
                              isEvents: false),
                        );
                      }
                    }

                    return Container();
                  },
                  listener:
                      (BuildContext contxt, GoogleDriveState state) async {
                    if (state is AssessmentDetailSuccess) {
                      //Fetching excel sheet records and its length
                      if (state.obj.length > 0) {
                        // await _historystudentAssessmentInfoDb.clear();

                        //Mark student that are already saved to google classroom
                        if (Overrides.STANDALONE_GRADED_APP) {
                          state.obj
                              .forEach((StudentAssessmentInfo student) async {
                            if ((GoogleClassroomOverrides
                                        .studentAssessmentAndClassroomObj
                                        ?.courseId
                                        ?.isNotEmpty ??
                                    false) &&
                                (GoogleClassroomOverrides
                                        .studentAssessmentAndClassroomObj
                                        ?.courseWorkId
                                        ?.isNotEmpty ??
                                    false)) {
                              student.isgoogleClassRoomStudentProfileUpdated =
                                  true;
                            }
                            student.isStudentResultAssignmentSavedOnDashboard =
                                true;
                            //Mark student that are already saved to google Slides
                            student.isSlideObjUpdated = true;
                            await _historystudentAssessmentInfoDb
                                .addData(student);
                          });
                        } else {
                          state.obj
                              .forEach((StudentAssessmentInfo student) async {
                            if ((GoogleClassroomOverrides
                                        .historyStudentResultSummaryForStandardApp
                                        ?.id
                                        ?.isNotEmpty ??
                                    false) &&
                                (GoogleClassroomOverrides
                                        .historyStudentResultSummaryForStandardApp
                                        ?.courseWorkId
                                        ?.isNotEmpty ??
                                    false)) {
                              student.isgoogleClassRoomStudentProfileUpdated =
                                  true;
                            }
                            student.isStudentResultAssignmentSavedOnDashboard =
                                true;
                            //Mark student that are already saved to google Slides
                            student.isSlideObjUpdated = true;
                            await _historystudentAssessmentInfoDb
                                .addData(student);
                          });
                        }

                        //Extract presentation url from the excel sheet
                        if (state.obj[0].googleSlidePresentationURL != 'NA' &&
                            state.obj[0].googleSlidePresentationURL != null &&
                            state.obj[0].googleSlidePresentationURL!
                                .isNotEmpty) {
                          OcrOverrides
                                  .gradedPlusHistoryAssignmentGooglePresentationId =
                              state.obj[0].googleSlidePresentationURL!
                                  .split('/')[5];
                        } else {
                          OcrOverrides
                                  .gradedPlusHistoryAssignmentGooglePresentationId =
                              'NA';
                        }

                        if (state.obj[0].answerKey != '' &&
                            state.obj[0].answerKey != 'NA' &&
                            state.obj[0].answerKey != null) {
                          widget.isMcqSheet = true;
                          widget.selectedAnswer = state.obj[0].answerKey;
                        }
                        OcrOverrides
                                .gradedPlusHistoryAssignmentGooglePresentationLink =
                            state.obj[0].googleSlidePresentationURL;
                        savedRecordCount != null
                            ? savedRecordCount == state.obj.length
                                ? dashboardState.value = 'Success'
                                : dashboardState.value = ''
                            : print("");

                        sheetRubricScore = state.obj.first.scoringRubric;
                        webContentLink = state.webContentLink;
                        isSuccessStateReceived.value = true;
                        infoIconValue.value = true;
                        historyRecordList = state.obj;

                        assessmentCount.value = state.obj.length;
                      }
                      updateAssessmentToDb();
                      isGoogleSheetStateReceived.value = true;

                      // classroomUrlStatus.value = 'Loading';

                      //Get Course URL on detail page load
                      _googleClassroomBloc.add(GetClassroomCourseWorkURL(
                          obj: GoogleClassroomOverrides
                              .studentAssessmentAndClassroomObj));
                    } else if (state is ErrorState) {
                      if (state.errorMsg == 'ReAuthentication is required') {
                        // await Utility.refreshAuthenticationToken(
                        //     isNavigator: false,
                        //     errorMsg: state.errorMsg!,
                        //     context: context,
                        //     scaffoldKey: scaffoldKey);
                        await Authentication.reAuthenticationRequired(
                            context: context,
                            errorMessage: state.errorMsg!,
                            scaffoldKey: scaffoldKey);
                        _driveBloc.add(GetAssessmentDetail(
                            fileId: widget.fileId, nextPageUrl: ''));
                      } else {
                        Navigator.of(context).pop();
                        Utility.currentScreenSnackBar(
                            "Something Went Wrong. Please Try Again.", null);
                      }
                    }
                  },
                ),
          Container(
            height: 0,
            width: 0,
            child: BlocListener<OcrBloc, OcrState>(
                bloc: _ocrBloc,
                listener: (context, state) async {
                  if (state is OcrLoading) {
                    dashboardState.value = 'Loading';
                  } else if (state is AssessmentSavedSuccessfully) {
                    //To update slidable action buttons : Enable/Disable
                    disableSlidableAction.value = true;

                    dashboardState.value = 'Success';
                    PlusUtility.updateLogs(
                        activityType: 'GRADED+',
                        userType: 'Teacher',
                        activityId: '14',
                        description: 'Save to dashboard success',
                        operationResult: 'Success');
                    List<StudentAssessmentInfo> studentInfo =
                        await OcrUtility.getSortedStudentInfoList(
                            tableName: widget.assessmentDetailPage == true
                                ? 'history_student_info'
                                : 'student_info');

                    studentInfo.asMap().forEach((index, element) async {
                      StudentAssessmentInfo element = studentInfo[index];
                      //Disabling all the existing records edit functionality. Only scan more records will be allowed to edit.
                      if (element.isSavedOnDashBoard == null) {
                        element.isSavedOnDashBoard = true;
                      }
                      await _studentAssessmentInfoDb.putAt(index, element);
                    });

                    List list = await OcrUtility.getSortedStudentInfoList(
                        tableName: 'student_info');

                    assessmentCount.value = list.length;

                    Globals.scanMoreStudentInfoLength = list.length;

                    _showDataSavedPopup(
                        historyAssessmentSection: false,
                        title: 'Saved To Data Dashboard',
                        msg:
                            'Yay! Assessment data has been successfully added to your school’s Data Dashboard.',
                        noActionText: 'No',
                        yesActionText: 'Perfect!');
                  } else if (state is OcrErrorReceived) {
                    disableSlidableAction.value = false;
                  }
                  if (state is AssessmentDashboardStatusForStandaloneApp) {
                    if (state.assessmentObj?.assessmentCId?.isNotEmpty ??
                        false) {
                      List list = await OcrUtility.getSortedStudentInfoList(
                          tableName: 'history_student_info');

                      if (isGoogleSheetStateReceived.value == true) {
                        state.resultRecordCount == list.length
                            ? dashboardState.value = 'Success'
                            : dashboardState.value = '';
                      }

                      if (Overrides.STANDALONE_GRADED_APP) {
                        List<GoogleClassroomCourses>
                            _googleClassroomCourseslocalData =
                            await _googleClassRoomlocalDbForStandAlone
                                .getData();

                        for (GoogleClassroomCourses element
                            in _googleClassroomCourseslocalData) {
                          if (element.courseId ==
                              state.assessmentObj!.courseId) {
                            //update the classroom course work id in GoogleClassroomOverrides obj
                            element.courseWorkId =
                                state.assessmentObj!.courseWorkId!;

                            GoogleClassroomOverrides
                                .studentAssessmentAndClassroomObj = element;

                            break;
                          }
                        }
                      }

                      savedRecordCount = state.resultRecordCount;
                      GoogleClassroomOverrides
                              .studentAssessmentAndClassroomObj.assessmentCId =
                          historyAssessmentId =
                              state.assessmentObj!.assessmentCId;
                    }
                  }

                  if (state is AssessmentDashboardStatusForStandardApp) {
                    if (state.assessmentObj?.assessmentCId?.isNotEmpty ??
                        false) {
                      List list = await OcrUtility.getSortedStudentInfoList(
                          tableName: 'history_student_info');

                      if (isGoogleSheetStateReceived.value == true) {
                        state.resultRecordCount == list.length
                            ? dashboardState.value = 'Success'
                            : dashboardState.value = '';
                      }

                      // List<ClassroomCourse> _googleClassroomCourseslocalData =
                      //     await _googleClassRoomlocalDbForStandardApp.getData();

                      // for (ClassroomCourse element
                      //     in _googleClassroomCourseslocalData) {
                      //   if (element.id == state.assessmentObj!.id) {
                      //     //update the classroom course work id in GoogleClassroomOverrides obj
                      //     element.courseWorkId =
                      //         state.assessmentObj!.courseWorkId!;

                      //     GoogleClassroomOverrides
                      //             .historyStudentResultSummaryForStandardApp =
                      //         element;

                      //     break;
                      //   }
                      // }

                      savedRecordCount = state.resultRecordCount;

                      historyAssessmentId = state.assessmentObj!.assessmentCId;
                    }
                  }

                  if (state is OcrLoading2) {
                    dashboardState.value = 'Loading';
                  }
                },
                child: EmptyContainer()),
          ),
        ],
      ),
    );
  }

//--------------------------------------------------------------------------------------------------------------------------
  Widget resultTitle() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          height: 50.0,
          margin:
              const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Theme.of(context).backgroundColor == Color(0xff000000)
                ? Color(0xff162429)
                : Color(0xffF7F8F9),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.5),
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Container(
              child: ListTile(
            leading: Utility.textWidget(
                text: 'Student Name',
                context: context,
                textTheme: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(fontWeight: FontWeight.bold)),
            trailing: Utility.textWidget(
                text: 'Points Earned',
                context: context,
                textTheme: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(fontWeight: FontWeight.bold)),
          )),
        ),
      ),
    );
  }

//--------------------------------------------------------------------------------------------------------------------------
  Widget listView(List<StudentAssessmentInfo> _list) {
    return ValueListenableBuilder<bool>(
        valueListenable: disableSlidableAction,
        child: Container(),
        builder: (BuildContext context, bool value, Widget? child) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height *
                    0.08), //For bottom padding from FAB
            height: widget.assessmentDetailPage!
                ? (MediaQuery.of(context).orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.height * 0.63
                    : MediaQuery.of(context).size.height * 0.45)
                : (MediaQuery.of(context).orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.height * 0.57
                    : MediaQuery.of(context).size.height * 0.45),
            child: ListView.builder(
              //padding:widget.assessmentDetailPage==true? EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.06):null,
              controller: _scrollController,
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 25), //AppTheme.klistPadding),
              scrollDirection: Axis.vertical,
              itemCount: _list.length, // Globals.gradeList.length,
              itemBuilder: (BuildContext context, int index) {
                return Slidable(
                    enabled: widget.assessmentDetailPage == true ? false : true,
                    // Specify a key if the Slidable is dismissible.
                    key: ValueKey(index),
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        CustomSlidableAction(
                          // An action can be bigger than the others.

                          onPressed: (i) {
                            //To reset the value listener
                            disableSlidableAction.value = false;

                            //print(i);
                            _list[index].isSavedOnDashBoard == null
                                ? performEditAndDelete(context, index, true)
                                : Utility.currentScreenSnackBar(
                                    "You Cannot Edit The Record Which Is Already Saved To The \'Data Dashboard\'",
                                    null);
                          },
                          backgroundColor:
                              _list[index].isSavedOnDashBoard == null
                                  ? AppTheme.kButtonColor
                                  : Colors.grey,
                          foregroundColor: Colors.white,
                          // icon: Icons.edit,
                          // label: 'Edit',
                          child: customSlidableDecorationWidget(
                              label: 'Edit', icon: Icons.edit),
                        ),
                        CustomSlidableAction(
                            onPressed: (i) {
                              //To reset the value listener
                              disableSlidableAction.value = false;

                              _list[index].isSavedOnDashBoard == null
                                  ? performEditAndDelete(context, index, false)
                                  : Utility.currentScreenSnackBar(
                                      "You Cannot Delete The Record Which Is Already Saved To The \'Data Dashboard\'",
                                      null);
                            },
                            backgroundColor:
                                _list[index].isSavedOnDashBoard == null
                                    ? Colors.red
                                    : Colors.grey,
                            foregroundColor: Colors.white,
                            // icon: Icons.delete,
                            // label: 'Delete',
                            child: customSlidableDecorationWidget(
                              label: 'Delete',
                              icon: Icons.delete,
                            )),
                      ],
                    ),
                    child: _buildList(index, _list, context));
              },
            ),
          );
        });
  }

//--------------------------------------------------------------------------------------------------------------------------
  Widget _buildList(int index, List<StudentAssessmentInfo> _list, context) {
    return _list[index].studentName == 'Name'
        ? Container()
        : Container(
            height: 54,
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
              onTap: (() => _list[index].assessmentImage == null ||
                      _list[index].assessmentImage == 'NA'
                  ? Utility.currentScreenSnackBar('No Image Found', null,
                      marginFromBottom: 120)
                  : showDialog(
                      useRootNavigator: true,
                      context: context,
                      builder: (_) =>
                          ImagePopup(imageURL: _list[index].assessmentImage!))),
              leading:
                  // Text('Unknown'),
                  Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Utility.textWidget(
                    text: _list[index].studentName == '' ||
                            _list[index].studentName == null
                        ? 'Unknown'
                        : _list[index].studentName!,
                    maxLines: 2,
                    context: context,
                    textTheme: Theme.of(context).textTheme.headline2!),
              ),
              trailing: Utility.textWidget(
                  text: //'2/2',
                      _list[index].studentGrade == '' ||
                              _list[index].studentGrade == null
                          ? '2/${_list[index].pointPossible ?? '2'}'
                          : '${_list[index].studentGrade}/${_list[index].pointPossible ?? '2'}', // '${Globals.gradeList[index]} /2',
                  context: context,
                  textTheme: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontWeight: FontWeight.bold)),
            ),
          );
  }

//--------------------------------------------------------------------------------------------------------------------------
  _showDataSavedPopup(
      {required bool? historyAssessmentSection,
      required String? title,
      required String? msg,
      required String? yesActionText,
      required String? noActionText}) {
    return showDialog(
        context: context,
        builder: (context) =>
            OrientationBuilder(builder: (context, orientation) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Center(
                  child: Container(
                    padding: Globals.deviceType == 'phone'
                        ? null
                        : const EdgeInsets.only(top: 10.0),
                    height: Globals.deviceType == 'phone'
                        ? null
                        : orientation == Orientation.portrait
                            ? MediaQuery.of(context).size.height / 15
                            : MediaQuery.of(context).size.width / 15,
                    width: Globals.deviceType == 'phone'
                        ? null
                        : orientation == Orientation.portrait
                            ? MediaQuery.of(context).size.width / 2
                            : MediaQuery.of(context).size.height / 2,
                    child: TranslationWidget(
                        message: title, //"Saved To Data Dashboard",
                        fromLanguage: "en",
                        toLanguage: Globals.selectedLanguage,
                        builder: (translatedMessage) {
                          return Text(translatedMessage.toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(color: AppTheme.kButtonColor));
                        }),
                  ),
                ),
                content: TranslationWidget(
                    message: msg,
                    //'Yay! Assessment data has been successfully added to your school’s Data Dashboard.',
                    //     'Yay! Data has been successfully saved to the dashboard',
                    fromLanguage: "en",
                    toLanguage: Globals.selectedLanguage,
                    builder: (translatedMessage) {
                      return Text(translatedMessage.toString(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.black));
                    }),
                actions: <Widget>[
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.height,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  if (historyAssessmentSection == true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          child: FittedBox(
                            child: TranslationWidget(
                                message: noActionText ?? "NO",
                                fromLanguage: "en",
                                toLanguage: Globals.selectedLanguage,
                                builder: (translatedMessage) {
                                  return Text(translatedMessage.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(
                                              color: AppTheme.kButtonColor,
                                              fontSize:
                                                  Globals.deviceType == 'phone'
                                                      ? 20
                                                      : 22));
                                }),
                          ),
                          onPressed: () {
                            //Globals.cameraPopup = false;
                            Navigator.of(context).pop();
                          },
                        ),
                        Container(
                          height: 35,
                          width: 1,
                          color: Colors.grey[300],
                        ),
                        TextButton(
                          child: FittedBox(
                            child: TranslationWidget(
                                message: yesActionText ?? "OK ",
                                fromLanguage: "en",
                                toLanguage: Globals.selectedLanguage,
                                builder: (translatedMessage) {
                                  return Text(translatedMessage.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(
                                              color: yesActionText ==
                                                      'Yes, Take Me There'
                                                  ? Colors.red
                                                  : AppTheme.kButtonColor,
                                              fontSize:
                                                  Globals.deviceType == 'phone'
                                                      ? 20
                                                      : 22));
                                }),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            if (yesActionText != null) {
                              await _historystudentAssessmentInfoDb.clear();
                            }
                            Fluttertoast.cancel();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      GradedPlusAssessmentSummary(
                                        titleIconData: widget.titleIconData,
                                        selectedFilterValue:
                                            widget.isMcqSheet == true
                                                ? 'Multiple Choice'
                                                : 'Constructed Response',
                                        isFromHomeSection: false,
                                      )),
                            );

                            //Globals.isCameraPopup = false;
                          },
                        ),
                      ],
                    ),
                  if (historyAssessmentSection == false)
                    Center(
                      child: TextButton(
                        child: TranslationWidget(
                            message: "OK ",
                            fromLanguage: "en",
                            toLanguage: Globals.selectedLanguage,
                            builder: (translatedMessage) {
                              return Text(translatedMessage.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        color: AppTheme.kButtonColor,
                                      ));
                            }),
                        onPressed: () {
                          Navigator.of(context).pop();

                          //Globals.isCameraPopup = false;
                        },
                      ),
                    )
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              );
            }));
  }

//--------------------------------------------------------------------------------------------------------------------------
  getGoogleFolderPath() async {
    List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();
    Utility.showSnackBar(scaffoldKey,
        "Unable To Navigate At The Moment. Please Try Again.", context, null);

    _driveBloc.add(GetDriveFolderIdEvent(
        isReturnState: false,
        //  filePath: file,
        token: _profileData[0].authorizationToken,
        folderName: "SOLVED GRADED+",
        refreshToken: _profileData[0].refreshToken));
  }

//--------------------------------------------------------------------------------------------------------------------------
  performEditAndDelete(BuildContext context, int index, bool? edit) async {
    List<StudentAssessmentInfo> studentInfo =
        await OcrUtility.getSortedStudentInfoList(tableName: 'student_info');
    if (edit!) {
      String editingLogMsg = "Teacher edited the record";

      FirebaseAnalyticsService.addCustomAnalyticsEvent(
          editingLogMsg.toLowerCase().replaceAll(" ", "_") ?? '');
      PlusUtility.updateLogs(
          activityType: 'GRADED+',
          userType: 'Teacher',
          activityId: '17',
          description: editingLogMsg,
          operationResult: 'Success');

      editingStudentNameController.text = studentInfo[index].studentName!;
      editingStudentIdController.text = studentInfo[index].studentId!;
      studentScoreController.text = widget.isMcqSheet == true
          ? studentInfo[index].studentResponseKey!
          : studentInfo[index].studentGrade!;
      pointPossible = studentInfo[index].pointPossible;
      String answerKey = studentInfo[index].answerKey!;
      String studentSelectedAlphabetAnswerKey =
          studentInfo[index].studentResponseKey!;

      editBottomSheet(
          studentSelection: widget.isMcqSheet == true
              ? studentSelectedAlphabetAnswerKey
              : studentScoreController.value.text,
          pointPossible: pointPossible ?? "2",
          answerKey: answerKey,
          controllerOne: editingStudentNameController,
          controllerTwo: editingStudentIdController,
          controllerThree: studentScoreController,
          index: index);
    } else {
      //  Globals.studentInfo!.length > 2
      if (studentInfo.length > 1) {
        _deletePopUP(
            //    studentName: Globals.studentInfo![index].studentName!,
            studentName: studentInfo[index].studentName!,
            index: index);
      } else {
        Utility.currentScreenSnackBar(
            "Action Not Performed. Result List Cannot Be Empty.", null);
      }
    }
  }

//--------------------------------------------------------------------------------------------------------------------------
  editBottomSheet(
      {required TextEditingController controllerOne,
      required TextEditingController controllerTwo,
      required TextEditingController controllerThree,
      required int index,
      required String pointPossible,
      required String answerKey,
      required String studentSelection}) {
    oldStudentId = controllerTwo.text;
    showModalBottomSheet(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        useRootNavigator: true,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        // animationCurve: Curves.easeOutQuart,
        elevation: 10,
        context: context,
        builder: (context) => EditBottomSheet(
              studentSelection: studentSelection,
              pointPossible: pointPossible,
              selectedAnswer: answerKey,
              isMcqSheet: widget.isMcqSheet,
              studentGradeController: controllerThree,
              studentNameController: controllerOne,
              studentEmailIdController: controllerTwo,
              sheetHeight: MediaQuery.of(context).size.height * 0.6,
              title: 'Edit Student Details',
              isImageField: false,
              textFieldTitleOne: 'Student Name',
              textFieldTitleTwo: Overrides.STANDALONE_GRADED_APP == true
                  ? 'Student Email'
                  : 'Student ID/Student Email',
              textFileTitleThree: 'Points Earned',
              isSubjectScreen: false,
              update: (
                  {required TextEditingController name,
                  required TextEditingController id,
                  required TextEditingController score,
                  String? studentResponse}) async {
                List<StudentAssessmentInfo> _list =
                    await OcrUtility.getSortedStudentInfoList(
                        tableName: 'student_info');
                StudentAssessmentInfo studentInfo = _list[index];

                //Checking if matches with existing data
                if (studentInfo.studentName == name.text &&
                    studentInfo.studentId == id.text &&
                    studentInfo.studentGrade == score.text &&
                    studentInfo.studentResponseKey == studentResponse) {
                  Navigator.pop(context, false);

                  return;
                }

                //In case of changed found in student details
                bool isEditScoreOrName = false;
                if (studentInfo.studentName != name.text ||
                    studentInfo.studentGrade != score.text) {
                  isEditScoreOrName = true;
                }

                studentInfo.studentName = name.text;
                studentInfo.studentId = id.text;
                studentInfo.studentGrade = score.text;
                studentInfo.studentResponseKey = studentResponse;
                studentInfo.isgoogleClassRoomStudentProfileUpdated = false;
                _studentAssessmentInfoDb.putAt(index, studentInfo);
                assessmentCount.value = _list.length;

                await updateCount();
                _method();

                disableSlidableAction.value = true;

                Navigator.pop(context, false);

                _ocrBloc.add(UpdateGradedPlusStudentResult(
                    mewStudentId: id.text,
                    oldStudentId: oldStudentId,
                    result: score.text,
                    studentName: name.text,
                    assessmentId: Globals.currentAssessmentId));

                //!UNCOMMENT Utility.showLoadingDialog(context: context, isOCR: true);
                _driveBloc2.add(UpdateDocOnDrive(
                  isMcqSheet: widget.isMcqSheet ?? false,
                  // questionImage: questionImageUrl ?? "NA",

                  assessmentName: Globals.assessmentName!,
                  fileId: Globals.googleExcelSheetId,
                  isLoading: true,
                  studentData: await OcrUtility.getSortedStudentInfoList(
                      isEdit: isEditScoreOrName,
                      tableName: Strings.studentInfoDbName),
                ));

                //to update the slides details .
                _driveBloc.add(EditSlideDetailsToGooglePresentation(
                    slidePresentationId: Globals.googleSlidePresentationId,
                    studentAssessmentInfo: studentInfo,
                    oldSlideIndex: isEditScoreOrName ? index : null));
                if (isEditScoreOrName) {
                  isEditPerform.value = !isEditPerform.value;
                }
              },
            ));
  }

//--------------------------------------------------------------------------------------------------------------------------
  _deletePopUP({required String studentName, required int index}) {
    return showDialog(
        context: context,
        builder: (context) =>
            OrientationBuilder(builder: (context, orientation) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Center(
                  child: Container(
                    padding: Globals.deviceType == 'phone'
                        ? null
                        : const EdgeInsets.only(top: 10.0),
                    height: Globals.deviceType == 'phone'
                        ? null
                        : orientation == Orientation.portrait
                            ? MediaQuery.of(context).size.height / 15
                            : MediaQuery.of(context).size.width / 15,
                    width: Globals.deviceType == 'phone'
                        ? null
                        : orientation == Orientation.portrait
                            ? MediaQuery.of(context).size.width / 2
                            : MediaQuery.of(context).size.height / 2,
                    child: TranslationWidget(
                        message: "Delete Record",
                        fromLanguage: "en",
                        toLanguage: Globals.selectedLanguage,
                        builder: (translatedMessage) {
                          return Text(translatedMessage.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(color: Colors.red));
                        }),
                  ),
                ),
                content: TranslationWidget(
                    message: 'You are about to delete the record - ',
                    fromLanguage: "en",
                    toLanguage: Globals.selectedLanguage,
                    builder: (translatedMessage) {
                      return RichText(
                        text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(text: translatedMessage),
                            TextSpan(
                                text: '"$studentName"',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    }),
                actions: <Widget>[
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.height,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        child: TranslationWidget(
                            message: "Keep the record",
                            fromLanguage: "en",
                            toLanguage: Globals.selectedLanguage,
                            builder: (translatedMessage) {
                              return Text(translatedMessage.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        color: AppTheme.kButtonColor,
                                      ));
                            }),
                        onPressed: () {
                          Navigator.pop(
                            context,
                          );
                        },
                      ),
                      TextButton(
                        child: TranslationWidget(
                            message: "Delete ",
                            fromLanguage: "en",
                            toLanguage: Globals.selectedLanguage,
                            builder: (translatedMessage) {
                              return Text(translatedMessage.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        color: Colors.red,
                                      ));
                            }),
                        onPressed: () async {
                          List<StudentAssessmentInfo> _list =
                              await OcrUtility.getSortedStudentInfoList(
                                  tableName: 'student_info');

                          await _studentAssessmentInfoDb.deleteAt(index);

                          //To save the 0th index value to next index in case of 0th index deletion
                          if (index == 0) {
                            StudentAssessmentInfo obj = _list[1];
                            obj
                              ..className = _list[0].className
                              ..subject = _list[0].subject
                              ..learningStandard = _list[0].learningStandard
                              ..subLearningStandard =
                                  _list[0].subLearningStandard
                              ..scoringRubric = _list[0].scoringRubric
                              ..customRubricImage = _list[0].customRubricImage
                              ..grade = _list[0].grade
                              ..questionImgUrl = _list[0].questionImgUrl
                              ..googleSlidePresentationURL =
                                  _list[0].googleSlidePresentationURL
                              ..standardDescription =
                                  _list[0].standardDescription
                              ..pointPossible = _list[0].pointPossible
                              ..answerKey = _list[0].answerKey
                              ..questionImgFilePath =
                                  _list[0].questionImgFilePath;

                            await _studentAssessmentInfoDb.putAt(0, obj);
                          }
                          String deleteRecordLogMsg =
                              "Teacher deleted the record successfully";
                          FirebaseAnalyticsService.addCustomAnalyticsEvent(
                              deleteRecordLogMsg
                                      .toLowerCase()
                                      .replaceAll(" ", "_") ??
                                  '');

                          PlusUtility.updateLogs(
                              activityType: 'GRADED+',
                              userType: 'Teacher',
                              activityId: '17',
                              description: deleteRecordLogMsg,
                              operationResult: 'Success');

                          // List _list = await OcrUtility.getSortedStudentInfoList(
                          //     tableName: 'student_info');
                          assessmentCount.value = _list.length - 1;
                          await updateCount();
                          _method();
                          // studentRecordList.value = Globals.studentInfo!;
                          Navigator.pop(
                            context,
                          );
                          //!UNCOMMENT        Utility.showLoadingDialog(
                          //!UNCOMMENT           context: context, isOCR: true);
                          _driveBloc2.add(UpdateDocOnDrive(
                              isMcqSheet: widget.isMcqSheet,
                              // questionImage: questionImageUrl ?? "NA",

                              assessmentName: Globals.assessmentName!,
                              fileId: Globals.googleExcelSheetId,
                              isLoading: true,
                              studentData:
                                  await OcrUtility.getSortedStudentInfoList(
                                      tableName: 'student_info')));

                          _driveBloc.add(DeleteSlideFromPresentation(
                              slidePresentationId:
                                  Globals.googleSlidePresentationId,
                              slideObjId: _list[index].slideObjectId));
                        },
                      ),
                    ],
                  )
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              );
            }));
  }

//--------------------------------------------------------------------------------------------------------------------------
  popupModal({required String message, required String? title}) {
    return showDialog(
        context: context,
        builder: (context) =>
            OrientationBuilder(builder: (context, orientation) {
              return CommonPopupWidget(
                  orientation: orientation,
                  context: context,
                  message: message,
                  title: title!);
            }));
  }

//--------------------------------------------------------------------------------------------------------------------------
  Future _method() async {
    List list =
        await OcrUtility.getSortedStudentInfoList(tableName: 'student_info');
    assessmentCount.value = list.length;

    if (Globals.scanMoreStudentInfoLength != null) {
      if (list.length == Globals.scanMoreStudentInfoLength) {
        dashboardState.value = 'Success';
      }
    }
  }

//--------------------------------------------------------------------------------------------------------------------------
  Future<void> updateCount() async {
    _listCount.value = await OcrUtility.getResultSummaryStudentInfoListLength(
        tableName: 'student_info');
  }

//--------------------------------------------------------------------------------------------------------------------------
  Widget detailsPageActionWithDashboard(index) {
    return BlocConsumer(
      bloc: _driveBloc,
      builder: (context, state) {
        if (state is ShareLinkReceived) {
          widget.shareLink = state.shareLink;

          return Icon(
            IconData(iconsList[index],
                fontFamily: Overrides.kFontFam,
                fontPackage: Overrides.kFontPkg),
            size: (widget.assessmentDetailPage! ? index == 2 : index == 3) &&
                    dashboardState.value == ''
                ? Globals.deviceType == 'phone'
                    ? 34
                    : 45
                : Globals.deviceType == 'phone'
                    ? 30
                    : 45,
            color: AppTheme.kButtonColor,
          );
        }

        return Container(
            padding: EdgeInsets.only(bottom: 14, top: 10),
            height: MediaQuery.of(context).size.height * 0.058,
            width: MediaQuery.of(context).size.width * 0.058,
            alignment: Alignment.center,
            child: Center(
                child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.primaryVariant,
            )));
      },
      listener: (context, state) async {
        if (state is ErrorState) {
          if (state.errorMsg == 'ReAuthentication is required') {
            // await Utility.refreshAuthenticationToken(
            //     isNavigator: false,
            //     errorMsg: state.errorMsg!,
            //     context: context,
            //     scaffoldKey: scaffoldKey);
            await Authentication.reAuthenticationRequired(
                context: context,
                errorMessage: state.errorMsg!,
                scaffoldKey: scaffoldKey);

            // _driveBloc
            //     .add(GetShareLink(fileId: widget.fileId, slideLink: false));
          } else {
            Navigator.of(context).pop();
            Utility.currentScreenSnackBar(
                "Something Went Wrong. Please Try Again.", null);
          }
        }
      },
    );
  }

//--------------------------------------------------------------------------------------------------------------------------
  void _showPopUp({required StudentAssessmentInfo studentAssessmentInfo}) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return CustomDialogBox(
            activityType: 'GRADED+',
            isMcqSheet: widget.isMcqSheet,
            title: widget.assessmentName == null
                ? 'Assignment Name'
                : widget.assessmentName!,
            height: MediaQuery.of(context).size.height * 0.53,
            // width: MediaQuery.of(context).size.width * 0.,
            studentAssessmentInfo: studentAssessmentInfo,
            profileData: null,
            isUserInfoPop: false,
          );
        });
  }

//--------------------------------------------------------------------------------------------------------------------------
  Widget infoWidget() {
    return IconButton(
      padding: EdgeInsets.only(top: 2),
      onPressed: () async {
        List<StudentAssessmentInfo> list =
            await OcrUtility.getSortedStudentInfoList(
                tableName: widget.assessmentDetailPage == true
                    ? 'history_student_info'
                    : 'student_info');
        _showPopUp(
          studentAssessmentInfo: list.first,
        );
      },
      icon: Icon(Icons.info,
          size: Globals.deviceType == 'tablet' ? 35 : null, color: Colors.grey

          //  Color(0xff000000) != Theme.of(context).backgroundColor
          //     ? Color(0xff111C20)
          //     : Color(0xffF7F8F9), //Colors.grey.shade400,
          ),
    );
  }

//--------------------------------------------------------------------------------------------------------------------------
  Future<String> _getPointPossible({required String tableName}) async {
    List<StudentAssessmentInfo> studentInfo =
        await OcrUtility.getSortedStudentInfoList(tableName: tableName);
    return studentInfo.first.pointPossible ?? '2';
  }

//--------------------------------------------------------------------------------------------------------------------------
  // Custom Slidable Widget use to translation wrapping issue
  Widget customSlidableDecorationWidget(
      {required String label, required IconData icon}) {
    final children = <Widget>[];

    children.add(
      Icon(icon),
    );

    children.add(
      SizedBox(height: 4),
    );

    children.add(
      TranslationWidget(
          message: label,
          fromLanguage: "en",
          toLanguage: Globals.selectedLanguage,
          builder: (translatedMessage) {
            return Text(
              translatedMessage,
              overflow: TextOverflow.ellipsis,
            );
          }),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...children.map(
          (child) => Flexible(
            child: child,
          ),
        )
      ],
    );
  }

//--------------------------------------------------------------------------------------------------------------------------
  updateAssessmentToDb() async {
    Utility.updateAssessmentToDb(
      studentInfoList: await OcrUtility.getSortedStudentInfoList(
          tableName: widget.assessmentDetailPage == true
              ? 'history_student_info'
              : 'student_info'),
      assessmentId: Globals.currentAssessmentId,
    );
  }

/*--------------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------performScanMore-----------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------*/
  void performScanMore() async {
    String scanMoreLogMsg =
        'Scan more button pressed from ${widget.assessmentDetailPage == true ? "Assessment History Detail Page" : "Result Summary"}';
//--------------------------------------------------------------------------
    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        scanMoreLogMsg.toLowerCase().replaceAll(" ", "_") ?? '');
    PlusUtility.updateLogs(
        activityType: 'GRADED+',
        userType: 'Teacher',
        activityId: '22',
        sessionId:
            widget.assessmentDetailPage == true ? widget.obj!.sessionId : '',
        description: scanMoreLogMsg,
        operationResult: 'Success');
//--------------------------------------------------------------------------

    if (widget.obj != null && widget.obj!.isCreatedAsPremium == "true") {
      createdAsPremium = true;
    }
    String pointPossible = await _getPointPossible(
        tableName: widget.assessmentDetailPage == true
            ? 'history_student_info'
            : 'student_info');
//--------------------------------------------------------------------------

    Fluttertoast.cancel();
    print('Result Summery mcq updated         ${widget.isMcqSheet}');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GradedPlusCameraScreen(
                titleIconData: widget.titleIconData,
                lastAssessmentLength: lastAssessmentLength,
                assessmentName: widget.assessmentName,
                isMcqSheet: isMcqSheet, // widget.isMcqSheet ?? false,
                selectedAnswer: selectedAnswer, //widget.selectedAnswer,
                isFlashOn: ValueNotifier<bool>(false),
                questionImageLink: questionImageUrl,
                obj: widget.obj,
                noNewScan: widget.assessmentDetailPage!,
                isFromHistoryAssessmentScanMore: widget.assessmentDetailPage!,
                onlyForPicture: false,
                isScanMore: true,
                // lastStudentInfoLength: Globals.studentInfo!.length,
                pointPossible: pointPossible != null && pointPossible.isNotEmpty
                    ? pointPossible.replaceAll(' ', '')
                    : '2')));
  }

/*--------------------------------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------_initState-------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------*/
  Future<void> _initState() async {
    if (widget.assessmentDetailPage!) {
      // GoogleClassroomOverrides.studentAssessmentAndClassroomObj = GoogleClassroomCourses();
      await _historystudentAssessmentInfoDb.clear();
      if (widget.historySecondTime == true) {
        widget.assessmentName = Globals.historyAssessmentName;
        widget.fileId = Globals.historyAssessmentFileId;
      } else {
        Globals.historyAssessmentName = '';
        Globals.historyAssessmentFileId = '';
        Globals.historyAssessmentName = widget.assessmentName;
        Globals.historyAssessmentFileId = widget.fileId;
      }

      _driveBloc
          .add(GetAssessmentDetail(fileId: widget.fileId, nextPageUrl: ''));

      if (Overrides.STANDALONE_GRADED_APP) {
        _ocrBloc.add(GetAssessmentAndSavedStudentResultSummaryForStandaloneApp(
            fileId: widget.fileId,
            assessmentObj:
                GoogleClassroomOverrides.studentAssessmentAndClassroomObj));
      } else {
        _ocrBloc.add(GetAssessmentAndSavedStudentResultSummaryForStandardApp(
            fileId: widget.fileId,
            assessmentObj: GoogleClassroomOverrides
                .historyStudentResultSummaryForStandardApp));
      }

      // _driveBloc3.add(GetShareLink(fileId: widget.fileId, slideLink: true));
    } else {
      updateAssessmentToDb();

      widget.shareLink = Globals.shareableLink;
      iconsList = Globals.ocrResultIcons;
      iconsName = Globals.ocrResultIconsName;

      _method();
      if (Overrides.STANDALONE_GRADED_APP) {
        classroomUrlStatus.value = true;
      }
    }
  }

/*--------------------------------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------fabButton--------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------*/
  Widget fabButton(
    BuildContext context,
  ) =>
      !widget.assessmentDetailPage!
          ? buildScanMoreAndShareFabButton()
          : ValueListenableBuilder(
              valueListenable: isSuccessStateReceived,
              child: Container(),
              builder: (BuildContext context, bool value, Widget? child) {
                return isSuccessStateReceived.value == true
                    ? buildScanMoreAndShareFabButton()
                    : Container();
              });

//--------------------------------------------------------------------------------------------------------------------------
  Future<void> _saveAndShareBottomSheetMenu() async {
    showModalBottomSheet(
        // clipBehavior: Clip.antiAliasWithSaveLayer,
        useRootNavigator: true,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        // animationCurve: Curves.easeOutQuart,
        elevation: 10,
        context: context,
        builder: (BuildContext context) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return GradedPlusResultOptionBottomSheet(
                assessmentDetailPage: widget.assessmentDetailPage!,
                height: MediaQuery.of(context).size.height * 0.45,

                //  getURlForResultSummaryIcons: getURlForBottomIcons,
                //  resultSummaryIconsOnTap: bottomIconsOnTap,
                resultSummaryIconsModalList: Overrides.STANDALONE_GRADED_APP
                    ? ResultSummaryIcons
                        .standAloneHistoryResultSummaryIconsModalList
                    : ResultSummaryIcons.resultSummaryIconsModalList,

                allUrls: {
                  'Share': widget.shareLink == null || widget.shareLink == ''
                      ? Globals.shareableLink ?? ''
                      : widget.shareLink ?? '',
                  // 'Drive': Globals.googleDriveFolderPath ?? '',
                  'History': 'History',
                  'Dashboard': Globals.appSetting.dashboardUrlC == null
                      ? 'https://www.${Globals.schoolDbnC}.com/'
                      : Globals.appSetting.dashboardUrlC!, //'Dashboard',
                  'Slides': !widget.assessmentDetailPage!
                      ? Globals.googleSlidePresentationLink ?? ''
                      : OcrOverrides
                              .gradedPlusHistoryAssignmentGooglePresentationLink ??
                          "",
                  'Sheets': widget.shareLink == null || widget.shareLink == ''
                      ? Globals.shareableLink ?? ''
                      : widget.shareLink ?? '',

                  'Class': widget.assessmentDetailPage != true
                      ? GoogleClassroomOverrides
                              .recentStudentResultSummaryForStandardApp
                              .courseWorkURL ??
                          ''
                      : GoogleClassroomOverrides
                              .historyStudentResultSummaryForStandardApp
                              .courseWorkURL ??
                          '',
                },
              );
            },
          );
        });
  }

//--------------------------------------------------------------------------------------------------------------------------
  Row buildScanMoreAndShareFabButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 60,
        ),
        GradedPlusCustomFloatingActionButton(
          title: 'Scan More',
          icon: Icon(
            Icons.add,
            color: Theme.of(context).backgroundColor,
          ),
          isExtended: true,
          onPressed: () async {
            if (Overrides.STANDALONE_GRADED_APP) {
              List<GoogleClassroomCourses> _localData =
                  await _googleClassRoomlocalDbForStandAlone.getData();
              if (_localData.isEmpty) {
                Utility.currentScreenSnackBar(
                    "You need to import roster first", null);
                return;
              }
            }
            // print('perform scan more');
            performScanMore();
          },
          heroTag: 'scan_more_tag',
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: PlusCustomFloatingActionButton(
            onPressed: _saveAndShareBottomSheetMenu,
          ),
        )
      ],
    );
  }
}
