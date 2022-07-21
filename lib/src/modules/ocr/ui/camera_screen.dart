import 'dart:convert';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/ocr/ui/create_assessment.dart';
import 'package:Soc/src/modules/ocr/ui/results_summary.dart';
import 'package:Soc/src/modules/ocr/ui/success.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wakelock/wakelock.dart';

class CameraScreen extends StatefulWidget {
  final String? pointPossible;
  final bool? isScanMore;
  final onlyForPicture;
  final bool isFromHistoryAssessmentScanMore;
  final scaffoldKey;
  final bool? oneTimeCamera;

  const CameraScreen(
      {Key? key,
      required this.pointPossible,
      required this.isScanMore,
      required this.onlyForPicture,
      this.scaffoldKey,
      required this.isFromHistoryAssessmentScanMore,
      this.oneTimeCamera})
      : super(key: key);
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

List<CameraDescription> cameras = [];

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("inside applifecycle");
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  CameraController? controller;
  bool _isCameraInitialized = false;
  bool isflashOff = true;
  bool flash = false;
  FlashMode? _currentFlashMode;
  int? scanMoreAssesmentList;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  GoogleDriveBloc _driveBloc = GoogleDriveBloc();

  LocalDatabase<String> _localDb = LocalDatabase('class_suggestions');

  LocalDatabase<StudentAssessmentInfo> _studentInfoDb =
      LocalDatabase('student_info');

  LocalDatabase<StudentAssessmentInfo> _historyStudentInfoDb =
      LocalDatabase('history_student_info');

  @override
  void initState() {
    Wakelock.enable();
    Globals.iscameraPopup
        ? WidgetsBinding.instance
            .addPostFrameCallback((_) => _showStartDialog())
        : null;

    // Hide the status bar
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // widget.isScanMore == true
    //     ? scanMoreAssesmentList = Globals.studentInfo!.length
    //     : null;

    onNewCameraSelected(cameras[0]);
    // _checkPermission();
    super.initState();
  }

  @override
  void dispose() {
    Wakelock.disable();
    controller?.dispose();
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
                                //    ScaffoldMessenger.of(context).removeCurrentSnackBar();
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
                      color: Colors.white,
                    );
                  }),

              //        Globals.studentInfo!.length > 0
              // ? IconButton(
              //     onPressed: () {
              //       //To dispose the snackbar message before navigating back if exist
              //       //    ScaffoldMessenger.of(context).removeCurrentSnackBar();
              //       widget.onlyForPicture
              //           ? Navigator.pop(context, null)
              //           : Navigator.pop(context, true);
              //     },
              //     icon: Icon(
              //       IconData(0xe80d,
              //           fontFamily: Overrides.kFontFam,
              //           fontPackage: Overrides.kFontPkg),
              //       color: AppTheme.kButtonColor,
              //     ),
              //   )
              // : Container(),

              IconButton(
                  onPressed: () async {
                    setState(() {
                      flash = !flash;
                      isflashOff = !isflashOff;
                    });
                    await controller!
                        .setFlashMode(flash ? FlashMode.torch : FlashMode.off);
                  },
                  icon: Icon(
                    isflashOff == true ? Icons.flash_off : Icons.flash_on,
                    color: Colors.white,
                    size: 30,
                  )),
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
                      if (state is GoogleDriveLoading) {
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
                                      historysecondTime:
                                          widget.isFromHistoryAssessmentScanMore
                                              ? true
                                              : null,
                                      asssessmentName: Globals.assessmentName,
                                      shareLink: Globals.shareableLink ?? '',
                                      assessmentDetailPage: widget
                                          .isFromHistoryAssessmentScanMore,
                                      isScanMore: true,
                                      assessmentListLenght:
                                          Globals.scanMoreStudentInfoLength,
                                    )),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResultsSummary(
                                      historysecondTime:
                                          widget.isFromHistoryAssessmentScanMore
                                              ? true
                                              : null,
                                      asssessmentName: Globals.assessmentName,
                                      shareLink: Globals.shareableLink ?? '',
                                      assessmentDetailPage: widget
                                          .isFromHistoryAssessmentScanMore,
                                      isScanMore: true,
                                      assessmentListLenght:
                                          Globals.scanMoreStudentInfoLength,
                                    )),
                          );
                        }
                      }
                      if (state is ErrorState) {
                        if (state.errorMsg == 'Reauthentication is required') {
                          await Utility.refreshAuthenticationToken(
                              isNavigator: true,
                              errorMsg: state.errorMsg!,
                              context: context,
                              scaffoldKey: _scaffoldKey);

                          _driveBloc.add(UpdateDocOnDrive(
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
                              "Something Went Wrong. Please Try Again.");
                        }
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
                        List<StudentAssessmentInfo> studentInfoDb =
                            await Utility.getStudentInfoList(
                                tableName:
                                    widget.isFromHistoryAssessmentScanMore ==
                                            true
                                        ? 'history_student_info'
                                        : 'student_info');

                        if (studentInfoDb.length > 0) {
                          if (widget.isFromHistoryAssessmentScanMore == true) {
                            // List<StudentAssessmentInfo> historyStudentInfo =
                            //     await Utility.getStudentInfoList(
                            //         tableName: 'history_student_info');

                            // if (studentInfoDb[0].studentId == 'Id') {
                            //   studentInfoDb.removeAt(0);
                            // }

                            //   To copy the static content in the sheet
                            // studentInfoDb
                            //   ..asMap().forEach((index, element) async {
                            //     StudentAssessmentInfo element =
                            //         studentInfoDb[index];

                            //     element.subject = studentInfoDb.first.subject;
                            //     element.learningStandard =
                            //         studentInfoDb.first.learningStandard == null
                            //             ? "NA"
                            //             : studentInfoDb.first.learningStandard;

                            //     element.subLearningStandard = studentInfoDb
                            //                 .first.subLearningStandard ==
                            //             null
                            //         ? "NA"
                            //         : studentInfoDb.first.subLearningStandard;
                            //     element.scoringRubric =
                            //         studentInfoDb.first.scoringRubric ?? 'NA';
                            //     element.customRubricImage =
                            //         studentInfoDb.first.customRubricImage ??
                            //             "NA";
                            //     element.grade = studentInfoDb.first.grade;
                            //     element.className =
                            //         studentInfoDb.first.className ?? 'NA';
                            //     //widget.selectedClass;
                            //     element.questionImgUrl =
                            //         studentInfoDb.first.questionImgUrl;
                            //     await _historyStudentInfoDb.putAt(
                            //         index, element);
                            //   });

                            // historyStudentInfo
                            //   ..asMap().forEach((index, element) async {
                            //     StudentAssessmentInfo element =
                            //         studentInfoDb[index];

                            //     element.subject = studentInfoDb.first.subject;
                            //     element.learningStandard =
                            //         studentInfoDb.first.learningStandard == null
                            //             ? "NA"
                            //             : studentInfoDb.first.learningStandard;
                            //     element.subLearningStandard = studentInfoDb
                            //                 .first.subLearningStandard ==
                            //             null
                            //         ? "NA"
                            //         : studentInfoDb.first.subLearningStandard;
                            //     element.scoringRubric = Globals.scoringRubric;
                            //     element.customRubricImage =
                            //         studentInfoDb.first.customRubricImage ??
                            //             "NA";
                            //     element.grade = studentInfoDb.first.grade;
                            //     element.className = Globals.assessmentName!
                            //         .split("_")[1]; //widget.selectedClass;
                            //     element.questionImgUrl =
                            //         studentInfoDb.first.questionImgUrl;
                            //     await _studentInfoDb.putAt(index, element);
                            //   });

                            // StudentAssessmentInfo element = studentInfoDb[0];

                            // element.subject = studentInfoDb.first.subject;
                            // element.learningStandard =
                            //     studentInfoDb.first.learningStandard == null
                            //         ? "NA"
                            //         : studentInfoDb.first.learningStandard;

                            // element.subLearningStandard =
                            //     studentInfoDb.first.subLearningStandard == null
                            //         ? "NA"
                            //         : studentInfoDb.first.subLearningStandard;
                            // element.scoringRubric =
                            //     studentInfoDb.first.scoringRubric ?? 'NA';
                            // element.customRubricImage =
                            //     studentInfoDb.first.customRubricImage ?? "NA";
                            // element.grade = studentInfoDb.first.grade;
                            // element.className =
                            //     studentInfoDb.first.className ?? 'NA';
                            // //widget.selectedClass;
                            // element.questionImgUrl =
                            //     studentInfoDb.first.questionImgUrl;
                            // await _historyStudentInfoDb.putAt(0, element);

                            _driveBloc.add(UpdateDocOnDrive(
                                assessmentName: Globals.historyAssessmentName,
                                fileId: Globals.historyAssessmentFileId,
                                isLoading: true,
                                studentData: await Utility.getStudentInfoList(
                                    tableName: 'history_student_info')));
                          } else if (!widget.isFromHistoryAssessmentScanMore &&
                              widget.isScanMore == true) {
                            //To remove the titles if exist in the list
                            // if (Globals.studentInfo![0].studentId == 'Id') {
                            //   Globals.studentInfo!.removeAt(0);
                            // }

                            //To copy the static content in the sheet
                            // studentInfoDb
                            //   ..asMap().forEach((index, element) async {
                            //     StudentAssessmentInfo element =
                            //         studentInfoDb[index];
                            //     element.subject = studentInfoDb.first.subject;
                            //     element.learningStandard =
                            //         studentInfoDb.first.learningStandard == null
                            //             ? "NA"
                            //             : studentInfoDb.first.learningStandard;
                            //     element.subLearningStandard = studentInfoDb
                            //                 .first.subLearningStandard ==
                            //             null
                            //         ? "NA"
                            //         : studentInfoDb.first.subLearningStandard;
                            //     element.scoringRubric = Globals.scoringRubric;
                            //     element.customRubricImage =
                            //         studentInfoDb.first.customRubricImage ??
                            //             "NA";
                            //     element.grade = studentInfoDb.first.grade;
                            //     element.className = Globals.assessmentName!
                            //         .split("_")[1]; //widget.selectedClass;
                            //     element.questionImgUrl =
                            //         studentInfoDb.first.questionImgUrl;
                            //     await _studentInfoDb.putAt(index, element);
                            //   });
                            // _driveBloc.add(UpdateDocOnDrive(
                            //                   isLoading: true,
                            //                   studentData: Globals.studentInfo!));

                            // studentInfoDb.forEach((element) {
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
                            // });
                            // LocalDatabase<StudentAssessmentInfo>
                            //     _studentInfoDb = LocalDatabase('student_info');
                            // await _studentInfoDb.clear();

                            // studentInfoDb.forEach((element) async {
                            //   await _studentInfoDb.addData(element);
                            // });
                            // studentInfoDb.clear();
                            // studentInfoDb = await _getStudentInfoList();

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

                            _driveBloc.add(UpdateDocOnDrive(
                                assessmentName: Globals.assessmentName!,
                                fileId: Globals.googleExcelSheetId,
                                isLoading: true,
                                studentData: await Utility.getStudentInfoList(
                                    tableName: 'student_info')));
                          } else {
                            List<String> classSuggestions =
                                await _localDb.getData();

                            LocalDatabase<String> classSectionLocalDb =
                                LocalDatabase('class_section_list');

                            List<String> localSectionList =
                                await classSectionLocalDb.getData();
                            if (localSectionList.isEmpty) {
                              print("local db is empty");
                              Globals.classList.forEach((String e) {
                                classSectionLocalDb.addData(e);
                              });
                            } else {
                              print("local db is not empty");
                              Globals.classList = [];
                              Globals.classList.addAll(localSectionList);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateAssessment(
                                        customGrades: Globals.classList,
                                        classSuggestions: classSuggestions)),
                              );
                            }
                          }
                        } else {
                          Utility.showSnackBar(
                              _scaffoldKey,
                              "Assessment not found! Please scan a student assessment to proceed further",
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
                    color: Colors.white,
                  );
                })

            // Globals.studentInfo!.length == 0
            //     ? IconButton(
            //         onPressed: () {
            //           //To dispose the snackbar message before navigating back if exist
            //           ScaffoldMessenger.of(context).removeCurrentSnackBar();
            //           Navigator.pop(context);
            //         },
            //         icon: Icon(
            //           Icons.close,
            //           color: AppTheme.kButtonColor,
            //         ),
            //       )
            //     : Container(),
          ],
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
        ),
        body: _isCameraInitialized
            ? LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                return GestureDetector(
                  onTapDown: (details) => onViewFinderTap(details, constraints),
                  child: Stack(children: [
                    Center(child: controller!.buildPreview()),
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
                                  HapticFeedback.vibrate();
                                  XFile? rawImage = await takePicture();
                                  File imageFile = File(rawImage!.path);
                                  final bytes =
                                      File(rawImage.path).readAsBytesSync();
                                  String img64 = base64Encode(bytes);

                                  //  File imageFile = File(rawImage!.path);

                                  int currentUnix =
                                      DateTime.now().millisecondsSinceEpoch;
                                  final directory =
                                      await getApplicationDocumentsDirectory();
                                  String fileFormat =
                                      imageFile.path.split('.').last;

                                  await imageFile.copy(
                                    '${directory.path}/$currentUnix.$fileFormat',
                                  );
                                  print(widget.pointPossible);
                                  await controller!.setFlashMode(FlashMode.off);

                                  if (widget.onlyForPicture) {
                                    Navigator.pop(context, imageFile);
                                  } else {
                                    LocalDatabase<StudentAssessmentInfo>
                                        _historyStudentInfoDb =
                                        LocalDatabase('history_student_info');

                                    List l =
                                        await _historyStudentInfoDb.getData();
                                    print(l.length);
                                    if (widget.isFromHistoryAssessmentScanMore ==
                                            true &&
                                        widget.oneTimeCamera == null) {
                                      Navigator.of(context)
                                        ..pop()
                                        ..pop();
                                    }
                                    List p =
                                        await _historyStudentInfoDb.getData();
                                    print(p.length);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SuccessScreen(
                                                isFromHistoryAssessmentScanMore:
                                                    widget
                                                        .isFromHistoryAssessmentScanMore,
                                                isScanMore: widget.isScanMore,
                                                img64: img64,
                                                imgPath: imageFile,
                                                pointPossible:
                                                    widget.pointPossible,
                                              )),
                                    );
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
            : Container(),
      ),
    );
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;

    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: false,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();
    // _currentFlashMode = controller!.value.flashMode;
    // Replace with the new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    // Update the Boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  Future<void> _showStartDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: TranslationWidget(
              message: "Images are stored in the Cloud, not on your device",
              fromLanguage: "en",
              toLanguage: Globals.selectedLanguage,
              builder: (translatedMessage) {
                return Text(translatedMessage.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold));
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
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    color: AppTheme.kButtonColor,
                                  ));
                    }),
                onPressed: () {
                  Globals.iscameraPopup = false;
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 16,
        );
      },
    );
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );

    controller!.setExposurePoint(offset);
    controller!.setFocusPoint(offset);
  }

  Future<List<StudentAssessmentInfo>> _getStudentInfoList() async {
    LocalDatabase<StudentAssessmentInfo> _studentInfoDb =
        LocalDatabase('student_info');
    return await _studentInfoDb.getData();
  }
}
