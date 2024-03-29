// import 'dart:async';
// import 'package:Soc/src/globals.dart';
// import 'package:Soc/src/modules/google_classroom/modal/classroom_student_profile_modal.dart';
// import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
// import 'package:Soc/src/modules/graded_plus/bloc/graded_plus_bloc.dart';
// import 'package:Soc/src/modules/graded_plus/modal/custom_rubic_modal.dart';
// import 'package:Soc/src/modules/graded_plus/modal/state_object_modal.dart';
// import 'package:Soc/src/modules/graded_plus/modal/student_assessment_info_modal.dart';
// import 'package:Soc/src/modules/graded_plus/modal/subject_details_modal.dart';
// import 'package:Soc/src/modules/graded_plus/new_ui/graded_plus_results_summary.dart';
// import 'package:Soc/src/modules/graded_plus/ui/subject_search_screen.dart';
// import 'package:Soc/src/modules/graded_plus/widgets/common_ocr_appbar.dart';
// import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
// import 'package:Soc/src/modules/graded_plus/ui/result_summary/results_summary.dart';
// import 'package:Soc/src/modules/graded_plus/widgets/searchbar_widget.dart';
// import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
// import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
// import 'package:Soc/src/modules/student_plus/widgets/screen_title_widget.dart';
// import 'package:Soc/src/overrides.dart';
// import 'package:Soc/src/services/analytics.dart';
// import 'package:Soc/src/services/utility.dart';
// import 'package:Soc/src/styles/theme.dart';
// import 'package:Soc/src/translator/translation_widget.dart';
// import 'package:Soc/src/widgets/bouncing_widget.dart';
// import 'package:Soc/src/widgets/debouncer.dart';
// import 'package:Soc/src/widgets/graded_globals.dart';
// import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
// import 'package:Soc/src/widgets/spacer_widget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_offline/flutter_offline.dart';
// import '../../../../services/Strings.dart';
// import '../../../../services/local_database/local_db.dart';
// import '../../../google_classroom/bloc/google_classroom_bloc.dart';
// import '../../../google_classroom/google_classroom_globals.dart';
// import '../../widgets/bottom_sheet_widget.dart';

// class SubjectSelection extends StatefulWidget {
//   final bool? isMcqSheet;
//   final String? selectedAnswer;
//   final String? selectedClass;
//   final String? subjectId;
//   final String? stateName;
//   final bool? isSearchPage;
//   final String? domainNameC;
//   final String? searchClass;
//   final String? selectedSubject;
//   // final String? questionImageUrl;
//   final bool? isCommonCore;
//   SubjectSelection(
//       {Key? key,
//       this.stateName,
//       this.subjectId,
//       required this.selectedClass,
//       this.isSearchPage,
//       this.domainNameC,
//       this.searchClass,
//       this.selectedSubject,
//       // required this.questionImageUrl,
//       this.isCommonCore,
//       this.isMcqSheet,
//       this.selectedAnswer})
//       : super(key: key);

//   @override
//   State<SubjectSelection> createState() => _SubjectSelectionState();
// }

// class _SubjectSelectionState extends State<SubjectSelection> {
//   static const double _KVerticalSpace = 60.0;
//   final searchController = TextEditingController();
//   final addController = TextEditingController();
//   String? selectedKeyword;
//   String? keywordSub;
//   OcrBloc _ocrBloc = OcrBloc();
//   List<String> userAddedSubjectList = [];
//   final _debouncer = Debouncer(milliseconds: 10);
//   GoogleDriveBloc _googleDriveBloc = GoogleDriveBloc();
//   final _scaffoldKey = new GlobalKey<ScaffoldState>();
//   String? subject;
//   String? learningStandard;
//   String? subLearningStandard;
//   String? subjectId;
//   String? standardId;
//   String? standardDescription;

//   StateSetter? showDialogSetState;

//   // new part of code
//   final ValueNotifier<int> pageIndex = ValueNotifier<int>(0);
//   final ValueNotifier<int> subjectIndex1 =
//       ValueNotifier<int>(-1); //To bypass the default selection
//   final ValueNotifier<int> nycIndex1 =
//       ValueNotifier<int>(-1); //To bypass the default selection
//   final ValueNotifier<int> nycSubIndex1 =
//       ValueNotifier<int>(-1); //To bypass the default selection
//   final ValueNotifier<bool> isSubmitButton = ValueNotifier<bool>(false);
//   final ValueNotifier<bool> isSkipButton = ValueNotifier<bool>(false);
//   final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);

//   LocalDatabase<StudentAssessmentInfo> _studentAssessmentInfoDb =
//       LocalDatabase('student_info');
//   LocalDatabase<SubjectDetailList> subjectRecentOptionDB =
//       LocalDatabase('recent_option_subject');
//   LocalDatabase<SubjectDetailList> learningRecentOptionDB =
//       LocalDatabase('recent_option_learning_standard');
//   final ScrollController _scrollController = ScrollController();

//   GoogleClassroomBloc _googleClassroomBloc = new GoogleClassroomBloc();
//   @override
//   initState() {
//     // To Fetch Subject Name Accoding to state seletion

//     // SubjectSelectionAPIAndMethods.googleSlidesPreparation();
//     googleSlidesPreparation();
//     if (widget.isSearchPage == true) {
//       isSkipButton.value = true;
//       _ocrBloc.add(FetchSubjectDetails(
//           stateName: widget.stateName,
//           subjectId: widget.subjectId,
//           type: 'nycSub',
//           selectedKeyword: widget.domainNameC,
//           grade: widget.selectedClass,
//           subjectSelected: widget.selectedSubject

//           // type: 'nycSub',
//           // keyword: widget.domainNameC,
//           // grade: widget.searchClass,
//           // subjectSelected: widget.selectedSubject
//           ));
//     } else {
//       if (!Overrides.STANDALONE_GRADED_APP) {
//         // get state subject list if school or default new york state
//         _ocrBloc.add(FetchStateListEvent(
//             fromCreateAssessment: false, stateName: widget.stateName));
//       } else {
//         //Fetch all data state wise // Standalone
//         fetchSubjectDetails('subject', widget.selectedClass,
//             widget.selectedClass, widget.stateName, '', '');
//       }

//       // if user come from state selection page or create assesment page
//     }

//     super.initState();
//     FirebaseAnalyticsService.addCustomAnalyticsEvent("subject_selection");
//     FirebaseAnalyticsService.setCurrentScreen(
//         screenTitle: 'subject_selection', screenClass: 'SubjectSelection');
//   }

//   @override
//   void dispose() {
//     _googleDriveBloc.close();
//     // TODO: implement dispose
//     super.dispose();
//   }

//   // back button widget on subject selection page at appBar -------
//   Widget backButtonWidget() {
//     return IconButton(
//       icon: Icon(
//         IconData(0xe80d,
//             fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
//         color: AppTheme.kButtonColor,
//       ),
//       onPressed: () async {
//         FocusManager.instance.primaryFocus?.unfocus();
//         // Change pages according to current page position on back press ..
//         if (pageIndex.value == 1) {
//           learningStandard = '';
//           isSkipButton.value = false;
//           nycIndex1.value = -1;
//           subjectIndex1.value = 0;
//           isSubmitButton.value = false;

//           fetchSubjectDetails('subject', widget.selectedClass,
//               widget.selectedClass, widget.stateName, '', '');

//           // _ocrBloc.add(FetchSubjectDetails(
//           //     type: 'subject',
//           //     selectedKeyword: widget.selectedClass,
//           //     grade: widget.selectedClass,
//           //     stateName: widget.stateName,
//           //     subjectId: '',
//           //     subjectSelected: ''));
//         } else if (pageIndex.value == 2) {
//           nycSubIndex1.value = -1;
//           nycIndex1.value = 0;
//           learningStandard = '';
//           standardDescription = '';
//           subLearningStandard = '';
//           isSubmitButton.value = false;
//           isSkipButton.value = true;

//           if (widget.isSearchPage == true) {
//             Navigator.pop(context);
//           } else {
//             _ocrBloc.add(FetchSubjectDetails(
//               type: 'nyc',
//               selectedKeyword: selectedKeyword,
//               grade: widget.selectedClass,
//               stateName: widget.stateName,
//               subjectId: subjectId,
//               subjectSelected: subject,
//             ));
//           }
//         } else {
//           Navigator.pop(context);
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Container(
//         child: Stack(
//           children: [
//             CommonBackgroundImgWidget(),
//             Scaffold(
//                 key: _scaffoldKey,
//                 bottomNavigationBar: progressIndicatorBar(),
//                 floatingActionButton: saveToDriveButton(),
//                 backgroundColor: Colors.transparent,
//                 resizeToAvoidBottomInset: false,
//                 appBar: CustomOcrAppBarWidget(
//                   fromGradedPlus: true,
//                   hideStateSelection: true,
//                   onTap: () {
//                     Utility.scrollToTop(scrollController: _scrollController);
//                   },
//                   isSuccessState: ValueNotifier<bool>(true),
//                   isBackOnSuccess: isBackFromCamera,
//                   isBackButton: true,
//                   key: null,
//                   isHomeButtonPopup: true,
//                   customBackButton: backButtonWidget(),
//                 ),
//                 body: mainBodyWidget()),
//             BlocListener<GoogleDriveBloc, GoogleDriveState>(
//                 bloc: _googleDriveBloc,
//                 child: Container(),
//                 listener: (context, state) async {
//                   // print(
//                   //     "subject section ui drive state ---------------->$state");

//                   // if (state is AddBlankSlidesOnDriveSuccess) {
//                   //   FirebaseAnalyticsService.addCustomAnalyticsEvent(
//                   //       "blank_slide_added");

//                   //   _googleDriveBloc.add(UpdateAssessmentImageToSlidesOnDrive(
//                   //       slidePresentationId:
//                   //           Globals.googleSlidePresentationId));
//                   // }

//                   if (state is GoogleSuccess) {
//                     PlusUtility.updateLogs(
//                         activityType: 'GRADED+',
//                         activityId: '45',
//                         description: 'G-Excel File Updated',
//                         operationResult: 'Success');
//                     showDialogSetState!(() {
//                       GradedGlobals.loadingMessage = 'Preparing Google Slide';
//                     });

//                     List<StudentAssessmentInfo> getStudentInfoList =
//                         await Utility.getStudentInfoList(
//                             tableName: 'student_info');

//                     //Updating very first slide with the assignment details
//                     _googleDriveBloc.add(UpdateAssignmentDetailsOnSlide(
//                         slidePresentationId: Globals.googleSlidePresentationId,
//                         studentAssessmentInfoDB: _studentAssessmentInfoDb));
//                   }

//                   if (state is ErrorState) {
//                     if (state.errorMsg == 'ReAuthentication is required') {
//                       await Utility.refreshAuthenticationToken(
//                           isNavigator: true,
//                           errorMsg: state.errorMsg!,
//                           context: context,
//                           scaffoldKey: _scaffoldKey);

//                       //calling API

//                       // updateExcelSheetOnDriveAndNavigate(connected: ,isSkip: false)
//                       // updateDocOnDrive(
//                       //   widget.isMcqSheet,
//                       //   // widget.questionImageUrl
//                       // );
//                     } else {
//                       Navigator.of(context).pop();
//                       Utility.currentScreenSnackBar(
//                           'Something went wrong' ?? "", null);
//                     }
//                   }

//                   if (state is GoogleSlideCreated) {
//                     FirebaseAnalyticsService.addCustomAnalyticsEvent(
//                         "google_slide_presentation_added");

//                     Globals.googleSlidePresentationId = state.slideFiledId;

//                     _googleDriveBloc.add(GetShareLink(
//                         fileId: Globals.googleSlidePresentationId,
//                         slideLink: true));
//                   }

//                   if (state is ShareLinkReceived) {
//                     Globals.googleSlidePresentationLink = state.shareLink;
//                     _googleDriveBloc.add(
//                         AddAndUpdateAssessmentImageToSlidesOnDrive(
//                             studentInfoDb: _studentAssessmentInfoDb,
//                             slidePresentationId:
//                                 Globals.googleSlidePresentationId));
//                   }

//                   if (state is UpdateAssignmentDetailsOnSlideSuccess) {
//                     PlusUtility.updateLogs(
//                         activityType: 'GRADED+',
//                         activityId: '44',
//                         description: 'G-Slide Updated',
//                         operationResult: 'Success');
//                     FirebaseAnalyticsService.addCustomAnalyticsEvent(
//                         "assessment_detail_added_first_slide");

//                     Globals.currentAssessmentId = '';
//                     showDialogSetState!(() {
//                       GradedGlobals.loadingMessage =
//                           'Assignment Detail is Updating';
//                     });
//                     List<StudentAssessmentInfo> studentAssessmentInfoDblist =
//                         await Utility.getStudentInfoList(
//                             tableName: 'student_info');
//                     _ocrBloc.add(SaveAssessmentToDashboardAndGetId(
//                         isMcqSheet: widget.isMcqSheet ?? false,
//                         assessmentQueImage: studentAssessmentInfoDblist
//                                 ?.first?.questionImgUrl ??
//                             '',
//                         assessmentName:
//                             Globals.assessmentName ?? 'Assessment Name',
//                         rubricScore: Globals.scoringRubric ?? '2',
//                         subjectName: widget.isSearchPage == true
//                             ? widget.selectedSubject ?? ''
//                             : subject ??
//                                 '', //Student Id will not be there in case of custom subject
//                         domainName: widget.isSearchPage == true
//                             ? widget.domainNameC ?? ''
//                             : learningStandard ?? '',
//                         subDomainName: subLearningStandard ?? '',
//                         grade: widget.selectedClass ?? '',
//                         schoolId: Globals.appSetting.schoolNameC ?? '',
//                         standardId: standardId ?? '',
//                         scaffoldKey: _scaffoldKey,
//                         context: context,
//                         fileId:
//                             Globals.googleExcelSheetId ?? 'Excel Id not found',
//                         sessionId: Globals.sessionId,
//                         teacherContactId: Globals.teacherId,
//                         teacherEmail: Globals.userEmailId,
//                         classroomCourseId: GoogleClassroomOverrides
//                                 ?.studentAssessmentAndClassroomObj?.courseId ??
//                             '',
//                         classroomCourseWorkId: GoogleClassroomOverrides
//                                 ?.studentAssessmentAndClassroomObj
//                                 ?.courseWorkId ??
//                             ''));
//                   }
//                 }),
//             BlocListener<GoogleClassroomBloc, GoogleClassroomState>(
//                 bloc: _googleClassroomBloc,
//                 child: Container(),
//                 listener: (context, state) async {
//                   if (state is CreateClassroomCourseWorkSuccess) {
//                     PlusUtility.updateLogs(
//                         activityType: 'GRADED+',
//                         activityId: '34',
//                         description: 'G-Classroom Created',
//                         operationResult: 'Success');
//                     _navigatetoResultSection();
//                   }

//                   if (state is GoogleClassroomErrorState) {
//                     if (state.errorMsg == 'ReAuthentication is required') {
//                       await Utility.refreshAuthenticationToken(
//                           isNavigator: true,
//                           errorMsg: state.errorMsg!,
//                           context: context,
//                           scaffoldKey: _scaffoldKey);

//                       _googleClassroomBloc.add(CreateClassRoomCourseWork(
//                           studentAssessmentInfoDb:
//                               LocalDatabase('student_info'),
//                           pointPossible: Globals.pointPossible ?? '0',
//                           studentClassObj: GoogleClassroomOverrides
//                               .studentAssessmentAndClassroomObj!,
//                           title: Globals.assessmentName ?? ''));
//                     } else {
//                       Navigator.of(context).pop();
//                       Utility.currentScreenSnackBar(
//                           state.errorMsg?.toString() ?? "", null);
//                     }
//                   }
//                 })
//           ],
//         ),
//       ),
//     );
//   }

//   // Search Bar widget with there conditions -----------
//   Widget searchWidget() {
//     return ValueListenableBuilder(
//         valueListenable: pageIndex,
//         builder: (BuildContext context, dynamic value, Widget? child) {
//           return pageIndex.value == 0
//               ? Container()
//               : SearchBar(
//                   stateName: widget.stateName!,
//                   isSubLearningPage: pageIndex.value == 2 ? true : false,
//                   readOnly: false,
//                   onTap: () {
//                     // In case of Domain search it will navigated to SearchPage
//                     if (pageIndex.value == 1) {
//                       FocusManager.instance.primaryFocus?.unfocus();

//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => SearchScreenPage(
//                                   isMcqSheet: widget.isMcqSheet,
//                                   selectedAnswer: widget.selectedAnswer,
//                                   // questionImage: widget.questionImageUrl ?? '',
//                                   selectedKeyword: selectedKeyword,
//                                   grade: widget.selectedClass,
//                                   selectedSubject: subject,
//                                   stateName: widget.stateName,
//                                   subjectId: subjectId,
//                                   googleDriveBloc: _googleDriveBloc,
//                                   googleClassroomBloc: _googleClassroomBloc,
//                                 )),
//                       );
//                     }
//                   },
//                   suffixIcon: InkWell(
//                     onTap: () {
//                       searchController.clear();
//                       _ocrBloc.add(FetchSubjectDetails(
//                           stateName: widget.stateName,
//                           subjectId: subjectId,
//                           type: 'nycSub',
//                           selectedKeyword: keywordSub,
//                           grade: widget.selectedClass,
//                           subjectSelected: subject));
//                     },
//                     child: Icon(
//                       Icons.clear,
//                       color: Theme.of(context).colorScheme.primaryVariant,
//                       size: Globals.deviceType == "phone" ? 20 : 28,
//                     ),
//                   ),
//                   controller: searchController,
//                   onSaved: (String value) {
//                     if (searchController.text.isEmpty && pageIndex.value != 1) {
//                       // Fetch whole data related to perticular Domain in case of search field is empty
//                       _ocrBloc.add(FetchSubjectDetails(
//                           stateName: widget.stateName,
//                           subjectId: subjectId,
//                           type: 'nycSub',
//                           selectedKeyword: keywordSub,
//                           grade: widget.selectedClass,
//                           subjectSelected: subject));
//                       // setState(() {});
//                     } else {
//                       // search according to text and return the data
//                       _debouncer.run(() async {
//                         _ocrBloc.add(SearchSubjectDetails(
//                             stateName: widget.stateName!,
//                             searchKeyword: searchController.text,
//                             type: 'nycSub',
//                             selectedKeyword: keywordSub,
//                             grade: widget.selectedClass,
//                             subjectSelected: subject));
//                         setState(() {});
//                       });
//                     }

//                     if (pageIndex.value == 1) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => SearchScreenPage(
//                                   isMcqSheet: widget.isMcqSheet,
//                                   selectedAnswer: widget.selectedAnswer,
//                                   // questionImage: widget.questionImageUrl ?? '',
//                                   selectedKeyword: selectedKeyword,
//                                   grade: widget.selectedClass,
//                                   selectedSubject: subject,
//                                   stateName: widget.stateName,
//                                   subjectId: subjectId,
//                                   googleDriveBloc: _googleDriveBloc,
//                                   googleClassroomBloc: _googleClassroomBloc,
//                                 )),
//                       );
//                     }
//                   });
//         });
//   }

//   // main body structure of the page----------------
//   Widget mainBodyWidget() {
//     return Container(
//         height: MediaQuery.of(context).orientation == Orientation.portrait
//             ? MediaQuery.of(context).size.height * 0.85
//             : MediaQuery.of(context).size.width * 0.80,
//         child: ListView(
//           padding: EdgeInsets.symmetric(
//             horizontal: 20,
//           ),
//           children: [
//             SpacerWidget(StudentPlusOverrides.KVerticalSpace / 4),
//             titleWidget(),
//             SpacerWidget(_KVerticalSpace / 3.5),
//             searchWidget(),
//             SpacerWidget(_KVerticalSpace / 4),
//             ValueListenableBuilder(
//                 valueListenable: pageIndex,
//                 builder: (BuildContext context, dynamic value, Widget? child) {
//                   return pageIndex.value == 1
//                       ? searchDomainText()
//                       : Container();
//                 }),
//             SpacerWidget(_KVerticalSpace / 4),
//             blocBuilderWidget(),
//             BlocListener(
//               bloc: _ocrBloc,
//               listener: (context, state) async {
//                 if (state is SubjectDataSuccess) {
//                   pageIndex.value = 0;
//                 } else if (state is NycDataSuccess) {
//                   // AnimationController?.dispose();
//                   pageIndex.value = 1;
//                   if (state.obj.length == 0) {
//                     isSkipButton.value = false;
//                     isSubmitButton.value = true;
//                   }
//                 } else if (state is NycSubDataSuccess) {
//                   pageIndex.value = 2;
//                 } else if (state is StateListFetchSuccessfully) {
//                   fetchSubjectDetails('subject', widget.selectedClass,
//                       widget.selectedClass, widget.stateName, '', '');
//                 }
//               },
//               child: Container(),
//             ),
//           ],
//         ));
//   }

//   Widget blocBuilderWidget() {
//     return BlocBuilder<OcrBloc, OcrState>(
//         bloc: _ocrBloc,
//         builder: (context, state) {
//           if (state is SubjectDataSuccess) {
//             state.obj!.forEach((element) {
//               if (element.dateTime != null) {
//                 state.obj!.sort((a, b) => DateTime.parse(b.dateTime.toString())
//                     .compareTo(DateTime.parse(a.dateTime.toString())));
//               }
//             });
//             // state.obj!.forEach((element) { userAddedSubjectList.add(element.subjectNameC!);});

//             return gridButtonsWidget(
//                 list: state.obj!, page: 0, isSubjectScreen: true);
//           } else if (state is NycDataSuccess) {
//             state.obj.removeWhere((element) => element.domainNameC == null);
//             state.obj.forEach((element) {
//               if (element.dateTime != null) {
//                 state.obj.sort((a, b) => DateTime.parse(b.dateTime.toString())
//                     .compareTo(DateTime.parse(a.dateTime.toString())));
//               }
//             });

//             return state.obj.length > 0
//                 ? gridButtonsWidget(
//                     list: state.obj, page: 1, isSubjectScreen: false)
//                 : Container(
//                     height: MediaQuery.of(context).size.height * 0.4,
//                     child: NoDataFoundErrorWidget(
//                       marginTop: MediaQuery.of(context).size.height * 0.1,
//                       //errorMessage: 'No Domain Found',
//                       isResultNotFoundMsg: false,
//                       isNews: false,
//                       isEvents: false,
//                     ),
//                   );
//           } else if (state is NycSubDataSuccess) {
//             state.obj!.forEach((element) {
//               if (element.domainCodeC != null) {
//                 state.obj!.sort((a, b) => a.name!.compareTo(b.name!));
//               }
//             });

//             return buttonListWidget(list: state.obj!);
//           } else if (state is SearchSubjectDetailsSuccess) {
//             List<SubjectDetailList> list = [];
//             if (pageIndex.value == 0) {
//               state.obj!.forEach((element) {
//                 if (element.subjectNameC != null) {
//                   state.obj!.sort(
//                       (a, b) => a.subjectNameC!.compareTo(b.subjectNameC!));
//                 }
//               });

//               for (int i = 0; i < state.obj!.length; i++) {
//                 if (state.obj![i].subjectNameC!
//                     .toUpperCase()
//                     .contains(searchController.text.toUpperCase())) {
//                   list.add(state.obj![i]);
//                 }
//               }
//             } else if (pageIndex.value == 1) {
//               state.obj!.forEach((element) {
//                 if (element.domainNameC != null) {
//                   state.obj!
//                       .sort((a, b) => a.domainNameC!.compareTo(b.domainNameC!));
//                 }
//               });

//               for (int i = 0; i < state.obj!.length; i++) {
//                 if (state.obj![i].domainNameC!
//                     .toUpperCase()
//                     .contains(searchController.text.toUpperCase())) {
//                   list.add(state.obj![i]);
//                 }
//               }
//             } else if (pageIndex.value == 2) {
//               state.obj!.forEach((element) {
//                 if (element.domainCodeC != null) {
//                   state.obj!
//                       .sort((a, b) => a.domainCodeC!.compareTo(b.domainCodeC!));
//                 }
//               });

//               for (int i = 0; i < state.obj!.length; i++) {
//                 if (state.obj![i].standardAndDescriptionC!
//                     .toUpperCase()
//                     .contains(searchController.text.toUpperCase())) {
//                   list.add(state.obj![i]);
//                 }
//               }
//             }

//             return pageIndex.value == 0
//                 ? gridButtonsWidget(list: list, page: 0, isSubjectScreen: true)
//                 : pageIndex.value == 1
//                     ? gridButtonsWidget(
//                         list: list, page: 1, isSubjectScreen: false)
//                     : buttonListWidget(list: list);
//           } else if (state is OcrLoading) {
//             // loading when user fetch subject detail first time
//             return pageIndex.value == 2
//                 ? Container()
//                 : Container(
//                     height: MediaQuery.of(context).size.height * 0.6,
//                     child: Center(
//                         child: Globals.isAndroid == true
//                             ? CircularProgressIndicator(
//                                 color: AppTheme.kButtonColor,
//                               )
//                             : CupertinoActivityIndicator(
//                                 radius: 20, color: AppTheme.kButtonColor)),
//                   );
//           }
//           // else if (state is OcrLoading2) {
//           //   return Container(
//           //     height: MediaQuery.of(context).size.height * 0.6,
//           //     child: Center(
//           //         child: Globals.isAndroid == true
//           //             ? CircularProgressIndicator(
//           //                 color: AppTheme.kButtonColor,
//           //               )
//           //             : CupertinoActivityIndicator(
//           //                 radius: 20, color: AppTheme.kButtonColor)),
//           //   );
//           // }

//           return Container(
//             height: MediaQuery.of(context).size.height * 0.6,
//             child: Center(
//                 child: Globals.isAndroid == true
//                     ? CircularProgressIndicator(
//                         color: AppTheme.kButtonColor,
//                       )
//                     : CupertinoActivityIndicator(
//                         radius: 20, color: AppTheme.kButtonColor)),
//           );
//           // return widget here based on BlocA's state
//         });
//   }

//   Widget titleWidget() {
//     return ValueListenableBuilder(
//       valueListenable: pageIndex,
//       builder: (BuildContext context, dynamic value, Widget? child) {
//         return Row(
//           children: [
//             IconButton(
//               alignment: Alignment.centerLeft,
//               padding: EdgeInsets.zero,
//               onPressed: () {
//                 FocusManager.instance.primaryFocus?.unfocus();
//                 // Change pages according to current page position on back press ..
//                 if (pageIndex.value == 1) {
//                   learningStandard = '';
//                   isSkipButton.value = false;
//                   nycIndex1.value = -1;
//                   subjectIndex1.value = 0;
//                   isSubmitButton.value = false;

//                   fetchSubjectDetails('subject', widget.selectedClass,
//                       widget.selectedClass, widget.stateName, '', '');
//                 } else if (pageIndex.value == 2) {
//                   nycSubIndex1.value = -1;
//                   nycIndex1.value = 0;
//                   learningStandard = '';
//                   standardDescription = '';
//                   subLearningStandard = '';
//                   isSubmitButton.value = false;
//                   isSkipButton.value = true;

//                   if (widget.isSearchPage == true) {
//                     Navigator.pop(context);
//                   } else {
//                     _ocrBloc.add(FetchSubjectDetails(
//                       type: 'nyc',
//                       selectedKeyword: selectedKeyword,
//                       grade: widget.selectedClass,
//                       stateName: widget.stateName,
//                       subjectId: subjectId,
//                       subjectSelected: subject,
//                     ));
//                   }
//                 } else {
//                   Navigator.pop(context);
//                 }
//               },
//               icon: Icon(
//                 IconData(0xe80d,
//                     fontFamily: Overrides.kFontFam,
//                     fontPackage: Overrides.kFontPkg),
//                 color: AppTheme.kButtonColor,
//               ),
//             ),
//             PlusScreenTitleWidget(
//                 kLabelSpacing: 0,
//                 text: pageIndex.value == 0
//                     ? 'Subject'
//                     : '${widget.stateName} Learning Standard'),
//           ],
//         );

//         //  Utility.textWidget(
//         //     text: pageIndex.value == 0
//         //         ? 'Subject'
//         //         : '${widget.stateName} Learning Standard',
//         //     context: context);
//       },
//       child: Container(),
//     );
//   }

//   Widget searchDomainText() {
//     return Utility.textWidget(
//         text: 'Select Domain',
//         textTheme: Theme.of(context).textTheme.subtitle1!.copyWith(
//               fontWeight: FontWeight.bold,
//             ),
//         context: context);
//   }

//   // widget to show list view on Sub-learning page  -------
//   Widget buttonListWidget({required List<SubjectDetailList> list}) {
//     return ValueListenableBuilder(
//       valueListenable: nycSubIndex1,
//       builder: (BuildContext context, dynamic value, Widget? child) {
//         return Container(
//           padding: EdgeInsets.only(bottom: 50),
//           height: Globals.deviceType == 'phone'
//               ? MediaQuery.of(context).size.height * 0.65
//               : MediaQuery.of(context).size.height * 0.7,
//           width: MediaQuery.of(context).size.width * 0.9,
//           child: ListView.separated(
//             controller: _scrollController,
//             padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).size.height * 0.03),
//             itemCount: list.length,
//             itemBuilder: (BuildContext ctx, index) {
//               return Column(children: [
//                 Bouncing(
//                   child: InkWell(
//                     onTap: () {
//                       subLearningStandard =
//                           list[index].standardAndDescriptionC!.split(' - ')[0];
//                       standardDescription =
//                           list[index].standardAndDescriptionC!.split(' - ')[1];
//                       standardId = list[index].id ?? '';
//                       if (pageIndex.value == 2) {
//                         nycSubIndex1.value = index;
//                         if (nycSubIndex1.value != -1) {
//                           isSubmitButton.value = true;
//                           isSkipButton.value = false;
//                         }
//                       }
//                     },
//                     child: AnimatedContainer(
//                       padding: EdgeInsets.only(bottom: 5),
//                       decoration: BoxDecoration(
//                         color: (nycSubIndex1.value == index &&
//                                 pageIndex.value == 2)
//                             ? AppTheme.kSelectedColor
//                             : Colors.grey,
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8),
//                         ),
//                       ),
//                       duration: Duration(microseconds: 100),
//                       child: Container(
//                         padding: EdgeInsets.all(15),
//                         alignment: Alignment.centerLeft,
//                         child: TranslationWidget(
//                           message: list[index].standardAndDescriptionC ?? '',
//                           toLanguage: Globals.selectedLanguage,
//                           fromLanguage: "en",
//                           builder: (translatedMessage) => RichText(
//                             text: translatedMessage != null &&
//                                     translatedMessage
//                                             .toString()
//                                             .split(' - ')
//                                             .length >
//                                         1
//                                 ? TextSpan(
//                                     // Note: Styles for TextSpans must be explicitly defined.
//                                     // Child text spans will inherit styles from parent
//                                     style:
//                                         Theme.of(context).textTheme.headline2,
//                                     children: <TextSpan>[
//                                       TextSpan(
//                                           text: translatedMessage
//                                               .toString()
//                                               .split(' - ')[0]
//                                               .replaceAll('Â', '')
//                                               .replaceAll('U+2612', '')
//                                               .replaceAll('⍰', ''), //🖾
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .headline2!
//                                               .copyWith(
//                                                 fontWeight: FontWeight.bold,
//                                               )),
//                                       TextSpan(text: '  '),
//                                       TextSpan(
//                                         text: translatedMessage
//                                             .toString()
//                                             .split(' - ')[1]
//                                             .replaceAll('Â', '')
//                                             .replaceAll('U+2612', '')
//                                             .replaceAll('⍰', ''),
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .headline2,
//                                       ),
//                                     ],
//                                   )
//                                 : TextSpan(
//                                     style:
//                                         Theme.of(context).textTheme.headline2,
//                                     children: [
//                                         TextSpan(text: translatedMessage)
//                                       ]),
//                           ),
//                         ),
//                         decoration: BoxDecoration(
//                             color: Color(0xff000000) !=
//                                     Theme.of(context).backgroundColor
//                                 ? Color(0xffF7F8F9)
//                                 : Color(0xff111C20),
//                             border: Border.all(
//                               color: (nycSubIndex1.value == index &&
//                                       pageIndex.value == 2)
//                                   ? AppTheme.kSelectedColor
//                                   : Colors.grey,
//                             ),
//                             borderRadius: BorderRadius.circular(8)),
//                       ),
//                     ),
//                   ),
//                 ),
//                 index == list.length - 1
//                     ? SizedBox(
//                         height: 40,
//                       )
//                     : Container()
//               ]);
//             },
//             separatorBuilder: (BuildContext context, int index) {
//               return SpacerWidget(_KVerticalSpace / 3.75);
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget progressIndicatorBar() {
//     return ValueListenableBuilder(
//       valueListenable: pageIndex,
//       child: Container(
//         height: 0,
//       ),
//       builder: (BuildContext context, dynamic value, Widget? child) {
//         return ValueListenableBuilder(
//             valueListenable: isSubmitButton,
//             child: Container(),
//             builder: (BuildContext context, dynamic value, Widget? child) {
//               return Container(
//                 padding: EdgeInsets.only(bottom: 20),
//                 margin:
//                     const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
//                 child: Container(
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                     child: AnimatedContainer(
//                       // duration: Duration(seconds: 5),
//                       duration: Duration(microseconds: 100),
//                       curve: Curves.easeOutExpo,
//                       child: LinearProgressIndicator(
//                         valueColor: new AlwaysStoppedAnimation<Color>(
//                             AppTheme.kButtonColor),
//                         backgroundColor: Color(0xff000000) !=
//                                 Theme.of(context).backgroundColor
//                             ? Color.fromRGBO(0, 0, 0, 0.1)
//                             : Color.fromRGBO(255, 255, 255, 0.16),
//                         minHeight: 15.0,
//                         value: isSubmitButton.value
//                             ? 100
//                             : pageIndex.value == 0
//                                 ? 0.33
//                                 : pageIndex.value == 1
//                                     ? 0.66
//                                     : 1,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             });
//       },
//     );
//   }

//   // Widget to show details in grid view on subject selection page and learning page
//   // Using Dynamic list because subject page have different modal list and sub learning have different list
//   Widget gridButtonsWidget(
//       {required List<dynamic> list, int? page, bool? isSubjectScreen}) {
//     return ValueListenableBuilder(
//       valueListenable: pageIndex.value == 0 ? subjectIndex1 : nycIndex1,
//       child: Container(),
//       builder: (BuildContext context, dynamic value, Widget? child) {
//         return Container(
//           padding: EdgeInsets.only(bottom: pageIndex.value == 0 ? 0 : 50),
//           height: MediaQuery.of(context).orientation == Orientation.portrait
//               ? MediaQuery.of(context).size.height * 0.62
//               : MediaQuery.of(context).size.width * 0.30,
//           width: MediaQuery.of(context).size.width * 0.9,
//           child: GridView.builder(
//               controller: _scrollController,
//               padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(context).size.height * 0.09),
//               gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//                   maxCrossAxisExtent: Globals.deviceType == 'phone'
//                       ? (pageIndex.value == 1)
//                           ? 220
//                           : 180
//                       : 400,
//                   childAspectRatio: Globals.deviceType == 'phone'
//                       ? (pageIndex.value == 1 && widget.isCommonCore == true)
//                           ? 7 / 6
//                           : 5 / 3
//                       : 5 / 1.5,
//                   crossAxisSpacing: Globals.deviceType == 'phone'
//                       ? (pageIndex.value == 1)
//                           ? 10
//                           : 15
//                       : 20,
//                   mainAxisSpacing: pageIndex.value == 1 ? 15 : 15),
//               itemCount: page == 1 ? list.length : list.length + 1,
//               itemBuilder: (BuildContext ctx, index) {
//                 return page == 1 || (page == 0 && index < list.length)
//                     ? Bouncing(
//                         // onPress: () {

//                         // },
//                         child: InkWell(
//                           onTap: () async {
//                             if (page != 1) {
//                               //print("INSIDE ON TAPPPPPPPPPPPPPPPPPPPPP");
//                             }

//                             searchController.clear();
//                             FocusManager.instance.primaryFocus?.unfocus();

//                             if (pageIndex.value == 0) {
//                               isSkipButton.value = true;
//                               subject = list[index].titleC ?? '';
//                               subjectId = list[index].id ?? '';
//                               // standardId = list[index].id ?? '';

//                               subjectIndex1.value = index;
//                               selectedKeyword = list[index].titleC;

//                               // Condition to check selected subject from local or not
//                               if ((list[index].id == null)) {
//                                 isSubmitButton.value = true;
//                               } else {
//                                 isSkipButton.value = true;
//                                 isSubmitButton.value = false;
//                                 _ocrBloc.add(FetchSubjectDetails(
//                                     type: 'nyc',
//                                     grade: widget.selectedClass,
//                                     selectedKeyword: widget.selectedClass,
//                                     subjectSelected: list[index].titleC,
//                                     subjectId: list[index].id,
//                                     stateName: widget.stateName));
//                               }

//                               if (index < list.length &&
//                                   !isSubmitButton.value) {}
//                               //To manage the recent subject list
//                               List<SubjectDetailList> recentlUsedList =
//                                   await subjectRecentOptionDB.getData();

//                               SubjectDetailList recentSubjectList =
//                                   SubjectDetailList();

//                               if (recentlUsedList.isNotEmpty) {
//                                 bool addToRecentList = false;

//                                 //To update the object if already exist
//                                 for (int i = 0;
//                                     i < recentlUsedList.length;
//                                     i++) {
//                                   if (recentlUsedList[i].subjectNameC ==
//                                       list[index].titleC) {
//                                     recentSubjectList = recentlUsedList[i];

//                                     recentSubjectList.dateTime = DateTime.now();
//                                     await subjectRecentOptionDB.putAt(
//                                         i, recentSubjectList);
//                                     addToRecentList = true;
//                                     break;
//                                   }
//                                 }

//                                 //To add the object if not exist
//                                 if (addToRecentList == false) {
//                                   recentSubjectList.subjectNameC =
//                                       list[index].titleC;
//                                   recentSubjectList.dateTime = DateTime.now();
//                                   await subjectRecentOptionDB
//                                       .addData(recentSubjectList);
//                                 }
//                               } else {
//                                 recentSubjectList.subjectNameC =
//                                     list[index].titleC;
//                                 recentSubjectList.dateTime = DateTime.now();
//                                 await subjectRecentOptionDB
//                                     .addData(recentSubjectList);
//                               }
//                             } else if (pageIndex.value == 1) {
//                               learningStandard = list[index].domainNameC;
//                               nycIndex1.value = index;
//                               // nycSubIndex1.value = index;

//                               if (index < list.length) {
//                                 keywordSub = list[index].domainNameC;
//                                 _ocrBloc.add(FetchSubjectDetails(
//                                     type: 'nycSub',
//                                     grade: widget.selectedClass,
//                                     subjectId: subjectId,
//                                     selectedKeyword: keywordSub,
//                                     stateName: widget.stateName,
//                                     subjectSelected: subject));
//                               }
//                               //To manage the recent learning standard list
//                               List<SubjectDetailList> learningrecentList =
//                                   await learningRecentOptionDB.getData();

//                               SubjectDetailList learningRecentObject =
//                                   SubjectDetailList();
//                               //To add the object if not exist
//                               if (learningrecentList.isNotEmpty) {
//                                 bool addToRecentList = false;

//                                 for (int i = 0;
//                                     i < learningrecentList.length;
//                                     i++) {
//                                   if (learningrecentList[i].domainNameC ==
//                                       list[index].domainNameC) {
//                                     learningRecentObject =
//                                         learningrecentList[i];

//                                     learningRecentObject.dateTime =
//                                         DateTime.now();
//                                     await learningRecentOptionDB.putAt(
//                                         i, learningRecentObject);
//                                     addToRecentList = true;
//                                     break;
//                                   }
//                                 }
//                                 //To update the object if not exist
//                                 if (addToRecentList == false) {
//                                   learningRecentObject.domainNameC =
//                                       list[index].domainNameC;
//                                   learningRecentObject.dateTime =
//                                       DateTime.now();
//                                   await learningRecentOptionDB
//                                       .addData(learningRecentObject);
//                                 }
//                               } else {
//                                 learningRecentObject.domainNameC =
//                                     list[index].domainNameC;
//                                 learningRecentObject.dateTime = DateTime.now();
//                                 await learningRecentOptionDB
//                                     .addData(learningRecentObject);
//                               }
//                             }
//                             if (index >= list.length &&
//                                 index !=
//                                     list.length + userAddedSubjectList.length) {
//                               _googleDriveBloc.close();
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         GradedPlusResultsSummary(
//                                           isMcqSheet: widget.isMcqSheet,
//                                           selectedAnswer: widget.selectedAnswer,
//                                           subjectId: subjectId ?? '',
//                                           standardId: standardId ?? '',
//                                           assessmentName:
//                                               Globals.assessmentName,
//                                           shareLink: Globals.shareableLink!,
//                                           assessmentDetailPage: false,
//                                         )),
//                               );
//                             }
//                           },
//                           child: AnimatedContainer(
//                             padding: EdgeInsets.only(bottom: 5),
//                             decoration: BoxDecoration(
//                               color: (subjectIndex1.value == index &&
//                                           pageIndex.value == 0) ||
//                                       (nycIndex1.value == index &&
//                                           pageIndex.value == 1)
//                                   ? AppTheme.kSelectedColor
//                                   : Colors.grey,
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(8),
//                               ),
//                             ),
//                             duration: Duration(microseconds: 5000),
//                             child: Container(
//                               padding: EdgeInsets.symmetric(horizontal: 10),
//                               alignment: isSubjectScreen == true
//                                   ? Alignment.center
//                                   : Alignment.centerLeft,
//                               child: Utility.textWidget(
//                                   textAlign: TextAlign.left,
//                                   text: page == 0
//                                       ? list[index].titleC
//                                       : list[index].domainNameC ?? '',
//                                   textTheme: Theme.of(context)
//                                       .textTheme
//                                       .headline2!
//                                       .copyWith(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize:
//                                               Globals.deviceType == 'tablet' &&
//                                                       page == 1
//                                                   ? 16
//                                                   : null),
//                                   context: context),
//                               decoration: BoxDecoration(
//                                   color: Color(0xff000000) !=
//                                           Theme.of(context).backgroundColor
//                                       ? Color(0xffF7F8F9)
//                                       : Color(0xff111C20),
//                                   border: Border.all(
//                                     color: (subjectIndex1.value == index &&
//                                                 pageIndex.value == 0) ||
//                                             (nycIndex1.value == index &&
//                                                 pageIndex.value == 1)
//                                         ? AppTheme.kSelectedColor
//                                         : Colors.grey,
//                                   ),
//                                   borderRadius: BorderRadius.circular(8)),
//                             ),
//                           ),
//                         ),
//                       )
//                     : Bouncing(
//                         child: InkWell(
//                           onTap: () {
//                             // if (pageIndex.value == 0) {
//                             //   subjectIndex1.value = index;
//                             // }
//                             addCustomSubjectBottomSheet();
//                           },
//                           child: AnimatedContainer(
//                             padding: EdgeInsets.only(bottom: 5),
//                             decoration: BoxDecoration(
//                               color:
//                                   // (subjectIndex1.value == index &&
//                                   //         pageIndex.value == 0)
//                                   //     ? AppTheme.kSelectedColor
//                                   //     :
//                                   Colors.grey,
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(8),
//                               ),
//                             ),
//                             duration: Duration(microseconds: 100),
//                             child: Container(
//                               padding: EdgeInsets.symmetric(horizontal: 10),
//                               alignment: Alignment.center,
//                               child: Utility.textWidget(
//                                   text: '+',
//                                   textTheme: Theme.of(context)
//                                       .textTheme
//                                       .headline2!
//                                       .copyWith(fontWeight: FontWeight.bold),
//                                   context: context),
//                               decoration: BoxDecoration(
//                                   color: Color(0xff000000) !=
//                                           Theme.of(context).backgroundColor
//                                       ? Color(0xffF7F8F9)
//                                       : Color(0xff111C20),
//                                   border: Border.all(
//                                     color: (subjectIndex1.value == index &&
//                                             pageIndex.value == 0)
//                                         ? AppTheme.kSelectedColor
//                                         : Colors.grey,
//                                   ),
//                                   borderRadius: BorderRadius.circular(8)),
//                             ),
//                           ),
//                         ),
//                       );
//               }),
//         );
//       },
//     );
//   }

//   //  To Open bottom sheet by which user can add new subjects to screen
//   addCustomSubjectBottomSheet() {
//     showModalBottomSheet(
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       isScrollControlled: true,
//       isDismissible: true,
//       enableDrag: true,
//       backgroundColor: Colors.transparent,
//       elevation: 10,
//       context: context,
//       builder: (context) => BottomSheetWidget(
//         title: 'Add Subject',
//         isImageField: false,
//         textFieldTitleOne: 'Subject Name',
//         submitButton: true,
//         isSubjectScreen: true,
//         sheetHeight: MediaQuery.of(context).orientation == Orientation.landscape
//             ? MediaQuery.of(context).size.height * 0.82
//             : MediaQuery.of(context).size.height * 0.45,
//         valueChanged: (controller) async {
//           await updateList(
//               subjectName: controller.text, classNo: widget.selectedClass!);

//           fetchSubjectDetails(
//               'subject',
//               widget.selectedClass,
//               widget.selectedClass,
//               widget.stateName,
//               selectedKeyword,
//               subjectId);

//           // _ocrBloc.add(FetchSubjectDetails(
//           //     type: 'subject',
//           //     selectedKeyword: widget.selectedClass,
//           //     grade: widget.selectedClass,
//           //     stateName: widget.stateName,
//           //     subjectId: subjectId,
//           //     subjectSelected: selectedKeyword));

//           controller.clear();
//           Navigator.pop(context, false);
//         },
//       ),
//       // SizedBox(
//       //   height: 30,
//       // )
//     );
//   }

//   // Widget from save to drive by which teacher can save data to google drive
//   Widget saveToDriveButton() {
//     return Wrap(
//       alignment: WrapAlignment.end,
//       children: [
//         ValueListenableBuilder(
//             valueListenable: isSkipButton,
//             child: Container(),
//             builder: (BuildContext context, dynamic value, Widget? child) {
//               return isSkipButton.value && pageIndex.value != 0
//                   ? OfflineBuilder(
//                       connectivityBuilder: (BuildContext context,
//                           ConnectivityResult connectivity, Widget child) {
//                         final bool connected =
//                             connectivity != ConnectivityResult.none;
//                         return FloatingActionButton.extended(
//                             backgroundColor:
//                                 AppTheme.kButtonColor.withOpacity(1.0),
//                             onPressed: () async {
//                               PlusUtility.updateLogs(
//                                   activityType: 'GRADED+',
//                                   activityId: '18',
//                                   description: 'Skip subject selection process',
//                                   operationResult: 'Success');
//                               updateExcelSheetOnDriveAndNavigate(
//                                   isSkip: true, connected: connected);
//                             },
//                             label: Row(
//                               children: [
//                                 BlocListener<OcrBloc, OcrState>(
//                                     bloc: _ocrBloc,
//                                     child: Container(),
//                                     listener: (context, state) {
//                                       if (state is OcrLoading) {
//                                         // Utility.showLoadingDialog(context);
//                                       }
//                                       if (state is AssessmentIdSuccess) {
//                                         Navigator.of(context).pop();
//                                         _googleDriveBloc.close();
//                                         Navigator.pushReplacement(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   GradedPlusResultsSummary(
//                                                     isMcqSheet:
//                                                         widget.isMcqSheet,
//                                                     selectedAnswer:
//                                                         widget.selectedAnswer,
//                                                     fileId: Globals
//                                                         .googleExcelSheetId,
//                                                     subjectId: subjectId ?? '',
//                                                     standardId:
//                                                         standardId ?? '',
//                                                     assessmentName:
//                                                         Globals.assessmentName,
//                                                     shareLink: '',
//                                                     assessmentDetailPage: false,
//                                                   )),
//                                         );
//                                       }
//                                     }),
//                                 Utility.textWidget(
//                                     text: 'Skip',
//                                     context: context,
//                                     textTheme: Theme.of(context)
//                                         .textTheme
//                                         .headline2!
//                                         .copyWith(
//                                             color: Theme.of(context)
//                                                 .backgroundColor)),
//                               ],
//                             ));
//                       },
//                       child: Container(),
//                     )
//                   : Container();
//             }),
//         ValueListenableBuilder(
//           valueListenable: isSubmitButton,
//           child: Container(),
//           builder: (BuildContext context, dynamic value, Widget? child) {
//             return //pageIndex.value == 2
//                 isSubmitButton.value
//                     ? OfflineBuilder(
//                         connectivityBuilder: (BuildContext context,
//                             ConnectivityResult connectivity, Widget child) {
//                           final bool connected =
//                               connectivity != ConnectivityResult.none;
//                           return FloatingActionButton.extended(
//                               backgroundColor:
//                                   AppTheme.kButtonColor.withOpacity(1.0),
//                               onPressed: () async {
//                                 updateExcelSheetOnDriveAndNavigate(
//                                     isSkip: false, connected: connected);
//                               },
//                               label: Row(
//                                 children: [
//                                   BlocListener<OcrBloc, OcrState>(
//                                       bloc: _ocrBloc,
//                                       child: Container(),
//                                       listener: (context, state) async {
//                                         if (state is AssessmentIdSuccess) {
//                                           if (Overrides.STANDALONE_GRADED_APP &&
//                                               (GoogleClassroomOverrides
//                                                       .studentAssessmentAndClassroomObj
//                                                       ?.courseWorkId
//                                                       ?.isEmpty ??
//                                                   true)) {
//                                             showDialogSetState!(() {
//                                               GradedGlobals.loadingMessage =
//                                                   'Creating Google Classroom Assignment';
//                                             });
//                                             _googleClassroomBloc.add(
//                                                 CreateClassRoomCourseWork(
//                                                     studentAssessmentInfoDb:
//                                                         LocalDatabase(
//                                                             'student_info'),
//                                                     pointPossible:
//                                                         Globals.pointPossible ??
//                                                             '0',
//                                                     studentClassObj:
//                                                         GoogleClassroomOverrides
//                                                             .studentAssessmentAndClassroomObj!,
//                                                     title: Globals
//                                                             .assessmentName ??
//                                                         ''));
//                                           } else {
//                                             _navigatetoResultSection();
//                                           }
//                                         }
//                                       }),
//                                   Utility.textWidget(
//                                       text: 'Save',
//                                       context: context,
//                                       textTheme: Theme.of(context)
//                                           .textTheme
//                                           .headline2!
//                                           .copyWith(
//                                               color: Theme.of(context)
//                                                   .backgroundColor)),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   Container(
//                                     //    margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
//                                     child: Image(
//                                       width: Globals.deviceType == "phone"
//                                           ? 23
//                                           : 28,
//                                       height: Globals.deviceType == "phone"
//                                           ? 23
//                                           : 28,
//                                       image: AssetImage(
//                                         "assets/images/drive_ico.png",
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ));
//                         },
//                         child: Container(),
//                       )
//                     : Container();
//           },
//         ),
//       ],
//     );
//   }

//   // Fuction to update custom(subject added by teacher) subjects to local db --
//   Future<void> updateList(
//       {required String subjectName, required String classNo}) async {
//     List<StateListObject> subjectList = [];

//     // to get custom subject list from localDb - State and class specific
//     LocalDatabase<StateListObject> _customSubjectlocalDb =
//         LocalDatabase('Subject_list${widget.stateName}$classNo');
//     List<StateListObject>? _stateCustomlocalData =
//         await _customSubjectlocalDb.getData();

//     // to get state list from localDb and extract subject names
//     LocalDatabase<StateListObject> _stateSubjectLocalDb =
//         LocalDatabase(Strings.stateObjectName);
//     List<StateListObject>? _stateSubjectLocalData =
//         await _stateSubjectLocalDb.getData();

//     //only adding the subjects state specific
//     for (int i = 0; i < _stateSubjectLocalData.length; i++) {
//       if (_stateSubjectLocalData[i].stateC == widget.stateName) {
//         subjectList.add(_stateSubjectLocalData[i]);
//       }
//     }

//     //Add custom subjects to the subject list
//     subjectList.addAll(_stateCustomlocalData);

//     //To check if subject already exist in the array before adding to the list
//     bool found = false;
//     subjectList.forEach((s) {
//       if (s.titleC!.toLowerCase() == subjectName.toLowerCase()) {
//         found = true;
//       }
//     });

//     if (subjectName.isNotEmpty && !found) {
//       StateListObject subjectDetailList = StateListObject();
//       subjectDetailList.titleC = subjectName;
//       _stateCustomlocalData.add(subjectDetailList);
//     } else {
//       Utility.showSnackBar(_scaffoldKey,
//           "Subject \'$subjectName\' Already Exist", context, null);
//     }

//     await _customSubjectlocalDb.clear();
//     _stateCustomlocalData.forEach((StateListObject e) {
//       _customSubjectlocalDb.addData(e);
//     });
//     // Calling event to update subject page --------

//     fetchSubjectDetails('subject', widget.selectedClass, widget.selectedClass,
//         widget.stateName, '', '');

//     // _ocrBloc.add(FetchSubjectDetails(
//     //     type: 'subject',
//     //     grade: widget.selectedClass,
//     //     // empty because no subject selected yet
//     //     subjectId: '',
//     //     subjectSelected: '',
//     //     selectedKeyword: widget.selectedClass,
//     //     stateName: widget.stateName));
//   }

//   Future<void> searchList(
//       {required String searchKeyword, required String classNo}) async {
//     LocalDatabase<String> _localDb = LocalDatabase(widget.isCommonCore == true
//         ? 'Subject_list_Common_core$classNo'
//         : 'Subject_list$classNo');
//     List<String>? _localData = await _localDb.getData();
//     userAddedSubjectList = [];
//     for (int i = 0; i < _localData.length; i++) {
//       if (_localData[i].toUpperCase().contains(searchKeyword.toUpperCase())) {
//         userAddedSubjectList.add(_localData[i]);
//       }
//     }
//   }

//   // Function to update sheet to drive and navigate to assessment summery -------------
//   void updateExcelSheetOnDriveAndNavigate(
//       {required bool isSkip, required bool connected}) async {
//     {
//       if (!connected) {
//         Utility.currentScreenSnackBar("No Internet Connection", null);
//       } else {
//         LocalDatabase<CustomRubricModal> _localDb =
//             LocalDatabase('custom_rubic');

//         List<CustomRubricModal>? _localData = await _localDb.getData();
//         String? rubricImgUrl;

//         for (int i = 0; i < _localData.length; i++) {
//           if (_localData[i].customOrStandardRubic == "Custom" &&
//               '${_localData[i].name}' + ' ' + '${_localData[i].score}' ==
//                   Globals.scoringRubric) {
//             rubricImgUrl = _localData[i].imgUrl;
//             break;
//           } else {
//             rubricImgUrl = 'NA';
//           }
//         }

//         List<StudentAssessmentInfo> studentAssessmentInfoDblist =
//             await Utility.getStudentInfoList(tableName: 'student_info');

//         //Updating remaining common details of assignment
//         StudentAssessmentInfo element = studentAssessmentInfoDblist.first;

//         element.subject = subject;
//         element.learningStandard =
//             learningStandard == null || learningStandard == ''
//                 ? "NA"
//                 : learningStandard;
//         element.subLearningStandard = subLearningStandard == null ||
//                 subLearningStandard == '' //standardDescription
//             ? "NA"
//             : subLearningStandard;
//         element.standardDescription = standardDescription == null ||
//                 standardDescription == '' //standardDescription
//             ? "NA"
//             : standardDescription;
//         element.scoringRubric =
//             widget.isMcqSheet == true ? '0-1' : Globals.scoringRubric;
//         element.className = Globals.assessmentName!.split("_")[1];
//         element.customRubricImage = rubricImgUrl;
//         element.grade = widget.selectedClass;
//         // element.questionImgUrl =
//         //     widget.questionImageUrl == '' ? "NA" : widget.questionImageUrl;
//         element.googleSlidePresentationURL =
//             Globals.googleSlidePresentationLink;
//         await _studentAssessmentInfoDb.putAt(0, element);

//         GradedGlobals.loadingMessage = 'Preparing Student Excel Sheet';

//         Utility.showLoadingDialog(
//             context: context,
//             isOCR: true,
//             state: (p0) => {showDialogSetState = p0});

//         //calling API
//         updateDocOnDrive(
//           widget.isMcqSheet,
//           // widget.questionImageUrl
//         );
//       }
//     }
//   }

//   fetchSubjectDetails(String? type, String? grade, String? selectedKeyword,
//       String? stateName, String? subjectSelected, String? subjectId) {
//     _ocrBloc.add(FetchSubjectDetails(
//         type: type,
//         grade: grade,
//         // empty because no subject selected yet
//         subjectId: subjectId,
//         subjectSelected: subjectSelected,
//         selectedKeyword: selectedKeyword,
//         stateName: stateName));
//   }

//   void updateDocOnDrive(
//     bool? isMCQSheet,
//     // String? questionImageURL,
//   ) async {
//     _googleDriveBloc.add(
//       UpdateDocOnDrive(
//           isMcqSheet: isMCQSheet ?? false,
//           // questionImage:
//           //     questionImageURL == '' ? 'NA' : questionImageURL ?? 'NA',
//           createdAsPremium: Globals.isPremiumUser,
//           assessmentName: Globals.assessmentName,
//           fileId: Globals.googleExcelSheetId,
//           isLoading: true,
//           studentData:
//               await Utility.getStudentInfoList(tableName: 'student_info')
//           //list2
//           //Globals.studentInfo!
//           ),
//     );
//   }

//   googleSlidesPreparation() {
//     if (Globals.googleSlidePresentationId!.isNotEmpty &&
//         (Globals.googleSlidePresentationLink == null ||
//             Globals.googleSlidePresentationLink!.isEmpty)) {
//       _googleDriveBloc.add(GetShareLink(
//           fileId: Globals.googleSlidePresentationId, slideLink: true));
//     }
//   }

//   void _navigatetoResultSection() {
//     GradedGlobals.loadingMessage = null;
//     Navigator.of(context).pop();
//     FirebaseAnalyticsService.addCustomAnalyticsEvent(
//         "save_to_drive_from_subject_selection");
//     PlusUtility.updateLogs(
//         activityType: 'GRADED+',
//         activityId: '12',
//         description: 'Save to drive',
//         operationResult: 'Success');
//     _googleDriveBloc.close();

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//           builder: (context) => GradedPlusResultsSummary(
//                 isMcqSheet: widget.isMcqSheet,
//                 selectedAnswer: widget.selectedAnswer,
//                 fileId: Globals.googleExcelSheetId,
//                 subjectId: subjectId ?? '',
//                 standardId: standardId ?? '',
//                 assessmentName: Globals.assessmentName,
//                 shareLink: '',
//                 assessmentDetailPage: false,
//               )),
//     );
//   }
// }
