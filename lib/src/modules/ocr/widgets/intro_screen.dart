import 'package:Soc/src/modules/ocr/ui/ocr_home.dart';
import 'package:Soc/src/modules/ocr/widgets/ocr_background_widget.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';
import '../../../globals.dart';
import '../../../services/local_database/hive_db_services.dart';

class IntoScreens extends StatefulWidget {
  const IntoScreens({Key? key}) : super(key: key);

  @override
  State<IntoScreens> createState() => _IntoScreensState();
}

class _IntoScreensState extends State<IntoScreens> {
  late int index;

  final onboardingPagesList = [
    CustomPageModel.customPageModel(
        'STEP 1',
        'Assign students a one-question assessment and have them complete it on any paper handout (blank, notebook, graph, etc.).',
        'assets/images/ocr_into_image_1.jpg'),
    CustomPageModel.customPageModel(
        'STEP 2',
        'Ensure students write their name and 9-digit NYCDOE student ID number anywhere on the assessment paper handout. ',
        'assets/images/ocr_into_image_2.png'),
    CustomPageModel.customPageModel(
        'STEP 3',
        'Grade student’s work directly on their paper handout using the selected rubric scale. Be sure to circle the score directly on the student work.',
        'assets/images/ocr_into_image_3.png'),
    CustomPageModel.customPageModel(
        'STEP 4',
        'Grade student’s work directly on their paper handout using the selected rubric scale. Be sure to circle the score directly on the student work.',
        'assets/images/ocr_into_image_4-removebg-preview.png'),
    CustomPageModel.customPageModel(
        'STEP 5',
        'Grade student’s work directly on their paper handout using the selected rubric scale. Be sure to circle the score directly on the student work.',
        'assets/images/ocr_into_image_5-removebg-preview.png')
  ];

  static const width = 100.0;
  @override
  void initState() {
    super.initState();
    index = 0;
  }

  SizedBox _skipButton({void Function(int)? setIndex}) {
    return SizedBox(
      // width: width,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Material(
          borderRadius: defaultSkipButtonBorderRadius,
          color: AppTheme.kButtonColor,
          child: InkWell(
            borderRadius: defaultSkipButtonBorderRadius,
            onTap: () {
              if (setIndex != null) {
                index = 4;
                setIndex(4);
              }
            },
            child: Padding(
              padding: defaultSkipButtonPadding,
              child: Text('Skip',
                  style: TextStyle(
                      fontSize: 15,
                      color:
                          Color(0xff000000) == Theme.of(context).backgroundColor
                              ? Colors.black
                              : Colors.white)
                  //defaultSkipButtonTextStyle,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox get _signupButton {
    return SizedBox(
      // width: width,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Material(
          borderRadius: defaultProceedButtonBorderRadius,
          color: AppTheme.kButtonColor,
          child: InkWell(
            borderRadius: defaultProceedButtonBorderRadius,
            onTap: () async {
              HiveDbServices _hiveDbServices = HiveDbServices();

              await _hiveDbServices.addSingleData('new_user', 'new_user', true);
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        OpticalCharacterRecognition()),
              );
            },
            child: Padding(
              padding: defaultProceedButtonPadding,
              child: Text('Start With Graded+',
                  style: TextStyle(
                      fontSize: 15,
                      color:
                          Color(0xff000000) == Theme.of(context).backgroundColor
                              ? Colors.black
                              : Colors.white)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackGroundImgWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Onboarding(
              pages: onboardingPagesList,
              onPageChange: (int pageIndex) {
                index = pageIndex;
              },
              footerBuilder: (context, dragDistance, pagesLength, setIndex) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      width: 0.0,
                      color: Colors.transparent,
                    ),
                  ),
                  child: ColoredBox(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30.0, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomIndicator(
                            netDragPercent: dragDistance,
                            pagesLength: pagesLength,
                            indicator: Indicator(
                              activeIndicator: ActiveIndicator(
                                  color: Color(0xff000000) ==
                                          Theme.of(context).backgroundColor
                                      ? Colors.white
                                      : Colors.black),
                              closedIndicator:
                                  ClosedIndicator(color: AppTheme.kButtonColor),
                              indicatorDesign: IndicatorDesign.polygon(
                                polygonDesign: PolygonDesign(
                                  polygon: DesignType.polygon_circle,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.8,
                          ),
                          index != pagesLength - 1
                              ? _skipButton(setIndex: setIndex)
                              : _signupButton,
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class CustomPageModel {
  static PageModel customPageModel(
      String? title, String? msgBody, String? imgURL) {
    return PageModel(
        widget: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imgURL!,
            fit: BoxFit.contain,
          ),
          SpacerWidget(
              MediaQuery.of(Globals.navigatorKey.currentContext!).size.height /
                  13),
          Align(
            alignment: Alignment.center,
            child: Text(
              title!,
              style: Theme.of(Globals.navigatorKey.currentContext!)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 23),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(Globals.navigatorKey.currentContext!)
                        .size
                        .width /
                    11,
                vertical: 20.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                msgBody!,
                style: Theme.of(Globals.navigatorKey.currentContext!)
                    .textTheme
                    .headline6!
                    .copyWith(
                      fontSize: 15,
                      letterSpacing: 0.7,
                      height: 1.5,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
