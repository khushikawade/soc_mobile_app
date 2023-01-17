import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/custom_rubic_modal.dart';
import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/ocr/modal/subject_details_modal.dart';
import 'package:Soc/src/modules/ocr/ui/results_summary.dart';
import 'package:Soc/src/modules/ocr/ui/subject_selection/subject_selection.dart';
import 'package:Soc/src/modules/ocr/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/widgets/ocr_background_widget.dart';
import 'package:Soc/src/modules/ocr/widgets/searchbar_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bouncing_widget.dart';
import 'package:Soc/src/widgets/debouncer.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreenPage extends StatefulWidget {
  final bool? isMcqSheet;
  final String? selectedAnswer;
  final String? selectedKeyword;
  final String? grade;
  final String? questionImage;
  final String? selectedSubject;
  final String? subjectId;
  final String? stateName;

  SearchScreenPage(
      {Key? key,
      this.isMcqSheet,
      this.selectedAnswer,
      required this.selectedKeyword,
      required this.grade,
      required this.selectedSubject,
      required this.questionImage,
      required this.stateName,
      required this.subjectId})
      : super(key: key);

  @override
  State<SearchScreenPage> createState() => _SearchScreenPageState();
}

class _SearchScreenPageState extends State<SearchScreenPage> {
  final searchController = TextEditingController();
  final ValueNotifier<int> nycSubIndex1 =
      ValueNotifier<int>(5000); //To bypass the default selection
  final ValueNotifier<int> listLength =
      ValueNotifier<int>(5000); //To bypass the default selection
  GoogleDriveBloc _googleDriveBloc = new GoogleDriveBloc();

  static const double _KVertcalSpace = 60.0;
  OcrBloc _ocrBloc = OcrBloc();
  OcrBloc _ocrBloc2 = OcrBloc();
  String? standardId;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _debouncer = Debouncer(milliseconds: 10);
  List<SubjectDetailList> searchList = [];
  int standerdLearningLength = 0;
  String? learningStandard;
  String? subLearningStandard;
  final ValueNotifier<bool> isSubmitButton = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isRecentList = ValueNotifier<bool>(true);
  LocalDatabase<StudentAssessmentInfo> _studentInfoDb =
      LocalDatabase('student_info');
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _ocrBloc.add(FetchRecentSearch(
        type: 'nycSub',
        subjectName: widget.selectedKeyword,
        // isSearchPage: true,
        className: widget.grade));
    _ocrBloc2.add(FetchRecentSearch(
        type: 'nyc',
        subjectName: widget.selectedKeyword,
        // isSearchPage: true,
        className: widget.grade));

    FirebaseAnalyticsService.addCustomAnalyticsEvent("search_screen_page");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'search_screen_page', screenClass: 'SearchScreenPage');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackGroundImgWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: submitAssessmentButton(),
          appBar: CustomOcrAppBarWidget(
            onTap: () {
              Utility.scrollToTop(scrollController: _scrollController);
            },
            isSuccessState: ValueNotifier<bool>(true),
            isBackButton: true,
            isBackOnSuccess: isBackFromCamera,
            key: _scaffoldKey,
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              shrinkWrap: true,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SearchBar(
                    stateName: widget.stateName!,
                    //    isCommonCore: widget.isCommonCore,
                    isSearchPage: true,
                    readOnly: false,
                    controller: searchController,
                    onSaved: (value) {
                      if (searchController.text.isEmpty) {
                        _ocrBloc.add(FetchRecentSearch(
                            type: 'nycSub',
                            subjectName: widget.selectedKeyword,
                            // isSearchPage: true,
                            className: widget.grade));
                        _ocrBloc2.add(FetchRecentSearch(
                            type: 'nyc',
                            subjectName: widget.selectedKeyword,
                            // isSearchPage: true,
                            className: widget.grade));
                      } else {
                        _debouncer.run(() async {
                          _ocrBloc.add(SearchSubjectDetails(
                              subjectSelected: widget.selectedSubject,
                              stateName: widget.stateName!,
                              searchKeyword: searchController.text,
                              type: 'nycSub',
                              selectedKeyword: widget.selectedKeyword,
                              isSearchPage: true,
                              grade: widget.grade));
                          _ocrBloc2.add(SearchSubjectDetails(
                            subjectSelected: widget.selectedSubject,
                            searchKeyword: searchController.text,
                            type: 'nyc',
                            stateName: widget.stateName!,
                            selectedKeyword: widget.selectedKeyword,
                            isSearchPage: true,
                            grade: widget.grade,
                          ));
                          setState(() {});
                        });
                      }
                    },
                  ),
                ),
                // SpacerWidget(10),
                BlocListener<OcrBloc, OcrState>(
                  bloc: _ocrBloc,
                  listener: (context, state) {
                    if (state is RecentListSuccess) {
                      searchList.clear();
                      searchList.addAll(state.obj!);
                      listLength.value = searchList.length;
                      isRecentList.value = true;
                    } else if (state is SearchSubjectDetailsSuccess) {
                      List<SubjectDetailList> list = [];

                      for (int i = 0; i < state.obj!.length; i++) {
                        if (state.obj![i].standardAndDescriptionC!
                            .toUpperCase()
                            .contains(searchController.text.toUpperCase())) {
                          list.add(state.obj![i]);
                        }
                      }
                      searchList.clear();
                      searchList.addAll(list);
                      listLength.value = searchList.length;
                      isRecentList.value = false;
                    }
                    // do stuff here based on BlocA's state
                  },
                  child: Container(),
                ),
                BlocListener<OcrBloc, OcrState>(
                  bloc: _ocrBloc2,
                  listener: (context, state) {
                    if (state is RecentListSuccess) {
                      searchList.insertAll(0, state.obj!);
                      standerdLearningLength = state.obj!.length;
                      listLength.value = searchList.length;
                      isRecentList.value = true;
                    } else if (state is SearchSubjectDetailsSuccess) {
                      List<SubjectDetailList> list = [];

                      for (int i = 0; i < state.obj!.length; i++) {
                        if (state.obj![i].domainNameC!
                            .toUpperCase()
                            .contains(searchController.text.toUpperCase())) {
                          list.add(state.obj![i]);
                        }
                      }
                      //print(searchList[0].standardAndDescriptionC);
                      searchList.insertAll(0, list);
                      standerdLearningLength = list.length;
                      listLength.value = searchList.length;
                      isRecentList.value = false;
                    }
                    // do stuff here based on BlocA's state
                  },
                  child: Container(),
                ),
                SpacerWidget(20),
                verticalListWidget()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget verticalListWidget() {
    return ValueListenableBuilder(
        valueListenable: listLength,
        builder: (BuildContext context, dynamic value, Widget? child) {
          return buttonListWidget(list: searchList);
        });
  }

  Widget buttonListWidget({required List<SubjectDetailList> list}) {
    return ValueListenableBuilder(
        valueListenable: isRecentList,
        builder: (BuildContext context, dynamic value, Widget? child) {
          return ValueListenableBuilder(
            valueListenable: nycSubIndex1,
            builder: (BuildContext context, dynamic value, Widget? child) {
              return list.length == 0
                  ? Container(
                      height: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? MediaQuery.of(context).size.height * 0.8
                          : MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Utility.textWidget(
                                  text: 'Recent Search',
                                  context: context,
                                  textTheme: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .copyWith(fontWeight: FontWeight.bold))),
                          Expanded(
                            child: NoDataFoundErrorWidget(
                              connected: true,
                              isNews: false,
                              isEvents: false,
                              isResultNotFoundMsg: false,
                              isOcrSearch: true,
                            ),
                          )
                        ],
                      ))
                  : Container(
                      //  padding: EdgeInsets.only(bottom: 50),
                      height: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? MediaQuery.of(context).size.height * 0.8
                          : MediaQuery.of(context).size.width * 0.8,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ListView.separated(
                        controller: _scrollController,
                        itemCount: list.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                index == 0 && isRecentList.value == true
                                    ? Container(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Utility.textWidget(
                                            text: 'Recent Search',
                                            context: context,
                                            textTheme: Theme.of(context)
                                                .textTheme
                                                .headline2!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold)))
                                    : Container(),
                                index == 0 && standerdLearningLength != 0
                                    ? Container(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Utility.textWidget(
                                            text: Overrides.STANDALONE_GRADED_APP == true
                                                ? 'Common Core'
                                                : 'Learning Standard',
                                            context: context,
                                            textTheme: Theme.of(context)
                                                .textTheme
                                                .headline1!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold)))
                                    : (index == standerdLearningLength && list.length != 0
                                        ? Container(
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: Utility.textWidget(
                                                text: Overrides.STANDALONE_GRADED_APP == true
                                                    ? 'Common Core'
                                                    : 'NY Next Generation Learning Standard',
                                                context: context,
                                                textTheme: Theme.of(context)
                                                    .textTheme
                                                    .headline1!
                                                    .copyWith(fontWeight: FontWeight.bold)))
                                        : Container()),
                                Bouncing(
                                  child: InkWell(
                                    onTap: () {
                                      //subLearningStandard = list[index].standardAndDescriptionC;
                                      //if (pageIndex.value == 2) {
                                      nycSubIndex1.value = index;
                                      if (index < standerdLearningLength) {
                                        isSubmitButton.value = false;
                                        addToRecentList(
                                            type: 'nyc',
                                            obj: list[index],
                                            className: widget.grade!,
                                            subjectName:
                                                widget.selectedKeyword!);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SubjectSelection(
                                                    isMcqSheet:
                                                        widget.isMcqSheet,
                                                    selectedAnswer:
                                                        widget.selectedAnswer,
                                                    subjectId: widget.subjectId,
                                                    questionImageUrl:
                                                        widget.questionImage ??
                                                            'NA',
                                                    selectedClass: widget.grade,
                                                    isSearchPage: true,
                                                    domainNameC:
                                                        learningStandard =
                                                            list[index]
                                                                .domainNameC,
                                                    searchClass: widget.grade,
                                                    selectedSubject:
                                                        widget.selectedSubject,
                                                    stateName: widget.stateName,
                                                  )),
                                        );
                                      } else {
                                        learningStandard =
                                            list[index].domainNameC;
                                        subLearningStandard = list[index]
                                            .standardAndDescriptionC!
                                            .split(' - ')[0];
                                        standardId = list[index].id;
                                        addToRecentList(
                                            type: 'nycSub',
                                            obj: list[index],
                                            className: widget.grade!,
                                            subjectName:
                                                widget.selectedKeyword!);
                                        isSubmitButton.value = true;
                                      }
                                      // if (nycSubIndex1.value != 50000) {
                                      //   isSubmitButton.value = true;
                                      // }
                                      // }
                                    },
                                    child: AnimatedContainer(
                                      padding: EdgeInsets.only(bottom: 5),
                                      decoration: BoxDecoration(
                                        color: (nycSubIndex1.value == index)
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
                                        child: index < standerdLearningLength
                                            ? Utility.textWidget(
                                                text: list[index].domainNameC!,
                                                context: context,
                                                textTheme: Theme.of(context)
                                                    .textTheme
                                                    .headline2)
                                            : RichText(
                                                text: list[index]
                                                                .standardAndDescriptionC !=
                                                            null &&
                                                        list[index]
                                                                .standardAndDescriptionC!
                                                                .split(' - ')
                                                                .length >
                                                            1
                                                    ? TextSpan(
                                                        // Note: Styles for TextSpans must be explicitly defined.
                                                        // Child text spans will inherit styles from parent
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline2,
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: list[index]
                                                                  .standardAndDescriptionC!
                                                                  .split(
                                                                      ' - ')[0],
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline2!
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  )),
                                                          TextSpan(text: '  '),
                                                          TextSpan(
                                                            text: list[index]
                                                                .standardAndDescriptionC!
                                                                .split(
                                                                    ' - ')[1],
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline2,
                                                          ),
                                                        ],
                                                      )
                                                    : TextSpan(
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline2,
                                                        children: [
                                                            TextSpan(
                                                                text: list[index]
                                                                        .standardAndDescriptionC ??
                                                                    '')
                                                          ]),
                                              ),
                                        decoration: BoxDecoration(
                                            color: Color(0xff000000) !=
                                                    Theme.of(context)
                                                        .backgroundColor
                                                ? Color(0xffF7F8F9)
                                                : Color(0xff111C20),
                                            border: Border.all(
                                              color:
                                                  (nycSubIndex1.value == index)
                                                      ? AppTheme.kSelectedColor
                                                      : Colors.grey,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                    ),
                                  ),
                                ),
                                index == list.length - 1
                                    ? SizedBox(
                                        height: 20,
                                      )
                                    : Container()
                              ]);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SpacerWidget(_KVertcalSpace / 3.75);
                        },
                      ),
                    );
            },
          );
        });
  }

  Widget submitAssessmentButton() {
    return ValueListenableBuilder(
      valueListenable: isSubmitButton,
      child: Container(),
      builder: (BuildContext context, dynamic value, Widget? child) {
        return //pageIndex.value == 2
            isSubmitButton.value
                ? FloatingActionButton.extended(
                    backgroundColor: AppTheme.kButtonColor.withOpacity(1.0),
                    onPressed: () async {
                      LocalDatabase<CustomRubricModal> _localDb =
                          LocalDatabase('custom_rubic');
                      List<CustomRubricModal>? _localData =
                          await _localDb.getData();
                      String? rubricImgUrl;
                      // String? rubricScore;
                      for (int i = 0; i < _localData.length; i++) {
                        if (_localData[i].customOrStandardRubic == "Custom" &&
                            _localData[i].name == Globals.scoringRubric) {
                          rubricImgUrl = _localData[i].imgUrl;
                          break;
                          // rubricScore = null;
                        }
                        // if (_localData[i].name == Globals.scoringRubric &&
                        //     _localData[i].customOrStandardRubic == "Custom") {
                        //   // rubricScore = _localData[i].score;
                        // }
                        else {
                          rubricImgUrl = 'NA';
                          // rubricScore = 'NA';
                        }
                      }

                      //Adding blank fields to the list : Static data
                      List<StudentAssessmentInfo> studentInfodblist =
                          await Utility.getStudentInfoList(
                              tableName: 'student_info');

                      StudentAssessmentInfo element = studentInfodblist[0];
                      element.subject = widget.selectedKeyword;
                      element.learningStandard =
                          learningStandard == null || learningStandard == ''
                              ? "NA"
                              : learningStandard;
                      element.subLearningStandard =
                          subLearningStandard == null || learningStandard == ''
                              ? "NA"
                              : subLearningStandard;
                      element.scoringRubric = widget.isMcqSheet == true
                          ? '0-1'
                          : Globals.scoringRubric;
                      element.customRubricImage = rubricImgUrl ?? "NA";
                      element.grade = widget.grade;
                      element.className = Globals.assessmentName!.split("_")[1];
                      element.questionImgUrl = widget.questionImage == ''
                          ? "NA"
                          : widget.questionImage;
                      element.googleSlidePresentationURL =
                          Globals.googleSlidePresentationLink;
                      await _studentInfoDb.putAt(0, element);

                      _googleDriveBloc.add(UpdateDocOnDrive(
                          isMcqSheet: widget.isMcqSheet ?? false,
                          questionImage: widget.questionImage == ''
                              ? 'NA'
                              : widget.questionImage ?? 'NA',
                          createdAsPremium: Globals.isPremiumUser,
                          assessmentName: Globals.assessmentName!,
                          fileId: Globals.googleExcelSheetId,
                          isLoading: true,
                          studentData:
                              //list2
                              await Utility.getStudentInfoList(
                                  tableName: 'student_info')));
                    },
                    label: Row(
                      children: [
                        BlocListener<GoogleDriveBloc, GoogleDriveState>(
                            bloc: _googleDriveBloc,
                            child: Container(),
                            listener: (context, state) async {
                              if (state is GoogleDriveLoading) {
                                Utility.showLoadingDialog(
                                    context: context, isOCR: true);
                              }
                              if (state is GoogleSuccess) {
                                Globals.currentAssessmentId = '';
                                _ocrBloc.add(SaveAssessmentToDashboardAndGetId(
                                    isMcqSheet: widget.isMcqSheet ?? false,
                                    assessmentQueImage:
                                        widget.questionImage ?? 'NA',
                                    assessmentName: Globals.assessmentName ??
                                        'Assessment Name',
                                    rubricScore: Globals.scoringRubric ?? '2',
                                    subjectName: widget.selectedSubject ??
                                        '', //Student Id will not be there in case of custom subject
                                    domainName: learningStandard ?? '',
                                    subDomainName: subLearningStandard ?? '',
                                    grade: widget.grade ?? '',
                                    schoolId:
                                        Globals.appSetting.schoolNameC ?? '',
                                    standardId: standardId ?? '',
                                    scaffoldKey: _scaffoldKey,
                                    context: context,
                                    fileId: Globals.googleExcelSheetId ??
                                        'Excel Id not found',
                                    sessionId: Globals.sessionId,
                                    teacherContactId: Globals.teacherId,
                                    teacherEmail: Globals.teacherEmailId));
                              }
                              if (state is ErrorState) {
                                if (state.errorMsg ==
                                    'ReAuthentication is required') {
                                  await Utility.refreshAuthenticationToken(
                                      isNavigator: true,
                                      errorMsg: state.errorMsg!,
                                      context: context,
                                      scaffoldKey: _scaffoldKey);

                                  _googleDriveBloc.add(
                                    UpdateDocOnDrive(
                                      isMcqSheet: widget.isMcqSheet ?? false,
                                      questionImage: widget.questionImage == ''
                                          ? 'NA'
                                          : widget.questionImage ?? 'NA',
                                      createdAsPremium: Globals.isPremiumUser,
                                      assessmentName: Globals.assessmentName,
                                      fileId: Globals.googleExcelSheetId,
                                      isLoading: true,
                                      studentData:
                                          //list2
                                          await Utility.getStudentInfoList(
                                              tableName: 'student_info'),
                                    ),
                                  );
                                } else {
                                  Navigator.of(context).pop();
                                  Utility.currentScreenSnackBar(
                                      "Something Went Wrong. Please Try Again.",
                                      null);
                                }
                              }
                            }),
                        BlocListener<OcrBloc, OcrState>(
                            bloc: _ocrBloc,
                            child: Container(),
                            listener: (context, state) {
                              if (state is OcrLoading) {
                                //Utility.showLoadingDialog(context);
                              }
                              if (state is AssessmentIdSuccess) {
                                Navigator.of(context).pop();
                                Utility.updateLogs(
                                    // ,
                                    activityId: '14',
                                    description: 'Save to drive',
                                    operationResult: 'Success');

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResultsSummary(
                                            isMcqSheet: widget.isMcqSheet,
                                            selectedAnswer:
                                                widget.selectedAnswer,
                                            fileId: Globals.googleExcelSheetId,
                                            // subjectId:  ?? '',
                                            standardId: standardId ?? '',
                                            assessmentName:
                                                Globals.assessmentName,
                                            shareLink: '',
                                            assessmentDetailPage: false,
                                          )),
                                );
                              }
                            }),
                        Utility.textWidget(
                            text: 'Save to drive',
                            context: context,
                            textTheme: Theme.of(context)
                                .textTheme
                                .headline2!
                                .copyWith(
                                    color: Theme.of(context).backgroundColor)),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          //    margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                          child: Image(
                            width: Globals.deviceType == "phone" ? 23 : 28,
                            height: Globals.deviceType == "phone" ? 23 : 28,
                            image: AssetImage(
                              "assets/images/drive_ico.png",
                            ),
                          ),
                        ),
                      ],
                    ))
                : Container();
      },
    );
  }

  addToRecentList(
      {required String type,
      required SubjectDetailList obj,
      required String className,
      required String subjectName}) async {
    LocalDatabase<SubjectDetailList> _localDb =
        LocalDatabase("${className}${subjectName}${type}RecentList");

    List<SubjectDetailList>? _localData = await _localDb.getData();

    if (type == 'nyc') {
      bool result = true;
      for (int i = 0; i < _localData.length; i++) {
        if (obj.domainNameC == _localData[i].domainNameC) {
          result = false;
          break;
        }
      }
      if (result == true) {
        _localData.add(obj);
      }
    } else if (type == 'nycSub') {
      bool result = true;
      for (int i = 0; i < _localData.length; i++) {
        if (obj.standardAndDescriptionC ==
            _localData[i].standardAndDescriptionC) {
          result = false;
          break;
        }
      }
      if (result == true) {
        _localData.add(obj);
      }
    }

    await _localDb.clear();
    _localData.forEach((SubjectDetailList e) {
      _localDb.addData(e);
    });
  }
}
