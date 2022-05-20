import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/ui/assessment_summary.dart';
import 'package:Soc/src/modules/ocr/ui/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/ui/ocr_background_widget.dart';
import 'package:Soc/src/modules/ocr/ui/ocr_home.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class FinishedScreen extends StatefulWidget {
  FinishedScreen({Key? key}) : super(key: key);

  @override
  State<FinishedScreen> createState() => _FinishedScreenState();
}

class _FinishedScreenState extends State<FinishedScreen> {
  @override
  static const double _KVertcalSpace = 60.0;
  int? selectedIndex;
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackGroundImgWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomOcrAppBarWidget(
            isBackButton: false,
          ),
          // AppBar(
          //   elevation: 0,
          //   automaticallyImplyLeading: false,
          //   actions: [
          //     Container(
          //       padding: EdgeInsets.only(right: 10),
          //       child: Icon(
          //         IconData(0xe874,
          //             fontFamily: Overrides.kFontFam,
          //             fontPackage: Overrides.kFontPkg),
          //         color: AppTheme.kButtonColor,
          //       ),
          //     ),
          //   ],
          // ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpacerWidget(_KVertcalSpace / 3),
              Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  // color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      highlightText(
                          text: 'Finished!',
                          theme: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(fontWeight: FontWeight.bold)),
                      Icon(
                        IconData(0xe878,
                            fontFamily: Overrides.kFontFam,
                            fontPackage: Overrides.kFontPkg),
                        size: 30,
                        color: AppTheme.kButtonColor,
                      ),
                    ],
                  )),
              // SpacerWidget(_KVertcalSpace / 3),
              // lineSeparater(),
              SpacerWidget(_KVertcalSpace / 2),
              Center(child: flipButton())
            ],
          ),
        ),
      ],
    );
  }

  Widget flipButton() {
    return Container(
        // padding: EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height * 0.15
            : MediaQuery.of(context).size.width * 0.15,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: Globals.finishedList
              .map<Widget>((element) =>
                  _flipButton(Globals.finishedList.indexOf(element)))
              .toList(),

          // [
          //   Icon(Icons.star_border),
          //   Icon(Icons.star_border),
          //   Icon(Icons.star_border),
          //   Icon(Icons.star_border),
          // ],
        ));
  }

  Widget _flipButton(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AssessmentSummary()),
          );
        } else if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OpticalCharacterRecognition()),
          );
        }
      },
      child: AnimatedContainer(
        padding: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color:
              (selectedIndex == index) ? AppTheme.kSelectedColor : Colors.grey,
          // Theme.of(context)
          //     .colorScheme
          //     .background.withOpacity(0.2), // indexColor == index + 1 ? AppTheme.kSelectedColor : null,

          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        duration: Duration(microseconds: 100),
        child: Container(
          padding: EdgeInsets.all(20),
          width: 170,
          height: 200,
          child: Center(
            child:
                //     Text(
                //   Globals.finishedList[index],
                //   textAlign: TextAlign.center,
                // )
                //
                highlightText(
              text: Globals.finishedList[index],
              theme: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          decoration: BoxDecoration(
              color: Color(0xff000000) != Theme.of(context).backgroundColor
                  ? Color(0xffF7F8F9)
                  : Color(0xff111C20),
              border: Border.all(
                color: (selectedIndex == index)
                    ? AppTheme.kSelectedColor
                    : Colors.grey,
              ),
              // color: scoringColor == index ? Colors.orange : null,
              borderRadius: BorderRadius.circular(8)),
        ),
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
        textAlign: TextAlign.center,
      ),
    );
  }

  // Widget lineSeparater() {
  //   return Container(
  //     width: MediaQuery.of(context).size.width * 0.9,
  //     height: 2,
  //     color: Theme.of(context).colorScheme.primaryVariant,
  //   );
  // }
}
