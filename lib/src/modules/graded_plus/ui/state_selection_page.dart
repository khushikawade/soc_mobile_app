import 'dart:async';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/bloc/graded_plus_bloc.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/subject_selection_screen.dart';
import 'package:Soc/src/modules/graded_plus/ui/subject_selection/subject_selection.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/graded_plus/widgets/searchbar_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/bouncing_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StateSelectionPage extends StatefulWidget {
  final bool? isMcqSheet;
  final String? selectedAnswer;
  final bool? isFromCreateAssessmentScreen;
  // final String questionImageUrl;
  final String selectedClass;
  final File? gradedPlusQueImage;
  final IconData? titleIconData;
  const StateSelectionPage(
      {Key? key,
      this.isMcqSheet,
      this.selectedAnswer,
      // required this.questionImageUrl,
      required this.selectedClass,
      this.isFromCreateAssessmentScreen,
      required this.gradedPlusQueImage,
      this.titleIconData})
      : super(key: key);

  @override
  State<StateSelectionPage> createState() => _StateSelectionPageState();
}

class _StateSelectionPageState extends State<StateSelectionPage> {
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  OcrBloc _ocrBloc = OcrBloc();
  final searchController = TextEditingController();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  // List<String> subjectList = [
  //   'Common Core',
  //   'NY Next Generation Learning Standard'
  // ];

  final double _KVertcalSpace = 60.0;

  @override
  void initState() {
    _ocrBloc.add(FetchStateListEvent(
        stateName: "GetAllState",
        fromCreateAssessment: widget.isFromCreateAssessmentScreen ?? false));
    super.initState();
    FirebaseAnalyticsService.addCustomAnalyticsEvent("state_selection_page");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'state_selection_page', screenClass: 'StateSelectionPage');
  }

  @override
  void dispose() {
    _ocrBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        child: Stack(
          children: [
            CommonBackgroundImgWidget(),
            Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              appBar: CustomOcrAppBarWidget(
                commonLogoPath:
                    Color(0xff000000) == Theme.of(context).backgroundColor
                        ? "assets/images/graded+_light.png"
                        : "assets/images/graded+_dark.png",
                refresh: (v) {
                  setState(() {});
                },
                iconData: Icons.add,
                plusAppName: 'GRADED+',
                fromGradedPlus: true,
                isSuccessState: ValueNotifier<bool>(true),
                isBackOnSuccess: isBackFromCamera,
                isBackButton: true,
                key: null,
                isHomeButtonPopup: true,
                customBackButton: IconButton(
                    icon: Icon(
                      IconData(0xe80d,
                          fontFamily: Overrides.kFontFam,
                          fontPackage: Overrides.kFontPkg),
                      color: AppTheme.kButtonColor,
                    ),
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();

                      Navigator.pop(context);
                    }),
              ),
              body: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    height: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? MediaQuery.of(context).size.height * 0.88
                        : MediaQuery.of(context).size.width * 0.80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // padding: EdgeInsets.symmetric(
                      //   horizontal: 20,
                      // ),
                      children: [
                        SpacerWidget(_KVertcalSpace * 0.50),
                        // SpacerWidget(_KVertcalSpace / 3.5),
                        Utility.textWidget(
                          context: context,
                          text: 'Select States',
                          // textTheme: Theme.of(context).textTheme.headline1
                        ),
                        SpacerWidget(_KVertcalSpace / 4),
                        SearchBar(
                            stateName: 'State Search',
                            readOnly: false,
                            controller: searchController,
                            onSaved: (String value) {
                              if (searchController.text.isEmpty) {
                                _ocrBloc.add(FetchStateListEvent(
                                    stateName: "GetAllState",
                                    fromCreateAssessment:
                                        widget.isFromCreateAssessmentScreen ??
                                            false));
                              } else {
                                _ocrBloc.add(LocalStateSearchEvent(
                                    keyWord: searchController.text));
                              }
                            }),
                        SpacerWidget(_KVertcalSpace / 4),
                        BlocConsumer(
                          bloc: _ocrBloc,
                          listener: (context, state) async {
                            if (state is OcrLoading) {
                              Utility.showLoadingDialog(
                                  context: context, isOCR: true);
                            } else if (state
                                is SubjectDetailsListSaveSuccessfully) {
                              Navigator.pop(context);
                              // AnimationController?.dispose();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GradedPluSubjectSelection(
                                          gradedPlusQueImage:
                                              widget.gradedPlusQueImage,
                                          isMcqSheet: widget.isMcqSheet,
                                          selectedAnswer: widget.selectedAnswer,
                                          // isCommonCore: selectedIndex.value == 0
                                          //     ? true
                                          //     : false,
                                          // questionImageUrl:
                                          //     widget.questionImageUrl,
                                          selectedClass: widget.selectedClass,
                                        )),
                              );

                              // _ocrBloc.add(FetchStateListEvent(
                              //     stateName: "GetAllState",
                              //     fromCreateAssesment:
                              //         widget.isFromCreateAssessmentScreen ??
                              //             false));
                            } else if (state is OcrErrorReceived) {
                              Navigator.pop(context);
                            }
                          },
                          builder: (BuildContext context, Object? state) {
                            if (state is OcrLoading2) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppTheme.kButtonColor,
                                  ),
                                ),
                              );
                            } else if (state is StateListFetchSuccessfully) {
                              return ValueListenableBuilder(
                                valueListenable: selectedIndex,
                                builder: (BuildContext context, dynamic value,
                                    Widget? child) {
                                  return buttonListWidget(
                                      list: state.stateList);
                                },
                                child: Container(),
                              );
                            }
                            // Condition to return search List
                            else if (state is LocalStateSearchResult) {
                              return state.stateList.length > 0
                                  ? ValueListenableBuilder(
                                      valueListenable: selectedIndex,
                                      builder: (BuildContext context,
                                          dynamic value, Widget? child) {
                                        return buttonListWidget(
                                            list: state.stateList);
                                      },
                                      child: Container(),
                                    )
                                  : Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      child: NoDataFoundErrorWidget(
                                          isResultNotFoundMsg: false,
                                          isNews: false,
                                          isEvents: false),
                                    );
                            }
                            return Container();
                          },
                          //child: Container(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Widget to build ListView ------------
  Widget buttonListWidget({required List<String> list}) {
    return Container(
      padding: EdgeInsets.only(bottom: 50),
      height: Globals.deviceType == 'phone'
          ? MediaQuery.of(context).size.height * 0.65
          : MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width * 0.9,
      child: RefreshIndicator(
        color: AppTheme.kButtonColor,
        key: refreshKey,
        onRefresh: refreshPage,
        child: ListView.separated(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.03),
          itemCount: list.length,
          itemBuilder: (BuildContext ctx, index) {
            return Column(children: [
              Bouncing(
                child: InkWell(
                  onTap: () async {
                    selectedIndex.value = index;
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.setString('selected_state', list[index]);
                    if (widget.isFromCreateAssessmentScreen == true) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GradedPluSubjectSelection(
                                  gradedPlusQueImage: widget.gradedPlusQueImage,
                                  isMcqSheet: widget.isMcqSheet,
                                  selectedAnswer: widget.selectedAnswer,
                                  stateName: list[index],
                                  // isCommonCore: selectedIndex.value == 0
                                  //     ? true
                                  //     : false,
                                  // questionImageUrl: widget.questionImageUrl,
                                  selectedClass: widget.selectedClass,
                                )),
                      );
                    } else {
                      Utility.currentScreenSnackBar(
                          '\'${list[index]}\' Has Been Updated As Your Current State',
                          null);
                      Timer(Duration(seconds: 2), () {
                        Navigator.pop(context);
                        //isRetryButton.value = true;
                      });
                    }

                    FirebaseAnalyticsService.addCustomAnalyticsEvent(
                        "state_updated_${list[index]}");
                    // _ocrBloc.add(SaveSubjectListDetailsToLocalDb(
                    //     selectedState: list[index]));
                  },
                  child: AnimatedContainer(
                    padding: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      color: selectedIndex.value == index
                          ? AppTheme.kSelectedColor
                          : Colors.grey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    duration: Duration(microseconds: 100),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.centerLeft,
                      child: TranslationWidget(
                        message: list[index],
                        toLanguage: Globals.selectedLanguage,
                        fromLanguage: "en",
                        builder: (translatedMessage) => RichText(
                          text: translatedMessage != null &&
                                  translatedMessage
                                          .toString()
                                          .split(' - ')
                                          .length >
                                      1
                              ? TextSpan(
                                  // Note: Styles for TextSpans must be explicitly defined.
                                  // Child text spans will inherit styles from parent
                                  style: Theme.of(context).textTheme.headline1,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: translatedMessage
                                            .toString()
                                            .split(' - ')[0]
                                            .replaceAll('Â', '')
                                            .replaceAll('U+2612', '')
                                            .replaceAll('⍰', ''), //🖾
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            )),
                                    TextSpan(text: '  '),
                                    TextSpan(
                                      text: translatedMessage
                                          .toString()
                                          .split(' - ')[1]
                                          .replaceAll('Â', '')
                                          .replaceAll('U+2612', '')
                                          .replaceAll('⍰', ''),
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                    ),
                                  ],
                                )
                              : TextSpan(
                                  style: Theme.of(context).textTheme.headline1,
                                  children: [
                                      TextSpan(text: translatedMessage)
                                    ]),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Color(0xff000000) !=
                                  Theme.of(context).backgroundColor
                              ? Color(0xffF7F8F9)
                              : Color(0xff111C20),
                          border: Border.all(
                            color: selectedIndex.value == index
                                ? AppTheme.kSelectedColor
                                : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ),
              index == list.length - 1
                  ? SizedBox(
                      height: 40,
                    )
                  : Container()
            ]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return SpacerWidget(_KVertcalSpace / 3.75);
          },
        ),
      ),
    );
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(
      atTop: false,
    );
    await Future.delayed(Duration(seconds: 2));
    _ocrBloc.add(FetchStateListEvent(
        stateName: "GetAllState",
        fromCreateAssessment: widget.isFromCreateAssessmentScreen ?? false));
  }
}
