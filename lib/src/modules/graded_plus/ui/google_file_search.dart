import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/google_drive/model/assessment.dart';
import 'package:Soc/src/modules/graded_plus/helper/result_action_icon_modal.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/results_summary.dart';
import 'package:Soc/src/modules/graded_plus/widgets/filter_bottom_sheet.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/local_database/hive_db_services.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/services/strings.dart';
import 'package:Soc/src/widgets/debouncer.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share/share.dart';
import '../../../services/utility.dart';
import '../../google_classroom/services/google_classroom_globals.dart';
import '../../google_classroom/modal/google_classroom_courses.dart';
import '../../google_drive/model/recent_google_file.dart';
import '../widgets/graded_plus_result_summary_action_bottom_sheet.dart';

class GoogleFileSearchPage extends StatefulWidget {
  final ScrollController? scrollController;
  final String selectedFilterValue;
  GoogleFileSearchPage(
      {Key? key,
      required this.scrollController,
      required this.selectedFilterValue})
      : super(key: key);
  @override
  _GoogleFileSearchPageState createState() => _GoogleFileSearchPageState();
}

class _GoogleFileSearchPageState extends State<GoogleFileSearchPage>
    with WidgetsBindingObserver {
  bool issuggestionList = false;
  static const double _kLabelSpacing = 20.0;
  static const double _kMargin = 16.0;
  final _controller = TextEditingController();
  // final refreshKey = GlobalKey<RefreshIndicatorState>();
  bool isErrorState = false;
  final GoogleDriveBloc googleBloc = new GoogleDriveBloc();
  FocusNode myFocusNode = new FocusNode();
  final _debouncer = Debouncer(milliseconds: 500);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static const double _kIconSize = 38.0;
  bool? isDBListEmpty = true;
  List<dynamic> searchList = [];
  String? searchId;
  dynamic recordObject;
  ValueNotifier<bool> updateTheUi = ValueNotifier<bool>(false);
  final ValueNotifier<String> selectedValue = ValueNotifier<String>('All');

  onItemChanged(String? searchKey) {
    // suggestionsList = true;
    // setState(() {
    if (searchKey != "") {
      issuggestionList = true;
    }

    if (issuggestionList == true) {
      _debouncer.run(() {
        // _homeBloc.add(GlobalSearchEvent(keyword: value));
        googleBloc.add(GetHistoryAssessmentFromDrive(
            isSearchPage: true,
            searchKeyword: searchKey!,
            filterType: selectedValue.value));
        updateTheUi.value = !updateTheUi.value;
        // setState(() {});
      });
    }
    // });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // print('Google Search Page');
    _setLocked();
    Globals.callSnackbar = true;
    getListLength();
    selectedValue.value = widget.selectedFilterValue;
    FirebaseAnalyticsService.addCustomAnalyticsEvent("google_file_search_page");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'google_file_search_page',
        screenClass: 'GoogleFileSearchPage');
  }

  @override
  dispose() {
    _setFree();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  getListLength() async {
    int length =
        await HiveDbServices().getListLength(Strings.googleRecentSearch);
    length < 1 ? isDBListEmpty = true : isDBListEmpty = false;
  }

  getListData(String localDatalogName) async {
    List listItem = await HiveDbServices().getListData(localDatalogName);
    return listItem;
  }

  deleteItem(String localDatalogName) async {
    int itemCount = await HiveDbServices().getListLength(localDatalogName);
    if (itemCount > 5) {
      await HiveDbServices().deleteData(localDatalogName, 0);
    }
  }

  Widget _buildSearchBar() {
    return SizedBox(
      height: 80,
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        padding: EdgeInsets.symmetric(
            vertical: _kLabelSpacing / 3, horizontal: _kLabelSpacing / 2),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            //side: BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.transparent,
          child: TranslationWidget(
              message: 'Google File Search',
              fromLanguage: "en",
              toLanguage: Globals.selectedLanguage,
              builder: (translatedMessage) {
                return TextFormField(
                  enabled: true,
                  autofocus: true,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryVariant),
                  focusNode: myFocusNode,
                  controller: _controller,
                  cursorColor: Theme.of(context).colorScheme.primaryVariant,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide:
                          BorderSide(color: AppTheme.kButtonColor, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 2),
                    ),
                    hintText: translatedMessage.toString(),
                    // hintStyle: TextStyle(color: Color(0xffAAAAAA), fontSize: 15),
                    fillColor:
                        Color(0xff000000) != Theme.of(context).backgroundColor
                            ? Theme.of(context).colorScheme.secondary
                            : Color.fromARGB(255, 12, 20, 23),
                    prefixIcon: Icon(
                      const IconData(0xe805,
                          fontFamily: Overrides.kFontFam,
                          fontPackage: Overrides.kFontPkg),
                      color: Theme.of(context).colorScheme.primaryVariant,
                      size: Globals.deviceType == "phone" ? 20 : 28,
                    ),
                    suffixIcon: _controller.text.isEmpty
                        ? null
                        : InkWell(
                            onTap: () {
                              // setState(() {
                              //   _controller.clear();
                              //   issuggestionList = false;
                              //   FocusScope.of(context).requestFocus(FocusNode());
                              // });
                              _controller.clear();
                              issuggestionList = false;
                              FocusScope.of(context).requestFocus(FocusNode());
                              updateTheUi.value = !updateTheUi.value;
                            },
                            child: Icon(
                              Icons.clear,
                              color:
                                  Theme.of(context).colorScheme.primaryVariant,
                              size: Globals.deviceType == "phone" ? 20 : 28,
                            ),
                          ),
                  ),
                  onChanged: onItemChanged,
                );
              }),
        ),
      ),
    );
  }

  Widget _buildRecentItemList() {
    return ValueListenableBuilder(
        valueListenable: selectedValue,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return FutureBuilder(
              future: HiveDbServices().getListData(Strings.googleRecentSearch),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                }
                // if (snapshot.connectionState == ConnectionState.done) {
                List reverseList = List.from(snapshot.data.reversed);
                List list = [];
                list.addAll(reverseList);

                if (selectedValue.value == 'Multiple Choice') {
                  list.removeWhere((element) =>
                      element.assessmentType != selectedValue.value ||
                      element.assessmentType == null);
                } else if (selectedValue.value == 'Constructed Response') {
                  list.removeWhere((element) =>
                      element.assessmentType != selectedValue.value &&
                      element.assessmentType != null);
                }
                return list != null && list.length > 0
                    ? Expanded(
                        child: ListView.builder(
                          controller: widget.scrollController,
                          padding:
                              EdgeInsets.only(bottom: _kLabelSpacing * 1.5),
                          scrollDirection: Axis.vertical,
                          itemCount: list.length < 10 ? list.length : 10,
                          itemBuilder: (BuildContext context, int index) {
                            // return _buildRecentItem(index, snapshot.data);
                            return _buildRecentItem(index, list);
                          },
                        ),
                      )
                    : Expanded(
                        child: NoDataFoundErrorWidget(
                          isSearchpage: true,
                          isResultNotFoundMsg: false,
                          marginTop: MediaQuery.of(context).size.height * 0.15,
                          isNews: false,
                          isEvents: false,
                        ),
                      );
              });
        });
  }

  Widget _buildRecentItem(int index, items) {
    return InkWell(
      onTap: () async {},
      child: Container(
        margin: EdgeInsets.only(
            left: _kMargin - 8, right: _kMargin, top: 6, bottom: 6),
        padding: EdgeInsets.only(
          left: _kMargin - 13, right: _kMargin,
          // top: 12, bottom: 12
        ),
        decoration: BoxDecoration(
          color: (index % 2 == 0)
              ? Theme.of(context).colorScheme.background == Color(0xff000000)
                  ? AppTheme.klistTilePrimaryDark
                  : AppTheme
                      .klistTilePrimaryLight //Theme.of(context).colorScheme.background
              : Theme.of(context).colorScheme.background == Color(0xff000000)
                  ? AppTheme.klistTileSecoandryDark
                  : AppTheme.klistTileSecoandryLight,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              spreadRadius: 0,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.only(top: 8),
            //color: Colors.amber,
            child: Icon(
                IconData(
                    items[index].assessmentType == 'Multiple Choice'
                        ? 0xe833
                        : 0xe87c,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                size: Globals.deviceType == 'phone'
                    ? (items[index].assessmentType == 'Multiple Choice'
                        ? 30
                        : 28)
                    : 38,
                color: AppTheme.kButtonColor),
          ),
          minLeadingWidth: 0,
          title: TranslationWidget(
            message: (items[index].title != null && items[index].title != ''
                ? '${items[index].title} '
                : 'Unknown'),
            toLanguage: Globals.selectedLanguage,
            fromLanguage: "en",
            builder: (translatedMessage) => Text(
              translatedMessage.toString(),
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: Theme.of(context).colorScheme.primaryVariant),
            ),
          ),
          // subtitle: Utility.textWidget(
          //     context: context,
          //     textTheme: Theme.of(context)
          //         .textTheme
          //         .subtitle2!
          //         .copyWith(color: Colors.grey.shade500),
          //     text: items[index].modifiedDate != null
          //         ? Utility.convertTimestampToDateFormat(
          //             DateTime.parse(items[index].modifiedDate!), "MM/dd/yy")
          //         : ""),
          // trailing: GestureDetector(
          //   onTap: () {
          //     PlusUtility.updateLogs(
          //         activityType: 'GRADED+',
          //         userType: 'Teacher',
          //         activityId: '13',
          //         sessionId: items[index].sessionId != ''
          //             ? items[index].sessionId
          //             : '',
          //         description:
          //             'Teacher tap on Share Button on assessment summery page',
          //         operationResult: 'Success');

          //     if (items[index].webContentLink != null &&
          //         items[index].webContentLink != '') {
          //       Share.share(items[index].webContentLink!);
          //     }
          //   },
          //   child: Icon(
          //     IconData(0xe876,
          //         fontFamily: Overrides.kFontFam,
          //         fontPackage: Overrides.kFontPkg),
          //     color: Color(0xff000000) != Theme.of(context).backgroundColor
          //         ? Color(0xff111C20)
          //         : Color(0xffF7F8F9),
          //     size: Globals.deviceType == 'phone' ? 28 : 38,
          //   ),
          // ),
          onTap: () async {
            List<dynamic> recentDetailDbList =
                await getListData(Strings.googleRecentSearch);
            List<dynamic> reversedRecentDetailDbList =
                new List.from(recentDetailDbList.reversed);
            //For GRADED+ Standalone
            if (Overrides.STANDALONE_GRADED_APP) {
              GoogleClassroomOverrides.studentAssessmentAndClassroomObj =
                  GoogleClassroomCourses();

              GoogleClassroomOverrides.studentAssessmentAndClassroomObj =
                  GoogleClassroomCourses(
                      assessmentCId:
                          reversedRecentDetailDbList[index].assessmentId,
                      courseId:
                          reversedRecentDetailDbList[index].classroomCourseId,
                      courseWorkId: reversedRecentDetailDbList[index]
                          .classroomCourseWorkId);
            }
            //For Standard App
            else {
              GoogleClassroomOverrides
                      .historyStudentResultSummaryForStandardApp =
                  ClassroomCourse();

              GoogleClassroomOverrides
                      .historyStudentResultSummaryForStandardApp =
                  await ClassroomCourse(
                      assessmentCId:
                          reversedRecentDetailDbList[index].assessmentId,
                      id: reversedRecentDetailDbList[index].classroomCourseId,
                      courseWorkId: reversedRecentDetailDbList[index]
                          .classroomCourseWorkId,
                      courseWorkURL: reversedRecentDetailDbList[index]
                          .classroomCourseWorkUrl);
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GradedPlusResultsSummary(
                        createdAsPremium: reversedRecentDetailDbList[index]
                                    .isCreatedAsPremium
                                    .toLowerCase() ==
                                'true'
                            ? true
                            : false as bool?,
                        obj: reversedRecentDetailDbList[index],
                        assessmentName:
                            reversedRecentDetailDbList[index].title!,
                        shareLink:
                            reversedRecentDetailDbList[index].webContentLink,
                        fileId: reversedRecentDetailDbList[index].fileId,
                        assessmentDetailPage: true,
                      )),
            );
          },

          trailing: IconButton(
            icon: Icon(
                IconData(0xe868,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color: AppTheme.kButtonColor),
            onPressed: () async {
              List<dynamic> recentDetailDbList =
                  await getListData(Strings.googleRecentSearch);

              List<dynamic> reversedRecentDetailDbList =
                  new List.from(recentDetailDbList.reversed);

              _saveAndShareBottomSheetMenu(
                  assessment: reversedRecentDetailDbList[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionList() {
    return BlocBuilder<GoogleDriveBloc, GoogleDriveState>(
        bloc: googleBloc,
        builder: (BuildContext context, GoogleDriveState state) {
          if (state is GoogleDriveGetSuccess) {
            searchList.clear();
            searchList.addAll(state.obj);

            return searchList.length > 0
                ? Expanded(
                    child: ValueListenableBuilder(
                        valueListenable: selectedValue,
                        child: Container(),
                        builder: (BuildContext context, dynamic value,
                            Widget? child) {
                          List list = [];
                          list.addAll(searchList);

                          if (selectedValue.value == 'Multiple Choice') {
                            list.removeWhere((element) =>
                                element.assessmentType != selectedValue.value ||
                                element.assessmentType == null);
                          } else if (selectedValue.value ==
                              'Constructed Response') {
                            list.removeWhere((element) =>
                                element.assessmentType != selectedValue.value &&
                                element.assessmentType != null);
                          }
                          return ListView(
                            controller: widget.scrollController,
                            shrinkWrap: true,
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.only(
                                left: _kLabelSpacing / 2,
                                right: _kLabelSpacing / 2,
                                bottom: _kLabelSpacing * 1.5),
                            children: list.map<Widget>((data) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: (list.indexOf(data) % 2 == 0)
                                      ? Theme.of(context)
                                                  .colorScheme
                                                  .background ==
                                              Color(0xff000000)
                                          ? AppTheme.klistTilePrimaryDark
                                          : AppTheme
                                              .klistTilePrimaryLight //Theme.of(context).colorScheme.background
                                      : Theme.of(context)
                                                  .colorScheme
                                                  .background ==
                                              Color(0xff000000)
                                          ? AppTheme.klistTileSecoandryDark
                                          : AppTheme.klistTileSecoandryLight,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.2),
                                      spreadRadius: 0,
                                      blurRadius: 1,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                    leading: Container(
                                      padding: EdgeInsets.only(top: 8),
                                      //color: Colors.amber,
                                      child: Icon(
                                          IconData(
                                              data.assessmentType ==
                                                      'Multiple Choice'
                                                  ? 0xe833
                                                  : 0xe87c,
                                              fontFamily: Overrides.kFontFam,
                                              fontPackage: Overrides.kFontPkg),
                                          size: Globals.deviceType == 'phone'
                                              ? (data.assessmentType ==
                                                      'Multiple Choice'
                                                  ? 30
                                                  : 28)
                                              : 38,
                                          color: AppTheme.kButtonColor),
                                    ),
                                    minLeadingWidth: 0,
                                    title: TranslationWidget(
                                      message: data.title ?? "Unknown",
                                      toLanguage: Globals.selectedLanguage,
                                      fromLanguage: "en",
                                      builder: (translatedMessage) => Text(
                                          translatedMessage.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primaryVariant)),
                                    ),
                                    subtitle: Utility.textWidget(
                                        context: context,
                                        textTheme: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(
                                                color: Colors.grey.shade500),
                                        text: data.modifiedDate != null
                                            ? Utility
                                                .convertTimestampToDateFormat(
                                                    DateTime.parse(
                                                        data.modifiedDate!),
                                                    "MM/dd/yy")
                                            : ""),
                                    // trailing: trailingRowBuilder(element: data),
                                    trailing: IconButton(
                                      icon: Icon(
                                          IconData(0xe868,
                                              fontFamily: Overrides.kFontFam,
                                              fontPackage: Overrides.kFontPkg),
                                          color: AppTheme.kButtonColor),
                                      onPressed: () async {
                                        _saveAndShareBottomSheetMenu(
                                            assessment: data);
                                      },
                                    ),

                                    //  GestureDetector(
                                    //   onTap: () {
                                    //     PlusUtility.updateLogs(
                                    //         activityId: '13',
                                    //         sessionId: data.sessionId != ''
                                    //             ? data.sessionId
                                    //             : '',
                                    //         description:
                                    //             'Teacher tap on Share Button on assessment summery page',
                                    //         operationResult: 'Success');

                                    //     if (data.webContentLink != null &&
                                    //         data.webContentLink != '') {
                                    //       Share.share(data.webContentLink!);
                                    //     }
                                    //   },
                                    //   child: Icon(
                                    //     IconData(0xe876,
                                    //         fontFamily: Overrides.kFontFam,
                                    //         fontPackage: Overrides.kFontPkg),
                                    //     color: Color(0xff000000) !=
                                    //             Theme.of(context)
                                    //                 .backgroundColor
                                    //         ? Color(0xff111C20)
                                    //         : Color(0xffF7F8F9),
                                    //     size: Globals.deviceType == 'phone'
                                    //         ? 28
                                    //         : 38,
                                    //   ),
                                    // ),
                                    onTap: () async {
                                      List itemListData = await getListData(
                                          Strings.googleRecentSearch);

                                      List idList = [];
                                      if (itemListData.length > 0) {
                                        for (int i = 0;
                                            i < itemListData.length;
                                            i++) {
                                          idList.add(itemListData[i].fileId);
                                        }
                                      }
                                      if (!idList.contains(data.fileId)) {
                                        if (data != null) {
                                          deleteItem(
                                              Strings.googleRecentSearch);

                                          final recentitem =
                                              RecentGoogleFileSearch(
                                                  hiveobjid: 1,
                                                  createdDate: data.createdDate,
                                                  description: data.description,
                                                  fileId: data.fileId,
                                                  isCreatedAsPremium:
                                                      data.isCreatedAsPremium,
                                                  label: data.label,
                                                  modifiedDate:
                                                      data.modifiedDate,
                                                  sessionId: data.sessionId,
                                                  title: data.title,
                                                  webContentLink:
                                                      data.webContentLink,
                                                  assessmentType:
                                                      data.assessmentType,
                                                  assessmentId:
                                                      data.assessmentId,
                                                  classroomCourseId:
                                                      data.classroomCourseId,
                                                  classroomCourseWorkId: data
                                                      .classroomCourseWorkId,
                                                  classroomCourseWorkUrl: data
                                                      .classroomCourseWorkUrl);

                                          addtoDataBase(recentitem);
                                        }
                                      }
                                      // }

                                      GoogleClassroomOverrides
                                              .studentAssessmentAndClassroomObj =
                                          GoogleClassroomCourses();

                                      GoogleClassroomOverrides
                                              .studentAssessmentAndClassroomObj =
                                          GoogleClassroomCourses(
                                              assessmentCId: data.assessmentId,
                                              courseId: data.classroomCourseId,
                                              courseWorkId:
                                                  data.classroomCourseWorkId);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GradedPlusResultsSummary(
                                                  createdAsPremium: data
                                                              .isCreatedAsPremium
                                                              .toString()
                                                              .toLowerCase() ==
                                                          'true'
                                                      ? true
                                                      : false as bool?,
                                                  obj: data,
                                                  assessmentName: data.title!,
                                                  shareLink:
                                                      data.webContentLink,
                                                  fileId: data.fileId,
                                                  assessmentDetailPage: true,
                                                )),
                                      );
                                    }),
                              );
                            }).toList(),
                          );
                        }))
                : Expanded(
                    child: NoDataFoundErrorWidget(
                      isSearchpage: true,
                      isResultNotFoundMsg: false,
                      marginTop: MediaQuery.of(context).size.height * 0.15,
                      isNews: false,
                      isEvents: false,
                    ),
                  );
          } else if (state is GoogleDriveLoading) {
            return Expanded(
                child: Center(
              child: Container(
                alignment: Alignment.center,
                width: _kIconSize * 1.4,
                height: _kIconSize * 1.5,
                child: CircularProgressIndicator(
                  color: AppTheme.kButtonColor,
                  strokeWidth: 2,
                ),
              ),
            ));
          } else {
            return Container(height: 0);
          }
        });
  }

  Widget _buildHeading(String? title, TextStyle? textstyle) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // HorizontalSpacerWidget(_kLabelSpacing / 2),
          TranslationWidget(
            message: title, //"Google File Search",
            toLanguage: Globals.selectedLanguage,
            fromLanguage: "en",
            builder: (translatedMessage) => Text(
              translatedMessage.toString(),
              style: textstyle,
              textAlign: TextAlign.left,
            ),
          ),
          title == 'Google File Search'
              ? Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                        onPressed: () {
                          filterBottomSheet();
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
                        builder: (BuildContext context, dynamic value,
                            Widget? child) {
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
              : Container()
        ],
      ),
    );
  }

  void addtoDataBase(log) async {
    // bool isSuccess =
    await HiveDbServices().addData(log, Strings.googleRecentSearch);
    isDBListEmpty = false;
  }

  void addRecordDetailtoLocalDb(dynamic log) async {
    await HiveDbServices().addData(log, Strings.googleRecentSearch);
  }

  void updateRecordList(List<dynamic> log) async {
    LocalDatabase<dynamic>? _localDb =
        LocalDatabase(Strings.googleRecentSearch);
    log.forEach((dynamic e) {
      _localDb.addData(e);
    });
    _localDb.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: body(),
    );
  }

  Widget body() {
    return ValueListenableBuilder(
        valueListenable: updateTheUi,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return OfflineBuilder(
              connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
              ) {
                final bool connected = connectivity != ConnectivityResult.none;

                if (connected) {
                  if (isErrorState == true) {
                    isErrorState = false;
                  }
                } else if (!connected) {
                  isErrorState = true;
                }

                return Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: StudentPlusOverrides.kSymmetricPadding),
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                    SpacerWidget(StudentPlusOverrides.KVerticalSpace / 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PlusScreenTitleWidget(
                          kLabelSpacing: StudentPlusOverrides.kLabelSpacing,
                          text: 'Google File Search',
                          backButton: true,
                        ),
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            IconButton(
                                onPressed: () {
                                  filterBottomSheet();
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
                                builder: (BuildContext context, dynamic value,
                                    Widget? child) {
                                  return selectedValue.value == 'All'
                                      ? Container()
                                      : Wrap(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 6, right: 6),
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
                      ],
                    ),
                    SpacerWidget(_kLabelSpacing / 2),
                    _buildSearchBar(),
                    issuggestionList
                        ? _buildSuggestionList()
                        : SizedBox(height: 0),
                    SpacerWidget(_kLabelSpacing / 2),
                    issuggestionList == false
                        ? _buildHeading(
                            "Recent Searches",
                            Theme.of(context)
                                .appBarTheme
                                .titleTextStyle!
                                .copyWith(
                                    fontSize: 18,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryVariant,
                                    fontWeight: FontWeight.w500),
                          ) //_buildHeading2()
                        : SizedBox(height: 0),
                    issuggestionList == false
                        ? _buildRecentItemList()
                        : SizedBox(height: 0),
                  ]),
                );
              },
              child: Container());
        });
  }

  Future _setFree() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future _setLocked() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  filterBottomSheet() {
    showModalBottomSheet(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        useRootNavigator: true,
        // animationCurve: Curves.easeOutQuart,
        elevation: 10,
        context: context,
        builder: (context) => FilterBottomSheet(
              title: 'Filter Assignment',
              selectedValue: selectedValue.value,
              update: ({String? filterValue}) async {
                selectedValue.value = filterValue!;
              },
            ));
  }

  // Widget trailingRowBuilder({required HistoryAssessment element}) {
  //   return Row(mainAxisSize: MainAxisSize.min, children: [
  //     if (element.presentationLink != null &&
  //         element.presentationLink!.isNotEmpty)
  //       GestureDetector(
  //           onTap: () {
  //             PlusUtility.updateLogs(
  //                 activityType: 'GRADED+',
  //                 userType: 'Teacher',
  //                 activityId: '31',
  //                 sessionId: element.sessionId != null ? element.sessionId : '',
  //                 description: 'Slide Icon Pressed - Google Search List',
  //                 operationResult: 'Success');

  //             Utility.launchUrlOnExternalBrowser(element.presentationLink!);
  //           },
  //           child: Padding(
  //             padding: const EdgeInsets.all(5.0),
  //             child: SvgPicture.asset(
  //               'assets/ocr_result_section_bottom_button_icons/Slide.svg',
  //               width: Globals.deviceType == "phone" ? 28 : 40,
  //               height: Globals.deviceType == "phone" ? 28 : 40,
  //             ),
  //           )),
  //     GestureDetector(
  //       onTap: () {
  //         PlusUtility.updateLogs(
  //             activityType: 'GRADED+',
  //             userType: 'Teacher',
  //             activityId: '13',
  //             sessionId: element.sessionId != null ? element.sessionId : '',
  //             description: 'Teacher tap on Share Button - Google Search List',
  //             operationResult: 'Success');

  //         if (element.webContentLink != null && element.webContentLink != '') {
  //           Share.share(element.webContentLink!);
  //         }
  //       },
  //       child: Icon(
  //         IconData(0xe876,
  //             fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
  //         color: Color(0xff000000) != Theme.of(context).backgroundColor
  //             ? Color(0xff111C20)
  //             : Color(0xffF7F8F9),
  //         size: Globals.deviceType == 'phone' ? 28 : 38,
  //       ),
  //     ),
  //   ]);
  // }

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
                  'Class': assessment.classroomCourseWorkUrl ?? '',
                },
              );
            },
          );
        });
  }
}
