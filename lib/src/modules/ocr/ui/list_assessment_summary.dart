import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/model/assessment.dart';
import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/ocr/ui/google_search.dart';
import 'package:Soc/src/modules/ocr/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/widgets/ocr_background_widget.dart';
import 'package:Soc/src/modules/ocr/ui/results_summary.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';
import '../../../services/local_database/local_db.dart';
import '../../google_drive/bloc/google_drive_bloc.dart';
import '../widgets/searchbar_widget.dart';

class AssessmentSummary extends StatefulWidget {
  final bool isFromHomeSection;
  AssessmentSummary({Key? key, required this.isFromHomeSection})
      : super(key: key);
  @override
  State<AssessmentSummary> createState() => _AssessmentSummaryState();
}

class _AssessmentSummaryState extends State<AssessmentSummary> {
  static const double _KVertcalSpace = 60.0;
  GoogleDriveBloc _driveBloc = GoogleDriveBloc();
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
  LocalDatabase<StudentAssessmentInfo> _historyStudentInfoDb =
      LocalDatabase('history_student_info');
  ScrollController _scrollController = ScrollController();
//  late ScrollController _controller;
  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_scrollListener);
    _driveBloc.add(GetHistoryAssessmentFromDrive());

    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   refreshPage(isFromPullToRefresh: false);
    // });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      refreshPage(isFromPullToRefresh: false);
    });

    // _driveBloc.add(GetHistoryAssessmentFromDrive());

    // _controller = new ScrollController()..addListener(_scrollListener);

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
        CommonBackGroundImgWidget(),
        WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            appBar: CustomOcrAppBarWidget(
              onTap: () {
                Utility.scrollToTop(scrollController: _scrollController);
              },
              isSuccessState: ValueNotifier<bool>(true),
              isbackOnSuccess: isBackFromCamera,
              key: GlobalKey(),
              isBackButton: widget.isFromHomeSection,
              assessmentDetailPage: true,
              assessmentPage: true,
              scaffoldKey: _scaffoldKey,
              isFromResultSection:
                  widget.isFromHomeSection == false ? true : null,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SpacerWidget(_KVertcalSpace / 4),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Utility.textWidget(
                    text: 'Assignment History',
                    context: context,
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                SpacerWidget(_KVertcalSpace / 3),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 30),
                  child: SearchBar(
                    stateName: '',
                    isSearchPage: false,
                    isSubLearningPage: false,
                    readOnly: true,
                    controller: searchAssessmentController,
                    onSaved: (String value) {
                      // if (value != null && value.isNotEmpty) {
                      //   isSearch.value = true;

                      //Calling local search only
                      // _driveBloc2
                      //     .add(GetAssessmentSearchDetails(keyword: value));
                      // }
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GoogleSearchWidget()),
                      );
                      // print('taped');
                    },
                  ),
                ),
                SpacerWidget(_KVertcalSpace / 5),
                Expanded(
                  child: RefreshIndicator(
                    color: AppTheme.kButtonColor,
                    key: refreshKey,
                    onRefresh: () => refreshPage(isFromPullToRefresh: true),
                    child: ValueListenableBuilder(
                        valueListenable: isSearch,
                        builder:
                            (BuildContext context, bool value, Widget? child) {
                          return BlocConsumer(
                              bloc:
                                  // isSearch.value == false
                                  // ?
                                  _driveBloc,

                              // : _driveBloc2,
                              builder: (BuildContext context,
                                  GoogleDriveState state) {
                                if (state is GoogleDriveGetSuccess) {
                                  nextPageUrl = state.nextPageLink;
                                  bool isloading = true;
                                  if (state.nextPageLink == '') {
                                    isloading = false;
                                  }
                                  // bool isloading
                                  lastAssessmentHistoryListbj = state.obj;
                                  return state.obj != null &&
                                          state.obj.length > 0
                                      ? listView(state.obj, isloading)
                                      : Expanded(
                                          child: NoDataFoundErrorWidget(
                                              isResultNotFoundMsg: true,
                                              isNews: false,
                                              isEvents: false),
                                        );
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
                                      'Reauthentication is required') {
                                    await Utility.refreshAuthenticationToken(
                                        isNavigator: false,
                                        errorMsg: state.errorMsg!,
                                        context: context,
                                        scaffoldKey: _scaffoldKey);

                                    _driveBloc
                                        .add(GetHistoryAssessmentFromDrive());
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
                        }),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget listView(List<HistoryAssessment> _list, bool isLoading) {
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.792
          : MediaQuery.of(context).size.height * 0.45,
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        // padding: EdgeInsets.only(bottom: AppTheme.klistPadding),
        scrollDirection: Axis.vertical,
        itemCount: _list.length + 1,
        itemBuilder: (BuildContext context, int index) {
          return index == _list.length
              ? isLoading == true
                  ? Container(
                      padding: EdgeInsets.only(top: 15),
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

                    // Theme.of(context).colorScheme.background ==
                    //     Color(0xff000000)
                    // ? Color(0xffF7F8F9)
                    // : Color(0xff162429),
                    // border: Border.all(color: Colors.white),
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
                    text:
                        'All Assignment Caught Up', //'You\'re All Caught Up', //'Yay! Assessment Result List Updated',
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
                    text:
                        'You\'ve fetched all the available files from Graded+ Assignment',
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
    return Column(
      children: [
        InkWell(
          onTap: () async {
            bool createdAsPremium = false;
            if (list[index].isCreatedAsPremium == "true") {
              createdAsPremium = true;
            }
            await _historyStudentInfoDb.clear();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ResultsSummary(
                        createdAsPremium: createdAsPremium,
                        obj: list[index],
                        asssessmentName: list[index].title!,
                        shareLink: list[index].webContentLink,
                        fileId: list[index].fileid,
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
                visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                subtitle: Utility.textWidget(
                    context: context,
                    textTheme: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(color: Colors.grey.shade500),
                    text: list[index].modifiedDate != null
                        ? Utility.convertTimestampToDateFormat(
                            DateTime.parse(list[index].modifiedDate!),
                            "MM/dd/yy")
                        : ""),
                title: Utility.textWidget(
                    text: list[index].title == null
                        ? 'Asssessment Name not found'
                        : list[index].title!,
                    context: context,
                    textTheme: Theme.of(context).textTheme.headline2),
                // subtitle:
                trailing: GestureDetector(
                  onTap: () {
                    Utility.updateLoges(
                        activityId: '13',
                        sessionId: list[index].sessionId != null
                            ? list[index].sessionId
                            : '',
                        description:
                            'Teacher tap on Share Button on Assignment summery page',
                        operationResult: 'Success');

                    if (list[index].webContentLink != null &&
                        list[index].webContentLink != '') {
                      Share.share(list[index].webContentLink!);
                    }
                    // : print("no web link $index");
                  },
                  child: Icon(
                    IconData(0xe876,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color:
                        Color(0xff000000) != Theme.of(context).backgroundColor
                            ? Color(0xff111C20)
                            : Color(0xffF7F8F9),
                    size: Globals.deviceType == 'phone' ? 28 : 38,
                  ),
                )),
          ),
        ),
      ],
    );
  }

  Future refreshPage({required bool isFromPullToRefresh}) async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    if (isFromPullToRefresh == true) {
      _driveBloc.add(GetHistoryAssessmentFromDrive());
    }
  }

  _scrollListener() {
    ////print(_controller.position.extentAfter);
    if (_scrollController.position.atEdge &&
        nextPageUrl != '' &&
        nextPageUrl != null) {
      _driveBloc.add(UpdateHistoryAssessmentFromDrive(
          obj: lastAssessmentHistoryListbj, nextPageUrl: nextPageUrl!));
      nextPageUrl = '';
    }
  }
}
