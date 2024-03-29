import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/model/assessment.dart';
import 'package:Soc/src/modules/graded_plus/helper/result_action_icon_modal.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/results_summary.dart';
import 'package:Soc/src/modules/graded_plus/ui/google_search.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/graded_plus/widgets/filter_bottom_sheet.dart';
import 'package:Soc/src/modules/graded_plus/widgets/graded_plus_result_summary_action_bottom_sheet.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_app_search_bar.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/google_authentication.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/local_database/local_db.dart';
import '../../google_classroom/services/google_classroom_globals.dart';
import '../../google_classroom/modal/google_classroom_courses.dart';
import '../../google_drive/bloc/google_drive_bloc.dart';
import '../widgets/searchbar_widget.dart';

class GradedPlusAssessmentSummary extends StatefulWidget {
  final bool isFromHomeSection;
  final String selectedFilterValue;
  final IconData? titleIconData;
  GradedPlusAssessmentSummary(
      {Key? key,
      required this.isFromHomeSection,
      required this.selectedFilterValue,
      this.titleIconData})
      : super(key: key);
  @override
  State<GradedPlusAssessmentSummary> createState() =>
      _GradedPlusAssessmentSummaryState();
}

class _GradedPlusAssessmentSummaryState
    extends State<GradedPlusAssessmentSummary> {
  static const double _KVertcalSpace = 60.0;
  GoogleDriveBloc _driveBloc = GoogleDriveBloc(); // For All Assessment
  GoogleDriveBloc _driveMcqBloc =
      GoogleDriveBloc(); // For Multiple Choice Assessment
  GoogleDriveBloc _driveConstructiveBloc =
      GoogleDriveBloc(); // For Constructive response
  // GoogleDriveBloc _driveBloc2 = GoogleDriveBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<HistoryAssessment> lastHistoryAssess = [];
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);
  List<HistoryAssessment> lastAssessmentHistoryListbj = [];
  String? nextPageUrl = '';
//  OcrBloc _ocrBloc = OcrBloc();
  TextEditingController searchAssessmentController = TextEditingController();

  final ValueNotifier<bool> isSearch = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isCallPaginationApi = ValueNotifier<bool>(false);
  // LocalDatabase<StudentAssessmentInfo> _historyStudentInfoDb =
  //     LocalDatabase('history_student_info');
  ScrollController _scrollController = ScrollController();
  final ValueNotifier<String> selectedValue = ValueNotifier<String>('All');
  FocusNode myFocusNode = new FocusNode();
//  late ScrollController _controller;
  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_scrollListener);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      selectedValue.value = Globals.selectedFilterValue;
      refreshPage(isFromPullToRefresh: false, delayInSeconds: 0);
    });

    PlusUtility.updateLogs(
        activityType: 'GRADED+',
        userType: 'Teacher',
        activityId: '4',
        description: 'Moved to history screen Graded+',
        operationResult: 'Success');

    FirebaseAnalyticsService.addCustomAnalyticsEvent("assessment_summary");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'assessment_summary', screenClass: 'AssessmentSummary');
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.transparent,
              appBar: CustomOcrAppBarWidget(
                commonLogoPath:
                    Color(0xff000000) == Theme.of(context).backgroundColor
                        ? "assets/images/graded+_light.png"
                        : "assets/images/graded+_dark.png",
                refresh: (v) {
                  setState(() {});
                },
                iconData: widget.titleIconData,
                plusAppName: 'GRADED+',
                fromGradedPlus: true,
                onTap: () {
                  Utility.scrollToTop(scrollController: _scrollController);
                },
                isSuccessState: ValueNotifier<bool>(true),
                isBackOnSuccess: isBackFromCamera,
                key: GlobalKey(),
                isBackButton: widget.isFromHomeSection,
                assessmentDetailPage: true,
                assessmentPage: true,
                scaffoldKey: _scaffoldKey,
                isFromResultSection:
                    widget.isFromHomeSection == false ? true : null,
              ),
              body: body()),
        )
      ],
    );
  }

  Widget body() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: StudentPlusOverrides.kSymmetricPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpacerWidget(StudentPlusOverrides.KVerticalSpace / 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            PlusScreenTitleWidget(
                kLabelSpacing: StudentPlusOverrides.kLabelSpacing,
                text: 'Assignment History'),
            Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      filterBottomSheet();
                      print("yes");
                    },
                    icon: Icon(
                      IconData(0xe87d,
                          fontFamily: Overrides.kFontFam,
                          fontPackage: Overrides.kFontPkg),
                      color: AppTheme.kButtonColor,
                      size: 28,
                    )),
                ValueListenableBuilder(
                    valueListenable: selectedValue,
                    child: Container(),
                    builder:
                        (BuildContext context, dynamic value, Widget? child) {
                      return selectedValue.value == 'All'
                          ? Container()
                          : Wrap(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 6, right: 6),
                                  height: 7,
                                  width: 7,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle),
                                ),
                              ],
                            );
                    })
              ],
            )
          ]),
          SpacerWidget(_KVertcalSpace / 3),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 50),
            child: PlusAppSearchBar(
              sectionName: 'GRADED+',
              hintText: "Search",
              onTap: () async {
                var result = Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GoogleSearchWidget(
                            titleIconData: widget.titleIconData,
                            selectedFilterValue: selectedValue.value,
                          )),
                );
                if (result == true) {
                  Utility.closeKeyboard(context);
                }
              },
              isMainPage: false,
              autoFocus: false,
              controller: searchAssessmentController,
              kLabelSpacing: 1,
              focusNode: myFocusNode,
              onItemChanged: null,
            ),

            //  SearchBar(
            //   stateName: '',
            //   isSearchPage: false,
            //   isSubLearningPage: false,
            //   readOnly: true,
            //   controller: searchAssessmentController,
            //   onSaved: (String value) {},
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => GoogleSearchWidget(
            //                 selectedFilterValue: selectedValue.value,
            //               )),
            //     );
            //   },
            // ),
          ),
          // SpacerWidget(_KVertcalSpace / 8),
          Expanded(
            child: RefreshIndicator(
              color: AppTheme.kButtonColor,
              key: refreshKey,
              onRefresh: () => refreshPage(isFromPullToRefresh: true),
              child: ValueListenableBuilder(
                  valueListenable: isSearch,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return ValueListenableBuilder(
                        valueListenable: selectedValue,
                        builder: (BuildContext context, String value,
                            Widget? child) {
                          return BlocConsumer(
                              bloc: selectedValue.value == 'Multiple Choice'
                                  ? _driveMcqBloc
                                  : (selectedValue.value ==
                                          'Constructed Response'
                                      ? _driveConstructiveBloc
                                      : _driveBloc),

                              // : _driveBloc2,
                              builder: (BuildContext context,
                                  GoogleDriveState state) {
                                // print(state);
                                if (state is GoogleDriveGetSuccess) {
                                  nextPageUrl = state.nextPageLink;
                                  bool isLoading = true;
                                  if (state.nextPageLink == '') {
                                    isLoading = false;
                                  }
                                  // bool isLoading
                                  lastAssessmentHistoryListbj = state.obj;
                                  if (nextPageUrl != '') {
                                    isLoading = true;
                                  }

                                  return state.obj != null &&
                                          state.obj.length > 0
                                      ? listView(state.obj, isLoading)
                                      : NoDataFoundErrorWidget(
                                          isResultNotFoundMsg: true,
                                          isNews: false,
                                          isEvents: false);
                                } else if (state is GoogleDriveLoading) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryVariant,
                                    )),
                                  );
                                }

                                return Container();
                              },
                              listener: (BuildContext contxt,
                                  GoogleDriveState state) async {
                                if (state is ErrorState) {
                                  if (state.errorMsg ==
                                      'ReAuthentication is required') {
                                    // await Utility.refreshAuthenticationToken(
                                    //     isNavigator: false,
                                    //     errorMsg: state.errorMsg!,
                                    //     context: context,
                                    //     scaffoldKey: _scaffoldKey);
                                    await Authentication
                                        .reAuthenticationRequired(
                                            context: context,
                                            errorMessage: state.errorMsg!,
                                            scaffoldKey: _scaffoldKey);
                                    _driveBloc.add(
                                        GetHistoryAssessmentFromDrive(
                                            isSearchPage: false,
                                            filterType: selectedValue.value));
                                  } else {
                                    Navigator.of(context).pop();
                                    Utility.currentScreenSnackBar(
                                        "Something Went Wrong. Please Try Again.",
                                        null);
                                  }
                                } else if (state is GoogleDriveLoading) {
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryVariant,
                                    )),
                                  );
                                }
                              });
                        });
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget listView(List<HistoryAssessment> _list, bool isLoading) {
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.792
          : MediaQuery.of(context).size.height * 0.45,
      child: ListView.builder(
        controller: _list.length > 5 ? _scrollController : null,
        shrinkWrap: true,
        // padding: EdgeInsets.only(bottom: AppTheme.klistPadding),
        scrollDirection: Axis.vertical,
        itemCount: _list.length + 1,
        itemBuilder: (BuildContext context, int index) {
          return index == _list.length
              ? isLoading == true
                  ? Container(
                      padding: EdgeInsets.only(top: 15, bottom: 40),
                      child: Center(
                        child: Platform.isIOS
                            ? CupertinoActivityIndicator(
                                color: AppTheme.kButtonbackColor,
                              )
                            : Container(
                                margin: EdgeInsets.only(bottom: 15),
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: AppTheme.kButtonColor,
                                ),
                              ),
                      ))
                  : allCaughtUp()
              : _buildList(_list, index);
        },
      ),
    );
  }

  Widget allCaughtUp() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Row(children: [
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Divider(
                    color: Theme.of(context).colorScheme.background ==
                            Color(0xff000000)
                        ? Colors.white
                        : Colors.black,
                    height: 40,
                  )),
            ),
            Container(
              width: 50,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return RadialGradient(
                        center: Alignment.topLeft,
                        radius: 0.5,
                        colors: <Color>[
                          AppTheme.kButtonColor,
                          AppTheme.kSelectedColor,
                        ],
                        tileMode: TileMode.repeated,
                      ).createShader(bounds);
                    },
                    child: Icon(Icons.done, color: AppTheme.kButtonColor),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background ==
                            Color(0xff000000)
                        ? Color(0xff111C20)
                        : Color(0xffF7F8F9),
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppTheme.kButtonColor,
                  AppTheme.kSelectedColor,
                ]),
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                  child: Divider(
                    color: Theme.of(context).colorScheme.background ==
                            Color(0xff000000)
                        ? Colors.white
                        : Colors.black,
                    height: 40,
                  )),
            ),
          ]),
          Container(
            padding: EdgeInsets.only(top: 15),
            // height: 80,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Utility.textWidget(
                    context: context,
                    text: "You're All Caught Up",
                    // text: selectedValue.value == 'All'
                    //     ? 'All Assignment Caught Up'
                    //     : selectedValue.value == 'Constructed Response'
                    //         ? 'All Constructed Assignment Caught Up'
                    //         : 'All MCQ Assignment Caught Up', //'You\'re All Caught Up', //'Yay! Assessment Result List Updated',
                    textAlign: TextAlign.center,
                    textTheme: Theme.of(context).textTheme.headline1!.copyWith(
                        color: Theme.of(context).colorScheme.background ==
                                Color(0xff000000)
                            ? Colors.white
                            : Colors.black, //AppTheme.kButtonColor,
                        fontWeight: FontWeight.bold)),
                SpacerWidget(10),
                Utility.textWidget(
                    context: context,
                    text: "You've seen all available assignments",
                    // 'You\'ve fetched all the available ${selectedValue.value == 'All' ? '' : selectedValue.value} files from Graded+ Assignment',
                    textAlign: TextAlign.center,
                    textTheme: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: Colors.grey, //AppTheme.kButtonColor,
                        )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildList(List<HistoryAssessment> list, int index) {
    return Column(children: [
      InkWell(
          onTap: () async {
            bool createdAsPremium = false;
            if (list[index].isCreatedAsPremium == "true") {
              createdAsPremium = true;
            }
            //     Globals.historyAssessmentId = list[index].assessmentId!;
            if (Overrides.STANDALONE_GRADED_APP) {
              // GoogleClassroomOverrides.studentAssessmentAndClassroomObj =
              //     GoogleClassroomCourses();

              GoogleClassroomOverrides.studentAssessmentAndClassroomObj =
                  await GoogleClassroomCourses(
                      assessmentCId: list[index].assessmentId,
                      courseId: list[index].classroomCourseId,
                      courseWorkId: list[index].classroomCourseWorkId);
            } else {
              // GoogleClassroomOverrides
              //         .historyStudentResultSummaryForStandardApp =
              //     ClassroomCourse();

              GoogleClassroomOverrides
                      .historyStudentResultSummaryForStandardApp =
                  await ClassroomCourse(
                      assessmentCId: list[index].assessmentId,
                      id: list[index].classroomCourseId,
                      courseWorkId: list[index].classroomCourseWorkId,
                      courseWorkURL: list[index].classroomCourseWorkUrl);
            }
            //update sharing url in case empty //in case of scan more
            Globals.shareableLink = list[index].webContentLink ?? '';

            Globals.shareableLink = list[index].webContentLink ?? '';

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GradedPlusResultsSummary(
                        titleIconData: widget.titleIconData,
                        createdAsPremium: createdAsPremium,
                        obj: list[index],
                        assessmentName: list[index].title!,
                        shareLink: list[index].webContentLink,
                        fileId: list[index].fileId,
                        assessmentDetailPage: true,
                      )),
            );
          },
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0.0),
                  color: (index % 2 == 0)
                      ? Theme.of(context).colorScheme.background ==
                              Color(0xff000000)
                          ? Color(0xff162429)
                          : Color(
                              0xffF7F8F9) //Theme.of(context).colorScheme.background
                      : Theme.of(context).colorScheme.background ==
                              Color(0xff000000)
                          ? Color(0xff111C20)
                          : Color(0xffE9ECEE)),
              child: ListTile(
                  leading: Container(
                    padding: EdgeInsets.only(top: 8),
                    //color: Colors.amber,
                    child: Icon(
                        IconData(
                            list[index].assessmentType == 'Multiple Choice'
                                ? 0xe833
                                : 0xe87c,
                            fontFamily: Overrides.kFontFam,
                            fontPackage: Overrides.kFontPkg),
                        size: Globals.deviceType == 'phone'
                            ? (list[index].assessmentType == 'Multiple Choice'
                                ? 30
                                : 28)
                            : 38,
                        color: AppTheme.kButtonColor),
                  ),
                  minLeadingWidth: 0,
                  visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                  subtitle: Utility.textWidget(
                      context: context,
                      textTheme: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(color: Colors.grey.shade500),
                      text: list[index].modifiedDate != null &&
                              list[index].modifiedDate != ''
                          ? Utility.convertTimestampToDateFormat(
                              DateTime.parse(list[index].modifiedDate!),
                              "MM/dd/yy")
                          : ""),
                  title: Utility.textWidget(
                      text: list[index].title == null
                          ? 'Assignment Name not found'
                          : list[index].title!,
                      context: context,
                      textTheme: Theme.of(context).textTheme.headline2),
                  // subtitle:
                  trailing: IconButton(
                      icon: Icon(
                          IconData(0xe868,
                              fontFamily: Overrides.kFontFam,
                              fontPackage: Overrides.kFontPkg),
                          color: AppTheme.kButtonColor),
                      onPressed: () {
                        _saveAndShareBottomSheetMenu(assessment: list[index]);
                      }))))
    ]);
  }

  Future refreshPage(
      {required bool isFromPullToRefresh, int? delayInSeconds}) async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(
        Duration(seconds: delayInSeconds == null ? 2 : delayInSeconds));
    if (isFromPullToRefresh == true) {
      if (selectedValue.value == 'Multiple Choice') {
        _driveMcqBloc.add(GetHistoryAssessmentFromDrive(
            filterType: selectedValue.value, isSearchPage: false));
      } else if (selectedValue.value == 'Constructed Response') {
        _driveConstructiveBloc.add(GetHistoryAssessmentFromDrive(
            filterType: selectedValue.value, isSearchPage: false));
      } else {
        _driveBloc.add(GetHistoryAssessmentFromDrive(
            filterType: selectedValue.value, isSearchPage: false));
      }
    }
  }

  _scrollListener() {
    ////print(_controller.position.extentAfter);
    if (_scrollController.position.atEdge &&
        //  _scrollController.position.extentAfter < 300 &&
        nextPageUrl != '' &&
        nextPageUrl != null) {
      if (selectedValue.value == 'Multiple Choice') {
        _driveMcqBloc.add(UpdateHistoryAssessmentFromDrive(
            filterType: selectedValue.value,
            obj: lastAssessmentHistoryListbj,
            nextPageUrl: nextPageUrl!));
      } else if (selectedValue.value == 'Constructed Response') {
        _driveConstructiveBloc.add(UpdateHistoryAssessmentFromDrive(
            filterType: selectedValue.value,
            obj: lastAssessmentHistoryListbj,
            nextPageUrl: nextPageUrl!));
      } else {
        _driveBloc.add(UpdateHistoryAssessmentFromDrive(
            filterType: selectedValue.value,
            obj: lastAssessmentHistoryListbj,
            nextPageUrl: nextPageUrl!));
      }

      nextPageUrl = '';
    }
  }

  filterBottomSheet() {
    showModalBottomSheet(
        useRootNavigator: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        // animationCurve: Curves.easeOutQuart,
        elevation: 10,
        context: context,
        builder: (context) => FilterBottomSheet(
            title: 'Filter Assignment',
            selectedValue: selectedValue.value,
            update: ({String? filterValue}) async {
              if (selectedValue.value != filterValue!) {
                if (filterValue == 'Multiple Choice') {
                  _driveMcqBloc.add(GetHistoryAssessmentFromDrive(
                      filterType: filterValue, isSearchPage: false));
                } else if (filterValue == 'Constructed Response') {
                  _driveConstructiveBloc.add(GetHistoryAssessmentFromDrive(
                      filterType: filterValue, isSearchPage: false));
                } else {
                  _driveBloc.add(GetHistoryAssessmentFromDrive(
                      filterType: filterValue, isSearchPage: false));
                }
              }
              selectedValue.value = filterValue;
              Globals.selectedFilterValue = selectedValue.value;
            }));
  }

  _saveAndShareBottomSheetMenu({required HistoryAssessment assessment}) {
    showModalBottomSheet(

        // clipBehavior: Clip.antiAliasWithSaveLayer,
        useRootNavigator: true,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        // animationCurve: Curves.easeOutQuart,
        elevation: 10,
        context: context,
        builder: (BuildContext context) {
          return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return GradedPlusResultOptionBottomSheet(
                assessmentDetailPage: false,
                height: MediaQuery.of(context).size.height * 0.45,
                //   getURlForResultSummaryIcons: getURlForBottomIcons,
                // resultSummaryIconsOnTap: bottomIconsOnTap,
                resultSummaryIconsModalList: Overrides.STANDALONE_GRADED_APP
                    ? ResultSummaryIcons
                        .standAloneHistoryResultSummaryIconsModalList
                    : ResultSummaryIcons.resultSummaryIconsModalList,
                // classroomUrlStatus: ValueNotifier<bool>(true),
                allUrls: {
                  'Share': assessment.webContentLink ?? '',
                  //  'Drive': Globals.googleDriveFolderPath ?? '',
                  'History': 'History',
                  'Dashboard': 'Dashboard',
                  'Slides': assessment.presentationLink ?? '',
                  'Sheets': assessment.webContentLink ?? '',
                  'Class': assessment.classroomCourseWorkUrl ?? ''
                });
          });
        });
  }
}
