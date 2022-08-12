import 'dart:async';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/google_drive/model/assessment.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/ocr/ui/camera_screen.dart';
import 'package:Soc/src/modules/ocr/widgets/animation_button.dart';
import 'package:Soc/src/modules/ocr/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/widgets/ocr_background_widget.dart';
import 'package:Soc/src/overrides.dart';
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

class SuccessScreen extends StatefulWidget {
  final String img64;
  final File imgPath;
  final String? pointPossible;
  final bool? isScanMore;
  final bool? isFromHistoryAssessmentScanMore;
  final bool? createdAsPremium;
  final HistoryAssessment? obj;
  final String? questionImageUrl;
  final bool isFlashOn;
  SuccessScreen(
      {Key? key,
      required this.img64,
      required this.imgPath,
      this.pointPossible,
      this.isScanMore,
      this.questionImageUrl,
      required this.isFromHistoryAssessmentScanMore,
      this.createdAsPremium,
      this.obj,
      required this.isFlashOn})
      : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  static const double _KVertcalSpace = 60.0;
  OcrBloc _bloc = OcrBloc();
  OcrBloc _bloc2 = OcrBloc();
  //bool failure = false;
  final ValueNotifier<bool> isSuccessResult = ValueNotifier<bool>(true);

  // bool rubricNotDetected = false;

  //int? indexColor;
  bool isSelected = true;
  bool onChange = false;
  String studentName = '';
  String studentId = '';
  late Timer? timer;
  final ValueNotifier<String> scanFailure = ValueNotifier<String>('');
  final ValueNotifier<int> indexColor = ValueNotifier<int>(2);
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
  // DateTime currentDateTime = DateTime.now(); //DateTime
  // // instance for maintaining logs
  // final OcrBloc _ocrBlocLogs = new OcrBloc();

  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);
  // final ValueNotifier<String> stu = ValueNotifier<String>('');

  GoogleDriveBloc _googleDriveBloc = GoogleDriveBloc();
  final ValueNotifier<String> pointScored = ValueNotifier<String>('2');

  final ValueNotifier<bool> animationStart = ValueNotifier<bool>(false);

  ScrollController scrollControlleName = new ScrollController();
  ScrollController scrollControllerId = new ScrollController();

  LocalDatabase<StudentAssessmentInfo> _studentInfoDb =
      LocalDatabase('student_info');

  void initState() {
    super.initState();
    _bloc.add(FetchTextFromImage(
        base64: widget.img64, pointPossible: widget.pointPossible ?? '2'));
  }

  @override
  void dispose() {
    scrollControlleName.dispose();
    scrollControllerId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(children: [
        CommonBackGroundImgWidget(),
        Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: CustomOcrAppBarWidget(
            isBackButton: false,
            isSuccessState: isSuccessResult,
            //isFailureState: failure,
            isHomeButtonPopup: true,
            isbackOnSuccess: isBackFromCamera,
            actionIcon:
                //  failure == true
                //     ?
                IconButton(
              onPressed: () async {
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
                  if (isStudentIdFilled.value.isNotEmpty &&
                      isStudentIdFilled.value.length == 9 &&
                      (isStudentIdFilled.value.startsWith('2') ||
                          isStudentIdFilled.value.startsWith('1'))) {
                    updateDetails(
                        isFromHistoryAssessmentScanMore:
                            widget.isFromHistoryAssessmentScanMore);

                    if (idController.text.isNotEmpty) {
                      _bloc.add(SaveStudentDetails(
                          studentName: nameController.text,
                          studentId: idController.text));
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
              },
              icon: Icon(
                IconData(0xe877,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                size: 30,
                color: AppTheme.kButtonColor,
              ),
            ),
            // : null,
            key: null,
          ),
          body: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: BlocConsumer<OcrBloc, OcrState>(
              bloc: _bloc, // provide the local bloc instance

              listener: (context, state) async {
                await Future.delayed(Duration(milliseconds: 200));
                if (state is OcrLoading) {
                  // isRetryButton.value = false;

                  Timer(Duration(seconds: 5), () {
                    isRetryButton.value = true;
                  });
                }
                if (state is FetchTextFromImageSuccess) {
                  //  scanFailure.value = 'Success';
                  // Future.delayed(Duration(milliseconds: 500));
                  scanFailure.value = 'Success';
                  _performAnimation();
                  Utility.updateLoges(
                      //  ,
                      activityId: '23',
                      description: 'Scan Assesment sheet successfully',
                      operationResult: 'Success');

                  widget.pointPossible == '2'
                      ? Globals.pointsEarnedList = [0, 1, 2]
                      : widget.pointPossible == '3'
                          ? Globals.pointsEarnedList = [0, 1, 2, 3]
                          : widget.pointPossible == '4'
                              ? Globals.pointsEarnedList = [0, 1, 2, 3, 4]
                              : Globals.pointsEarnedList.length = 2;
                  nameController.text =
                      isStudentNameFilled.value = state.studentName!;
                  onChange == false
                      ? idController.text = state.studentId!
                      : null;
                  pointScored.value = state.grade!;
                  //   reconizeText(pathOfImage);
                  // });

                  // if (_formKey2.currentState!.validate()) {
                  if (isStudentIdFilled.value.isNotEmpty &&
                      isStudentIdFilled.value.length == 9 &&
                      (isStudentIdFilled.value.startsWith('2') ||
                          isStudentIdFilled.value.startsWith('1'))) {
                    if (nameController.text.isNotEmpty &&
                        idController.text.isNotEmpty) {
                      timer = await Timer(Duration(seconds: 5), () async {
                        updateDetails(
                            isFromHistoryAssessmentScanMore:
                                widget.isFromHistoryAssessmentScanMore);
                        String imgExtension = widget.imgPath.path.substring(
                            widget.imgPath.path.lastIndexOf(".") + 1);
                        _googleDriveBloc.add(AssessmentImgToAwsBucked(
                            isHistoryAssessmentSection:
                                widget.isFromHistoryAssessmentScanMore,
                            imgBase64: widget.img64,
                            imgExtension: imgExtension,
                            studentId: idController.text));
                        // }
                        // COMMENT below section for enableing the camera

                        var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CameraScreen(
                                    questionImageLink:
                                        widget.questionImageUrl ?? '',
                                    obj: widget.obj,
                                    createdAsPremium: widget.createdAsPremium,
                                    isFromHistoryAssessmentScanMore:
                                        widget.isFromHistoryAssessmentScanMore!,
                                    onlyForPicture: false,
                                    isScanMore: widget.isScanMore,
                                    pointPossible: widget.pointPossible,
                                    flash: widget.isFlashOn,
                                  )),
                        );
                        if (result == true) {
                          isBackFromCamera.value = result;
                        }

                        //UNCOMMENT below section for enableing the camera

                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (_) => CameraScreen()));
                      });
                    }
                  } else {
                    // setState(() {
                    isSuccessResult.value = true;
                    // });
                  }
                } else if (state is FetchTextFromImageFailure) {
                  scanFailure.value = 'Failure';

                  // setState(() {
                  isSuccessResult.value = false;
                  // });
                  widget.pointPossible == '2'
                      ? Globals.pointsEarnedList = [0, 1, 2]
                      : widget.pointPossible == '3'
                          ? Globals.pointsEarnedList = [0, 1, 2, 3]
                          : widget.pointPossible == '4'
                              ? Globals.pointsEarnedList = [0, 1, 2, 3, 4]
                              : Globals.pointsEarnedList.length = 2;
                  if (state.grade == '') {
                    Utility.showSnackBar(_scaffoldKey,
                        'Could Not Detect The Right Score', context, null);
                  }

                  Utility.updateLoges(
                      // ,
                      activityId: '23',
                      description: state.grade == '' && state.studentId == ''
                          ? 'Unable to detect Student Id and grade'
                          : (state.grade == '' && state.studentId != '')
                              ? 'Unable to detect rubric score'
                              : (state.grade != '' && state.studentId == '')
                                  ? 'Unable to detect Student Id '
                                  : (state.grade != '' &&
                                          state.studentId != '' &&
                                          state.studentName == '')
                                      ? 'Unable to detect Student Name OR Student does not exist in the database'
                                      : 'Unable to fatch details(Scan Failure)',
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

                  // Center(
                  //   child: CircularProgressIndicator(
                  //     color: AppTheme.kButtonColor,
                  //   ),
                  // );
                } else if (state is FetchTextFromImageSuccess) {
                  nameController.text = state.studentName!;
                  widget.pointPossible == '2'
                      ? Globals.pointsEarnedList = [0, 1, 2]
                      : widget.pointPossible == '3'
                          ? Globals.pointsEarnedList = [0, 1, 2, 3]
                          : widget.pointPossible == '4'
                              ? Globals.pointsEarnedList = [0, 1, 2, 3, 4]
                              : Globals.pointsEarnedList.length = 2;
                  onChange == false
                      ? idController.text = state.studentId!
                      : null;
                  pointScored.value = state.grade!;
                  // idController.text = state.studentId!;
                  // nameController.text = state.studentName!;
                  // Globals.gradeList.add(state.grade!);

                  return successScreen(
                      id: state.studentId!, grade: state.grade!);
                } else if (state is FetchTextFromImageFailure) {
                  onChange == false
                      ? idController.text = state.studentId ?? ''
                      : state.studentId == ''
                          ? studentId
                          : null;
                  widget.pointPossible == '2'
                      ? Globals.pointsEarnedList = [0, 1, 2]
                      : widget.pointPossible == '3'
                          ? Globals.pointsEarnedList = [0, 1, 2, 3]
                          : widget.pointPossible == '4'
                              ? Globals.pointsEarnedList = [0, 1, 2, 3, 4]
                              : Globals.pointsEarnedList.length = 2;
                  onChange == false
                      ? nameController.text = state.studentName ?? ''
                      : null;
                  pointScored.value = state.grade!;
                  // idController.text = state.studentId!;
                  // nameController.text =
                  //     onChange == true ? state.studentName! : studentName;
                  // Globals.gradeList.add(state.grade!);
                  if (state.grade == '') {
                    rubricNotDetected.value = true;
                  }

                  return failureScreen(
                      id: state.studentId!, grade: state.grade!);
                }
                return Container();
                // return widget here based on BlocA's state
              },
            ),
          ),
          floatingActionButton: ValueListenableBuilder(
              valueListenable: scanFailure,
              child: Container(),
              builder: (BuildContext context, dynamic value, Widget? child) {
                return scanFailure.value == "Failure"
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: retryButton(
                          onPressed: () {
                            Utility.updateLoges(
                                // ,
                                activityId: '9',
                                description:
                                    'Scan Failure and teacher retry scan',
                                operationResult: 'Failure');

                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => CameraScreen(
                            //             questionImageLink:
                            //                 widget.questionImageUrl ?? '',
                            //             obj: widget.obj,
                            //             createdAsPremium:
                            //                 widget.createdAsPremium,
                            //             isFromHistoryAssessmentScanMore: widget
                            //                 .isFromHistoryAssessmentScanMore!,
                            //             onlyForPicture: false,
                            //             isScanMore: widget.isScanMore,
                            //             pointPossible: widget.pointPossible,
                            //           )),
                            // );
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.of(context).pop(widget.isFlashOn);
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => CameraScreen(
                            //             isFromHistoryAssessmentScanMore: widget
                            //                 .isFromHistoryAssessmentScanMore!,
                            //             onlyForPicture: false,
                            //             isScanMore: widget.isScanMore,
                            //             pointPossible: widget.pointPossible,
                            //           )),
                            // );
                          },
                        ))
                    : scanFailure.value == "Success"
                        ? ValueListenableBuilder(
                            valueListenable: isBackFromCamera,
                            child: Container(),
                            builder: (BuildContext context, dynamic value,
                                Widget? child) {
                              return isBackFromCamera.value != true
                                  ? Align(
                                      alignment: Alignment.bottomCenter,
                                      child:
                                          //  SuccessCustomButton(
                                          //   width: MediaQuery.of(context).size.width * 0.3,
                                          //   animatedWidth:
                                          //       MediaQuery.of(context).size.width * 0.3,
                                          //   // animatedWidth: animatedWidth.value
                                          // )
                                          ValueListenableBuilder(
                                              valueListenable: animationStart,
                                              child: Container(),
                                              builder: (BuildContext context,
                                                  dynamic value,
                                                  Widget? child) {
                                                return InkWell(
                                                  onTap: () async {
                                                    if (animationStart.value ==
                                                        true) {
                                                      timer!.cancel();

                                                      updateDetails(
                                                          isFromHistoryAssessmentScanMore:
                                                              widget
                                                                  .isFromHistoryAssessmentScanMore);
                                                      Utility.updateLoges(
                                                          //  ,
                                                          activityId: '10',
                                                          description:
                                                              'Next Scan',
                                                          operationResult:
                                                              'Success');

                                                      String imgExtension = widget
                                                          .imgPath.path
                                                          .substring(widget
                                                                  .imgPath.path
                                                                  .lastIndexOf(
                                                                      ".") +
                                                              1);
                                                      _googleDriveBloc.add(
                                                          AssessmentImgToAwsBucked(
                                                              isHistoryAssessmentSection:
                                                                  widget
                                                                      .isFromHistoryAssessmentScanMore,
                                                              imgBase64:
                                                                  widget.img64,
                                                              imgExtension:
                                                                  imgExtension,
                                                              studentId:
                                                                  idController
                                                                      .text));
                                                      // }
                                                      // COMMENT below section for enableing the camera
                                                      var result =
                                                          await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                CameraScreen(
                                                                  questionImageLink:
                                                                      widget.questionImageUrl ??
                                                                          '',
                                                                  obj: widget
                                                                      .obj,
                                                                  createdAsPremium:
                                                                      widget
                                                                          .createdAsPremium,
                                                                  isFromHistoryAssessmentScanMore:
                                                                      widget
                                                                          .isFromHistoryAssessmentScanMore!,
                                                                  onlyForPicture:
                                                                      false,
                                                                  isScanMore: widget
                                                                      .isScanMore,
                                                                  pointPossible:
                                                                      widget
                                                                          .pointPossible,
                                                                  flash: widget
                                                                      .isFlashOn,
                                                                )),
                                                      );
                                                      if (result == true) {
                                                        isBackFromCamera.value =
                                                            result;
                                                      }

                                                      // Navigator.pushReplacement(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //       builder: (context) =>
                                                      //           CameraScreen(
                                                      //             isScanMore:
                                                      //                 widget.isScanMore,
                                                      //             pointPossible: widget
                                                      //                 .pointPossible,
                                                      //           )),
                                                      // );
                                                    } else {
                                                      print(
                                                          "Not -------------> move");
                                                    }
                                                  },
                                                  child: SuccessCustomButton(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.055,
                                                      animationDuration:
                                                          Duration(
                                                              milliseconds:
                                                                  4950),
                                                      animationStart:
                                                          animationStart.value),
                                                );
                                              }),
                                    )
                                  : Container();
                            })
                        : Container();
              }),
          // retryButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        )
      ]),
    );
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

                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => CameraScreen(
                        //             isFromHistoryAssessmentScanMore:
                        //                 widget.isFromHistoryAssessmentScanMore!,
                        //             onlyForPicture: false,
                        //             isScanMore: widget.isScanMore,
                        //             pointPossible: widget.pointPossible,
                        //           )),
                        // );
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Form(
        key: _formKey1,
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
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
            SpacerWidget(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Utility.textWidget(
                    text: 'Manual Entry',
                    context: context,
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 5.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffCF6679),
                  ),
                  child: Icon(
                      IconData(0xe838,
                          fontFamily: Overrides.kFontFam,
                          fontPackage: Overrides.kFontPkg),
                      size: 19,
                      color: Colors.white),
                ),
              ],
            ),

            SpacerWidget(_KVertcalSpace * 0.25),
            Utility.textWidget(
                text: 'Student Name',
                context: context,
                textTheme: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryVariant
                        .withOpacity(0.5))),

            //                 ValueListenableBuilder(
            // valueListenable: isStudentNameFilled,
            // builder: (BuildContext context, dynamic value, Widget? child) {
            //   print(isStudentNameFilled.value);
            //   return
            textFormField(
                scrollController: scrollControlleName,
                controller: nameController,
                hintText: 'Student Name',
                inputFormatters: <TextInputFormatter>[
                  //To capitalize first letter of the textfield
                  UpperCaseTextFormatter()
                ],
                // keyboardType: TextInputType.,
                isFailure: true,
                // errormsg:
                //     "If you would like to save the student in database, Please enter the student name",
                onSaved: (String value) {
                  isStudentNameFilled.value = value;
                  // _formKey1.currentState!.validate();
                  // value != '' ? valuechange = true : valuechange = false;
                  //  updateDetails(isUpdateData: true);
                  studentName = nameController.text;
                  onChange = true;
                },
                validator: (String? value) {
                  isStudentNameFilled.value = value!; //nameController.text;

                  return isStudentNameFilled.value.isEmpty ||
                          isStudentNameFilled.value.length < 3
                      ? ''
                      : null;
                }),

            ValueListenableBuilder(
                valueListenable: isStudentNameFilled,
                child: Container(),
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return Container(
                    // padding: null,
                    alignment: Alignment.centerLeft,
                    child: TranslationWidget(
                        message: isStudentNameFilled.value == ""
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
                  );
                }),
            //       ;},
            //   child: Container(),
            // ),
            SpacerWidget(_KVertcalSpace / 2),
            Utility.textWidget(
                text: 'Student ID',
                context: context,
                textTheme: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryVariant
                        .withOpacity(0.5))),

            ValueListenableBuilder(
                valueListenable: isStudentIdFilled,
                child: Container(),
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return Wrap(
                    children: [
                      textFormField(
                          scrollController: scrollControllerId,
                          controller: idController,
                          keyboardType: TextInputType.number,
                          hintText: 'Student ID',
                          isFailure: true,
                          // errormsg:
                          //     "Student Id should not be empty, must start with '2' and contains a '9' digit number.",
                          onSaved: (String value) {
                            isStudentIdFilled.value = value;
                            _formKey1.currentState!.validate();
                            // updateDetails(isUpdateData: true);
                            studentId = idController.text;
                            if (idController.text.length == 9 &&
                                (idController.text[0] == '2' ||
                                    idController.text[0] == '1')) {
                              _bloc2.add(FetchStudentDetails(
                                  ossId: idController.text));
                            }
                            onChange = true;
                          },
                          validator: (String? value) {
                            isStudentIdFilled.value = value!;
                            return (!isStudentIdFilled.value.startsWith('2') &&
                                        !isStudentIdFilled.value
                                            .startsWith('1')) ||
                                    isStudentIdFilled.value.length < 9
                                ? ''
                                : null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            // FilteringTextInputFormatter.allow(
                            //     RegExp("[0-9]")),
                          ],
                          maxNineDigit: true),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: TranslationWidget(
                            message: isStudentIdFilled.value == ""
                                ? 'Student ID is required'
                                : isStudentIdFilled.value.length != 9
                                    ? 'Student ID Must Have 9 Digits Number'
                                    : !isStudentIdFilled.value
                                                .startsWith('2') &&
                                            !isStudentIdFilled.value
                                                .startsWith('1')
                                        ? 'Student ID Must Starts Either With \'2\' Or \'1\''
                                        : '',
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
            SpacerWidget(_KVertcalSpace / 2),
            Center(
              child: Utility.textWidget(
                  textAlign: TextAlign.center,
                  text: 'Points Earned',
                  context: context,
                  textTheme: Theme.of(context).textTheme.headline2!.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryVariant
                          .withOpacity(0.5))),
            ),
            SpacerWidget(_KVertcalSpace / 4),
            Center(
                child: pointsEarnedButton(grade == '' ? 2 : int.parse(grade),
                    isSuccessState: false)),
            SpacerWidget(_KVertcalSpace / 2),
            Center(child: imagePreviewWidget()),
            SpacerWidget(_KVertcalSpace / 0.9),
            SpacerWidget(_KVertcalSpace / 1.5),
          ],
        ),
      ),
    );
  }

  Widget successScreen({required String id, required String grade}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Form(
        key: _formKey2,
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  SpacerWidget(_KVertcalSpace / 5),
            SpacerWidget(_KVertcalSpace * 0.25),
            Utility.textWidget(
                text: 'Student Name',
                context: context,
                textTheme: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryVariant
                        .withOpacity(0.3))),
            textFormField(
                scrollController: scrollControlleName,
                controller: nameController,
                inputFormatters: <TextInputFormatter>[
                  //To capitalize first letter of the textfield
                  UpperCaseTextFormatter()
                ],
                hintText: 'Student Name',
                isFailure: false,
                // errormsg: "Make sure to save the record with student name",
                onSaved: (String value) {
                  isStudentNameFilled.value = value;
                  _formKey2.currentState!.validate();
                  value != '' ? valuechange = true : valuechange = false;

                  //updateDetails(isUpdateData: true);
                  onChange = true;
                },
                validator: (String? value) {
                  isStudentNameFilled.value = value!;
                  // return null;
                  // if (value!.isEmpty) {
                  //   return 'If You Would Like To Save The Student Details In The Database, Please Enter The Student Name';
                  // } else if (value.length < 3) {
                  //   return 'Make Sure The Student Name Contains More Than 3 Characters';
                  // } else {
                  //   return null;
                  // }
                }),
            ValueListenableBuilder(
                valueListenable: isStudentNameFilled,
                child: Container(),
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: TranslationWidget(
                        message: isStudentNameFilled.value == ""
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
                  );
                }),
            SpacerWidget(_KVertcalSpace / 2),
            Utility.textWidget(
                text: 'Student Id',
                context: context,
                textTheme: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryVariant
                        .withOpacity(0.5))),
            textFormField(
              scrollController: scrollControllerId,
              maxNineDigit: true,
              controller: idController,
              keyboardType: TextInputType.number,
              hintText: 'Student Id',
              // errormsg:
              //     "Student Id should not be empty, must start with '2' and contains a '9' digit number.",
              isFailure: false,
              onSaved: (String value) {
                isStudentIdFilled.value = value;
                _formKey2.currentState!.validate();
                //  updateDetails(isUpdateData: true);
                onChange = true;
              },
              validator: (String? value) {
                isStudentIdFilled.value = value!;
                // return null;
                // if (value!.isEmpty) {
                //   return "Student Id Should Not Be Empty, Must Starts With '2' And Contains '9' digits Number";
                // } else if (value.length != 9) {
                //   return 'Student ID Must Have 9 Digits Number';
                // } else if (!value.startsWith('2') && !value.startsWith('1')) {
                //   return 'Student ID Must Starts With \'2\'';
                // } else {
                //   return null;
                // }
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.allow(
                    RegExp("[a-z A-Z á-ú Á-Ú 0-9 ]")),
              ],
            ),
            ValueListenableBuilder(
                valueListenable: isStudentIdFilled,
                child: Container(),
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: TranslationWidget(
                        message: isStudentIdFilled.value == ""
                            ? 'Student ID is required'
                            : isStudentIdFilled.value.length != 9
                                ? 'Student ID Must Have 9 Digits Number'
                                : !isStudentIdFilled.value.startsWith('2') &&
                                        !isStudentIdFilled.value.startsWith('1')
                                    ? 'Student ID Must Starts Either With \'2\' Or \'1\''
                                    : '',
                        fromLanguage: "en",
                        toLanguage: Globals.selectedLanguage,
                        builder: (translatedMessage) {
                          return Text(
                            translatedMessage,
                            style: TextStyle(color: Colors.red),
                          );
                        }),
                  );
                }),
            SpacerWidget(_KVertcalSpace / 2),
            Center(
              child: Utility.textWidget(
                  text: 'Points Earned',
                  context: context,
                  textTheme: Theme.of(context).textTheme.headline2!.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryVariant
                          .withOpacity(0.5))),
            ),
            SpacerWidget(_KVertcalSpace / 4),
            Center(
                child:
                    pointsEarnedButton(int.parse(grade), isSuccessState: true)),
            SpacerWidget(_KVertcalSpace / 2),
            Center(child: imagePreviewWidget()),
            SpacerWidget(_KVertcalSpace / 2.8),
            Center(
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  // color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Utility.textWidget(
                          text: 'All Good!',
                          context: context,
                          textTheme: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(fontWeight: FontWeight.bold)),
                      Icon(
                        IconData(0xe878,
                            fontFamily: Overrides.kFontFam,
                            fontPackage: Overrides.kFontPkg),
                        size: 34,
                        color: AppTheme.kButtonColor,
                      ),
                    ],
                  )),
            ),
            SpacerWidget(MediaQuery.of(context).size.height * 0.15),
          ],
          // ),
        ),
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
        height: MediaQuery.of(context).size.height * 0.30,
        width: MediaQuery.of(context).size.width * 0.58,
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

  Widget pointsEarnedButton(int grade, {required bool isSuccessState}) {
    return FittedBox(
      child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          child: Globals.pointsEarnedList.length > 4
              ? ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                        child: pointsButton(index, grade,
                            isSuccessState: isSuccessState));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 12,
                    );
                  },
                  itemCount: Globals.pointsEarnedList.length)
              : Row(
                  // scrollDirection: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: Globals.pointsEarnedList
                      .map<Widget>((element) => pointsButton(
                          Globals.pointsEarnedList.indexOf(element), grade,
                          isSuccessState: true))
                      .toList(),
                )),
    );
  }

  Widget pointsButton(index, int grade, {required bool isSuccessState}) {
    isSelected ? indexColor.value = grade : null;
    return ValueListenableBuilder(
        valueListenable: rubricNotDetected,
        builder: (BuildContext context, dynamic value, Widget? child) {
          return ValueListenableBuilder(
            valueListenable: indexColor,
            builder: (BuildContext context, dynamic value, Widget? child) {
              return InkWell(
                  onTap: () {
                    // updateDetails(isUpdateData: true);
                    Utility.updateLoges(
                        // ,
                        activityId: '8',
                        description:
                            'Teacher change score rubric \'${pointScored.value.toString()}\' to \'${index.toString()}\'',
                        operationResult: 'Success');
                    pointScored.value = index.toString();
                    // if (isSuccessState) {}
                    isSelected = false;
                    rubricNotDetected.value = false;
                    indexColor.value = index;
                    // updateDetails(isUpdateData: true);

                    // nameController.text = studentName;
                    // idController.text = studentId;
                    //.text = studentId;
                  },
                  child: AnimatedContainer(
                    duration: Duration(microseconds: 100),
                    padding: EdgeInsets.only(
                      bottom: 5,
                    ),
                    decoration: BoxDecoration(
                      color: index == indexColor.value
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
                            MediaQuery.of(context).size.height *
                                0.085, //:MediaQuery.of(context).size.height*0.2,
                        width:
                            //Globals.pointsEarnedList.length>3?
                            MediaQuery.of(context).size.width * 0.17,
                        //:MediaQuery.of(context).size.width*0.2,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical:
                                20), //horizontal: Globals.pointsEarnedList.length>3?20:30
                        decoration: BoxDecoration(
                          color: Color(0xff000000) !=
                                  Theme.of(context).backgroundColor
                              ? Color(0xffF7F8F9)
                              : Color(0xff111C20),
                          border: Border.all(
                            color: index == indexColor.value
                                ? rubricNotDetected.value == true &&
                                        isSelected == true
                                    ? Colors.red
                                    : AppTheme.kSelectedColor
                                : Colors.grey,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: TranslationWidget(
                          message: Globals.pointsEarnedList[index].toString(),
                          toLanguage: Globals.selectedLanguage,
                          fromLanguage: "en",
                          builder: (translatedMessage) => Text(
                            translatedMessage.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(
                                    color: indexColor.value == index
                                        ? rubricNotDetected.value == true &&
                                                isSelected == true
                                            ? Colors.red
                                            : AppTheme.kSelectedColor
                                        : Colors.grey),
                          ),
                        )),
                  ));
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
                // controller.selection = TextSelection.fromPosition(
                //     TextPosition(offset: controller.text.length));
                return TextFormField(
                    scrollController: scrollController,
                    maxLength: maxNineDigit == true ? 9 : null,
                    inputFormatters:
                        inputFormatters == null ? null : inputFormatters,
                    autovalidateMode: AutovalidateMode.always,
                    keyboardType: keyboardType ?? null,
                    //        //textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
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

                      hintStyle: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(
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
    return InkWell(
      onTap: onPressed,
      child: FittedBox(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppTheme.kButtonColor,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          height: MediaQuery.of(context).size.height * 0.055,
          // width: Globals.deviceType=='phone'? MediaQuery.of(context).size.width * 0.3: MediaQuery.of(context).size.width * 0.2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.refresh,
                  color: Theme.of(context).backgroundColor,
                  size: Globals.deviceType == 'phone' ? 28 : 40),
              SizedBox(width: 5),
              Center(
                child: Utility.textWidget(
                  text: 'Retry',
                  context: context,
                  textTheme: Theme.of(context).textTheme.headline1!.copyWith(
                        color: Theme.of(context).backgroundColor,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateDetails(
      {bool? isUpdateData,
      required bool? isFromHistoryAssessmentScanMore}) async {
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
        studentAssessmentInfo.studentId = idController.text;
        studentAssessmentInfo.studentGrade =
            indexColor.value.toString(); //pointScored.value;
        // studentAssessmentInfo.pointpossible = Globals.pointpossible;
        studentAssessmentInfo.assessmentImgPath =
            widget.imgPath.path.toString();

        await _historyStudentInfoDb.putAt(
            historyStudentInfo.length - 1, studentAssessmentInfo);
        return;
      } else {
        // StudentAssessmentInfo studentAssessmentInfo =
        //         StudentAssessmentInfo();
        // if (historyStudentInfo.isEmpty) {
        //   // final StudentAssessmentInfo studentAssessmentInfo =
        //   //     StudentAssessmentInfo();
        //   studentAssessmentInfo.studentName =
        //       nameController.text.isNotEmpty ? nameController.text : "Unknown";
        //   studentAssessmentInfo.studentId = idController.text;
        //   studentAssessmentInfo.studentGrade = pointScored.value;
        //   studentAssessmentInfo.pointpossible = Globals.pointpossible ?? '2';
        //   studentAssessmentInfo.assessmentImgPath = widget.imgPath.toString();
        //   // studentAssessmentInfo.assessmentName = Globals.assessmentName;
        //   await _historyStudentInfoDb.addData(studentAssessmentInfo);
        // } else
        if (historyStudentInfo.isNotEmpty) {
          List id = [];
          for (int i = 0; i < historyStudentInfo.length; i++) {
            if (!historyStudentInfo.contains(id)) {
              id.add(historyStudentInfo[i].studentId);
            } else {
              print('Record is already exist in the list. Skipping...');
            }
          }
          if (!id.contains(idController.text)) {
            // StudentAssessmentInfo studentAssessmentInfo =
            //     StudentAssessmentInfo();
            studentAssessmentInfo.studentName = nameController.text.isNotEmpty
                ? nameController.text
                : "Unknown";
            studentAssessmentInfo.studentId = idController.text;
            studentAssessmentInfo.studentGrade =
                indexColor.value.toString(); //pointScored.value;
            // studentAssessmentInfo.pointpossible = Globals.pointpossible;
            studentAssessmentInfo.assessmentImgPath =
                widget.imgPath.path.toString();
            // studentAssessmentInfo.assessmentName = Globals.assessmentName;
            if (!historyStudentInfo.contains(id)) {
              //   Globals.historyStudentInfo!.add(studentAssessmentInfo);
              List list = await _historyStudentInfoDb.getData();
              print(list);
              await _historyStudentInfoDb.addData(studentAssessmentInfo);
            }
          }
        }
        return;
      }
    } else {
      List<StudentAssessmentInfo> studentInfo =
          await Utility.getStudentInfoList(tableName: 'student_info');

      if (studentInfo.length > 0 && studentInfo[0].studentId == "Id") {
        studentInfo.remove(0);
      }

      if (isUpdateData == true && studentInfo.isNotEmpty) {
        // final StudentAssessmentInfo studentAssessmentInfo =
        //     StudentAssessmentInfo();
        studentAssessmentInfo.studentName = nameController.text;
        studentAssessmentInfo.studentId = idController.text;
        studentAssessmentInfo.studentGrade =
            indexColor.value.toString(); //pointScored.value;
        studentAssessmentInfo.pointpossible =
            Globals.pointpossible != null || Globals.pointpossible!.isNotEmpty
                ? Globals.pointpossible
                : '2';
        studentAssessmentInfo.assessmentImgPath =
            widget.imgPath.path.toString();
// To update/edit the scanned details
        await _studentInfoDb.putAt(
            studentInfo.length - 1, studentAssessmentInfo);
        return;
      } else {
        final StudentAssessmentInfo studentAssessmentInfo =
            StudentAssessmentInfo();
        if (studentInfo.isEmpty) {
          // final StudentAssessmentInfo studentAssessmentInfo =
          //     StudentAssessmentInfo();
          studentAssessmentInfo.studentName =
              nameController.text.isNotEmpty ? nameController.text : "Unknown";
          studentAssessmentInfo.studentId = idController.text;
          studentAssessmentInfo.studentGrade =
              indexColor.value.toString(); //pointScored.value;
          studentAssessmentInfo.pointpossible =
              Globals.pointpossible != null || Globals.pointpossible!.isNotEmpty
                  ? Globals.pointpossible
                  : '2';
          studentAssessmentInfo.assessmentImgPath =
              widget.imgPath.path.toString();
          // studentAssessmentInfo.assessmentName = Globals.assessmentName;
          await _studentInfoDb.addData(studentAssessmentInfo);
          return;
        } else {
          List id = [];
          for (int i = 0; i < studentInfo.length; i++) {
            if (!studentInfo.contains(id)) {
              print('not contaains ----------------->');
              id.add(studentInfo[i].studentId);
            } else {
              print('Record is already exist in the list. Skipping...');
            }
          }
          if (!id.contains(idController.text)) {
            studentAssessmentInfo.studentName = nameController.text.isNotEmpty
                ? nameController.text
                : "Unknown";
            studentAssessmentInfo.studentId = idController.text;
            studentAssessmentInfo.studentGrade =
                indexColor.value.toString(); //pointScored.value;
            studentAssessmentInfo.pointpossible =
                Globals.pointpossible != null ||
                        Globals.pointpossible!.isNotEmpty
                    ? Globals.pointpossible
                    : '2';
            studentAssessmentInfo.assessmentImgPath =
                widget.imgPath.path.toString();
            // studentAssessmentInfo.assessmentName = Globals.assessmentName;
            if (!studentInfo.contains(id)) {
              print('added in record ----------------->>>>');
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
            builder: (_) => CameraScreen(
                  questionImageLink: widget.questionImageUrl ?? '',
                  obj: widget.obj,
                  createdAsPremium: widget.createdAsPremium,
                  isFromHistoryAssessmentScanMore:
                      widget.isFromHistoryAssessmentScanMore!,
                  onlyForPicture: false,
                  isScanMore: widget.isScanMore,
                  pointPossible: widget.pointPossible,
                  flash: widget.isFlashOn,
                )));
    if (result == true) {
      isBackFromCamera.value = result;
    }
  }

  void _performAnimation() {
    Timer(Duration(milliseconds: 50), () async {
      animationStart.value = true;
    });
  }
}
