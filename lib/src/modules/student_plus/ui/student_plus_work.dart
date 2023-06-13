import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/google_drive/model/user_profile.dart';
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
import 'package:Soc/src/modules/student_plus/ui/student_plus_search_page.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_app_bar.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_option_bottom_sheet.dart';
import 'package:Soc/src/modules/student_plus/widgets/work_filter_widget.dart';
import 'package:Soc/src/modules/student_plus/widgets/screen_title_widget.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_search_bar.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/image_popup.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class StudentPlusWorkScreen extends StatefulWidget {
  final StudentPlusDetailsModel studentDetails;

  const StudentPlusWorkScreen({Key? key, required this.studentDetails})
      : super(key: key);

  @override
  State<StudentPlusWorkScreen> createState() => _StudentPlusWorkScreenState();
}

class _StudentPlusWorkScreenState extends State<StudentPlusWorkScreen> {
  static const double _kLabelSpacing =
      20.0; // Used for space between the  widget
  // controller used for search page
  final _controller = TextEditingController();
  final StudentPlusBloc _studentPlusBloc = StudentPlusBloc();
  ValueNotifier<String> filterNotifier = ValueNotifier<String>('');
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  // List<StudentPlusWorkModel> studentWorkUpdatedList = [];
  FocusNode myFocusNode = new FocusNode();
  final GoogleSlidesPresentationBloc googleSlidesPresentationBloc =
      GoogleSlidesPresentationBloc();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  GoogleDriveBloc googleDriveBloc = GoogleDriveBloc();
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

    Utility.updateLogs(
        activityType: 'STUDENT+',
        activityId: '52',
        description: 'Student+ Work Screen',
        operationResult: 'Success');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: StudentPlusAppBar(
            titleIconCode: 0xe885,
            isWorkPage: true,
            // refresh: (v) {
            //   setState(() {});
            // },
          ),
          body: Container(
            padding: EdgeInsets.symmetric(
                horizontal: StudentPlusOverrides.kSymmetricPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpacerWidget(StudentPlusOverrides.KVerticalSpace / 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    // filterIcon()
                  ],
                ),
                SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
                StudentPlusInfoSearchBar(
                  hintText:
                      '${widget.studentDetails.firstNameC ?? ''} ${widget.studentDetails.lastNameC ?? ''}',
                  isMainPage: false,
                  autoFocus: false,
                  onTap: () {
                    pushNewScreen(
                      context,
                      screen: StudentPlusSearchScreen(
                          fromStudentPlusDetailPage: true,
                          index: 2,
                          studentDetails: widget.studentDetails),
                      withNavBar: false,
                    );
                  },
                  controller: _controller,
                  kLabelSpacing: _kLabelSpacing,
                  focusNode: myFocusNode,
                ),
                SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
                listViewWidget(),
                SpacerWidget(20)
              ],
            ),
          ),
          floatingActionButton: fab(),
        ),
        googleSlidesPresentationBlocListener(),
        googleDriveBlocListener(),
      ],
    );
  }

  /* ----------------------- Widget to show filter icon ----------------------- */
  Widget filterIcon({required List<StudentPlusWorkModel> list}) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTap: () {
            /*-------------------------User Activity Track START----------------------------*/
            Utility.updateLogs(
                activityType: 'STUDENT+',
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
        Utility.updateLogs(
            activityType: 'STUDENT+',
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
                if (filterNotifier.value == '' &&
                    state is StudentPlusWorkSuccess &&
                    state.obj.length > 0) {
                  return PlusCustomFloatingActionButton(onPressed: () {
                    if (StudentPlusOverrides
                            ?.studentPlusGoogleDriveFolderId?.isEmpty ??
                        true) {
                      _checkDriveFolderExistsOrNot();
                    } else if (widget
                            .studentDetails?.googlePresentationUrl?.isEmpty ??
                        true) {
                      getGooglePresentationUrl();
                    } else {
                      _shareBottomSheetMenu();
                    }
                  });
                } else {
                  return Container();
                }
              });
        });
  }

  _shareBottomSheetMenu() async {
    List<ResultSummaryIcons> resultSummaryIconsModalList = [
      ResultSummaryIcons(
        title: 'Sync Presentation',
        svgPath: '',
      ),
    ];
    if (widget.studentDetails.googlePresentationUrl?.isNotEmpty ?? false) {
      resultSummaryIconsModalList.add(
        ResultSummaryIcons(
          title: 'Go to Presentation',
          svgPath: 'assets/ocr_result_section_bottom_button_icons/Slide.svg',
        ),
      );
    }

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
              return StudentPlusOptionBottomSheet(
                  studentDetails: widget.studentDetails,
                  resultSummaryIconsModalList: resultSummaryIconsModalList,
                  height: MediaQuery.of(context).size.height * 0.25);
            },
          );
        });
  }

  void getGooglePresentationUrl() {
    Utility.showLoadingDialog(
        context: context, isOCR: true, msg: 'Please Wait...');
    googleSlidesPresentationBloc.add(GetStudentPlusPresentationURL(
        studentDetails: widget.studentDetails,
        studentPlusDriveFolderId:
            StudentPlusOverrides.studentPlusGoogleDriveFolderId));
  }

  BlocListener googleSlidesPresentationBlocListener() {
    return BlocListener<GoogleSlidesPresentationBloc,
            GoogleSlidesPresentationState>(
        bloc: googleSlidesPresentationBloc,
        child: Container(),
        listener: (context, state) async {
          if (state is GetGooglePresentationURLSuccess) {
            Navigator.pop(context, false);
            widget.studentDetails.googlePresentationUrl =
                state.googlePresentationFileUrl;

            _shareBottomSheetMenu();
          }

          if (state is GoogleSlidesPresentationErrorState) {
            Navigator.pop(context, false);
            if (state.errorMsg == 'ReAuthentication is required') {
              await Utility.refreshAuthenticationToken(
                  isNavigator: false,
                  errorMsg: state.errorMsg!,
                  context: context,
                  scaffoldKey: scaffoldKey);
            } else {
              Utility.currentScreenSnackBar(
                  state.errorMsg == 'NO_CONNECTION'
                      ? 'No Internet Connection'
                      : "Something Went Wrong. Please Try Again.",
                  null);
            }
          }
        });
  }

  BlocListener googleDriveBlocListener() {
    return BlocListener<GoogleDriveBloc, GoogleDriveState>(
        bloc: googleDriveBloc,
        child: Container(),
        listener: (context, state) async {
          print("On student work ------------$state---------");
          //Checking Google Folder State
          if (state is GoogleSuccess) {
            Navigator.of(context).pop();
            if (StudentPlusOverrides
                    ?.studentPlusGoogleDriveFolderId?.isNotEmpty ??
                false) {
              getGooglePresentationUrl();
            } else {
              // Navigator.of(context).pop();
              Utility.currentScreenSnackBar(
                  "Something Went Wrong. Please Try Again.", null);
            }
          }
          if (state is ErrorState) {
            Navigator.of(context).pop();
            if (state.errorMsg == 'ReAuthentication is required') {
              await Utility.refreshAuthenticationToken(
                  isNavigator: false,
                  errorMsg: state.errorMsg!,
                  context: context,
                  scaffoldKey: scaffoldKey);
            } else {
              Utility.currentScreenSnackBar(
                  "Something Went Wrong. Please Try Again.", null);
            }
          }
        });
  }

  void _checkDriveFolderExistsOrNot() async {
    Utility.showLoadingDialog(
        context: context, isOCR: true, msg: 'Please Wait...');
    //FOR STUDENT PLUS

    //this is get the user profile details
    final List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();
    final UserInformation userProfile = _profileData[0];

    print("callig the the event to check the folder available or not ");

    //It will trigger the drive event to check is that (SOLVED STUDENT+) folder in drive
    //is available or not if not this will create one or the available get the drive folder id
    googleDriveBloc.add(GetDriveFolderIdEvent(
        fromGradedPlusAssessmentSection: false,
        isReturnState: true,
        token: userProfile.authorizationToken,
        folderName: "SOLVED STUDENT+",
        refreshToken: userProfile.refreshToken));
  }
}
