import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/modules/student_plus/model/student_google_presentation_detail_modal.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_searchbar_and_dropdown_widget.dart';
import 'package:Soc/src/services/google_authentication.dart';
import 'package:Soc/src/services/user_profile.dart';
import 'package:Soc/src/modules/google_presentation/bloc/google_presentation_bloc.dart';
import 'package:Soc/src/modules/graded_plus/helper/result_action_icon_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_fab.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/student_plus/bloc/student_plus_bloc.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_work_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_utility.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_app_bar.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_option_bottom_sheet.dart';
import 'package:Soc/src/modules/student_plus/widgets/work_filter_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/image_popup.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentPlusWorkScreen extends StatefulWidget {
  StudentPlusDetailsModel studentDetails;
  final String sectionType;
  StudentPlusWorkScreen(
      {Key? key, required this.studentDetails, required this.sectionType})
      : super(key: key);

  @override
  State<StudentPlusWorkScreen> createState() => _StudentPlusWorkScreenState();
}

class _StudentPlusWorkScreenState extends State<StudentPlusWorkScreen> {
  // Used for space between the  widget
  static const double _kLabelSpacing = 20.0;
  // controller used for search page
  // final _controller = TextEditingController();
//------------------------------------------------------------------------------------------------------

  final StudentPlusBloc _studentPlusBloc = StudentPlusBloc();
  GoogleDriveBloc googleDriveBloc = GoogleDriveBloc();
  final StudentPlusBloc _studentPlusForStudentGooglePresentationBloc =
      StudentPlusBloc();
  final GoogleSlidesPresentationBloc googleSlidesPresentationBloc =
      GoogleSlidesPresentationBloc();
//------------------------------------------------------------------------------------------------------

  ValueNotifier<String> filterNotifier = ValueNotifier<String>('');
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  FocusNode myFocusNode = new FocusNode();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
//------------------------------------------------------------------------------------------------------

  List<ResultSummaryIcons> resultSummaryIconsModalList = [
    ResultSummaryIcons(title: 'Sync Presentation', svgPath: ''),
    ResultSummaryIcons(
        title: 'Open Presentation',
        svgPath: 'assets/ocr_result_section_bottom_button_icons/Slide.svg')
  ];
//------------------------------------------------------------------------------------------------------

  @override
  void initState() {
    _studentPlusBloc.add(
        FetchStudentWorkEvent(studentId: widget.studentDetails.studentIdC));

    super.initState();

    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        "student_plus_work_screen");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'student_plus_work_screen',
        screenClass: 'StudentPlusWorkScreen');

    PlusUtility.updateLogs(
        activityType: 'STUDENT+',
        userType: 'Teacher',
        activityId: '52',
        description: 'Student+ Work Screen',
        operationResult: 'Success');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CommonBackgroundImgWidget(),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: StudentPlusAppBar(
            sectionType: widget.sectionType,
            titleIconCode: 0xe885,
            isWorkPage: true,
            refresh: (v) {
              setState(() {});
            }),
        body: Container(
            padding: EdgeInsets.symmetric(
                horizontal: StudentPlusOverrides.kSymmetricPadding),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SpacerWidget(StudentPlusOverrides.KVerticalSpace / 4),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                PlusScreenTitleWidget(
                    kLabelSpacing: _kLabelSpacing,
                    text: StudentPlusOverrides.studentPlusWorkTitle),
                BlocBuilder<StudentPlusBloc, StudentPlusState>(
                    bloc: _studentPlusBloc,
                    builder: (BuildContext contxt, StudentPlusState state) {
                      if (state is StudentPlusLoading) {
                        return Container();
                        // return CupertinoActivityIndicator();
                      } else if (state is StudentPlusWorkSuccess) {
                        return state.obj.length > 0
                            ? filterIcon(list: state.obj)
                            : Container();
                      } else {
                        return Container();
                      }
                    })
              ]),
              SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
              widget.sectionType == "Student"
                  ? Container()
                  : StudentPlusSearchBarAndDropdown(
                    index: 2,
                      sectionType: widget.sectionType,
                      studentDetails: widget.studentDetails),
              SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
              listViewWidget(),
              SpacerWidget(20)
            ])),
        floatingActionButton: fab(),
      ),
      googleDriveBlocListener(),
      _studentPlusForStudentGooglePresentationBlocListener()
    ]);
  }

  /* ----------------------- Widget to show filter icon ----------------------- */
  Widget filterIcon({required List<StudentPlusWorkModel> list}) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTap: () {
            /*-------------------------User Activity Track START----------------------------*/
            PlusUtility.updateLogs(
                activityType: 'STUDENT+',
                userType: 'Teacher',
                activityId: '39',
                description: 'Filter Record STUDENT+',
                operationResult: 'Success');

            FirebaseAnalyticsService.addCustomAnalyticsEvent(
                'Filter Record STUDENT+'.toLowerCase().replaceAll(" ", "_"));
            /*-------------------------User Activity Track END----------------------------*/

            List<String> subjectList =
                StudentPlusUtility.getSubjectList(list: list);
            List<String> teacherList =
                StudentPlusUtility.getTeacherList(list: list);
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
              builder: (_) => LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return StudentPlusFilterWidget(
                  filterNotifier: filterNotifier,
                  subjectList: subjectList,
                  teacherList: teacherList,
                  height: constraints.maxHeight < 750 &&
                          Globals.deviceType == "phone"
                      ? MediaQuery.of(context).size.height * 0.4 //0.45
                      : Globals.deviceType == "phone"
                          ? MediaQuery.of(context).size.height * 0.42 //0.45
                          : MediaQuery.of(context).size.height * 0.25,
                );
              }),
            );
          },
          child: Icon(
            IconData(0xe87d,
                fontFamily: Overrides.kFontFam,
                fontPackage: Overrides.kFontPkg),
            color: AppTheme.kButtonColor,
            size: 26,
          ),
        ),
        ValueListenableBuilder(
            valueListenable: filterNotifier,
            child: Container(),
            builder: (BuildContext context, dynamic value, Widget? child) {
              return filterNotifier.value == ''
                  ? Container()
                  : Wrap(
                      children: [
                        Container(
                          // margin: EdgeInsets.only(top: 6, right: 6),
                          height: 7,
                          width: 7,
                          decoration: BoxDecoration(
                              color: Colors.red, shape: BoxShape.circle),
                        ),
                      ],
                    );
            })
      ],
    );
  }

  /* ------------------------ widget to build work list ----------------------- */
  Widget listViewWidget() {
    return BlocBuilder<StudentPlusBloc, StudentPlusState>(
      bloc: _studentPlusBloc,
      builder: (BuildContext contxt, StudentPlusState state) {
        if (state is StudentPlusLoading) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              alignment: Alignment.center,
              child: CircularProgressIndicator.adaptive(
                backgroundColor: AppTheme.kButtonColor,
              ));
        } else if (state is StudentPlusWorkSuccess) {
          return state.obj.length > 0
              ? ValueListenableBuilder(
                  valueListenable: filterNotifier,
                  child: Container(),
                  builder:
                      (BuildContext context, dynamic value, Widget? child) {
                    List<StudentPlusWorkModel> studentWorkUpdatedList = [];
                    //Filtered Records
                    for (int i = 0; i < state.obj.length; i++) {
                      if (state.obj[i].subjectC == filterNotifier.value ||
                          filterNotifier.value == '' ||
                          filterNotifier.value ==
                              "${state.obj[i].firstName ?? ''} ${state.obj[i].lastName ?? ''}") {
                        studentWorkUpdatedList.add(state.obj[i]);
                      }
                    }

                    return Expanded(
                        child: RefreshIndicator(
                      color: AppTheme.kButtonColor,
                      key: refreshKey,
                      onRefresh: refreshPage,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: studentWorkUpdatedList
                            .length, // studentWorkList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return listObject(
                              studentWorkModel: studentWorkUpdatedList[index],
                              index: index);
                        },
                      ),
                    ));
                  })
              : Expanded(
                  child: NoDataFoundErrorWidget(
                    errorMessage: StudentPlusOverrides.studentWorkErrorMessage,
                    //  marginTop: 0,
                    isResultNotFoundMsg: false,
                    isNews: false,
                    isEvents: false,
                    isSearchpage: true,
                  ),
                );
        } else {
          return Container();
        }
      },
    );
  }

  /* ----------------- widget to show work detail in listTile ----------------- */
  Widget listObject(
      {required StudentPlusWorkModel studentWorkModel, required int index}) {
    return InkWell(
      onTap: () {
        /*-------------------------User Activity Track START----------------------------*/
        PlusUtility.updateLogs(
            activityType: 'STUDENT+',
            userType: 'Teacher',
            activityId: '42',
            description: 'View Student Work STUDENT+',
            operationResult: 'Success');

        FirebaseAnalyticsService.addCustomAnalyticsEvent(
            'View Student Work STUDENT+'.toLowerCase().replaceAll(" ", "_"));
        /*-------------------------User Activity Track END----------------------------*/

        if (studentWorkModel.assessmentImageC == null ||
            studentWorkModel.assessmentImageC == '') {
          Utility.currentScreenSnackBar(
              StudentPlusOverrides.studentWorkSnackbar, null,
              marginFromBottom: 120);
        } else {
          showDialog(
              useRootNavigator: true,
              context: context,
              builder: (_) =>
                  ImagePopup(imageURL: studentWorkModel.assessmentImageC!));
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0.0),
            color: (index % 2 == 0)
                ? Theme.of(context).colorScheme.background == Color(0xff000000)
                    ? Color(0xff162429)
                    : Color(
                        0xffF7F8F9) //Theme.of(context).colorScheme.background
                : Theme.of(context).colorScheme.background == Color(0xff000000)
                    ? Color(0xff111C20)
                    : Color(0xffE9ECEE)),
        child: Row(
          children: [
            Container(
              width: (MediaQuery.of(context).size.width * 0.25) - 20,
              child: Container(
                child: CircleAvatar(
                  backgroundColor: AppTheme.kButtonColor,
                  radius: MediaQuery.of(context).size.width * 0.065,
                  child: CircleAvatar(
                      backgroundColor: (index % 2 == 0)
                          ? Theme.of(context).colorScheme.background ==
                                  Color(0xff000000)
                              ? Color(0xff162429)
                              : Color(
                                  0xffF7F8F9) //Theme.of(context).colorScheme.background
                          : Theme.of(context).colorScheme.background ==
                                  Color(0xff000000)
                              ? Color(0xff111C20)
                              : Color(0xffE9ECEE),
                      radius: MediaQuery.of(context).size.width * 0.060,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Utility.textWidget(
                              text:
                                  "${studentWorkModel.resultC!}/${StudentPlusUtility.getMaxPointPossible(rubric: studentWorkModel.rubricC ?? '')}",
                              context: context,
                              textAlign: TextAlign.center,
                              textTheme: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                      color: AppTheme.kButtonColor,
                                      fontWeight: FontWeight.bold)),
                          Container(
                            width: 20,
                            height: 1,
                            color: Colors.grey,
                          ),
                          Text(
                              studentWorkModel.assessmentType ==
                                      "Multiple Choice"
                                  ? "MCQ"
                                  : 'CR',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(color: Colors.grey
                                      //color: AppTheme.kButtonColor,
                                      ))
                        ],
                      )),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Utility.textWidget(
                      text: studentWorkModel.nameC!,
                      context: context,
                      textTheme: Theme.of(context).textTheme.headline4),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    //  context: context,
                    "${Utility.convertDateUSFormat(studentWorkModel.dateC)}  |  ${studentWorkModel.firstName ?? ''} ${studentWorkModel.lastName ?? ''}",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
            ),
            Container(
                width: (MediaQuery.of(context).size.width * 0.25) - 20,
                //  color: Colors.yellow,0xe88c
                child: Icon(
                    IconData(0xe88c,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    // size: 20,
                    color: AppTheme.kButtonColor))
          ],
        ),
      ),
    );
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    _studentPlusBloc.add(
        FetchStudentWorkEvent(studentId: widget.studentDetails.studentIdC));

    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        'Sync Student Work STUDENT+'.toLowerCase().replaceAll(" ", "_"));
  }

  Widget? fab() {
    return BlocBuilder<StudentPlusBloc, StudentPlusState>(
        bloc: _studentPlusBloc,
        builder: (
          BuildContext contxt,
          StudentPlusState state,
        ) {
          return ValueListenableBuilder(
              valueListenable: filterNotifier,
              child: Container(),
              builder: (BuildContext context, dynamic value, Widget? child) {
                if (state is StudentPlusWorkSuccess && state.obj.length > 0) {
                  return PlusCustomFloatingActionButton(onPressed: () async {
                    //GET THE CURRENT USER PROFILE DETAIL
                    List<UserInformation> userProfileInfoData =
                        await UserGoogleProfile.getUserProfile();
                    //ShOW LOADING
                    Utility.showLoadingDialog(
                        context: context, isOCR: true, msg: 'Please Wait...');

                    if (userProfileInfoData[0].studentPlusGoogleDriveFolderId ==
                            null ||
                        userProfileInfoData[0].studentPlusGoogleDriveFolderId ==
                            "") {
                      _checkDriveFolderExistsOrNot();
                    } else {
                      getStundentGooglePresentationDetails();
                    }
                  });
                } else {
                  return Container();
                }
              });
        });
  }

  _shareBottomSheetMenu(
      {required StudentPlusDetailsModel studentDetails,
      int? studentGooglePresentationRecordId}) async {
    //to remove loading popup
    Navigator.of(context).pop();
    final result = await showModalBottomSheet(
        // clipBehavior: Clip.antiAliasWithSaveLayer,
        useRootNavigator: true,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        // animationCurve: Curves.easeOutQuart,
        elevation: 10,
        context: context,
        builder: (BuildContext context) {
          return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return StudentPlusOptionBottomSheet(
                studentGooglePresentationRecordId:
                    studentGooglePresentationRecordId,
                filterName: filterNotifier.value ?? '',
                studentDetails: studentDetails,
                resultSummaryIconsModalList: resultSummaryIconsModalList,
                height: MediaQuery.of(context).size.height * 0.35);
          });
        });
    if (result != null) {
      widget.studentDetails = result;
    }
  }

  BlocListener googleDriveBlocListener() {
    return BlocListener<GoogleDriveBloc, GoogleDriveState>(
        bloc: googleDriveBloc,
        child: Container(),
        listener: (context, state) async {
          //Checking Google Folder State
          if (state is GoogleFolderCreated) {
            //Trigger this event to get the student google presentations details
            getStundentGooglePresentationDetails();
          }
          if (state is ErrorState) {
            Navigator.of(context).pop();
            if (state.errorMsg == 'ReAuthentication is required') {
              await Authentication.reAuthenticationRequired(
                  context: context,
                  errorMessage: state.errorMsg!,
                  scaffoldKey: scaffoldKey);
            } else {
              Utility.currentScreenSnackBar(
                  state.errorMsg == 'NO_CONNECTION' ||
                          state.errorMsg == 'Connection failed' ||
                          state.errorMsg == 'Software caused connection abort'
                      ? 'Make sure you have a proper Internet connection'
                      : "Something Went Wrong. Please Try Again.",
                  null);
            }
          }
        });
  }

  void _checkDriveFolderExistsOrNot() async {
    //FOR STUDENT PLUS
    //this is get the user profile details
    final List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();
    final UserInformation userProfile = _profileData[0];

    //It will trigger the drive event to check is that (SOLVED STUDENT+) folder in drive
    //is available or not if not this will create one or the available get the drive folder id
    googleDriveBloc.add(GetDriveFolderIdEvent(
        fromGradedPlusAssessmentSection: false,
        isReturnState: true,
        token: userProfile.authorizationToken,
        folderName: "SOLVED STUDENT+",
        refreshToken: userProfile.refreshToken));
  }

// get the student google presentation details
  void getStundentGooglePresentationDetails() {
    _studentPlusForStudentGooglePresentationBloc.add(
        GetStudentPlusWorkGooglePresentationDetails(
            studentDetails: widget.studentDetails,
            schoolDBN: Globals.schoolDbnC ?? '',
            filterName: filterNotifier.value ?? ''));
  }

  BlocListener _studentPlusForStudentGooglePresentationBlocListener() {
    return BlocListener(
        bloc: _studentPlusForStudentGooglePresentationBloc,
        child: Container(),
        listener: (context, state) async {
          if (state is GetStudentPlusWorkGooglePresentationDetailsSuccess) {
            // the student Google Presentation RecordId if need to udpate the record with new Presentation id and Presentation url
            //if this is null or empty this will create new record
            int? studentGooglePresentationRecordId;

            if (state.studentGooglePresentationDetail != false) {
              StudentGooglePresentationDetailModal obj =
                  state.studentGooglePresentationDetail;
             // print(obj.googlePresentationId);
              widget.studentDetails.studentGooglePresentationId =
                  obj.googlePresentationId ?? "";
              widget.studentDetails.studentGooglePresentationUrl =
                  obj.googlePresentationURL ?? '';

              studentGooglePresentationRecordId = obj.id;
            } else {
              widget.studentDetails.studentGooglePresentationId = '';
              widget.studentDetails.studentGooglePresentationUrl = '';
            }

            _shareBottomSheetMenu(
                studentDetails: widget.studentDetails,
                studentGooglePresentationRecordId:
                    studentGooglePresentationRecordId);
          }
          if (state is StudentPlusErrorReceived) {
            Navigator.of(context).pop();
            Utility.currentScreenSnackBar(
                state.err == 'NO_CONNECTION' ||
                        state.err == 'Connection failed' ||
                        state.err == 'Software caused connection abort'
                    ? 'Make sure you have a proper Internet connection'
                    : "Something Went Wrong. Please Try Again.",
                null);
          }
        });
  }
}
