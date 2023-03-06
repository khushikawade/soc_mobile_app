import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/google_drive/model/user_profile.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/user_info.dart';
import 'package:Soc/src/modules/ocr/ui/list_assessment_summary.dart';
import 'package:Soc/src/modules/ocr/ui/mcq_correct_answer_screen.dart';
import 'package:Soc/src/modules/ocr/ui/ocr_home.dart';
import 'package:Soc/src/modules/ocr/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/widgets/ocr_background_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bouncing_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SelectAssessmentType extends StatefulWidget {
  const SelectAssessmentType({Key? key}) : super(key: key);

  @override
  State<SelectAssessmentType> createState() => _SelectAssessmentTypeState();
}

class _SelectAssessmentTypeState extends State<SelectAssessmentType> {
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);
  DateTime currentDateTime = DateTime.now(); //DateTime
  GoogleDriveBloc _googleDriveBloc = new GoogleDriveBloc();
  final OcrBloc _ocrBlocLogs = new OcrBloc();
  List<String> selectionList = ['Constructed Response', 'Multiple Choice'];
  final ValueNotifier<String> selectedAnswerKey = ValueNotifier<String>('');
  int myTimeStamp = DateTime.now().microsecondsSinceEpoch;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    FirebaseAnalyticsService.addCustomAnalyticsEvent("state_selection_page");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'state_selection_page', screenClass: 'StateSelectionPage');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackGroundImgWidget(),
        Scaffold(
          appBar: CustomOcrAppBarWidget(
            //Show home button in standard app and hide in standalone
            assessmentDetailPage: Overrides.STANDALONE_GRADED_APP ? true : null,
            isOcrHome: true,
            isSuccessState: ValueNotifier<bool>(true),
            isBackOnSuccess: isBackFromCamera,
            key: GlobalKey(),
            isBackButton: Overrides.STANDALONE_GRADED_APP ? true : false,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Utility.textWidget(
                  text: 'Select Assignment Type',
                  context: context,
                  textTheme: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              SpacerWidget(MediaQuery.of(context).size.height * 0.02),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: selectionList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buttonDesign(index: index);
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: floatingActionButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        )
      ],
    );
  }

  Widget buttonDesign({required int index}) {
    return ValueListenableBuilder(
        valueListenable: selectedAnswerKey,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return Bouncing(
            child: GestureDetector(
              onTap: () {
                selectedAnswerKey.value = selectionList[index];
                Globals.scanMoreStudentInfoLength = 0;
                if (selectedAnswerKey.value.isEmpty) {
                  Utility.currentScreenSnackBar("Select the Answer Key", null);
                } else if (selectedAnswerKey.value == 'Multiple Choice') {
                  Utility.updateLogs(
                      activityId: '28',
                      description: 'MCQ Type Selection',
                      operationResult: 'Success');
                  Fluttertoast.cancel();
                  Globals.scoringRubric = '0-1';

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MultipleChoiceSection()));
                } else {
                  Utility.updateLogs(
                      activityId: '27',
                      description: 'Constructive Type Selection',
                      operationResult: 'Success');
                  Fluttertoast.cancel();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OpticalCharacterRecognition()));
                }

                FirebaseAnalyticsService.addCustomAnalyticsEvent(
                    "assessment_type_selected_${selectedAnswerKey.value}");
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 15,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: selectedAnswerKey.value ==
                                          selectionList[index]
                                      ? AppTheme.kSelectedColor
                                      : Colors.grey,
                                  border: Border.all(
                                    width: 2,
                                    color: selectedAnswerKey.value ==
                                            selectionList[index]
                                        ? AppTheme.kSelectedColor
                                        : Colors.transparent,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              height: MediaQuery.of(context).size.height * 0.19,
                              width: MediaQuery.of(context).size.width * 0.903,
                            ),
                            AnimatedContainer(
                              decoration: BoxDecoration(
                                  color: Color(0xff000000) !=
                                          Theme.of(context).backgroundColor
                                      ? Color(0xffF7F8F9)
                                      : Color(0xff111C20),
                                  border: Border.all(
                                    width: 2,
                                    color: selectedAnswerKey.value ==
                                            selectionList[index]
                                        ? AppTheme.kSelectedColor
                                        : Colors.transparent,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              height:
                                  MediaQuery.of(context).size.height * 0.185,
                              width: MediaQuery.of(context).size.width * 0.9,
                              duration: Duration(microseconds: 100),
                              child: Center(
                                  child: Container(
                                      padding: EdgeInsets.only(top: 50),
                                      child: Utility.textWidget(
                                          text: selectionList[index],
                                          context: context,
                                          textTheme: Theme.of(context)
                                              .textTheme
                                              .headline1))),
                            ),
                          ],
                        )),
                  ),
                  AnimatedContainer(
                    duration: Duration(microseconds: 100),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: selectedAnswerKey.value == selectionList[index]
                              ? AppTheme.kSelectedColor
                              : Colors.transparent,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.18),
                    child: CircleAvatar(
                      backgroundColor:
                          Color(0xff000000) != Theme.of(context).backgroundColor
                              ? Colors.grey.shade200
                              : Colors.grey.shade800,
                      radius: MediaQuery.of(context).size.height * 0.07,
                      child: CircleAvatar(
                        backgroundColor: Color(0xff000000) !=
                                Theme.of(context).backgroundColor
                            ? Color(0xffF7F8F9)
                            : Color(0xff111C20),
                        radius: MediaQuery.of(context).size.height * 0.06,
                        child: Icon(
                            IconData(index == 1 ? 0xe833 : 0xe87c,
                                fontFamily: Overrides.kFontFam,
                                fontPackage: Overrides.kFontPkg),
                            size: index == 0 ? 35 : 42,
                            color:
                                selectedAnswerKey.value == selectionList[index]
                                    ? AppTheme.kSelectedColor
                                    : AppTheme.kButtonColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget floatingActionButton() {
    return Overrides.STANDALONE_GRADED_APP != true
        ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocListener<GoogleDriveBloc, GoogleDriveState>(
                  bloc: _googleDriveBloc,
                  child: Container(),
                  listener: (context, state) async {
                    if (state is GoogleDriveLoading) {
                      Utility.showLoadingDialog(context: context, isOCR: true);
                    }
                    if (state is GoogleSuccess) {
                      if (state.assessmentSection == true) {
                        Navigator.of(context).pop();
                        _beforenavigateOnAssessmentSection();
                      }
                    }
                    if (state is ErrorState) {
                      if (Globals.sessionId == '') {
                        Globals.sessionId =
                            "${Globals.teacherEmailId}_${myTimeStamp.toString()}";
                      }
                      _ocrBlocLogs.add(LogUserActivityEvent(
                          sessionId: Globals.sessionId,
                          teacherId: Globals.teacherId,
                          activityId: '1',
                          accountId: Globals.appSetting.schoolNameC,
                          accountType: Globals.isPremiumUser == true
                              ? "Premium"
                              : "Free",
                          dateTime: currentDateTime.toString(),
                          description: 'Start Scanning Failed',
                          operationResult: 'Failed'));
                      if (state.errorMsg == 'ReAuthentication is required') {
                        await Utility.refreshAuthenticationToken(
                            isNavigator: true,
                            errorMsg: state.errorMsg!,
                            context: context,
                            scaffoldKey: _scaffoldKey);

                        _triggerDriveFolderEvent(state.isAssessmentSection);
                      } else {
                        Navigator.of(context).pop();
                        Utility.currentScreenSnackBar(
                            "Something Went Wrong. Please Try Again.", null);
                      }
                      // Utility.refreshAuthenticationToken(
                      //     state.errorMsg!, context, _scaffoldKey);

                      //  await _launchURL('Google Authentication');
                    }
                  }),
              OfflineBuilder(
                  child: Container(),
                  connectivityBuilder: (BuildContext context,
                      ConnectivityResult connectivity, Widget child) {
                    final bool connected =
                        connectivity != ConnectivityResult.none;
                    return GestureDetector(
                      onTap: () async {
                        await FirebaseAnalyticsService.addCustomAnalyticsEvent(
                            "assessment_history");
                        if (!connected) {
                          Utility.currentScreenSnackBar(
                              "No Internet Connection", null);
                          return;
                        }
                        if (Globals.googleDriveFolderId!.isEmpty ||
                            Globals.googleDriveFolderId == '') {
                          _triggerDriveFolderEvent(true);
                        } else {
                          _beforenavigateOnAssessmentSection();
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.only(top: 10),
                          // color: Colors.red,
                          child: Utility.textWidget(
                              text: 'Assignment History',
                              context: context,
                              textTheme: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(
                                    decoration: TextDecoration.underline,
                                  ))),
                    );
                  }),
            ],
          )
        : Container();
  }

  void _triggerDriveFolderEvent(bool isTriggerdbyAssessmentSection) async {
    List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();

    _googleDriveBloc.add(GetDriveFolderIdEvent(
        assessmentSection: isTriggerdbyAssessmentSection ? true : null,
        isFromOcrHome: true,
        //  filePath: file,
        token: _profileData[0].authorizationToken,
        folderName: "SOLVED GRADED+",
        refreshToken: _profileData[0].refreshToken));
  }

  void _beforenavigateOnAssessmentSection() {
    if (Globals.sessionId == '') {
      Globals.sessionId = "${Globals.teacherEmailId}_${myTimeStamp.toString()}";
    }
    _ocrBlocLogs.add(LogUserActivityEvent(
        sessionId: Globals.sessionId,
        teacherId: Globals.teacherId,
        activityId: '4',
        accountId: Globals.appSetting.schoolNameC,
        accountType: Globals.isPremiumUser == true ? "Premium" : "Free",
        dateTime: currentDateTime.toString(),
        description: 'Assignment History page from Select Assignment page',
        operationResult: 'Success'));
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AssessmentSummary(
                selectedFilterValue: 'All',
                isFromHomeSection: true,
              )),
    );
  }
}
