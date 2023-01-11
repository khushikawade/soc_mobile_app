import 'dart:convert';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/modal/google_classroom_courses.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/google_drive/model/assessment.dart';
import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/ocr/ui/create_assessment.dart';
import 'package:Soc/src/modules/ocr/ui/results_summary.dart';
import 'package:Soc/src/modules/ocr/ui/success.dart';
import 'package:Soc/src/modules/ocr/widgets/common_popup.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

class CameraScreen extends StatefulWidget {
  final String? pointPossible;
  final String? selectedAnswer;
  final bool? isMcqSheet;
  final bool? isScanMore;
  final onlyForPicture;
  final bool isFromHistoryAssessmentScanMore;
  final scaffoldKey;
  final bool? oneTimeCamera;
  final bool? createdAsPremium;
  final String? questionImageLink;
  final HistoryAssessment? obj;
  final String? assessmentName;
  final int? lastAssessmentLength;
  // bool flash;
  ValueNotifier<bool>? isFlashOn = ValueNotifier<bool>(false);
  CameraScreen(
      {Key? key,
      this.lastAssessmentLength,
      this.assessmentName,
      required this.pointPossible,
      required this.isScanMore,
      required this.onlyForPicture,
      this.questionImageLink,
      this.scaffoldKey,
      required this.isFromHistoryAssessmentScanMore,
      this.oneTimeCamera,
      this.isMcqSheet,
      this.selectedAnswer,
      this.createdAsPremium,
      this.obj,
      required this.isFlashOn})
      : super(key: key);
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

List<CameraDescription> cameras = [];

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //print("inside lifecycle");
    final CameraController? cameraController = controller!.value;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      //print(' inside     AppLifecycleState.inactive');
      // Free up memory when camera not active
      //   cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      //print(' inside    AppLifecycleState.resumed');
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  CameraDescription? description;
  ValueNotifier<CameraController>? controller =
      ValueNotifier<CameraController>(CameraController(
    cameras[0],
    ResolutionPreset.high,
    imageFormatGroup:
        Platform.isIOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.jpeg,
    enableAudio: false,
  ));

  ValueNotifier<bool>? _isCameraInitialized = ValueNotifier<bool>(false);
  int? scanMoreAssessmentList;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleDriveBloc _driveBloc = GoogleDriveBloc();
  GoogleDriveBloc _driveBloc2 = GoogleDriveBloc();

  LocalDatabase<String> _localDb = LocalDatabase('class_suggestions');
  List<String> classList = [
    'PK',
    'K',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '+'
  ];

  LocalDatabase<StudentAssessmentInfo> _studentInfoDb =
      LocalDatabase('student_info');

  LocalDatabase<StudentAssessmentInfo> _historyStudentInfoDb =
      LocalDatabase('history_student_info');

  @override
  void initState() {
    // widget.isFlashOn!.value = widget.isFlashOn;
    Wakelock.enable();

    Globals.iscameraPopup
        ? WidgetsBinding.instance
            .addPostFrameCallback((_) => _showStartDialog())
        : null;
    SystemChrome.setEnabledSystemUIOverlays([]);
    // Hide the status bar
    // SystemChrome.ssEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // widget.isScanMore == true
    //     ? scanMoreAssessmentList = Globals.studentInfo!.length
    //     : null;

    onNewCameraSelected(cameras[0]);
    // _checkPermission();
    FirebaseAnalyticsService.addCustomAnalyticsEvent("camera_screen");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'camera_screen', screenClass: 'CameraScreen');

    super.initState();
  }

  @override
  void dispose() {
    Wakelock.disable();
    controller?.dispose();
    setEnabledSystemUIMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            toolbarHeight:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 50
                    : 60,
            leadingWidth: 200,
            leading: Row(
              children: [
                FutureBuilder(
                    future: _getStudentInfoList(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<StudentAssessmentInfo>> snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!.length > 0
                            ? IconButton(
                                onPressed: () {
                                  //To dispose the snackbar message before navigating back if exist
                                  ScaffoldMessenger.of(context)
                                      .removeCurrentSnackBar();
                                  widget.onlyForPicture
                                      ? Navigator.pop(context, null)
                                      : Navigator.pop(context, true);
                                },
                                icon: Icon(
                                  IconData(0xe80d,
                                      fontFamily: Overrides.kFontFam,
                                      fontPackage: Overrides.kFontPkg),
                                  color: AppTheme.kButtonColor,
                                ),
                              )
                            : Container();
                      }
                      return CupertinoActivityIndicator(

                          // color: Colors.white,
                          );
                    }),
                ValueListenableBuilder(
                  builder:
                      (BuildContext context, dynamic value, Widget? child) {
                    return IconButton(
                        onPressed: () async {
                          widget.isFlashOn!.value = !widget.isFlashOn!.value;

                          try {
                            await controller!.value.setFlashMode(
                                widget.isFlashOn!.value
                                    ? FlashMode.always
                                    : FlashMode.off);
                          } catch (e) {}
                        },
                        icon: Icon(
                          widget.isFlashOn!.value == false
                              ? Icons.flash_off
                              : Icons.flash_on,
                          color: Colors.white,
                          size: 30,
                        ));
                  },
                  valueListenable: widget.isFlashOn!,
                  child: Container(),
                ),
              ],
            ),
            actions: [
              //For custom image use
              widget.onlyForPicture
                  ? Container()
                  : BlocListener<GoogleDriveBloc, GoogleDriveState>(
                      bloc: _driveBloc,
                      child: Container(),
                      listener: (context, state) async {
                        if (state is ShowLoadingDialog) {
                          Utility.showLoadingDialog(context, true);
                        }
                        if (state is GoogleSuccess) {
                          Navigator.of(context).pop();
                          if (widget.isFromHistoryAssessmentScanMore == true) {
                            Navigator.of(context)
                              ..pop()
                              ..pop()
                              ..pop();

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => ResultsSummary(
                                        isMcqSheet: widget.isMcqSheet,
                                        selectedAnswer: widget.selectedAnswer,
                                        obj: widget.obj,
                                        createdAsPremium:
                                            widget.createdAsPremium,
                                        historySecondTime: widget
                                                .isFromHistoryAssessmentScanMore
                                            ? true
                                            : null,
                                        assessmentName: Globals.assessmentName,
                                        shareLink: Globals.shareableLink ?? '',
                                        assessmentDetailPage: widget
                                            .isFromHistoryAssessmentScanMore,
                                        isScanMore: true,
                                        assessmentListLength:
                                            Globals.scanMoreStudentInfoLength,
                                      )),
                            );
                          } else {
                            setEnabledSystemUIMode();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultsSummary(
                                        isMcqSheet: widget.isMcqSheet,
                                        selectedAnswer: widget.selectedAnswer,
                                        createdAsPremium:
                                            widget.createdAsPremium,
                                        historySecondTime: widget
                                                .isFromHistoryAssessmentScanMore
                                            ? true
                                            : null,
                                        assessmentName: Globals.assessmentName,
                                        shareLink: Globals.shareableLink ?? '',
                                        assessmentDetailPage: widget
                                            .isFromHistoryAssessmentScanMore,
                                        isScanMore: true,
                                        assessmentListLength:
                                            Globals.scanMoreStudentInfoLength,
                                      )),
                            );
                          }
                        }
                        if (state is ErrorState) {
                          if (state.errorMsg ==
                              'ReAuthentication is required') {
                            await Utility.refreshAuthenticationToken(
                                isNavigator: true,
                                errorMsg: state.errorMsg!,
                                context: context,
                                scaffoldKey: _scaffoldKey);

                            _driveBloc.add(UpdateDocOnDrive(
                                isMcqSheet: widget.isMcqSheet ?? false,
                                questionImage: widget.questionImageLink ?? 'NA',
                                createdAsPremium: widget.createdAsPremium,
                                assessmentName: Globals.historyAssessmentName,
                                fileId: Globals.historyAssessmentFileId,
                                isLoading: true,
                                studentData: await Utility.getStudentInfoList(
                                    tableName:
                                        widget.isFromHistoryAssessmentScanMore ==
                                                true
                                            ? 'history_student_info'
                                            : 'student_info')));
                          } else {
                            Navigator.of(context).pop();
                            Utility.currentScreenSnackBar(
                                "Something Went Wrong. Please Try Again.",
                                null);
                          }
                        }
                        if (state is AddBlankSlidesOnDriveSuccess) {
                          _driveBloc.add(UpdateAssessmentImageToSlidesOnDrive(
                              slidepresentationId:
                                  Globals.googleSlidePresentationId));
                        }
                        if (state is GoogleAssessmentImagesOnSlidesUpdated) {
                          List<StudentAssessmentInfo> studentInfoDb =
                              await Utility.getStudentInfoList(
                                  tableName:
                                      widget.isFromHistoryAssessmentScanMore ==
                                              true
                                          ? 'history_student_info'
                                          : 'student_info');
                          StudentAssessmentInfo element = studentInfoDb[0];

                          //Updating remaining common details of assessment
                          element.subject = studentInfoDb.first.subject;
                          element.learningStandard =
                              studentInfoDb.first.learningStandard == null
                                  ? "NA"
                                  : studentInfoDb.first.learningStandard;
                          element.subLearningStandard =
                              studentInfoDb.first.subLearningStandard == null
                                  ? "NA"
                                  : studentInfoDb.first.subLearningStandard;
                          element.scoringRubric = Globals.scoringRubric;
                          element.customRubricImage =
                              studentInfoDb.first.customRubricImage ?? "NA";
                          element.grade = studentInfoDb.first.grade;
                          element.className = Globals.assessmentName!
                              .split("_")[1]; //widget.selectedClass;
                          element.questionImgUrl =
                              studentInfoDb.first.questionImgUrl;

                          await _studentInfoDb.putAt(0, element);
                          List l = await Utility.getStudentInfoList(
                              tableName: 'student_info');

                          _driveBloc.add(UpdateDocOnDrive(
                              isMcqSheet: widget.isMcqSheet ?? false,
                              questionImage: widget.questionImageLink ?? 'NA',
                              createdAsPremium: widget.createdAsPremium,
                              assessmentName: Globals.assessmentName!,
                              fileId: Globals.googleExcelSheetId,
                              isLoading: true,
                              studentData: await Utility.getStudentInfoList(
                                  tableName: 'student_info')));
                        }
                        if (state is GoogleSheetUpdateOnScanMoreSuccess) {
                          _driveBloc.add(UpdateDocOnDrive(
                              isMcqSheet: widget.isMcqSheet ?? false,
                              questionImage: widget.questionImageLink ?? 'NA',
                              createdAsPremium: widget.createdAsPremium ??
                                  Globals.isPremiumUser,
                              assessmentName: Globals.historyAssessmentName,
                              fileId: Globals.historyAssessmentFileId,
                              isLoading: true,
                              studentData: state.list));
                        }
                      }),

              widget.onlyForPicture
                  ? Container()
                  : Container(
                      padding: EdgeInsets.only(right: 5),
                      child: TextButton(
                        style: ButtonStyle(alignment: Alignment.center),
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
                        onPressed: () async {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          try {
                            await controller!.value.setFlashMode(FlashMode.off);
                          } catch (e) {}
                          Utility.updateLogs(
                              activityId: '19',
                              description: 'Assessment scan finished',
                              operationResult: 'Success');

                          List<StudentAssessmentInfo> studentInfoDb =
                              await Utility.getStudentInfoList(
                                  tableName:
                                      widget.isFromHistoryAssessmentScanMore ==
                                              true
                                          ? 'history_student_info'
                                          : 'student_info');

                          if (studentInfoDb.length > 0) {
                            if (widget.isFromHistoryAssessmentScanMore ==
                                true) {
                              _driveBloc.add(UpdateGoogleSlideOnScanMore(
                                  assessmentName: widget.assessmentName ?? '',
                                  isFromHistoryAssessment:
                                      widget.isFromHistoryAssessmentScanMore,
                                  lastAssessmentLength:
                                      widget.lastAssessmentLength ?? 0,
                                  slidePresentationId:
                                      Globals.googleSlidePresentationId!));
                            } else if (!widget
                                    .isFromHistoryAssessmentScanMore &&
                                widget.isScanMore == true) {
                              _driveBloc.add(AddBlankSlidesOnDrive(
                                  slidepresentationId:
                                      Globals.googleSlidePresentationId));
                            }

                            //     {

                            //   StudentAssessmentInfo element = studentInfoDb[0];

                            //   //Updating remaining common details of assessment
                            //   element.subject = studentInfoDb.first.subject;
                            //   element.learningStandard =
                            //       studentInfoDb.first.learningStandard == null
                            //           ? "NA"
                            //           : studentInfoDb.first.learningStandard;
                            //   element.subLearningStandard =
                            //       studentInfoDb.first.subLearningStandard ==
                            //               null
                            //           ? "NA"
                            //           : studentInfoDb.first.subLearningStandard;
                            //   element.scoringRubric = Globals.scoringRubric;
                            //   element.customRubricImage =
                            //       studentInfoDb.first.customRubricImage ?? "NA";
                            //   element.grade = studentInfoDb.first.grade;
                            //   element.className = Globals.assessmentName!
                            //       .split("_")[1]; //widget.selectedClass;
                            //   element.questionImgUrl =
                            //       studentInfoDb.first.questionImgUrl;

                            //   await _studentInfoDb.putAt(0, element);

                            //   _driveBloc.add(UpdateDocOnDrive(
                            //       questionImage:
                            //           widget.questionImageLink ?? 'NA',
                            //       createdAsPremium: widget.createdAsPremium,
                            //       assessmentName: Globals.assessmentName!,
                            //       fileId: Globals.googleExcelSheetId,
                            //       isLoading: true,
                            //       studentData: await Utility.getStudentInfoList(
                            //           tableName: 'student_info')));
                            // }

                            // else {
                            //   _driveBloc.add(UpdateDocOnDrive(
                            //       isMcqSheet: widget.isMcqSheet,
                            //       questionImage:
                            //           widget.questionImageLink ?? 'NA',
                            //       createdAsPremium: widget.createdAsPremium,
                            //       assessmentName: Globals.assessmentName!,
                            //       fileId: Globals.googleExcelSheetId,
                            //       isLoading: true,
                            //       studentData: await Utility.getStudentInfoList(
                            //           tableName: 'student_info')));
                            // }
                            else {
                              if (Overrides.STANDALONE_GRADED_APP == true) {
                                List<String> suggestionList =
                                    await getSuggestionChips();

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateAssessment(
                                          isMcqSheet: widget.isMcqSheet,
                                          selectedAnswer: widget.selectedAnswer,
                                          customGrades: classList,
                                          classSuggestions: suggestionList)),
                                );
                              } else {
                                List<String> classSuggestions =
                                    await _localDb.getData();
                                LocalDatabase<String> classSectionLocalDb =
                                    LocalDatabase('class_section_list');

                                List<String> localSectionList =
                                    await classSectionLocalDb.getData();

                                // Compares 2 list and update the changes in local database.
                                bool isClassChanges = false;
                                for (int i = 0; i < classList.length; i++) {
                                  if (!localSectionList
                                      .contains(classList[i])) {
                                    isClassChanges = true;
                                    break;
                                  }
                                }

                                if (localSectionList.isEmpty ||
                                    isClassChanges) {
                                  //print("local db is empty");
                                  classSectionLocalDb.clear();
                                  classList.forEach((String e) {
                                    classSectionLocalDb.addData(e);
                                  });
                                } else {
                                  //print("local db is not empty");
                                  classList = [];
                                  classList.addAll(localSectionList);
                                }
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateAssessment(
                                          isMcqSheet: widget.isMcqSheet,
                                          selectedAnswer: widget.selectedAnswer,
                                          customGrades: classList,
                                          classSuggestions: classSuggestions)),
                                );
                              }
                            }
                          } else {
                            Utility.showSnackBar(
                                _scaffoldKey,
                                "Assignment not found! Please scan a student Assignment to proceed further",
                                context,
                                null);
                          }
                        },
                      )),

              FutureBuilder(
                  future: _getStudentInfoList(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<StudentAssessmentInfo>> snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.length == 0
                          ? IconButton(
                              onPressed: () {
                                //To dispose the snackbar message before navigating back if exist
                                ScaffoldMessenger.of(context)
                                    .removeCurrentSnackBar();
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.close,
                                color: AppTheme.kButtonColor,
                              ),
                            )
                          : Container();
                    }
                    return CupertinoActivityIndicator(
                        //  color: Colors.white,
                        );
                  })
            ],
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
          ),
          body: ValueListenableBuilder(
              child: Container(),
              valueListenable: _isCameraInitialized!,
              builder: (BuildContext context, dynamic value, Widget? child) {
                return _isCameraInitialized!.value
                    ? LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                        return GestureDetector(
                          onTapDown: (details) =>
                              onViewFinderTap(details, constraints),
                          child: Stack(children: [
                            Center(child: controller!.value.buildPreview()),
                            Positioned(
                              bottom: 15.0,
                              child: Container(
                                color: Colors.transparent,
                                height: MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                    ? MediaQuery.of(context).size.height * 0.2
                                    : MediaQuery.of(context).size.height * 0.25,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Container(
                                      height: 90,
                                      width: 90,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.transparent,
                                          border: Border.all(
                                              color: Colors.white, width: 5)),
                                      padding: EdgeInsets.all(3),
                                      child: InkWell(
                                        onTap: () async {
                                          try {} catch (e) {}
                                          HapticFeedback.vibrate();
                                          XFile? rawImage = await takePicture();
                                          File imageFile = File(rawImage!.path);
                                          final bytes = File(rawImage.path)
                                              .readAsBytesSync();
                                          String img64 = base64Encode(bytes);

                                          int currentUnix = DateTime.now()
                                              .millisecondsSinceEpoch;
                                          final directory =
                                              await getApplicationDocumentsDirectory();
                                          String fileFormat =
                                              imageFile.path.split('.').last;

                                          await imageFile.copy(
                                            '${directory.path}/$currentUnix.$fileFormat',
                                          );

                                          if (widget.onlyForPicture) {
                                            Navigator.pop(context, imageFile);
                                          } else {
                                            LocalDatabase<StudentAssessmentInfo>
                                                _historyStudentInfoDb =
                                                LocalDatabase(
                                                    'history_student_info');

                                            List l = await _historyStudentInfoDb
                                                .getData();
                                            //print(l.length);
                                            if (widget.isFromHistoryAssessmentScanMore ==
                                                    true &&
                                                widget.oneTimeCamera == null) {
                                              Navigator.of(context)
                                                ..pop()
                                                ..pop();
                                            }
                                            List p = await _historyStudentInfoDb
                                                .getData();
                                            //print(p.length);
                                            setEnabledSystemUIMode();
                                            var flashOn = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SuccessScreen(
                                                        assessmentName: widget
                                                            .assessmentName,
                                                        lastAssessmentLength: widget
                                                            .lastAssessmentLength,
                                                        isMcqSheet:
                                                            widget.isMcqSheet,
                                                        selectedAnswer: widget
                                                            .selectedAnswer,
                                                        questionImageUrl: widget
                                                            .questionImageLink,
                                                        obj: widget.obj,
                                                        createdAsPremium: widget
                                                            .createdAsPremium,
                                                        isFromHistoryAssessmentScanMore:
                                                            widget
                                                                .isFromHistoryAssessmentScanMore,
                                                        isScanMore:
                                                            widget.isScanMore,
                                                        img64: img64,
                                                        imgPath: imageFile,
                                                        pointPossible: widget
                                                            .pointPossible,
                                                        isFlashOn: widget
                                                                    .isFlashOn!
                                                                    .value ==
                                                                false
                                                            ? false
                                                            : true,
                                                      )),
                                            );

                                            if (flashOn == true) {
                                              try {
                                                await controller!.value
                                                    .setFlashMode(
                                                        FlashMode.always);
                                              } catch (e) {}
                                            }
                                          }
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white),
                                        ),
                                      )),
                                ),
                              ),
                            )
                          ]),
                        );
                      })
                    : Container();
              })),
    );
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller!.value;

    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup:
          Platform.isIOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.jpeg,
      enableAudio: false,
    );

    // Dispose the previous controller
    await previousCameraController.dispose();

    // Replace with the new controller

    if (mounted) {
      controller!.value = cameraController;
    }

    try {
      await cameraController.initialize();
      await cameraController.lockCaptureOrientation();

      await Future.wait(<Future<Object?>>[
        // The exposure mode is currently not supported on the web.
        ...!kIsWeb
            ? <Future<Object?>>[
                cameraController
                    .getMinExposureOffset()
                    .then((double value) => value),
                cameraController
                    .getMaxExposureOffset()
                    .then((double value) => value)
              ]
            : <Future<Object?>>[],
        cameraController.getMaxZoomLevel().then((double value) => value),
        cameraController.getMinZoomLevel().then((double value) => value),
      ]);
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showPopup(
              message:
                  'You have denied the camera access. To continue use the Graded+, Camera permission is required.  Please go to the \'App Settings\' to enable the camera access.',
              title: 'Permission Required!');
          break;

        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          showPopup(
              message:
                  'Camera Access Denied. To continue use the Graded+, Camera permission is required. Please go to the \'App Settings\' to enable the camera access.',
              title: 'Permission Required!');
          break;

        case 'CameraAccessRestricted':
          // iOS only
          showPopup(
              message:
                  'Camera Access is Restricted. To continue use the Graded+, Camera access is required. Please go to the \'App Settings\' to enable the camera access.',
              title: 'Permission Required!');
          break;

        default:
          _showCameraException(e);
          break;
      }
    }

    // Update the Boolean
    if (mounted) {
      _isCameraInitialized!.value = cameraController.value.isInitialized;

      try {
        await controller!.value.setFlashMode(
            widget.isFlashOn!.value ? FlashMode.always : FlashMode.off);
      } catch (e) {}
    }
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    Utility.showSnackBar(
        _scaffoldKey, 'Error: ${e.code}\n${e.description}', context, null);
  }

  void _logError(String code, String? message) {
    if (message != null) {
      print('Error: $code\nError Message: $message');
    } else {
      print('Error: $code');
    }
  }

  showPopup({required String message, required String? title}) {
    return showDialog(
        context: context,
        builder: (context) =>
            OrientationBuilder(builder: (context, orientation) {
              return CommonPopupWidget(
                  orientation: orientation,
                  context: context,
                  message: message,
                  title: title!,
                  isAccessDenied: true);
            }));
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller!.value;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      //print('Error occured while taking picture: $e');
      return null;
    }
  }

  Future<void> _showStartDialog() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? showPopUp = pref.getBool("camera_popup");

    return showPopUp == null
        ? showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: TranslationWidget(
                    message:
                        "Images are stored in the Cloud, not on your device",
                    fromLanguage: "en",
                    toLanguage: Globals.selectedLanguage,
                    builder: (translatedMessage) {
                      return Text(translatedMessage.toString(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold));
                    }),
                titleTextStyle: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: Colors.black),
                actions: [
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.height,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  Center(
                    child: TextButton(
                      child: TranslationWidget(
                          message: "Ok",
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
                      onPressed: () async {
                        Globals.iscameraPopup = false;
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.setBool("camera_popup", false);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 16,
              );
            },
          )
        : null;
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );

    controller!.value.setExposurePoint(offset);
    controller!.value.setFocusPoint(offset);
  }

  Future<List<StudentAssessmentInfo>> _getStudentInfoList() async {
    LocalDatabase<StudentAssessmentInfo> _studentInfoDb =
        LocalDatabase('student_info');
    return await _studentInfoDb.getData();
  }

  Future<List<String>> getSuggestionChips() async {
    try {
      List<String> classList = [];
      LocalDatabase<GoogleClassroomCourses> _localDb =
          LocalDatabase(Strings.googleClassroomCoursesList);

      List<GoogleClassroomCourses>? _localData = await _localDb.getData();
      for (var i = 0; i < _localData.length; i++) {
        classList.add(_localData[i].name!);
      }
      classList.sort();
      return classList;
    } catch (e) {
      List<String> classList = [];
      return classList;
    }
  }

  void setEnabledSystemUIMode() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }
}
