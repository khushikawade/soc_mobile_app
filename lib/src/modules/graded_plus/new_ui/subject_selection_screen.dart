import 'dart:async';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/bloc/google_classroom_bloc.dart';
import 'package:Soc/src/modules/google_classroom/google_classroom_globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/graded_plus/bloc/graded_plus_bloc.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_plus_utilty.dart';
import 'package:Soc/src/modules/graded_plus/modal/assessment_status_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/custom_rubic_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/state_object_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/subject_details_modal.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/graded_plus_subject_search_screen.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/results_summary.dart';
import 'package:Soc/src/modules/graded_plus/widgets/bottom_sheet_widget.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/graded_plus/widgets/searchbar_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/bouncing_widget.dart';
import 'package:Soc/src/widgets/debouncer.dart';
import 'package:Soc/src/widgets/graded_globals.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

class GradedPluSubjectSelection extends StatefulWidget {
  final bool? isMcqSheet;
  final String? selectedAnswer;
  final String? selectedClass;
  final String? subjectId;
  final String? stateName;
  final bool? isSearchPage;
  final String? domainNameC;
  final String? searchClass;
  final String? selectedSubject;
  // final String? questionImageUrl;
  final bool? isCommonCore;
  final File? gradedPlusQueImage;
  GradedPluSubjectSelection(
      {Key? key,
      this.stateName,
      this.subjectId,
      required this.selectedClass,
      this.isSearchPage,
      this.domainNameC,
      this.searchClass,
      this.selectedSubject,
      // required this.questionImageUrl,
      this.isCommonCore,
      this.isMcqSheet,
      this.selectedAnswer,
      required this.gradedPlusQueImage})
      : super(key: key);

  @override
  State<GradedPluSubjectSelection> createState() => _SubjectSelectionState();
}

class _SubjectSelectionState extends State<GradedPluSubjectSelection> {
  GoogleDriveBloc googleBloc = GoogleDriveBloc();
  GoogleDriveBloc excelSheetBloc = GoogleDriveBloc();
  GoogleDriveBloc googleSlideBloc = GoogleDriveBloc();
  GoogleClassroomBloc _googleClassroomBloc = new GoogleClassroomBloc();
  OcrBloc ocrAssessmentBloc = OcrBloc();
  //Used to fetch subject details
  OcrBloc _ocrBloc = OcrBloc();
  bool allProcessDone = false;

//---------------------------------------------------------------------------------------------------------------
  static const double _KVerticalSpace = 60.0;
  final searchController = TextEditingController();
  final addController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _debouncer = Debouncer(milliseconds: 10);
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

//---------------------------------------------------------------------------------------------------------------
  List<String> userAddedSubjectList = [];
  String? selectedKeyword;
  String? keywordSub;
  String? subject;
  String? learningStandard;
  String? subLearningStandard;
  String? subjectId;
  String? standardId;
  String? standardDescription;

  StateSetter? showDialogSetState;

//---------------------------------------------------------------------------------------------------------------
  // new part of code
  final ValueNotifier<int> pageIndex = ValueNotifier<int>(0);
  final ValueNotifier<int> subjectIndex1 =
      ValueNotifier<int>(-1); //To bypass the default selection
  final ValueNotifier<int> nycIndex1 =
      ValueNotifier<int>(-1); //To bypass the default selection
  final ValueNotifier<int> nycSubIndex1 =
      ValueNotifier<int>(-1); //To bypass the default selection
  final ValueNotifier<bool> isSubmitButton = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isSkipButton = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);
  // Value Notifier to check which is update or not
  ValueNotifier<AssessmentStatusModel> assessmentExportAndSaveStatus =
      ValueNotifier<AssessmentStatusModel>(AssessmentStatusModel(
          excelSheetPrepared: false,
          slidePrepared: false,
          saveAssessmentResultToDashboard: false,
          saveGoogleClassroom: true));

  List<String> processList = [
    'Google Sheet',
    'Google Slides',
    'Google Classroom',
    '${Globals.schoolDbnC} Dashboard'
  ];

//---------------------------------------------------------------------------------------------------------------
  LocalDatabase<StudentAssessmentInfo> _studentAssessmentInfoDb =
      LocalDatabase('student_info');
  LocalDatabase<SubjectDetailList> subjectRecentOptionDB =
      LocalDatabase('recent_option_subject');
  LocalDatabase<SubjectDetailList> learningRecentOptionDB =
      LocalDatabase('recent_option_learning_standard');

  //---------------------------------------------------------------------------------------------------------------

  @override
  initState() {
    // To Fetch Subject Name According to state selection

    // SubjectSelectionAPIAndMethods.googleSlidesPreparation();
    //  googleSlidesPreparation();
    isSkipButton.value = true;
    if (widget.isSearchPage == true) {
      //    isSkipButton.value = true;
      _ocrBloc.add(FetchSubjectDetails(
          stateName: widget.stateName,
          subjectId: widget.subjectId,
          type: 'nycSub',
          selectedKeyword: widget.domainNameC,
          grade: widget.selectedClass,
          subjectSelected: widget.selectedSubject));
    } else {
      if (!Overrides.STANDALONE_GRADED_APP) {
        // get state subject list if school or default new york state

        _ocrBloc.add(FetchStateListEvent(
            fromCreateAssessment: false, stateName: widget.stateName));
      } else {
        //Fetch all data state wise // Standalone
        fetchSubjectDetails('subject', widget.selectedClass,
            widget.selectedClass, widget.stateName, '', '');
      }

      // if user come from state selection page or create assessment page
    }
    //isSkipButton.value = true;

    super.initState();
    FirebaseAnalyticsService.addCustomAnalyticsEvent("subject_selection");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'subject_selection', screenClass: 'SubjectSelection');
  }

  @override
  void dispose() {
    //_googleDriveBloc.close();
    // TODO: implement dispose
    super.dispose();
  }

  // back button widget on subject selection page at appBar -------
  Widget backButtonWidget() {
    return IconButton(
      padding: EdgeInsets.all(0),
      icon: Icon(
        IconData(0xe80d,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        color: AppTheme.kButtonColor,
      ),
      onPressed: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        // Change pages according to current page position on back press ..
        if (pageIndex.value == 1) {
          learningStandard = '';
          isSkipButton.value = true;
          nycIndex1.value = -1;
          subjectIndex1.value = 0;
          isSubmitButton.value = false;

          fetchSubjectDetails('subject', widget.selectedClass,
              widget.selectedClass, widget.stateName, '', '');

          // _ocrBloc.add(FetchSubjectDetails(
          //     type: 'subject',
          //     selectedKeyword: widget.selectedClass,
          //     grade: widget.selectedClass,
          //     stateName: widget.stateName,
          //     subjectId: '',
          //     subjectSelected: ''));
        } else if (pageIndex.value == 2) {
          nycSubIndex1.value = -1;
          nycIndex1.value = 0;
          learningStandard = '';
          standardDescription = '';
          subLearningStandard = '';
          isSubmitButton.value = false;
          isSkipButton.value = true;

          if (widget.isSearchPage == true) {
            Navigator.pop(context);
          } else {
            _ocrBloc.add(FetchSubjectDetails(
              type: 'nyc',
              selectedKeyword: selectedKeyword,
              grade: widget.selectedClass,
              stateName: widget.stateName,
              subjectId: subjectId,
              subjectSelected: subject,
            ));
          }
        } else {
          Navigator.pop(context);
        }
      },
    );
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
                bottomNavigationBar: progressIndicatorBar(),
                floatingActionButton: saveToDriveButton(),
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset: false,
                appBar: CustomOcrAppBarWidget(
                  fromGradedPlus: true,
                  hideStateSelection: true,
                  onTap: () {
                    Utility.scrollToTop(scrollController: _scrollController);
                  },
                  isSuccessState: ValueNotifier<bool>(true),
                  isBackOnSuccess: isBackFromCamera,
                  isBackButton: true,
                  key: null,
                  isHomeButtonPopup: true,
                  customBackButton: backButtonWidget(),
                ),
                body: mainBodyWidget()),
            googleBlocListener(),
            excelBlocListener(),
            slideBlocListener(),
            classRoomBlocListener(),
            ocrAssessmentBlocListener(),
            subjectBlocListener()
          ],
        ),
      ),
    );
  }

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  // Search Bar widget with there conditions -----------
  Widget searchWidget() {
    return ValueListenableBuilder(
        valueListenable: pageIndex,
        builder: (BuildContext context, dynamic value, Widget? child) {
          return pageIndex.value == 0
              ? Container()
              : SearchBar(
                  stateName: widget.stateName!,
                  isSubLearningPage: pageIndex.value == 2 ? true : false,
                  readOnly: false,
                  onTap: () {
                    // In case of Domain search it will navigated to SearchPage
                    if (pageIndex.value == 1) {
                      FocusManager.instance.primaryFocus?.unfocus();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GradedPlusSearchScreenPage(
                                  gradedPlusQueImage: widget.gradedPlusQueImage,
                                  isMcqSheet: widget.isMcqSheet,
                                  selectedAnswer: widget.selectedAnswer,
                                  // questionImage: widget.questionImageUrl ?? '',
                                  selectedKeyword: selectedKeyword,
                                  grade: widget.selectedClass,
                                  selectedSubject: subject,
                                  stateName: widget.stateName,
                                  subjectId: subjectId,
                                  googleDriveBloc: googleBloc,
                                  googleClassroomBloc: _googleClassroomBloc,
                                )),
                      );
                    }
                  },
                  suffixIcon: InkWell(
                    onTap: () {
                      searchController.clear();
                      _ocrBloc.add(FetchSubjectDetails(
                          stateName: widget.stateName,
                          subjectId: subjectId,
                          type: 'nycSub',
                          selectedKeyword: keywordSub,
                          grade: widget.selectedClass,
                          subjectSelected: subject));
                    },
                    child: Icon(
                      Icons.clear,
                      color: Theme.of(context).colorScheme.primaryVariant,
                      size: Globals.deviceType == "phone" ? 20 : 28,
                    ),
                  ),
                  controller: searchController,
                  onSaved: (String value) {
                    if (searchController.text.isEmpty && pageIndex.value != 1) {
                      // Fetch whole data related to perticular Domain in case of search field is empty
                      _ocrBloc.add(FetchSubjectDetails(
                          stateName: widget.stateName,
                          subjectId: subjectId,
                          type: 'nycSub',
                          selectedKeyword: keywordSub,
                          grade: widget.selectedClass,
                          subjectSelected: subject));
                      // setState(() {});
                    } else {
                      // search according to text and return the data
                      _debouncer.run(() async {
                        _ocrBloc.add(SearchSubjectDetails(
                            stateName: widget.stateName!,
                            searchKeyword: searchController.text,
                            type: 'nycSub',
                            selectedKeyword: keywordSub,
                            grade: widget.selectedClass,
                            subjectSelected: subject));
                        setState(() {});
                      });
                    }

                    if (pageIndex.value == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GradedPlusSearchScreenPage(
                                  gradedPlusQueImage: widget.gradedPlusQueImage,
                                  isMcqSheet: widget.isMcqSheet,
                                  selectedAnswer: widget.selectedAnswer,
                                  // questionImage: widget.questionImageUrl ?? '',
                                  selectedKeyword: selectedKeyword,
                                  grade: widget.selectedClass,
                                  selectedSubject: subject,
                                  stateName: widget.stateName,
                                  subjectId: subjectId,
                                  googleClassroomBloc: _googleClassroomBloc,
                                  googleDriveBloc: googleBloc,
                                )),
                      );
                    }
                  });
        });
  }

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  // main body structure of the page----------------
  Widget mainBodyWidget() {
    return Container(
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height * 0.85
            : MediaQuery.of(context).size.width * 0.80,
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          children: [
            SpacerWidget(StudentPlusOverrides.KVerticalSpace / 10),
            titleWidget(),
            SpacerWidget(_KVerticalSpace / 3.5),
            searchWidget(),
            SpacerWidget(_KVerticalSpace / 4),
            ValueListenableBuilder(
                valueListenable: pageIndex,
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return pageIndex.value == 1
                      ? searchDomainText()
                      : Container();
                }),
            SpacerWidget(_KVerticalSpace / 4),
            blocBuilderWidget(),
          ],
        ));
  }

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  Widget blocBuilderWidget() {
    return BlocBuilder<OcrBloc, OcrState>(
        bloc: _ocrBloc,
        builder: (context, state) {
          if (state is SubjectDataSuccess) {
            state.obj!.forEach((element) {
              if (element.dateTime != null) {
                state.obj!.sort((a, b) => DateTime.parse(b.dateTime.toString())
                    .compareTo(DateTime.parse(a.dateTime.toString())));
              }
            });
            // state.obj!.forEach((element) { userAddedSubjectList.add(element.subjectNameC!);});

            return gridButtonsWidget(
                list: state.obj!, page: 0, isSubjectScreen: true);
          } else if (state is NycDataSuccess) {
            state.obj.removeWhere((element) => element.domainNameC == null);
            state.obj.forEach((element) {
              if (element.dateTime != null) {
                state.obj.sort((a, b) => DateTime.parse(b.dateTime.toString())
                    .compareTo(DateTime.parse(a.dateTime.toString())));
              }
            });

            return state.obj.length > 0
                ? gridButtonsWidget(
                    list: state.obj, page: 1, isSubjectScreen: false)
                : Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: NoDataFoundErrorWidget(
                      marginTop: MediaQuery.of(context).size.height * 0.1,
                      //errorMessage: 'No Domain Found',
                      isResultNotFoundMsg: false,
                      isNews: false,
                      isEvents: false,
                    ),
                  );
          } else if (state is NycSubDataSuccess) {
            state.obj!.forEach((element) {
              if (element.domainCodeC != null) {
                state.obj!.sort((a, b) => a.name!.compareTo(b.name!));
              }
            });

            return buttonListWidget(list: state.obj!);
          } else if (state is SearchSubjectDetailsSuccess) {
            List<SubjectDetailList> list = [];
            if (pageIndex.value == 0) {
              state.obj!.forEach((element) {
                if (element.subjectNameC != null) {
                  state.obj!.sort(
                      (a, b) => a.subjectNameC!.compareTo(b.subjectNameC!));
                }
              });

              for (int i = 0; i < state.obj!.length; i++) {
                if (state.obj![i].subjectNameC!
                    .toUpperCase()
                    .contains(searchController.text.toUpperCase())) {
                  list.add(state.obj![i]);
                }
              }
            } else if (pageIndex.value == 1) {
              state.obj!.forEach((element) {
                if (element.domainNameC != null) {
                  state.obj!
                      .sort((a, b) => a.domainNameC!.compareTo(b.domainNameC!));
                }
              });

              for (int i = 0; i < state.obj!.length; i++) {
                if (state.obj![i].domainNameC!
                    .toUpperCase()
                    .contains(searchController.text.toUpperCase())) {
                  list.add(state.obj![i]);
                }
              }
            } else if (pageIndex.value == 2) {
              state.obj!.forEach((element) {
                if (element.domainCodeC != null) {
                  state.obj!
                      .sort((a, b) => a.domainCodeC!.compareTo(b.domainCodeC!));
                }
              });

              for (int i = 0; i < state.obj!.length; i++) {
                if (state.obj![i].standardAndDescriptionC!
                    .toUpperCase()
                    .contains(searchController.text.toUpperCase())) {
                  list.add(state.obj![i]);
                }
              }
            }

            return pageIndex.value == 0
                ? gridButtonsWidget(list: list, page: 0, isSubjectScreen: true)
                : pageIndex.value == 1
                    ? gridButtonsWidget(
                        list: list, page: 1, isSubjectScreen: false)
                    : buttonListWidget(list: list);
          } else if (state is OcrLoading) {
            // loading when user fetch subject detail first time
            return pageIndex.value == 2
                ? Container()
                : Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                        child: Globals.isAndroid == true
                            ? CircularProgressIndicator(
                                color: AppTheme.kButtonColor,
                              )
                            : CupertinoActivityIndicator(
                                radius: 20, color: AppTheme.kButtonColor)),
                  );
          }
          // else if (state is OcrLoading2) {
          //   return Container(
          //     height: MediaQuery.of(context).size.height * 0.6,
          //     child: Center(
          //         child: Globals.isAndroid == true
          //             ? CircularProgressIndicator(
          //                 color: AppTheme.kButtonColor,
          //               )
          //             : CupertinoActivityIndicator(
          //                 radius: 20, color: AppTheme.kButtonColor)),
          //   );
          // }

          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
                child: Globals.isAndroid == true
                    ? CircularProgressIndicator(
                        color: AppTheme.kButtonColor,
                      )
                    : CupertinoActivityIndicator(
                        radius: 20, color: AppTheme.kButtonColor)),
          );
          // return widget here based on BlocA's state
        });
  }

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  Widget titleWidget() {
    return ValueListenableBuilder(
      valueListenable: pageIndex,
      builder: (BuildContext context, dynamic value, Widget? child) {
        return Container(
          // width: MediaQuery.of(context).size.width * 0.1,
          child: PlusScreenTitleWidget(
            kLabelSpacing: 0,
            text: pageIndex.value == 0
                ? 'Subject'
                : '${widget.stateName} Learning Standard',
            backButton: true,
            backButtonOnTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              // Change pages according to current page position on back press ..
              if (pageIndex.value == 1) {
                learningStandard = '';
                isSkipButton.value = true;
                nycIndex1.value = -1;
                subjectIndex1.value = 0;
                isSubmitButton.value = false;

                fetchSubjectDetails('subject', widget.selectedClass,
                    widget.selectedClass, widget.stateName, '', '');
              } else if (pageIndex.value == 2) {
                nycSubIndex1.value = -1;
                nycIndex1.value = 0;
                learningStandard = '';
                standardDescription = '';
                subLearningStandard = '';
                isSubmitButton.value = false;
                isSkipButton.value = true;

                if (widget.isSearchPage == true) {
                  Navigator.pop(context);
                } else {
                  _ocrBloc.add(FetchSubjectDetails(
                    type: 'nyc',
                    selectedKeyword: selectedKeyword,
                    grade: widget.selectedClass,
                    stateName: widget.stateName,
                    subjectId: subjectId,
                    subjectSelected: subject,
                  ));
                }
              } else {
                Navigator.pop(context);
              }
            },
          ),
        );
      },
      child: Container(),
    );
  }

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  Widget searchDomainText() {
    return Utility.textWidget(
        text: 'Select Domain',
        textTheme: Theme.of(context).textTheme.subtitle1!.copyWith(
              fontWeight: FontWeight.bold,
            ),
        context: context);
  }

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  // widget to show list view on Sub-learning page  -------
  Widget buttonListWidget({required List<SubjectDetailList> list}) {
    return ValueListenableBuilder(
      valueListenable: nycSubIndex1,
      builder: (BuildContext context, dynamic value, Widget? child) {
        return Container(
          padding: EdgeInsets.only(bottom: 50),
          height: Globals.deviceType == 'phone'
              ? MediaQuery.of(context).size.height * 0.65
              : MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.03),
            itemCount: list.length,
            itemBuilder: (BuildContext ctx, index) {
              return Column(children: [
                Bouncing(
                  child: InkWell(
                    onTap: () {
                      subLearningStandard =
                          list[index].standardAndDescriptionC!.split(' - ')[0];
                      standardDescription =
                          list[index].standardAndDescriptionC!.split(' - ')[1];
                      standardId = list[index].id ?? '';
                      if (pageIndex.value == 2) {
                        nycSubIndex1.value = index;
                        if (nycSubIndex1.value != -1) {
                          isSubmitButton.value = true;
                          isSkipButton.value = false;
                        }
                      }
                    },
                    child: AnimatedContainer(
                      padding: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        color: (nycSubIndex1.value == index &&
                                pageIndex.value == 2)
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
                          message: list[index].standardAndDescriptionC ?? '',
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
                                    style:
                                        Theme.of(context).textTheme.headline2,
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
                                              .headline2!
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
                                      ),
                                    ],
                                  )
                                : TextSpan(
                                    style:
                                        Theme.of(context).textTheme.headline2,
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
                              color: (nycSubIndex1.value == index &&
                                      pageIndex.value == 2)
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
              return SpacerWidget(_KVerticalSpace / 3.75);
            },
          ),
        );
      },
    );
  }

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  Widget progressIndicatorBar() {
    return ValueListenableBuilder(
      valueListenable: pageIndex,
      child: Container(
        height: 0,
      ),
      builder: (BuildContext context, dynamic value, Widget? child) {
        return ValueListenableBuilder(
            valueListenable: isSubmitButton,
            child: Container(),
            builder: (BuildContext context, dynamic value, Widget? child) {
              return Container(
                padding: EdgeInsets.only(bottom: 20),
                margin:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: AnimatedContainer(
                      // duration: Duration(seconds: 5),
                      duration: Duration(microseconds: 100),
                      curve: Curves.easeOutExpo,
                      child: LinearProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            AppTheme.kButtonColor),
                        backgroundColor: Color(0xff000000) !=
                                Theme.of(context).backgroundColor
                            ? Color.fromRGBO(0, 0, 0, 0.1)
                            : Color.fromRGBO(255, 255, 255, 0.16),
                        minHeight: 15.0,
                        value: isSubmitButton.value
                            ? 100
                            : pageIndex.value == 0
                                ? 0.33
                                : pageIndex.value == 1
                                    ? 0.66
                                    : 1,
                      ),
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  // Widget to show details in grid view on subject selection page and learning page
  // Using Dynamic list because subject page have different modal list and sub learning have different list
  Widget gridButtonsWidget(
      {required List<dynamic> list, int? page, bool? isSubjectScreen}) {
    return ValueListenableBuilder(
      valueListenable: pageIndex.value == 0 ? subjectIndex1 : nycIndex1,
      child: Container(),
      builder: (BuildContext context, dynamic value, Widget? child) {
        return Container(
          padding: EdgeInsets.only(bottom: pageIndex.value == 0 ? 0 : 50),
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height * 0.62
              : MediaQuery.of(context).size.width * 0.30,
          width: MediaQuery.of(context).size.width * 0.9,
          child: GridView.builder(
              controller: _scrollController,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.09),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: Globals.deviceType == 'phone'
                      ? (pageIndex.value == 1)
                          ? 220
                          : 180
                      : 400,
                  childAspectRatio: Globals.deviceType == 'phone'
                      ? (pageIndex.value == 1 && widget.isCommonCore == true)
                          ? 7 / 6
                          : 5 / 3
                      : 5 / 1.5,
                  crossAxisSpacing: Globals.deviceType == 'phone'
                      ? (pageIndex.value == 1)
                          ? 10
                          : 15
                      : 20,
                  mainAxisSpacing: pageIndex.value == 1 ? 15 : 15),
              itemCount: page == 1
                  ? list.length
                  : list.length +
                      1, //  plus 2 for adding length in case subject (1 for no standard and another for + add subject)
              itemBuilder: (BuildContext ctx, index) {
                return page == 1 || (page == 0 && index < list.length)
                    ? Bouncing(
                        // onPress: () {

                        // },
                        child: InkWell(
                          onTap: () async {
                            if (page != 1) {
                              //print("INSIDE ON TAPPPPPPPPPPPPPPPPPPPPP");
                            }

                            searchController.clear();
                            FocusManager.instance.primaryFocus?.unfocus();

                            if (pageIndex.value == 0) {
                              isSkipButton.value = true;
                              subject = list[index].titleC ?? '';
                              subjectId = list[index].id ?? '';
                              // standardId = list[index].id ?? '';

                              subjectIndex1.value = index;
                              selectedKeyword = list[index].titleC;

                              // Condition to check selected subject from local or not
                              if ((list[index].id == null)) {
                                isSubmitButton.value = true;
                              } else {
                                isSkipButton.value = true;
                                isSubmitButton.value = false;
                                _ocrBloc.add(FetchSubjectDetails(
                                    type: 'nyc',
                                    grade: widget.selectedClass,
                                    selectedKeyword: widget.selectedClass,
                                    subjectSelected: list[index].titleC,
                                    subjectId: list[index].id,
                                    stateName: widget.stateName));
                              }

                              if (index < list.length &&
                                  !isSubmitButton.value) {}
                              //To manage the recent subject list
                              List<SubjectDetailList> recentlUsedList =
                                  await subjectRecentOptionDB.getData();

                              SubjectDetailList recentSubjectList =
                                  SubjectDetailList();

                              if (recentlUsedList.isNotEmpty) {
                                bool addToRecentList = false;

                                //To update the object if already exist
                                for (int i = 0;
                                    i < recentlUsedList.length;
                                    i++) {
                                  if (recentlUsedList[i].subjectNameC ==
                                      list[index].titleC) {
                                    recentSubjectList = recentlUsedList[i];

                                    recentSubjectList.dateTime = DateTime.now();
                                    await subjectRecentOptionDB.putAt(
                                        i, recentSubjectList);
                                    addToRecentList = true;
                                    break;
                                  }
                                }

                                //To add the object if not exist
                                if (addToRecentList == false) {
                                  recentSubjectList.subjectNameC =
                                      list[index].titleC;
                                  recentSubjectList.dateTime = DateTime.now();
                                  await subjectRecentOptionDB
                                      .addData(recentSubjectList);
                                }
                              } else {
                                recentSubjectList.subjectNameC =
                                    list[index].titleC;
                                recentSubjectList.dateTime = DateTime.now();
                                await subjectRecentOptionDB
                                    .addData(recentSubjectList);
                              }
                            } else if (pageIndex.value == 1) {
                              learningStandard = list[index].domainNameC;
                              nycIndex1.value = index;
                              // nycSubIndex1.value = index;

                              if (index < list.length) {
                                keywordSub = list[index].domainNameC;
                                _ocrBloc.add(FetchSubjectDetails(
                                    type: 'nycSub',
                                    grade: widget.selectedClass,
                                    subjectId: subjectId,
                                    selectedKeyword: keywordSub,
                                    stateName: widget.stateName,
                                    subjectSelected: subject));
                              }
                              //To manage the recent learning standard list
                              List<SubjectDetailList> learningrecentList =
                                  await learningRecentOptionDB.getData();

                              SubjectDetailList learningRecentObject =
                                  SubjectDetailList();
                              //To add the object if not exist
                              if (learningrecentList.isNotEmpty) {
                                bool addToRecentList = false;

                                for (int i = 0;
                                    i < learningrecentList.length;
                                    i++) {
                                  if (learningrecentList[i].domainNameC ==
                                      list[index].domainNameC) {
                                    learningRecentObject =
                                        learningrecentList[i];

                                    learningRecentObject.dateTime =
                                        DateTime.now();
                                    await learningRecentOptionDB.putAt(
                                        i, learningRecentObject);
                                    addToRecentList = true;
                                    break;
                                  }
                                }
                                //To update the object if not exist
                                if (addToRecentList == false) {
                                  learningRecentObject.domainNameC =
                                      list[index].domainNameC;
                                  learningRecentObject.dateTime =
                                      DateTime.now();
                                  await learningRecentOptionDB
                                      .addData(learningRecentObject);
                                }
                              } else {
                                learningRecentObject.domainNameC =
                                    list[index].domainNameC;
                                learningRecentObject.dateTime = DateTime.now();
                                await learningRecentOptionDB
                                    .addData(learningRecentObject);
                              }
                            }
                            if (index >= list.length &&
                                index !=
                                    list.length + userAddedSubjectList.length) {
                              // _googleDriveBloc.close();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GradedPlusResultsSummary(
                                          isMcqSheet: widget.isMcqSheet,
                                          selectedAnswer: widget.selectedAnswer,
                                          subjectId: subjectId ?? '',
                                          standardId: standardId ?? '',
                                          assessmentName:
                                              Globals.assessmentName,
                                          shareLink: Globals.shareableLink!,
                                          assessmentDetailPage: false,
                                        )),
                              );
                            }
                          },
                          child: AnimatedContainer(
                            padding: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              color: (subjectIndex1.value == index &&
                                          pageIndex.value == 0) ||
                                      (nycIndex1.value == index &&
                                          pageIndex.value == 1)
                                  ? AppTheme.kSelectedColor
                                  : Colors.grey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            duration: Duration(microseconds: 5000),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              alignment: isSubjectScreen == true
                                  ? Alignment.center
                                  : Alignment.centerLeft,
                              child: Utility.textWidget(
                                  textAlign: TextAlign.left,
                                  text: page == 0
                                      ? list[index].titleC
                                      : list[index].domainNameC ?? '',
                                  textTheme: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              Globals.deviceType == 'tablet' &&
                                                      page == 1
                                                  ? 16
                                                  : null),
                                  context: context),
                              decoration: BoxDecoration(
                                  color: Color(0xff000000) !=
                                          Theme.of(context).backgroundColor
                                      ? Color(0xffF7F8F9)
                                      : Color(0xff111C20),
                                  border: Border.all(
                                    color: (subjectIndex1.value == index &&
                                                pageIndex.value == 0) ||
                                            (nycIndex1.value == index &&
                                                pageIndex.value == 1)
                                        ? AppTheme.kSelectedColor
                                        : Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      )
                    : Bouncing(
                        child: InkWell(
                        onTap: () {
                          addCustomSubjectBottomSheet();
                        },
                        child: AnimatedContainer(
                          padding: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          duration: Duration(microseconds: 100),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            child: Utility.textWidget(
                                text: '+',
                                textTheme: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(fontWeight: FontWeight.bold),
                                context: context),
                            decoration: BoxDecoration(
                                color: Color(0xff000000) !=
                                        Theme.of(context).backgroundColor
                                    ? Color(0xffF7F8F9)
                                    : Color(0xff111C20),
                                border: Border.all(
                                  color: (subjectIndex1.value == index &&
                                          pageIndex.value == 0)
                                      ? AppTheme.kSelectedColor
                                      : Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ));
              }),
        );
      },
    );
  }

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  //  To Open bottom sheet by which user can add new subjects to screen
  addCustomSubjectBottomSheet() {
    showModalBottomSheet(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      useRootNavigator: true,

      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      elevation: 10,
      context: context,
      builder: (context) => BottomSheetWidget(
        title: 'Add Subject',
        isImageField: false,
        textFieldTitleOne: 'Subject Name',
        submitButton: true,
        isSubjectScreen: true,
        sheetHeight: MediaQuery.of(context).orientation == Orientation.landscape
            ? MediaQuery.of(context).size.height * 0.82
            : MediaQuery.of(context).size.height * 0.45,
        valueChanged: (controller) async {
          await updateList(
              subjectName: controller.text, classNo: widget.selectedClass!);

          fetchSubjectDetails(
              'subject',
              widget.selectedClass,
              widget.selectedClass,
              widget.stateName,
              selectedKeyword,
              subjectId);

          controller.clear();
          Navigator.pop(context, false);
        },
      ),
      // SizedBox(
      //   height: 30,
      // )
    );
  }

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  // Widget from save to drive by which teacher can save data to google drive
  Widget saveToDriveButton() {
    return Wrap(
      alignment: WrapAlignment.end,
      children: [
        ValueListenableBuilder(
            valueListenable: isSkipButton,
            child: Container(),
            builder: (BuildContext context, dynamic value, Widget? child) {
              return isSkipButton.value //&& pageIndex.value != 0
                  ? OfflineBuilder(
                      connectivityBuilder: (BuildContext context,
                          ConnectivityResult connectivity, Widget child) {
                        final bool connected =
                            connectivity != ConnectivityResult.none;
                        return FloatingActionButton.extended(
                            backgroundColor:
                                AppTheme.kButtonColor.withOpacity(1.0),
                            onPressed: () async {
                              // showLoadingDialog(
                              //     context: context,
                              //     state: (p0) => {showDialogSetState = p0});
                              //!UNCOMMENT
                              Utility.updateLogs(
                                  activityType: 'GRADED+',
                                  activityId: '18',
                                  description: 'Skip subject selection process',
                                  operationResult: 'Success');
                              floatingButtonOnTap();
                            },
                            label: Row(
                              children: [
                                Utility.textWidget(
                                    text: 'Skip',
                                    context: context,
                                    textTheme: Theme.of(context)
                                        .textTheme
                                        .headline2!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .backgroundColor)),
                              ],
                            ));
                      },
                      child: Container(),
                    )
                  : Container();
            }),
        ValueListenableBuilder(
          valueListenable: isSubmitButton,
          child: Container(),
          builder: (BuildContext context, dynamic value, Widget? child) {
            return //pageIndex.value == 2
                isSubmitButton.value
                    ? OfflineBuilder(
                        connectivityBuilder: (BuildContext context,
                            ConnectivityResult connectivity, Widget child) {
                          final bool connected =
                              connectivity != ConnectivityResult.none;
                          return FloatingActionButton.extended(
                            backgroundColor:
                                AppTheme.kButtonColor.withOpacity(1.0),
                            onPressed: () async {
                              floatingButtonOnTap();
                              // updateExcelSheetOnDriveAndNavigate(
                              //     connected: connected);
                            },
                            label: Utility.textWidget(
                                text: 'Save',
                                context: context,
                                textTheme: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(
                                        color:
                                            Theme.of(context).backgroundColor)),
                          );
                        },
                        child: Container(),
                      )
                    : Container();
          },
        ),
      ],
    );
  }

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  // Function to update custom(subject added by teacher) subjects to local db --
  Future<void> updateList(
      {required String subjectName, required String classNo}) async {
    List<StateListObject> subjectList = [];

    // to get custom subject list from localDb - State and class specific
    LocalDatabase<StateListObject> _customSubjectlocalDb =
        LocalDatabase('Subject_list${widget.stateName}$classNo');
    List<StateListObject>? _stateCustomlocalData =
        await _customSubjectlocalDb.getData();

    // to get state list from localDb and extract subject names
    LocalDatabase<StateListObject> _stateSubjectLocalDb =
        LocalDatabase(Strings.stateObjectName);
    List<StateListObject>? _stateSubjectLocalData =
        await _stateSubjectLocalDb.getData();

    //only adding the subjects state specific
    for (int i = 0; i < _stateSubjectLocalData.length; i++) {
      if (_stateSubjectLocalData[i].stateC == widget.stateName) {
        subjectList.add(_stateSubjectLocalData[i]);
      }
    }

    //Add custom subjects to the subject list
    subjectList.addAll(_stateCustomlocalData);

    //To check if subject already exist in the array before adding to the list
    bool found = false;
    subjectList.forEach((s) {
      if (s.titleC!.toLowerCase() == subjectName.toLowerCase()) {
        found = true;
      }
    });

    if (subjectName.isNotEmpty && !found) {
      StateListObject subjectDetailList = StateListObject();
      subjectDetailList.titleC = subjectName;
      _stateCustomlocalData.add(subjectDetailList);
    } else {
      Utility.showSnackBar(_scaffoldKey,
          "Subject \'$subjectName\' Already Exist", context, null);
    }

    await _customSubjectlocalDb.clear();
    _stateCustomlocalData.forEach((StateListObject e) {
      _customSubjectlocalDb.addData(e);
    });
    // Calling event to update subject page --------

    fetchSubjectDetails('subject', widget.selectedClass, widget.selectedClass,
        widget.stateName, '', '');
  }

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  Future<void> searchList(
      {required String searchKeyword, required String classNo}) async {
    LocalDatabase<String> _localDb = LocalDatabase(widget.isCommonCore == true
        ? 'Subject_list_Common_core$classNo'
        : 'Subject_list$classNo');
    List<String>? _localData = await _localDb.getData();
    userAddedSubjectList = [];
    for (int i = 0; i < _localData.length; i++) {
      if (_localData[i].toUpperCase().contains(searchKeyword.toUpperCase())) {
        userAddedSubjectList.add(_localData[i]);
      }
    }
  }

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  // Function to update sheet to drive and navigate to assessment summery -------------
  void updateExcelSheetOnDriveAndNavigate({required bool connected}) async {
    {
      if (!connected) {
        Utility.currentScreenSnackBar("No Internet Connection", null);
      } else {
        LocalDatabase<CustomRubricModal> _localDb =
            LocalDatabase('custom_rubic');

        List<CustomRubricModal>? _localData = await _localDb.getData();
        String? rubricImgUrl;

        for (int i = 0; i < _localData.length; i++) {
          if (_localData[i].customOrStandardRubic == "Custom" &&
              '${_localData[i].name}' + ' ' + '${_localData[i].score}' ==
                  Globals.scoringRubric) {
            rubricImgUrl = _localData[i].imgUrl ?? 'NA';
            break;
          } else {
            rubricImgUrl = 'NA';
          }
        }

        List<StudentAssessmentInfo> studentAssessmentInfoDblist =
            await OcrUtility.getSortedStudentInfoList(
                tableName: 'student_info');

        //Updating remaining common details of assignment
        StudentAssessmentInfo element = studentAssessmentInfoDblist.first;

        element.subject = subject == null || subject == '' ? "NA" : subject;
        element.learningStandard =
            learningStandard == null || learningStandard == ''
                ? "NA"
                : learningStandard;
        element.subLearningStandard = subLearningStandard == null ||
                subLearningStandard == '' //standardDescription
            ? "NA"
            : subLearningStandard;
        element.standardDescription = standardDescription == null ||
                standardDescription == '' //standardDescription
            ? "NA"
            : standardDescription;
        element.scoringRubric =
            widget.isMcqSheet == true ? '0-1' : Globals.scoringRubric;
        element.className = Globals.assessmentName!.split("_")[1];
        element.customRubricImage = rubricImgUrl;
        element.grade = widget.selectedClass;
        // element.questionImgUrl =
        //     widget.questionImageUrl == '' ? "NA" : widget.questionImageUrl;
        element.googleSlidePresentationURL =
            Globals.googleSlidePresentationLink;
        await _studentAssessmentInfoDb.putAt(0, element);

        GradedGlobals.loadingMessage = 'Preparing Student Excel Sheet';

        // Utility.showLoadingDialog(
        //     context: context,
        //     isOCR: true,
        //     state: (p0) => {showDialogSetState = p0});

        //calling API
        updateDocOnDrive(
          widget.isMcqSheet,
          // widget.questionImageUrl
        );
      }
    }
  }

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  fetchSubjectDetails(String? type, String? grade, String? selectedKeyword,
      String? stateName, String? subjectSelected, String? subjectId) {
    _ocrBloc.add(FetchSubjectDetails(
        type: type,
        grade: grade,
        // empty because no subject selected yet
        subjectId: subjectId,
        subjectSelected: subjectSelected,
        selectedKeyword: selectedKeyword,
        stateName: stateName));
  }

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  void updateDocOnDrive(
    bool? isMCQSheet,
    // String? questionImageURL,
  ) async {
    excelSheetBloc.add(
      UpdateDocOnDrive(
          isMcqSheet: isMCQSheet ?? false,
          // questionImage:
          //     questionImageURL == '' ? 'NA' : questionImageURL ?? 'NA',

          assessmentName: Globals.assessmentName,
          fileId: Globals.googleExcelSheetId,
          isLoading: true,
          studentData: await OcrUtility.getSortedStudentInfoList(
              tableName: 'student_info')
          //list2
          //Globals.studentInfo!
          ),
    );
  }

// //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//   googleSlidesPreparation() {
//     if (Globals.googleSlidePresentationId!.isNotEmpty &&
//         (Globals.googleSlidePresentationLink == null ||
//             Globals.googleSlidePresentationLink!.isEmpty)) {
//       _googleDriveBloc.add(GetShareLink(
//           fileId: Globals.googleSlidePresentationId, slideLink: true));
//     }
//   }

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  void _navigateToResultSection() {
    GradedGlobals.loadingMessage = null;
    Navigator.of(context).pop();
    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        "save_to_drive_from_subject_selection");
    Utility.updateLogs(
        activityType: 'GRADED+',
        activityId: '12',
        description: 'Save to drive',
        operationResult: 'Success');

    // _googleDriveBloc.close();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => GradedPlusResultsSummary(
                isMcqSheet: widget.isMcqSheet,
                selectedAnswer: widget.selectedAnswer,
                fileId: Globals.googleExcelSheetId,
                subjectId: subjectId ?? '',
                standardId: standardId ?? '',
                assessmentName: Globals.assessmentName,
                shareLink: '',
                assessmentDetailPage: false,
              )),
    );
  }

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  void _saveResultAssignmentsToDashboard(
      {required String assessmentId,
      required String googleSpreadsheetUrl,
      // required String subjectId,
      required String assessmentName,
      //  required String fileId,
      required LocalDatabase<StudentAssessmentInfo> studentAssessmentInfoDb}) {
    ocrAssessmentBloc.add(GradedPlusSaveResultToDashboard(
      assessmentId: assessmentId,
      assessmentSheetPublicURL: googleSpreadsheetUrl,
      studentInfoDb: studentAssessmentInfoDb,
      assessmentName: assessmentName,
      // subjectId: subjectId,
      schoolId: Globals.appSetting.schoolNameC!,
      // fileId: fileId,
    ));
  }

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  void _navigateToResultSectionOnSkipButton() {
    Navigator.of(context).pop();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => GradedPlusResultsSummary(
                isMcqSheet: widget.isMcqSheet,
                selectedAnswer: widget.selectedAnswer,
                fileId: Globals.googleExcelSheetId,
                subjectId: subjectId ?? '',
                standardId: standardId ?? '',
                assessmentName: Globals.assessmentName,
                shareLink: '',
                assessmentDetailPage: false,
              )),
    );
  }

  Widget classRoomBlocListener() {
    return BlocListener<GoogleClassroomBloc, GoogleClassroomState>(
        bloc: _googleClassroomBloc,
        child: Container(),
        listener: (context, state) async {
          if (state is CreateClassroomCourseWorkSuccess) {
            Utility.updateLogs(
                activityType: 'GRADED+',
                activityId: '34',
                description: 'G-Classroom Created',
                operationResult: 'Success');
            _navigateToResultSection();
          }
          if (state is GoogleClassroomErrorState) {
            if (state.errorMsg == 'ReAuthentication is required') {
              await Utility.refreshAuthenticationToken(
                  isNavigator: true,
                  errorMsg: state.errorMsg!,
                  context: context,
                  scaffoldKey: _scaffoldKey);
              _googleClassroomBloc.add(CreateClassRoomCourseWork(
                  studentAssessmentInfoDb: LocalDatabase('student_info'),
                  pointPossible: Globals.pointPossible ?? '0',
                  studentClassObj:
                      GoogleClassroomGlobals.studentAssessmentAndClassroomObj!,
                  title: Globals.assessmentName ?? ''));
            } else {
              Navigator.of(context).pop();
              Utility.currentScreenSnackBar(
                  state.errorMsg?.toString() ?? "", null);
            }
          }
        });
  }

  /* ---------- widget bloc listener to upload question image,create excel sheet & slide, --------- */
  Widget googleBlocListener() {
    return BlocListener<GoogleDriveBloc, GoogleDriveState>(
        bloc: googleBloc,
        child: Container(),
        listener: (context, state) async {
          print("state is $state");
          if (state is ExcelSheetCreated) {
            Globals.googleExcelSheetId =
                state.googleSpreadSheetFileObj['fileId'];
            Globals.shareableLink =
                state.googleSpreadSheetFileObj['fileUrl'] ?? '';
            //Create Google Presentation once Spreadsheet created
            googleBloc.add(CreateSlideToDrive(
                isMcqSheet: widget.isMcqSheet ?? false,
                fileTitle: Globals.assessmentName,
                excelSheetId: Globals.googleExcelSheetId));
          }
          if (state is ErrorState) {
            if (state.errorMsg == 'ReAuthentication is required') {
              Navigator.of(context).pop();
              await Utility.refreshAuthenticationToken(
                  isNavigator: true,
                  errorMsg: state.errorMsg!,
                  context: context,
                  scaffoldKey: _scaffoldKey);
            } else {
              Navigator.of(context).pop();
              Utility.currentScreenSnackBar(
                  state.errorMsg == 'NO_CONNECTION'
                      ? 'No Internet Connection'
                      : "Something Went Wrong. Please Try Again.",
                  null);
            }
          }
          if (state is RecallTheEvent) {
            googleBloc.add(CreateExcelSheetToDrive(
                description: widget.isMcqSheet == true
                    ? "Multiple Choice Sheet"
                    : "Graded+",
                name: Globals.assessmentName,
                folderId: Globals.googleDriveFolderId!));
          }

          if (state is GoogleSlideCreated) {
            Globals.googleSlidePresentationId = state.slideFiledId;
            // if (Globals.googleSlidePresentationId!.isNotEmpty &&
            //     (Globals.googleSlidePresentationLink == null ||
            //         Globals.googleSlidePresentationLink!.isEmpty)) {
            googleBloc.add(GetShareLink(
                fileId: Globals.googleSlidePresentationId, slideLink: true));
            // }
            Utility.updateLogs(
                activityType: 'GRADED+',
                activityId: '33',
                description: 'G-Slide Created',
                operationResult: 'Success');

            // call events to update the sheets and slide
          }

          if (state is QuestionImageSuccess) {
            //update Question image url in local studentDb
            List<StudentAssessmentInfo> studentInfoList =
                await _studentAssessmentInfoDb.getData();
            if (studentInfoList?.isNotEmpty ?? false) {
              StudentAssessmentInfo studentObj = studentInfoList.first;
              studentObj.questionImgUrl = state.questionImageUrl;
              await _studentAssessmentInfoDb.putAt(0, studentObj);
            }
            googleBloc.add(CreateExcelSheetToDrive(
                description: widget.isMcqSheet == true
                    ? "Multiple Choice Sheet"
                    : "Graded+",
                name: Globals.assessmentName,
                folderId: Globals.googleDriveFolderId!));
          }

          if (state is ShareLinkReceived) {
            Globals.googleSlidePresentationLink = state.shareLink;
            updateExcelSheetOnDriveAndNavigate(connected: true);
            googleSlideBloc.add(
                AddAndUpdateAssessmentAndResultDetailsToSlidesOnDrive(
                    studentInfoDb: _studentAssessmentInfoDb,
                    slidePresentationId: Globals.googleSlidePresentationId));
          }
        });
  }

  Widget excelBlocListener() {
    return BlocListener<GoogleDriveBloc, GoogleDriveState>(
        bloc: excelSheetBloc,
        child: Container(),
        listener: (context, state) async {
          print("state is $state");
          if (state is GoogleSuccess) {
            Utility.updateLogs(
                activityType: 'GRADED+',
                activityId: '45',
                description: 'G-Excel File Updated',
                operationResult: 'Success');

            showDialogSetState!(() {
              assessmentExportAndSaveStatus.value.excelSheetPrepared =
                  true; // update loading dialog and navigate
            });
            Globals.currentAssessmentId = '';

            List<StudentAssessmentInfo> studentAssessmentInfoDblist =
                await OcrUtility.getSortedStudentInfoList(
                    tableName: 'student_info');
            ocrAssessmentBloc.add(SaveAssessmentToDashboardAndGetId(
                isMcqSheet: widget.isMcqSheet ?? false,
                assessmentQueImage:
                    studentAssessmentInfoDblist?.first?.questionImgUrl ?? '',
                assessmentName: Globals.assessmentName ?? 'Assessment Name',
                rubricScore: Globals.scoringRubric ?? '2',
                subjectName: widget.isSearchPage == true
                    ? widget.selectedSubject ?? 'NA'
                    : subject ??
                        'NA', //Student Id will not be there in case of custom subject
                domainName: widget.isSearchPage == true
                    ? widget.domainNameC ?? ''
                    : learningStandard ?? '',
                subDomainName: subLearningStandard ?? '',
                grade: widget.selectedClass ?? '',
                schoolId: Globals.appSetting.schoolNameC ?? '',
                standardId: standardId ?? '',
                scaffoldKey: _scaffoldKey,
                context: context,
                fileId: Globals.googleExcelSheetId ?? 'Excel Id not found',
                sessionId: Globals.sessionId,
                teacherContactId: Globals.teacherId,
                teacherEmail: Globals.teacherEmailId,
                classroomCourseId: GoogleClassroomGlobals
                        ?.studentAssessmentAndClassroomObj?.courseId ??
                    '',
                classroomCourseWorkId: GoogleClassroomGlobals
                        ?.studentAssessmentAndClassroomObj?.courseWorkId ??
                    ''));

            // showDialogSetState() {
            //   assessmentExportAndSaveStatus.value.excelSheetPrepared =
            //       true; // update loading dialog and navigate
            // }
            // showDialogSetState(() {
            //   assessmentExportAndSaveStatus.value.excelSheetPrepared =
            //       true; // update loading dialog and navigate
            // });
            // showDialogSetState() {}

            navigateToResultSummery();
          }
          if (state is ErrorState) {
            if (state.errorMsg == 'ReAuthentication is required') {
              Navigator.of(context).pop();
              await Utility.refreshAuthenticationToken(
                  isNavigator: true,
                  errorMsg: state.errorMsg!,
                  context: context,
                  scaffoldKey: _scaffoldKey);
            } else {
              Navigator.of(context).pop();
              Utility.currentScreenSnackBar('Something went wrong' ?? "", null);
            }
          }
        });
  }

  Widget slideBlocListener() {
    return BlocListener<GoogleDriveBloc, GoogleDriveState>(
        bloc: googleSlideBloc,
        child: Container(),
        listener: (context, state) async {
          if (state is ErrorState) {
            if (state.errorMsg == 'ReAuthentication is required') {
              Navigator.of(context).pop();
              await Utility.refreshAuthenticationToken(
                  isNavigator: true,
                  errorMsg: state.errorMsg!,
                  context: context,
                  scaffoldKey: _scaffoldKey);
            } else {
              Navigator.of(context).pop();
              Utility.currentScreenSnackBar('Something went wrong' ?? "", null);
            }
          }
          print("state is $state");
          if (state is AddAndUpdateStudentAssessmentDetailsToSlideSuccess) {
            //Updating very first slide with the assignment details
            googleSlideBloc.add(UpdateAssignmentDetailsOnSlide(
                slidePresentationId: Globals.googleSlidePresentationId,
                studentAssessmentInfoDB: _studentAssessmentInfoDb));
          }
          if (state is UpdateAssignmentDetailsOnSlideSuccess) {
            Utility.updateLogs(
                activityType: 'GRADED+',
                activityId: '44',
                description: 'G-Slide Updated',
                operationResult: 'Success');
            FirebaseAnalyticsService.addCustomAnalyticsEvent(
                "assessment_detail_added_first_slide");
            showDialogSetState!(() {
              assessmentExportAndSaveStatus.value.slidePrepared = true;
            });

            navigateToResultSummery();
          }
        });
  }

  /* ---------------------------- widget for assessment create ocr bloc --------------------------- */
  Widget ocrAssessmentBlocListener() {
    return BlocListener<OcrBloc, OcrState>(
      bloc: ocrAssessmentBloc,
      listener: (context, state) {
        print("state is $state");
        if (state is AssessmentIdSuccess) {
          _saveResultAssignmentsToDashboard(
              assessmentId: state.dashboardAssignmentsId ?? '',
              googleSpreadsheetUrl: Globals.shareableLink ?? '',
              assessmentName: Globals.assessmentName ?? '',
              studentAssessmentInfoDb: _studentAssessmentInfoDb);
        } else if (state is OcrErrorReceived) {
          Navigator.of(context).pop();
          Utility.currentScreenSnackBar('Something went wrong' ?? "", null);
        } else if (state is GradedPlusSaveResultToDashboardSuccess) {
          showDialogSetState!(() {
            assessmentExportAndSaveStatus
                .value.saveAssessmentResultToDashboard = true;
          });
          // assessmentExportAndSaveStatus.value.saveAssessmentResultToDashboard =
          //     true;
          navigateToResultSummery();
        }
      },
      child: Container(),
    );
  }

  /* ---------------------------- subjectBlocListener --------------------------- */
  Widget subjectBlocListener() {
    return BlocListener(
      bloc: _ocrBloc,
      listener: (context, state) async {
        if (state is SubjectDataSuccess) {
          pageIndex.value = 0;
        } else if (state is NycDataSuccess) {
          // AnimationController?.dispose();
          pageIndex.value = 1;
          if (state.obj.length == 0) {
            isSkipButton.value = false;
            isSubmitButton.value = true;
          }
        } else if (state is NycSubDataSuccess) {
          pageIndex.value = 2;
        } else if (state is StateListFetchSuccessfully) {
          fetchSubjectDetails('subject', widget.selectedClass,
              widget.selectedClass, widget.stateName, '', '');
        }
      },
      child: Container(),
    );
  }

  /* ----- Function will navigate to result summery when all process done ----- */
  navigateToResultSummery() {
    // check all process is done or not
    if (assessmentExportAndSaveStatus.value.excelSheetPrepared == true &&
        assessmentExportAndSaveStatus.value.slidePrepared == true &&
        assessmentExportAndSaveStatus.value.saveAssessmentResultToDashboard ==
            true) {
      showDialogSetState!(() {
        allProcessDone == true;
      });

      // Future.delayed(const Duration(milliseconds: 5000), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GradedPlusResultsSummary(
            isMcqSheet: widget.isMcqSheet,
            selectedAnswer: widget.selectedAnswer,
            fileId: Globals.googleExcelSheetId,
            subjectId: subjectId ?? '',
            standardId: standardId ?? '',
            assessmentName: Globals.assessmentName,
            shareLink: '',
            assessmentDetailPage: false,
          ),
        ),
      );
      //    });
    }
  }

  /* ------ Function call when someone tap on skip button or save button ------ */
  floatingButtonOnTap() async {
    showLoadingDialog(
        context: context, state: (p0) => {showDialogSetState = p0});
    // Utility.showLoadingDialog(
    //     context: context, isOCR: true, msg: "Please Wait");

    if (Globals.googleExcelSheetId == null ||
        Globals.googleExcelSheetId?.isEmpty == true) {
      // Check if question image exists

      if (widget.gradedPlusQueImage == null) {
        googleBloc.add(CreateExcelSheetToDrive(
          description:
              widget.isMcqSheet == true ? "Multiple Choice Sheet" : "Graded+",
          name: Globals.assessmentName,
          folderId: Globals.googleDriveFolderId!,
        ));
      } else {
        googleBloc.add(QuestionImgToAwsBucket(
          imageFile: widget.gradedPlusQueImage,
        ));
      }
      return; // Exit the function early
    }

    //Will call the method only in case of user press the button again if something went wrong or authentication requires in between the process
    callActionOnReTappingFAB();
  }

//------------------------------------------------------------------------callActionOnReTappingFAB------------------------------------------------------------------------------------
  //Will call the method only in case of user press the button again if something went wrong or authentication requires in between the process
  callActionOnReTappingFAB() async {
    if (Globals.googleSlidePresentationId == null ||
        Globals.googleSlidePresentationId?.isEmpty == true) {
      googleBloc.add(CreateSlideToDrive(
        isMcqSheet: widget.isMcqSheet ?? false,
        fileTitle: Globals.assessmentName,
        excelSheetId: Globals.googleExcelSheetId,
      ));
      return; // Exit the function early
    }

    //------------------------------------------------------------------------------
    //Get Slide Share Link if empty
    if (Globals.googleSlidePresentationLink == null ||
        Globals.googleSlidePresentationLink?.isEmpty == true) {
      googleBloc.add(GetShareLink(
        fileId: Globals.googleSlidePresentationId,
        slideLink: true,
      ));
      return; // Exit the function early
    }

    //------------------------------------------------------------------------------
    //Updating Excel sheet with student details if not already updated
    if (assessmentExportAndSaveStatus.value.excelSheetPrepared == false) {
      updateExcelSheetOnDriveAndNavigate(connected: true);
    }

    //------------------------------------------------------------------------------
    //Updating Google Slide with student details if not already updated
    if (assessmentExportAndSaveStatus.value.slidePrepared == false) {
      googleSlideBloc.add(AddAndUpdateAssessmentAndResultDetailsToSlidesOnDrive(
        studentInfoDb: _studentAssessmentInfoDb,
        slidePresentationId: Globals.googleSlidePresentationId,
      ));
    }

    //------------------------------------------------------------------------------
    //Updating student result to dashboard if not already updated
    if (assessmentExportAndSaveStatus.value.saveAssessmentResultToDashboard ==
        false) {
      Globals.currentAssessmentId = '';
      List<StudentAssessmentInfo> studentAssessmentInfoDblist =
          await OcrUtility.getSortedStudentInfoList(tableName: 'student_info');
      ocrAssessmentBloc.add(SaveAssessmentToDashboardAndGetId(
        isMcqSheet: widget.isMcqSheet ?? false,
        assessmentQueImage:
            studentAssessmentInfoDblist?.first?.questionImgUrl ?? '',
        assessmentName: Globals.assessmentName ?? 'Assessment Name',
        rubricScore: Globals.scoringRubric ?? '2',
        subjectName: widget.isSearchPage == true
            ? widget.selectedSubject ?? ''
            : subject ?? '',
        domainName: widget.isSearchPage == true
            ? widget.domainNameC ?? ''
            : learningStandard ?? '',
        subDomainName: subLearningStandard ?? '',
        grade: widget.selectedClass ?? '',
        schoolId: Globals.appSetting.schoolNameC ?? '',
        standardId: standardId ?? '',
        scaffoldKey: _scaffoldKey,
        context: context,
        fileId: Globals.googleExcelSheetId ?? 'Excel Id not found',
        sessionId: Globals.sessionId,
        teacherContactId: Globals.teacherId,
        teacherEmail: Globals.teacherEmailId,
        classroomCourseId: GoogleClassroomGlobals
                ?.studentAssessmentAndClassroomObj?.courseId ??
            '',
        classroomCourseWorkId: GoogleClassroomGlobals
                ?.studentAssessmentAndClassroomObj?.courseWorkId ??
            '',
      ));
    }
  }

  void showLoadingDialog({
    BuildContext? context,
    required Function(StateSetter) state,
  }) async {
    return showDialog<void>(
      useRootNavigator: false,
      context: context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          if (state != null) {
            state(setState);
          }

          return WillPopScope(
              onWillPop: () async => true,
              child: SimpleDialog(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  backgroundColor: allProcessDone == true
                      ? Colors.transparent
                      : Color(0xff000000) != Theme.of(context).backgroundColor
                          ? Color(0xff111C20)
                          : Color(0xffF7F8F9), //Colors.black54,
                  children: allProcessDone == true
                      ? <Widget>[
                          Container(
                            color: Colors.transparent,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.center,
                                    height: MediaQuery.of(context).size.height *
                                        0.18,
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.only(top: 45),
                                    decoration: BoxDecoration(
                                      color: Color(0xff000000) !=
                                              Theme.of(context).backgroundColor
                                          ? Color(0xff111C20)
                                          : Color(0xffF7F8F9),
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black,
                                            offset: Offset(0, 2),
                                            blurRadius: 10),
                                      ],
                                      // gradient: LinearGradient(
                                      //   begin: Alignment.topCenter,
                                      //   end: Alignment.bottomCenter,
                                      //   colors: [
                                      //     AppTheme.kButtonColor,
                                      //     Color(0xff000000) !=
                                      //             Theme.of(context)
                                      //                 .backgroundColor
                                      //         ? Color(0xffF7F8F9)
                                      //         : Color(0xff111C20),
                                      //   ],
                                      //   stops: [
                                      //     0.6,
                                      //     0.5,
                                      //   ],
                                      // ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Awesome!',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Student Assessments Saved Successfully',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                        ),
                                      ],
                                    )
                                    // child: FittedBox(child: pbisStudentDetailWidget)
                                    ),
                                Positioned(
                                  top: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xff000000) !=
                                                  Theme.of(context)
                                                      .backgroundColor
                                              ? Color(0xff111C20)
                                              : Color(0xffF7F8F9),
                                          width: 8),
                                      //color: AppTheme.kButtonColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.kButtonColor,
                                        //color: AppTheme.kButtonColor,
                                        shape: BoxShape.circle,
                                      ),

                                      height: 80,
                                      width: 80,
                                      child: Icon(
                                        IconData(0xe877,
                                            fontFamily: Overrides.kFontFam,
                                            fontPackage: Overrides.kFontPkg),
                                        color: Color(0xff000000) !=
                                                Theme.of(context)
                                                    .backgroundColor
                                            ? Color(0xff111C20)
                                            : Color(0xffF7F8F9),
                                        size: 40,
                                      ),
                                      // decoration: BoxDecoration(
                                      //     borderRadius:
                                      //         BorderRadius.circular(20)),
                                      // child: widget,
                                    ),
                                    //child:
                                    //  PBISCommonProfileWidget(
                                    //     studentProfile:widget.studentProfile,
                                    //     isFromStudentPlus: widget.isFromStudentPlus,
                                    //     isLoading: widget.isLoading,
                                    //     valueChange: valueChange,
                                    //     countWidget: true,
                                    //     studentValueNotifier: widget.studentValueNotifier,
                                    //     profilePictureSize: PBISPlusOverrides.profilePictureSize,
                                    //     imageUrl:
                                    //         widget.studentValueNotifier.value.profile!.photoUrl!),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]
                      : <Widget>[
                          Text(
                            "Saving",
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.bold),
                          ),
                          SpacerWidget(10),
                          ...processList
                              .map((item) => Container(
                                    margin: EdgeInsets.symmetric(vertical: 7),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: 55,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppTheme.kButtonColor),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                        ),
                                        progressWidget(value: item)
                                      ],
                                    ),
                                  ))
                              .toList(),
                          // Container(
                          //   child: ListView.builder(
                          //     //shrinkWrap: true,
                          //     itemBuilder: (context, index) {
                          //       return
                          //     },
                          //     itemCount: processList.length,
                          //   ),
                          // )

                          // Container(
                          //   height: Globals.deviceType == 'phone' ? 80 : 100,
                          //   width: Globals.deviceType == 'phone'
                          //       ? MediaQuery.of(context).size.width * 0.4
                          //       : MediaQuery.of(context).size.width * 0.5,
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Padding(
                          //         padding: const EdgeInsets.symmetric(horizontal: 10),
                          //         child: FittedBox(
                          //           child: Utility.textWidget(
                          //               text: msg ??
                          //                   GradedGlobals.loadingMessage ??
                          //                   'Please Wait...',
                          //               context: context,
                          //               textTheme: Theme.of(context)
                          //                   .textTheme
                          //                   .headline6!
                          //                   .copyWith(
                          //                     color: Color(0xff000000) !=
                          //                             Theme.of(context)
                          //                                 .backgroundColor
                          //                         ? Color(0xffFFFFFF)
                          //                         : Color(0xff000000),
                          //                     fontSize: Globals.deviceType == "phone"
                          //                         ? AppTheme.kBottomSheetTitleSize
                          //                         : AppTheme.kBottomSheetTitleSize *
                          //                             1.3,
                          //                   )),
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         height: 10,
                          //       ),
                          //       Container(
                          //         alignment: Alignment.center,
                          //         margin: EdgeInsets.symmetric(horizontal: 10),
                          //         child: CircularProgressIndicator(
                          //           color: isOCR! ? AppTheme.kButtonColor : null,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // )
                        ]));
        });
      },
    );
  }

  Widget progressWidget({required String value}) {
    if ((value == 'Google Sheet' &&
            assessmentExportAndSaveStatus.value.excelSheetPrepared) ||
        (value == 'Google Slides' &&
            assessmentExportAndSaveStatus.value.slidePrepared) ||
        (value == 'Google Classroom' &&
            assessmentExportAndSaveStatus.value.saveGoogleClassroom) ||
        (value == '${Globals.schoolDbnC} Dashboard' &&
            assessmentExportAndSaveStatus
                .value.saveAssessmentResultToDashboard)) {
      return Icon(
        IconData(0xe877,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        color: AppTheme.kButtonColor,
      );
    } else {
      return CupertinoActivityIndicator(
        color: AppTheme.kButtonColor,
      );
    }
  }
}
