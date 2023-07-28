// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/services/google_classroom_globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/graded_plus/bloc/graded_plus_bloc.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_plus_utilty.dart';
import 'package:Soc/src/modules/graded_plus/modal/assessment_status_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/custom_rubic_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/subject_details_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/results_summary.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/subject_selection_screen.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/graded_plus/widgets/searchbar_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/google_authentication.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/user_profile.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bouncing_widget.dart';
import 'package:Soc/src/widgets/debouncer.dart';
import 'package:Soc/src/widgets/graded_globals.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../google_classroom/bloc/google_classroom_bloc.dart';

// ignore: must_be_immutable
class GradedPlusSearchScreenPage extends StatefulWidget {
  GradedPlusSearchScreenPage(
      {Key? key,
      this.isMcqSheet,
      this.selectedAnswer,
      required this.selectedKeyword,
      required this.grade,
      required this.selectedSubject,
      // required this.questionImage,
      required this.stateName,
      required this.subjectId,
      required this.googleDriveBloc,
      required this.googleClassroomBloc,
      required this.gradedPlusQueImage,
      this.titleIconData})
      : super(key: key);

  GoogleClassroomBloc googleClassroomBloc;
  GoogleDriveBloc googleDriveBloc;
  final String? grade;
  final File? gradedPlusQueImage;
  final bool? isMcqSheet;
  final String? selectedAnswer;
  final String? selectedKeyword;
  // final String? questionImage;
  final String? selectedSubject;

  final String? stateName;
  final String? subjectId;
  final IconData? titleIconData;
  @override
  State<GradedPlusSearchScreenPage> createState() =>
      _GradedPlusSearchScreenPageState();
}

class _GradedPlusSearchScreenPageState
    extends State<GradedPlusSearchScreenPage> {
//------------------------------------------------------------------------------------------
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();
  // final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

//------------------------------------------------------------------------------------------
  final ValueNotifier<int> nycSubIndex1 =
      ValueNotifier<int>(5000); //To bypass the default selection
  final ValueNotifier<int> listLength =
      ValueNotifier<int>(5000); //To bypass the default selection
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isRecentList = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isSubmitButton = ValueNotifier<bool>(false);
  // Value Notifier to check which is update or not
  ValueNotifier<LoadingStatusModel> assessmentExportAndSaveStatus =
      ValueNotifier<LoadingStatusModel>(LoadingStatusModel(
          excelSheetPrepared: false,
          slidePrepared: false,
          saveAssessmentResultToDashboard: false,
          googleClassroomPrepared: false));

//------------------------------------------------------------------------------------------
  GoogleDriveBloc excelSheetBloc = GoogleDriveBloc();
  GoogleDriveBloc googleBloc = GoogleDriveBloc();
  GoogleDriveBloc googleSlideBloc = GoogleDriveBloc();
  OcrBloc ocrAssessmentBloc = OcrBloc();
  OcrBloc _ocrBloc = OcrBloc();
  OcrBloc _ocrBloc2 = OcrBloc();

//------------------------------------------------------------------------------------------
  // final searchController = TextEditingController();
  List<String> processList = ((GoogleClassroomOverrides
              .recentStudentResultSummaryForStandardApp.id?.isNotEmpty ??
          false)
      // &&
      // Overrides.STANDALONE_GRADED_APP != true
      )
      ? [
          'Google Sheets',
          'Google Slides',
          'Google Classroom',
          '${Globals.schoolDbnC} Dashboard'
        ]
      : ['Google Sheets', 'Google Slides', '${Globals.schoolDbnC} Dashboard'];
  List<SubjectDetailList> searchList = [];
  LocalDatabase<StudentAssessmentInfo> _studentAssessmentInfoDb =
      LocalDatabase('student_info');
  StateSetter? showDialogSetState;
  String? learningStandard;
  String? standardDescription;
  String? standardId;
  int standardLearningLength = 0;
  String? subLearningStandard;
  static const double _KVertcalSpace = 60.0;
  final _debouncer = Debouncer(milliseconds: 10);
  //------------------------------------------------------------------------------------------

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _ocrBloc.add(FetchRecentSearch(
        type: 'nycSub',
        subjectName: widget.selectedKeyword,
        // isSearchPage: true,
        className: widget.grade));
    _ocrBloc2.add(FetchRecentSearch(
        type: 'nyc',
        subjectName: widget.selectedKeyword,
        // isSearchPage: true,
        className: widget.grade));

    FirebaseAnalyticsService.addCustomAnalyticsEvent("search_screen_page");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'search_screen_page', screenClass: 'SearchScreenPage');
  }

  Widget verticalListWidget() {
    return ValueListenableBuilder(
        valueListenable: listLength,
        builder: (BuildContext context, dynamic value, Widget? child) {
          return buttonListWidget(list: searchList);
        });
  }

  Widget buttonListWidget({required List<SubjectDetailList> list}) {
    return ValueListenableBuilder(
        valueListenable: isRecentList,
        builder: (BuildContext context, dynamic value, Widget? child) {
          return ValueListenableBuilder(
              valueListenable: nycSubIndex1,
              builder: (BuildContext context, dynamic value, Widget? child) {
                return list.length == 0
                    ? Container(
                        height: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? MediaQuery.of(context).size.height * 0.8
                            : MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Utility.textWidget(
                                    text: 'Recent Searches',
                                    context: context,
                                    textTheme: Theme.of(context)
                                        .textTheme
                                        .headline2!
                                        .copyWith(
                                            fontWeight: FontWeight.bold))),
                            Expanded(
                              child: NoDataFoundErrorWidget(
                                connected: true,
                                isNews: false,
                                isEvents: false,
                                isResultNotFoundMsg: false,
                                isOcrSearch: true,
                              ),
                            )
                          ],
                        ))
                    : Container(
                        //  padding: EdgeInsets.only(bottom: 50),
                        height: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? MediaQuery.of(context).size.height * 0.8
                            : MediaQuery.of(context).size.width * 0.8,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ListView.separated(
                            padding: EdgeInsets.only(
                                bottom: Platform.isAndroid ? 80 : 120),
                            controller: _scrollController,
                            itemCount: list.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    index == 0 && isRecentList.value == true
                                        ? Container(
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: Utility.textWidget(
                                              text: 'Recent Searches',
                                              context: context,
                                              textTheme: Theme.of(context)
                                                  .textTheme
                                                  .headline1!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w100),
                                            ))
                                        : Container(),
                                    index == 0 && standardLearningLength != 0
                                        ? Container(
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: Utility.textWidget(
                                                text: Overrides.STANDALONE_GRADED_APP == true
                                                    ? 'Common Core'
                                                    : 'Learning Standard',
                                                context: context,
                                                textTheme: Theme.of(context).textTheme.headline1!.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold)))
                                        : (index == standardLearningLength && list.length != 0
                                            ? Container(
                                                padding:
                                                    EdgeInsets.only(bottom: 10),
                                                child: Utility.textWidget(
                                                    text: Overrides.STANDALONE_GRADED_APP == true
                                                        ? 'Common Core'
                                                        : 'NY Next Generation Learning Standard',
                                                    context: context,
                                                    textTheme: Theme.of(context)
                                                        .textTheme
                                                        .headline1!
                                                        .copyWith(fontWeight: FontWeight.bold)))
                                            : Container()),
                                    Bouncing(
                                        child: InkWell(
                                            onTap: () {
                                              //subLearningStandard = list[index].standardAndDescriptionC;
                                              //if (pageIndex.value == 2) {
                                              nycSubIndex1.value = index;
                                              if (index <
                                                  standardLearningLength) {
                                                isSubmitButton.value = false;
                                                addToRecentList(
                                                    type: 'nyc',
                                                    obj: list[index],
                                                    className: widget.grade!,
                                                    subjectName: widget
                                                        .selectedKeyword!);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          GradedPluSubjectSelection(
                                                            titleIconData: widget
                                                                .titleIconData,
                                                            gradedPlusQueImage:
                                                                widget
                                                                    .gradedPlusQueImage,
                                                            isMcqSheet: widget
                                                                .isMcqSheet,
                                                            selectedAnswer: widget
                                                                .selectedAnswer,
                                                            subjectId: widget
                                                                .subjectId,
                                                            // questionImageUrl:
                                                            //     widget.questionImage ??
                                                            //         'NA',
                                                            selectedClass:
                                                                widget.grade,
                                                            isSearchPage: true,
                                                            domainNameC:
                                                                learningStandard =
                                                                    list[index]
                                                                        .domainNameC,
                                                            searchClass:
                                                                widget.grade,
                                                            selectedSubject: widget
                                                                .selectedSubject,
                                                            stateName: widget
                                                                .stateName,
                                                          )),
                                                );
                                              } else {
                                                learningStandard =
                                                    list[index].domainNameC;
                                                subLearningStandard = list[
                                                        index]
                                                    .standardAndDescriptionC!
                                                    .split(' - ')[0];
                                                standardDescription = list[
                                                        index]
                                                    .standardAndDescriptionC!
                                                    .split(' - ')[1];
                                                standardId = list[index].id;
                                                addToRecentList(
                                                    type: 'nycSub',
                                                    obj: list[index],
                                                    className: widget.grade!,
                                                    subjectName: widget
                                                        .selectedKeyword!);
                                                isSubmitButton.value = true;
                                              }
                                              // if (nycSubIndex1.value != 50000) {
                                              //   isSubmitButton.value = true;
                                              // }
                                              // }
                                            },
                                            child: AnimatedContainer(
                                                padding:
                                                    EdgeInsets.only(bottom: 5),
                                                decoration: BoxDecoration(
                                                  color: (nycSubIndex1.value ==
                                                          index)
                                                      ? AppTheme.kSelectedColor
                                                      : Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                ),
                                                duration:
                                                    Duration(microseconds: 100),
                                                child: Container(
                                                    padding: EdgeInsets.all(15),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: index <
                                                            standardLearningLength
                                                        ? Utility.textWidget(
                                                            text: list[index]
                                                                .domainNameC!,
                                                            context: context,
                                                            textTheme:
                                                                Theme.of(context)
                                                                    .textTheme
                                                                    .headline2)
                                                        : list[index].standardAndDescriptionC !=
                                                                    null &&
                                                                list[index].standardAndDescriptionC!.split(' - ').length >
                                                                    1
                                                            ?
                                                            //To manage translation of text
                                                            Utility
                                                                .textSpanWidget(
                                                                textTheme1: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline2!
                                                                    .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                textTheme2: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline2!,
                                                                text1: list[
                                                                        index]
                                                                    .standardAndDescriptionC!
                                                                    .split(
                                                                        ' - ')[0],
                                                                text2: list[
                                                                        index]
                                                                    .standardAndDescriptionC!
                                                                    .split(
                                                                        ' - ')[1],
                                                                context:
                                                                    context,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              )
                                                            : Utility.textWidget(
                                                                textTheme:
                                                                    Theme.of(context)
                                                                        .textTheme
                                                                        .headline2,
                                                                context:
                                                                    context,
                                                                text: list[index].standardAndDescriptionC ?? ''),
                                                    decoration: BoxDecoration(color: Color(0xff000000) != Theme.of(context).backgroundColor ? Color(0xffF7F8F9) : Color(0xff111C20), border: Border.all(color: (nycSubIndex1.value == index) ? AppTheme.kSelectedColor : Colors.grey), borderRadius: BorderRadius.circular(8)))))),
                                    index == list.length - 1
                                        ? SizedBox(height: 20)
                                        : Container()
                                  ]);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SpacerWidget(_KVertcalSpace / 3.75);
                            }));
              });
        });
  }

  Widget submitAssessmentButton() {
    return ValueListenableBuilder(
      valueListenable: isSubmitButton,
      child: Container(),
      builder: (BuildContext context, dynamic value, Widget? child) {
        return //pageIndex.value == 2
            isSubmitButton.value
                ? FloatingActionButton.extended(
                    backgroundColor: AppTheme.kButtonColor.withOpacity(1.0),
                    onPressed: () async {
                      floatingButtonOnTap();
                      //await saveToDrive();
                    },
                    label: Utility.textWidget(
                        text: 'Save',
                        context: context,
                        textTheme: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(
                                color: Theme.of(context).backgroundColor)))
                : Container();
      },
    );
  }

  addToRecentList(
      {required String type,
      required SubjectDetailList obj,
      required String className,
      required String subjectName}) async {
    LocalDatabase<SubjectDetailList> _localDb =
        LocalDatabase("${className}${subjectName}${type}RecentList");

    List<SubjectDetailList>? _localData = await _localDb.getData();

    if (type == 'nyc') {
      bool result = true;
      for (int i = 0; i < _localData.length; i++) {
        if (obj.domainNameC == _localData[i].domainNameC) {
          result = false;
          break;
        }
      }
      if (result == true) {
        _localData.add(obj);
      }
    } else if (type == 'nycSub') {
      bool result = true;
      for (int i = 0; i < _localData.length; i++) {
        if (obj.standardAndDescriptionC ==
            _localData[i].standardAndDescriptionC) {
          result = false;
          break;
        }
      }
      if (result == true) {
        _localData.add(obj);
      }
    }

    await _localDb.clear();
    _localData.forEach((SubjectDetailList e) {
      _localDb.addData(e);
    });
  }

  Future saveToDrive() async {
    LocalDatabase<CustomRubricModal> _localDb = LocalDatabase('custom_rubic');
    List<CustomRubricModal>? _localData = await _localDb.getData();
    String? rubricImgUrl;
    // String? rubricScore;
    for (int i = 0; i < _localData.length; i++) {
      if (_localData[i].customOrStandardRubic == "Custom" &&
          _localData[i].name == Globals.scoringRubric) {
        rubricImgUrl = _localData[i].imgUrl ?? 'NA';
        break;
        // rubricScore = null;
      } else {
        rubricImgUrl = 'NA';
        // rubricScore = 'NA';
      }
    }

    //Adding blank fields to the list : Static data
    List<StudentAssessmentInfo> studentAssessmentInfoDblist =
        await OcrUtility.getSortedStudentInfoList(tableName: 'student_info');

    StudentAssessmentInfo element = studentAssessmentInfoDblist[0];
    element.subject = widget.selectedKeyword;
    element.learningStandard =
        learningStandard == null || learningStandard == ''
            ? "NA"
            : learningStandard;
    element.subLearningStandard =
        subLearningStandard == null || subLearningStandard == ''
            ? "NA"
            : subLearningStandard; //standardDescription
    element.standardDescription =
        standardDescription == null || standardDescription == ''
            ? "NA"
            : standardDescription; //standardDescription

    element.scoringRubric =
        widget.isMcqSheet == true ? '0-1' : Globals.scoringRubric;
    element.customRubricImage = rubricImgUrl ?? "NA";
    element.grade = widget.grade;
    element.className = Globals.assessmentName!.split("_")[1];
    // element.questionImgUrl = widget.questionImage == ''
    //     ? "NA"
    //     : widget.questionImage;
    element.googleSlidePresentationURL = Globals.googleSlidePresentationLink;
    await _studentAssessmentInfoDb.putAt(0, element);

    //GradedGlobals.loadingMessage = 'Preparing Student Excel Sheet';

    // Utility.showLoadingDialog(
    //     context: context,
    //     isOCR: true,
    //     state: (p0) => {showDialogSetState = p0});

    excelSheetBloc.add(UpdateDocOnDrive(
        isMcqSheet: widget.isMcqSheet ?? false,
        // questionImage: widget.questionImage == ''
        //     ? 'NA'
        //     : widget.questionImage ?? 'NA',

        assessmentName: Globals.assessmentName!,
        fileId: Globals.googleExcelSheetId,
        isLoading: true,
        studentData:
            //list2
            await OcrUtility.getSortedStudentInfoList(
                tableName: 'student_info')));
  }

  /* ---------- widget bloc listener to upload question image,create excel sheet & slide, --------- */
  Widget googleBlocListener() {
    return BlocListener<GoogleDriveBloc, GoogleDriveState>(
        bloc: googleBloc,
        child: Container(),
        listener: (context, state) async {
          print("state is $state");
          if (state is ExcelSheetCreated) {
            Globals.googleExcelSheetId =
                state.googleSpreadSheetFileObj['fileId'];
            Globals.shareableLink =
                state.googleSpreadSheetFileObj['fileUrl'] ?? '';
            //Create Google Presentation once Spreadsheet created
            googleBloc.add(CreateSlideToDrive(
                isMcqSheet: widget.isMcqSheet ?? false,
                fileTitle: Globals.assessmentName,
                excelSheetId: Globals.googleExcelSheetId));
          }
          if (state is ErrorState) {
            if (state.errorMsg == 'ReAuthentication is required') {
              Navigator.of(context).pop();
              // await Utility.refreshAuthenticationToken(
              //     isNavigator: true,
              //     errorMsg: state.errorMsg!,
              //     context: context,
              //     scaffoldKey: _scaffoldKey);
              await Authentication.reAuthenticationRequired(
                  context: context,
                  errorMessage: state.errorMsg!,
                  scaffoldKey: _scaffoldKey);
            } else {
              Navigator.of(context).pop();
              Utility.currentScreenSnackBar(
                  state.errorMsg == 'NO_CONNECTION'
                      ? 'No Internet Connection'
                      : "Something Went Wrong. Please Try Again.",
                  null);
            }
          }
          if (state is RecallTheEvent) {
            List<UserInformation> userProfileInfoData =
                await UserGoogleProfile.getUserProfile();

            googleBloc.add(CreateExcelSheetToDrive(
                description: widget.isMcqSheet == true
                    ? "Multiple Choice Sheet"
                    : "Graded+",
                name: Globals.assessmentName,
                folderId:
                    userProfileInfoData[0].gradedPlusGoogleDriveFolderId ??
                        ''));
          }

          if (state is GoogleSlideCreated) {
            Globals.googleSlidePresentationId = state.slideFiledId;

            googleBloc.add(GetShareLink(
                fileId: Globals.googleSlidePresentationId, slideLink: true));
            //    }
            PlusUtility.updateLogs(
                activityType: 'GRADED+',
                userType: 'Teacher',
                activityId: '33',
                description: 'G-Slide Created',
                operationResult: 'Success');

            // call events to update the sheets and slide
          }

          if (state is QuestionImageSuccess) {
            //update Question image url in local studentDb
            List<StudentAssessmentInfo> studentInfoList =
                await _studentAssessmentInfoDb.getData();
            if (studentInfoList?.isNotEmpty ?? false) {
              StudentAssessmentInfo studentObj = studentInfoList.first;
              studentObj.questionImgUrl = state.questionImageUrl;
              await _studentAssessmentInfoDb.putAt(0, studentObj);
            }

            List<UserInformation> userProfileInfoData =
                await UserGoogleProfile.getUserProfile();
            googleBloc.add(CreateExcelSheetToDrive(
                description: widget.isMcqSheet == true
                    ? "Multiple Choice Sheet"
                    : "Graded+",
                name: Globals.assessmentName,
                folderId:
                    userProfileInfoData[0].gradedPlusGoogleDriveFolderId ??
                        ''));
          }

          if (state is ShareLinkReceived) {
            Globals.googleSlidePresentationLink = state.shareLink;
            saveToDrive();
            googleSlideBloc.add(
                AddAndUpdateAssessmentAndResultDetailsToSlidesOnDrive(
                    studentInfoDb: _studentAssessmentInfoDb,
                    slidePresentationId: Globals.googleSlidePresentationId));
          }
        });
  }

  /* -------------------- Widget bloc listener to manage excel sheet upload data ------------------- */
  Widget excelBlocListener() {
    return BlocListener<GoogleDriveBloc, GoogleDriveState>(
        bloc: excelSheetBloc,
        child: Container(),
        listener: (context, state) async {
          print("state is $state");
          if (state is GoogleFolderCreated) {
            PlusUtility.updateLogs(
                activityType: 'GRADED+',
                userType: 'Teacher',
                activityId: '45',
                description: 'G-Excel File Updated',
                operationResult: 'Success');
            showDialogSetState!(() {
              assessmentExportAndSaveStatus.value.excelSheetPrepared = true;
            });
            Globals.currentAssessmentId = '';

//If classroom course id is empty or null thats mean user didnt select any classroom course
            if ((GoogleClassroomOverrides
                        .recentStudentResultSummaryForStandardApp
                        .id
                        ?.isNotEmpty ??
                    false) &&
                Overrides.STANDALONE_GRADED_APP != true) {
              createClassRoomCourseWorkForStandardApp();
            } else {
              assessmentExportAndSaveStatus.value.googleClassroomPrepared =
                  true;
              saveAssessmentToDashboardAndGetId();
            }
          }

          if (state is ErrorState) {
            if (state.errorMsg == 'ReAuthentication is required') {
              Navigator.of(context).pop();
              // await Utility.refreshAuthenticationToken(
              //     isNavigator: true,
              //     errorMsg: state.errorMsg!,
              //     context: context,
              //     scaffoldKey: _scaffoldKey);
              await Authentication.reAuthenticationRequired(
                  context: context,
                  errorMessage: state.errorMsg!,
                  scaffoldKey: _scaffoldKey);
            } else {
              Navigator.of(context).pop();
              Utility.currentScreenSnackBar('Something went wrong' ?? "", null);
            }
          }
        });
  }

  Widget slideBlocListener() {
    return BlocListener<GoogleDriveBloc, GoogleDriveState>(
        bloc: googleSlideBloc,
        child: Container(),
        listener: (context, state) async {
          if (state is ErrorState) {
            if (state.errorMsg == 'ReAuthentication is required') {
              Navigator.of(context).pop();
              // await Utility.refreshAuthenticationToken(
              //     isNavigator: true,
              //     errorMsg: state.errorMsg!,
              //     context: context,
              //     scaffoldKey: _scaffoldKey);
              await Authentication.reAuthenticationRequired(
                  context: context,
                  errorMessage: state.errorMsg!,
                  scaffoldKey: _scaffoldKey);
            } else {
              Navigator.of(context).pop();
              Utility.currentScreenSnackBar('Something went wrong' ?? "", null);
            }
          }

          print("state is $state");

          if (state is AddAndUpdateStudentAssessmentDetailsToSlideSuccess) {
            //Updating very first slide with the assignment details
            googleSlideBloc.add(UpdateAssignmentDetailsOnSlide(
                slidePresentationId: Globals.googleSlidePresentationId,
                studentAssessmentInfoDB: _studentAssessmentInfoDb));
          }

          if (state is UpdateAssignmentDetailsOnSlideSuccess) {
            PlusUtility.updateLogs(
                activityType: 'GRADED+',
                userType: 'Teacher',
                activityId: '44',
                description: 'G-Slide Updated',
                operationResult: 'Success');
            FirebaseAnalyticsService.addCustomAnalyticsEvent(
                "assessment_detail_added_first_slide");

            showDialogSetState!(() {
              assessmentExportAndSaveStatus.value.slidePrepared = true;
            });

            navigateToResultSummary();
          }
        });
  }

  /* ---------------------------- widget for assessment create ocr bloc --------------------------- */
  Widget ocrAssessmentBlocListener() {
    return BlocListener<OcrBloc, OcrState>(
      bloc: ocrAssessmentBloc,
      listener: (context, state) {
        print("state is $state");
        if (state is AssessmentIdSuccess) {
          _saveResultAssignmentsToDashboard(
              assessmentId: state.dashboardAssignmentsId ?? '',
              googleSpreadsheetUrl: Globals.shareableLink ?? '',
              assessmentName: Globals.assessmentName ?? '',
              studentAssessmentInfoDb: _studentAssessmentInfoDb);
        } else if (state is OcrErrorReceived) {
          Navigator.of(context).pop();
          Utility.currentScreenSnackBar('Something went wrong' ?? "", null);
        } else if (state is GradedPlusSaveResultToDashboardSuccess) {
          showDialogSetState!(() {
            assessmentExportAndSaveStatus
                .value.saveAssessmentResultToDashboard = true;
          });
          navigateToResultSummary();
        }
      },
      child: Container(),
    );
  }

  /* ----- Function will navigate to result summery when all process done ----- */
  navigateToResultSummary() {
    // check all process is done or not

    if (assessmentExportAndSaveStatus.value.excelSheetPrepared == true &&
        assessmentExportAndSaveStatus.value.slidePrepared == true &&
        assessmentExportAndSaveStatus.value.saveAssessmentResultToDashboard ==
            true) {
      FirebaseAnalyticsService.addCustomAnalyticsEvent(
          "save_to_drive_from_subject_search");
      PlusUtility.updateLogs(
          activityType: 'GRADED+',
          userType: 'Teacher',
          activityId: '12',
          description: 'Save to drive',
          operationResult: 'Success');

      Navigator.pop(context);
      OcrUtility.showSuccessDialog(context: context);
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GradedPlusResultsSummary(
              titleIconData: widget.titleIconData,
              isMcqSheet: widget.isMcqSheet,
              selectedAnswer: widget.selectedAnswer,
              fileId: Globals.googleExcelSheetId,
              //subjectId: subjectId ?? '',
              standardId: standardId ?? '',
              assessmentName: Globals.assessmentName,
              shareLink: '',
              assessmentDetailPage: false,
            ),
          ),
        );
      });
    }
  }

  /* ------ Function call when someone tap on skip button or save button ------ */
  floatingButtonOnTap() async {
    OcrUtility.showProgressLoadingDialog(
        context: context,
        state: (p0) => {showDialogSetState = p0},
        assessmentExportAndSaveStatus: assessmentExportAndSaveStatus,
        processList: processList);
    // Utility.showLoadingDialog(
    //     context: context, isOCR: true, msg: "Please Wait");

    if (Globals.googleExcelSheetId == null ||
        Globals.googleExcelSheetId?.isEmpty == true) {
      // Check if question image exists
      if (widget.gradedPlusQueImage == null) {
        List<UserInformation> userProfileInfoData =
            await UserGoogleProfile.getUserProfile();
        googleBloc.add(CreateExcelSheetToDrive(
          description:
              widget.isMcqSheet == true ? "Multiple Choice Sheet" : "Graded+",
          name: Globals.assessmentName,
          folderId: userProfileInfoData[0].gradedPlusGoogleDriveFolderId ?? '',
        ));
      } else {
        googleBloc.add(QuestionImgToAwsBucket(
          imageFile: widget.gradedPlusQueImage,
        ));
      }
      return; // Exit the function early
    }
    //Will call the method only in case of user press the button again if something went wrong or authentication requires in between the process
    callActionOnReTappingFAB();
  }

  //------------------------------------------------------------------------callActionOnReTappingFAB------------------------------------------------------------------------------------
  //Will call the method only in case of user press the button again if something went wrong or authentication requires in between the process
  callActionOnReTappingFAB() async {
    if (Globals.googleSlidePresentationId == null ||
        Globals.googleSlidePresentationId?.isEmpty == true) {
      googleBloc.add(CreateSlideToDrive(
        isMcqSheet: widget.isMcqSheet ?? false,
        fileTitle: Globals.assessmentName,
        excelSheetId: Globals.googleExcelSheetId,
      ));
      return; // Exit the function early
    }

    //------------------------------------------------------------------------------
    //Get Slide Share Link if empty
    if (Globals.googleSlidePresentationLink == null ||
        Globals.googleSlidePresentationLink?.isEmpty == true) {
      googleBloc.add(GetShareLink(
        fileId: Globals.googleSlidePresentationId,
        slideLink: true,
      ));
      return; // Exit the function early
    }

    //------------------------------------------------------------------------------
    //Updating Excel sheet with student details if not already updated
    if (assessmentExportAndSaveStatus.value.excelSheetPrepared == false) {
      saveToDrive();
    }

    //------------------------------------------------------------------------------
    //Updating Google Slide with student details if not already updated
    if (assessmentExportAndSaveStatus.value.slidePrepared == false) {
      googleSlideBloc.add(AddAndUpdateAssessmentAndResultDetailsToSlidesOnDrive(
        studentInfoDb: _studentAssessmentInfoDb,
        slidePresentationId: Globals.googleSlidePresentationId,
      ));
    }

    //google classroom with student details if not already updated
    if (assessmentExportAndSaveStatus.value.googleClassroomPrepared == false) {
      createClassRoomCourseWorkForStandardApp();
    }

    //------------------------------------------------------------------------------
    //Updating student result to dashboard if not already updated
    if (assessmentExportAndSaveStatus.value.saveAssessmentResultToDashboard ==
        false) {
      Globals.currentAssessmentId = '';

      saveAssessmentToDashboardAndGetId();
    }
  }

  Widget classRoomBlocListener() {
    return BlocListener<GoogleClassroomBloc, GoogleClassroomState>(
        bloc: widget.googleClassroomBloc,
        child: Container(),
        listener: (context, state) async {
          print("state is $state");
          if (state is CreateClassroomCourseWorkSuccess) {
            PlusUtility.updateLogs(
                activityType: 'GRADED+',
                userType: 'Teacher',
                activityId: '34',
                description: 'G-Classroom Created',
                operationResult: 'Success');
            navigateToResultSummary();
          }
          if (state is GoogleClassroomErrorState) {
            if (state.errorMsg == 'ReAuthentication is required') {
              // await Utility.refreshAuthenticationToken(
              //     isNavigator: true,
              //     errorMsg: state.errorMsg!,
              //     context: context,
              //     scaffoldKey: _scaffoldKey);
              await Authentication.reAuthenticationRequired(
                  context: context,
                  errorMessage: state.errorMsg!,
                  scaffoldKey: _scaffoldKey);

              widget.googleClassroomBloc.add(CreateClassRoomCourseWork(
                  studentAssessmentInfoDb: LocalDatabase('student_info'),
                  pointPossible: Globals.pointPossible ?? '0',
                  studentClassObj: GoogleClassroomOverrides
                      .studentAssessmentAndClassroomObj!,
                  title: Globals.assessmentName!.split("_")[1] ?? ''));
            } else {
              Navigator.of(context).pop();
              Utility.currentScreenSnackBar(
                  state.errorMsg?.toString() ?? "", null);
            }
          }

          if (state is CreateClassroomCourseWorkSuccessForStandardApp) {
            showDialogSetState!(() {
              assessmentExportAndSaveStatus.value.googleClassroomPrepared =
                  true;
            });
            saveAssessmentToDashboardAndGetId();
            navigateToResultSummary();
          }
        });
  }

  void createClassRoomCourseWorkForStandardApp() {
    widget.googleClassroomBloc.add(CreateClassroomCourseWorkForStandardApp(
        studentAssessmentInfoDb: _studentAssessmentInfoDb,
        studentClassObj:
            GoogleClassroomOverrides.recentStudentResultSummaryForStandardApp,
        title: Globals.assessmentName ?? '',
        pointPossible: Globals.pointPossible ?? "0"));
  }

  Future<void> saveAssessmentToDashboardAndGetId() async {
    Globals.currentAssessmentId = '';

    List<StudentAssessmentInfo> studentAssessmentInfoDblist =
        await OcrUtility.getSortedStudentInfoList(tableName: 'student_info');
    Globals.currentAssessmentId = '';
    //Save Assessment To  Postgres Database
    ocrAssessmentBloc.add(SaveAssessmentToDashboardAndGetId(
        isMcqSheet: widget.isMcqSheet ?? false,
        assessmentQueImage:
            studentAssessmentInfoDblist?.first?.questionImgUrl ?? 'NA',
        assessmentName: Globals.assessmentName ?? 'Assessment Name',
        rubricScore: Globals.scoringRubric ?? '2',
        subjectName: widget.selectedSubject ??
            'NA', //Student Id will not be there in case of custom subject
        domainName: learningStandard ?? '',
        subDomainName: subLearningStandard ?? '',
        grade: widget.grade ?? '',
        schoolId: Globals.appSetting.schoolNameC ?? '',
        standardId: standardId ?? '',
        scaffoldKey: _scaffoldKey,
        context: context,
        fileId: Globals.googleExcelSheetId ?? 'Excel Id not found',
        sessionId: Globals.sessionId,
        teacherContactId: await OcrUtility.getTeacherId(),
        teacherEmail: Globals.userEmailId,
        classroomCourseId: GoogleClassroomOverrides
                ?.studentAssessmentAndClassroomObj?.courseId ??
            '',
        classroomCourseWorkId: GoogleClassroomOverrides
                ?.studentAssessmentAndClassroomObj?.courseWorkId ??
            '',
        classroomCourseWorkUrl: Overrides.STANDALONE_GRADED_APP
            ? GoogleClassroomOverrides
                    ?.studentAssessmentAndClassroomObj?.courseWorkURL ??
                ''
            : GoogleClassroomOverrides
                    .recentStudentResultSummaryForStandardApp.courseWorkURL ??
                ''));
  }

  //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  void _saveResultAssignmentsToDashboard(
      {required String assessmentId,
      required String googleSpreadsheetUrl,
      // required String subjectId,
      required String assessmentName,
      //  required String fileId,
      required LocalDatabase<StudentAssessmentInfo> studentAssessmentInfoDb}) {
    ocrAssessmentBloc.add(GradedPlusSaveResultToDashboard(
      assessmentId: assessmentId,
      assessmentSheetPublicURL: googleSpreadsheetUrl,
      studentInfoDb: studentAssessmentInfoDb,
      assessmentName: assessmentName,
      // subjectId: subjectId,
      schoolId: Globals.appSetting.schoolNameC!,
      // fileId: fileId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CommonBackgroundImgWidget(),
      Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: submitAssessmentButton(),
          appBar: CustomOcrAppBarWidget(
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
              isBackButton: true,
              isBackOnSuccess: isBackFromCamera,
              key: _scaffoldKey),
          body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                  shrinkWrap: true,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        // padding: EdgeInsets.symmetric(horizontal: 20),
                        child: SearchBar(
                            stateName: widget.stateName!,
                            //    isCommonCore: widget.isCommonCore,
                            isSearchPage: true,
                            readOnly: false,
                            controller: searchController,
                            onSaved: (value) {
                              if (searchController.text.isEmpty) {
                                _ocrBloc.add(FetchRecentSearch(
                                    type: 'nycSub',
                                    subjectName: widget.selectedKeyword,
                                    // isSearchPage: true,
                                    className: widget.grade));
                                _ocrBloc2.add(FetchRecentSearch(
                                    type: 'nyc',
                                    subjectName: widget.selectedKeyword,
                                    // isSearchPage: true,
                                    className: widget.grade));
                              } else {
                                _debouncer.run(() async {
                                  _ocrBloc.add(SearchSubjectDetails(
                                      subjectSelected: widget.selectedSubject,
                                      stateName: widget.stateName!,
                                      searchKeyword: searchController.text,
                                      type: 'nycSub',
                                      selectedKeyword: widget.selectedKeyword,
                                      isSearchPage: true,
                                      grade: widget.grade));
                                  _ocrBloc2.add(SearchSubjectDetails(
                                    subjectSelected: widget.selectedSubject,
                                    searchKeyword: searchController.text,
                                    type: 'nyc',
                                    stateName: widget.stateName!,
                                    selectedKeyword: widget.selectedKeyword,
                                    isSearchPage: true,
                                    grade: widget.grade,
                                  ));
                                  setState(() {});
                                });
                              }
                            })),
                    // SpacerWidget(10),
                    //FetchRecentSearch for nyc sub domain
                    BlocListener<OcrBloc, OcrState>(
                      bloc: _ocrBloc,
                      listener: (context, state) {
                        if (state is RecentListSuccess) {
                          searchList.clear();
                          searchList.addAll(state.obj!);
                          listLength.value = searchList.length;
                          isRecentList.value = true;
                        } else if (state is SearchSubjectDetailsSuccess) {
                          List<SubjectDetailList> list = [];

                          for (int i = 0; i < state.obj!.length; i++) {
                            if (state.obj![i].standardAndDescriptionC!
                                .toUpperCase()
                                .contains(
                                    searchController.text.toUpperCase())) {
                              list.add(state.obj![i]);
                            }
                          }
                          searchList.clear();
                          searchList.addAll(list);
                          listLength.value = searchList.length;
                          isRecentList.value = false;
                        }

                        // do stuff here based on BlocA's state
                      },
                      child: Container(),
                    ),

                    //FetchRecentSearch for nyc domain
                    BlocListener<OcrBloc, OcrState>(
                        bloc: _ocrBloc2,
                        listener: (context, state) {
                          if (state is RecentListSuccess) {
                            searchList.insertAll(0, state.obj!);
                            standardLearningLength = state.obj!.length;
                            listLength.value = searchList.length;
                            isRecentList.value = true;
                          } else if (state is SearchSubjectDetailsSuccess) {
                            List<SubjectDetailList> list = [];

                            for (int i = 0; i < state.obj!.length; i++) {
                              if (state.obj![i].domainNameC!
                                  .toUpperCase()
                                  .contains(
                                      searchController.text.toUpperCase())) {
                                list.add(state.obj![i]);
                              }
                            }
                            //print(searchList[0].standardAndDescriptionC);
                            searchList.insertAll(0, list);
                            standardLearningLength = list.length;
                            listLength.value = searchList.length;
                            isRecentList.value = false;
                          }
                          // do stuff here based on BlocA's state
                        },
                        child: Container()),
                    SpacerWidget(20),
                    verticalListWidget()
                  ]))),
      googleBlocListener(),
      excelBlocListener(),
      slideBlocListener(),
      ocrAssessmentBlocListener(),
      classRoomBlocListener()
    ]);
  }
}
