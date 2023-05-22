// import 'package:Soc/src/globals.dart';
// import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
// import 'package:Soc/src/modules/student_plus/model/student_work_model.dart';
// import 'package:Soc/src/modules/student_plus/ui/student_plus_exams.dart';
// import 'package:Soc/src/modules/student_plus/ui/student_plus_grades.dart';
// import 'package:Soc/src/modules/student_plus/ui/student_plus_info.dart';
// import 'package:Soc/src/modules/student_plus/ui/student_plus_work.dart';
// import 'package:Soc/src/overrides.dart';
// import 'package:Soc/src/services/Strings.dart';
// import 'package:Soc/src/services/local_database/local_db.dart';
// import 'package:Soc/src/services/utility.dart';
// import 'package:Soc/src/styles/theme.dart';
// import 'package:Soc/src/translator/translation_widget.dart';
// import 'package:Soc/src/widgets/spacer_widget.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

// class StudentPlusUtility {
//   /* -------------------------------------------------------------------------- */
//   /*                  List of Static word used in student plus                  */
//   /* -------------------------------------------------------------------------- */
//   static final String searchTileStaticWord = 'Class';
//   static final String recentSearchHeader = "Recent Search";
//   static final String titleSearchPage = 'Search Any Student';
//   static final String searchHintText = 'Search Student';
//   static final String errorMessageOnSearchPage =
//       'Please Search With Minimum 3 Characters';
//   static final String studentInfoPageTitle = 'Student Info';
//   static final String studentGradesPageTitle = 'Grades';
//   static final String studentPlusWorkTitle = 'GRADED+ Scanned Work';
//   static final String studentPlusExamsTitle = 'Exams';
//   static final String studentWorkSnackbar = "No Image Found";
//   static final String studentWorkErrorMessage = 'No Student Work Found';
//   static final String gradesTitleLeft = 'Class';
//   static final String gradesTitleRight = 'Grades';
//   static final String examScreenPopupText =
//       'The student’s position relative to students in the same grade level nationwide. For example, if a student’s percentile rank is 90%, this means the student scored better than or equal to 90% of their peers.';
//   static final double kSymmetricPadding = 10.0;
//   /* -------------------------------------------------------------------------- */
//   /*                       functions used in student plus                       */
//   /* -------------------------------------------------------------------------- */

//   /* -------------- Function to get recent search student details ------------- */
//   static Future<List<dynamic>> getRecentData() async {
//     LocalDatabase<StudentDetailsModel> _localDb =
//         LocalDatabase(Strings.studentInfoRecentList);
//     List<StudentDetailsModel>? _localData = await _localDb.getData();
//     return _localData;
//   }

//   /* ------------- Function to add student info to add recent List ------------ */
//   static addStudentInfoToLocalDb(
//       {required StudentDetailsModel studentInfo}) async {
//     LocalDatabase<StudentDetailsModel> _localDb =
//         LocalDatabase(Strings.studentInfoRecentList);

//     List<StudentDetailsModel>? _localData = await _localDb.getData();
//     List<StudentDetailsModel> studentInfoList = [];
//     studentInfoList.add(studentInfo);
//     for (var i = 0; i < _localData.length; i++) {
//       if (_localData[i].id != studentInfo.id) {
//         studentInfoList.add(_localData[i]);
//       }
//     }
//     await _localDb.clear();
//     studentInfoList.forEach((StudentDetailsModel e) async {
//       await _localDb.addData(e);
//     });
//   }

//   /* ---------------------- setting lock at portrait mode --------------------- */
//   static Future setLocked() async {
//     await SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//   }

//   /* ------------- Function to return student details with labels ------------- */
//   static List<StudentPlusInfoModel> createStudentList(
//       {required StudentDetailsModel studentDetails}) {
//     List<StudentPlusInfoModel> studentInfoList = [
//       StudentPlusInfoModel(
//           label: 'Name',
//           value:
//               '${studentDetails.firstNameC ?? ''} ${studentDetails.lastNameC ?? ''}'),
//       StudentPlusInfoModel(
//           label: 'ID', value: '${studentDetails.studentIdC ?? '-'}'),
//       StudentPlusInfoModel(
//           label: 'Phone', value: '${studentDetails.parentPhoneC ?? '-'}'),
//       StudentPlusInfoModel(
//           label: 'Email', value: '${studentDetails.emailC ?? '-'}'),
//       StudentPlusInfoModel(
//           label: 'Grade', value: '${studentDetails.gradeC ?? '-'}'),
//       StudentPlusInfoModel(
//           label: 'Class', value: '${studentDetails.classC ?? '-'}'),
//       StudentPlusInfoModel(
//           label: 'Teacher', value: '${studentDetails.teacherProperC ?? '-'}'),
//       StudentPlusInfoModel(label: 'Attend%', value: '${'-'}'),
//       StudentPlusInfoModel(
//           label: 'Gender', value: '${studentDetails.genderFullC ?? '-'}'),
//       StudentPlusInfoModel(
//           label: 'Ethnicity', value: '${studentDetails.ethnicityNameC ?? '-'}'),
//       StudentPlusInfoModel(label: 'Age', value: '-'),
//       StudentPlusInfoModel(
//           label: 'DOB', value: '${studentDetails.dobC ?? '-'}'),
//       StudentPlusInfoModel(
//           label: 'ELL Status', value: '${studentDetails.ellC ?? '-'}'),
//       StudentPlusInfoModel(
//           label: 'ELL Level',
//           value: '${studentDetails.ellProficiencyC ?? '-'}'),
//       StudentPlusInfoModel(
//           label: 'IEP Status', value: '${studentDetails.iepProgramC ?? '-'}'),
//     ];
//     return studentInfoList;
//   }

//   /* ------- function to return list of widget for bottom navigation bar ------ */
//   static List<Widget> buildScreens({required StudentDetailsModel studentInfo}) {
//     List<Widget> _screens = [];
//     _screens.add(StudentPlusInfoPage(
//       studentDetails: studentInfo,
//     ));
//     _screens.add(StudentPlusExamsPage(
//       studentDetails: studentInfo,
//     ));
//     _screens.add(StudentPlusWorkPage(
//       studentDetails: studentInfo,
//     ));
//     _screens.add(StudentPlusGradesPage(
//       studentDetails: studentInfo,
//     ));
//     _screens.add(Container());
//     return _screens;
//   }

//   /* ---------- function to return list of bottom navigation bar item --------- */
//   static List<PersistentBottomNavBarItem> navBarsItems(
//       {required BuildContext context}) {
//     List<PersistentBottomNavBarItem> persistentBottomNavBarItemList = [];
//     persistentBottomNavBarItemList.add(PersistentBottomNavBarItem(
//       icon: ResultSummaryIcons("0xe883", '   Info', context),
//       activeColorPrimary: AppTheme.kButtonColor,
//       inactiveColorPrimary: CupertinoColors.systemGrey,
//     ));
//     persistentBottomNavBarItemList.add(PersistentBottomNavBarItem(
//       icon: ResultSummaryIcons("0xe881", 'Exams', context),
//       activeColorPrimary: AppTheme.kButtonColor,
//       inactiveColorPrimary: CupertinoColors.systemGrey,
//     ));
//     persistentBottomNavBarItemList.add(PersistentBottomNavBarItem(
//       icon: ResultSummaryIcons("0xe885", 'Work', context),
//       activeColorPrimary: AppTheme.kButtonColor,
//       inactiveColorPrimary: CupertinoColors.systemGrey,
//     ));
//     persistentBottomNavBarItemList.add(PersistentBottomNavBarItem(
//       icon: ResultSummaryIcons("0xe823", 'Grades', context),
//       activeColorPrimary: AppTheme.kButtonColor,
//       inactiveColorPrimary: CupertinoColors.systemGrey,
//     ));
//     persistentBottomNavBarItemList.add(PersistentBottomNavBarItem(
//       icon: ResultSummaryIcons(getStaffIconCode(), 'Staff', context),
//       activeColorPrimary: AppTheme.kButtonColor,
//       inactiveColorPrimary: CupertinoColors.systemGrey,
//     ));
//     return persistentBottomNavBarItemList;
//   }

//   /* --------- function to get staff icon code from main bottom navBar -------- */
//   static String getStaffIconCode() {
//     String staffIconCode = '0xe808';
//     for (var i = 0;
//         i < Globals.appSetting.bottomNavigationC!.split(";").length;
//         i++) {
//       if (Globals.appSetting.bottomNavigationC!.split(";").contains('staff')) {
//         staffIconCode =
//             Globals.appSetting.bottomNavigationC!.split(";")[i].split("_")[1];
//         return staffIconCode;
//       }
//     }
//     return staffIconCode;
//   }

//   /* -------------------- bottom navigation bar item widget ------------------- */
//   static Widget ResultSummaryIcons(iconData, title, context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           child: Column(
//             children: [
//               Icon(
//                 IconData(int.parse(iconData),
//                     fontFamily: Overrides.kFontFam,
//                     fontPackage: Overrides.kFontPkg),
//                 // size: 22,
//               ),
//               SpacerWidget(2),
//               TranslationWidget(
//                 shimmerHeight: 8,
//                 message: title,
//                 fromLanguage: "en",
//                 toLanguage: Globals.selectedLanguage,
//                 builder: (translatedMessage) => Expanded(
//                   child: FittedBox(
//                     child: Text(
//                       translatedMessage.toString(),
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 2,
//                       style: Theme.of(context).textTheme.headline4!,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

// /* ---------------- function to get pointPossible from rubric --------------- */
//   static String getMaxPointPossible({required String rubric}) {
//     String maxPointPossible = '2';
//     if (rubric.contains('4')) {
//       maxPointPossible = '4';
//     } else if (rubric.contains('3')) {
//       maxPointPossible = '3';
//     }
//     return maxPointPossible;
//   }

//   /* -------------- Function to return opposite background color -------------- */
//   static Color oppositeBackgroundColor({required BuildContext context}) {
//     return Color(0xff000000) != Theme.of(context).backgroundColor
//         ? Color(0xff111C20)
//         : Color(0xffF7F8F9);
//   }

//   static String calculateAgeFromDOBString(String dobString) {
//     try {
//       if (dobString == '') {
//         return 'NA';
//       }
//       DateTime dob = DateFormat("dd/MM/yyyy").parse(dobString);
//       DateTime now = DateTime.now();
//       int age = now.year - dob.year;
//       if (now.month < dob.month ||
//           (now.month == dob.month && now.day < dob.day)) {
//         age--;
//       }
//       return age.toString();
//     } catch (e) {
//       return 'NA';
//     }
//   }

//   /* -------------------------------------------------------------------------- */
//   /*                              Graph functions                            */
//   /* -------------------------------------------------------------------------- */
//   /* ------------- function to create nycGraphLineBarsData details ------------ */
//   static List<LineChartBarData> graphLineBarsData(
//       {required BuildContext context,
//       required bool isIReadyGraph,
//       required StudentDetailsModel studentDetails,
//       required bool isMathSection}) {
//     return [
//       LineChartBarData(
//           showingIndicators: showingIndicators(),
//           spots: isIReadyGraph == true
//               ? listIReadyFlPoint(
//                   isMathsSection: isMathSection, studentDetails: studentDetails)
//               : listNysFlPoint(
//                   removeLast: false,
//                   studentDetails: studentDetails,
//                   isMathsSection: isMathSection),
//           isCurved: false,
//           barWidth: 2,
//           color: StudentPlusUtility.oppositeBackgroundColor(context: context),
//           dotData: FlDotData(
//             show: true,
//             getDotPainter: (p0, p1, p2, p3) {
//               if (isIReadyGraph == true) {
//                 return FlDotCirclePainter(
//                   radius: 3,
//                   color: Theme.of(context).colorScheme.background,
//                   strokeWidth: 4,
//                   strokeColor: StudentPlusUtility.oppositeBackgroundColor(
//                       context: context),
//                 );
//               } else {
//                 return FlDotCirclePainter(
//                     radius: 7,
//                     color: Theme.of(context).colorScheme.background,
//                     strokeWidth: 3,
//                     strokeColor: AppTheme.kButtonColor);
//               }
//             },
//           ),
//           dashArray: [8]),
//       LineChartBarData(
//         spots: isIReadyGraph == true
//             ? listIReadyFlPoint(
//                 isMathsSection: isMathSection, studentDetails: studentDetails)
//             : listNysFlPoint(
//                 removeLast: true,
//                 studentDetails: studentDetails,
//                 isMathsSection: isMathSection),
//         isCurved: false,
//         barWidth: 2,
//         color: StudentPlusUtility.oppositeBackgroundColor(context: context),
//         dotData: FlDotData(
//           show: true,
//           getDotPainter: (p0, p1, p2, p3) {
//             return FlDotCirclePainter(
//                 radius: 7,
//                 color: Theme.of(context).colorScheme.background,
//                 strokeWidth: 3,
//                 strokeColor: AppTheme.kButtonColor);
//           },
//         ),
//       ),
//     ];
//   }

//   /* ---------------------- return graph indicator value ---------------------- */
//   static List<int> showingIndicators() {
//     return [0, 1, 2, 3];
//   }

//   /* ------------------------- return nys graph point ------------------------- */
//   static List<FlSpot> listNysFlPoint(
//       {required bool removeLast,
//       required StudentDetailsModel studentDetails,
//       required bool isMathsSection}) {
//     List<FlSpot> list = [
//       // FlSpot(2020, 60),
//       FlSpot(
//           2020,
//           double.parse((isMathsSection == true
//                   ? studentDetails.nysMathScore2019C
//                   : studentDetails.nysElaScore2019C) ??
//               "0.00")),
//       FlSpot(
//           2021,
//           double.parse((isMathsSection == true
//                   ? studentDetails.nysMathScore2021C
//                   : studentDetails.nysElaScore2021C) ??
//               "0.00")),
//       FlSpot(
//           2022,
//           double.parse((isMathsSection == true
//                   ? studentDetails.nysMathScore2022C
//                   : studentDetails.nysElaScore2022C) ??
//               "0.00")),
//       FlSpot(
//           2023,
//           double.parse((isMathsSection == true
//                   ? studentDetails.nysMath2023PredictionC
//                   : studentDetails.nysEla2023PredictionC) ??
//               "0.00")),
//     ];
//     // List<FlSpot> list = [];
//     // list.add(FlSpot(2020, 2.02));
//     // if ((isMathsSection == true
//     //         ? studentDetails.nysMathPrScore2021C
//     //         : studentDetails.nysElaPrScore2021C) !=
//     //     null) {
//     //   list.add(
//     //     FlSpot(
//     //         2021,
//     //         double.parse((isMathsSection == true
//     //                 ? studentDetails.nysMathPrScore2021C
//     //                 : studentDetails.nysElaPrScore2021C) ??
//     //             "0.00")),
//     //   );
//     // }
//     // if ((isMathsSection == true
//     //         ? studentDetails.nysMathPrScore2022C
//     //         : studentDetails.nysElaPrScore2022C) !=
//     //     null) {
//     //   list.add(
//     //     FlSpot(
//     //         2022,
//     //         double.parse((isMathsSection == true
//     //                 ? studentDetails.nysMathPrScore2022C
//     //                 : studentDetails.nysElaPrScore2022C) ??
//     //             "0.00")),
//     //   );
//     // }

//     // if ((isMathsSection == true
//     //         ? studentDetails.nysMath2023PredictionC
//     //         : studentDetails.nysEla2023PredictionC) !=
//     //     null) {
//     //   list.add(FlSpot(
//     //       2023,
//     //       double.parse((isMathsSection == true
//     //               ? studentDetails.nysMath2023PredictionC
//     //               : studentDetails.nysEla2023PredictionC) ??
//     //           "0.00")));
//     // }
//     if (removeLast) {
//       list.removeLast();
//       return list;
//     } else {
//       return list;
//     }
//   }

//   /* ------------------------- Nys tooltip text color ------------------------- */

//   static Color nysTooltipColor({required double value}) {
//     if (value >= 1.00 && value <= 1.99) {
//       return Colors.red;
//     } else if ((value >= 2.00 && value <= 2.99)) {
//       return Colors.yellow;
//     } else if ((value >= 3.00 && value <= 3.99)) {
//       return Colors.green;
//     } else if ((value >= 4.00 && value <= 4.99)) {
//       return Colors.blue;
//     } else {
//       return Colors.grey;
//     }
//   }

//   /* ----------------------- return iReady graph points ----------------------- */
//   static List<FlSpot> listIReadyFlPoint(
//       {required StudentDetailsModel studentDetails,
//       required bool isMathsSection}) {
//     return [
//       FlSpot(
//           0,
//           double.parse((isMathsSection == true
//                   ? studentDetails.mathPreviousSyEOYPercentile
//                   : studentDetails.ELAPreviousSyEOYPercentile) ??
//               "0.00")),
//       FlSpot(
//           1,
//           double.parse((isMathsSection == true
//                   ? studentDetails.mathCurrentSyBOYPercentile
//                   : studentDetails.ELACurrentSyBOYPercentile) ??
//               "0.00")),
//       FlSpot(
//           2,
//           double.parse((isMathsSection == true
//                   ? studentDetails.mathCurrentSyMOYPercentile
//                   : studentDetails.ELACurrentSyMOYPercentile) ??
//               "0.00")),
//       FlSpot(
//           3,
//           double.parse((isMathsSection == true
//                   ? studentDetails.mathCurrentSyEOYPercentile
//                   : studentDetails.ELACurrentSyEOYPercentile) ??
//               "0.00")),
//     ];
//   }

//   /* -------------------- Function to show tooltipIndicator ------------------- */
//   static List<ShowingTooltipIndicators> showingTooltipIndicators(
//       {required BuildContext context,
//       required bool isIReadyGraph,
//       required StudentDetailsModel studentDetails,
//       required bool isMathSection}) {
//     List<ShowingTooltipIndicators> list = [];

//     for (var i = 0; i < 4; i++) {
//       list.add(ShowingTooltipIndicators([
//         LineBarSpot(
//             StudentPlusUtility.graphLineBarsData(
//                 context: context,
//                 isIReadyGraph: isIReadyGraph,
//                 isMathSection: isMathSection,
//                 studentDetails: studentDetails)[0],
//             StudentPlusUtility.graphLineBarsData(
//                     context: context,
//                     isIReadyGraph: isIReadyGraph,
//                     isMathSection: isMathSection,
//                     studentDetails: studentDetails)
//                 .indexOf(StudentPlusUtility.graphLineBarsData(
//                     context: context,
//                     isIReadyGraph: isIReadyGraph,
//                     isMathSection: isMathSection,
//                     studentDetails: studentDetails)[0]),
//             StudentPlusUtility.graphLineBarsData(
//                     context: context,
//                     isIReadyGraph: isIReadyGraph,
//                     isMathSection: isMathSection,
//                     studentDetails: studentDetails)[0]
//                 .spots[i]),
//       ]));
//     }
//     return list;
//   }

//   /* ---------------------- Function to show bottom Sheet --------------------- */
//   static showBottomSheet(
//       {required double kLabelSpacing,
//       required BuildContext context,
//       required String text,
//       required String title}) {
//     showModalBottomSheet(
//         //  transitionAnimationController:AnimationController(animationBehavior: AnimationBehavior.preserve) ,
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         isScrollControlled: true,
//         isDismissible: true,
//         enableDrag: true,
//         backgroundColor: Colors.transparent,
//         elevation: 20,
//         context: context,
//         builder: (context) {
//           return SafeArea(
//             child: Container(
//               decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.secondary,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30))),
//               height: MediaQuery.of(context).size.height * 0.3,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       FocusScope.of(context).requestFocus(FocusNode());
//                     },
//                     icon: Icon(
//                       Icons.clear,
//                       color: AppTheme.kButtonColor,
//                       size: Globals.deviceType == "phone" ? 28 : 36,
//                     ),
//                   ),
//                   Center(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: Utility.textWidget(
//                           text: title,
//                           context: context,
//                           textTheme: Theme.of(context).textTheme.headline1,
//                           textAlign: TextAlign.center),
//                     ),
//                   ),
//                   SizedBox(
//                     height: kLabelSpacing,
//                   ),
//                   Center(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: Utility.textWidget(
//                           text: text,
//                           context: context,
//                           textTheme: Theme.of(context).textTheme.headline2,
//                           textAlign: TextAlign.center),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   /* --------------------- Function to return subject list -------------------- */
//   static List<String> getSubjectList({required List<StudentWorkModel> list}) {
//     List<String> subjectList = [];
//     for (var i = 0; i < list.length; i++) {
//       if (!subjectList.contains(list[i].subjectC) && list[i].subjectC != null) {
//         subjectList.add(list[i].subjectC ?? '');
//       }
//     }
//     return subjectList;
//   }

//   /* --------- Function to return teacher list from student work list --------- */
//   static List<String> getTeacherList({required List<StudentWorkModel> list}) {
//     List<String> teacherList = [];
//     for (var i = 0; i < list.length; i++) {
//       if (!teacherList.contains(
//               "${list[i].firstName ?? ''} ${list[i].lastName ?? ''}") &&
//           list[i].subjectC != null) {
//         teacherList.add("${list[i].firstName ?? ''} ${list[i].lastName ?? ''}");
//       }
//     }
//     return teacherList;
//   }
// }
