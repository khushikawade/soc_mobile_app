// import 'dart:convert';
// import 'dart:io';
// import 'package:Soc/src/globals.dart';
// import 'package:Soc/src/modules/google_classroom/modal/google_classroom_courses.dart';
// import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
// import 'package:Soc/src/modules/google_drive/model/assessment.dart';
// import 'package:Soc/src/modules/graded_plus/helper/graded_overrides.dart';
// import 'package:Soc/src/modules/graded_plus/helper/graded_plus_utilty.dart';
// import 'package:Soc/src/modules/graded_plus/modal/student_assessment_info_modal.dart';
// import 'package:Soc/src/modules/graded_plus/helper/graded_plus_utilty.dart';
// import 'package:Soc/src/modules/graded_plus/new_ui/graded_plus_create_assessment.dart';
// import 'package:Soc/src/modules/graded_plus/new_ui/graded_plus_results_summary.dart';
// import 'package:Soc/src/modules/graded_plus/new_ui/graded_plus_scan_result.dart';
// import 'package:Soc/src/modules/graded_plus/ui/create_assessment.dart';
// import 'package:Soc/src/modules/graded_plus/ui/result_summary/results_summary.dart';
// import 'package:Soc/src/modules/graded_plus/ui/success.dart';
// import 'package:Soc/src/modules/graded_plus/widgets/common_popup.dart';
// import 'package:Soc/src/modules/graded_plus/widgets/student_popup.dart';
// import 'package:Soc/src/overrides.dart';
// import 'package:Soc/src/services/Strings.dart';
// import 'package:Soc/src/services/analytics.dart';
// import 'package:Soc/src/services/local_database/local_db.dart';
// import 'package:Soc/src/services/utility.dart';
// import 'package:Soc/src/styles/theme.dart';
// import 'package:Soc/src/translator/translation_widget.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wakelock/wakelock.dart';

// import '../../google_classroom/bloc/google_classroom_bloc.dart';
// import '../../google_classroom/google_classroom_globals.dart';

// class CameraScreen extends StatefulWidget {
//   final String? pointPossible;
//   final String? selectedAnswer;
//   final bool? isMcqSheet;
//   final bool? isScanMore;
//   final onlyForPicture;
//   final bool isFromHistoryAssessmentScanMore;
//   final scaffoldKey;
//   final bool? oneTimeCamera;
//   final bool? createdAsPremium;
//   final String? questionImageLink;
//   final HistoryAssessment? obj;
//   final String? assessmentName;
//   final int? lastAssessmentLength;
//   // bool flash;
//   ValueNotifier<bool>? isFlashOn = ValueNotifier<bool>(false);
//   CameraScreen(
//       {Key? key,
//       this.lastAssessmentLength,
//       this.assessmentName,
//       required this.pointPossible,
//       required this.isScanMore,
//       required this.onlyForPicture,
//       this.questionImageLink,
//       this.scaffoldKey,
//       required this.isFromHistoryAssessmentScanMore,
//       this.oneTimeCamera,
//       this.isMcqSheet,
//       this.selectedAnswer,
//       this.createdAsPremium,
//       this.obj,
//       required this.isFlashOn})
//       : super(key: key);
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// List<CameraDescription> cameras = [];

// class _CameraScreenState extends State<CameraScreen>
//     with WidgetsBindingObserver {
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     //print("inside lifecycle");
//     final CameraController? cameraController = controller!.value;

//     // App state changed before we got the chance to initialize.
//     if (cameraController == null || !cameraController.value.isInitialized) {
//       return;
//     }

//     if (state == AppLifecycleState.inactive) {
//       //print(' inside     AppLifecycleState.inactive');
//       // Free up memory when camera not active
//       //   cameraController.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       //print(' inside    AppLifecycleState.resumed');
//       // Reinitialize the camera with same properties
//       onNewCameraSelected(cameraController.description);
//     }
//   }

//   CameraDescription? description;

//   ValueNotifier<CameraController>? controller =
//       ValueNotifier<CameraController>(CameraController(
//     cameras[0],
//     ResolutionPreset.high,
//     imageFormatGroup:
//         Platform.isIOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.jpeg,
//     enableAudio: false,
//   ));

//   ValueNotifier<bool>? _isCameraInitialized = ValueNotifier<bool>(false);
//   int? scanMoreAssessmentList;
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   GoogleDriveBloc _driveBloc = GoogleDriveBloc();
//   GoogleDriveBloc _driveBloc2 = GoogleDriveBloc();

//   LocalDatabase<String> _localDb = LocalDatabase('class_suggestions');
//   List<String> classList = [
//     'PK',
//     'K',
//     '1',
//     '2',
//     '3',
//     '4',
//     '5',
//     '6',
//     '7',
//     '8',
//     '9',
//     '10',
//     '11',
//     '12',
//     '+'
//   ];

//   LocalDatabase<StudentAssessmentInfo> _studentAssessmentInfoDb =
//       LocalDatabase(Strings.studentInfoDbName);

//   LocalDatabase<StudentAssessmentInfo> _historystudentAssessmentInfoDb =
//       LocalDatabase(Strings.historyStudentInfoDbName);

//   GoogleClassroomBloc _googleClassroomBloc = new GoogleClassroomBloc();
//   ValueNotifier<bool>? removeLoading = ValueNotifier<bool>(false);
//   @override
//   void initState() {
//     // print(GoogleClassroomOverrides.studentAssessmentAndClassroomObj);
//     // widget.isFlashOn!.value = widget.isFlashOn;
//     Wakelock.enable();

//     Globals.isCameraPopup
//         ? WidgetsBinding.instance
//             .addPostFrameCallback((_) => _showStartDialog())
//         : null;
//     SystemChrome.setEnabledSystemUIOverlays([]);
//     // Hide the status bar
//     // SystemChrome.ssEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
//     // widget.isScanMore == true
//     //     ? scanMoreAssessmentList = Globals.studentInfo!.length
//     //     : null;

//     onNewCameraSelected(cameras[0]);
//     // _checkPermission();
//     FirebaseAnalyticsService.addCustomAnalyticsEvent("camera_screen");
//     FirebaseAnalyticsService.setCurrentScreen(
//         screenTitle: 'camera_screen', screenClass: 'CameraScreen');
//     OcrOverrides.gradedPlusNavBarIsHide.value = true;
//     super.initState();
//   }

//   @override
//   void dispose() {
//     Wakelock.disable();
//     controller?.dispose();
//     setEnabledSystemUIMode();
//     OcrOverrides.gradedPlusNavBarIsHide.value = false;
//     super.dispose();
//   }

//   ValueNotifier<bool> showFocusCircle = ValueNotifier<bool>(false);

//   double x = 0;
//   double y = 0;
//   final GlobalKey<NonCourseGoogleClassroomStudentPopupState> _dialogKey =
//       GlobalKey<NonCourseGoogleClassroomStudentPopupState>();
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//           key: _scaffoldKey,
//           appBar: AppBar(
//             toolbarHeight:
//                 MediaQuery.of(context).orientation == Orientation.portrait
//                     ? 50
//                     : 60,
//             leadingWidth: 200,
//             leading: Row(
//               children: [
//                 FutureBuilder(
//                     future: _getStudentInfoList(),
//                     builder: (BuildContext context,
//                         AsyncSnapshot<List<StudentAssessmentInfo>> snapshot) {
//                       if (snapshot.hasData) {
//                         return snapshot.data!.length > 0
//                             ? IconButton(
//                                 onPressed: () {
//                                   //To dispose the snackbar message before navigating back if exist
//                                   ScaffoldMessenger.of(context)
//                                       .removeCurrentSnackBar();
//                                   widget.onlyForPicture
//                                       ? Navigator.pop(context, null)
//                                       : Navigator.pop(context, true);
//                                 },
//                                 icon: Icon(
//                                   IconData(0xe80d,
//                                       fontFamily: Overrides.kFontFam,
//                                       fontPackage: Overrides.kFontPkg),
//                                   color: AppTheme.kButtonColor,
//                                 ),
//                               )
//                             : Container();
//                       }
//                       return CupertinoActivityIndicator(

//                           // color: Colors.white,
//                           );
//                     }),
//                 ValueListenableBuilder(
//                   builder:
//                       (BuildContext context, dynamic value, Widget? child) {
//                     return IconButton(
//                         onPressed: () async {
//                           widget.isFlashOn!.value = !widget.isFlashOn!.value;

//                           try {
//                             await controller!.value.setFlashMode(
//                                 widget.isFlashOn!.value
//                                     ? FlashMode.always
//                                     : FlashMode.off);
//                           } catch (e) {}
//                         },
//                         icon: Icon(
//                           widget.isFlashOn!.value == false
//                               ? Icons.flash_off
//                               : Icons.flash_on,
//                           color: Colors.white,
//                           size: 30,
//                         ));
//                   },
//                   valueListenable: widget.isFlashOn!,
//                   child: Container(),
//                 ),
//               ],
//             ),
//             actions: [
//               //For custom image use
//               widget.onlyForPicture
//                   ? Container()
//                   : BlocListener<GoogleDriveBloc, GoogleDriveState>(
//                       bloc: _driveBloc,
//                       child: Container(),
//                       listener: (context, state) async {
//                         if (state is ShowLoadingDialog) {
//                           Utility.showLoadingDialog(
//                               context: context, isOCR: true);
//                         }
//                         if (state is GoogleSuccess) {
//                           if (Overrides.STANDALONE_GRADED_APP) {
//                             _googleClassroomBloc.add(CreateClassRoomCourseWork(
//                               isFromHistoryAssessmentScanMore:
//                                   widget.isFromHistoryAssessmentScanMore,
//                               pointPossible: widget.pointPossible ?? '0',
//                               studentClassObj: GoogleClassroomOverrides
//                                   .studentAssessmentAndClassroomObj,
//                               title: widget.isFromHistoryAssessmentScanMore
//                                   ? Globals.historyAssessmentName ?? ''
//                                   : Globals.assessmentName ?? '',
//                               studentAssessmentInfoDb:
//                                   widget.isFromHistoryAssessmentScanMore
//                                       ? _historystudentAssessmentInfoDb
//                                       : _studentAssessmentInfoDb,
//                             ));
//                           } else {
//                             _navigatetoResultSection();
//                           }
//                         }
//                         if (state is ErrorState) {
//                           if (state.errorMsg ==
//                               'ReAuthentication is required') {
//                             await Utility.refreshAuthenticationToken(
//                                 isNavigator: true,
//                                 errorMsg: state.errorMsg!,
//                                 context: context,
//                                 scaffoldKey: _scaffoldKey);

//                             _driveBloc.add(UpdateDocOnDrive(
//                                 isMcqSheet: widget.isMcqSheet ?? false,
//                                 // questionImage: widget.questionImageLink ?? 'NA',
//                                 createdAsPremium: widget.createdAsPremium,
//                                 assessmentName: Globals.historyAssessmentName,
//                                 fileId: Globals.historyAssessmentFileId,
//                                 isLoading: true,
//                                 studentData: await Utility.getStudentInfoList(
//                                     tableName:
//                                         widget.isFromHistoryAssessmentScanMore ==
//                                                 true
//                                             ? Strings.historyStudentInfoDbName
//                                             : Strings.studentInfoDbName)));
//                           } else {
//                             Navigator.of(context).pop();
//                             Utility.currentScreenSnackBar(
//                                 "Something Went Wrong. Please Try Again.",
//                                 null);
//                           }
//                         }

//                         if (state
//                             is AddAndUpdateStudentAssessmentDetailsToSlideSuccess) {
//                           List<StudentAssessmentInfo> studentAssessmentInfoDb =
//                               await Utility.getStudentInfoList(
//                                   tableName:
//                                       widget.isFromHistoryAssessmentScanMore ==
//                                               true
//                                           ? Strings.historyStudentInfoDbName
//                                           : Strings.studentInfoDbName);
//                           StudentAssessmentInfo element =
//                               studentAssessmentInfoDb[0];

//                           //Updating remaining common details of assessment
//                           element.subject =
//                               studentAssessmentInfoDb.first.subject;
//                           element.learningStandard = studentAssessmentInfoDb
//                                       .first.learningStandard ==
//                                   null
//                               ? "NA"
//                               : studentAssessmentInfoDb.first.learningStandard;
//                           element.subLearningStandard = studentAssessmentInfoDb
//                                       .first.subLearningStandard ==
//                                   null
//                               ? "NA"
//                               : studentAssessmentInfoDb
//                                   .first.subLearningStandard;
//                           element.scoringRubric = Globals.scoringRubric;
//                           element.customRubricImage =
//                               studentAssessmentInfoDb.first.customRubricImage ??
//                                   "NA";
//                           element.grade = studentAssessmentInfoDb.first.grade;
//                           element.className = Globals.assessmentName!
//                               .split("_")[1]; //widget.selectedClass;
//                           element.questionImgUrl =
//                               studentAssessmentInfoDb.first.questionImgUrl;

//                           await _studentAssessmentInfoDb.putAt(0, element);
//                           // List l = await Utility.getStudentInfoList(
//                           //     tableName: Strings.studentInfoDbName);

//                           _driveBloc.add(UpdateDocOnDrive(
//                               isMcqSheet: widget.isMcqSheet ?? false,
//                               // questionImage: widget.questionImageLink ?? 'NA',
//                               createdAsPremium: widget.createdAsPremium,
//                               assessmentName: Globals.assessmentName!,
//                               fileId: Globals.googleExcelSheetId,
//                               isLoading: true,
//                               studentData: await Utility.getStudentInfoList(
//                                   tableName: Strings.studentInfoDbName)));
//                         }
//                         if (state is GoogleSheetUpdateOnScanMoreSuccess) {
//                           _driveBloc.add(UpdateDocOnDrive(
//                               isMcqSheet: widget.isMcqSheet ?? false,
//                               // questionImage: widget.questionImageLink ?? 'NA',
//                               createdAsPremium: widget.createdAsPremium ??
//                                   Globals.isPremiumUser,
//                               assessmentName: Globals.historyAssessmentName,
//                               fileId: Globals.historyAssessmentFileId,
//                               isLoading: true,
//                               studentData: state.list));
//                         }
//                       }),
//               widget.onlyForPicture
//                   ? Container()
//                   : BlocListener<GoogleClassroomBloc, GoogleClassroomState>(
//                       bloc: _googleClassroomBloc,
//                       child: Container(),
//                       listener: (context, state) async {
//                         if (state is CreateClassroomCourseWorkSuccess) {
//                           _navigatetoResultSection();
//                         }
//                         if (state is GoogleClassroomErrorState) {
//                           if (state.errorMsg ==
//                               'ReAuthentication is required') {
//                             await Utility.refreshAuthenticationToken(
//                                 isNavigator: true,
//                                 errorMsg: state.errorMsg!,
//                                 context: context,
//                                 scaffoldKey: _scaffoldKey);

//                             _googleClassroomBloc.add(CreateClassRoomCourseWork(
//                               isFromHistoryAssessmentScanMore:
//                                   widget.isFromHistoryAssessmentScanMore,
//                               pointPossible: widget.pointPossible ?? '0',
//                               studentClassObj: GoogleClassroomOverrides
//                                   .studentAssessmentAndClassroomObj,
//                               title: widget.isFromHistoryAssessmentScanMore
//                                   ? Globals.historyAssessmentName ?? ''
//                                   : Globals.assessmentName ?? '',
//                               studentAssessmentInfoDb:
//                                   widget.isFromHistoryAssessmentScanMore
//                                       ? _historystudentAssessmentInfoDb
//                                       : _studentAssessmentInfoDb,
//                             ));
//                           } else {
//                             Navigator.of(context).pop();
//                             Utility.currentScreenSnackBar(
//                                 state.errorMsg?.toString() ?? "", null);
//                           }
//                         }
//                       }),

//               widget.onlyForPicture
//                   ? Container()
//                   : Container(
//                       padding: EdgeInsets.only(right: 5),
//                       child: TextButton(
//                         style: ButtonStyle(alignment: Alignment.center),
//                         child: TranslationWidget(
//                             message: "DONE",
//                             fromLanguage: "en",
//                             toLanguage: Globals.selectedLanguage,
//                             builder: (translatedMessage) {
//                               return Text(translatedMessage,
//                                   style: TextStyle(
//                                     color: AppTheme.kButtonColor,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18,
//                                   ));
//                             }),
//                         onPressed: () async {
//                           ScaffoldMessenger.of(context).removeCurrentSnackBar();
//                           try {
//                             await controller!.value.setFlashMode(FlashMode.off);
//                           } catch (e) {}

//                           PlusUtility.updateLogs(
//                               activityType: 'GRADED+',
//                               activityId: '19',
//                               description: 'Assessment scan finished',
//                               operationResult: 'Success');

//                           List<StudentAssessmentInfo> studentAssessmentInfoDb =
//                               await Utility.getStudentInfoList(
//                                   tableName:
//                                       widget.isFromHistoryAssessmentScanMore ==
//                                               true
//                                           ? Strings.historyStudentInfoDbName
//                                           : Strings.studentInfoDbName);

//                           if (studentAssessmentInfoDb.length > 0) {
//                             // Check if all students belong to same class
//                             if (Overrides.STANDALONE_GRADED_APP &&
//                                 (widget.isFromHistoryAssessmentScanMore ==
//                                         true ||
//                                     widget.isScanMore == true)) {
//                               //Preparing list of student not belong to selected class
//                               List<StudentAssessmentInfo>
//                                   notPresentStudentsInSelectedClass =
//                                   await OcrUtility
//                                       .checkAllStudentBelongsToSameClassOrNot(
//                                           title: widget
//                                                   .isFromHistoryAssessmentScanMore
//                                               ? Globals.historyAssessmentName ??
//                                                   ''
//                                               : Globals.assessmentName ?? '',
//                                           isScanMore: true,
//                                           studentInfoDB: widget
//                                                       .isFromHistoryAssessmentScanMore ==
//                                                   true
//                                               ? _historystudentAssessmentInfoDb
//                                               : _studentAssessmentInfoDb);

//                               if (notPresentStudentsInSelectedClass
//                                       ?.isNotEmpty ??
//                                   true) {
//                                 notPresentStudentsPopupModal(
//                                     notPresentStudentsInSelectedClass:
//                                         notPresentStudentsInSelectedClass);
//                                 return;
//                               }
//                             }

//                             preparingGoogleSlideFiles();
//                           } else {
//                             Utility.showSnackBar(
//                                 _scaffoldKey,
//                                 "Assignment not found! Please scan a student Assignment to proceed further",
//                                 context,
//                                 null);
//                           }
//                         },
//                       )),

//               FutureBuilder(
//                   future: _getStudentInfoList(),
//                   builder: (BuildContext context,
//                       AsyncSnapshot<List<StudentAssessmentInfo>> snapshot) {
//                     if (snapshot.hasData) {
//                       return snapshot.data!.length == 0
//                           ? IconButton(
//                               onPressed: () {
//                                 //To dispose the snackbar message before navigating back if exist
//                                 ScaffoldMessenger.of(context)
//                                     .removeCurrentSnackBar();
//                                 Navigator.pop(context);
//                               },
//                               icon: Icon(
//                                 Icons.close,
//                                 color: AppTheme.kButtonColor,
//                               ),
//                             )
//                           : Container();
//                     }
//                     return CupertinoActivityIndicator(
//                         //  color: Colors.white,
//                         );
//                   })
//             ],
//             backgroundColor: Colors.black,
//             automaticallyImplyLeading: false,
//           ),
//           body: ValueListenableBuilder(
//               child: Container(),
//               valueListenable: _isCameraInitialized!,
//               builder: (BuildContext context, dynamic value, Widget? child) {
//                 return _isCameraInitialized!.value
//                     ? LayoutBuilder(builder:
//                         (BuildContext context, BoxConstraints constraints) {
//                         return GestureDetector(
//                           onTapUp: (details) => manualCameraFocusOnTap(details),
//                           // onViewFinderTap(details, constraints),
//                           child: Stack(children: [
//                             Center(child: controller!.value.buildPreview()),
//                             Positioned(
//                               bottom: 15.0,
//                               child: Container(
//                                 color: Colors.transparent,
//                                 height: MediaQuery.of(context).orientation ==
//                                         Orientation.portrait
//                                     ? MediaQuery.of(context).size.height * 0.2
//                                     : MediaQuery.of(context).size.height * 0.25,
//                                 width: MediaQuery.of(context).size.width,
//                                 child: Center(
//                                   child: Container(
//                                       height: 90,
//                                       width: 90,
//                                       decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: Colors.transparent,
//                                           border: Border.all(
//                                               color: Colors.white, width: 5)),
//                                       padding: EdgeInsets.all(3),
//                                       child: InkWell(
//                                         onTap: () async {
//                                           try {} catch (e) {}
//                                           HapticFeedback.vibrate();
//                                           XFile? rawImage = await takePicture();
//                                           File imageFile = File(rawImage!.path);
//                                           final bytes = File(rawImage.path)
//                                               .readAsBytesSync();
//                                           String img64 = base64Encode(bytes);

//                                           int currentUnix = DateTime.now()
//                                               .millisecondsSinceEpoch;
//                                           final directory =
//                                               await getApplicationDocumentsDirectory();
//                                           String fileFormat =
//                                               imageFile.path.split('.').last;

//                                           await imageFile.copy(
//                                             '${directory.path}/$currentUnix.$fileFormat',
//                                           );

//                                           if (widget.onlyForPicture) {
//                                             Navigator.pop(context, imageFile);
//                                           } else {
//                                             if (widget.isFromHistoryAssessmentScanMore ==
//                                                     true &&
//                                                 widget.oneTimeCamera == null) {
//                                               Navigator.of(context)
//                                                 ..pop()
//                                                 ..pop();
//                                             }

//                                             setEnabledSystemUIMode();

//                                             var flashOn = await Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       GradedPlusScanResult(
//                                                         assessmentName: widget
//                                                             .assessmentName,
//                                                         lastAssessmentLength: widget
//                                                             .lastAssessmentLength,
//                                                         isMcqSheet:
//                                                             widget.isMcqSheet,
//                                                         selectedAnswer: widget
//                                                             .selectedAnswer,
//                                                         questionImageUrl: widget
//                                                             .questionImageLink,
//                                                         obj: widget.obj,
//                                                         createdAsPremium: widget
//                                                             .createdAsPremium,
//                                                         isFromHistoryAssessmentScanMore:
//                                                             widget
//                                                                 .isFromHistoryAssessmentScanMore,
//                                                         isScanMore:
//                                                             widget.isScanMore,
//                                                         img64: img64,
//                                                         imgPath: imageFile,
//                                                         pointPossible: widget
//                                                             .pointPossible,
//                                                         isFlashOn: widget
//                                                                     .isFlashOn!
//                                                                     .value ==
//                                                                 false
//                                                             ? false
//                                                             : true,
//                                                       )),
//                                             );

//                                             OcrOverrides.gradedPlusNavBarIsHide
//                                                 .value = true;
//                                             if (flashOn == true) {
//                                               try {
//                                                 await controller!.value
//                                                     .setFlashMode(
//                                                         FlashMode.always);
//                                               } catch (e) {}
//                                             }
//                                           }
//                                         },
//                                         child: Container(
//                                           decoration: const BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               color: Colors.white),
//                                         ),
//                                       )),
//                                 ),
//                               ),
//                             ),
//                             ValueListenableBuilder(
//                                 child: Container(),
//                                 valueListenable: showFocusCircle,
//                                 builder: (BuildContext context, dynamic value,
//                                     Widget? child) {
//                                   return showFocusCircle.value
//                                       ? Positioned(
//                                           top: y - 20,
//                                           left: x - 20,
//                                           child: Container(
//                                             height: MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                 10,
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                 10,
//                                             decoration: BoxDecoration(
//                                                 shape: BoxShape.circle,
//                                                 border: Border.all(
//                                                     color: Colors.white,
//                                                     width: 1.5)),
//                                           ))
//                                       : Container();
//                                 })
//                           ]),
//                         );
//                       })
//                     : Container();
//               })),
//     );
//   }

//   void onNewCameraSelected(CameraDescription cameraDescription) async {
//     final previousCameraController = controller!.value;

//     // Instantiating the camera controller
//     final CameraController cameraController = CameraController(
//       cameraDescription,
//       ResolutionPreset.high,
//       imageFormatGroup:
//           Platform.isIOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.jpeg,
//       enableAudio: false,
//     );

//     // Dispose the previous controller
//     await previousCameraController.dispose();

//     // Replace with the new controller

//     if (mounted) {
//       controller!.value = cameraController;
//     }

//     try {
//       await cameraController.initialize();
//       await cameraController.lockCaptureOrientation();

//       await Future.wait(<Future<Object?>>[
//         // The exposure mode is currently not supported on the web.
//         ...!kIsWeb
//             ? <Future<Object?>>[
//                 cameraController
//                     .getMinExposureOffset()
//                     .then((double value) => value),
//                 cameraController
//                     .getMaxExposureOffset()
//                     .then((double value) => value)
//               ]
//             : <Future<Object?>>[],
//         cameraController.getMaxZoomLevel().then((double value) => value),
//         cameraController.getMinZoomLevel().then((double value) => value),
//       ]);
//     } on CameraException catch (e) {
//       switch (e.code) {
//         case 'CameraAccessDenied':
//           showPopup(
//               message: OcrOverrides.cameraPermissionMessage!,
//               //  'You have denied the camera access. To continue use the Graded+, Camera permission is required.  Please go to the \'App Settings\' to enable the camera access.',
//               title: OcrOverrides.cameraPermissionTitle
//               //'Permission Required!'
//               );
//           break;

//         case 'CameraAccessDeniedWithoutPrompt':
//           // iOS only
//           showPopup(
//               message: OcrOverrides.cameraPermissionMessage!,
//               //'Camera Access Denied. To continue use the Graded+, Camera permission is required. Please go to the \'App Settings\' to enable the camera access.',
//               title: OcrOverrides.cameraPermissionTitle
//               //'Permission Required!'
//               );
//           break;

//         case 'CameraAccessRestricted':
//           // iOS only
//           showPopup(
//               message: OcrOverrides.cameraPermissionMessage!,
//               //      'Camera Access is Restricted. To continue use the Graded+, Camera access is required. Please go to the \'App Settings\' to enable the camera access.',
//               title: OcrOverrides.cameraPermissionTitle
//               //'Permission Required!'
//               );
//           break;

//         default:
//           _showCameraException(e);
//           break;
//       }
//     }

//     // Update the Boolean
//     if (mounted) {
//       _isCameraInitialized!.value = cameraController.value.isInitialized;

//       try {
//         await controller!.value.setFlashMode(
//             widget.isFlashOn!.value ? FlashMode.always : FlashMode.off);
//       } catch (e) {}
//     }
//   }

//   void _showCameraException(CameraException e) {
//     _logError(e.code, e.description);
//     Utility.showSnackBar(
//         _scaffoldKey, 'Error: ${e.code}\n${e.description}', context, null);
//   }

//   void _logError(String code, String? message) {
//     if (message != null) {
//       print('Error: $code\nError Message: $message');
//     } else {
//       print('Error: $code');
//     }
//   }

//   showPopup({required String message, required String? title}) {
//     return showDialog(
//         context: context,
//         builder: (context) =>
//             OrientationBuilder(builder: (context, orientation) {
//               return CommonPopupWidget(
//                   orientation: orientation,
//                   context: context,
//                   message: message,
//                   title: title!,
//                   isAccessDenied: true);
//             }));
//   }

//   Future<XFile?> takePicture() async {
//     final CameraController? cameraController = controller!.value;
//     if (cameraController!.value.isTakingPicture) {
//       // A capture is already pending, do nothing.
//       return null;
//     }
//     try {
//       XFile file = await cameraController.takePicture();
//       return file;
//     } on CameraException catch (e) {
//       //print('Error occured while taking picture: $e');
//       return null;
//     }
//   }

//   Future<void> _showStartDialog() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     bool? showPopUp = pref.getBool("camera_popup");

//     return showPopUp == null
//         ? showDialog<void>(
//             context: context,
//             barrierDismissible: false, // user must tap button!
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 backgroundColor: Colors.white,
//                 title: TranslationWidget(
//                     message:
//                         "Images are stored in the Cloud, not on your device",
//                     fromLanguage: "en",
//                     toLanguage: Globals.selectedLanguage,
//                     builder: (translatedMessage) {
//                       return Text(translatedMessage.toString(),
//                           textAlign: TextAlign.center,
//                           style: Theme.of(context)
//                               .textTheme
//                               .headline3!
//                               .copyWith(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold));
//                     }),
//                 titleTextStyle: Theme.of(context)
//                     .textTheme
//                     .headline3!
//                     .copyWith(color: Colors.black),
//                 actions: [
//                   Container(
//                     height: 1,
//                     width: MediaQuery.of(context).size.height,
//                     color: Colors.grey.withOpacity(0.2),
//                   ),
//                   Center(
//                     child: TextButton(
//                       child: TranslationWidget(
//                           message: "Ok",
//                           fromLanguage: "en",
//                           toLanguage: Globals.selectedLanguage,
//                           builder: (translatedMessage) {
//                             return Text(translatedMessage.toString(),
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .headline5!
//                                     .copyWith(
//                                       color: AppTheme.kButtonColor,
//                                     ));
//                           }),
//                       onPressed: () async {
//                         Globals.isCameraPopup = false;
//                         SharedPreferences pref =
//                             await SharedPreferences.getInstance();
//                         pref.setBool("camera_popup", false);
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                   ),
//                 ],
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//                 elevation: 16,
//               );
//             },
//           )
//         : null;
//   }

//   Future<List<StudentAssessmentInfo>> _getStudentInfoList() async {
//     // LocalDatabase<StudentAssessmentInfo> _studentAssessmentInfoDb =
//     //     LocalDatabase(Strings.studentInfoDbName);
//     return await _studentAssessmentInfoDb.getData();
//   }

// // Will be used in standalone app only
//   Future<List<String>> getSuggestionChips() async {
//     List<String> classSuggestionsList = [];

//     try {
//       List<StudentAssessmentInfo> studentInfo =
//           await Utility.getStudentInfoList(
//               tableName: Strings.studentInfoDbName);

//       LocalDatabase<GoogleClassroomCourses> _localDb =
//           LocalDatabase(Strings.googleClassroomCoursesList);

//       List<GoogleClassroomCourses>? _localData = await _localDb.getData();

// // filteredCourses only the courses that contain all scanned students
//       classSuggestionsList = _localData
//           .where((course) => course.studentList != null)
//           .where((course) => course.studentList!.any((student) => studentInfo
//               .any((s) => s.studentId == student['profile']['emailAddress'])))
//           .map((course) => course.name!)
//           .toSet() // remove duplicates
//           .toList();

// // if classSuggestionList is empty or null so get all local classroom courses
//       classSuggestionsList = classSuggestionsList?.isNotEmpty ?? false
//           ? classSuggestionsList
//           : _localData.map((course) => course.name!).toList();

//       classSuggestionsList.sort();
//       return classSuggestionsList ?? [];
//     } catch (e) {
//       return classSuggestionsList;
//     }
//   }

//   void setEnabledSystemUIMode() {
//     SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
//   }

//   Future<void> manualCameraFocusOnTap(TapUpDetails details) async {
//     if (controller!.value.value.isInitialized) {
//       showFocusCircle.value = true;
//       x = details.localPosition.dx;
//       y = details.localPosition.dy;

//       double fullWidth = MediaQuery.of(context).size.width;
//       double cameraHeight = fullWidth * controller!.value.value.aspectRatio;

//       double xp = x / fullWidth;
//       double yp = y / cameraHeight;

//       Offset point = Offset(xp, yp);

//       // Manually focus
//       await controller!.value.setFocusPoint(point);

//       // Manually set light exposure
//       await controller!.value.setExposurePoint(point);

//       Future.delayed(const Duration(seconds: 2)).whenComplete(() {
//         showFocusCircle.value = false;
//       });
//     }
//   }

//   Future<void> _navigatetoResultSection() async {
//     Navigator.of(context).pop();
//     if (widget.isFromHistoryAssessmentScanMore == true) {
//       Navigator.of(context)
//         ..pop()
//         ..pop()
//         ..pop();

//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//             builder: (context) => GradedPlusResultsSummary(
//                   isMcqSheet: widget.isMcqSheet,
//                   selectedAnswer: widget.selectedAnswer,
//                   obj: widget.obj,
//                   createdAsPremium: widget.createdAsPremium,
//                   historySecondTime:
//                       widget.isFromHistoryAssessmentScanMore ? true : null,
//                   assessmentName: Globals.assessmentName,
//                   shareLink: Globals.shareableLink ?? '',
//                   assessmentDetailPage: widget.isFromHistoryAssessmentScanMore,
//                   isScanMore: true,
//                   assessmentListLength: Globals.scanMoreStudentInfoLength,
//                 )),
//       );
//     } else {
//       final List<StudentAssessmentInfo> list =
//           await _studentAssessmentInfoDb.getData();

//       list.asMap().forEach(
//         (i, object) async {
//           object.isScanMore = false;
//           await _studentAssessmentInfoDb.putAt(i, object);
//         },
//       );

//       setEnabledSystemUIMode();
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => GradedPlusResultsSummary(
//                   isMcqSheet: widget.isMcqSheet,
//                   selectedAnswer: widget.selectedAnswer,
//                   createdAsPremium: widget.createdAsPremium,
//                   historySecondTime:
//                       widget.isFromHistoryAssessmentScanMore ? true : null,
//                   assessmentName: Globals.assessmentName,
//                   shareLink: Globals.shareableLink ?? '',
//                   assessmentDetailPage: widget.isFromHistoryAssessmentScanMore,
//                   isScanMore: true,
//                   assessmentListLength: Globals.scanMoreStudentInfoLength,
//                 )),
//       );
//     }
//   }

//   _navigateToCreateAssessment({required List<String> suggestionList}) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//           builder: (context) => GradedPlusCreateAssessment(
//               isMcqSheet: widget.isMcqSheet,
//               selectedAnswer: widget.selectedAnswer,
//               customGrades: classList,
//               classSuggestions: suggestionList)),
//     );
//   }

//   // notPresentStudentsPopupModal(
//   //     {required List<StudentAssessmentInfo>
//   //         notPresentStudentsInSelectedClass}) async {
//   //   showDialog(
//   //       context: context,
//   //       builder: (showDialogContext) => NonCourseGoogleClassroomNonCourseGoogleClassroomStudentPopup(
//   //             key: _dialogKey,
//   //             notPresentStudentsInSelectedClass:
//   //                 notPresentStudentsInSelectedClass,
//   //             title: 'Action Required!',
//   //             message:
//   //                 "A few students not found in the selected course . Do you still want to continue with these students?",
//   //             studentInfoDb: widget.isFromHistoryAssessmentScanMore == true
//   //                 ? _historystudentAssessmentInfoDb
//   //                 : _studentAssessmentInfoDb,
//   //             onTapCallback: () {
//   //               // Close the dialog from outside
//   //               if (_dialogKey.currentState != null) {
//   //                 _dialogKey.currentState!.closeDialog();
//   //               }
//   //               preparingGoogleSlideFiles();
//   //             },
//   //           ));
//   // }

//   // Future<void> preparingGoogleSlideFiles() async {
//   //   if (widget.isFromHistoryAssessmentScanMore == true) {
//   //     _driveBloc.add(UpdateGoogleSlideOnScanMore(
//   //         studentInfoDb: LocalDatabase(Strings.historyStudentInfoDbName),
//   //         isMcqSheet: widget.isMcqSheet ?? false,
//   //         assessmentName: widget.assessmentName ?? '',
//   //         isFromHistoryAssessment: widget.isFromHistoryAssessmentScanMore,
//   //         lastAssessmentLength: widget.lastAssessmentLength ?? 0,
//   //         slidePresentationId: Globals.googleSlidePresentationId!));
//   //   } else if (!widget.isFromHistoryAssessmentScanMore &&
//   //       widget.isScanMore == true) {
//   //     _driveBloc.add(AddAndUpdateAssessmentImageToSlidesOnDrive(
//   //         isScanMore: true,
//   //         slidePresentationId: Globals.googleSlidePresentationId,
//   //         studentInfoDb: LocalDatabase(Strings.studentInfoDbName)));
//   //     //
//   //   } else {
//   //     if (Overrides.STANDALONE_GRADED_APP == true) {
//   //       //Prepare suggestion chips for create screen //course list
//   //       Utility.showLoadingDialog(context: context, isOCR: true);
//   //       List<String> suggestionList = await getSuggestionChips();
//   //       Navigator.of(context).pop();

//   //       _navigateToCreateAssessment(suggestionList: suggestionList);
//   //     } else {
//   //       List<String> classSuggestions = await _localDb.getData();
//   //       LocalDatabase<String> classSectionLocalDb =
//   //           LocalDatabase('class_section_list');

//   notPresentStudentsPopupModal(
//       {required List<StudentAssessmentInfo>
//           notPresentStudentsInSelectedClass}) async {
//     String course = getCourse();
//     showDialog(
//         context: context,
//         builder: (showDialogContext) => NonCourseGoogleClassroomStudentPopup(
//               key: _dialogKey,
//               notPresentStudentsInSelectedClass:
//                   notPresentStudentsInSelectedClass,
//               title: 'Action Required!',
//               message:
//                   "A few students not found in the selected course \'$course\'. Do you still want to continue with these students?",
//               studentInfoDb: widget.isFromHistoryAssessmentScanMore == true
//                   ? _historystudentAssessmentInfoDb
//                   : _studentAssessmentInfoDb,
//               onTapCallback: () {
//                 // Close the dialog from outside
//                 if (_dialogKey.currentState != null) {
//                   _dialogKey.currentState!.closeDialog();
//                 }
//                 preparingGoogleSlideFiles();
//               },
//             ));
//   }

//   Future<void> preparingGoogleSlideFiles() async {
//     if (widget.isFromHistoryAssessmentScanMore == true) {
//       _driveBloc.add(UpdateGoogleSlideOnScanMore(
//           studentInfoDb: LocalDatabase(Strings.historyStudentInfoDbName),
//           isMcqSheet: widget.isMcqSheet ?? false,
//           assessmentName: widget.assessmentName ?? '',
//           isFromHistoryAssessment: widget.isFromHistoryAssessmentScanMore,
//           lastAssessmentLength: widget.lastAssessmentLength ?? 0,
//           slidePresentationId: Globals.googleSlidePresentationId!));
//     } else if (!widget.isFromHistoryAssessmentScanMore &&
//         widget.isScanMore == true) {
//       _driveBloc.add(AddAndUpdateAssessmentImageToSlidesOnDrive(
//           isScanMore: true,
//           slidePresentationId: Globals.googleSlidePresentationId,
//           studentInfoDb: LocalDatabase(Strings.studentInfoDbName)));
//       //
//     } else {
//       if (Overrides.STANDALONE_GRADED_APP == true) {
//         //Prepare suggestion chips for create screen //course list
//         Utility.showLoadingDialog(context: context, isOCR: true);
//         List<String> suggestionList = await getSuggestionChips();
//         Navigator.of(context).pop();

//         // if (isAllStudentsBelongToSameCourse) {
//         //   _navigateToCreateAssessment(
//         //       suggestionList: suggestionList);
//         // } else {
//         //   removeNonCourseGoogleClassroomStudentPopupModal(
//         //       suggestionList: suggestionList);
//         // }
//         _navigateToCreateAssessment(suggestionList: suggestionList);

//         // Navigator.pushReplacement(
//         //   context,
//         //   MaterialPageRoute(
//         //       builder: (context) => CreateAssessment(
//         //           isMcqSheet: widget.isMcqSheet,
//         //           selectedAnswer: widget.selectedAnswer,
//         //           customGrades: classList,
//         //           classSuggestions: suggestionList)),
//         // );
//       } else {
//         List<String> classSuggestions = await _localDb.getData();
//         LocalDatabase<String> classSectionLocalDb =
//             LocalDatabase('class_section_list');

//         List<String> localSectionList = await classSectionLocalDb.getData();

//         // Compares 2 list and update the changes in local database.
//         bool isClassChanges = false;
//         for (int i = 0; i < classList.length; i++) {
//           if (!localSectionList.contains(classList[i])) {
//             isClassChanges = true;
//             break;
//           }
//         }

//         if (localSectionList.isEmpty || isClassChanges) {
//           //print("local db is empty");
//           classSectionLocalDb.clear();
//           classList.forEach((String e) {
//             classSectionLocalDb.addData(e);
//           });
//         } else {
//           //print("local db is not empty");
//           classList = [];
//           classList.addAll(localSectionList);
//         }
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (context) => GradedPlusCreateAssessment(
//                   isMcqSheet: widget.isMcqSheet,
//                   selectedAnswer: widget.selectedAnswer,
//                   customGrades: classList,
//                   classSuggestions: classSuggestions)),
//         );
//       }
//     }
//   }

//   String getCourse() {
//     // Extract the course name from the assessment name, which is in the format "assessment_math"

//     String course = widget.isFromHistoryAssessmentScanMore
//         ? Globals?.historyAssessmentName ?? ''
//         : Globals?.assessmentName ?? '';
// // Split the assessment name by "_" and get the second element, which contains the course name
//     return course.contains("_") ? course.split("_")[1] : '';
//   }

// //   Future removeStudentRecordFromStudentInfoDB() async {
// //     List<StudentAssessmentInfo> studentinfo =
// //         await _studentAssessmentInfoDb.getData();

//   //       // Compares 2 list and update the changes in local database.
//   //       bool isClassChanges = false;
//   //       for (int i = 0; i < classList.length; i++) {
//   //         if (!localSectionList.contains(classList[i])) {
//   //           isClassChanges = true;
//   //           break;
//   //         }
//   //       }

//   //       if (localSectionList.isEmpty || isClassChanges) {
//   //         //print("local db is empty");
//   //         classSectionLocalDb.clear();
//   //         classList.forEach((String e) {
//   //           classSectionLocalDb.addData(e);
//   //         });
//   //       } else {
//   //         //print("local db is not empty");
//   //         classList = [];
//   //         classList.addAll(localSectionList);
//   //       }
//   //       Navigator.pushReplacement(
//   //         context,
//   //         MaterialPageRoute(
//   //             builder: (context) => CreateAssessment(
//   //                 isMcqSheet: widget.isMcqSheet,
//   //                 selectedAnswer: widget.selectedAnswer,
//   //                 customGrades: classList,
//   //                 classSuggestions: classSuggestions)),
//   //       );
//   //     }
//   //   }
//   // }
// }
