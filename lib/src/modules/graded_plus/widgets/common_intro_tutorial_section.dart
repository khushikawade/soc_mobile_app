import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/ui/graded_standalone_landing_page.dart';
import 'package:Soc/src/modules/graded_plus/modal/custom_intro_content_modal.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/bottom_navbar_home.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_fab.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/local_database/hive_db_services.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CommonIntroSection extends StatefulWidget {
  final bool? isMcqSheet;
  final bool? backButton;
  final bool? isSkipAndStartButton;
  final List<GradedIntroContentModal> onBoardingInfoList;
  const CommonIntroSection({
    Key? key,
    required this.onBoardingInfoList,
    this.backButton = false,
    this.isMcqSheet,
    this.isSkipAndStartButton = false,
  }) : super(key: key);

  @override
  State<CommonIntroSection> createState() => _CommonIntroSectionState();
}

class _CommonIntroSectionState extends State<CommonIntroSection> {
  CarouselController carouselController = CarouselController();
  ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  List<String> sectionInfo = ['Constructed Response', 'Multiple Choice'];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HiveDbServices _hiveDbServices = HiveDbServices();
  // @override
  // Widget build(BuildContext context) {
  //   return body();
  // }
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CommonBackgroundImgWidget(),
      Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar: appBar(),
        body: body(),
      )
    ]);
  }

  Widget body() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          sectionhHeader(),
          Expanded(
            child: Container(child: carouselSliderBuilder()),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget? appBar() {
    return CustomOcrAppBarWidget(
      plusAppName: 'GRADED+',
      fromGradedPlus: true,
      //Show home button in standard app and hide in standalone
      assessmentDetailPage: Overrides.STANDALONE_GRADED_APP ? true : null,
      isOcrHome: true,
      isSuccessState: ValueNotifier<bool>(true),
      isBackOnSuccess: ValueNotifier<bool>(false),
      key: GlobalKey(),
      isBackButton: Overrides.STANDALONE_GRADED_APP ? true : false,
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
            mainAxisAlignment: MainAxisAlignment.center,
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
              Container(
                height: MediaQuery.of(context).size.height / 6,
                alignment: Alignment.center,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: TranslationWidget(
                    message: item.msgBody ?? '',
                    toLanguage: Globals.selectedLanguage,
                    fromLanguage: "en",
                    builder: (translatedMessage) => Text(
                      translatedMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            letterSpacing: 0.7,
                            height: 1.2,
                          ),
                    ),
                  ),
                ),
              ),
              ValueListenableBuilder<int>(
                  valueListenable: currentIndex,
                  builder:
                      (BuildContext context, dynamic value, Widget? child) {
                    return Container(
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: item.title == 'STEP 2'
                            ? Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Align(
                                      alignment: Alignment.topCenter,
                                      child: FittedBox(
                                        child: TranslationWidget(
                                          message: 'Select assignment type:',
                                          toLanguage: Globals.selectedLanguage,
                                          fromLanguage: "en",
                                          builder: (translatedMessage) => Text(
                                              translatedMessage,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(Globals
                                                      .navigatorKey
                                                      .currentContext!)
                                                  .textTheme
                                                  .headline2!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                        ),
                                      )),
                                  // SpacerWidget(20),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                        sectionInfo.length,
                                        (index) => Expanded(
                                          child: assignmentSectionbutton(
                                            index: index,
                                            sectionInfo: sectionInfo[index],
                                          ),
                                        ),
                                      )),
                                ],
                              )
                            : widget.backButton == true &&
                                    widget.isSkipAndStartButton == true
                                ? currentIndex.value !=
                                        widget.onBoardingInfoList.length - 1
                                    ? skipAndStartButton(action: 'Skip')
                                    : skipAndStartButton(
                                        action: 'Start With Graded+')
                                : null);
                  })
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

  assignmentSectionbutton({required int index, required String sectionInfo}) {
    return GradedPlusCustomFloatingActionButton(
      textTheme: Theme.of(context).textTheme.subtitle2!.copyWith(),
      padding: EdgeInsets.all(10),
      isExtended: true,
      title: sectionInfo,
      backgroundColor: AppTheme.kButtonColor.withOpacity(1.0),
      fabWidth: MediaQuery.of(context).size.width / 3,
      onPressed: () {
        List<GradedIntroContentModal> onBoardingInfoList = [];
        if (index == 0) {
          onBoardingInfoList =
              GradedIntroContentModal.onBoardingConstrutedResponseIndoList;
        } else {
          onBoardingInfoList =
              GradedIntroContentModal.onBoardingMultipleChoiceIndoList;
        }

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => CommonIntroSection(
                      isSkipAndStartButton: widget.isSkipAndStartButton,
                      backButton: true,
                      onBoardingInfoList: onBoardingInfoList,
                    )));
      },
    );
  }

  Row sectionhHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: widget.backButton == true
          ? MainAxisAlignment.start
          : MainAxisAlignment.center,
      children: [
        if (widget.backButton == true)
          Row(
            children: [
              Align(alignment: Alignment.centerLeft, child: backbutton()),
              SizedBox(
                  width: widget.backButton == true
                      ? MediaQuery.of(context).size.width * 0.105
                      : 0.0),
            ],
          ),
        carouselSliderIndicator()
      ],
    );
  }

  Widget backbutton() {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
          IconData(0xe80d,
              fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
          color: AppTheme.kButtonColor),
    );
  }

  Container skipAndStartButton({required String? action}) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Align(
        alignment: Alignment.centerRight,
        child: Material(
          borderRadius: BorderRadius.all(
              Radius.circular(20.0)), //defaultSkipButtonBorderRadius,
          color: AppTheme.kButtonColor,
          child: InkWell(
            borderRadius: BorderRadius.all(
                Radius.circular(20.0)), //defaultSkipButtonBorderRadius,
            onTap: () async {
              if (action != 'Skip') {
                await _hiveDbServices.addSingleData(
                    'is_new_user', 'new_user', true);

//to remove the both Graded+ tutorial pages
                Navigator.of(context)
                  ..pop()
                  ..pop();

// and push to graded+ section
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            Overrides.STANDALONE_GRADED_APP == true
                                ? GradedLandingPage(
                                    isMultipleChoice: false,
                                  )
                                : GradedPlusNavBarHome()));
              } else {
                carouselController
                    .animateToPage(widget.onBoardingInfoList.length - 1);
              }
            },
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 17.0,
                    vertical: 5.0), //defaultSkipButtonPadding,
                child: FittedBox(
                  child: TranslationWidget(
                    message: action,
                    toLanguage: Globals.selectedLanguage,
                    fromLanguage: "en",
                    builder: (translatedMessage) => Text(
                        translatedMessage == 'Start'
                            ? 'Start With Graded+'
                            : '$translatedMessage',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme!.bodyMedium
                        //defaultSkipButtonTextStyle,
                        ),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
