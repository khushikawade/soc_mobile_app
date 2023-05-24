import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/ui/graded_landing_page.dart';
import 'package:Soc/src/modules/graded_plus/modal/custom_content_modal.dart';
import 'package:Soc/src/modules/graded_plus/ui/graded_plus_navbar_home.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../services/local_database/hive_db_services.dart';
import '../../../translator/translation_widget.dart';

class CustomIntroWidget extends StatefulWidget {
  final bool? isMcqSheet;
  final bool? isFromHelp;
  const CustomIntroWidget({Key? key, this.isMcqSheet, this.isFromHelp})
      : super(key: key);

  @override
  State<CustomIntroWidget> createState() => _CustomIntroWidgetState();
}

class _CustomIntroWidgetState extends State<CustomIntroWidget> {
  CarouselController carouselController = CarouselController();
  HiveDbServices _hiveDbServices = HiveDbServices();

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: CarouselSlider(
            carouselController: carouselController,
            options: CarouselOptions(
                viewportFraction: 1,
                enableInfiniteScroll: false,
                height: MediaQuery.of(context).size.height,
                onPageChanged: (index, value) {
                  setState(() {
                    _currentIndex = index;
                  });
                }),
            items: GradedIntroContentModal.onboardingPagesList.map((i) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      i.imgURL!,
                      fit: BoxFit.contain,
                    ),
                    SpacerWidget(MediaQuery.of(context).size.height / 13),
                    Align(
                        alignment: Alignment.center,
                        child: TranslationWidget(
                          message: i.title!,
                          toLanguage: Globals.selectedLanguage,
                          fromLanguage: "en",
                          builder: (translatedMessage) => Text(
                              translatedMessage,
                              textAlign: TextAlign.center,
                              style:
                                  Theme.of(Globals.navigatorKey.currentContext!)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 23)
                              //defaultSkipButtonTextStyle,
                              ),
                        )),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 11,
                          vertical: 20.0),
                      child: Align(
                          alignment: Alignment.center,
                          child: TranslationWidget(
                            message: i.msgBody!,
                            toLanguage: Globals.selectedLanguage,
                            fromLanguage: "en",
                            builder: (translatedMessage) => Text(
                              translatedMessage,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    fontSize: 15,
                                    letterSpacing: 0.7,
                                    height: 1.5,
                                  ),
                              //defaultSkipButtonTextStyle,
                            ),
                          )),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        Builder(builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.height / 50,
                bottom: MediaQuery.of(context).size.height / 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        map<Widget>(GradedIntroContentModal.onboardingPagesList,
                            (index, url) {
                      return Container(
                        width: 10.0,
                        height: 10.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? AppTheme.kButtonColor
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                ),
                _currentIndex !=
                        GradedIntroContentModal.onboardingPagesList.length - 1
                    ? _button(action: 'Skip')
                    : _button(action: 'Start With Graded+'),
              ],
            ),
          );
        })
      ],
    );
  }

  SizedBox _button({required String? action}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.1,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Material(
          borderRadius: BorderRadius.all(
              Radius.circular(20.0)), //defaultSkipButtonBorderRadius,
          color: AppTheme.kButtonColor,
          child: Visibility(
            visible: widget.isFromHelp != true,
            child: InkWell(
              borderRadius: BorderRadius.all(
                  Radius.circular(20.0)), //defaultSkipButtonBorderRadius,
              onTap: () async {
                if (action != 'Skip') {
                  await _hiveDbServices.addSingleData(
                      'new_user', 'new_user', true);
                  Navigator.pushReplacement<void, void>(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              Overrides.STANDALONE_GRADED_APP == true
                                  ? GradedLandingPage(
                                      isMultipleChoice: widget.isMcqSheet,
                                    )
                                  : GradedPlusNavBarHome()));
                } else {
                  // await FirebaseAnalyticsService.addCustomAnalyticsEvent(
                  //     "walkthrough_skip");
                  carouselController.animateToPage(
                      GradedIntroContentModal.onboardingPagesList.length - 1);
                }
              },
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 17.0,
                      vertical: 5.0), //defaultSkipButtonPadding,
                  child: TranslationWidget(
                    message: action,
                    toLanguage: Globals.selectedLanguage,
                    fromLanguage: "en",
                    builder: (translatedMessage) => Text(
                        translatedMessage == 'Start'
                            ? 'Start With Graded+'
                            : '$translatedMessage',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff000000) ==
                                    Theme.of(context).backgroundColor
                                ? Colors.black
                                : Colors.white)
                        //defaultSkipButtonTextStyle,
                        ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
