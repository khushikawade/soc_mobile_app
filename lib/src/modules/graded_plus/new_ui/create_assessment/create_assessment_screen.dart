import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/services/google_classroom_globals.dart';
import 'package:Soc/src/modules/google_classroom/modal/google_classroom_courses.dart';
import 'package:Soc/src/modules/graded_plus/bloc/graded_plus_bloc.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_overrides.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_plus_utilty.dart';
import 'package:Soc/src/modules/graded_plus/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/create_assessment/create_assessment_method.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/camera_screen.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/subject_selection_screen.dart';
import 'package:Soc/src/modules/graded_plus/ui/state_selection_page.dart';
import 'package:Soc/src/modules/graded_plus/widgets/Common_popup.dart';
import 'package:Soc/src/modules/graded_plus/widgets/bottom_sheet_widget.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/bouncing_widget.dart';
import 'package:Soc/src/widgets/image_popup.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../services/firstLetterUpperCase.dart';
import '../../../google_classroom/bloc/google_classroom_bloc.dart';
import '../../widgets/student_popup.dart';
import '../../widgets/suggestion_chip.dart';

class GradedPlusCreateAssessment extends StatefulWidget {
  GradedPlusCreateAssessment({
    Key? key,
    required this.classSuggestions,
    required this.customGrades,
    this.isMcqSheet,
    required this.selectedAnswer,
    // required this.classroomSuggestions
  }) : super(key: key);
  final List<String> classSuggestions;
  final List<String> customGrades;
  final bool? isMcqSheet;
  final String? selectedAnswer;
  // final List<String> classroomSuggestions;
  @override
  State<GradedPlusCreateAssessment> createState() => _CreateAssessmentState();
}

class _CreateAssessmentState extends State<GradedPlusCreateAssessment>
    with SingleTickerProviderStateMixin {
//--------------------------------------------------------------------------------------------------------

  final GlobalKey<NonCourseGoogleClassroomStudentPopupState> _dialogKey =
      GlobalKey<NonCourseGoogleClassroomStudentPopupState>();
  ScrollController scrollControllerAssessmentName = new ScrollController();
  ScrollController scrollControllerClassName = new ScrollController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController assessmentController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController addController = TextEditingController();
//--------------------------------------------------------------------------------------------------------
  // GoogleDriveBloc _googleDriveBloc = new GoogleDriveBloc();
  final ValueNotifier<String> selectedGrade = ValueNotifier<String>("PK");
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);
  ValueNotifier<bool> isImageFilePicked = ValueNotifier<bool>(
      false); //Used to manage the question image. Should not be editable if already sent to google classroom assignment
  final ValueNotifier<String> assessmentNameError = ValueNotifier<String>('');
  final ValueNotifier<String> classError = ValueNotifier<String>('');
  // ValueNotifier<bool> isAlreadySelected = ValueNotifier<bool>(
  //     false); //Used to manage the edit of assignment details if excel and slide already created. It should not be editable then.

//--------------------------------------------------------------------------------------------------------
  LocalDatabase<StudentAssessmentInfo> _studentAssessmentInfoDb =
      LocalDatabase(Strings.studentInfoDbName);
  LocalDatabase<String> _localDb = LocalDatabase('class_suggestions');

//--------------------------------------------------------------------------------------------------------
  GoogleClassroomBloc _googleClassroomBloc = new GoogleClassroomBloc();
  final OcrBloc _bloc = new OcrBloc();

//--------------------------------------------------------------------------------------------------------
  bool isClassroomSelectedForStandardApp = false;
  File? imageFile;
  static const double _KVerticalSpace = 60.0;

  // GoogleClassroomCourses? studentClassRoomObj;

//--------------------------------------------------------------------------------------------------------

  @override
  void initState() {
    initMethod();
    super.initState();
  }

  initMethod() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      OcrOverrides.gradedPlusNavBarIsHide.value = false;
    });

    //Managing suggestion chips // course name // class name
    if (Overrides.STANDALONE_GRADED_APP) {
      GoogleClassroomOverrides.studentAssessmentAndClassroomObj =
          GoogleClassroomCourses();
      CreateAssessmentScreenMethod.updateClassNameForStandAloneApp(
          classSuggestions: widget.classSuggestions,
          classController: classController,
          classError: classError);
    } else {}

    // get last selected grade
    CreateAssessmentScreenMethod.getLastSelectedGrade(
        selectedGrade: selectedGrade);

    FirebaseAnalyticsService.addCustomAnalyticsEvent("create_assessment");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'create_assessment', screenClass: 'CreateAssessment');

    await OcrUtility.sortStudents(
      tableName: Strings.studentInfoDbName,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Stack(
        children: [
          CommonBackgroundImgWidget(),
          Scaffold(
              key: scaffoldKey,
              resizeToAvoidBottomInset: true,
              floatingActionButton: textActionButton(),
              // floatingActionButtonLocation:
              //   FloatingActionButtonLocation.centerFloat,
              backgroundColor: Colors.transparent,
              appBar: CustomOcrAppBarWidget(
                plusAppName: 'GRADED+',
                fromGradedPlus: true,
                isSuccessState: ValueNotifier<bool>(true),
                isBackOnSuccess: isBackFromCamera,
                key: GlobalKey(),
                isBackButton: false,
                isHomeButtonPopup: true,
              ),
              body: body()),
        ],
      ),
    );
  }

  Widget body() {
    bool isSmallDevice = MediaQuery.of(context).size.height * 0.8 <= 700;
    // print(MediaQuery.of(context).size.height * 0.9);
    return Form(
      key: _formKey,
      child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: StudentPlusOverrides.kSymmetricPadding),
          child: ListView(
              physics: !isSmallDevice ? NeverScrollableScrollPhysics() : null,
              padding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: StudentPlusOverrides.kLabelSpacing / 2),
              shrinkWrap: true,
              children: [
                SpacerWidget(StudentPlusOverrides.KVerticalSpace / 10),
                PlusScreenTitleWidget(
                  kLabelSpacing: 0,
                  text: 'Create Assignment',
                  backButton: true,
                ),
                SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
                Utility.textWidget(
                    context: context,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    text: 'Assignment Name',
                    textTheme: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryVariant
                            .withOpacity(0.3))),
                textFormField(
                    scrollController: scrollControllerAssessmentName,
                    isAssessmentTextFormField: true,
                    controller: assessmentController,
                    hintText: 'Assignment Name',
                    validator: (String? value) {
                      return null;
                    },
                    onSaved: (String value) {
                      assessmentNameError.value = value;
                    },
                    readOnly: false),

                //Used to tramslate the error message
                ValueListenableBuilder(
                    valueListenable: assessmentNameError,
                    child: Container(),
                    builder:
                        (BuildContext context, dynamic value, Widget? child) {
                      return Container(
                        //  color: Colors.amber,

                        padding: assessmentNameError.value.isEmpty
                            ? EdgeInsets.only(top: 8)
                            : null,
                        alignment: Alignment.centerLeft,
                        child: TranslationWidget(
                            message: assessmentNameError.value.isEmpty
                                ? 'Assignment Name is required'
                                : assessmentNameError.value.length < 2
                                    ? 'Assignment Name should contains atleast 2 characters'
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

                SpacerWidget(_KVerticalSpace / 3),
                Utility.textWidget(
                    context: context,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    text: 'Class Name',
                    textTheme: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryVariant
                            .withOpacity(0.3))),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textFormField(
                      readOnly: Overrides.STANDALONE_GRADED_APP == true
                          ? true
                          : false, // true,
                      scrollController: scrollControllerClassName,
                      isAssessmentTextFormField: false,
                      controller: classController,
                      hintText: '1st',
                      onSaved: (String value) {
                        classError.value = value;
                      },
                      validator: (String? value) {
                        return null;
                      },
                    ),
                    ValueListenableBuilder(
                        valueListenable: classError,
                        child: Container(),
                        builder: (BuildContext context, dynamic value,
                            Widget? child) {
                          return Container(
                            padding: EdgeInsets.only(top: 8),
                            alignment: Alignment.centerLeft,
                            child: TranslationWidget(
                                message: classError.value.isEmpty
                                    ? 'Class is required'
                                    : '',
                                fromLanguage: "en",
                                toLanguage: Globals.selectedLanguage,
                                builder: (translatedMessage) {
                                  return Text(
                                    translatedMessage,
                                    style: TextStyle(
                                        color: classError.value.isEmpty
                                            ? Colors.red
                                            : Colors.transparent),
                                  );
                                }),
                          );
                        }),
                  ],
                ),
                if (widget.classSuggestions.length > 0)
                  SpacerWidget(_KVerticalSpace / 8),
                Utility.textWidget(
                    context: context,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    text: 'Select Classroom',
                    textTheme: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryVariant
                            .withOpacity(0.3))),
                if (widget.classSuggestions.length > 0)
                  SpacerWidget(_KVerticalSpace / 5),
                Container(
                    height: 30,
                    child: ChipsFilter(
                      selectedValue: (String value) {
                        //update the class textformfield controller
                        //and it's error msg variable
                        classController.text = value;
                        classError.value = value;

                        if (Overrides.STANDALONE_GRADED_APP) {
                          CreateAssessmentScreenMethod
                              .updateClassNameForStandAloneApp(
                                  classSuggestions: widget.classSuggestions,
                                  classController: classController,
                                  classError: classError);
                        } else {
                          CreateAssessmentScreenMethod
                              .updateClassNameForStandardApp(courseName: value);

                          // update the
                          if (value?.isNotEmpty ?? false) {
                            isClassroomSelectedForStandardApp = true;
                          } else {
                            isClassroomSelectedForStandardApp = false;
                          }
                        }
                      },
                      selected: 1, // Select the second filter as default
                      filters: widget.classSuggestions,
                    )),

                SpacerWidget(_KVerticalSpace / 2),
                Utility.textWidget(
                    context: context,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    text: 'Select Grade',
                    textTheme: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryVariant
                            .withOpacity(0.3))),
                SpacerWidget(_KVerticalSpace / 4),
                scoringButton(),
                SpacerWidget(_KVerticalSpace / 3),

                Row(
                  children: [
                    ValueListenableBuilder(
                        valueListenable: isImageFilePicked,
                        builder: (BuildContext context, dynamic value,
                            Widget? child) {
                          return Container(
                            // height: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Utility.textWidget(
                                      context: context,
                                      text: isImageFilePicked.value != true
                                          ? 'Scan Assignment (Optional)'
                                          : 'Assignment Selected',
                                      textTheme: TextStyle(
                                          color: isImageFilePicked.value != true
                                              ? Color(0xff000000) ==
                                                      Theme.of(context)
                                                          .backgroundColor
                                                  ? Color(0xffFFFFFF)
                                                  : Color(0xff000000)
                                              : AppTheme.kSelectedColor,
                                          fontSize:
                                              Globals.deviceType == 'phone'
                                                  ? 16
                                                  : 22),
                                    ),
                                    isImageFilePicked.value == true
                                        ? IconButton(
                                            onPressed: () {
                                              // if (isAlreadySelected
                                              //     .value) {
                                              //   _checkFieldEditable(
                                              //       msg:
                                              //           "You cannot edit the image, once created.");
                                              // } else {
                                              _cameraImage(context);
                                              //  }
                                            },
                                            icon: Icon(
                                              Icons.replay_outlined,
                                              // : Icons.image_sharp,
                                              size:
                                                  Globals.deviceType == 'phone'
                                                      ? 20
                                                      : 25,
                                            ),
                                            color:
                                                isImageFilePicked.value != true
                                                    ? Color(0xff000000) ==
                                                            Theme.of(context)
                                                                .backgroundColor
                                                        ? Color(0xffFFFFFF)
                                                        : Color(0xff000000)
                                                    : AppTheme.kSelectedColor,
                                          )
                                        : Container(),
                                  ],
                                ),
                                SpacerWidget(_KVerticalSpace / 8),
                                CircleAvatar(
                                  //  foregroundColor:  Colors.red,
                                  backgroundImage:
                                      isImageFilePicked.value == true
                                          ? FileImage(imageFile!)
                                          : null,
                                  backgroundColor: AppTheme.kButtonColor,
                                  radius: 30,
                                  child: IconButton(
                                    onPressed: () {
                                      if (isImageFilePicked.value != true) {
                                        // if (isAlreadySelected.value) {
                                        //   _checkFieldEditable(
                                        //       msg:
                                        //           "You cannot edit the image, once created.");
                                        // } else {
                                        _cameraImage(context);
                                        //  }
                                      } else {
                                        showQuestionImage();
                                      }
                                    },
                                    icon: Icon(
                                      isImageFilePicked.value != true
                                          ? Icons.add
                                          : Icons.check,
                                      // : Icons.image_sharp,
                                      size: Globals.deviceType == 'phone'
                                          ? 25
                                          : 30,
                                    ),
                                    color: isImageFilePicked.value != true
                                        ? Color(0xff000000) ==
                                                Theme.of(context)
                                                    .backgroundColor
                                            ? Color(0xffFFFFFF)
                                            : Color(0xff000000)
                                        : AppTheme.kSelectedColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
                SpacerWidget(_KVerticalSpace / 2),
              ])),
    );
  }

  void showQuestionImage() {
    showDialog(
        context: context,
        builder: (_) => ImagePopup(
              imageURL: '',
              isOcrPage: true,
              imageFile: imageFile,
            ));
  }

  Widget scoringButton() {
    return ValueListenableBuilder(
        valueListenable: selectedGrade,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return Container(
            child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: Globals.deviceType == 'phone' ? 50 : 70,
                    childAspectRatio: 5 / 6,
                    crossAxisSpacing: Globals.deviceType == 'phone' ? 15 : 50,
                    mainAxisSpacing: 5),
                itemCount: widget.customGrades.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Bouncing(
                    child: GestureDetector(
                      onTap: () {
                        if (widget.customGrades[index] != '+') {
                          // to updated selection to local db
                          CreateAssessmentScreenMethod.updateSelectedGrade(
                              value: widget.customGrades[index]);
                        }
                        widget.customGrades[index] == '+'
                            ? _updateGradeBottomSheet()
                            : selectedGrade.value = widget.customGrades[index];
                      },
                      child: Transform.scale(
                        scale: 1, //_scale!,
                        child: AnimatedContainer(
                          duration: Duration(microseconds: 10),
                          padding: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectedGrade.value ==
                                    widget.customGrades[index]
                                ? AppTheme.kSelectedColor
                                : Colors.grey,
                          ),
                          child: new Container(
                            decoration: BoxDecoration(
                                color: Color(0xff000000) !=
                                        Theme.of(context).backgroundColor
                                    ? Color(0xffF7F8F9)
                                    : Color(0xff111C20),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selectedGrade.value ==
                                          widget.customGrades[index]
                                      ? AppTheme.kSelectedColor
                                      : Colors.grey,
                                )),
                            child: Center(
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 5.0),
                                  child: Utility.textWidget(
                                    context: context,
                                    text: widget.customGrades[index],
                                    textTheme: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(
                                            color: selectedGrade.value ==
                                                    widget.customGrades[index]
                                                ? AppTheme.kSelectedColor
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primaryVariant),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
        });
  }

  Widget textFormField({
    required TextEditingController controller,
    bool? readOnly,
    required onSaved,
    required hintText,
    required validator,
    required bool isAssessmentTextFormField,
    required ScrollController scrollController,
  }) {
    return ValueListenableBuilder(
        valueListenable: classError,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          // controller.selection = TextSelection.fromPosition(
          //     TextPosition(offset: controller.text.length));
          return ValueListenableBuilder(
              valueListenable: assessmentNameError,
              child: Container(),
              builder: (BuildContext context, dynamic value, Widget? child) {
                return Container(
                  //  color: Colors.blue,
                  child: TextFormField(
                    // onTap: (() => _checkFieldEditable(
                    //     msg:
                    //         'You cannot edit the Assessment Name and Class, once created.')),
                    readOnly: readOnly ?? false,
                    scrollController: scrollController,
                    autovalidateMode: AutovalidateMode.always,
                    textAlign: TextAlign.start,
                    inputFormatters: <TextInputFormatter>[
                      //To capitalize first letter of the textfield
                      UpperCaseTextFormatter()
                    ],
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.bold),
                    controller: controller,
                    cursorColor: Theme.of(context).colorScheme.primaryVariant,
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                      fillColor: Colors.transparent,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryVariant
                                .withOpacity(0.5)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryVariant
                                .withOpacity(0.5)),
                      ),
                      contentPadding: EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .primaryVariant
                              .withOpacity(0.3),
                        ),
                      ),
                    ),
                    onChanged: onSaved,
                    validator: validator,
                  ),
                );
              });
        });
  }

  Widget textActionButton() {
    return OfflineBuilder(
      connectivityBuilder: (BuildContext context,
          ConnectivityResult connectivity, Widget child) {
        final bool connected = connectivity != ConnectivityResult.none;
        return Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: FloatingActionButton.extended(
              backgroundColor: AppTheme.kButtonColor,
              onPressed: () async {
                // Hide keyboard
                FocusScope.of(context).requestFocus(FocusNode());

                // Check for internet connection
                if (!connected) {
                  Utility.currentScreenSnackBar("No Internet Connection", null);
                  return;
                }

                // Check if form is valid
                if (assessmentNameError.value.isEmpty ||
                    assessmentNameError.value.length < 2 ||
                    classError.value.isEmpty) {
                  return;
                }

                // Check if using standalone graded app and if student not belongs to selected classroom

                /* --------------------------------------------------------------------------- */
                /*                              StandAlone app                                 */
                /* --------------------------------------------------------------------------- */
                /* --------------- This will works only for StandAlone App   ----------------- */
                if (Overrides.STANDALONE_GRADED_APP &&
                    (GoogleClassroomOverrides.studentAssessmentAndClassroomObj
                            ?.courseId?.isEmpty ??
                        true)) {
                  Utility.currentScreenSnackBar(
                      "None of the scanned student available in the selected classroom course \'${classController.text}\'",
                      null);
                  return;
                }

                // Check if all students belong to same class
                if (Overrides.STANDALONE_GRADED_APP) {
                  Utility.showLoadingDialog(
                    context: context,
                    isOCR: true,
                  );

                  List<StudentAssessmentInfo>
                      notPresentStudentListInSelectedClass = await OcrUtility
                          .checkAllStudentBelongsToSameClassOrNotForStandAloneApp(
                              title: Globals.assessmentName ?? '',
                              isScanMore: false,
                              studentInfoDB: _studentAssessmentInfoDb);

                  Navigator.of(context).pop();

                  //Check student and show popup modal in case of scan more
                  if ((notPresentStudentListInSelectedClass?.isNotEmpty ??
                      true)) {
                    notPresentStudentsPopupModal(
                        notPresentStudentsInSelectedClass:
                            notPresentStudentListInSelectedClass,
                        courseName: classController.text);
                    return;
                  }
                }

                //   /* -------------------------------------------------------------------------- */
                //   /*                              StandDart app                                 */
                //   /* -------------------------------------------------------------------------- */

                //   /* ------------------ This will works for Standart App    -------------------- */

                if (Overrides.STANDALONE_GRADED_APP == false &&
                    isClassroomSelectedForStandardApp == false) {
                  classroomNotSelectedWarningPopupModal();
                  return;
                }
                _performGoogleRelatedActions();
              },
              label: Row(
                children: [
                  Utility.textWidget(
                      context: context,
                      text: 'Next',
                      textTheme: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(color: Theme.of(context).backgroundColor)),
                  SpacerWidget(5),
                  RotatedBox(
                    quarterTurns: 90,
                    child: Icon(Icons.arrow_back,
                        color: Theme.of(context).backgroundColor, size: 20),
                  )
                ],
              )),
        );
      },
      child: Container(),
    );
  }

  Future<void> _cameraImage(BuildContext context) async {
    File? photo = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GradedPlusCameraScreen(
                isMcqSheet: widget.isMcqSheet,
                selectedAnswer: widget.selectedAnswer,
                isFromHistoryAssessmentScanMore: false,
                onlyForPicture: true,
                isScanMore: false,
                pointPossible: '',
                isFlashOn: ValueNotifier<bool>(false),
              )),
    );
    if (photo != null) {
      imageFile = photo;
      //isImageFilePicked.value = false;
      isImageFilePicked.value = true;

      //update Question imagefilepath in local studentDb

      List<StudentAssessmentInfo> studentInfoList =
          await _studentAssessmentInfoDb.getData();

      if (studentInfoList?.isNotEmpty ?? false) {
        StudentAssessmentInfo stduentObj = studentInfoList.first;
        stduentObj.questionImgFilePath = imageFile!.path.toString();
        await _studentAssessmentInfoDb.putAt(0, stduentObj);
      }

      String addedAQuestionImgLogMsg = "User Added a Question Image";
      FirebaseAnalyticsService.addCustomAnalyticsEvent(
          addedAQuestionImgLogMsg.toLowerCase().replaceAll(" ", "_") ?? '');
    }
  }

  _updateGradeBottomSheet() {
    showModalBottomSheet(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      elevation: 10,
      context: context,
      builder: (context) => BottomSheetWidget(
        title: 'Add Custom Grade',
        isImageField: false,
        textFieldTitleOne: 'Grade Name',
        isSubjectScreen: true,
        sheetHeight: MediaQuery.of(context).orientation == Orientation.landscape
            ? MediaQuery.of(context).size.height * 0.82
            : MediaQuery.of(context).size.height / 2.5,
        valueChanged: (controller) async {
          await updateGradeList(
              context: context,
              sectionName: controller.text,
              customGrades: widget.customGrades,
              selectedGrade: selectedGrade,
              scaffoldKey: scaffoldKey);

          // to updated selection to local db
          CreateAssessmentScreenMethod.updateSelectedGrade(
            value: controller.text,
          );

          controller.clear();
          Navigator.pop(context, false);
        },
        submitButton: true,
      ),
    );
  }

  notPresentStudentsPopupModal(
      {required List<StudentAssessmentInfo> notPresentStudentsInSelectedClass,
      required String courseName}) async {
    showDialog(
        context: context,
        builder: (showDialogContext) => NonCourseGoogleClassroomStudentPopup(
              key: _dialogKey,
              notPresentStudentsInSelectedClass:
                  notPresentStudentsInSelectedClass,
              title: 'Action Required!',
              message:
                  // "A few students not found in the selected course \'${classController.text}\'. Do you still want to continue with these students?",
                  "A few students not found in the selected Google Classroom course. Do you still want to continue with these students?",
              studentInfoDb: _studentAssessmentInfoDb,
              onTapCallback: () {
                // Close the dialog from outside
                if (_dialogKey.currentState != null) {
                  _dialogKey.currentState!.closeDialog();
                }
                _performGoogleRelatedActions();
              },
            ));
  }

  void _performGoogleRelatedActions() {
    Globals.assessmentName =
        "${assessmentController.text}_${classController.text}";

//Create google classroom assignment in case of standalone only
    if (Overrides.STANDALONE_GRADED_APP) {
      _googleClassroomBloc.add(CreateClassRoomCourseWork(
          studentAssessmentInfoDb: _studentAssessmentInfoDb,
          studentClassObj:
              GoogleClassroomOverrides.studentAssessmentAndClassroomObj,
          title: Globals.assessmentName ?? '',
          pointPossible: Globals.pointPossible ?? "0"));
    } else {
      CreateAssessmentScreenMethod.navigateToSubjectSection(
          context: context,
          classSuggestions: widget.classSuggestions,
          classController: classController,
          selectedAnswer: widget.selectedAnswer,
          selectedGrade: selectedGrade,
          localDb: _localDb,
          imageFile: imageFile,
          isMcqSheet: widget.isMcqSheet);
    }
  }

// show warning popup
  classroomNotSelectedWarningPopupModal() {
    return showDialog(
        context: context,
        builder: (context) =>
            OrientationBuilder(builder: (context, orientation) {
              return CommonPopupWidget(
                isLogout: true,
                orientation: orientation,
                context: context,
                message:
                    "You haven't selected any Google Classroom Course. Do you still want to continue?",
                title: "Action Required!",
                confirmationButtonTitle: "Continue",
                deniedButtonTitle: "Select",
                confirmationOnPress: () async {
                  Navigator.pop(context);
                  _performGoogleRelatedActions();
                },
              );
            }));
  }

/*------------------------------------------------------------------------------------------------*/
/*---------------------------------------updateGradeList------------------------------------------*/
/*------------------------------------------------------------------------------------------------*/
  updateGradeList({
    context,
    required String sectionName,
    required customGrades,
    required selectedGrade,
    required scaffoldKey,
  }) async {
    LocalDatabase<String> _localDb = LocalDatabase('class_section_list');

    if (!customGrades.contains(sectionName)) {
      customGrades.removeLast();
      customGrades.add(sectionName);
      customGrades.add('+');
      //-----------------------------
      setState(() {});
      //-----------------------------

      selectedGrade.value = customGrades[customGrades.length - 2];
    } else {
      Utility.showSnackBar(
          scaffoldKey, "Subject \'$sectionName\' Already Exist", context, null);
    }

    await _localDb.clear();
    customGrades.forEach((String e) {
      _localDb.addData(e);
    });
  }
}
