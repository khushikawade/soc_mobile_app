// ignore_for_file: must_be_immutable

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/google_classroom_globals.dart';
import 'package:Soc/src/modules/google_classroom/modal/google_classroom_courses.dart';
import 'package:Soc/src/modules/google_classroom/ui/graded_landing_page.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/result_action_icon_modal.dart';
import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/ocr/ui/list_assessment_summary.dart';
import 'package:Soc/src/modules/ocr/ui/camera_screen.dart';
import 'package:Soc/src/modules/ocr/widgets/common_popup.dart';
import 'package:Soc/src/modules/ocr/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/widgets/edit_bottom_sheet.dart';
import 'package:Soc/src/modules/ocr/widgets/ocr_background_widget.dart';
import 'package:Soc/src/modules/ocr/widgets/user_profile.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/image_popup.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import '../../../../services/Strings.dart';
import '../../../../widgets/empty_container_widget.dart';
import '../../../google_classroom/bloc/google_classroom_bloc.dart';
import '../../../google_drive/model/user_profile.dart';
import '../../bloc/ocr_bloc.dart';
import '../../modal/user_info.dart';

class ResultsSummary extends StatefulWidget {
  ResultsSummary(
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
      this.isMcqSheet = false,
      this.selectedAnswer})
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
  @override
  State<ResultsSummary> createState() => studentRecordList();
}

class studentRecordList extends State<ResultsSummary> {
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

  final editingStudentNameController = TextEditingController();
  final editingStudentIdController = TextEditingController();
  final studentScoreController = TextEditingController();
  String? pointPossible;

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
  GoogleDriveBloc _driveBloc3 = GoogleDriveBloc();
  final ValueNotifier<bool> isShareLinkReceived = ValueNotifier<bool>(false);
  LocalDatabase<GoogleClassroomCourses> _googleClassRoomlocalDb =
      LocalDatabase(Strings.googleClassroomCoursesList);

  GoogleClassroomBloc _googleClassroomBloc = new GoogleClassroomBloc();
  final ValueNotifier<bool> classroomUrlStatus = ValueNotifier<bool>(false);
  @override
  void initState() {
    _futureMethod();
    _initState();

    _scrollController.addListener(_scrollListener);

    super.initState();

    FirebaseAnalyticsService.addCustomAnalyticsEvent("results_summary");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'results_summary', screenClass: 'ResultsSummary');
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {
      _scrollListener();
    });
    // TODO: implement dispose
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          CommonBackGroundImgWidget(),
          Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.transparent,
            appBar: CustomOcrAppBarWidget(
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
                                  fontSize: 18,
                                ));
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
                        Utility.updateLogs(
                            activityId: '19',
                            description: assignmentCompletedLogMsg,
                            operationResult: 'Success');
                        Fluttertoast.cancel();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    Overrides.STANDALONE_GRADED_APP == true
                                        ? GradedLandingPage()
                                        : HomePage(
                                            isFromOcrSection: true,
                                          )),
                            (_) => false);
                        // onFinishedPopup();
                      })),
              isResultScreen: true,
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SpacerWidget(_KVerticalSpace * 0.40),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 5,
                    ), //EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Utility.textWidget(
                            text: 'Results Summary',
                            context: context,
                            textTheme: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontWeight: FontWeight.bold)),
                        ValueListenableBuilder(
                            valueListenable: isGoogleSheetStateReceived,
                            builder: (BuildContext context, bool value,
                                Widget? child) {
                              return ValueListenableBuilder(
                                  valueListenable: assessmentCount,
                                  builder: (BuildContext context, int value,
                                      Widget? child) {
                                    return FutureBuilder(
                                        future: Utility.getStudentInfoList(
                                            tableName:
                                                widget.assessmentDetailPage ==
                                                        true
                                                    ? 'history_student_info'
                                                    : 'student_info'),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<
                                                    List<StudentAssessmentInfo>>
                                                snapshot) {
                                          // if (snapshot.connectionState ==
                                          //     ConnectionState.waiting) {
                                          //   return Globals.isAndroid!
                                          //       ? Container(
                                          //           width: 10,
                                          //           height: 10,
                                          //           child:
                                          //               CircularProgressIndicator(
                                          //                   color: Theme.of(
                                          //                           context)
                                          //                       .colorScheme
                                          //                       .primaryVariant,
                                          //                   strokeWidth: 2))
                                          //       : CupertinoActivityIndicator();
                                          // }
                                          if (snapshot.hasData &&
                                                  widget.assessmentDetailPage ==
                                                      true
                                              ? isGoogleSheetStateReceived.value
                                              : !isGoogleSheetStateReceived
                                                  .value) {
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
                                                          style:
                                                              Theme.of(context)
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
                                          // Padding(
                                          //   padding: EdgeInsets.only(top: 10),
                                          //   child: ShimmerLoading(
                                          //     isLoading: true,
                                          //     child: Container(
                                          //       decoration: BoxDecoration(
                                          //           color: Colors.white,
                                          //           borderRadius:
                                          //               BorderRadius.all(
                                          //                   Radius.circular(
                                          //                       40))),
                                          //       // height: 15,
                                          //       // width: 15,

                                          //       child: CircleAvatar(
                                          //         radius: 10,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // );

                                          // Globals.isAndroid!
                                          //     ? Container(
                                          //         width: 10,
                                          //         height: 10,
                                          //         child:
                                          //             CircularProgressIndicator(
                                          //                 color: Theme.of(
                                          //                         context)
                                          //                     .colorScheme
                                          //                     .primaryVariant,
                                          //                 strokeWidth: 2))
                                          //     : CupertinoActivityIndicator();
                                        });
                                  });
                            }),
                      ],
                    ),
                  ),
                  // SpacerWidget(_KVerticalSpace / 5),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.09,
                    child: ValueListenableBuilder(
                      valueListenable: infoIconValue,
                      builder:
                          (BuildContext context, bool value, Widget? child) {
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
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    child: Utility.textWidget(
                                        text: widget.assessmentName == null
                                            ? 'Assessment Name'
                                            : widget.assessmentName!,
                                        context: context,
                                        maxLines: 2,
                                        textAlign: TextAlign.left,
                                        textTheme: Theme.of(context)
                                            .textTheme
                                            .headline2!),
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
                  // SpacerWidget(_KVerticalSpace / 5),
                  !widget.assessmentDetailPage!
                      ? Expanded(
                          child: ListView(
                            children: [
                              resultTitle(),
                              ValueListenableBuilder(
                                  valueListenable: assessmentCount,
                                  builder: (BuildContext context, int listCount,
                                      Widget? child) {
                                    return FutureBuilder(
                                        future: Utility.getStudentInfoList(
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
                                  }),
                              BlocListener<GoogleDriveBloc, GoogleDriveState>(
                                  bloc: _driveBloc2,
                                  child: Container(),
                                  listener: (context, state) async {
                                    // if (state is GoogleDriveLoading) {
                                    //   Utility.showLoadingDialog(
                                    //       context: context, isOCR: true);
                                    // }

                                    if (state is GoogleSuccess) {
                                      if (Overrides.STANDALONE_GRADED_APP) {
                                        _googleClassroomBloc.add(
                                            CreateClassRoomCourseWork(
                                                isEditStudentInfo: true,
                                                studentAssessmentInfoDb:
                                                    LocalDatabase(
                                                        'student_info'),
                                                studentClassObj:
                                                    GoogleClassroomGlobals
                                                        .studentAssessmentAndClassroomObj,
                                                title: Globals.assessmentName!,
                                                pointPossible:
                                                    Globals.pointPossible ??
                                                        "0"));
                                      } else {
                                        Navigator.of(context).pop();
                                      }
                                    }
                                    if (state is ErrorState) {
                                      if (state.errorMsg ==
                                          'ReAuthentication is required') {
                                        await Utility
                                            .refreshAuthenticationToken(
                                                isNavigator: true,
                                                errorMsg: state.errorMsg!,
                                                context: context,
                                                scaffoldKey: scaffoldKey);

                                        _driveBloc2.add(UpdateDocOnDrive(
                                          isMcqSheet:
                                              widget.isMcqSheet ?? false,
                                          // questionImage:
                                          //     questionImageUrl ?? "NA",
                                          createdAsPremium: createdAsPremium,
                                          assessmentName:
                                              Globals.assessmentName!,
                                          fileId: Globals.googleExcelSheetId,
                                          isLoading: true,
                                          studentData:
                                              //list2
                                              await Utility.getStudentInfoList(
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
                          builder:
                              (BuildContext contxt, GoogleDriveState state) {
                            if (state is GoogleDriveLoading2) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
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
                                    children: [
                                      resultTitle(),
                                      FutureBuilder(
                                          future: Utility.getStudentInfoList(
                                              tableName:
                                                  widget.assessmentDetailPage ==
                                                          true
                                                      ? 'history_student_info'
                                                      : 'student_info'),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<
                                                      List<
                                                          StudentAssessmentInfo>>
                                                  snapshot) {
                                            if (snapshot.hasData) {
                                              if (snapshot.data!.length != 0) {
                                                questionImageUrl = snapshot
                                                    .data![0].questionImgUrl;
                                              }
                                              // updateAssessmentToDb(
                                              //     studentInfoList:
                                              //         snapshot.data);
                                              return listView(snapshot.data!);
                                            }
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.5,
                                              child: Center(
                                                  child: Globals.isAndroid!
                                                      ? CircularProgressIndicator(
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .primaryVariant,
                                                        )
                                                      : CupertinoActivityIndicator(
                                                          color: Theme.of(
                                                                  context)
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
                                return Column(
                                  children: [
                                    resultTitle(),
                                    listView(
                                      state.obj,
                                    )
                                  ],
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
                          listener: (BuildContext contxt,
                              GoogleDriveState state) async {
                            if (state is AssessmentDetailSuccess) {
                              //Fetching excel sheet records and its length
                              if (state.obj.length > 0) {
                                // await _historystudentAssessmentInfoDb.clear();

                                //Mark student that are already saved to google classroom
                                state.obj.forEach((e) async {
                                  if ((GoogleClassroomGlobals
                                              .studentAssessmentAndClassroomObj
                                              ?.courseId
                                              ?.isNotEmpty ??
                                          false) &&
                                      (GoogleClassroomGlobals
                                              .studentAssessmentAndClassroomObj
                                              ?.courseWorkId
                                              ?.isNotEmpty ??
                                          false)) {
                                    e.isgoogleClassRoomStudentProfileUpdated =
                                        true;
                                  }
                                  await _historystudentAssessmentInfoDb
                                      .addData(e);
                                });

                                //Extract presentation url from the excel sheet
                                if (state.obj[0]
                                            .googleSlidePresentationURL !=
                                        'NA' &&
                                    state.obj[0].googleSlidePresentationURL !=
                                        null &&
                                    state.obj[0].googleSlidePresentationURL!
                                        .isNotEmpty) {
                                  Globals.googleSlidePresentationId = state
                                      .obj[0].googleSlidePresentationURL!
                                      .split('/')[5];
                                } else {
                                  Globals.googleSlidePresentationId = 'NA';
                                }

                                if (state.obj[0].answerKey != '' &&
                                    state.obj[0].answerKey != 'NA' &&
                                    state.obj[0].answerKey != null) {
                                  widget.isMcqSheet = true;
                                  widget.selectedAnswer =
                                      state.obj[0].answerKey;
                                }
                                Globals.googleSlidePresentationLink =
                                    state.obj[0].googleSlidePresentationURL;
                                savedRecordCount != null
                                    ? savedRecordCount == state.obj.length
                                        ? dashboardState.value = 'Success'
                                        : dashboardState.value = ''
                                    : print("");

                                sheetRubricScore =
                                    state.obj.first.scoringRubric;
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
                              _googleClassroomBloc.add(
                                  GetClassroomCourseWorkURL(
                                      obj: GoogleClassroomGlobals
                                          .studentAssessmentAndClassroomObj));
                            } else if (state is ErrorState) {
                              if (state.errorMsg ==
                                  'ReAuthentication is required') {
                                await Utility.refreshAuthenticationToken(
                                    isNavigator: false,
                                    errorMsg: state.errorMsg!,
                                    context: context,
                                    scaffoldKey: scaffoldKey);

                                _driveBloc.add(GetAssessmentDetail(
                                    fileId: widget.fileId, nextPageUrl: ''));
                              } else {
                                Navigator.of(context).pop();
                                Utility.currentScreenSnackBar(
                                    "Something Went Wrong. Please Try Again.",
                                    null);
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
                            Utility.updateLogs(
                                // accountType: 'Free',
                                activityId: '14',
                                description: 'Save to dashboard success',
                                operationResult: 'Success');
                            List<StudentAssessmentInfo> studentInfo =
                                await Utility.getStudentInfoList(
                                    tableName:
                                        widget.assessmentDetailPage == true
                                            ? 'history_student_info'
                                            : 'student_info');

                            studentInfo.asMap().forEach((index, element) async {
                              StudentAssessmentInfo element =
                                  studentInfo[index];
                              //Disabling all the existing records edit functionality. Only scan more records will be allowed to edit.
                              if (element.isSavedOnDashBoard == null) {
                                element.isSavedOnDashBoard = true;
                              }
                              await _studentAssessmentInfoDb.putAt(
                                  index, element);
                            });

                            List list = await Utility.getStudentInfoList(
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
                          if (state is AssessmentDashboardStatus) {
                            if (state
                                    .assessmentObj?.assessmentCId?.isNotEmpty ??
                                false) {
                              List list = await Utility.getStudentInfoList(
                                  tableName: 'history_student_info');

                              if (isGoogleSheetStateReceived.value == true) {
                                state.resultRecordCount == list.length
                                    ? dashboardState.value = 'Success'
                                    : dashboardState.value = '';
                              }

                              if (Overrides.STANDALONE_GRADED_APP) {
                                List<GoogleClassroomCourses>
                                    _googleClassroomCourseslocalData =
                                    await _googleClassRoomlocalDb.getData();

                                for (GoogleClassroomCourses element
                                    in _googleClassroomCourseslocalData) {
                                  if (element.courseId ==
                                      state.assessmentObj!.courseId) {
                                    //update the classroom course work id in GoogleClassroomGlobals obj
                                    element.courseWorkId =
                                        state.assessmentObj!.courseWorkId!;

                                    GoogleClassroomGlobals
                                            .studentAssessmentAndClassroomObj =
                                        element;

                                    break;
                                  }
                                }
                              }

                              savedRecordCount = state.resultRecordCount;
                              GoogleClassroomGlobals
                                      .studentAssessmentAndClassroomObj
                                      .assessmentCId =
                                  historyAssessmentId =
                                      state.assessmentObj!.assessmentCId;
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
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!widget.assessmentDetailPage!) _scanFloatingWidget(),
                SpacerWidget(10),
                !widget.assessmentDetailPage!
                    ? _bottomButtons(context, iconsList, iconsName,
                        webContentLink: Globals.googleDriveFolderPath ?? '')
                    : ValueListenableBuilder(
                        valueListenable: isSuccessStateReceived,
                        child: Container(),
                        builder:
                            (BuildContext context, bool value, Widget? child) {
                          return isSuccessStateReceived.value == true
                              ? Column(
                                  children: [
                                    _scanFloatingWidget(),
                                    SpacerWidget(10),
                                    _bottomButtons(
                                        context, iconsList, iconsName,
                                        webContentLink: webContentLink!),
                                  ],
                                )
                              : Container();
                        }),
                BlocListener(
                  child: Container(),
                  bloc: _driveBloc3,
                  listener: (context, state) async {
                    if (state is ShareLinkReceived) {
                      //   print("LINK RECIVED -------------->");
                      if (!widget.assessmentDetailPage!) {
                        Globals.shareableLink = state.shareLink;
                      }
                      isShareLinkReceived.value = true;
                      widget.shareLink = state.shareLink;
                    }

                    if (state is ErrorState) {
                      if (state.errorMsg == 'ReAuthentication is required') {
                        await Utility.refreshAuthenticationToken(
                            isNavigator: false,
                            errorMsg: state.errorMsg!,
                            context: context,
                            scaffoldKey: scaffoldKey);

                        _driveBloc.add(GetShareLink(
                            fileId: widget.fileId, slideLink: false));
                      } else {
                        // Navigator.of(context).pop();
                        Utility.currentScreenSnackBar(
                            "Something Went Wrong. Please Try Again.", null);
                      }
                    }
                  },
                )
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
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
                    await Utility.refreshAuthenticationToken(
                        isNavigator: true,
                        errorMsg: state.errorMsg!,
                        context: context,
                        scaffoldKey: scaffoldKey);

                    _googleClassroomBloc.add(CreateClassRoomCourseWork(
                        isEditStudentInfo: true,
                        studentAssessmentInfoDb: LocalDatabase('student_info'),
                        studentClassObj: GoogleClassroomGlobals
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
                    print(state.classroomCouseWorkURL);
                    Utility.currentScreenSnackBar(
                        "Please check your internet connection and try again",
                        null);
                  }

                  GoogleClassroomGlobals.studentAssessmentAndClassroomObj
                      .courseWorkURL = state.classroomCouseWorkURL ?? '';
                  classroomUrlStatus.value = true;
                }
              })
        ],
      ),
    );
  }

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
                    ? MediaQuery.of(context).size.height * 0.55
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

  Widget _scanFloatingWidget() {
    return ValueListenableBuilder<bool>(
        valueListenable: isScrolling,
        child: Container(),
        builder: (BuildContext context, bool value, Widget? child) {
          return Container(
            //margin: EdgeInsets.only(left: 15),
            alignment: Alignment.center,
            // width: isScrolling.value ? null : 130,
            child: FloatingActionButton.extended(
                isExtended: !isScrolling.value,
                backgroundColor: AppTheme.kButtonColor,
                onPressed: () async {
                  if (Overrides.STANDALONE_GRADED_APP) {
                    List<GoogleClassroomCourses> _localData =
                        await _googleClassRoomlocalDb.getData();
                    if (_localData.isEmpty) {
                      Utility.currentScreenSnackBar(
                          "You need to import roster first", null);
                      return;
                    }
                  }
                  // print('perform scan more');
                  performScanMore();
                },
                icon: Icon(
                    IconData(0xe875,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color: Theme.of(context).backgroundColor,
                    size: 16),
                label: Utility.textWidget(
                    text: isScrolling.value ? '' : 'Scan More',
                    context: context,
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(color: Theme.of(context).backgroundColor))),
          );
        });
  }

  Widget _bottomButtons(context, List iconsList, List iconName,
      {required String webContentLink}) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor == Color(0xff000000)
                ? Color(0xff162429)
                : Color(0xffF7F8F9),
            // color: Theme.of(context).backgroundColor,
            boxShadow: [
              new BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                blurRadius: 20.0,
              ),
            ],
            borderRadius: BorderRadius.circular(4)),
        margin: widget.assessmentDetailPage!
            ? EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.15,
                right: MediaQuery.of(context).size.width * 0.15)
            : !widget.assessmentDetailPage!
                ? EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.0,
                    right: MediaQuery.of(context).size.width * 0.0)
                : Globals.deviceType == 'tablet'
                    ? EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.03)
                    : null,
        padding: Globals.deviceType == 'tablet'
            ? EdgeInsets.symmetric(horizontal: 20)
            : EdgeInsets.symmetric(horizontal: 8),
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height * 0.086
            : MediaQuery.of(context).size.width * 0.086,
        width:
            //  Overrides.STANDALONE_GRADED_APP == true
            //     ? (widget.assessmentDetailPage == true
            //         ? MediaQuery.of(context).size.width * 0.5
            //         : MediaQuery.of(context).size.width * 0.7)
            //  :
            widget.assessmentDetailPage!
                ? MediaQuery.of(context).size.width * 0.7
                : MediaQuery.of(context).size.width * 0.9,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: Overrides.STANDALONE_GRADED_APP
              ? widget.assessmentDetailPage!
                  ? BottomIcon.standAloneHistoryBottomIconModalList
                      .map<Widget>((element) => bottomIcon(element))
                      .toList()
                  : BottomIcon.standAloneBottomIconModalList
                      .map<Widget>((element) => bottomIcon(element))
                      .toList()
              : widget.assessmentDetailPage!
                  ? BottomIcon.historybottomIconModalList
                      .map<Widget>((element) => bottomIcon(element))
                      .toList()
                  : BottomIcon.bottomIconModalList
                      .map<Widget>((element) => bottomIcon(element))
                      .toList(),
        ));
  }

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
                                  builder: (context) => AssessmentSummary(
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

  getGoogleFolderPath() async {
    List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();
    Utility.showSnackBar(scaffoldKey,
        "Unable To Navigate At The Moment. Please Try Again.", context, null);

    _driveBloc.add(GetDriveFolderIdEvent(
        isFromOcrHome: false,
        //  filePath: file,
        token: _profileData[0].authorizationToken,
        folderName: "SOLVED GRADED+",
        refreshToken: _profileData[0].refreshToken));
  }

  performEditAndDelete(BuildContext context, int index, bool? edit) async {
    List<StudentAssessmentInfo> studentInfo =
        await Utility.getStudentInfoList(tableName: 'student_info');
    if (edit!) {
      String editingLogMsg = "Teacher edited the record";

      FirebaseAnalyticsService.addCustomAnalyticsEvent(
          editingLogMsg.toLowerCase().replaceAll(" ", "_") ?? '');
      Utility.updateLogs(
          // ,
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

  editBottomSheet(
      {required TextEditingController controllerOne,
      required TextEditingController controllerTwo,
      required TextEditingController controllerThree,
      required int index,
      required String pointPossible,
      required String answerKey,
      required String studentSelection}) {
    showModalBottomSheet(
        clipBehavior: Clip.antiAliasWithSaveLayer,
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
                  : 'Student Id/Student Email',
              textFileTitleThree:
                  //   widget.isMcqSheet == true
                  // ? "Student Selection"
                  // /// : "Student Grade",
                  // :
                  'Points Earned',
              isSubjectScreen: false,
              update: (
                  {required TextEditingController name,
                  required TextEditingController id,
                  required TextEditingController score,
                  String? studentResonance}) async {
                List<StudentAssessmentInfo> _list =
                    await Utility.getStudentInfoList(tableName: 'student_info');
                StudentAssessmentInfo studentInfo = _list[index];

                studentInfo.studentName = name.text;
                studentInfo.studentId = id.text;
                studentInfo.studentGrade = score.text;
                studentInfo.studentResponseKey = studentResonance;
                studentInfo.isgoogleClassRoomStudentProfileUpdated = false;
                _studentAssessmentInfoDb.putAt(index, studentInfo);
                assessmentCount.value = _list.length;

                await _futureMethod();
                _method();
                disableSlidableAction.value = true;
                Navigator.pop(context, false);
                Utility.showLoadingDialog(context: context, isOCR: true);
                _driveBloc2.add(UpdateDocOnDrive(
                  isMcqSheet: widget.isMcqSheet ?? false,
                  // questionImage: questionImageUrl ?? "NA",
                  createdAsPremium: Globals.isPremiumUser,
                  assessmentName: Globals.assessmentName!,
                  fileId: Globals.googleExcelSheetId,
                  isLoading: true,
                  studentData:
                      //list2
                      await Utility.getStudentInfoList(
                          tableName: 'student_info'),
                ));

//to update the slides details .
                _driveBloc.add(EditSlideFromPresentation(
                    slidePresentationId: Globals.googleSlidePresentationId,
                    studentAssessmentInfo: studentInfo));

                // assessmentCount.value = await Utility.getStudentInfoListLength(
                //           tableName: 'student_info');
                // studentRecordList.value = Utility.getStudentInfoList(
                //           tableName: 'student_info');
              },
            ));
  }

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
                              await Utility.getStudentInfoList(
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

                          Utility.updateLogs(
                              activityId: '17',
                              description: deleteRecordLogMsg,
                              operationResult: 'Success');

                          // List _list = await Utility.getStudentInfoList(
                          //     tableName: 'student_info');
                          assessmentCount.value = _list.length - 1;
                          await _futureMethod();
                          _method();
                          // studentRecordList.value = Globals.studentInfo!;
                          Navigator.pop(
                            context,
                          );
                          Utility.showLoadingDialog(
                              context: context, isOCR: true);
                          _driveBloc2.add(UpdateDocOnDrive(
                              isMcqSheet: widget.isMcqSheet,
                              // questionImage: questionImageUrl ?? "NA",
                              createdAsPremium: Globals.isPremiumUser,
                              assessmentName: Globals.assessmentName!,
                              fileId: Globals.googleExcelSheetId,
                              isLoading: true,
                              studentData: await Utility.getStudentInfoList(
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

  Future _method() async {
    List list = await Utility.getStudentInfoList(tableName: 'student_info');
    assessmentCount.value = list.length;

    if (Globals.scanMoreStudentInfoLength != null) {
      if (list.length == Globals.scanMoreStudentInfoLength) {
        dashboardState.value = 'Success';
      }
    }
  }

  Future<void> _futureMethod() async {
    _listCount.value =
        await Utility.getStudentInfoListLength(tableName: 'student_info');
  }

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
            await Utility.refreshAuthenticationToken(
                isNavigator: false,
                errorMsg: state.errorMsg!,
                context: context,
                scaffoldKey: scaffoldKey);

            _driveBloc
                .add(GetShareLink(fileId: widget.fileId, slideLink: false));
          } else {
            Navigator.of(context).pop();
            Utility.currentScreenSnackBar(
                "Something Went Wrong. Please Try Again.", null);
          }
        }
      },
    );
  }

  Widget detailPageActionButtons(iconName, index) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      //UNCOMMENT
      //  color: Colors.black,
      child: IconButton(
          padding: EdgeInsets.zero,
          icon: iconsName[index] == 'Share' &&
                  !widget.assessmentDetailPage! &&
                  widget.isScanMore == null
              ? detailsPageActionWithDashboard(index)
              : detailPageActionsWithoutDashboard(index: index),
          onPressed: () async {
            if (iconsName[index] == 'Share') {
              Utility.updateLogs(
                  activityId: '13',
                  sessionId: widget.assessmentDetailPage == true
                      ? widget.obj!.sessionId
                      : '',
                  description: widget.assessmentDetailPage == true
                      ? 'Share Button pressed from Assessment History Detail Page'
                      : 'Share Button pressed from Result Summary',
                  operationResult: 'Success');
              widget.shareLink != null && widget.shareLink!.isNotEmpty
                  ? Share.share(widget.shareLink!)
                  : print("no link ");
            } else if (iconsName[index] == 'History') {
              Utility.updateLogs(
                  activityId: '15',
                  description: 'History Assesment button pressed',
                  operationResult: 'Success');

              _showDataSavedPopup(
                  historyAssessmentSection: true,
                  title: 'Action Required',
                  msg:
                      'If you navigate to the history section, You will not be able to return back to the current screen. \n\nDo you still want to move forward?',
                  noActionText: 'No',
                  yesActionText: 'Yes, Take Me There');
            } else if ((iconName[index] == 'Sheet' ||
                    iconName[index] == 'Dashboard') &&
                dashboardState.value == '') {
              if (Overrides.STANDALONE_GRADED_APP == true) {
                if (widget.shareLink == null) {
                  Utility.currentScreenSnackBar('Please Wait', null,
                      marginFromBottom: 90);
                } else {
                  await Utility.launchUrlOnExternalBrowser(widget.shareLink!);
                }

                return;
              }

              if (Globals.isPremiumUser) {
                if (widget.assessmentDetailPage == true &&
                    widget.createdAsPremium == false) {
                  Utility.updateLogs(
                      // ,
                      activityId: '14',
                      description:
                          'Oops! Teacher cannot save the assessment to the dashboard which was scanned before the premium account',
                      operationResult: 'Failed');
                  popupModal(
                      title: 'Data Not Saved',
                      message:
                          'Oops! You cannot save the Assignment to the dashboard which was scanned before the premium account. If you still want to save this to the Dashboard, Please rescan the Assignment.');
                  Globals.scanMoreStudentInfoLength =
                      await Utility.getStudentInfoListLength(
                              tableName: 'student_info') -
                          1;
                } else {
                  List list = await Utility.getStudentInfoList(
                      tableName: 'student_info');
                  if (widget.isScanMore == true &&
                      widget.assessmentListLength != null &&
                      widget.assessmentListLength! < list.length) {
                    Utility.updateLogs(
                        // accountType: 'Free',
                        activityId: '14',
                        description:
                            'Save to deshboard pressed in case for scanmore',
                        operationResult: 'Success');
                    //print(
                    // 'if     calling is scanMore -------------------------->');
                    //print(widget.assessmentListLenght);
                    _ocrBloc.add(SaveAssessmentToDashboard(
                        assessmentId: !widget.assessmentDetailPage!
                            ? Globals.currentAssessmentId
                            : historyAssessmentId ?? '',
                        assessmentSheetPublicURL: widget.shareLink,
                        resultList: await Utility.getStudentInfoList(
                            tableName: widget.assessmentDetailPage == true
                                ? 'history_student_info'
                                : 'student_info'),
                        previouslyAddedListLength: widget.assessmentListLength,
                        assessmentName: widget.assessmentName!,
                        rubricScore: widget.rubricScore ?? '',
                        subjectId: widget.subjectId ?? '',
                        schoolId: Globals.appSetting.schoolNameC!, //Account Id
                        // standardId: widget.standardId ?? '',
                        scaffoldKey: scaffoldKey,
                        context: context,
                        isHistoryAssessmentSection:
                            widget.assessmentDetailPage!));
                  } else {
                    //print(
                    // 'else      calling is noramal -------------------------->');
                    // Adding the non saved record of dashboard in the list
                    List<StudentAssessmentInfo> _listRecord = [];

                    if (widget.assessmentDetailPage! &&
                        savedRecordCount != null &&
                        historyRecordList.length != savedRecordCount!) {
                      _listRecord = historyRecordList.sublist(
                          savedRecordCount!, historyRecordList.length);
                    } else {
                      //
                      _listRecord = historyRecordList;
                    }

                    _ocrBloc.add(SaveAssessmentToDashboard(
                      assessmentId: !widget.assessmentDetailPage!
                          ? Globals.currentAssessmentId
                          : historyAssessmentId ?? '',
                      assessmentSheetPublicURL: widget.shareLink,
                      resultList: !widget.assessmentDetailPage!
                          ? await Utility.getStudentInfoList(
                              tableName: 'student_info')
                          : _listRecord,
                      assessmentName: widget.assessmentName!,
                      rubricScore: !widget.assessmentDetailPage!
                          ? widget.rubricScore ?? ''
                          : sheetRubricScore ?? '',
                      subjectId: widget.subjectId ?? '',
                      schoolId: Globals.appSetting.schoolNameC!, //Account Id
                      // standardId: widget.standardId ?? '',
                      scaffoldKey: scaffoldKey,
                      context: context,
                      isHistoryAssessmentSection: widget.assessmentDetailPage!,
                      fileId: widget.fileId ?? '',
                    ));
                  }
                }
              } else {
                Utility.updateLogs(
                    // ,
                    activityId: '14',
                    description:
                        'Free User tried to save the data to the dashboard',
                    operationResult: 'Failed');
                popupModal(
                    title: 'Upgrade To Premium',
                    message:
                        'This is a premium feature. To view a sample dashboard, click here: \nhttps://datastudio.google.com/u/0/reporting/75743c2d-5749-45e7-9562-58d0928662b2/page/p_79velk1hvc \n\nTo speak to SOLVED about obtaining the premium version of GRADED+, including a custom data Dashboard, email admin@solvedconsulting.com');
              }
              // }
            } else if (dashboardState.value == 'Success') {
              if (Overrides.STANDALONE_GRADED_APP == true) {
                if (widget.shareLink == null) {
                  Utility.currentScreenSnackBar('Please Wait', null,
                      marginFromBottom: 90);
                } else {
                  await Utility.launchUrlOnExternalBrowser(widget.shareLink!);
                }

                return;
              }
              popupModal(
                  title: 'Already Saved',
                  message:
                      'The data has already been saved to the data dashboard.');
            }
          }),
    );
  }

  Widget detailPageActionsWithoutDashboard({required int index}) {
    if (Overrides.STANDALONE_GRADED_APP == true &&
        iconsName[index] == 'Sheet') {
      return Container(
          height: 28,

          // margin: EdgeInsets.only(right: 15, bottom: 1),
          //padding: EdgeInsets.symmetric(vertical: 9),
          child: SvgPicture.asset(Strings.googleSheetIcon));
    } else {
      return Icon(
        IconData(
            (widget.assessmentDetailPage! ? index == 2 : index == 3) &&
                    dashboardState.value == 'Success'
                ? 0xe877
                : iconsList[index],
            fontFamily: Overrides.kFontFam,
            fontPackage: Overrides.kFontPkg),
        size: (widget.assessmentDetailPage! ? index == 2 : index == 3) &&
                dashboardState.value == ''
            ? Globals.deviceType == 'phone'
                ? 33
                : 55
            : Globals.deviceType == 'phone'
                ? 33
                : 48,
        color: iconsName[index] == 'History'
            ? AppTheme.kButtonbackColor
            : iconsName[index] == 'Share'
                ? AppTheme.kButtonColor
                : (widget.assessmentDetailPage! &&
                            index == 2 &&
                            isAssessmentAlreadySaved == 'YES') ||
                        (widget.assessmentDetailPage! &&
                            index == 2 &&
                            dashboardState.value == 'Success')
                    ? Colors.green
                    : index == 2 || (index == 3 && dashboardState.value == '')
                        ? Theme.of(context).backgroundColor == Color(0xff000000)
                            ? Colors.white
                            : Colors.black
                        : (widget.assessmentDetailPage!
                                    ? index == 2
                                    : index == 3) &&
                                dashboardState.value == 'Success'
                            ? Colors.green
                            : AppTheme.kButtonColor,
      );
    }
  }

  void _showPopUp({required StudentAssessmentInfo studentAssessmentInfo}) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return CustomDialogBox(
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

  Widget infoWidget() {
    return IconButton(
      padding: EdgeInsets.only(top: 2),
      onPressed: () async {
        List<StudentAssessmentInfo> list = await Utility.getStudentInfoList(
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

  Future<String> _getpointPossible({required String tableName}) async {
    List<StudentAssessmentInfo> studentInfo =
        await Utility.getStudentInfoList(tableName: tableName);
    return studentInfo.first.pointPossible ?? '2';
  }

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

  Widget _slidableDecorationWidget(
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

  updateAssessmentToDb() async {
    Utility.updateAssessmentToDb(
      studentInfoList: await Utility.getStudentInfoList(
          tableName: widget.assessmentDetailPage == true
              ? 'history_student_info'
              : 'student_info'),
      assessmentId: Globals.currentAssessmentId,
    );
  }

  Widget bottomIcon(BottomIcon element) {
    return Expanded(
      child: ValueListenableBuilder(
          valueListenable: classroomUrlStatus,
          child: Container(),
          builder: (BuildContext context, bool value, Widget? child) {
            return ValueListenableBuilder(
                valueListenable: isShareLinkReceived,
                child: Container(),
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return ValueListenableBuilder(
                      valueListenable: dashboardState,
                      child: Container(),
                      builder:
                          (BuildContext context, dynamic value, Widget? child) {
                        return Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //text building for all icons
                              Utility.textWidget(
                                  text: element.title!,
                                  context: context,
                                  textTheme: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(fontWeight: FontWeight.bold)),

                              //Loading indicator dashboard
                              if ((element.title == "Dashboard" &&
                                      dashboardState.value == "Loading") ||
                                  (element.title == "Share" &&
                                      !isShareLinkReceived.value) ||
                                  (element.title == "Class" &&
                                      !classroomUrlStatus.value))
                                Container(
                                    padding: EdgeInsets.all(3),
                                    width:
                                        Globals.deviceType == "phone" ? 28 : 50,
                                    height:
                                        Globals.deviceType == "phone" ? 28 : 50,
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(
                                      strokeWidth: MediaQuery.of(context)
                                              .size
                                              .shortestSide *
                                          0.005,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryVariant,
                                    ))

                              //Tick mark icons
                              else if (element.title == "Dashboard" &&
                                  dashboardState.value == "Success")
                                SvgPicture.asset(
                                    'assets/ocr_result_section_bottom_button_icons/Done.svg',
                                    width:
                                        Globals.deviceType == "phone" ? 28 : 50,
                                    height:
                                        Globals.deviceType == "phone" ? 28 : 50,
                                    color: AppTheme.kButtonColor)

                              //building all icons here
                              else
                                Builder(builder: (context) {
                                  String? url = getURlForBottomIcons(
                                      title: element.title ?? '');
                                  return Opacity(
                                    opacity: ((url?.isEmpty ?? true) ||
                                            (url == 'NA'))
                                        ? 0.3
                                        : 1.0,
                                    child: InkWell(
                                      child: SvgPicture.asset(element.svgPath!,
                                          width: Globals.deviceType == "phone"
                                              ? 28
                                              : 50,
                                          height: Globals.deviceType == "phone"
                                              ? 28
                                              : 50,
                                          color: Theme.of(context)
                                                          .backgroundColor ==
                                                      Color(0xff000000) &&
                                                  element.title == "Dashboard"
                                              ? Color(0xffF7F8F9)
                                              : null),
                                      onTap: (() async {
                                        _bottomIconsOnTap(
                                            title: element.title ?? '',
                                            url: url ?? '');
                                      }),
                                    ),
                                  );
                                }),
                            ]);
                      });
                });
          }),
    );
  }

  _bottomIconsOnTap({required String title, required String url}) async {
    switch (title) {
      case 'Share':
        String shareLogMsg =
            'Share Button pressed from ${widget.assessmentDetailPage == true ? "Assessment History Detail Page" : "Result Summary"}';
        FirebaseAnalyticsService.addCustomAnalyticsEvent(
            shareLogMsg.toLowerCase().replaceAll(" ", "_") ?? '');
        Utility.updateLogs(
            activityId: '13',
            sessionId: widget.assessmentDetailPage == true
                ? widget.obj!.sessionId
                : '',
            description: shareLogMsg,
            operationResult: 'Success');
        if ((url?.isNotEmpty ?? false) && (url != 'NA')) {
          Share.share(url);
        }
        break;

      // case 'Drive':
      //   String driveLogMsg =
      //       'Drive Button pressed from ${widget.assessmentDetailPage == true ? "Assessment History Detail Page" : "Result Summary"}';

      //   FirebaseAnalyticsService.addCustomAnalyticsEvent(
      //       driveLogMsg.toLowerCase().replaceAll(" ", "_") ?? '');
      //   Fluttertoast.cancel();
      //   Utility.updateLogs(
      //       activityId: '16',
      //       sessionId: widget.assessmentDetailPage == true
      //           ? widget.obj!.sessionId
      //           : '',
      //       description: driveLogMsg,
      //       operationResult: 'Success');
      //   // url != null
      //   //     ? Utility.launchUrlOnExternalBrowser(url)
      //   //     : getGoogleFolderPath();
      //   if ((url?.isNotEmpty ?? false) && (url != 'NA')) {
      //     Utility.launchUrlOnExternalBrowser(url);
      //   } else {
      //     getGoogleFolderPath();
      //   }
      //   break;
      case 'History':
        String historyLogMsg =
            'History Assessment button pressed from ${widget.assessmentDetailPage == true ? "Assessment History Detail Page" : "Result Summary"}';
        FirebaseAnalyticsService.addCustomAnalyticsEvent(
            historyLogMsg.toLowerCase().replaceAll(" ", "_") ?? '');
        Utility.updateLogs(
            activityId: '15',
            description: historyLogMsg,
            operationResult: 'Success');

        _showDataSavedPopup(
            historyAssessmentSection: true,
            title: 'Action Required',
            msg:
                'If you navigate to the history section, You will not be able to return back to the current screen. \n\nDo you still want to move forward?',
            noActionText: 'No',
            yesActionText: 'Yes, Take Me There');
        break;
      case 'Dashboard':
        if (Globals.isPremiumUser!) {
          if (widget.assessmentDetailPage == true &&
              widget.createdAsPremium == false) {
            String dashboardLogMsgNotPremiumAccount =
                'None premium assessment tried to save from premium account using scan more option from ${widget.assessmentDetailPage == true ? "Assessment History Detail Page" : "Result Summary"}';
            FirebaseAnalyticsService.addCustomAnalyticsEvent(
                dashboardLogMsgNotPremiumAccount
                        .toLowerCase()
                        .replaceAll(" ", "_") ??
                    '');
            Utility.updateLogs(
                // ,
                activityId: '14',
                description: dashboardLogMsgNotPremiumAccount,
                operationResult: 'Failed');
            popupModal(
                title: 'Data Not Saved',
                message:
                    'Oops! You cannot save the Assignment to the dashboard which was scanned before the premium account. If you still want to save this to the Dashboard, Please rescan the Assignment.');
            Globals.scanMoreStudentInfoLength =
                await Utility.getStudentInfoListLength(
                        tableName: 'student_info') -
                    1;
          } else {
            List list =
                await Utility.getStudentInfoList(tableName: 'student_info');
            if (widget.isScanMore == true &&
                widget.assessmentListLength != null &&
                widget.assessmentListLength! < list.length) {
              String dashboardLogMsgPremiumAccount =
                  'Save to dashboard pressed in case for scan more from ${widget.assessmentDetailPage == true ? "Assessment History Detail Page" : "Result Summary"}';
              FirebaseAnalyticsService.addCustomAnalyticsEvent(
                  dashboardLogMsgPremiumAccount
                          .toLowerCase()
                          .replaceAll(" ", "_") ??
                      '');
              Utility.updateLogs(
                  // accountType: 'Free',
                  activityId: '14',
                  description: dashboardLogMsgPremiumAccount,
                  operationResult: 'Success');

              _ocrBloc.add(SaveAssessmentToDashboard(
                  assessmentId: !widget.assessmentDetailPage!
                      ? Globals.currentAssessmentId
                      : historyAssessmentId ?? '',
                  assessmentSheetPublicURL: widget.shareLink,
                  resultList: await Utility.getStudentInfoList(
                      tableName: widget.assessmentDetailPage == true
                          ? 'history_student_info'
                          : 'student_info'),
                  previouslyAddedListLength: widget.assessmentListLength,
                  assessmentName: widget.assessmentName!,
                  rubricScore: widget.rubricScore ?? '',
                  subjectId: widget.subjectId ?? '',
                  schoolId: Globals.appSetting.schoolNameC!, //Account Id
                  // standardId: widget.standardId ?? '',
                  scaffoldKey: scaffoldKey,
                  context: context,
                  isHistoryAssessmentSection: widget.assessmentDetailPage!));
            } else {
              List<StudentAssessmentInfo> _listRecord = [];

              if (widget.assessmentDetailPage! &&
                  savedRecordCount != null &&
                  historyRecordList.length != savedRecordCount!) {
                _listRecord = historyRecordList.sublist(
                    savedRecordCount!, historyRecordList.length);
              } else {
                //
                _listRecord = historyRecordList;
              }

              _ocrBloc.add(SaveAssessmentToDashboard(
                assessmentId: !widget.assessmentDetailPage!
                    ? Globals.currentAssessmentId
                    : historyAssessmentId ?? '',
                assessmentSheetPublicURL: widget.shareLink,
                resultList: !widget.assessmentDetailPage!
                    ? await Utility.getStudentInfoList(
                        tableName: 'student_info')
                    : _listRecord,
                assessmentName: widget.assessmentName!,
                rubricScore: !widget.assessmentDetailPage!
                    ? widget.rubricScore ?? ''
                    : sheetRubricScore ?? '',
                subjectId: widget.subjectId ?? '',
                schoolId: Globals.appSetting.schoolNameC!, //Account Id
                // standardId: widget.standardId ?? '',
                scaffoldKey: scaffoldKey,
                context: context,
                isHistoryAssessmentSection: widget.assessmentDetailPage!,
                fileId: widget.fileId ?? '',
              ));
            }
          }
        } else {
          String dashboardLogMsgForFreeUser =
              "Free User tried to save the data to the dashboard from ${widget.assessmentDetailPage == true ? "Assessment History Detail Page" : "Result Summary"}";
          FirebaseAnalyticsService.addCustomAnalyticsEvent(
              dashboardLogMsgForFreeUser.toLowerCase().replaceAll(" ", "_") ??
                  '');
          Utility.updateLogs(
              // ,
              activityId: '14',
              description: dashboardLogMsgForFreeUser,
              operationResult: 'Failed');
          popupModal(
              title: 'Upgrade To Premium',
              message:
                  'This is a premium feature. To view a sample dashboard, click here: \nhttps://datastudio.google.com/u/0/reporting/75743c2d-5749-45e7-9562-58d0928662b2/page/p_79velk1hvc \n\nTo speak to SOLVED about obtaining the premium version of GRADED+, including a custom data Dashboard, email admin@solvedconsulting.com');
        }
        break;
      case 'Slides':
        String slidesLogMsg =
            "Slide Action Button pressed from ${widget.assessmentDetailPage == true ? "Assessment History Detail Page" : "Result Summary"}";

        FirebaseAnalyticsService.addCustomAnalyticsEvent(
            slidesLogMsg.toLowerCase().replaceAll(" ", "_") ?? '');
        Fluttertoast.cancel();

        Utility.updateLogs(
            activityId: '31',
            sessionId: widget.assessmentDetailPage == true
                ? widget.obj!.sessionId ?? ''
                : '',
            description: slidesLogMsg,
            operationResult: 'Success');

        // Globals.googleSlidePresentationLink != null &&
        //         Globals.googleSlidePresentationLink!.isNotEmpty
        //     ? Utility.launchUrlOnExternalBrowser(
        //         Globals.googleSlidePresentationLink!)
        //     : Utility.currentScreenSnackBar(
        //         'Assessment do not have slides', null);
        if ((url?.isNotEmpty ?? false) && (url != 'NA')) {
          Utility.launchUrlOnExternalBrowser(url);
        }

        break;
      case "Sheet":
        if ((url?.isNotEmpty ?? false) && (url != 'NA')) {
          String sheetLogMsg =
              "Sheet Action Button pressed from ${widget.assessmentDetailPage == true ? "Assessment History Detail Page" : "Result Summary"}";
          FirebaseAnalyticsService.addCustomAnalyticsEvent(
              sheetLogMsg.toLowerCase().replaceAll(" ", "_") ?? '');
          await Utility.launchUrlOnExternalBrowser(url);
        }
        break;
      case "Class":
        if ((url?.isNotEmpty ?? false) && (url != 'NA')) {
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

  void performScanMore() async {
    if ((widget.assessmentDetailPage == true) &&
        ((widget.createdAsPremium == true && Globals.isPremiumUser != true) ||
            (widget.createdAsPremium == false &&
                Globals.isPremiumUser == true))) {
      popupModal(
          title: 'Alert!',
          message: Globals.isPremiumUser == true
              ? 'Oops! You are currently a "Premium" user. You cannot update the Assignment that you created as a "Free" user. You can start with a fresh scan as a Premium user.'
              : 'Oops! You are currently a "Free" user. You cannot update the Assignment that you created as a "Premium" user. If you still want to edit this Assignment then please upgrade to Premium. You can still create new Assignments as Free user.');
      return;
    }
    String scanMoreLogMsg =
        'Scan more button pressed from ${widget.assessmentDetailPage == true ? "Assessment History Detail Page" : "Result Summary"}';

    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        scanMoreLogMsg.toLowerCase().replaceAll(" ", "_") ?? '');
    Utility.updateLogs(
        //,
        activityId: '22',
        sessionId:
            widget.assessmentDetailPage == true ? widget.obj!.sessionId : '',
        description: scanMoreLogMsg,
        operationResult: 'Success');

    if (widget.obj != null && widget.obj!.isCreatedAsPremium == "true") {
      createdAsPremium = true;
    }
    String pointPossible = await _getpointPossible(
        tableName: widget.assessmentDetailPage == true
            ? 'history_student_info'
            : 'student_info');

    Fluttertoast.cancel();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CameraScreen(
                lastAssessmentLength: lastAssessmentLength,
                assessmentName: widget.assessmentName,
                isMcqSheet: widget.isMcqSheet,
                selectedAnswer: widget.selectedAnswer,
                isFlashOn: ValueNotifier<bool>(false),
                questionImageLink: questionImageUrl,
                obj: widget.obj,
                createdAsPremium: widget.assessmentDetailPage == true
                    ? createdAsPremium
                    : Globals.isPremiumUser,
                oneTimeCamera: widget.assessmentDetailPage!,
                isFromHistoryAssessmentScanMore: widget.assessmentDetailPage!,
                onlyForPicture: false,
                isScanMore: true,
                // lastStudentInfoLength: Globals.studentInfo!.length,
                pointPossible: pointPossible != null && pointPossible.isNotEmpty
                    ? pointPossible.replaceAll(' ', '')
                    : '2')));
  }

  Future<void> _initState() async {
    if (widget.assessmentDetailPage!) {
      // GoogleClassroomGlobals.studentAssessmentAndClassroomObj = GoogleClassroomCourses();
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

      _ocrBloc.add(GetDashBoardStatus(
          fileId: widget.fileId,
          assessmentObj:
              GoogleClassroomGlobals.studentAssessmentAndClassroomObj));
      _driveBloc3.add(GetShareLink(fileId: widget.fileId, slideLink: true));
    } else {
      updateAssessmentToDb();
      if (widget.isScanMore != true) {
        // print("Shared Link called");
        _driveBloc3.add(GetShareLink(fileId: widget.fileId, slideLink: true));
      } else {
        //TODO : REMOVE GLOBAL ACCESS : IMPROVE

        widget.shareLink = Globals.shareableLink;
        isShareLinkReceived.value = true;
      }

      iconsList = Globals.ocrResultIcons;
      iconsName = Globals.ocrResultIconsName;

      _method();
      if (Overrides.STANDALONE_GRADED_APP) {
        classroomUrlStatus.value = true;
      }
    }
  }

  getURlForBottomIcons({required String title}) {
    Map map = {
      'Share': widget.shareLink,
      'Drive': Globals.googleDriveFolderPath,
      'History': 'History',
      'Dashboard': 'Dashboard',
      'Slides': Globals.googleSlidePresentationLink,
      'Sheet': widget.shareLink,
      'Class':
          GoogleClassroomGlobals.studentAssessmentAndClassroomObj.courseWorkURL,
    };

    return map[title] ?? '';
  }
}
