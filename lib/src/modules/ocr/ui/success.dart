import 'dart:async';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/ocr/ui/camera_screen.dart';
import 'package:Soc/src/modules/ocr/ui/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/ui/ocr_background_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuccessScreen extends StatefulWidget {
  final String img64;
  final File imgPath;
  final String? pointPossible;
  final bool? isScanMore;
  SuccessScreen(
      {Key? key,
      required this.img64,
      required this.imgPath,
      this.pointPossible,
      this.isScanMore})
      : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  static const double _KVertcalSpace = 60.0;
  OcrBloc _bloc = OcrBloc();
  bool failure = false;
  int? indexColor;
  bool isSelected = true;
  bool onChange = false;
  String studentName = '';
  String studentId = '';
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? pointScored;
  @override
  void initState() {
    super.initState();
    _bloc.add(FetchTextFromImage(
        base64: widget.img64, pointPossible: widget.pointPossible ?? '2'));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(children: [
        CommonBackGroundImgWidget(),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomOcrAppBarWidget(
              isBackButton: false,
              isSuccessState: !failure,
              //isFailureState: failure,
              isHomeButtonPopup: true,
              actionIcon: failure == true
                  ? IconButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (nameController.text.isNotEmpty &&
                              nameController.text.length >= 3 &&
                              idController.text.isNotEmpty) {
                            _bloc.add(SaveStudentDetails(
                                studentName: nameController.text,
                                studentId: idController.text));
                          }
                          // _bloc.add(SaveStudentDetails(studentId: '',studentName: ''));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CameraScreen(
                                        isScanMore: widget.isScanMore,
                                        pointPossible: widget.pointPossible,
                                      )));
                        }
                      },
                      icon: Icon(
                        IconData(0xe877,
                            fontFamily: Overrides.kFontFam,
                            fontPackage: Overrides.kFontPkg),
                        size: 30,
                        color: AppTheme.kButtonColor,
                      ),
                    )
                  : null,
              key: null,
            ),
            body: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: BlocConsumer<OcrBloc, OcrState>(
                  bloc: _bloc, // provide the local bloc instance
                  listener: (context, state) {
                    if (state is FetchTextFromImageSuccess) {
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
                      pointScored = state.grade;

                      nameController.text = state.studentName!;
                      // if (_formKey.currentState!.validate()) {
                      if (nameController.text.isNotEmpty &&
                          nameController.text.length >= 3 &&
                          idController.text.isNotEmpty) {
                        Timer(Duration(seconds: 5), () {
                          updateDetails();
                          // COMMENT below section for enableing the camera
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CameraScreen(
                                      isScanMore: widget.isScanMore,
                                      pointPossible: widget.pointPossible,
                                    )),
                          );
                          //UNCOMMENT below section for enableing the camera

                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (_) => CameraScreen()));
                        });
                      }
                      //}
                      else {
                        setState(() {
                          failure = true;
                        });
                      }
                    } else if (state is FetchTextFromImageFailure) {
                      widget.pointPossible == '2'
                          ? Globals.pointsEarnedList = [0, 1, 2]
                          : widget.pointPossible == '3'
                              ? Globals.pointsEarnedList = [0, 1, 2, 3]
                              : widget.pointPossible == '4'
                                  ? Globals.pointsEarnedList = [0, 1, 2, 3, 4]
                                  : Globals.pointsEarnedList.length = 2;
                      onChange == false
                          ? idController.text = state.studentId ?? ''
                          : state.studentId == ''
                              ? studentId
                              : null;
                      onChange == false
                          ? nameController.text = state.studentName ?? ''
                          : null;
                      pointScored = state.grade;
                      updateDetails();
                      setState(() {
                        failure = true;
                      });
                    }
                    // do stuff here based on BlocA's state
                  },
                  builder: (context, state) {
                    if (state is OcrLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.kButtonColor,
                        ),
                      );
                    } else if (state is FetchTextFromImageSuccess) {
                      // idController.text = state.studentId!;
                      // nameController.text = state.studentName!;
                      // Globals.gradeList.add(state.grade!);
                      return successScreen(
                          id: state.studentId!, grade: state.grade!);
                    } else if (state is FetchTextFromImageFailure) {
                      // idController.text = state.studentId!;
                      // nameController.text =
                      //     onChange == true ? state.studentName! : studentName;
                      Globals.gradeList.add(state.grade!);
                      return failureScreen(
                          id: state.studentId!, grade: state.grade!);
                    }
                    return Container();
                    // return widget here based on BlocA's state
                  }),
            ))
      ]),
    );
  }

  Widget failureScreen({
    required String id,
    required String grade,
  }) {
    return Form(
      key: _formKey,
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpacerWidget(_KVertcalSpace * 0.25),
          Utility.textWidget(
              text: 'Student Name',
              context: context,
              textTheme: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryVariant
                      .withOpacity(0.5))),
          textFormField(
            controller: nameController,
            isFailure: true,
            errormsg: "Make sure to save the record with student name",
            onSaved: (String value) {
              updateDetails(isUpdateData: true);
              studentName = nameController.text;
              onChange = true;
            },
            validator: (value) {},
          ),
          SpacerWidget(_KVertcalSpace / 2),
          Utility.textWidget(
              text: 'Student ID',
              context: context,
              textTheme: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryVariant
                      .withOpacity(0.5))),
          textFormField(
            controller: idController,
            keyboardType: TextInputType.number,
            isFailure: true,
            // errormsg:
            //     "Student Id should not be empty, must start with '2' and contains a '9' digit number.",
            onSaved: (String value) {
              updateDetails(isUpdateData: true);
              studentId = idController.text;
              onChange = true;
            },
            validator: (value) {
              if (value!.length != 9) {
                return 'Student Id must have 9 digit numbers';
              } else if (!value.startsWith('2')) {
                return 'Student Id must starts with \'2\'';
              } else {
                return null;
              }
            },
          ),
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
          Center(child: pointsEarnedButton(grade == '' ? 2 : int.parse(grade))),
          SpacerWidget(_KVertcalSpace / 2),
          Center(child: imagePreviewWidget()),
          SpacerWidget(_KVertcalSpace / 0.9),
          Center(child: textActionButton())
        ],
      ),
    );
  }

  Widget successScreen({required String id, required String grade}) {
    return ListView(
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
          controller: nameController,
          isFailure: false,
          errormsg: "Make sure to save the record with student name",
          onSaved: (String value) {
            updateDetails(isUpdateData: true);
            onChange = true;
          },
          validator: (value) {},
        ),
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
          controller: idController,
          keyboardType: TextInputType.number,
          // errormsg:
          //     "Student Id should not be empty, must start with '2' and contains a '9' digit number.",
          isFailure: false,
          onSaved: (String value) {
            updateDetails(isUpdateData: true);
            onChange = true;
          },
          validator: (String value) {
            if (value.isEmpty) {
              return "Student Id should not be empty, must start with '2' and contains a '9' digit number.";
            } else if (value.length != 9) {
              return 'Student Id must have 9 digit numbers';
            } else if (!value.startsWith('2')) {
              return 'Student Id must starts with \'2\'';
            } else {
              return null;
            }
          },
        ),
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
        Center(child: pointsEarnedButton(int.parse(grade))),
        SpacerWidget(_KVertcalSpace / 2),
        Center(child: imagePreviewWidget()),
        SpacerWidget(_KVertcalSpace / 1.28),
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
      ],
      // ),
    );
  }

  Widget imagePreviewWidget() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      width: MediaQuery.of(context).size.width * 0.58,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.52),
        child: Image.file(
          widget.imgPath,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget pointsEarnedButton(int grade) {
    return Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        child: Globals.pointsEarnedList.length > 4
            ? ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Center(child: pointsButton(index, grade));
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
                        Globals.pointsEarnedList.indexOf(element), grade))
                    .toList(),
              ));
  }

  Widget pointsButton(index, int grade) {
    isSelected ? indexColor = grade : null;

    return InkWell(
        onTap: () {
          pointScored = index.toString();
          updateDetails(isUpdateData: true);
          setState(() {
            isSelected = false;
            indexColor = index;
            // nameController.text = studentName;
            // idController.text = studentId;
            //.text = studentId;
          });
        },
        child: AnimatedContainer(
          duration: Duration(microseconds: 100),
          padding: EdgeInsets.only(
            bottom: 5,
          ),
          decoration: BoxDecoration(
            color: index == indexColor ? AppTheme.kSelectedColor : Colors.grey,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Color(0xff000000) != Theme.of(context).backgroundColor
                    ? Color(0xffF7F8F9)
                    : Color(0xff111C20),
                border: Border.all(
                  color: index == indexColor
                      ? AppTheme.kSelectedColor
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
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                      color: indexColor == index
                          ? AppTheme.kSelectedColor
                          : Colors.grey),
                ),
              )),
        ));
  }

  Widget textFormField(
      {required TextEditingController controller,
      required onSaved,
      required validator,
      TextInputType? keyboardType,
      required bool? isFailure,
      String? errormsg}) {
    return TextFormField(
        autovalidateMode: AutovalidateMode.always,
        // keyboardType: keyboardType ?? null,
        //textAlign: TextAlign.start,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(fontWeight: FontWeight.bold),
        controller: controller,
        cursorColor: Theme.of(context).colorScheme.primaryVariant,
        decoration: InputDecoration(
          errorText: controller.text.isEmpty ? errormsg : null,
          errorMaxLines: 2,
          contentPadding: EdgeInsets.only(top: 10, bottom: 10),
          fillColor: Colors.transparent,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                // color: controller.text.isNotEmpty
                //     ? Theme.of(context)
                //         .colorScheme
                //         .primaryVariant
                //         .withOpacity(0.5)
                //     : Colors.red
                ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                // color: controller.text.isEmpty
                //     ? Theme.of(context)
                //         .colorScheme
                //         .primaryVariant
                //         .withOpacity(0.5)
                //     : Colors.red
                ),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color:
                  Theme.of(context).colorScheme.primaryVariant.withOpacity(0.5),
            ),
          ),
        ),
        onChanged: onSaved,
        //validator: validator
        );
  }

  Widget textActionButton() {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => CameraScreen(
                    isScanMore: widget.isScanMore,
                    pointPossible: widget.pointPossible,
                  )),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.kButtonColor,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        height: 54,
        width: MediaQuery.of(context).size.width * 0.42,
        child: Center(
          child: Utility.textWidget(
            text: 'Retry',
            context: context,
            textTheme: Theme.of(context).textTheme.headline1!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }

  void updateDetails({bool? isUpdateData}) {
    if (isUpdateData == true && Globals.studentInfo != null) {
      Globals.studentInfo!.removeAt(Globals.studentInfo!.length - 1);
      StudentAssessmentInfo studentAssessmentInfo = StudentAssessmentInfo();
      studentAssessmentInfo.studentName = nameController.text;
      studentAssessmentInfo.studentId = idController.text;
      studentAssessmentInfo.studentGrade = pointScored;
      studentAssessmentInfo.pointpossible = Globals.pointpossible;
      //studentAssessmentInfo.assessmentName = Globals.assessmentName;
      Globals.studentInfo!.add(studentAssessmentInfo);
    } else {
      if (Globals.studentInfo == null) {
        final StudentAssessmentInfo studentAssessmentInfo =
            StudentAssessmentInfo();
        studentAssessmentInfo.studentName = nameController.text;
        studentAssessmentInfo.studentId = idController.text;
        studentAssessmentInfo.studentGrade = pointScored;
        studentAssessmentInfo.pointpossible = Globals.pointpossible;
        // studentAssessmentInfo.assessmentName = Globals.assessmentName;
        Globals.studentInfo!.add(studentAssessmentInfo);
      } else {
        List id = [];
        for (int i = 0; i < Globals.studentInfo!.length; i++) {
          id.add(Globals.studentInfo![i].studentId);
        }
        if (!id.contains(idController.text)) {
          StudentAssessmentInfo studentAssessmentInfo = StudentAssessmentInfo();
          studentAssessmentInfo.studentName = nameController.text;
          studentAssessmentInfo.studentId = idController.text;
          studentAssessmentInfo.studentGrade = pointScored;
          studentAssessmentInfo.pointpossible = Globals.pointpossible;
          // studentAssessmentInfo.assessmentName = Globals.assessmentName;
          Globals.studentInfo!.add(studentAssessmentInfo);
        }
      }
    }
  }
}
