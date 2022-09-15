import 'dart:convert';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/ocr/ui/camera_screen.dart';
import 'package:Soc/src/modules/ocr/widgets/bottom_sheet_widget.dart';
import 'package:Soc/src/modules/ocr/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/widgets/ocr_background_widget.dart';
import 'package:Soc/src/modules/ocr/ui/subject_selection.dart';
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
import 'package:flutter_offline/flutter_offline.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/firstLetterUpperCase.dart';
import '../widgets/suggestion_chip.dart';

class CreateAssessment extends StatefulWidget {
  CreateAssessment(
      {Key? key, required this.classSuggestions, required this.customGrades})
      : super(key: key);
  final List<String> classSuggestions;
  final List<String> customGrades;
  @override
  State<CreateAssessment> createState() => _CreateAssessmentState();
}

class _CreateAssessmentState extends State<CreateAssessment>
    with SingleTickerProviderStateMixin {
  static const double _KVertcalSpace = 60.0;
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
  ValueNotifier<bool> isimageFilePicked = ValueNotifier<bool>(false);
  final ValueNotifier<String> assessmentNameError = ValueNotifier<String>('');
  final ValueNotifier<String> classError = ValueNotifier<String>('');

  File? imageFile;
  final ImagePicker _picker = ImagePicker();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  LocalDatabase<String> _localDb = LocalDatabase('class_suggestions');
  final OcrBloc _bloc = new OcrBloc();

  final addController = TextEditingController();
  @override
  void initState() {
    // listScrollController.addListener(_scrollListener);
    Globals.googleExcelSheetId = '';
    _bloc.add(SaveSubjectListDetails());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  // _scrollListener() {
  //   FocusScope.of(context).requestFocus(FocusNode());
  // }

  ScrollController scrollControlleAssessmentName = new ScrollController();
  ScrollController scrollControlleClassName = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
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
              isbackOnSuccess: isBackFromCamera,
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
                  child: ListView(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.2),
                    // controller: listScrollController,
                    shrinkWrap: true,
                    children: [
                      SpacerWidget(_KVertcalSpace * 0.50),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: highlightText(
                          text: 'Create Assessment',
                          theme: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SpacerWidget(_KVertcalSpace / 1.8),
                      highlightText(
                          text: 'Assessment Name',
                          theme: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryVariant
                                      .withOpacity(0.3))),
                      textFormField(
                          scrollController: scrollControlleAssessmentName,
                          isAssessmenttextFormField: true,
                          controller: assessmentController,
                          hintText: 'Assessment Name',
                          validator: (String? value) {
                            return null;
                          },
                          onSaved: (String value) {
                            assessmentNameError.value = value;

                            //To insert the value in the middle of the text
                            // String beforeCursorPosition = assessmentController
                            //     .selection
                            //     .textBefore(assessmentController.text);

                            // String afterCursorPosition = assessmentController
                            //     .selection
                            //     .textAfter(assessmentController.text);

                            // String result = beforeCursorPosition +
                            //     value +
                            //     afterCursorPosition;

                            // assessmentNameError.value = result;
                          }),

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
                                  message: assessmentNameError.value.isEmpty
                                      ? 'Assessment Name Is Required'
                                      : assessmentNameError.value.length < 2
                                          ? 'Assessment Name Should Contains Atleast 2 Characters'
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
                            scrollController: scrollControlleClassName,
                            isAssessmenttextFormField: false,
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
                                  alignment: Alignment.centerLeft,
                                  child: TranslationWidget(
                                      message: classError.value.isEmpty
                                          ? 'Class Is Required'
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
                        ],
                      ),
                      if (widget.classSuggestions.length > 0)
                        SpacerWidget(_KVertcalSpace / 8),
                      if (widget.classSuggestions.length > 0)
                        Container(
                          height: 30,
                          //padding: EdgeInsets.only(left: 2.0),
                          child: ChipsFilter(
                              selectedValue: (String value) {
                                if (value.isNotEmpty) {
                                  classController.text = value;
                                  classError.value = value;
                                }
                              },
                              selected:
                                  1, // Select the second filter as default
                              filters: widget.classSuggestions),
                        ),

                      SpacerWidget(_KVertcalSpace / 2),
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
                      SpacerWidget(_KVertcalSpace / 4),
                      scoringButton(),
                      SpacerWidget(_KVertcalSpace / 3),

                      Row(
                        children: [
                          ValueListenableBuilder(
                              valueListenable: isimageFilePicked,
                              builder: (BuildContext context, dynamic value,
                                  Widget? child) {
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
                                            text: isimageFilePicked.value !=
                                                    true
                                                ? 'Scan Assessment (Optional)'
                                                : 'Assessment Selected',
                                            textTheme: TextStyle(
                                                color: isimageFilePicked
                                                            .value !=
                                                        true
                                                    ? Color(0xff000000) ==
                                                            Theme.of(context)
                                                                .backgroundColor
                                                        ? Color(0xffFFFFFF)
                                                        : Color(0xff000000)
                                                    : AppTheme.kSelectedColor,
                                                fontSize: Globals.deviceType ==
                                                        'phone'
                                                    ? 16
                                                    : 22),
                                          ),
                                          isimageFilePicked.value == true
                                              ? IconButton(
                                                  onPressed: () {
                                                    _cameraImage(context);
                                                  },
                                                  icon: Icon(
                                                    Icons.replay_outlined,
                                                    // : Icons.image_sharp,
                                                    size: Globals.deviceType ==
                                                            'phone'
                                                        ? 20
                                                        : 25,
                                                  ),
                                                  color: isimageFilePicked
                                                              .value !=
                                                          true
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
                                      SpacerWidget(_KVertcalSpace / 8),
                                      CircleAvatar(
                                        //  foregroundColor:  Colors.red,
                                        backgroundImage:
                                            isimageFilePicked.value == true
                                                ? FileImage(imageFile!)
                                                : null,
                                        backgroundColor: AppTheme.kButtonColor,
                                        radius: 30,
                                        child: IconButton(
                                          onPressed: () {
                                            if (isimageFilePicked.value !=
                                                true) {
                                              _cameraImage(context);
                                            } else {
                                              showQuestionImage();
                                            }
                                          },
                                          icon: Icon(
                                            isimageFilePicked.value != true
                                                ? Icons.add
                                                : Icons.check,
                                            // : Icons.image_sharp,
                                            size: Globals.deviceType == 'phone'
                                                ? 25
                                                : 30,
                                          ),
                                          color: isimageFilePicked.value != true
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
                  ),
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
                    onPress: () {
                      widget.customGrades[index] == '+'
                          ? _addSectionBottomSheet()
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
    required onSaved,
    required hintText,
    required validator,
    required bool isAssessmenttextFormField,
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
                      // errorText: isAssessmenttextFormField == true &&
                      //             (controller.text.isEmpty ||
                      //                 assessmentNameError.value.length < 2) ||
                      //         controller.text.isEmpty
                      //     ? ''
                      //     : null,
                      // errorMaxLines: 2,
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
                                .withOpacity(0.5)
                            //  controller.text.isEmpty ||
                            //         assessmentNameError.value.length < 2 ||
                            //         classError.value.isEmpty
                            //     ? Colors.red
                            //     : Theme.of(context).colorScheme.primaryVariant.withOpacity(0.5),
                            ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryVariant
                                .withOpacity(0.5)
                            //  assessmentNameError.value.isEmpty ||
                            //         assessmentNameError.value.length < 2 ||
                            //         classError.value.isEmpty
                            //     ? Colors.red
                            //     : Theme.of(context).colorScheme.primaryVariant.withOpacity(
                            //         0.5) // Theme.of(context).colorScheme.primaryVariant,
                            ),
                      ),
                      contentPadding: EdgeInsets.only(top: 10, bottom: 10),
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
              FocusScope.of(context).requestFocus(FocusNode());
              if (!connected) {
                Utility.currentScreenSnackBar("No Internet Connection");
              } else {
                // if (_formKey.currentState!.validate()) {
                if (assessmentNameError.value.isNotEmpty &&
                    assessmentNameError.value.length > 2 &&
                    classError.value.isNotEmpty) {
                  Globals.assessmentName =
                      "${assessmentController.text}_${classController.text}";
                  //Create excel sheet if not created already for current assessment

                  if (Globals.googleExcelSheetId!.isEmpty) {
                    _googleDriveBloc.add(CreateExcelSheetToDrive(
                        name:
                            "${assessmentController.text}_${classController.text}"));
                  } else if (imageFile != null && imageFile!.path.isNotEmpty) {
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
              }
            },
            label: Row(
              children: [
                BlocListener<GoogleDriveBloc, GoogleDriveState>(
                    bloc: _googleDriveBloc,
                    child: Container(),
                    listener: (context, state) async {
                      if (state is GoogleDriveLoading) {
                        Utility.showLoadingDialog(context, true);
                      }

                      if (state is ExcelSheetCreated) {
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
                      if (state is ErrorState) {
                        if (state.errorMsg == 'Reauthentication is required') {
                          await Utility.refreshAuthenticationToken(
                              isNavigator: true,
                              errorMsg: state.errorMsg!,
                              context: context,
                              scaffoldKey: scaffoldKey);

                          _googleDriveBloc.add(CreateExcelSheetToDrive(
                              name:
                                  "${assessmentController.text}_${classController.text}"));
                        } else {
                          Navigator.of(context).pop();
                          Utility.currentScreenSnackBar(
                              "Something Went Wrong. Please Try Again.");
                        }
                      }
                    }),
                BlocListener<GoogleDriveBloc, GoogleDriveState>(
                    bloc: _googleDriveBloc2,
                    child: Container(),
                    listener: (context, state) async {
                      if (state is GoogleDriveLoading) {
                        Utility.showLoadingDialog(context, true);
                      }

                      if (state is QuestionImageSuccess) {
                        Navigator.of(context).pop();

                        _navigateToSubjectSection(state.questionImageUrl);
                      }
                      if (state is ErrorState) {
                        Navigator.of(context).pop();
                        Utility.currentScreenSnackBar(
                            "Something Went Wrong. Please Try Again.");
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
                isFromHistoryAssessmentScanMore: false,
                onlyForPicture: true,
                isScanMore: false,
                pointPossible: '',
                isFlashOn: ValueNotifier<bool>(false),
              )),
    );
    if (photo != null) {
      imageFile = photo;
      isimageFilePicked.value = false;
      isimageFilePicked.value = true;
    }
  }

  void _navigateToSubjectSection(String? questionImageUrl) async {
    for (int i = 0; i < widget.classSuggestions.length; i++) {
      classController.text == widget.classSuggestions[i]
          ? widget.classSuggestions.removeAt(i)
          : print("nothing ---------->");
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
    Utility.updateLoges(
        activityId: '11',
        description: 'Created G-Excel file',
        operationResult: 'Success');

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SubjectSelection(
                questionimageUrl: questionImageUrl ?? '',
                selectedClass: widget.customGrades[selectedGrade.value],
              )),
    );
  }

  _addSectionBottomSheet() {
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
              sheetHeight:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? MediaQuery.of(context).size.height * 0.82
                      : MediaQuery.of(context).size.height * 0.45,
              valueChanged: (controller) async {
                await updateList(
                  sectionName: controller.text,
                );

                controller.clear();
                Navigator.pop(context, false);
              },
            ));
  }

  updateList({required String sectionName}) async {
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
}
