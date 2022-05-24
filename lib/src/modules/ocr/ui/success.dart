import 'dart:async';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/ocr/ui/camera_screen.dart';
import 'package:Soc/src/modules/ocr/ui/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/ui/create_assessment.dart';
import 'package:Soc/src/modules/ocr/ui/ocr_background_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuccessScreen extends StatefulWidget {
  final String? img64;
  final File? imgPath;
  SuccessScreen({Key? key, required this.img64, required this.imgPath})
      : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  final nameController = TextEditingController(text: 'Ben Carney');
  final idController = TextEditingController();
  static const double _KVertcalSpace = 60.0;
  OcrBloc _bloc = OcrBloc();
  bool failure = false;
  int? indexColor;
  bool isSelected = true;
  bool onChange = false;

  String? pointScored;
  @override
  void initState() {
    super.initState();
    _bloc.add(FetchTextFromImage(base64: widget.img64!));
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
              isFailureState: failure,
              isHomeButtonPopup: true,
            ),
            body: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: BlocConsumer<OcrBloc, OcrState>(
                  bloc: _bloc, // provide the local bloc instance
                  listener: (context, state) {
                    if (state is FetchTextFromImageSuccess) {
                      onChange == false
                          ? idController.text = state.schoolId!
                          : null;
                      pointScored = state.grade;

                      Timer(Duration(seconds: 5), () {
                        updateDetails();
                        // COMMENT below section for enableing the camera
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateAssessment()),
                        );
                        //UNCOMMENT below section for enableing the camera

                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (_) => CameraScreen()));
                      });
                    } else if (state is FetchTextFromImageFailure) {
                      onChange == false
                          ? idController.text = state.schoolId ?? ''
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
                      idController.text = state.schoolId!;
                      Globals.gradeList.add(state.grade!);
                      return successScreen(
                          id: state.schoolId!, grade: state.grade!);
                    } else if (state is FetchTextFromImageFailure) {
                      idController.text = state.schoolId!;
                      Globals.gradeList.add(state.grade!);
                      return failureScreen(
                          id: state.schoolId!, grade: state.grade!);
                    }
                    return Container();
                    // return widget here based on BlocA's state
                  }),
            ))
      ]),
    );
  }

  Widget failureScreen({required String id, required String grade}) {
    return ListView(
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
            onSaved: (String value) {
              updateDetails(isUpdateData: true);
              nameController.text = nameController.text;
              onChange = true;
            }),
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
            onSaved: (String value) {
              updateDetails(isUpdateData: true);
              onChange = true;
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
        Center(child: pointsEarnedButton(grade == '' ? 2 : int.parse(grade))),
        SpacerWidget(_KVertcalSpace / 2),
        Center(child: imagePreviewWidget()),
        SpacerWidget(_KVertcalSpace / 0.9),
        Center(child: textActionButton())
      ],
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
            onSaved: (String value) {
              updateDetails(isUpdateData: true);
              onChange = true;
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
            controller: idController,
            keyboardType: TextInputType.number,
            onSaved: (String value) {
              updateDetails(isUpdateData: true);
              onChange = true;
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
          widget.imgPath!,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget pointsEarnedButton(int grade) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: Globals.pointsEarnedList
            .map<Widget>((element) =>
                pointsButton(Globals.pointsEarnedList.indexOf(element), grade))
            .toList(),
      ),
    );
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
          });
        },
        child: AnimatedContainer(
          duration: Duration(microseconds: 100),
          padding: EdgeInsets.only(bottom: 5),
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
                message: '$index',
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
      TextInputType? keyboardType}) {
    return TextFormField(
      keyboardType: keyboardType ?? null,
      textAlign: TextAlign.start,
      style: Theme.of(context)
          .textTheme
          .headline6!
          .copyWith(fontWeight: FontWeight.bold),
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.primaryVariant,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 10, bottom: 10),
        fillColor: Colors.transparent,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color:
                Theme.of(context).colorScheme.primaryVariant.withOpacity(0.5),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              // color:AppTheme.kButtonColor,
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
    );
  }

  Widget textActionButton() {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CameraScreen()),
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
      studentAssessmentInfo.assessmentName = Globals.assessmentName;
      Globals.studentInfo!.add(studentAssessmentInfo);
    } else {
      if (Globals.studentInfo == null) {
        final StudentAssessmentInfo studentAssessmentInfo =
            StudentAssessmentInfo();
        studentAssessmentInfo.studentName = nameController.text;
        studentAssessmentInfo.studentId = idController.text;
        studentAssessmentInfo.studentGrade = pointScored;
        studentAssessmentInfo.pointpossible = Globals.pointpossible;
        studentAssessmentInfo.assessmentName = Globals.assessmentName;
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
          studentAssessmentInfo.assessmentName = Globals.assessmentName;
          Globals.studentInfo!.add(studentAssessmentInfo);
        }
      }
    }
  }
}
