import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/ui/create_assessment.dart';
import 'package:Soc/src/modules/ocr/ui/subject_selection.dart';
import 'package:Soc/src/modules/ocr/ui/success.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'camera_screen.dart';

class OpticalCharacterRecognition extends StatefulWidget {
  const OpticalCharacterRecognition({Key? key}) : super(key: key);

  @override
  State<OpticalCharacterRecognition> createState() =>
      _OpticalCharacterRecognitionPageState();
}

class _OpticalCharacterRecognitionPageState
    extends State<OpticalCharacterRecognition> {
  static const double _KVertcalSpace = 60.0;
  final assessmentController = TextEditingController();
  final classController = TextEditingController();
  int indexColor = 2;
  int scoringColor = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          appBarTitle: 'OCR',
          isSearch: true,
          isShare: false,
          language: Globals.selectedLanguage,
          isCenterIcon: false,
          ishtmlpage: false,
          sharedpopBodytext: '',
          sharedpopUpheaderText: '',
        ),
        body: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              highlightText(text: 'Points Possible'),
              SpacerWidget(_KVertcalSpace / 4),
              smallButton(),
              SpacerWidget(_KVertcalSpace / 2),
              highlightText(text: 'Scoring Rubric'),
              SpacerWidget(_KVertcalSpace / 4),
              scoringButton(),
              SpacerWidget(_KVertcalSpace * 1.6),
              cameraButton(),
            ],
          ),
        ));
  }

  Widget cameraButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textwidget(
                text: 'Start Scanning',
                textTheme: Theme.of(context).textTheme.headline1),
            textwidget(
                text: 'Student Work',
                textTheme: Theme.of(context).textTheme.headline6)
          ],
        ),
        IconButton(
          iconSize: 50,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateAssessment()),
            );
          },
          icon: Icon(Icons.camera_alt_rounded),
        )
      ],
    );
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

  Widget smallButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: Globals.icons
            .map<Widget>(
                (element) => pointsButton(Globals.icons.indexOf(element)))
            .toList(),
      ),
    );
  }

  Widget pointsButton(index) {
    return InkWell(
        onTap: () {
          setState(() {
            indexColor = index + 1;
          });
        },
        child: AnimatedContainer(
          padding: EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: indexColor == index + 1
                ? AppTheme.kSelectedColor
                : Colors.grey,
                // Theme.of(context)
                //     .colorScheme
                //     .background.withOpacity(0.2), // indexColor == index + 1 ? AppTheme.kSelectedColor : null,

            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          duration: Duration(microseconds: 100),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                
                //  indexColor == index + 1
                //     ? AppTheme.kSelectedColor
                //     : Theme.of(context).colorScheme.background,
                border: Border.all(
                    color: indexColor == index + 1
                ? AppTheme.kSelectedColor
                : Colors.grey,),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: TranslationWidget(
                message: '${index + 1}',
                toLanguage: Globals.selectedLanguage,
                fromLanguage: "en",
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                      color: indexColor == index + 1
                ? AppTheme.kSelectedColor
                : Theme.of(context).colorScheme.primaryVariant,
                       ),
                ),
              )),
        ));
  }

  Widget scoringButton() {
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.45
          : MediaQuery.of(context).size.width * 0.35,
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? MediaQuery.of(context).size.width * 0.5
                      : MediaQuery.of(context).size.height * 0.5,
              childAspectRatio: 6 / 3.5,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15),
          itemCount: Globals.scoringList.length,
          itemBuilder: (BuildContext ctx, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  scoringColor = index;
                });
              },
              child: AnimatedContainer(
                padding: EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: scoringColor == index
                ? AppTheme.kSelectedColor
                : Colors.grey,
                // Theme.of(context)
                //     .colorScheme
                //     .background.withOpacity(0.2), // indexColor == index + 1 ? AppTheme.kSelectedColor : null,

            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          duration: Duration(microseconds: 100),
                child: Container(
                  // width:Globals.scoringList.length -1 == index ? MediaQuery.of(context).size.width: null,
                  alignment: Alignment.center,
                  child: textwidget(
                    text: Globals.scoringList[index],
                    textTheme: Theme.of(context).textTheme.headline2!.copyWith(
                        color: scoringColor == index
                            ? AppTheme.kSelectedColor
                            : Theme.of(context).colorScheme.primaryVariant),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: scoringColor == index
                            ? AppTheme.kSelectedColor
                            : Colors.grey,
                      ),
                      color:
                          Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            );
          }),
    );
  }

  Widget highlightText({required String text}) {
    return TranslationWidget(
      message: text,
      toLanguage: Globals.selectedLanguage,
      fromLanguage: "en",
      builder: (translatedMessage) => Text(
        translatedMessage.toString(),
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
