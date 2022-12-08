import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/modal/answer_key_modal.dart';
import 'package:Soc/src/modules/ocr/ui/camera_screen.dart';
import 'package:Soc/src/modules/ocr/widgets/ocr_background_widget.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/common_ocr_appbar.dart';

class MultipleChoiceSection extends StatefulWidget {
  const MultipleChoiceSection({Key? key}) : super(key: key);

  @override
  State<MultipleChoiceSection> createState() => _MultipleChoiceSectionState();
}

class _MultipleChoiceSectionState extends State<MultipleChoiceSection> {
  final ValueNotifier<String> selectedAnswerKey = ValueNotifier<String>('');
  static const double _KVertcalSpace = 60.0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackGroundImgWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomOcrAppBarWidget(
            isSuccessState: ValueNotifier<bool>(true),
            isbackOnSuccess: ValueNotifier<bool>(false),
            key: GlobalKey(),
            isBackButton: true,
          ),
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SpacerWidget(_KVertcalSpace * 0.40),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Utility.textWidget(
                    text: 'Correct Answer Key',
                    context: context,
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                SpacerWidget(_KVertcalSpace / 2),
                //  answerKeyButtons()
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: answerKeyButtons(),
                  ),
                ),
              ]),
          floatingActionButton: floatingActionButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ],
    );
  }

  // Widget textwidget({required String text, required dynamic textTheme}) {
  //   return TranslationWidget(
  //     message: text,
  //     toLanguage: Globals.selectedLanguage,
  //     fromLanguage: "en",
  //     builder: (translatedMessage) => Text(
  //       translatedMessage.toString(),
  //       style: textTheme,
  //     ),
  //   );
  // }

  Widget floatingActionButton() {
    return ValueListenableBuilder(
        valueListenable: selectedAnswerKey,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return FloatingActionButton.extended(
              extendedPadding: EdgeInsets.symmetric(horizontal: 20),
              isExtended: true,
              backgroundColor: selectedAnswerKey.value.isNotEmpty
                  ? AppTheme.kButtonColor.withOpacity(1.0)
                  : Colors.grey.shade400,
              onPressed: () async {
                if (selectedAnswerKey.value.isEmpty) {
                  Utility.currentScreenSnackBar("Select the Answer Key", null);
                } else {
                  Fluttertoast.cancel();
                  navigateToCamera();
                }
              },
              label: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 1.5,
                child: Utility.textWidget(
                    context: context,
                    text: 'Next',
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(color: Theme.of(context).backgroundColor)),
              ));
        });
  }

  void navigateToCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          isFromHistoryAssessmentScanMore: false,
          onlyForPicture: false,
          isScanMore: false,
          pointPossible: Globals.pointpossible,
          isFlashOn: ValueNotifier<bool>(false),
        ),
        // settings: RouteSettings(name: "/home")
      ),
    );
  }

  Widget answerKeyButtons() {
    return ValueListenableBuilder(
        valueListenable: selectedAnswerKey,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return LayoutBuilder(builder: (context, constraints) {
            return new GridView.count(
                childAspectRatio: constraints.biggest.aspectRatio * 3 / 1.7,
                shrinkWrap: true,
                crossAxisCount: 2,
                physics: NeverScrollableScrollPhysics(),
                children: AnswerKeyModal.answerKeyModelList
                    .map((AnswerKeyModal value) {
                  return _buildCircularWidget(value, constraints);
                }).toList());
          });
        });
  }

  Widget _buildCircularWidget(
      AnswerKeyModal value, BoxConstraints constraints) {
    return GestureDetector(
      onTap: () {
        selectedAnswerKey.value = value.title!;
      },
      child: Container(
        height: 100,
        width: 100,
        margin: EdgeInsets.all(constraints.biggest.aspectRatio * 15),
        alignment: Alignment.center,
        child: Utility.textWidget(
          text: value.title!,
          context: context,
          textTheme: Theme.of(context).textTheme.headline6!.copyWith(
              fontWeight: FontWeight.bold,
              color: selectedAnswerKey.value == value.title!
                  ? AppTheme.kSelectedColor
                  : Colors.black),
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: value.title == selectedAnswerKey.value
                  ? AppTheme.kSelectedColor
                  : Colors.transparent,
              width: 1.5,
            ),
            color: value.color),
      ),
    );
  }
}
