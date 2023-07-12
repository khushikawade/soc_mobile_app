import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/modal/custom_intro_content_modal.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CommonIntroSection extends StatefulWidget {
  final bool? backButton;
  final List<GradedIntroContentModal> onBoardingInfoList;
  const CommonIntroSection(
      {Key? key, required this.onBoardingInfoList, this.backButton = false})
      : super(key: key);

  @override
  State<CommonIntroSection> createState() => _CommonIntroSectionState();
}

class _CommonIntroSectionState extends State<CommonIntroSection> {
  CarouselController carouselController = CarouselController();
  ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  List<String> sectionInfo = ['Constructed Response', 'Multiple Choice'];

  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          carouselSliderIndicator(),
          Expanded(
            child: Container(child: carouselSliderBuilder()),
          ),
        ],
      ),
    );
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  CarouselSlider carouselSliderBuilder() {
    return CarouselSlider(
      carouselController: carouselController,
      options: CarouselOptions(
          viewportFraction: 1,
          enableInfiniteScroll: false,
          height: MediaQuery.of(context).size.height,
          onPageChanged: (index, value) {
            currentIndex.value = index;
          }),
      items: widget.onBoardingInfoList.map((GradedIntroContentModal item) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                item.imgURL!,
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height / 3.0,
              ),
              SpacerWidget(40),
              Align(
                  alignment: Alignment.center,
                  child: TranslationWidget(
                    message: item.title ?? '',
                    toLanguage: Globals.selectedLanguage,
                    fromLanguage: "en",
                    builder: (translatedMessage) => Text(translatedMessage,
                        textAlign: TextAlign.center,
                        style: Theme.of(Globals.navigatorKey.currentContext!)
                            .textTheme
                            .headline2!
                            .copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: TranslationWidget(
                  message: item.msgBody ?? '',
                  toLanguage: Globals.selectedLanguage,
                  fromLanguage: "en",
                  builder: (translatedMessage) => Text(
                    translatedMessage,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          letterSpacing: 0.7,
                          height: 1.2,
                        ),
                  ),
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: item.title == 'STEP 2'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            sectionInfo.length,
                            (index) => Expanded(
                              child: buttonDesign(
                                index: index,
                                sectionInfo: sectionInfo[index],
                              ),
                            ),
                          ))
                      : null)
            ],
          ),
        );
      }).toList(),
    );
  }

  Builder carouselSliderIndicator() {
    return Builder(builder: (context) {
      return Padding(
        padding: EdgeInsets.all(10),
        child: ValueListenableBuilder<int>(
            valueListenable: currentIndex,
            builder: (BuildContext context, dynamic value, Widget? child) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          map<Widget>(widget.onBoardingInfoList, (index, url) {
                        return Container(
                          width: 10.0,
                          height: 10.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentIndex.value == index
                                ? AppTheme.kButtonColor
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              );
            }),
      );
    });
  }

  buttonDesign({required int index, required String sectionInfo}) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 50,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              Colors.blue), // Replace with your desired color
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0)), // Adjust the border radius as needed
            ),
          ),
        ),
        onPressed: () {
          // Add your button's onPressed logic here
        },
        child: TranslationWidget(
          message: sectionInfo ?? '',
          toLanguage: Globals.selectedLanguage,
          fromLanguage: "en",
          builder: (translatedMessage) => Text(
            translatedMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(),
          ),
        ),
      ),
    );
  }
}
