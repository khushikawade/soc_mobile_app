import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/model/user_profile.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/answer_key_modal.dart';
import 'package:Soc/src/modules/ocr/modal/user_info.dart';
import 'package:Soc/src/modules/ocr/ui/camera_screen.dart';
import 'package:Soc/src/modules/ocr/ui/list_assessment_summary.dart';
import 'package:Soc/src/modules/ocr/widgets/ocr_background_widget.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bouncing_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../google_drive/bloc/google_drive_bloc.dart';
import '../widgets/common_ocr_appbar.dart';

class MultipleChoiceSection extends StatefulWidget {
  const MultipleChoiceSection({Key? key}) : super(key: key);

  @override
  State<MultipleChoiceSection> createState() => _MultipleChoiceSectionState();
}

class _MultipleChoiceSectionState extends State<MultipleChoiceSection> {
  @override
  void initState() {
    // TODO: implement initState
    Globals.pointpossible = '1';
    super.initState();
  }

  final ValueNotifier<String> selectedAnswerKey = ValueNotifier<String>('');
  GoogleDriveBloc _googleDriveBloc = new GoogleDriveBloc();
  final OcrBloc _ocrBlocLogs = new OcrBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime currentDateTime = DateTime.now(); //DateTime

  int myTimeStamp = DateTime.now().microsecondsSinceEpoch;
  static const double _KVerticalSpace = 60.0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackGroundImgWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomOcrAppBarWidget(
            isSuccessState: ValueNotifier<bool>(true),
            isBackOnSuccess: ValueNotifier<bool>(false),
            key: GlobalKey(),
            isBackButton: true,
          ),
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //SpacerWidget(_KVerticalSpace * 0.05),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Utility.textWidget(
                    text: 'Answer Key',
                    context: context,
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                SpacerWidget(_KVerticalSpace / 5),
                //  answerKeyButtons()
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: answerKeyButtons(),
                  ),
                ),
              ]),
          floatingActionButton: floatingActionButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ],
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
              return FloatingActionButton.extended(
                  extendedPadding: EdgeInsets.symmetric(horizontal: 20),
                  isExtended: true,
                  backgroundColor: selectedAnswerKey.value.isNotEmpty
                      ? AppTheme.kButtonColor.withOpacity(1.0)
                      : Colors.grey.shade400,
                  onPressed: () async {
                    if (selectedAnswerKey.value.isEmpty) {
                      Utility.currentScreenSnackBar(
                          "Select the Answer Key", null);
                    } else {
                      Fluttertoast.cancel();
                      if (Globals.googleDriveFolderId!.isEmpty) {
                        _triggerDriveFolderEvent(false);
                      } else {
                        _beforeNavigateOnCameraSection();
                      }
                      //  navigateToCamera();
                    }
                  },
                  label: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Utility.textWidget(
                        context: context,
                        text: 'Next',
                        textTheme: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(
                                color: Theme.of(context).backgroundColor)),
                  ));
            }),
        // BlocListener<GoogleDriveBloc, GoogleDriveState>(
        //     bloc: _googleDriveBloc,
        //     child: Container(),
        //     listener: (context, state) async {
        //       if (state is GoogleDriveLoading) {
        //         Utility.showLoadingDialog(context, true);
        //       }
        //       if (state is GoogleSuccess) {
        //         if (state.assessmentSection == true) {
        //           Navigator.of(context).pop();
        //           _beforenavigateOnAssessmentSection();
        //         }
        //       }
        //       if (state is ErrorState) {
        //         if (Globals.sessionId == '') {
        //           Globals.sessionId =
        //               "${Globals.teacherEmailId}_${myTimeStamp.toString()}";
        //         }
        //         _ocrBlocLogs.add(LogUserActivityEvent(
        //             sessionId: Globals.sessionId,
        //             teacherId: Globals.teacherId,
        //             activityId: '1',
        //             accountId: Globals.appSetting.schoolNameC,
        //             accountType:
        //                 Globals.isPremiumUser == true ? "Premium" : "Free",
        //             dateTime: currentDateTime.toString(),
        //             description: 'Start Scanning Failed',
        //             operationResult: 'Failed'));
        //         if (state.errorMsg == 'ReAuthentication is required') {
        //           await Utility.refreshAuthenticationToken(
        //               isNavigator: true,
        //               errorMsg: state.errorMsg!,
        //               context: context,
        //               scaffoldKey: _scaffoldKey);

        //           _triggerDriveFolderEvent(state.isAssessmentSection);
        //         } else {
        //           Navigator.of(context).pop();
        //           Utility.currentScreenSnackBar(
        //               "Something Went Wrong. Please Try Again.", null);
        //         }
        //         // Utility.refreshAuthenticationToken(
        //         //     state.errorMsg!, context, _scaffoldKey);

        //         //  await _launchURL('Google Authentication');

        //       }
        //     }),
        // OfflineBuilder(
        //     child: Container(),
        //     connectivityBuilder: (BuildContext context,
        //         ConnectivityResult connectivity, Widget child) {
        //       final bool connected = connectivity != ConnectivityResult.none;
        //       return GestureDetector(
        //         onTap: () async {
        //           await FirebaseAnalyticsService.addCustomAnalyticsEvent(
        //               "assessment_history");
        //           if (!connected) {
        //             Utility.currentScreenSnackBar(
        //                 "No Internet Connection", null);
        //             return;
        //           }
        //           if (Globals.googleDriveFolderId!.isEmpty) {
        //             _triggerDriveFolderEvent(true);
        //           } else {
        //             _beforenavigateOnAssessmentSection();
        //           }
        //         },
        //         child: Container(
        //             padding: EdgeInsets.only(top: 10),
        //             // color: Colors.red,
        //             child: Utility.textWidget(
        //                 text: 'Assignment History',
        //                 context: context,
        //                 textTheme:
        //                     Theme.of(context).textTheme.headline2!.copyWith(
        //                           decoration: TextDecoration.underline,
        //                         ))),
        //       );
        //     }),
      ],
    );
  }

  void navigateToCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          isMcqSheet: true,
          selectedAnswer: selectedAnswerKey.value,
          isFromHistoryAssessmentScanMore: false,
          onlyForPicture: false,
          isScanMore: false,
          pointPossible: Globals.pointpossible,
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
                childAspectRatio: constraints.biggest.aspectRatio * 3 / 1.67,
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
        assessmentSection: isTriggeredAssessmentSection ? true : null,
        isFromOcrHome: true,
        //  filePath: file,
        token: _profileData[0].authorizationToken,
        folderName: "SOLVED GRADED+",
        refreshToken: _profileData[0].refreshToken));
  }

  void _beforeNavigateOnCameraSection() {
    if (Globals.sessionId == '') {
      Globals.sessionId = "${Globals.teacherEmailId}_${myTimeStamp.toString()}";
    }
    _ocrBlocLogs.add(LogUserActivityEvent(
        sessionId: Globals.sessionId,
        teacherId: Globals.teacherId,
        activityId: '1',
        accountId: Globals.appSetting.schoolNameC,
        accountType: Globals.isPremiumUser == true ? "Premium" : "Free",
        dateTime: currentDateTime.toString(),
        description: 'Start Scanning',
        operationResult: 'Success'));

    navigateToCamera();
  }
}
