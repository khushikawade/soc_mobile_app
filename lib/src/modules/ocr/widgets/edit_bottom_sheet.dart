import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../services/firstLetterUpperCase.dart';

// ignore: must_be_immutable
class EditBottomSheet extends StatefulWidget {
  EditBottomSheet(
      {Key? key,
      this.studentSelection,
      this.selectedAnswer,
      required this.title,
      required this.isMcqSheet,
      required this.isImageField,
      required this.textFieldTitleOne,
      this.textFieldTitleTwo,
      this.textFileTitleThree,
      this.sheetHeight,
      required this.isSubjectScreen,
      required this.pointPossible,
      this.onTap,
      this.valueChanged,
      required this.studentNameController,
      required this.studentEmailIdController,
      required this.studentGradeController,
      required this.update})
      : super(key: key);

  final bool? isImageField;
  final String? selectedAnswer;
  final String? studentSelection;
  final bool? isMcqSheet;
  final String? title;
  final String? textFieldTitleOne;
  final String? textFieldTitleTwo;
  final String? textFileTitleThree;
  final double? sheetHeight;
  final bool? isSubjectScreen;
  final String pointPossible;
  final VoidCallback? onTap;
  final ValueChanged? valueChanged;
  final TextEditingController studentNameController;
  final TextEditingController studentEmailIdController;
  final TextEditingController studentGradeController;
  final Function(
      {required TextEditingController name,
      required TextEditingController id,
      required TextEditingController score,
      String? studentResonance}) update;
  @override
  State<EditBottomSheet> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<EditBottomSheet> {
  final ImagePicker _picker = ImagePicker();
  File? imageFile;
  // final formKey = new GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final GoogleDriveBloc _googleBloc = new GoogleDriveBloc();
  final ValueNotifier<dynamic> indexColor = ValueNotifier<dynamic>(2);
  final ValueNotifier<String> pointScored = ValueNotifier<String>('2');
  final ValueNotifier<bool> rubricNotDetected = ValueNotifier<bool>(false);

  // ScrollController scrollControllerName = new ScrollController();
  // ScrollController scrollControllerId = new ScrollController();

  final ValueNotifier<String> isStudentNameFilled = ValueNotifier<String>('');
  final ValueNotifier<String> isStudentIdFilled = ValueNotifier<String>('');

  List pointsEarnedList = ['A', 'B', 'C', 'D', 'E', 'NA'];
  bool isSelected = true;
  RegExp regex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  void initState() {
    super.initState();
    if (widget.isMcqSheet != true) {
      widget.pointPossible == '3'
          ? pointsEarnedList = ['0', '1', '2', '3']
          : widget.pointPossible == '4'
              ? pointsEarnedList = ['0', '1', '2', '3', '4']
              : pointsEarnedList = ['0', '1', '2'];
    } else {
      pointsEarnedList = ['A', 'B', 'C', 'D', 'E', 'NA'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets / 1.1,
      controller: ModalScrollController.of(context),
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        height: widget.sheetHeight != null
            ? widget.sheetHeight
            : MediaQuery.of(context).orientation == Orientation.landscape
                ? MediaQuery.of(context).size.height * 0.82
                : MediaQuery.of(context).size.height *
                    0.60, //MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Color(0xff000000) != Theme.of(context).backgroundColor
              ? Color(0xffF7F8F9)
              : Color(0xff111C20),
          // borderRadius: BorderRadius.circular(15),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
                FocusScope.of(context).requestFocus(FocusNode());
              },
              icon: Icon(
                Icons.clear,
                color: AppTheme.kButtonColor,
                size: Globals.deviceType == "phone" ? 28 : 36,
              ),
            ),
            Container(
              height: 60,
              decoration: BoxDecoration(
                  border: Border.symmetric(horizontal: BorderSide.none),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15))),
              child: Container(
                alignment: Alignment.center,
                // padding: EdgeInsets.symmetric(vertical: 10),
                child: Utility.textWidget(
                    context: context,
                    text: widget.title!,
                    textTheme: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Color(0xff000000) ==
                                  Theme.of(context).backgroundColor
                              ? Color(0xffFFFFFF)
                              : Color(0xff000000),
                          fontSize: Globals.deviceType == "phone"
                              ? AppTheme.kBottomSheetTitleSize
                              : AppTheme.kBottomSheetTitleSize * 1.3,
                        )),
              ),
            ),
            Form(
              key: _formKey,
              child: Expanded(
                child: ListView(
                  //   physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,

                  children: [
                    widget.textFieldTitleOne != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Utility.textWidget(
                                      context: context,
                                      text: widget.textFieldTitleOne!,
                                      textTheme: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color: Color(0xff000000) ==
                                                    Theme.of(context)
                                                        .backgroundColor
                                                ? Color(0xffFFFFFF)
                                                : Color(0xff000000),
                                          )),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: textFormField(
                                      controller: widget.studentNameController,
                                      hintText: 'Student Name',
                                      inputFormatters: <TextInputFormatter>[
                                        //To capitalize first letter of the textfield
                                        UpperCaseTextFormatter()
                                      ],
                                      // keyboardType: TextInputType.,
                                      isFailure: true,
                                      onSaved: (String value) {},
                                      validator: (String? value) {
                                        isStudentNameFilled.value = value!;
                                        return widget.studentNameController.text
                                                    .isEmpty ||
                                                widget.studentNameController
                                                        .text.length <
                                                    3
                                            ? ''
                                            : null;
                                      }),
                                ),
                                ValueListenableBuilder(
                                    valueListenable:
                                        widget.studentNameController,
                                    // child: Container(),
                                    builder: (BuildContext context,
                                        dynamic value, Widget? child) {
                                      return widget.studentNameController.text
                                                  .length <
                                              3
                                          ? Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 0),
                                              alignment: Alignment.centerLeft,
                                              child: TranslationWidget(
                                                  message: Overrides
                                                                  .STANDALONE_GRADED_APP ==
                                                              true &&
                                                          (widget
                                                              .studentNameController
                                                              .text
                                                              .isEmpty)
                                                      ? 'Student Name is required'
                                                      // : widget.studentNameController
                                                      //             .text.length <
                                                      //         3
                                                      //     ? 'Make Sure The Student Name Contains More Than 3 Character'
                                                      //     : null
                                                      // )?
                                                      : widget.studentNameController
                                                                  .text.length <
                                                              3
                                                          ? 'Make Sure The Student Name Contains More Than 3 Character'
                                                          : null,
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
                                            )
                                          : Container();
                                    }),
                              ])
                        : Container(),
                    widget.textFieldTitleTwo != null
                        ? Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 20, top: 25),
                                    child: Utility.textWidget(
                                        context: context,
                                        text: widget.textFieldTitleTwo!,
                                        textTheme: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                              color: Color(0xff000000) ==
                                                      Theme.of(context)
                                                          .backgroundColor
                                                  ? Color(0xffFFFFFF)
                                                  : Color(0xff000000),
                                            )),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: ValueListenableBuilder(
                                        valueListenable:
                                            widget.studentEmailIdController,
                                        child: Container(),
                                        builder: (BuildContext context,
                                            dynamic value, Widget? child) {
                                          return Wrap(
                                            children: [
                                              textFormField(
                                                  controller: widget
                                                      .studentEmailIdController,
                                                  hintText:
                                                      'Student Id/Student Email',
                                                  inputFormatters: [],
                                                  maxNineDigit:
                                                      Utility.checkForInt(widget
                                                              .studentEmailIdController
                                                              .text)
                                                          ? true
                                                          : false, //true
                                                  isFailure: true,
                                                  onSaved: (String value) {},
                                                  validator: (String? value) {
                                                    return Overrides
                                                                .STANDALONE_GRADED_APP ==
                                                            true
                                                        ?
                                                        //Check email format
                                                        (widget.studentEmailIdController
                                                                .text.isEmpty
                                                            ? ''
                                                            : (!regex.hasMatch(widget
                                                                    .studentEmailIdController
                                                                    .text))
                                                                ? ''
                                                                : null)
                                                        : widget.studentEmailIdController
                                                                .text.isEmpty
                                                            ? ''
                                                            : Utility.checkForInt(
                                                                    widget
                                                                        .studentEmailIdController
                                                                        .text)
                                                                ? (widget.studentEmailIdController.text.length != 9
                                                                    ? ''
                                                                    : (widget.studentEmailIdController.text[0] != '2' && widget.studentEmailIdController.text[0] != '1'
                                                                        ? ''
                                                                        : null))
                                                                : (!regex.hasMatch(widget
                                                                        .studentEmailIdController
                                                                        .text))
                                                                    ? ''
                                                                    : null;
                                                  }),
                                              //Validation Messages
                                              Container(
                                                child: TranslationWidget(
                                                    message: Overrides.STANDALONE_GRADED_APP ==
                                                            true
                                                        ? (widget.studentEmailIdController.text ==
                                                                ''
                                                            ? 'Student Email Is Required'
                                                            : (!regex.hasMatch(widget
                                                                    .studentEmailIdController
                                                                    .text))
                                                                ? 'Please Enter valid Email'
                                                                : '')
                                                        : widget.studentEmailIdController
                                                                .text.isEmpty
                                                            ? 'Please Enter Valid Email ID or Student ID'
                                                            : Utility.checkForInt(widget
                                                                    .studentEmailIdController
                                                                    .text)
                                                                ? (widget.studentEmailIdController.text.length != 9
                                                                    ? 'Student Id should be 9 digit'
                                                                    : (widget.studentEmailIdController.text[0] != '2' && widget.studentEmailIdController.text[0] != '1'
                                                                        ? 'Student Id should be start for 1 or 2'
                                                                        : ''))
                                                                : (!regex.hasMatch(widget
                                                                        .studentEmailIdController
                                                                        .text))
                                                                    ? 'Please Enter valid Email'
                                                                    : '',

                                                    // (isStudentIdFilled.value == ""
                                                    //     ? 'Student ID/Email Is Required'
                                                    //     : ''),
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
                                              ),
                                            ],
                                          );
                                        }),
                                    // _textFiled(
                                    //     // whichContoller: 2,
                                    //     msg:
                                    //         Overrides.STANDALONE_GRADED_APP ==
                                    //                 true
                                    //             ? 'enter a valid Email'
                                    //             : "field is required",
                                    //     controller:
                                    //         widget.studentEmailIdController)
                                  ),
                                  if (Overrides.STANDALONE_GRADED_APP == true)
                                    SizedBox(
                                      height: 20,
                                    )
                                ]),
                          )
                        : Container(),
                    SpacerWidget(8),
                    widget.textFileTitleThree != null
                        ? Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: Utility.textWidget(
                                        context: context,
                                        text: widget.textFileTitleThree!,
                                        textTheme: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                              color: Color(0xff000000) ==
                                                      Theme.of(context)
                                                          .backgroundColor
                                                  ? Color(0xffFFFFFF)
                                                  : Color(0xff000000),
                                            )),
                                  ),
                                  // widget.isMcqSheet == true
                                  //     ?
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: pointsEarnedButton(
                                        widget.studentSelection,
                                        isSuccessState: true),
                                  )
                                  // : Container(
                                  //     padding: EdgeInsets.symmetric(
                                  //         horizontal: 20),
                                  //     child: _textFiled(
                                  //         // whichContoller: 3,
                                  //         keyboardType:
                                  //             TextInputType.number,
                                  //         maxNineDigit: 1,
                                  //         msg: "field is required ",
                                  //         controller: widget
                                  //             .studentGradeController)),
                                ]),
                          )
                        : Container(),
                    widget.isImageField!
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Utility.textWidget(
                                      context: context,
                                      text: 'Add Image',
                                      textTheme: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color: Color(0xff000000) ==
                                                    Theme.of(context)
                                                        .backgroundColor
                                                ? Color(0xffFFFFFF)
                                                : Color(0xff000000),
                                          )),
                                ),
                                SpacerWidget(5),
                                SpacerWidget(10),
                                InkWell(
                                  onTap: () {
                                    showActionsheet(context);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 40,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          border: Border.all(
                                              width: 2,
                                              color: Colors.grey.shade200),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      // color: Colors.grey.shade200,

                                      height: 115,
                                      width: MediaQuery.of(context).size.width,
                                      child: imageFile != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.file(
                                                imageFile!,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            )
                                          : Container(
                                              child: Center(
                                                child: Icon(
                                                  Icons.add_a_photo,
                                                  color: AppTheme.kButtonColor
                                                      .withOpacity(1.0),
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ])
                        : Container(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                      child: FloatingActionButton.extended(
                          backgroundColor:
                              AppTheme.kButtonColor.withOpacity(1.0),
                          onPressed: () async {
                            //  dnakhfkahj
                            if (_formKey.currentState!.validate()) {
                              widget.studentGradeController.text =
                                  widget.isMcqSheet == true
                                      ? (widget.selectedAnswer ==
                                              indexColor.value.toString()
                                          ? '1'
                                          : '0')
                                      : widget.studentGradeController.text;
                              widget.update(
                                  name: widget.studentNameController,
                                  id: widget.studentEmailIdController,
                                  score: widget.studentGradeController,
                                  studentResonance: widget.isMcqSheet == true
                                      ? indexColor.value.toString()
                                      : 'NA');
                            }
                          },
                          label: Row(
                            children: [
                              Utility.textWidget(
                                  text: 'Update',
                                  context: context,
                                  textTheme: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .backgroundColor)),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pointsEarnedButton(dynamic grade, {required bool isSuccessState}) {
    return FittedBox(
      child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          child: pointsEarnedList.length > 4
              ? ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                        child: pointsButton(
                            widget.isMcqSheet == true
                                ? pointsEarnedList[index]
                                : index,
                            grade,
                            isSuccessState: isSuccessState));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 12,
                    );
                  },
                  itemCount: pointsEarnedList.length)
              : Row(
                  // scrollDirection: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: pointsEarnedList
                      .map<Widget>((element) => pointsButton(
                          pointsEarnedList.indexOf(element), grade,
                          isSuccessState: true))
                      .toList(),
                )),
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
              return InkWell(
                  onTap: () {
                    // updateDetails(isUpdateData: true);
                    Utility.updateLogs(
                        // ,
                        activityId: '8',
                        description:
                            'Teacher change score rubric \'${pointScored.value.toString()}\' to \'${index.toString()}\'',
                        operationResult: 'Success');
                    pointScored.value = index.toString();
                    widget.studentGradeController.text = index.toString();
                    // if (isSuccessState) {}
                    isSelected = false;
                    rubricNotDetected.value = false;
                    indexColor.value = index.toString();
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
                        height: //pointsEarnedList.length>3?
                            widget.isMcqSheet == true
                                ? MediaQuery.of(context).size.height *
                                    //  0.085, //:MediaQuery.of(context).size.height*0.2,
                                    0.075
                                : MediaQuery.of(context).size.height * 0.085,
                        width:
                            //pointsEarnedList.length>3?
                            widget.isMcqSheet == true
                                ? MediaQuery.of(context).size.width * 0.14
                                : MediaQuery.of(context).size.width * 0.17,
                        //:MediaQuery.of(context).size.width*0.2,
                        padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical:
                                10), //horizontal: pointsEarnedList.length>3?20:30
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
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: TranslationWidget(
                          message: widget.isMcqSheet == true
                              ? index
                              : pointsEarnedList[index].toString(),
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
                                        ? (index.toString() ==
                                                widget.selectedAnswer
                                            ? Colors.green.shade300
                                            : indexColor.value == index
                                                ? Colors
                                                    .red //AppTheme.kSelectedColor
                                                : Colors.grey)
                                        : (indexColor.value == index.toString()
                                            ? AppTheme.kSelectedColor
                                            : Colors.grey)),
                          ),
                        )),
                  ));
            },
          );
        });
  }

  showActionsheet(context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text(
                "Camera",
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                _cameraImage(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text(
                "Gallery",
                style: TextStyle(color: Colors.blue),
              ),
              isDestructiveAction: true,
              onPressed: () {
                _imgFromGallery(context);
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
          )),
    );
  }

  Future<void> _cameraImage(BuildContext context) async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        imageFile = File(photo.path);

        Navigator.pop(context);
      });
    } else {
      Navigator.pop(context);
    }
  }

  _imgFromGallery(BuildContext context) async {
    XFile? image = (await _picker.pickImage(
      source: ImageSource.gallery,
    ));
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
        Navigator.pop(context);
      });
    } else {
      Navigator.pop(context);
    }
  }

  Widget _textFiled({
    required int whichContoller,
    required String msg,
    required TextEditingController controller,
    int? maxNineDigit,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      keyboardType: keyboardType ?? null,
      maxLength: maxNineDigit ?? null,
      textInputAction: TextInputAction.next,
      inputFormatters: keyboardType == null
          ? <TextInputFormatter>[]
          : <TextInputFormatter>[
              //To capitalize first letter of the textfield
              UpperCaseTextFormatter()
            ],

      validator: (text) {
        if (text == null || text.isEmpty) {
          return msg;
        }

        return null;
      },

      autofocus: false,
      textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.subtitle1!.copyWith(
            fontWeight: FontWeight.bold,
          ),
      controller: controller,
      cursorColor: //Theme.of(context).colorScheme.primaryVariant,
          Color(0xff000000) == Theme.of(context).backgroundColor
              ? Color(0xffFFFFFF)
              : Color(
                  0xff000000), //Theme.of(context).colorScheme.primaryVariant,
      decoration: InputDecoration(
        counterStyle: TextStyle(
            color: Color(0xff000000) == Theme.of(context).backgroundColor
                ? Color(0xffFFFFFF)
                : Color(0xff000000)),
        fillColor: Colors.transparent,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.kButtonColor,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme
                .kButtonColor, // Theme.of(context).colorScheme.primaryVariant,
          ),
        ),
        contentPadding: EdgeInsets.only(top: 10, bottom: 10),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.kButtonColor,
          ),
        ),
      ),
      onChanged: (vlaue) {},
    );
  }

  Widget textFormField({
    required TextEditingController controller,
    onSaved,
    required validator,
    TextInputType? keyboardType,
    required bool? isFailure,
    String? errormsg,
    List<TextInputFormatter>? inputFormatters,
    bool? maxNineDigit,
    String? hintText,
  }) {
    return ValueListenableBuilder(
        valueListenable: controller,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return ValueListenableBuilder(
              valueListenable: controller,
              child: Container(),
              builder: (BuildContext context, dynamic value, Widget? child) {
                if (controller.text.length != 0) {
                  //!=0
                  controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length));
                }

                return TextFormField(
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
                    textAlign: TextAlign.start,
                    inputFormatters:
                        inputFormatters == null ? null : inputFormatters,
                    autovalidateMode: AutovalidateMode.always,
                    keyboardType: keyboardType ?? null,
                    //        //textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    controller: controller,
                    cursorColor: Theme.of(context).colorScheme.primaryVariant,
                    decoration: InputDecoration(
                      counterStyle: TextStyle(
                          color: Color(0xff000000) ==
                                  Theme.of(context).backgroundColor
                              ? Color(0xffFFFFFF)
                              : Color(0xff000000)),
                      fillColor: Colors.transparent,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppTheme.kButtonColor,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppTheme
                              .kButtonColor, // Theme.of(context).colorScheme.primaryVariant,
                        ),
                      ),
                      contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppTheme.kButtonColor,
                        ),
                      ),
                    ),
                    onChanged: onSaved,
                    validator: validator);
              });
        });
  }
}
