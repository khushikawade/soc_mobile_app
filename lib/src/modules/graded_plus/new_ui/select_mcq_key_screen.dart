import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/services/user_profile.dart';
import 'package:Soc/src/modules/graded_plus/bloc/graded_plus_bloc.dart';
import 'package:Soc/src/modules/graded_plus/modal/answer_key_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/camera_screen.dart';
import 'package:Soc/src/modules/graded_plus/ui/camera_screen.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_fab.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/modules/student_plus/widgets/screen_title_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bouncing_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../google_drive/bloc/google_drive_bloc.dart';
import '../widgets/common_ocr_appbar.dart';

class GradedPlusMultipleChoice extends StatefulWidget {
  const GradedPlusMultipleChoice({Key? key}) : super(key: key);

  @override
  State<GradedPlusMultipleChoice> createState() =>
      _GradedPlusMultipleChoiceState();
}

class _GradedPlusMultipleChoiceState extends State<GradedPlusMultipleChoice> {
  @override
  void initState() {
    // TODO: implement initState
    Globals.pointPossible = '1';

    FirebaseAnalyticsService.addCustomAnalyticsEvent("multiple_choice_screen");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'multiple_choice_screen',
        screenClass: 'GradedPlusMultipleChoice');
    super.initState();
  }

  final ValueNotifier<String> selectedAnswerKey = ValueNotifier<String>('');
  GoogleDriveBloc _googleDriveBloc = new GoogleDriveBloc();
  final OcrBloc _ocrBlocLogs = new OcrBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime currentDateTime = DateTime.now(); //DateTime

  int myTimeStamp = DateTime.now().microsecondsSinceEpoch;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar(),
          body: body(),
          floatingActionButton: floatingActionButton(),
          floatingActionButtonLocation:
              // FloatingActionButtonLocation.centerFloat,
              FloatingActionButtonLocation.miniCenterFloat,
        ),
        BlocListener(
            bloc: _googleDriveBloc,
            child: Container(),
            listener: (context, state) async {
              if (state is GoogleDriveLoading) {
                Utility.showLoadingDialog(context: context, isOCR: true);
              }
              if (state is GoogleSuccess) {
                Navigator.of(context).pop();
                Globals.googleDriveFolderId?.isNotEmpty ?? false
                    ? _beforeNavigateOnCameraSection()
                    : Utility.currentScreenSnackBar(
                        "Something Went Wrong. Please Try Again.", null);
              }
              if (state is ErrorState) {
                if (Globals.sessionId == '') {
                  PlusUtility.updateUserLogsSessionId();
                }

                PlusUtility.updateLogs(
                    activityType: 'GRADED+',
                    activityId: '1',
                    description: 'Start Scanning Failed',
                    operationResult: 'Failure');

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
              }
            })
      ],
    );
  }

  PreferredSizeWidget appBar() {
    return CustomOcrAppBarWidget(
      plusAppName: 'GRADED+',
      fromGradedPlus: true,
      isSuccessState: ValueNotifier<bool>(true),
      isBackOnSuccess: ValueNotifier<bool>(false),
      key: GlobalKey(),
      isBackButton: true,
    );
  }

  Widget body() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: StudentPlusOverrides.kSymmetricPadding),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SpacerWidget(StudentPlusOverrides.KVerticalSpace / 10),
        PlusScreenTitleWidget(
          kLabelSpacing: 0,
          text: 'Answer Key',
          backButton: true,
        ),
        SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
        Expanded(
          child: answerKeyButtons(),
        ),
      ]),
    );
  }

  Widget floatingActionButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ValueListenableBuilder(
            valueListenable: selectedAnswerKey,
            child: Container(),
            builder: (BuildContext context, dynamic value, Widget? child) {
              return GradedPlusCustomFloatingActionButton(
                isExtended: true,
                title: 'Next',
                backgroundColor: selectedAnswerKey.value.isNotEmpty
                    ? AppTheme.kButtonColor.withOpacity(1.0)
                    : Colors.grey.shade400,
                fabWidth: MediaQuery.of(context).size.width / 1.5,
                onPressed: () async {
                  if (selectedAnswerKey.value.isEmpty) {
                    Utility.currentScreenSnackBar(
                        "Select the Answer Key", null);
                  } else {
                    Fluttertoast.cancel();
                    Globals.googleDriveFolderId?.isEmpty ?? true
                        ? _triggerDriveFolderEvent(false)
                        : _beforeNavigateOnCameraSection();
                  }
                },
              );
            }),
      ],
    );
  }

  void navigateToCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GradedPlusCameraScreen(
          isMcqSheet: true,
          selectedAnswer: selectedAnswerKey.value,
          isFromHistoryAssessmentScanMore: false,
          onlyForPicture: false,
          isScanMore: false,
          pointPossible: Globals.pointPossible,
          isFlashOn: ValueNotifier<bool>(false),
        ),
        // settings: RouteSettings(name: "/home")
      ),
    );
  }

  Widget answerKeyButtons() {
    return ValueListenableBuilder(
        valueListenable: selectedAnswerKey,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return LayoutBuilder(builder: (context, constraints) {
            return new GridView.count(
                padding: EdgeInsets.symmetric(vertical: 10),
                childAspectRatio: constraints.biggest.aspectRatio * 3 / 1.50,
                shrinkWrap: true,
                crossAxisCount: 2,
                physics: NeverScrollableScrollPhysics(),
                children: AnswerKeyModal.answerKeyModelList
                    .map((AnswerKeyModal value) {
                  return _buildCircularWidget(value, constraints);
                }).toList());
          });
        });
  }

  Widget _buildCircularWidget(
      AnswerKeyModal value, BoxConstraints constraints) {
    return Bouncing(
      child: GestureDetector(
          onTap: () {
            selectedAnswerKey.value = value.title!;
            FirebaseAnalyticsService.addCustomAnalyticsEvent(
                "answer_key_selected_${value.title}");
            PlusUtility.updateLogs(
                activityType: 'GRADED+',
                activityId: '29',
                description: 'MCQ Selection Answer key selected ${value.title}',
                operationResult: 'Success');
          },
          child: Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.all(constraints.biggest.aspectRatio * 15),
            alignment: Alignment.center,
            child: Utility.textWidget(
              text: value.title!,
              context: context,
              textTheme: Theme.of(context).textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: selectedAnswerKey.value == value.title!
                      ? AppTheme.kSelectedColor
                      : Colors.black),
            ),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: value.title == selectedAnswerKey.value
                      ? AppTheme.kSelectedColor.withOpacity(0.8)
                      : Colors.transparent,
                  width: value.title == selectedAnswerKey.value ? 5 : 1.5,
                ),
                color: value.color),
          )),
    );
  }

  void _triggerDriveFolderEvent(bool isTriggeredAssessmentSection) async {
    List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();

    _googleDriveBloc.add(GetDriveFolderIdEvent(
        fromGradedPlusAssessmentSection:
            isTriggeredAssessmentSection ? true : null,
        isReturnState: true,
        //  filePath: file,
        token: _profileData[0].authorizationToken,
        folderName: "SOLVED GRADED+",
        refreshToken: _profileData[0].refreshToken));
  }

  void _beforeNavigateOnCameraSection() {
    if (Globals.sessionId == '') {
      PlusUtility.updateUserLogsSessionId();
    }

    PlusUtility.updateLogs(
        activityType: 'GRADED+',
        activityId: '1',
        description: 'Start Scanning',
        operationResult: 'Success');

    navigateToCamera();
  }
}
