import 'dart:async';
import 'dart:io';

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/ocr/ui/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/ui/ocr_home.dart';
import 'package:Soc/src/overrides.dart';
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
  int? indexColor;
  @override
  void initState() {
    // TODO: implement initState
    // Globals.isbottomNavbar = false;
    _bloc.add(FetchTextFromImage(base64: widget.img64!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomOcrAppBarWidget(isBackButton: false),
      // AppBar(
      //   elevation: 0,
      // ),
      body: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child:
              // BlocBuilder<OcrBloc, OcrState>(
              //     bloc: _bloc, // provide the local bloc instance
              //     builder: (context, state) {
              //       if (state is OcrLoading) {
              //         return CircularProgressIndicator(
              //           color: Colors.white,
              //         );
              //       } else if (state is FetchTextFromImageSuccess) {
              //         idController.text = state.schoolId!;
              //         Globals.gradeList.add(state.grade!);
              //         return successScreen(id: state.schoolId!, grade: state.grade!);
              //
              //       }
              //       return Container();
              //     }),

              BlocConsumer<OcrBloc, OcrState>(
                  bloc: _bloc, // provide the local bloc instance
                  listener: (context, state) {
                    if (state is FetchTextFromImageSuccess) {
                      idController.text = state.schoolId!;
                      Globals.gradeList.add(state.grade!);
                      Timer(Duration(seconds: 5), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => OpticalCharacterRecognition()));
                      });
                    }
                    // do stuff here based on BlocA's state
                  },
                  builder: (context, state) {
                    if (state is OcrLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    } else if (state is FetchTextFromImageSuccess) {
                      idController.text = state.schoolId!;
                      Globals.gradeList.add(state.grade!);
                      return successScreen(
                          id: state.schoolId!, grade: state.grade!);
                    }
                    return Container();
                    // return widget here based on BlocA's state
                  })),
    );
  }

  Widget failureScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //  SpacerWidget(_KVertcalSpace / 5),
        highlightText(
            text: 'Scan Failure',
            theme: Theme.of(context).textTheme.headline6!),
        SpacerWidget(_KVertcalSpace / 3),
        highlightText(
            text: 'Student Name',
            theme: Theme.of(context).textTheme.headline4!.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .primaryVariant
                    .withOpacity(0.3))),
        textFormField(controller: nameController, onSaved: (String value) {}),
        SpacerWidget(_KVertcalSpace / 2),
        highlightText(
            text: 'Student Id',
            theme: Theme.of(context).textTheme.headline4!.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .primaryVariant
                    .withOpacity(0.3))),
        textFormField(controller: idController, onSaved: (String value) {}),
        SpacerWidget(_KVertcalSpace / 2),
        Center(
          child: highlightText(
              text: 'Points Earned',
              theme: Theme.of(context).textTheme.headline3!),
        ),
        SpacerWidget(_KVertcalSpace / 4),
        Center(child: smallButton(2)),
        SpacerWidget(_KVertcalSpace / 2),
        Center(child: previewWidget()),
        SpacerWidget(_KVertcalSpace / 2),
      ],
    );
  }

  Widget successScreen({required String id, required String grade}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //  SpacerWidget(_KVertcalSpace / 5),
          highlightText(
              text: 'Student Name',
              theme: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryVariant
                      .withOpacity(0.3))),
          textFormField(controller: nameController, onSaved: (String value) {}),
          SpacerWidget(_KVertcalSpace / 2),
          highlightText(
              text: 'Student Id',
              theme: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryVariant
                      .withOpacity(0.3))),
          textFormField(controller: idController, onSaved: (String value) {}),
          SpacerWidget(_KVertcalSpace / 2),
          highlightText(
              text: 'Points Earned',
              theme: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryVariant
                      .withOpacity(0.3))),
          SpacerWidget(_KVertcalSpace / 4),
          smallButton(int.parse(grade)),
          SpacerWidget(_KVertcalSpace / 2),
          previewWidget(),

          SpacerWidget(_KVertcalSpace / 2.5),
          Container(
              width: MediaQuery.of(context).size.width * 0.5,
              // color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    IconData(0xe878,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    size: 28,
                    color: Colors.green,
                  ),
                  highlightText(
                      text: 'All Good!',
                      theme: Theme.of(context).textTheme.headline6)
                ],
              )),
        ],
      ),
    );
  }

  Widget previewWidget() {
    return Container(
      color: Colors.green,
      height: MediaQuery.of(context).size.height * 0.38,
      width: MediaQuery.of(context).size.width * 0.58,
      child: Image.file(
        widget.imgPath!,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget highlightText({required String text, required theme}) {
    return TranslationWidget(
      message: text,
      toLanguage: Globals.selectedLanguage,
      fromLanguage: "en",
      builder: (translatedMessage) => Text(
        translatedMessage.toString(),
        // maxLines: 2,
        //overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
        style: theme,
      ),
    );
  }

  Widget smallButton(int grade) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      // height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: Globals.pointsEarnedList
            .map<Widget>((element) =>
                pointsButton(Globals.pointsEarnedList.indexOf(element), grade))
            .toList(),
      ),
    );
  }

  Widget pointsButton(index, grade) {
    return InkWell(
        onTap: () {
          setState(() {
            indexColor = index + 1;
          });
        },
        child: AnimatedContainer(
          duration: Duration(microseconds: 100),
          padding: EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: indexColor == index + 1 || index == grade
                ? AppTheme.kSelectedColor
                : Colors.grey,
            // Theme.of(context)
            //     .colorScheme
            //     .background.withOpacity(0.2), // indexColor == index + 1 ? AppTheme.kSelectedColor : null,

            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                border: Border.all(
                  color: indexColor == index + 1 || index == grade
                      ? AppTheme.kSelectedColor
                      : Colors.grey,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: TranslationWidget(
                message: '$index',
                toLanguage: Globals.selectedLanguage,
                fromLanguage: "en",
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                      color: indexColor == index + 1
                          ? AppTheme.kSelectedColor
                          : Colors.grey),
                ),
              )),
        ));
  }

  Widget textFormField(
      {required TextEditingController controller, required onSaved}) {
    return TextFormField(
      //
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline6,
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.primaryVariant,
      decoration: InputDecoration(
        fillColor: Theme.of(context).backgroundColor,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color:
                Theme.of(context).colorScheme.primaryVariant.withOpacity(0.5),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color:
                  Colors.green // Theme.of(context).colorScheme.primaryVariant,
              ),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color:
                Theme.of(context).colorScheme.primaryVariant.withOpacity(0.3),
          ),
        ),
      ),
      onChanged: onSaved,
    );
  }
}
