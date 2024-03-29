import 'dart:async';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/google_drive/model/assessment.dart';
import 'package:Soc/src/modules/graded_plus/bloc/graded_plus_bloc.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_overrides.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_plus_utilty.dart';
import 'package:Soc/src/modules/graded_plus/modal/individualStudentModal.dart';
import 'package:Soc/src/modules/graded_plus/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/student_details_standard_modal.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/camera_screen.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/scan_result/scan_result_method.dart';
import 'package:Soc/src/modules/graded_plus/widgets/graded_plus_next_scananimation_button.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_fab.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/graded_plus/widgets/suggestion_chip.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/firstLetterUpperCase.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/image_popup.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class GradedPlusScanResult extends StatefulWidget {
  final bool? isMcqSheet;
  final String? selectedAnswer;
  final String img64;
  final File imgPath;
  final String? pointPossible;
  final bool? isScanMore;
  final bool? isFromHistoryAssessmentScanMore;
  final bool? createdAsPremium;
  final HistoryAssessment? obj;
  final String? questionImageUrl;
  final bool isFlashOn;
  final String? assessmentName;
  final int? lastAssessmentLength;
  final IconData? titleIconData;

  GradedPlusScanResult(
      {Key? key,
      this.isMcqSheet,
      this.assessmentName,
      this.lastAssessmentLength,
      this.selectedAnswer,
      required this.img64,
      required this.imgPath,
      this.pointPossible,
      this.isScanMore,
      this.questionImageUrl,
      required this.isFromHistoryAssessmentScanMore,
      this.createdAsPremium,
      this.obj,
      required this.isFlashOn,
      this.titleIconData})
      : super(key: key);

  @override
  State<GradedPlusScanResult> createState() => _GradedPlusScanResultState();
}

class _GradedPlusScanResultState extends State<GradedPlusScanResult>
    with TickerProviderStateMixin {
  static const double _KVerticalSpace = 60.0;
  OcrBloc _bloc = OcrBloc();
  OcrBloc _bloc2 = OcrBloc();
  //bool failure = false;
  final ValueNotifier<bool> isSuccessResult = ValueNotifier<bool>(true);
  RegExp regex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  bool isSelected = true;

  List<StudentClassroomInfo> studentInfo = [];
  List<StudentDetailsModal> standardStudentDetails = [];
  bool onChange = false;
  String studentName = '';
  String studentId = '';
  late Timer? timer;
  List<String> suggestionEmailList = [];
  List<String> suggestionNameList = [];
  final ValueNotifier<int> suggestionNameListLenght = ValueNotifier<int>(0);
  final ValueNotifier<int> suggestionEmailListLenght = ValueNotifier<int>(0);
  final ValueNotifier<String> scanFailure = ValueNotifier<String>('');
  final ValueNotifier<dynamic> indexColor = ValueNotifier<dynamic>(2);
  final ValueNotifier<String> isStudentNameFilled = ValueNotifier<String>('');
  final ValueNotifier<String> isStudentIdFilled = ValueNotifier<String>('');
  final ValueNotifier<bool> isRetryButton = ValueNotifier<bool>(false);
  final ValueNotifier<bool> rubricNotDetected = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isNameUpdated = ValueNotifier<bool>(false);
  var nameController = TextEditingController();
  var idController = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool? valuechange;
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);
  GoogleDriveBloc _googleDriveBloc = GoogleDriveBloc();
  final ValueNotifier<String> pointScored = ValueNotifier<String>('2');
  final ValueNotifier<bool> animationStart = ValueNotifier<bool>(false);
  ScrollController scrollControlledName = new ScrollController();
  ScrollController scrollControllerId = new ScrollController();
  LocalDatabase<StudentAssessmentInfo> _studentInfoDb =
      LocalDatabase('student_info');
  LocalDatabase<StudentAssessmentInfo> _standardStudentDetailsDb =
      LocalDatabase(Strings.studentDetailList);
  bool isFirstTime = true;

  late AnimationController _controller;
  late Animation<double> _animation;
  bool isRubricChanged = false; // boolean to check rubric is change or not
  String uniqueId = DateTime.now().microsecondsSinceEpoch.toString(); // Unq
  bool initialCursorPositionAtLast = true; //To manage textfield cursor position

  //Used to detect the student id change when user changes the id even after successful detection
  String? detectStudentIdChange = '';

  void initState() {
    print(Globals.googleSlidePresentationId);
    super.initState();
    _bloc.add(FetchTextFromImage(
        selectedAnswer: widget.selectedAnswer,
        isMcqSheet: widget.isMcqSheet ?? false,
        base64: widget.img64,
        pointPossible: widget.pointPossible ?? '2'));

    FirebaseAnalyticsService.addCustomAnalyticsEvent("success_screen");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'success_screen', screenClass: 'GradedPlusScanResult');

    if (widget.isMcqSheet == true) {
      _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000),
      );

      _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: _controller, curve: Curves.linearToEaseOut)) //easeInOut
        ..addListener(() {
          setState(() {});
        });

      _controller.repeat();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      OcrOverrides.gradedPlusNavBarIsHide.value = false;
    });
  }

  @override
  void dispose() {
    scrollControlledName.dispose();
    scrollControllerId.dispose();

    if (widget.isMcqSheet == true) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(children: [
        CommonBackgroundImgWidget(),
        Scaffold(
          resizeToAvoidBottomInset: true,
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: appBar(),
          body: body(),
          floatingActionButton: nextScanFloatingActionButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        )
      ]),
    );
  }

  PreferredSizeWidget appBar() {
    return CustomOcrAppBarWidget(
      refresh: (v) {
        setState(() {});
      },
      commonLogoPath: Color(0xff000000) == Theme.of(context).backgroundColor
          ? "assets/images/graded+_light.png"
          : "assets/images/graded+_dark.png",
      iconData: widget.titleIconData,
      plusAppName: 'GRADED+',
      fromGradedPlus: true,
      isBackButton: false,
      isSuccessState: isSuccessResult,
      isHomeButtonPopup: true,
      isBackOnSuccess: isBackFromCamera,
      actionIcon: Container(),
      key: null,
    );
  }

  Widget nextScanFloatingActionButton() {
    return ValueListenableBuilder(
        valueListenable: scanFailure,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          if (scanFailure.value == "Success") {
            return ValueListenableBuilder(
                valueListenable: isBackFromCamera,
                child: Container(),
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return
                      // isBackFromCamera.value != true
                      //     ?
                      Align(
                    alignment: Alignment.bottomCenter,
                    child: ValueListenableBuilder(
                        valueListenable: animationStart,
                        child: Container(),
                        builder: (BuildContext context, dynamic value,
                            Widget? child) {
                          return InkWell(
                            onTap: () async {
                              onPressSuccessFloatingButton();
                            },
                            child: GradedPlusNextScanAnimationButton(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height:
                                  MediaQuery.of(context).size.height * 0.055,
                              animationDuration: Duration(milliseconds: 4950),
                              animationStart: animationStart.value,
                            ),
                          );
                        }),
                  );
                  //  : Container();
                });
          } else if (scanFailure.value == "") {
            return Container();
          } else {
            return ValueListenableBuilder(
              valueListenable: isStudentIdFilled,
              child: Container(),
              builder: (context, value, child) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.055,
                  // width: MediaQuery.of(context).size.width * 0.3,
                  child: FloatingActionButton.extended(
                    backgroundColor: AppTheme.kButtonColor,
                    onPressed: () {
                      //  Condition to check id is validate or not
                      if (ScanResultMethods.validateStudentId(
                          value: idController.text, regex: regex)) {
                        onPressAction();
                      } else {
                        PlusUtility.updateLogs(
                            activityType: 'GRADED+',
                            userType: 'Teacher',
                            activityId: '9',
                            description: 'Scan Failure and teacher retry scan',
                            operationResult: 'Failure');

                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        Navigator.of(context).pop(widget.isFlashOn);
                      }
                    },
                    label: Container(
                      child: Row(
                        children: [
                          Utility.textWidget(
                              text: ScanResultMethods.validateStudentId(
                                      value: idController.text, regex: regex)
                                  ? "Next"
                                  : 'Retry',
                              context: context,
                              textTheme: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                      color:
                                          Theme.of(context).backgroundColor)),
                        ],
                      ),
                    ),
                    icon: ScanResultMethods.validateStudentId(
                            value: idController.text, regex: regex)
                        ? Icon(
                            IconData(0xe877,
                                fontFamily: Overrides.kFontFam,
                                fontPackage: Overrides.kFontPkg),
                            size: 20,
                            color: Theme.of(context).backgroundColor,
                            // color: AppTheme.kButtonColor,
                          )
                        : Icon(
                            Icons.refresh,
                            color: Theme.of(context).backgroundColor,
                          ),
                  ),
                );
              },
            );
          }
        });
  }

  Widget body() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: StudentPlusOverrides.kSymmetricPadding),
      child: BlocConsumer<OcrBloc, OcrState>(
        bloc: _bloc, // provide the local bloc instance
        listener: (context, state) async {
          await Future.delayed(Duration(milliseconds: 200));
          if (state is OcrLoading) {
            studentInfo = [];
            studentInfo = await OcrUtility.getStudentList();
            Timer(Duration(seconds: 5), () {
              isRetryButton.value = true;
            });
          }
          if (state is FetchTextFromImageSuccess) {
            updateStudentDetails();
            scanFailure.value = 'Success';
            _performAnimation();
            PlusUtility.updateLogs(
                activityType: 'GRADED+',
                userType: 'Teacher',
                activityId: '23',
                description: 'Scan Assessment sheet successfully',
                operationResult: 'Success');
            if (widget.isMcqSheet == true) {
              Globals.pointsEarnedList = ['A', 'B', 'C', 'D', 'E', 'NA'];
            } else {
              widget.pointPossible == '3'
                  ? Globals.pointsEarnedList = [0, 1, 2, 3]
                  : widget.pointPossible == '4'
                      ? Globals.pointsEarnedList = [0, 1, 2, 3, 4]
                      : Globals.pointsEarnedList = [0, 1, 2];
            }
            nameController.text =
                isStudentNameFilled.value = state.studentName!;
            onChange == false ? idController.text = state.studentId! : null;
            pointScored.value = state.grade!;

            if (isStudentIdFilled.value.isNotEmpty &&
                    Overrides.STANDALONE_GRADED_APP == true
                ? (regex.hasMatch(isStudentIdFilled.value))
                : isStudentIdFilled.value.isNotEmpty) {
              if (nameController.text.isNotEmpty &&
                  idController.text.isNotEmpty) {
                timer = await Timer(Duration(seconds: 5), () async {
                  updateDetails(
                      isFromHistoryAssessmentScanMore:
                          widget.isFromHistoryAssessmentScanMore);
                  String imgExtension = widget.imgPath.path
                      .substring(widget.imgPath.path.lastIndexOf(".") + 1);
                  _googleDriveBloc.add(AssessmentImgToAwsBucked(
                      isHistoryAssessmentSection:
                          widget.isFromHistoryAssessmentScanMore,
                      imgBase64: widget.img64,
                      imgExtension: imgExtension,
                      studentId: idController.text));

                  // COMMENT below section for enabling the camera

                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GradedPlusCameraScreen(
                              titleIconData: widget.titleIconData,
                              assessmentName: widget.assessmentName,
                              lastAssessmentLength: widget.lastAssessmentLength,
                              isMcqSheet: widget.isMcqSheet,
                              selectedAnswer: widget.selectedAnswer,
                              questionImageLink: widget.questionImageUrl ?? '',
                              obj: widget.obj,
                              createdAsPremium: widget.createdAsPremium,
                              isFromHistoryAssessmentScanMore:
                                  widget.isFromHistoryAssessmentScanMore!,
                              onlyForPicture: false,
                              isScanMore: widget.isScanMore,
                              pointPossible: widget.pointPossible,
                              isFlashOn: ValueNotifier<bool>(widget.isFlashOn),
                            )),
                  );
                  if (result == true) {
                    isBackFromCamera.value = result;
                    initialCursorPositionAtLast = true;
                  }
                });
              }
            } else {
              isSuccessResult.value = true;
            }
          } else if (state is FetchTextFromImageFailure) {
            updateStudentDetails();
            scanFailure.value = 'Failure';

            isSuccessResult.value = false;

            if (widget.isMcqSheet == true) {
              Globals.pointsEarnedList = ['A', 'B', 'C', 'D', 'E', 'NA'];
            } else {
              widget.pointPossible == '3'
                  ? Globals.pointsEarnedList = [0, 1, 2, 3]
                  : widget.pointPossible == '4'
                      ? Globals.pointsEarnedList = [0, 1, 2, 3, 4]
                      : Globals.pointsEarnedList = [0, 1, 2];
            }
            if (state.grade == '') {
              Utility.currentScreenSnackBar(
                  widget.isMcqSheet == true
                      ? 'Could Not Detect The Right Answer'
                      : 'Could Not Detect The Right Score',
                  null);
            }

            PlusUtility.updateLogs(
                activityType: 'GRADED+',
                userType: 'Teacher',
                activityId: '23',
                description: state.grade == '' && state.studentId == ''
                    ? (Overrides.STANDALONE_GRADED_APP == true
                        ? ' Unable to detect Student Email and grade'
                        : 'Unable to detect Student Id and grade')
                    : (state.grade == '' && state.studentId != '')
                        ? 'Unable to detect rubric score'
                        : (state.grade != '' && state.studentId == '')
                            ? (Overrides.STANDALONE_GRADED_APP == true
                                ? 'Unable to detect Student Email '
                                : 'Unable to detect Student Id ')
                            : (state.grade != '' &&
                                    state.studentId != '' &&
                                    state.studentName == '')
                                ? 'Unable to detect Student Name OR Student does not exist in the database'
                                : 'Unable to fetch details(Scan Failure)',
                operationResult: 'Failure');

            onChange == false
                ? idController.text = state.studentId ?? ''
                : state.studentId == ''
                    ? studentId
                    : null;
            onChange == false
                ? nameController.text =
                    isStudentNameFilled.value = state.studentName ?? ''
                : null;
            pointScored.value = state.grade!;
            // updateDetails();
          }
          // do stuff here based on BlocA's state
        },
        builder: (context, state) {
          if (state is OcrLoading) {
            return loadingScreen();
          } else if (state is FetchTextFromImageSuccess) {
            nameController.text = state.studentName!;
            if (widget.isMcqSheet == true) {
              Globals.pointsEarnedList = ['A', 'B', 'C', 'D', 'E', 'NA'];
            } else {
              widget.pointPossible == '3'
                  ? Globals.pointsEarnedList = [0, 1, 2, 3]
                  : widget.pointPossible == '4'
                      ? Globals.pointsEarnedList = [0, 1, 2, 3, 4]
                      : Globals.pointsEarnedList = [0, 1, 2];
            }
            onChange == false ? idController.text = state.studentId! : null;
            pointScored.value = state.grade!;

            return gradedPlusSuccessScanResult(
                id: state.studentId!, grade: state.grade!);
          } else if (state is FetchTextFromImageFailure) {
            onChange == false
                ? idController.text = state.studentId ?? ''
                : state.studentId == ''
                    ? studentId
                    : null;
            if (widget.isMcqSheet == true) {
              Globals.pointsEarnedList = ['A', 'B', 'C', 'D', 'E', 'NA'];
            } else {
              widget.pointPossible == '3'
                  ? Globals.pointsEarnedList = [0, 1, 2, 3]
                  : widget.pointPossible == '4'
                      ? Globals.pointsEarnedList = [0, 1, 2, 3, 4]
                      : Globals.pointsEarnedList = [0, 1, 2];
            }
            onChange == false
                ? nameController.text = state.studentName ?? ''
                : null;
            pointScored.value = state.grade!;

            if (state.grade == '') {
              rubricNotDetected.value = true;
            }

            return failureScreen(id: state.studentId!, grade: state.grade!);
          }
          return Container();
          // return widget here based on BlocA's state
        },
      ),
    );
  }

  onPressAction() async {
    if (isBackFromCamera.value == true) {
      updateDetails(
          isUpdateData: true,
          isFromHistoryAssessmentScanMore:
              widget.isFromHistoryAssessmentScanMore);
      _navigatetoCameraSection();
    } else {
      if (_formKey1.currentState == null) {
        scanFailure.value = 'Failure';
      }

      if (idController.text.isNotEmpty &&
              Overrides.STANDALONE_GRADED_APP == true
          ? (regex.hasMatch(idController.text))
          : (Utility.checkForInt(idController.text)
              ? (idController.text.length == 9 &&
                  ((idController.text[0] == '2' ||
                      idController.text[0] == '1')))
              : (regex.hasMatch(idController.text)))) {
        if (Overrides.STANDALONE_GRADED_APP == true) {
          bool result = await OcrUtility.checkEmailFromGoogleClassroom(
              studentEmail:
                  idController.value.text); //checkEmailFromGoogleclassroom();
          if (!result) {
            //  Scaffold.of(context).showSnackBar(showSnack('Error. Could not log out'));
            Utility.currentScreenSnackBar(
                'Please use imported email address from google classroom',
                null);
            return;
          }
        }
        updateDetails(
            isFromHistoryAssessmentScanMore:
                widget.isFromHistoryAssessmentScanMore);

        if (idController.text.isNotEmpty) {
          if (Overrides.STANDALONE_GRADED_APP != true &&
              nameController.text.isNotEmpty) {
            _bloc.add(SaveStudentDetails(
                studentName: nameController.text,
                studentId: idController.text));
          }
          String imgExtension = widget.imgPath.path
              .substring(widget.imgPath.path.lastIndexOf(".") + 1);

          _googleDriveBloc.add(AssessmentImgToAwsBucked(
              isHistoryAssessmentSection:
                  widget.isFromHistoryAssessmentScanMore,
              imgBase64: widget.img64,
              imgExtension: imgExtension,
              studentId: idController.text));

          _navigatetoCameraSection();
        }
      }
    }
  }

  onPressSuccessFloatingButton() async {
    if (animationStart.value == true) {
      timer!.cancel();

      updateDetails(
          isFromHistoryAssessmentScanMore:
              widget.isFromHistoryAssessmentScanMore);
      PlusUtility.updateLogs(
          activityType: 'GRADED+',
          userType: 'Teacher',
          activityId: '10',
          description: 'Next Scan',
          operationResult: 'Success');

      String imgExtension = widget.imgPath.path
          .substring(widget.imgPath.path.lastIndexOf(".") + 1);
      _googleDriveBloc.add(AssessmentImgToAwsBucked(
          isHistoryAssessmentSection: widget.isFromHistoryAssessmentScanMore,
          imgBase64: widget.img64,
          imgExtension: imgExtension,
          studentId: idController.text));
      // }
      // COMMENT below section for enableing the camera
      var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GradedPlusCameraScreen(
                  titleIconData: widget.titleIconData,
                  assessmentName: widget.assessmentName,
                  lastAssessmentLength: widget.lastAssessmentLength,
                  isMcqSheet: widget.isMcqSheet,
                  selectedAnswer: widget.selectedAnswer,
                  questionImageLink: widget.questionImageUrl ?? '',
                  obj: widget.obj,
                  createdAsPremium: widget.createdAsPremium,
                  isFromHistoryAssessmentScanMore:
                      widget.isFromHistoryAssessmentScanMore!,
                  onlyForPicture: false,
                  isScanMore: widget.isScanMore,
                  pointPossible: widget.pointPossible,
                  isFlashOn: ValueNotifier<bool>(widget.isFlashOn),
                )),
      );
      if (result == true) {
        isBackFromCamera.value = result;
        initialCursorPositionAtLast = true;
      }
    }
  }

  Widget loadingScreen() {
    return ValueListenableBuilder(
        valueListenable: isRetryButton,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppTheme.kButtonColor,
                ),
                SizedBox(
                  height: 30,
                ),
                isRetryButton.value == true
                    ? retryButton(onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        Navigator.of(context).pop(widget.isFlashOn);
                      })
                    : Container()
              ],
            ),
          );
        });
  }

  Widget failureScreen({
    required String id,
    required String grade,
  }) {
    isStudentIdFilled.value = id;
    return Form(
      key: _formKey1,
      child: ListView(
        padding: EdgeInsets.symmetric(
            vertical: 0, horizontal: StudentPlusOverrides.kLabelSpacing / 2),
        children: [
          BlocListener<OcrBloc, OcrState>(
            bloc: _bloc2,
            child: Container(),
            listener: (context, state) async {
              if (state is SuccessStudentDetails) {
                nameController.text = state.studentName;
                isStudentNameFilled.value = state.studentName;
                isNameUpdated.value = !isNameUpdated.value;
                // _formKey1.currentState!.validate();
              }
            },
          ),
          SpacerWidget(StudentPlusOverrides.KVerticalSpace / 4),
          SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
          Utility.textWidget(
              text: 'Student Name',
              context: context,
              textTheme: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryVariant
                      .withOpacity(0.3))),
          textFormField(
              scrollController: scrollControlledName,
              controller: nameController,
              hintText: 'Student Name',
              inputFormatters: <TextInputFormatter>[
                //To capitalize first letter of the textfield
                UpperCaseTextFormatter()
              ],
              // keyboardType: TextInputType.,
              isFailure: true,
              onSaved: (String value) {
                studentNameOnSaveFailure(value);
              },
              validator: (String? value) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  isStudentNameFilled.value = value!; //nameController.text;
                });
                // isStudentNameFilled.value = value!; //nameController.text;

                return isStudentNameFilled.value.isEmpty ||
                        isStudentNameFilled.value.length < 3
                    ? ''
                    : null;
              }),
          ValueListenableBuilder(
              valueListenable: isStudentNameFilled,
              child: Container(),
              builder: (BuildContext context, dynamic value, Widget? child) {
                if (isStudentNameFilled?.value?.isEmpty ?? true) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    suggestionNameListLenght.value = 0;
                  });
                }
                return isStudentNameFilled.value.length < 3
                    ? Container(
                        // padding: null,
                        alignment: Alignment.centerLeft,
                        child: TranslationWidget(
                            message: Overrides.STANDALONE_GRADED_APP == true
                                ? (isStudentNameFilled.value == ""
                                    ? 'Student Name is required'
                                    : nameController.text.length < 3
                                        ? 'Make Sure The Student Name Contains More Than 3 Character'
                                        : '')
                                : isStudentNameFilled.value == ""
                                    ? 'Please Enter The Student Name'
                                    : nameController.text.length < 3
                                        ? 'Make Sure The Student Name Contains More Than 3 Character'
                                        : '',
                            fromLanguage: "en",
                            toLanguage: Globals.selectedLanguage,
                            builder: (translatedMessage) {
                              return Text(
                                translatedMessage,
                                style: TextStyle(color: Colors.red),
                              );
                            }),
                      )
                    : Container();
              }),
          suggestionWidget(isNameList: true),
          SpacerWidget(_KVerticalSpace / 3),
          Utility.textWidget(
              text: Overrides.STANDALONE_GRADED_APP == true
                  ? 'Student Email'
                  : 'Student ID/Student Email',
              context: context,
              textTheme: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryVariant
                      .withOpacity(0.3))),
          ValueListenableBuilder(
              valueListenable: isStudentIdFilled,
              child: Container(),
              builder: (BuildContext context, dynamic value, Widget? child) {
                // return emailTextField();
                return Wrap(
                  children: [
                    textFormField(
                      scrollController: scrollControllerId,
                      controller: idController,
                      hintText: Overrides.STANDALONE_GRADED_APP == true
                          ? 'Student Email'
                          : 'Student ID/Email',
                      isFailure: true,
                      // errormsg:
                      //     "Student Id should not be empty, must start with '2' and contains a '9' digit number.",
                      onSaved: (String value) {
                        initialCursorPositionAtLast = false;
                        studentIdOnSaveFailure(value, false);
                      },
                      validator: (String? value) {
                        // isStudentIdFilled.value = value!;
                        // WidgetsBinding.instance.addPostFrameCallback((_) {
                        //  isStudentIdFilled.value = value!;
                        // });
                        return Overrides.STANDALONE_GRADED_APP == true
                            ? idController.text.isEmpty ||
                                    !regex.hasMatch(idController.text)
                                ? ''
                                : null
                            : idController.text.isEmpty
                                ? ''
                                : null;
                      },
                      inputFormatters: [],
                      maxNineDigit: Utility.checkForInt(idController.text)
                          ? true
                          : false, //true
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: TranslationWidget(
                          message: Overrides.STANDALONE_GRADED_APP == true
                              ? (idController.text == ''
                                  ? 'Student Email Is Required'
                                  : (!regex.hasMatch(idController.text))
                                      ? 'Please Enter valid Email'
                                      : '')
                              : idController.text.isEmpty
                                  ? 'Please Enter Valid Email ID or Student ID'
                                  : Utility.checkForInt(idController.text)
                                      ? (idController.text.length != 9
                                          ? 'Student Id should be 9 digit'
                                          : (idController.text[0] != '2' &&
                                                  idController.text[0] != '1'
                                              ? 'Student Id should be start for 1 or 2'
                                              : ''))
                                      : (!regex.hasMatch(idController.text))
                                          ? 'Please Enter valid Email'
                                          : '',

                          // (isStudentIdFilled.value == ""
                          //     ? 'Student ID/Email Is Required'
                          //     : ''),
                          fromLanguage: "en",
                          toLanguage: Globals.selectedLanguage,
                          builder: (translatedMessage) {
                            return Text(
                              translatedMessage,
                              style: TextStyle(color: Colors.red),
                            );
                          }),
                    ),
                  ],
                );
              }),
          suggestionWidget(isNameList: false),
          SpacerWidget(StudentPlusOverrides.kSymmetricPadding / 2),
          Center(
            child: Utility.textWidget(
                textAlign: TextAlign.center,
                text: widget.isMcqSheet == true
                    ? 'Student Selection'
                    : 'Points Earned',
                context: context,
                textTheme: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryVariant
                        .withOpacity(0.3))),
          ),
          SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
          pointsEarnedButton(
              widget.isMcqSheet == true
                  ? grade == ''
                      ? 'NA'
                      : grade
                  : (grade == '' ? 2 : int.parse(grade)),
              isSuccessState: false),
          SpacerWidget(widget.isMcqSheet == true
              ? StudentPlusOverrides.kSymmetricPadding * 0
              : StudentPlusOverrides.kSymmetricPadding * 2.5),
          Center(child: imagePreviewWidget()),
          SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
        ],
      ),
    );
  }

  Widget suggestionWidget({required bool isNameList}) {
    return ValueListenableBuilder(
        valueListenable: isNameList == true
            ? suggestionNameListLenght
            : suggestionEmailListLenght,
        child: Container(),
        builder: (BuildContext context, int value, Widget? child) {
          // print("printing value --$value");

          return suggestionNameListLenght.value == 0 &&
                      suggestionEmailListLenght.value == 0 ||
                  (suggestionNameListLenght.value == 0 && isNameList == true) ||
                  (suggestionEmailListLenght.value == 0 && isNameList != true)
              ? Container()
              : Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  height: 30,
                  child: ChipsFilter(
                      selectedValue: (String value) {
                        if (value.isNotEmpty) {
                          if (isNameList == true) {
                            if (Overrides.STANDALONE_GRADED_APP == true) {
                              nameController.text = value;
                              for (int i = 0; i < studentInfo.length; i++) {
                                if (studentInfo[i].studentName! == value) {
                                  idController.text =
                                      studentInfo[i].studentEmail!;
                                  isNameUpdated.value = !isNameUpdated.value;
                                  isStudentNameFilled.value =
                                      studentInfo[i].studentName!;
                                  suggestionNameList = [];
                                  suggestionNameListLenght.value = 0;
                                  isStudentIdFilled.value =
                                      studentInfo[i].studentEmail!;
                                  suggestionEmailList = [];
                                  suggestionEmailListLenght.value = 0;

                                  break;
                                }
                              }
                            } else {
                              nameController.text = value;
                              for (int i = 0;
                                  i < standardStudentDetails.length;
                                  i++) {
                                if (standardStudentDetails[i].name! == value) {
                                  idController.text =
                                      standardStudentDetails[i].studentId!;
                                  isNameUpdated.value = !isNameUpdated.value;
                                  isStudentNameFilled.value =
                                      standardStudentDetails[i].name!;
                                  suggestionNameList = [];
                                  suggestionNameListLenght.value = 0;
                                  isStudentIdFilled.value =
                                      standardStudentDetails[i].studentId!;
                                  suggestionEmailList = [];
                                  suggestionEmailListLenght.value = 0;

                                  break;
                                }
                              }
                            }
                          } else {
                            if (Overrides.STANDALONE_GRADED_APP == true) {
                              idController.text = value;
                              isStudentIdFilled.value = value;
                              for (int i = 0; i < studentInfo.length; i++) {
                                if (studentInfo[i].studentEmail! == value) {
                                  nameController.text =
                                      studentInfo[i].studentName!;
                                  isNameUpdated.value = !isNameUpdated.value;
                                  isStudentNameFilled.value =
                                      studentInfo[i].studentName!;
                                  suggestionEmailList = [];
                                  suggestionEmailListLenght.value = 0;
                                  suggestionNameList = [];
                                  suggestionNameListLenght.value = 0;

                                  break;
                                }
                              }
                            } else {
                              idController.text = value;
                              isStudentIdFilled.value = value;
                              for (int i = 0;
                                  i < standardStudentDetails.length;
                                  i++) {
                                if (standardStudentDetails[i].studentId! ==
                                        value ||
                                    standardStudentDetails[i].email! == value) {
                                  nameController.text =
                                      standardStudentDetails[i].name!;
                                  isNameUpdated.value = !isNameUpdated.value;
                                  isStudentNameFilled.value =
                                      standardStudentDetails[i].name!;
                                  suggestionEmailList = [];
                                  suggestionEmailListLenght.value = 0;
                                  suggestionNameList = [];
                                  suggestionNameListLenght.value = 0;

                                  break;
                                }
                              }
                            }
                          }

                          //        _debouncer.run(() async {

                          //   setState(() {});
                          // });
                        }
                      },
                      selected: 1, // Select the second filter as default
                      filters: isNameList == true
                          ? suggestionNameList
                          : suggestionEmailList),
                );
        });
    //   : Container();
  }

  Widget gradedPlusSuccessScanResult(
      {required String id, required String grade}) {
    return Form(
      key: _formKey2,
      child: ListView(
        padding: EdgeInsets.symmetric(
            vertical: 0, horizontal: StudentPlusOverrides.kLabelSpacing / 2),
        children: [
          SpacerWidget(StudentPlusOverrides.KVerticalSpace / 4),
          SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
          Utility.textWidget(
              text: 'Student Name',
              context: context,
              textTheme: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryVariant
                      .withOpacity(0.3))),
          textFormField(
              scrollController: scrollControlledName,
              controller: nameController,
              inputFormatters: <TextInputFormatter>[
                //To capitalize first letter of the textfield
                UpperCaseTextFormatter()
              ],
              hintText: 'Student Name',
              isFailure: false,
              // errormsg: "Make sure to save the record with student name",
              onSaved: (String value) {
                studentNameOnSaveSuccess(value);
              },
              validator: (String? value) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  isStudentNameFilled.value = value!;
                });
                // isStudentNameFilled.value = value!;
              }),
          ValueListenableBuilder(
              valueListenable: isStudentNameFilled,
              child: Container(),
              builder: (BuildContext context, dynamic value, Widget? child) {
                if (isStudentNameFilled?.value?.isEmpty ?? true) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    suggestionNameListLenght.value = 0;
                  });
                }

                return nameController.text.length < 3
                    ? Container(
                        alignment: Alignment.centerLeft,
                        child: TranslationWidget(
                            message: Overrides.STANDALONE_GRADED_APP == true
                                ? (isStudentNameFilled.value == ""
                                    ? 'Student Name is required'
                                    : nameController.text.length < 3
                                        ? 'Make Sure The Student Name Contains More Than 3 Character'
                                        : '')
                                : isStudentNameFilled.value == ""
                                    ? 'If You Would Like To Save The Student Details In The Database, Please Enter The Student Name'
                                    : nameController.text.length < 3
                                        ? 'Make Sure The Student Name Contains More Than 3 Character'
                                        : '',
                            fromLanguage: "en",
                            toLanguage: Globals.selectedLanguage,
                            builder: (translatedMessage) {
                              return Text(
                                translatedMessage,
                                style: TextStyle(color: Colors.red),
                              );
                            }),
                      )
                    : Container();
              }),
          suggestionWidget(isNameList: true),
          SpacerWidget(_KVerticalSpace / 3),
          Utility.textWidget(
              text: Overrides.STANDALONE_GRADED_APP == true
                  ? 'Student Email'
                  : 'Student ID/Student Email',
              context: context,
              textTheme: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryVariant
                      .withOpacity(0.3))),
          ValueListenableBuilder(
              valueListenable: isStudentIdFilled,
              child: Container(),
              builder: (BuildContext context, dynamic value, Widget? child) {
                // return emailTextField();
                return Wrap(
                  children: [
                    textFormField(
                      scrollController: scrollControllerId,
                      controller: idController,
                      hintText: Overrides.STANDALONE_GRADED_APP == true
                          ? 'Student Email'
                          : 'Student ID/Email',
                      isFailure: true,
                      // errormsg:
                      //     "Student Id should not be empty, must start with '2' and contains a '9' digit number.",
                      onSaved: (String value) {
                        if (detectStudentIdChange == '') {
                          detectStudentIdChange = value;
                        }
                        initialCursorPositionAtLast = false;
                        studentIdOnSaveFailure(value, true);
                      },
                      validator: (String? value) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          isStudentIdFilled.value = value!;
                        });
                        //isStudentIdFilled.value = value!;
                        return Overrides.STANDALONE_GRADED_APP == true
                            ? isStudentIdFilled.value.isEmpty ||
                                    !regex.hasMatch(isStudentIdFilled.value)
                                ? ''
                                : null
                            : isStudentIdFilled.value.isEmpty
                                ? ''
                                : null;
                      },
                      inputFormatters: [],
                      maxNineDigit: Utility.checkForInt(idController.text)
                          ? true
                          : false, //true
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: TranslationWidget(
                          message: Overrides.STANDALONE_GRADED_APP == true
                              ? (idController.text == ''
                                  ? 'Student Email Is Required'
                                  : (!regex.hasMatch(idController.text))
                                      ? 'Please Enter valid Email'
                                      : '')
                              : idController.text.isEmpty
                                  ? 'Please Enter Valid Email ID or Student ID'
                                  : Utility.checkForInt(idController.text)
                                      ? (idController.text.length != 9
                                          ? 'Student Id should be 9 digit'
                                          : (idController.text[0] != '2' &&
                                                  idController.text[0] != '1'
                                              ? 'Student Id should be start for 1 or 2'
                                              : ''))
                                      : (!regex.hasMatch(idController.text))
                                          ? 'Please Enter valid Email'
                                          : '',

                          // (isStudentIdFilled.value == ""
                          //     ? 'Student ID/Email Is Required'
                          //     : ''),
                          fromLanguage: "en",
                          toLanguage: Globals.selectedLanguage,
                          builder: (translatedMessage) {
                            return Text(
                              translatedMessage,
                              style: TextStyle(color: Colors.red),
                            );
                          }),
                    ),
                  ],
                );
              }),
          suggestionWidget(isNameList: false),
          // SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
          Center(
            child: Utility.textWidget(
                text: widget.isMcqSheet == true
                    ? 'Student Selection'
                    : 'Points Earned',
                context: context,
                textTheme: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryVariant
                        .withOpacity(0.3))),
          ),
          SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
          pointsEarnedButton(
              widget.isMcqSheet == true ? grade : int.parse(grade),
              isSuccessState: true),
          SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
          Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.5,
              // color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Utility.textWidget(
                      text: widget.isMcqSheet == true
                          ? 'Successful Scan '
                          : 'All Good!',
                      context: context,
                      textTheme: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontWeight: FontWeight.bold)),
                  Icon(
                    IconData(0xe878,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    size: Globals.deviceType == 'phone' ? 24 : 34,
                    color: AppTheme.kButtonColor,
                  ),
                ],
              )),
          SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
          Center(child: imagePreviewWidget()),
          SpacerWidget(StudentPlusOverrides.kSymmetricPadding * 2),
        ],
        // ),
      ),
    );
  }

  void showCustomRubricImage() {
    showDialog(
        context: context,
        builder: (_) => ImagePopup(
              imageURL: '',
              isOcrPage: true,
              imageFile: widget.imgPath,
            ));
  }

  Widget imagePreviewWidget() {
    return InkWell(
      onTap: () {
        showCustomRubricImage();
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.width * 0.45,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.52),
          child: Image.file(
            widget.imgPath,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget pointsEarnedButton(dynamic grade, {required bool isSuccessState}) {
    return FittedBox(
      child: Container(
        alignment: Alignment.center,
        height: widget.isMcqSheet == true
            ? MediaQuery.of(context).size.height * 0.15
            : null,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: Globals.pointsEarnedList
              .map<Widget>((element) => pointsButton(
                  widget.isMcqSheet == true
                      ? element
                      : Globals.pointsEarnedList.indexOf(element),
                  grade,
                  isSuccessState: true))
              .toList(),
        ),
      ),
    );
  }

  Widget pointsButton(index, dynamic grade, {required bool isSuccessState}) {
    isSelected ? indexColor.value = grade : null;
    return ValueListenableBuilder(
        valueListenable: rubricNotDetected,
        builder: (BuildContext context, dynamic value, Widget? child) {
          return ValueListenableBuilder(
            valueListenable: indexColor,
            builder: (BuildContext context, dynamic value, Widget? child) {
              return Column(
                children: [
                  InkWell(
                      onTap: () {
                        // updateDetails(isUpdateData: true);
                        PlusUtility.updateLogs(
                            activityType: 'GRADED+',
                            userType: 'Teacher',
                            activityId: '8',
                            description:
                                'Teacher change score rubric \'${pointScored.value.toString()}\' to \'${index.toString()}\'',
                            operationResult: 'Success');
                        if (pointScored.value != index.toString()) {
                          isRubricChanged = true;
                          if (widget.isMcqSheet == true) {
                            PlusUtility.updateLogs(
                                activityType: 'GRADED+',
                                userType: 'Teacher',
                                activityId: '8',
                                description:
                                    'Answer Key changed from ${pointScored.value} to ${index.toString()}',
                                operationResult: 'Success');
                          }
                        }
                        pointScored.value = index.toString();
                        // if (isSuccessState) {}
                        isSelected = false;
                        rubricNotDetected.value = false;
                        indexColor.value = index;
                      },
                      child: AnimatedContainer(
                        duration: Duration(microseconds: 100),
                        padding: EdgeInsets.only(
                          bottom: 5,
                        ),
                        decoration: BoxDecoration(
                          color: widget.isMcqSheet == true
                              ? (index == widget.selectedAnswer &&
                                      indexColor.value == index
                                  ? Colors.green.shade300
                                  : indexColor.value == index
                                      ? rubricNotDetected.value == true &&
                                              isSelected == true
                                          ? Colors.red
                                          : Colors.red
                                      : Colors.grey)
                              : index == indexColor.value
                                  ? rubricNotDetected.value == true &&
                                          isSelected == true
                                      ? Colors.red
                                      : AppTheme.kSelectedColor
                                  : Colors.grey,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: Container(
                            alignment: Alignment.center,
                            height: //Globals.pointsEarnedList.length>3?
                                widget.isMcqSheet == true
                                    ? MediaQuery.of(context).size.height *
                                        //  0.085, //:MediaQuery.of(context).size.height*0.2,
                                        0.073
                                    : MediaQuery.of(context).size.height *
                                        0.085,
                            width:
                                //Globals.pointsEarnedList.length>3?
                                widget.isMcqSheet == true
                                    ? MediaQuery.of(context).size.width * 0.133
                                    : MediaQuery.of(context).size.width * 0.17,
                            //:MediaQuery.of(context).size.width*0.2,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical:
                                    10), //horizontal: Globals.pointsEarnedList.length>3?20:30
                            decoration: BoxDecoration(
                              color: Color(0xff000000) !=
                                      Theme.of(context).backgroundColor
                                  ? Color(0xffF7F8F9)
                                  : Color(0xff111C20),
                              border: Border.all(
                                color: widget.isMcqSheet == true
                                    ? (index == widget.selectedAnswer &&
                                            indexColor.value == index
                                        ? Colors.green.shade300
                                        : indexColor.value == index
                                            ? rubricNotDetected.value == true &&
                                                    isSelected == true
                                                ? Colors.red
                                                : Colors.red
                                            : Colors.grey)
                                    : index == indexColor.value
                                        ? rubricNotDetected.value == true &&
                                                isSelected == true
                                            ? Colors.red
                                            : AppTheme.kSelectedColor
                                        : Colors.grey,

                                // index == indexColor.value
                                //     ? rubricNotDetected.value == true &&
                                //             isSelected == true
                                //         ? Colors.red
                                //         : AppTheme.kSelectedColor
                                //     : Colors.grey,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: TranslationWidget(
                              message: widget.isMcqSheet == true
                                  ? index
                                  : Globals.pointsEarnedList[index].toString(),
                              toLanguage: Globals.selectedLanguage,
                              fromLanguage: "en",
                              builder: (translatedMessage) => Text(
                                translatedMessage.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: widget.isMcqSheet == true
                                            // ? (index == widget.selectedAnswer
                                            //     ? AppTheme.kButtonColor
                                            //     : indexColor.value == index
                                            //         ? rubricNotDetected.value ==
                                            //                     true &&
                                            //                 isSelected == true
                                            //             ? Colors.red
                                            //             : Colors
                                            //                 .red //AppTheme.kSelectedColor
                                            //         : Colors.grey)
                                            ? (index == widget.selectedAnswer &&
                                                    indexColor.value == index
                                                ? Colors.green.shade300
                                                : indexColor.value == index
                                                    ? rubricNotDetected.value ==
                                                                true &&
                                                            isSelected == true
                                                        ? Colors.red
                                                        : Colors.red
                                                    : Colors.grey)
                                            : (indexColor.value == index
                                                ? rubricNotDetected.value ==
                                                            true &&
                                                        isSelected == true
                                                    ? Colors.red
                                                    : AppTheme.kSelectedColor
                                                : Colors.grey)),
                              ),
                            )),
                      )),
                  //Compare Correct Answer Key
                  if (index == widget.selectedAnswer)
                    Expanded(
                        child: ScanResultMethods.animatedArrowWidget(
                            context: context, animation: _animation))
                ],
              );
            },
          );
        });
  }

  Widget textFormField({
    required TextEditingController controller,
    required onSaved,
    required validator,
    TextInputType? keyboardType,
    required bool? isFailure,
    String? errormsg,
    List<TextInputFormatter>? inputFormatters,
    bool? maxNineDigit,
    String? hintText,
    required ScrollController scrollController,
  }) {
    return ValueListenableBuilder(
        valueListenable: isNameUpdated,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return ValueListenableBuilder(
              valueListenable: isStudentNameFilled,
              child: Container(),
              builder: (BuildContext context, dynamic value, Widget? child) {
                if (controller.text.length != 0 &&
                    initialCursorPositionAtLast == true) {
                  //!=0
                  controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length));
                  // initialCursorPositionAtLast = false;
                }

                return TextFormField(
                    scrollController: scrollController,
                    maxLength: maxNineDigit == true &&
                            Overrides.STANDALONE_GRADED_APP == false
                        ? 9
                        : null,
                    // ? null
                    // Overrides.STANDALONE_GRADED_APP == true
                    //     ? null
                    //     : maxNineDigit == true
                    //         ? 9
                    //         : null,
                    inputFormatters:
                        inputFormatters == null ? null : inputFormatters,
                    autovalidateMode: AutovalidateMode.always,
                    keyboardType: keyboardType ?? null,
                    //        //textAlign: TextAlign.start,
                    style: Overrides.STANDALONE_GRADED_APP == true
                        ? Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(fontWeight: FontWeight.bold)
                        : Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(fontWeight: FontWeight.bold),
                    controller: controller,
                    cursorColor: Theme.of(context).colorScheme.primaryVariant,
                    decoration: InputDecoration(
                      counterStyle: TextStyle(
                          color: Color(0xff000000) ==
                                  Theme.of(context).backgroundColor
                              ? Color(0xffFFFFFF)
                              : Color(0xff000000)),
                      // errorText: controller.text.isEmpty ? errormsg : null,
                      hintText: hintText,
                      errorStyle: TextStyle(fontSize: 1),

                      hintStyle: Overrides.STANDALONE_GRADED_APP == true
                          ? Theme.of(context).textTheme.headline5!.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.grey)
                          : Theme.of(context).textTheme.headline6!.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                      // errorText: controller.text.isEmpty ? errormsg : null,
                      // errorMaxLines: 2,

                      contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                      fillColor: Colors.transparent,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: controller.text.isNotEmpty ||
                                    isStudentNameFilled.value.isNotEmpty
                                ? Theme.of(context)
                                    .colorScheme
                                    .primaryVariant
                                    .withOpacity(0.5)
                                : Colors.red),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: controller.text.isNotEmpty
                                ? Theme.of(context)
                                    .colorScheme
                                    .primaryVariant
                                    .withOpacity(0.5)
                                : Colors.red),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .primaryVariant
                              .withOpacity(0.5),
                        ),
                      ),
                    ),
                    onChanged: onSaved,
                    validator: validator);
              });
        });
  }

  Widget retryButton({required final onPressed}) {
    return GradedPlusCustomFloatingActionButton(
        isExtended: true,
        icon: Icon(Icons.refresh,
            color: Theme.of(context).backgroundColor,
            size: Globals.deviceType == 'phone' ? 28 : 40),
        title: 'Retry',
        onPressed: onPressed);
  }

  void updateDetails(
      {bool? isUpdateData,
      required bool? isFromHistoryAssessmentScanMore}) async {
    String? updatedStudentId;

    String? studentEmail;

    if (idController.text.contains('@')) {
      if (Overrides.STANDALONE_GRADED_APP == false) {
        studentEmail = idController.text;
      }

      updatedStudentId = ScanResultMethods.getIdFromEmail(
          studentEmailDetails: idController.text,
          standardStudentDetails: standardStudentDetails);
    } else {
      if (Overrides.STANDALONE_GRADED_APP == false) {
        studentEmail = ScanResultMethods.getEmailFromId(
            studentIdDetails: idController.text,
            standardStudentDetails: standardStudentDetails);
      }

      updatedStudentId = idController.text;
    }

    print(studentEmail);
    StudentAssessmentInfo studentAssessmentInfo = StudentAssessmentInfo();

    // To add the scan more result to the google file existing list
    if (isFromHistoryAssessmentScanMore == true) {
      LocalDatabase<StudentAssessmentInfo> _historyStudentInfoDb =
          LocalDatabase('history_student_info');
      @override
      List<StudentAssessmentInfo> historyStudentInfo =
          await _historyStudentInfoDb.getData();

      if (historyStudentInfo.length > 0 &&
          historyStudentInfo[0].studentId == "Id") {
        historyStudentInfo.remove(0);
      }

      if (isUpdateData == true && historyStudentInfo.isNotEmpty) {
        studentAssessmentInfo.studentName = nameController.text;
        studentAssessmentInfo.studentId =
            updatedStudentId; // commented to add id case of email //idController.text;
        studentAssessmentInfo.studentGrade = widget.isMcqSheet == true
            ? (widget.selectedAnswer == indexColor.value.toString() ? '1' : '0')
            : indexColor.value.toString(); //pointScored.value;
        // studentAssessmentInfo.pointPossible = Globals.pointPossible;
        studentAssessmentInfo.assessmentImgPath =
            widget.imgPath.path.toString();
        studentAssessmentInfo.answerKey =
            widget.isMcqSheet == true ? widget.selectedAnswer : 'NA';
        studentAssessmentInfo.studentResponseKey =
            widget.isMcqSheet == true ? indexColor.value.toString() : 'NA';
        studentAssessmentInfo.googleSlidePresentationURL = 'NA';
        studentAssessmentInfo.uniqueId = uniqueId;
        studentAssessmentInfo.isRubricChanged = isRubricChanged.toString();
        if (Overrides.STANDALONE_GRADED_APP == false) {
          studentAssessmentInfo.studentEmail = studentEmail ?? '';
        }

        //  if (!id.contains(idController.text)) {
        await _historyStudentInfoDb.putAt(
            historyStudentInfo.length - 1, studentAssessmentInfo);
        // }

        return;
      } else {
        if (historyStudentInfo.isNotEmpty) {
          List id = [];
          for (int i = 0; i < historyStudentInfo.length; i++) {
            if (!historyStudentInfo.contains(id)) {
              id.add(historyStudentInfo[i].studentId);
            } else {
              //print('Record is already exist in the list. Skipping...');
            }
          }
          if (!id.contains(updatedStudentId)) {
            // commented to add id case of email //idController.text;
            studentAssessmentInfo.studentName = nameController.text.isNotEmpty
                ? nameController.text
                : "Unknown";
            studentAssessmentInfo.studentId =
                updatedStudentId; // commented to add id case of email //idController.text;
            studentAssessmentInfo.studentGrade = widget.isMcqSheet == true
                ? (widget.selectedAnswer == indexColor.value.toString()
                    ? '1'
                    : '0')
                : indexColor.value.toString(); //pointScored.value;

            studentAssessmentInfo.assessmentImgPath =
                widget.imgPath.path.toString();
            studentAssessmentInfo.answerKey =
                widget.isMcqSheet == true ? widget.selectedAnswer : 'NA';
            studentAssessmentInfo.studentResponseKey =
                widget.isMcqSheet == true ? indexColor.value.toString() : 'NA';
            studentAssessmentInfo.googleSlidePresentationURL = 'NA';
            studentAssessmentInfo.uniqueId = uniqueId;
            studentAssessmentInfo.isRubricChanged = isRubricChanged.toString();
            studentAssessmentInfo.isScanMore = widget?.isScanMore ?? false;
            if (Overrides.STANDALONE_GRADED_APP == false) {
              studentAssessmentInfo.studentEmail = studentEmail ?? '';
            }

            if (!historyStudentInfo.contains(id)) {
              //   Globals.historyStudentInfo!.add(studentAssessmentInfo);
              List list = await _historyStudentInfoDb.getData();
              //print(list);
              await _historyStudentInfoDb.addData(studentAssessmentInfo);
            }
          }
        }
        return;
      }
    } else {
      List<StudentAssessmentInfo> studentInfo =
          await OcrUtility.getSortedStudentInfoList(tableName: 'student_info');

      if (studentInfo.length > 0 && studentInfo[0].studentId == "Id") {
        studentInfo.remove(0);
      }
      List id = [];
      for (int i = 0; i < studentInfo.length; i++) {
        if (!studentInfo.contains(id)) {
          //print('not contaains ----------------->');
          id.add(studentInfo[i].studentId);
        } else {
          //print('Record is already exist in the list. Skipping...');
        }
      }

      if (isUpdateData == true && studentInfo.isNotEmpty) {
        // final StudentAssessmentInfo studentAssessmentInfo =
        //     StudentAssessmentInfo();

        // if (!id.contains(updatedStudentId)) {
        studentAssessmentInfo.studentName = nameController.text;
        studentAssessmentInfo.studentId =
            updatedStudentId; // commented to add id case of email //idController.text;
        studentAssessmentInfo.studentGrade = widget.isMcqSheet == true
            ? (widget.selectedAnswer == indexColor.value.toString() ? '1' : '0')
            : indexColor.value.toString(); //ointScored.value;
        studentAssessmentInfo.pointPossible =
            Globals.pointPossible != null || Globals.pointPossible!.isNotEmpty
                ? Globals.pointPossible
                : '2';
        studentAssessmentInfo.assessmentImgPath =
            widget.imgPath.path.toString();
        studentAssessmentInfo.answerKey =
            widget.isMcqSheet == true ? widget.selectedAnswer : 'NA';
        studentAssessmentInfo.studentResponseKey =
            widget.isMcqSheet == true ? indexColor.value.toString() : 'NA';
        studentAssessmentInfo.googleSlidePresentationURL = 'NA';
        studentAssessmentInfo.uniqueId = uniqueId;
        studentAssessmentInfo.isRubricChanged = isRubricChanged.toString();
        studentAssessmentInfo.isScanMore = widget?.isScanMore ?? false;
        if (Overrides.STANDALONE_GRADED_APP == false) {
          studentAssessmentInfo.studentEmail = studentEmail ?? '';
        }

// To update/edit the scanned details
        await _studentInfoDb.putAt(
            studentInfo.length - 1, studentAssessmentInfo);
        return;
        // }
      } else {
        final StudentAssessmentInfo studentAssessmentInfo =
            StudentAssessmentInfo();
        if (studentInfo.isEmpty) {
          // final StudentAssessmentInfo studentAssessmentInfo =
          //     StudentAssessmentInfo();
          studentAssessmentInfo.studentName =
              nameController.text.isNotEmpty ? nameController.text : "Unknown";
          studentAssessmentInfo.studentId =
              updatedStudentId; // commented to add id case of email //idController.text;
          studentAssessmentInfo.studentGrade = widget.isMcqSheet == true
              ? (widget.selectedAnswer == indexColor.value.toString()
                  ? '1'
                  : '0')
              : indexColor.value.toString(); //pointScored.value;
          studentAssessmentInfo.pointPossible =
              Globals.pointPossible != null || Globals.pointPossible!.isNotEmpty
                  ? Globals.pointPossible
                  : '2';
          studentAssessmentInfo.assessmentImgPath =
              widget.imgPath.path.toString();
          studentAssessmentInfo.answerKey =
              widget.isMcqSheet == true ? widget.selectedAnswer : 'NA';
          studentAssessmentInfo.studentResponseKey =
              widget.isMcqSheet == true ? indexColor.value.toString() : 'NA';
          studentAssessmentInfo.googleSlidePresentationURL = 'NA';
          studentAssessmentInfo.uniqueId = uniqueId;
          studentAssessmentInfo.isRubricChanged = isRubricChanged.toString();
          studentAssessmentInfo.isScanMore = widget?.isScanMore ?? false;
          if (Overrides.STANDALONE_GRADED_APP == false) {
            studentAssessmentInfo.studentEmail = studentEmail ?? '';
          }

          // studentAssessmentInfo.assessmentName = Globals.assessmentName;
          await _studentInfoDb.addData(studentAssessmentInfo);
          return;
        } else {
          List id = [];
          for (int i = 0; i < studentInfo.length; i++) {
            if (!id.contains(id)) {
              //print('not contaains ----------------->');
              id.add(studentInfo[i].studentId);
            } else {
              //print('Record is already exist in the list. Skipping...');
            }
          }
          if (!id.contains(updatedStudentId)) {
            // commented to add id case of email //idController.text;
            studentAssessmentInfo.studentName = nameController.text.isNotEmpty
                ? nameController.text
                : "Unknown";
            studentAssessmentInfo.studentId =
                updatedStudentId; // commented to add id case of email //idController.text;
            studentAssessmentInfo.studentGrade = widget.isMcqSheet == true
                ? (widget.selectedAnswer == indexColor.value.toString()
                    ? '1'
                    : '0')
                : indexColor.value.toString(); //pointScored.value;
            studentAssessmentInfo.pointPossible =
                Globals.pointPossible != null ||
                        Globals.pointPossible!.isNotEmpty
                    ? Globals.pointPossible
                    : '2';
            studentAssessmentInfo.assessmentImgPath =
                widget.imgPath.path.toString();
            studentAssessmentInfo.answerKey =
                widget.isMcqSheet == true ? widget.selectedAnswer : 'NA';
            studentAssessmentInfo.studentResponseKey =
                widget.isMcqSheet == true ? indexColor.value.toString() : 'NA';
            studentAssessmentInfo.googleSlidePresentationURL = 'NA';
            studentAssessmentInfo.uniqueId = uniqueId;
            studentAssessmentInfo.isRubricChanged = isRubricChanged.toString();
            studentAssessmentInfo.isScanMore = widget?.isScanMore ?? false;
            if (Overrides.STANDALONE_GRADED_APP == false) {
              studentAssessmentInfo.studentEmail = studentEmail ?? '';
            }
            // studentAssessmentInfo.assessmentName = Globals.assessmentName;
            if (!studentInfo.contains(id)) {
              await _studentInfoDb.addData(studentAssessmentInfo);
            }
          }
          return;
        }
      }
    }
  }

  Future<void> _navigatetoCameraSection() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => GradedPlusCameraScreen(
                  titleIconData: widget.titleIconData,
                  assessmentName: widget.assessmentName,
                  lastAssessmentLength: widget.lastAssessmentLength,
                  isMcqSheet: widget.isMcqSheet,
                  selectedAnswer: widget.selectedAnswer,
                  questionImageLink: widget.questionImageUrl ?? '',
                  obj: widget.obj,
                  createdAsPremium: widget.createdAsPremium,
                  isFromHistoryAssessmentScanMore:
                      widget.isFromHistoryAssessmentScanMore!,
                  onlyForPicture: false,
                  isScanMore: widget.isScanMore,
                  pointPossible: widget.pointPossible,
                  isFlashOn: ValueNotifier<bool>(widget.isFlashOn),
                )));
    if (result == true) {
      isBackFromCamera.value = result;
      initialCursorPositionAtLast = true;
      // isStudentIdFilled.value = idController.text;
    }
  }

  void _performAnimation() {
    Timer(Duration(milliseconds: 50), () async {
      animationStart.value = true;
    });
  }

  Future<List<StudentDetailsModal>> updateStudentDetails() async {
    try {
      //  List<StudentDetailsModal> studentList = [];
      LocalDatabase<StudentDetailsModal> _localDb =
          LocalDatabase(Strings.studentDetailList);

      List<StudentDetailsModal>? _localData = await _localDb.getData();

      standardStudentDetails.clear();
      standardStudentDetails = _localData;
      return standardStudentDetails;
    } catch (e) {
      List<StudentDetailsModal> studentList = [];
      return studentList;
    }
  }

  studentIdOnSaveFailure(value, bool? isDetectionSuccess) {
    isStudentIdFilled.value = value;
    _formKey1.currentState!.validate();
    suggestionEmailList.clear();

    // updateDetails(isUpdateData: true);
    studentId = idController.text;
    if (idController.text.length == 9 &&
        (idController.text[0] == '2' ||
            idController.text[0] == '1' &&
                Overrides.STANDALONE_GRADED_APP != true)) {
      _bloc2.add(FetchStudentDetails(ossId: idController.text));
    }

    //List of suggestion emails for Standalone app
    if (Overrides.STANDALONE_GRADED_APP && value.isNotEmpty) {
      // suggestionEmailList = [];
      for (int i = 0; i < studentInfo.length; i++) {
        if (studentInfo[i]
                .studentEmail!
                .toUpperCase()
                .contains(value.toUpperCase()) &&
            !suggestionEmailList.contains(studentInfo[i].studentEmail!)) {
          suggestionEmailList.add(studentInfo[i].studentEmail!);
        }
      }

      if (regex.hasMatch(value)) {
        for (int i = 0; i < studentInfo.length; i++) {
          if (studentInfo[i].studentEmail! == value) {
            nameController.text = studentInfo[i].studentName!;
            isStudentNameFilled.value = studentInfo[i].studentName!;
            isNameUpdated.value = !isNameUpdated.value;
          }
        }
      }
    }

    //List of suggestion emails for Standard app
    else if (value.isNotEmpty) {
      // suggestionEmailList = [];
      for (int i = 0; i < standardStudentDetails.length; i++) {
        if ((standardStudentDetails[i]
                    .studentId!
                    .toUpperCase()
                    .contains(value.toUpperCase()) ||
                standardStudentDetails[i]
                    .email!
                    .toUpperCase()
                    .contains(value.toUpperCase())) &&
            !suggestionEmailList
                .contains(standardStudentDetails[i].studentId!)) {
          if (standardStudentDetails[i]
                  .email!
                  .toUpperCase()
                  .contains(value.toUpperCase()) &&
              standardStudentDetails[i].email! != '') {
            suggestionEmailList.add(standardStudentDetails[i].email!);
          } else if (standardStudentDetails[i]
              .studentId!
              .toUpperCase()
              .contains(value.toUpperCase())) {
            suggestionEmailList.add(standardStudentDetails[i].studentId!);
          }
        }
      }

      // //Assign the length of suggestion emails
      // suggestionEmailListLenght.value =
      //     suggestionEmailList.length;

      if (regex.hasMatch(value)) {
        for (int i = 0; i < standardStudentDetails.length; i++) {
          if (standardStudentDetails[i].name! == value) {
            nameController.text = standardStudentDetails[i].name!;
            isStudentNameFilled.value = standardStudentDetails[i].name!;
            isNameUpdated.value = !isNameUpdated.value;
          }
        }
      }
    } else {}
    //---------------------------------------------------------------
    //(Failure Case Check)||(Success Case Check)
    if ((isDetectionSuccess == false) ||
        (detectStudentIdChange != value && detectStudentIdChange != '')) {
      //update changed value and log the change
      detectStudentIdChange = value;

      //Every time when student id detection fails, user manually enter the student id
      PlusUtility.updateLogs(
          activityType: 'Graded+',
          userType: 'Teacher',
          activityId: '55',
          sessionId: Globals.sessionId,
          description: 'Student Id/Email Change',
          operationResult: 'Success');
    }
    //---------------------------------------------------------------
    // //Assign the length of suggestion emails
    suggestionEmailListLenght.value = suggestionEmailList.length;

    onChange = true;
  }

  studentNameOnSaveFailure(value) {
    isStudentNameFilled.value = value;
    suggestionNameList.clear();

    studentName = nameController.text;
    if (Overrides.STANDALONE_GRADED_APP && value.isNotEmpty) {
      for (int i = 0; i < studentInfo.length; i++) {
        if (studentInfo[i]
                .studentName!
                .toUpperCase()
                .contains(value.toUpperCase()) &&
            !suggestionNameList.contains(studentInfo[i].studentName!)) {
          suggestionNameList.add(studentInfo[i].studentName!);
        }
      }
      suggestionNameListLenght.value = suggestionNameList.length;
      if (value.length > 3) {
        for (int i = 0; i < studentInfo.length; i++) {
          if (studentInfo[i].studentName! == value) {
            idController.text = studentInfo[i].studentEmail!;
            isStudentIdFilled.value = studentInfo[i].studentEmail!;
          }
        }
      }
    } else if (value.isNotEmpty) {
      for (int i = 0; i < standardStudentDetails.length; i++) {
        if (standardStudentDetails[i]
                .name!
                .toUpperCase()
                .contains(value.toUpperCase()) &&
            !suggestionNameList.contains(standardStudentDetails[i].name!)) {
          suggestionNameList.add(standardStudentDetails[i].name!);
        }
      }
      suggestionNameListLenght.value = suggestionNameList.length;
      if (value.length > 3) {
        for (int i = 0; i < standardStudentDetails.length; i++) {
          if (standardStudentDetails[i].name! == value) {
            // idController.text = standardStudentDetails[i].name!;
            // isStudentIdFilled.value = standardStudentDetails[i].name!;
            idController.text = standardStudentDetails[i].studentId ?? '';
            isStudentIdFilled.value = standardStudentDetails[i].studentId ?? '';
          }
        }
      }
    } else {
      suggestionEmailListLenght.value = 0;
    }
    onChange = true;
  }

  studentIdOnSaveSuccess(value) {
    isStudentIdFilled.value = value;
    _formKey2.currentState!.validate();
    studentId = idController.text;
    suggestionEmailList.clear();

    if (idController.text.length == 9 &&
        (idController.text[0] == '2' || idController.text[0] == '1')) {
      _bloc2.add(FetchStudentDetails(ossId: idController.text));
    }
    if (Overrides.STANDALONE_GRADED_APP && value.isNotEmpty) {
      for (int i = 0; i < studentInfo.length; i++) {
        if (studentInfo[i]
                .studentEmail!
                .toUpperCase()
                .contains(value.toUpperCase()) &&
            !suggestionEmailList.contains(studentInfo[i].studentEmail!)) {
          suggestionEmailList.add(studentInfo[i].studentEmail!);
        }
      }
      suggestionEmailListLenght.value = suggestionEmailList.length;
      if (regex.hasMatch(value)) {
        for (int i = 0; i < studentInfo.length; i++) {
          if (studentInfo[i].studentEmail! == value) {
            nameController.text = studentInfo[i].studentName!;
            isStudentNameFilled.value = studentInfo[i].studentName!;
            isNameUpdated.value = !isNameUpdated.value;
          }
        }
      }
    } else if (value.isNotEmpty) {
      for (int i = 0; i < standardStudentDetails.length; i++) {
        if ((standardStudentDetails[i]
                    .studentId!
                    .toUpperCase()
                    .contains(value.toUpperCase()) ||
                standardStudentDetails[i]
                    .email!
                    .toUpperCase()
                    .contains(value.toUpperCase())) &&
            !suggestionEmailList
                .contains(standardStudentDetails[i].studentId!)) {
          if (standardStudentDetails[i]
                  .email!
                  .toUpperCase()
                  .contains(value.toUpperCase()) &&
              standardStudentDetails[i].email! != '') {
            suggestionEmailList.add(standardStudentDetails[i].email!);
          } else if (standardStudentDetails[i]
              .studentId!
              .toUpperCase()
              .contains(value.toUpperCase())) {
            suggestionEmailList.add(standardStudentDetails[i].studentId!);
          }
        }
      }
      suggestionEmailListLenght.value = suggestionEmailList.length;
      if (regex.hasMatch(value)) {
        for (int i = 0; i < standardStudentDetails.length; i++) {
          if (standardStudentDetails[i].name! == value) {
            nameController.text = standardStudentDetails[i].name!;
            isStudentNameFilled.value = standardStudentDetails[i].name!;
            isNameUpdated.value = !isNameUpdated.value;
          }
        }
      }
    } else {
      suggestionEmailList = [];
      suggestionEmailListLenght.value = 0;
    }

    //  updateDetails(isUpdateData: true);
    onChange = true;
  }

  studentNameOnSaveSuccess(String value) {
    isStudentNameFilled.value = value;
    _formKey2.currentState!.validate();
    value != '' ? valuechange = true : valuechange = false;
    suggestionNameList.clear();

    if (value.isEmpty) {
      // suggestionNameList.clear();
      suggestionEmailListLenght.value = 0;
    }

    studentName = nameController.text;
    if (Overrides.STANDALONE_GRADED_APP) {
      // suggestionNameList.clear();
      for (int i = 0; i < studentInfo.length; i++) {
        if (studentInfo[i]
                .studentName!
                .toUpperCase()
                .contains(value.toUpperCase()) &&
            !suggestionNameList.contains(studentInfo[i].studentName!)) {
          suggestionNameList.add(studentInfo[i].studentName!);
        }
      }
      suggestionNameListLenght.value = suggestionNameList.length;
      if (value.length > 3) {
        for (int i = 0; i < studentInfo.length; i++) {
          if (studentInfo[i].studentName! == value) {
            idController.text = studentInfo[i].studentEmail!;
            isStudentIdFilled.value = studentInfo[i].studentEmail!;
          }
        }
      }
    } else {
      for (int i = 0; i < standardStudentDetails.length; i++) {
        if (standardStudentDetails[i]
                .name!
                .toUpperCase()
                .contains(value.toUpperCase()) &&
            !suggestionNameList.contains(standardStudentDetails[i].name!)) {
          suggestionNameList.add(standardStudentDetails[i].name!);
        }
      }
      suggestionNameListLenght.value = suggestionNameList.length;
      if (value.length > 3) {
        for (int i = 0; i < standardStudentDetails.length; i++) {
          if (standardStudentDetails[i].name! == value) {
            idController.text = standardStudentDetails[i].email!;
            isStudentIdFilled.value = standardStudentDetails[i].email!;
          }
        }
      }
    }

    onChange = true;
  }
}
