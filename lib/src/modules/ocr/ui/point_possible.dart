import 'package:Soc/src/globals.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class PointPossible extends StatefulWidget {
  const PointPossible({Key? key}) : super(key: key);

  @override
  State<PointPossible> createState() => _PointPossibleState();
}

class _PointPossibleState extends State<PointPossible> {
  static const double _KVertcalSpace = 60.0;
  final pointsController = TextEditingController();
  int indexColor = 2;
  int scoringColor = 0;
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
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.height * 0.85
                  : MediaQuery.of(context).size.width * 0.87,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  highlightText(text: 'Points Possible'),
                  SpacerWidget(_KVertcalSpace / 4),
                  smallButton(),
                  SpacerWidget(_KVertcalSpace / 2),
                  highlightText(text: 'Scoring Rubric'),
                  SpacerWidget(_KVertcalSpace / 4),
                  scoringButton(),
                  // SpacerWidget(_KVertcalSpace / 8),
                  cameraButton(),
                ],
              ),
            ),
          ),
        ));
  }

  Widget cameraButton() {
    return InkWell(
      onTap: () {},
      child: CircleAvatar(
          maxRadius: 65,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textwidget(
                text: 'Start',
                textTheme: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              textwidget(
                text: 'Scanning',
                textTheme: Theme.of(context).textTheme.subtitle1,
              ),
              textwidget(
                text: 'Student',
                textTheme: Theme.of(context).textTheme.subtitle1,
              ),
              textwidget(
                text: 'Work',
                textTheme: Theme.of(context).textTheme.subtitle1,
              )
            ],
          )),
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
      width: MediaQuery.of(context).size.width * 0.75,
      // height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            decoration: BoxDecoration(
              color: indexColor == index + 1 ? Colors.orange : null,
              border: Border.all(
                  color: Theme.of(context).colorScheme.primaryVariant),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: TranslationWidget(
              message: '${index + 1}',
              toLanguage: Globals.selectedLanguage,
              fromLanguage: "en",
              builder: (translatedMessage) => Text(
                translatedMessage.toString(),
                style: Theme.of(context).textTheme.headline1,
              ),
            )));
  }

  Widget scoringButton() {
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.40
          : MediaQuery.of(context).size.width * 0.40,
      width: MediaQuery.of(context).size.width * 0.7,
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              childAspectRatio: 5 / 3.5,
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
              child: Container(
                alignment: Alignment.center,
                child: textwidget(
                  text: Globals.scoringList[index],
                  textTheme: Theme.of(context).textTheme.headline2,
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primaryVariant,
                    ),
                    color: scoringColor == index ? Colors.orange : null,
                    borderRadius: BorderRadius.circular(15)),
              ),
            );
          }),
    );
  }

  Widget highlightText({required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: TranslationWidget(
        message: text,
        toLanguage: Globals.selectedLanguage,
        fromLanguage: "en",
        builder: (translatedMessage) => Text(
          translatedMessage.toString(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
    );
  }
}
