import 'dart:convert';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/google_classroom_globals.dart';
import 'package:Soc/src/modules/google_classroom/modal/google_classroom_courses.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/ocr/graded_overrides.dart';
import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/ocr/ui/camera_screen.dart';
import 'package:Soc/src/modules/ocr/ui/state_selection_page.dart';
import 'package:Soc/src/modules/ocr/widgets/bottom_sheet_widget.dart';
import 'package:Soc/src/modules/ocr/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/widgets/ocr_background_widget.dart';
import 'package:Soc/src/modules/ocr/ui/subject_selection/subject_selection.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/firstLetterUpperCase.dart';
import '../../google_classroom/bloc/google_classroom_bloc.dart';
import 'package:Soc/src/modules/ocr/widgets/Common_popup.dart';
import '../widgets/student_popup.dart';
import '../widgets/suggestion_chip.dart';

class CreateAssessment extends StatefulWidget {
  CreateAssessment(
      {Key? key,
      required this.classSuggestions,
      required this.customGrades,
      this.isMcqSheet,
      required this.selectedAnswer})
      : super(key: key);
  final List<String> classSuggestions;
  final List<String> customGrades;
  final bool? isMcqSheet;
  final String? selectedAnswer;
  @override
  State<CreateAssessment> createState() => _CreateAssessmentState();
}

class _CreateAssessmentState extends State<CreateAssessment>
    with SingleTickerProviderStateMixin {
  static const double _KVerticalSpace = 60.0;
  final assessmentController = TextEditingController();
  final classController = TextEditingController();
  // int selectedGrade.value = 0;
  final _formKey = GlobalKey<FormState>();
  GoogleDriveBloc _googleDriveBloc = new GoogleDriveBloc();
  // To update image to s3 bucket
  GoogleDriveBloc _googleDriveBloc2 = new GoogleDriveBloc();
  // final ScrollController listScrollController = ScrollController();
  final ValueNotifier<int> selectedGrade = ValueNotifier<int>(0);
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);
  ValueNotifier<bool> isImageFilePicked = ValueNotifier<bool>(false);
  final ValueNotifier<String> assessmentNameError = ValueNotifier<String>('');
  final ValueNotifier<String> classError = ValueNotifier<String>('');
  ValueNotifier<bool> isAlreadySelected = ValueNotifier<bool>(false);
  File? imageFile;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  LocalDatabase<String> _localDb = LocalDatabase('class_suggestions');
  final OcrBloc _bloc = new OcrBloc();

  final addController = TextEditingController();
  @override
  void initState() {
    GoogleClassroomGlobals.studentAssessmentAndClassroomObj =
        GoogleClassroomCourses();

    //Managing suggestion chips // course name // class name
    updateClassName();

    Globals.googleExcelSheetId = '';
    Globals.googleSlidePresentationId = '';
    Globals.googleSlidePresentationLink = '';

    FirebaseAnalyticsService.addCustomAnalyticsEvent("create_assessment");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'create_assessment', screenClass: 'CreateAssessment');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ScrollController scrollControllerAssessmentName = new ScrollController();
  ScrollController scrollControllerClassName = new ScrollController();

  GoogleClassroomBloc _googleClassroomBloc = new GoogleClassroomBloc();
  final GlobalKey<NonCourseGoogleClassroomStudentPopupState> _dialogKey =
      GlobalKey<NonCourseGoogleClassroomStudentPopupState>();

  // GoogleClassroomCourses? studentClassRoomObj;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Stack(
        children: [
          CommonBackGroundImgWidget(),
          Scaffold(
            key: scaffoldKey,
            resizeToAvoidBottomInset: true,
            floatingActionButton: textActionButton(),
            // floatingActionButtonLocation:
            //   FloatingActionButtonLocation.centerFloat,
            backgroundColor: Colors.transparent,
            appBar: CustomOcrAppBarWidget(
              isSuccessState: ValueNotifier<bool>(true),
              isBackOnSuccess: isBackFromCamera,
              key: GlobalKey(),
              isBackButton: false,
              isHomeButtonPopup: true,
            ),

            body: Container(
              child: Form(
                key: _formKey,
                child: Container(
                  // color: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.height
                          : MediaQuery.of(context).size.width,
                  child: ValueListenableBuilder(
                      valueListenable: isAlreadySelected,
                      child: Container(),
                      builder:
                          (BuildContext context, dynamic value, Widget? child) {
                        return ListView(
                          padding: EdgeInsets.only(bottom: 20),
                          // controller: listScrollController,
                          shrinkWrap: true,
                          children: [
                            SpacerWidget(_KVerticalSpace * 0.50),
                            highlightText(
                              text: 'Create Assignment',
                              theme: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            SpacerWidget(_KVerticalSpace / 1.8),
                            highlightText(
                                text: 'Assignment Name',
                                theme: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryVariant
                                            .withOpacity(0.3))),
                            textFormField(
                                scrollController:
                                    scrollControllerAssessmentName,
                                isAssessmentTextFormField: true,
                                controller: assessmentController,
                                hintText: 'Assignment Name',
                                validator: (String? value) {
                                  return null;
                                },
                                onSaved: (String value) {
                                  assessmentNameError.value = value;
                                },
                                readOnly: isAlreadySelected.value),

                            //Used to tramslate the error message
                            ValueListenableBuilder(
                                valueListenable: assessmentNameError,
                                child: Container(),
                                builder: (BuildContext context, dynamic value,
                                    Widget? child) {
                                  return Container(
                                    //  color: Colors.amber,

                                    padding: assessmentNameError.value.isEmpty
                                        ? EdgeInsets.only(top: 8)
                                        : null,
                                    alignment: Alignment.centerLeft,
                                    child: TranslationWidget(
                                        message: assessmentNameError
                                                .value.isEmpty
                                            ? 'Assignment Name is required'
                                            : assessmentNameError.value.length <
                                                    2
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
                            highlightText(
                                text: 'Class Name',
                                theme: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryVariant
                                            .withOpacity(0.3))),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textFormField(
                                  readOnly:
                                      Overrides.STANDALONE_GRADED_APP == true
                                          ? true
                                          : isAlreadySelected.value, // true,
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
                                    builder: (BuildContext context,
                                        dynamic value, Widget? child) {
                                      return Container(
                                        padding: classError.value.isEmpty
                                            ? EdgeInsets.only(top: 8)
                                            : null,
                                        alignment: Alignment.centerLeft,
                                        child: TranslationWidget(
                                            message: classError.value.isEmpty
                                                ? 'Class is required'
                                                : '',
                                            fromLanguage: "en",
                                            toLanguage:
                                                Globals.selectedLanguage,
                                            builder: (translatedMessage) {
                                              return Text(
                                                translatedMessage,
                                                style: TextStyle(
                                                    color: Colors.red),
                                              );
                                            }),
                                      );
                                    }),
                              ],
                            ),
                            if (widget.classSuggestions.length > 0 &&
                                !isAlreadySelected.value)
                              SpacerWidget(_KVerticalSpace / 8),
                            if (widget.classSuggestions.length > 0)
                              Container(
                                  height: !isAlreadySelected.value ? 30 : 0.0,
                                  //padding: EdgeInsets.only(left: 2.0),
                                  child: ChipsFilter(
                                    selectedValue: (String value) {
                                      if (value.isNotEmpty) {
                                        classController.text = value;
                                        classError.value = value;
                                        updateClassName();
                                      }
                                    },
                                    selected:
                                        1, // Select the second filter as default
                                    filters: widget.classSuggestions,
                                  )),

                            SpacerWidget(_KVerticalSpace / 2),
                            highlightText(
                                text: 'Select Grade',
                                theme: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(
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
                                    builder: (BuildContext context,
                                        dynamic value, Widget? child) {
                                      return Container(
                                        // height: 80,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Utility.textWidget(
                                                  context: context,
                                                  text: isImageFilePicked
                                                              .value !=
                                                          true
                                                      ? 'Scan Assignment (Optional)'
                                                      : 'Assignment Selected',
                                                  textTheme: TextStyle(
                                                      color: isImageFilePicked
                                                                  .value !=
                                                              true
                                                          ? Color(0xff000000) ==
                                                                  Theme.of(
                                                                          context)
                                                                      .backgroundColor
                                                              ? Color(
                                                                  0xffFFFFFF)
                                                              : Color(
                                                                  0xff000000)
                                                          : AppTheme
                                                              .kSelectedColor,
                                                      fontSize:
                                                          Globals.deviceType ==
                                                                  'phone'
                                                              ? 16
                                                              : 22),
                                                ),
                                                isImageFilePicked.value == true
                                                    ? IconButton(
                                                        onPressed: () {
                                                          _cameraImage(context);
                                                        },
                                                        icon: Icon(
                                                          Icons.replay_outlined,
                                                          // : Icons.image_sharp,
                                                          size:
                                                              Globals.deviceType ==
                                                                      'phone'
                                                                  ? 20
                                                                  : 25,
                                                        ),
                                                        color: isImageFilePicked
                                                                    .value !=
                                                                true
                                                            ? Color(0xff000000) ==
                                                                    Theme.of(
                                                                            context)
                                                                        .backgroundColor
                                                                ? Color(
                                                                    0xffFFFFFF)
                                                                : Color(
                                                                    0xff000000)
                                                            : AppTheme
                                                                .kSelectedColor,
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                            SpacerWidget(_KVerticalSpace / 8),
                                            CircleAvatar(
                                              //  foregroundColor:  Colors.red,
                                              backgroundImage:
                                                  isImageFilePicked.value ==
                                                          true
                                                      ? FileImage(imageFile!)
                                                      : null,
                                              backgroundColor:
                                                  AppTheme.kButtonColor,
                                              radius: 30,
                                              child: IconButton(
                                                onPressed: () {
                                                  if (isImageFilePicked.value !=
                                                      true) {
                                                    _cameraImage(context);
                                                  } else {
                                                    showQuestionImage();
                                                  }
                                                },
                                                icon: Icon(
                                                  isImageFilePicked.value !=
                                                          true
                                                      ? Icons.add
                                                      : Icons.check,
                                                  // : Icons.image_sharp,
                                                  size: Globals.deviceType ==
                                                          'phone'
                                                      ? 25
                                                      : 30,
                                                ),
                                                color: isImageFilePicked
                                                            .value !=
                                                        true
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
                          ],
                        );
                      }),
                ),
              ),
            ),
          ),
        ],
      ),
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

  Widget textwidget({required String text, required dynamic textTheme}) {
    return TranslationWidget(
      message: text,
      toLanguage: Globals.selectedLanguage,
      fromLanguage: "en",
      builder: (translatedMessage) => Text(
        translatedMessage.toString(),
        style: textTheme,
      ),
    );
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
                // physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: Globals.deviceType == 'phone' ? 50 : 70,
                    childAspectRatio: 5 / 6,
                    crossAxisSpacing: Globals.deviceType == 'phone' ? 15 : 50,
                    mainAxisSpacing: 5),
                itemCount: widget.customGrades.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Bouncing(
                    // onPress: () {
                    //   // widget.customGrades[index] == '+'
                    //   //     ? _addSectionBottomSheet()
                    //   //     : selectedGrade.value = index;
                    // },
                    child: GestureDetector(
                      onTap: () {
                        widget.customGrades[index] == '+'
                            ? _updateGradeBottomSheet()
                            : selectedGrade.value = index;
                      },
                      child: Transform.scale(
                        scale: 1, //_scale!,
                        child: AnimatedContainer(
                          duration: Duration(microseconds: 10),
                          padding: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectedGrade.value == index
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
                                  color: selectedGrade.value == index
                                      ? AppTheme.kSelectedColor
                                      : Colors.grey,
                                )),
                            child: Center(
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 5.0),
                                  child: textwidget(
                                    text: widget.customGrades[index],
                                    textTheme: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(
                                            color: selectedGrade.value == index
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

  Widget highlightText({required String text, required theme}) {
    return TranslationWidget(
      message: text,
      toLanguage: Globals.selectedLanguage,
      fromLanguage: "en",
      builder: (translatedMessage) => Text(
        translatedMessage.toString(),
        maxLines: 2,
        //overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        style: theme,
      ),
    );
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
                    onTap: (() => _checkFieldEditable()),
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
                      fillColor: isAlreadySelected.value
                          ? Colors.grey.withOpacity(.1)
                          : Colors.transparent,
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
                      contentPadding:
                          EdgeInsets.only(top: 10, bottom: 10, left: 3.0),
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
        return FloatingActionButton.extended(
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
              //on updating the course selection, firstly 'GoogleClassroomGlobals.studentAssessmentAndClassroomObj?.courseId?' gets empty and updates with the selected course id when course matches to one or more student
              if (Overrides.STANDALONE_GRADED_APP &&
                  (GoogleClassroomGlobals.studentAssessmentAndClassroomObj
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

                List<StudentAssessmentInfo> studentsNotBelongToSelectedCourse =
                    await _compareStudentsBelongToSameClassOrNot();

                Navigator.of(context).pop();
                if (studentsNotBelongToSelectedCourse?.isNotEmpty ?? true) {
                  showUnavailableStudentsPopupModal(
                      studentsNotBelongToSelectedCourse:
                          studentsNotBelongToSelectedCourse);
                  return;
                }
              }

              performOnTapOnNext();
            },
            // onPressed: () async {
            //   FocusScope.of(context).requestFocus(FocusNode());
            //   if (!connected) {
            //     Utility.currentScreenSnackBar("No Internet Connection", null);
            //   } else {
            //     // if (_formKey.currentState!.validate()) {
            //     if (assessmentNameError.value.isNotEmpty &&
            //         assessmentNameError.value.length >= 2 &&
            //         classError.value.isNotEmpty) {
            //       if (Overrides.STANDALONE_GRADED_APP &&
            //           (GoogleClassroomGlobals.studentAssessmentAndClassroomObj
            //                   ?.courseId?.isEmpty ??
            //               true)) {
            //         Utility.currentScreenSnackBar(
            //             "None of the scanned student available in the selected classroom course \'${classController.text}\'",
            //             null);
            //       } else {
            //         if (Overrides.STANDALONE_GRADED_APP) {
            //           List<StudentAssessmentInfo> notPresentStudentsList =
            //               await _compareStudentsBelongToSameClassOrNot();

            //           if (notPresentStudentsList?.isNotEmpty ?? false) {
            //             studentPopupModal(
            //                 notPresentStudentsList: notPresentStudentsList);
            //           } else {
            //             preparingexcelSheet();
            //           }
            //         } else {
            //           preparingexcelSheet();
            //         }
            //       }
            //     }
            //   }
            // },
            label: Row(
              children: [
                BlocListener<GoogleDriveBloc, GoogleDriveState>(
                    bloc: _googleDriveBloc,
                    child: Container(),
                    listener: (context, state) async {
                      if (state is GoogleDriveLoading) {
                        Utility.showLoadingDialog(
                            context: context, isOCR: true);
                      }

                      if (state is ExcelSheetCreated) {
                        //Create Google Presentation once Spreadsheet created
                        _googleDriveBloc.add(CreateSlideToDrive(
                            isMcqSheet: widget.isMcqSheet ?? false,
                            fileTitle:
                                "${assessmentController.text}_${classController.text}",
                            excelSheetId: Globals.googleExcelSheetId));
                      }
                      if (state is ErrorState) {
                        if (state.errorMsg == 'ReAuthentication is required') {
                          await Utility.refreshAuthenticationToken(
                              isNavigator: true,
                              errorMsg: state.errorMsg!,
                              context: context,
                              scaffoldKey: scaffoldKey);

                          _googleDriveBloc.add(CreateExcelSheetToDrive(
                              isMcqSheet: widget.isMcqSheet,
                              name:
                                  "${assessmentController.text}_${classController.text}"));
                        } else {
                          Navigator.of(context).pop();
                          Utility.currentScreenSnackBar(
                              state.errorMsg == 'NO_CONNECTION'
                                  ? 'No Internet Connection'
                                  : "Something Went Wrong. Please Try Again.",
                              null);
                        }
                      }
                      if (state is RecallTheEvent) {
                        _googleDriveBloc.add(CreateExcelSheetToDrive(
                            isMcqSheet: widget.isMcqSheet,
                            name:
                                "${assessmentController.text}_${classController.text}"));
                      }

                      if (state is GoogleSlideCreated) {
                        // _googleDriveBloc.add(GetShareLink(
                        //     fileId: Globals.googleSlidePresentationId,
                        //     slideLink: true));

                        //Save Google Presentation Id
                        Globals.googleSlidePresentationId = state.slideFiledId;
                        Navigator.of(context).pop();

                        // to update question image to aws s3 bucket and get the link
                        if (imageFile != null && imageFile!.path.isNotEmpty) {
                          String imgExtension = imageFile!.path
                              .substring(imageFile!.path.lastIndexOf(".") + 1);
                          List<int> imageBytes = imageFile!.readAsBytesSync();
                          String imageB64 = base64Encode(imageBytes);
                          Globals.questionImgFilePath = imageFile;

                          _googleDriveBloc2.add(QuestionImgToAwsBucked(
                              imgBase64: imageB64, imgExtension: imgExtension));
                        } else {
                          _navigateToSubjectSection('');
                        }
                      }
                    }),
                BlocListener<GoogleDriveBloc, GoogleDriveState>(
                    bloc: _googleDriveBloc2,
                    child: Container(),
                    listener: (context, state) async {
                      if (state is GoogleDriveLoading) {
                        Utility.showLoadingDialog(
                            context: context, isOCR: true);
                      }

                      if (state is QuestionImageSuccess) {
                        Navigator.of(context).pop();

                        _navigateToSubjectSection(state.questionImageUrl);
                      }
                      if (state is ErrorState) {
                        Navigator.of(context).pop();
                        Utility.currentScreenSnackBar(
                            "Something Went Wrong. Please Try Again.", null);
                      }
                    }),
                textwidget(
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
            ));
      },
      child: Container(),
    );
  }

  Future<void> _cameraImage(BuildContext context) async {
    File? photo = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CameraScreen(
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
      isImageFilePicked.value = false;
      isImageFilePicked.value = true;
      String addedAQuestionImgLogMsg = "User Added a Question Image";
      FirebaseAnalyticsService.addCustomAnalyticsEvent(
          addedAQuestionImgLogMsg.toLowerCase().replaceAll(" ", "_") ?? '');
    }
  }

  void _navigateToSubjectSection(String? questionImageUrl) async {
    for (int i = 0; i < widget.classSuggestions.length; i++) {
      if (classController.text == widget.classSuggestions[i])
        widget.classSuggestions.removeAt(i);
    }

    widget.classSuggestions.insert(0, classController.text);
// ignore: unnecessary_statements
    if (widget.classSuggestions.length > 9) {
      widget.classSuggestions.removeAt(0);
    }

    await _localDb.clear();
    widget.classSuggestions.forEach((String e) {
      _localDb.addData(e);
    });

    Utility.updateLogs(
        activityId: '11',
        description: 'Created G-Excel file',
        operationResult: 'Success');

    // To check State is selected or not only for standalone app (if selected then navigate to subject screen otherwise navigate to state selection screen)
    String? selectedState;
    if (Overrides.STANDALONE_GRADED_APP) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      selectedState = pref.getString('selected_state');
    } else {
      //for school app default state
      selectedState = OcrOverrides.defaultStateForSchoolApp;
    }

    isAlreadySelected.value = true;

    // FirebaseAnalyticsService.addCustomAnalyticsEvent(
    //     "navigate_from_create_assignment_page_to_subject_page");
    if (selectedState != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SubjectSelection(
                  isMcqSheet: widget.isMcqSheet,
                  selectedAnswer: widget.selectedAnswer,
                  stateName: selectedState,
                  questionImageUrl: questionImageUrl ?? '',
                  selectedClass: widget.customGrades[selectedGrade.value],
                )),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StateSelectionPage(
                  isMcqSheet: widget.isMcqSheet,
                  selectedAnswer: widget.selectedAnswer,
                  isFromCreateAssessmentScreen: true,
                  questionImageUrl: questionImageUrl ?? '',
                  selectedClass: widget.customGrades[selectedGrade.value],
                )),
      );
    }
  }

  _updateGradeBottomSheet() {
    showModalBottomSheet(
      clipBehavior: Clip.antiAliasWithSaveLayer,
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
            sectionName: controller.text,
          );

          controller.clear();
          Navigator.pop(context, false);
        },
        submitButton: true,
      ),
    );
  }

  updateGradeList({required String sectionName}) async {
    LocalDatabase<String> _localDb = LocalDatabase('class_section_list');

    if (!widget.customGrades.contains(sectionName)) {
      widget.customGrades.removeLast();
      widget.customGrades.add(sectionName);
      widget.customGrades.add('+');

      setState(() {});
      selectedGrade.value = widget.customGrades.length - 2;
    } else {
      Utility.showSnackBar(
          scaffoldKey, "Subject \'$sectionName\' Already Exist", context, null);
    }

    await _localDb.clear();
    widget.customGrades.forEach((String e) {
      _localDb.addData(e);
    });
  }

  updateClassName() async {
    GoogleClassroomGlobals.studentAssessmentAndClassroomObj =
        GoogleClassroomCourses(courseId: '');

    LocalDatabase<GoogleClassroomCourses> _localDb =
        LocalDatabase(Strings.googleClassroomCoursesList);

/////---------
//Validating suggestion list comes from camera screen //comparing string of list and return course object
//Manage here to manage standalone and standard app
    List<GoogleClassroomCourses> googleClassroomCoursesDB =
        await _localDb.getData();

    List<GoogleClassroomCourses> _localData = googleClassroomCoursesDB
        .where((GoogleClassroomCourses classroomCourses) =>
            widget.classSuggestions.contains(classroomCourses.name))
        .toList();

    _localData.sort((a, b) => (a?.name ?? '').compareTo(b?.name ?? ''));

/////--------

    List<StudentAssessmentInfo> studentInfo =
        await Utility.getStudentInfoList(tableName: 'student_info');

    if (studentInfo.isNotEmpty) {
      for (GoogleClassroomCourses classroom in _localData) {
        if (classController.text?.isNotEmpty == true &&
            classroom.name != classController.text) {
          continue;
        }

        for (var student in classroom.studentList!) {
          for (StudentAssessmentInfo info in studentInfo) {
            if (info.studentId == student['profile']['emailAddress']) {
              print(classroom.name);
              classError.value = classroom.name!;
              if (Overrides.STANDALONE_GRADED_APP) {
                GoogleClassroomGlobals.studentAssessmentAndClassroomObj =
                    classroom;
              }
              if (classController.text?.isEmpty != false) {
                classController.text = classroom.name!;
              }
              break;
            }
          }
        }
      }
    }
  }

  _checkFieldEditable() {
    if (isAlreadySelected.value) {
      Utility.currentScreenSnackBar(
          'You cannot edit the Assessment Name and Class, once created.', null);
    }
    return;
  }

  Future<List<StudentAssessmentInfo>>
      _compareStudentsBelongToSameClassOrNot() async {
    try {
      List<StudentAssessmentInfo> studentInfo =
          await Utility.getStudentInfoList(tableName: 'student_info');

      // Retrieve the students not present in the "GoogleClassroomCourses" or not in the "Selected Course" object locally
      return studentInfo.where((student) {
        return GoogleClassroomGlobals
            .studentAssessmentAndClassroomObj //selected course object
            .studentList!
            .every((courseStudent) {
          return courseStudent["profile"]["emailAddress"] != student.studentId;
        });
      }).toList();
    } catch (e) {
      return [];
    }
  }

  void performOnTapOnNext() {
    Globals.assessmentName =
        "${assessmentController.text}_${classController.text}";
    //Create excel sheet if not created already for current assessment

    if (Globals.googleExcelSheetId!.isEmpty) {
      _googleDriveBloc.add(CreateExcelSheetToDrive(
          isMcqSheet: widget.isMcqSheet,
          name: "${assessmentController.text}_${classController.text}"));
      if (Overrides.STANDALONE_GRADED_APP) {
        _googleClassroomBloc.add(CreateClassRoomCourseWork(
            studentAssessmentInfoDb: LocalDatabase('student_info'),
            studentClassObj:
                GoogleClassroomGlobals.studentAssessmentAndClassroomObj,
            title: Globals.assessmentName ?? '',
            pointPossible: Globals.pointPossible ?? "0"));
      }
    } else if (imageFile != null && imageFile!.path.isNotEmpty) {
      String imgExtension =
          imageFile!.path.substring(imageFile!.path.lastIndexOf(".") + 1);
      List<int> imageBytes = imageFile!.readAsBytesSync();
      String imageB64 = base64Encode(imageBytes);
      Globals.questionImgFilePath = imageFile;

      _googleDriveBloc2.add(QuestionImgToAwsBucked(
          imgBase64: imageB64, imgExtension: imgExtension));
    } else {
      _navigateToSubjectSection('');
    }
  }

  void showUnavailableStudentsPopupModal(
      {required List<StudentAssessmentInfo>
          studentsNotBelongToSelectedCourse}) async {
    showDialog(
        context: context,
        builder: (showDialogContext) => NonCourseGoogleClassroomStudentPopup(
              key: _dialogKey,
              studentsNotBelongToSelectedCourse:
                  studentsNotBelongToSelectedCourse,
              title: 'Action Required!',
              message:
                  "A few students not found in the selected course \'${classController.text}\'. Do you still want to continue with these students?",
              studentInfoDb: LocalDatabase('student_info'),
              onTapCallback: () {
                // Close the dialog from outside
                if (_dialogKey.currentState != null) {
                  _dialogKey.currentState!.closeDialog();
                }
                performOnTapOnNext();
              },
            ));
  }
}
