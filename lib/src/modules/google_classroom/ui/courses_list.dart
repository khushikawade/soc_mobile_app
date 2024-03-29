// import 'dart:async';
// import 'package:Soc/src/modules/google_classroom/bloc/google_classroom_bloc.dart';
// import 'package:Soc/src/modules/google_classroom/modal/google_classroom_courses.dart';
// import 'package:Soc/src/modules/google_drive/model/user_profile.dart';
// import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
// import 'package:Soc/src/modules/graded_plus/ui/select_assessment_type.dart';
// import 'package:Soc/src/modules/graded_plus/widgets/Common_popup.dart';
// import 'package:Soc/src/modules/graded_plus/widgets/common_ocr_appbar.dart';
// import 'package:Soc/src/modules/plus_common_widgets/google_login.dart';
// import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
// import 'package:Soc/src/modules/graded_plus/widgets/spinning_icon.dart';
// import 'package:Soc/src/overrides.dart';
// import 'package:Soc/src/services/utility.dart';
// import 'package:Soc/src/styles/theme.dart';
// import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
// import 'package:Soc/src/widgets/spacer_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

// class CoursesListScreen extends StatefulWidget {
//   List<GoogleClassroomCourses> googleClassroomCourseList =
//       []; //Will get update on refresh
//   CoursesListScreen({
//     required this.googleClassroomCourseList,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<CoursesListScreen> createState() => _CoursesListScreenState();
// }

// class _CoursesListScreenState extends State<CoursesListScreen>
//     with SingleTickerProviderStateMixin {
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   final refreshKey = GlobalKey<RefreshIndicatorState>();
//   static const double _KVertcalSpace = 60.0;
//   final GoogleClassroomBloc _googleClassroomBloc = new GoogleClassroomBloc();
//   final ValueNotifier<int> selectedValue = ValueNotifier<int>(0);
//   final ValueNotifier<bool> refreshList = ValueNotifier<bool>(false);
//   final ItemScrollController _itemScrollController = ItemScrollController();
//   final ValueNotifier<bool> isScrollingStop = ValueNotifier<bool>(true);
//   AnimationController? _animationController;
//   ScrollController? _scrollController;
//   void _animateToIndex(
//     int index,
//     int listLength,
//   ) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _itemScrollController.scrollTo(
//           index: index,
//           duration: const Duration(seconds: 2),
//           curve: Curves.linearToEaseOut);
//     });
//   }

//   @override
//   void initState() {
//     _animationController = AnimationController(
//         vsync: this,
//         duration: const Duration(seconds: 1),
//         animationBehavior: AnimationBehavior.normal);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(children: [
//
//       Scaffold(
//         backgroundColor: Colors.transparent,
//         key: _scaffoldKey,
//         resizeToAvoidBottomInset: true,
//         appBar: CustomOcrAppBarWidget(
//           fromGradedPlus: true,
//           isSuccessState: ValueNotifier<bool>(true),
//           isBackOnSuccess: ValueNotifier<bool>(false),
//           key: GlobalKey(),
//           isBackButton: true,
//           assessmentDetailPage: true,
//           assessmentPage: false,
//           scaffoldKey: _scaffoldKey,
//           isFromResultSection:
//               null, //widget.isFromHomeSection == false ? true : null,
//           navigateBack: true,
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             SpacerWidget(_KVertcalSpace / 4),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Utility.textWidget(
//                     text: 'All Courses',
//                     context: context,
//                     textTheme: Theme.of(context)
//                         .textTheme
//                         .headline6!
//                         .copyWith(fontWeight: FontWeight.bold),
//                   ),
//                   Container(
//                     height: MediaQuery.of(context).size.height * 0.036,
//                     // padding: EdgeInsets.only(right: 10),
//                     child: FloatingActionButton.extended(
//                         backgroundColor: AppTheme.kButtonColor,
//                         onPressed: () {
//                           if (_animationController!.isAnimating == true) {
//                             Utility.currentScreenSnackBar(
//                                 'Please Wait, Sync Is In Progress', null,
//                                 marginFromBottom: 90);
//                           } else {
//                             _animationController!.repeat();
//                             refreshPage(isFromPullToRefresh: true);
//                           }
//                         },
//                         label: Row(
//                           children: [
//                             Utility.textWidget(
//                                 text: 'Sync',
//                                 context: context,
//                                 textTheme: Theme.of(context)
//                                     .textTheme
//                                     .headline4!
//                                     .copyWith(
//                                         color:
//                                             Theme.of(context).backgroundColor)),
//                           ],
//                         ),
//                         icon: SpinningIconButton(
//                           controller: _animationController,
//                           iconData: Icons.sync,
//                         )),
//                   )
//                 ],
//               ),
//             ),
//             SpacerWidget(_KVertcalSpace / 3),
//             SpacerWidget(_KVertcalSpace / 5),
//             Expanded(
//                 child: ValueListenableBuilder(
//                     valueListenable: refreshList,
//                     child: Container(),
//                     builder:
//                         (BuildContext context, dynamic value, Widget? child) {
//                       return RefreshIndicator(
//                           color: AppTheme.kButtonColor,
//                           key: refreshKey,
//                           onRefresh: () =>
//                               refreshPage(isFromPullToRefresh: true),
//                           child: widget.googleClassroomCourseList.length > 0
//                               ? coursesChips(widget.googleClassroomCourseList)
//                               //listView(widget.googleClassroomCourseList)
//                               : NoDataFoundErrorWidget(
//                                   isResultNotFoundMsg: true,
//                                   isNews: false,
//                                   isEvents: false));
//                     })),
//             BlocListener<GoogleClassroomBloc, GoogleClassroomState>(
//                 bloc: _googleClassroomBloc,
//                 child: Container(),
//                 listener:
//                     (BuildContext contxt, GoogleClassroomState state) async {
//                   if (state is GoogleClassroomCourseListSuccess) {
//                     widget.googleClassroomCourseList.clear();
//                     widget.googleClassroomCourseList.addAll(state.obj!);
//                     refreshList.value = !refreshList.value;
//                     if (_animationController!.isAnimating == true) {
//                       Utility.currentScreenSnackBar(
//                           'Classroom Synced Successfully', null,
//                           marginFromBottom: 90);
//                       _animationController!.stop();
//                     }
//                   }
//                   if (state is GoogleClassroomErrorState) {
//                     if (state.errorMsg == 'ReAuthentication is required') {
//                       await Utility.refreshAuthenticationToken(
//                           isNavigator: false,
//                           errorMsg: state.errorMsg!,
//                           context: context,
//                           scaffoldKey: _scaffoldKey);

//                       _googleClassroomBloc.add(GetClassroomCourses());
//                     } else {
//                       Navigator.of(context).pop();
//                       Utility.currentScreenSnackBar(
//                           "Something Went Wrong. Please Try Again.", null);
//                     }
//                   }
//                 }),
//           ],
//         ),
//       ),
//       scanAssessmentButton(),
//     ]);
//   }

//   Widget scanAssessmentButton() {
//     return ValueListenableBuilder<bool>(
//         valueListenable: isScrollingStop,
//         child: Container(),
//         builder: (BuildContext context, bool value, Widget? child) {
//           return AnimatedPositioned(
//             bottom: 30,
//             right: !isScrollingStop.value
//                 ? 8
//                 : (Utility.displayWidth(context) / 2) - 80,
//             duration: const Duration(milliseconds: 650),
//             curve: Curves.decelerate,
//             child: Container(
//               width: !isScrollingStop.value ? 50 : null,
//               height: !isScrollingStop.value ? 50 : null,
//               // width: !isScrollingStop.value
//               //     ? null
//               //     : Globals.deviceType == 'phone'
//               //         ? 150
//               //         : 210,
//               child: FloatingActionButton.extended(
//                   heroTag: null,
//                   isExtended: isScrollingStop.value,
//                   backgroundColor: AppTheme.kButtonColor,
//                   onPressed: () async {
//                     if (widget.googleClassroomCourseList.length == 0) {
//                       popupModal(
//                           title: 'Roster',
//                           message: 'Please import the Roster first');
//                     } else {
//                       List<UserInformation> _userProfileLocalData =
//                           await UserGoogleProfile.getUserProfile();
//                       GoogleLogin.verifyUserAndGetDriveFolder(
//                           _userProfileLocalData);
//                       ScaffoldMessenger.of(context).removeCurrentSnackBar();
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                             builder: (context) =>
//                                 SelectAssessmentType() //OpticalCharacterRecognition()
//                             ),
//                       );
//                     }
//                   },
//                   icon: isScrollingStop.value
//                       ? Container()
//                       : Container(
//                           //  alignment: Alignment.center,
//                           child: Icon(
//                               IconData(0xe875,
//                                   fontFamily: Overrides.kFontFam,
//                                   fontPackage: Overrides.kFontPkg),
//                               color: Theme.of(context).backgroundColor,
//                               size: 16),

//                           // Icon(Icons.add,
//                           //     size: Globals.deviceType == 'tablet' ? 30 : null,
//                           //     color: Theme.of(context).backgroundColor

//                           //     ),
//                         ),
//                   label: !isScrollingStop.value
//                       ? Container()
//                       : Utility.textWidget(
//                           text: 'Scan Assignment',
//                           context: context,
//                           textTheme: Theme.of(context)
//                               .textTheme
//                               .headline2!
//                               .copyWith(
//                                   color: Theme.of(context).backgroundColor))),
//             ),
//           );
//         });
//   }

//   Widget coursesChips(List<GoogleClassroomCourses> courseList) {
//     return Column(
//       children: [
//         Container(
//             margin: EdgeInsets.only(bottom: 10.0),
//             height: 30,
//             //padding: EdgeInsets.only(left: 2.0),
//             child: Container(
//               child: ListView.builder(
//                 controller: null,
//                 itemBuilder: (BuildContext context, int index) {
//                   return chipBuilder(courseList, context, index);
//                 },
//                 itemCount: courseList.length,
//                 scrollDirection: Axis.horizontal,
//               ),
//             )),
//         Expanded(child: studentListCourseWiseView(courseList))
//       ],
//     );
//   }

//   Widget chipBuilder(
//     List<GoogleClassroomCourses> courseList,
//     context,
//     currentIndex,
//   ) {
//     return ValueListenableBuilder(
//         valueListenable: selectedValue,
//         child: Container(),
//         builder: (BuildContext context, dynamic value, Widget? child) {
//           return GestureDetector(
//             onTap: () {
//               selectedValue.value = currentIndex;
//               _animateToIndex(
//                 currentIndex,
//                 courseList[currentIndex].studentList!.length,
//               );
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               margin: EdgeInsets.only(left: 5),
//               decoration: BoxDecoration(
//                 boxShadow: [],
//                 color: //Colors.transparent,
//                     Color(0xff000000) != Theme.of(context).backgroundColor
//                         ? Color(0xffF7F8F9)
//                         : Color(0xff111C20),
//                 border: Border.all(
//                     color: selectedValue.value == currentIndex
//                         ? AppTheme.kSelectedColor
//                         : Colors.grey),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     courseList[currentIndex].name!,
//                     style: Theme.of(context)
//                         .textTheme
//                         .subtitle2!
//                         .copyWith(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   Widget studentListCourseWiseView(
//     List<GoogleClassroomCourses> courseList,
//   ) {
//     return NotificationListener<ScrollNotification>(
//       onNotification: onNotification,
//       child: ScrollablePositionedList.builder(
//           padding: EdgeInsets.symmetric(vertical: 10.0),
//           shrinkWrap: true,
//           itemScrollController: _itemScrollController,
//           itemCount: courseList.length,
//           itemBuilder: (context, index) {
//             return _buildCourseSeparationList(courseList, index);
//           }),
//     );
//   }

//   Widget _buildCourseSeparationList(
//       List<GoogleClassroomCourses> courseListlist, index) {
//     return
//         // courseListlist[index].studentList!.length > 0
//         //     ?
//         Column(children: [
//       // Container(
//       //   // color: Theme.of(context).colorScheme.secondary,
//       //   height: 6,
//       // ),
//       Container(
//         key: ValueKey(courseListlist[index]),
//         color: Theme.of(context).colorScheme.secondary,
//         child: Center(
//             child: Container(
//           padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
//           child: Text(
//             courseListlist[index].name! +
//                 ' ' +
//                 '${courseListlist[index].section ?? ''}' +
//                 ' ' +
//                 (courseListlist[index].room == ''
//                     ? ''
//                     : '(${courseListlist[index].room ?? ''})'),
//             style: Theme.of(context)
//                 .textTheme
//                 .headline2!
//                 .copyWith(color: AppTheme.kButtonColor),
//           ),
//         )),
//       ),
//       courseListlist[index].studentList!.length > 0
//           ? renderStudents(courseListlist[index].studentList!)
//           : Container(
//               height: 65,
//               padding: EdgeInsets.only(left: 20),
//               alignment: Alignment.centerLeft,
//               width: MediaQuery.of(context).size.width,
//               color:
//                   Theme.of(context).colorScheme.background == Color(0xff000000)
//                       ? Color(0xff162429)
//                       : Color(0xffF7F8F9),
//               child: Text('No student found'),
//             )
//     ]);
//   }

//   renderStudents(List studentList) {
//     return ListView.builder(
//       padding: EdgeInsets.all(0),
//       physics: NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       controller: _scrollController,
//       // scrollDirection: Axis.vertical,
//       itemCount: studentList.length,
//       itemBuilder: (BuildContext context, int index) {
//         return _buildStudentList(studentList, index);
//       },
//     );
//   }

//   Widget _buildStudentList(List studentList, int index) {
//     return InkWell(
//       onTap: () async {},
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(0.0),
//             color: (index % 2 == 0)
//                 ? Theme.of(context).colorScheme.background == Color(0xff000000)
//                     ? Color(0xff162429)
//                     : Color(
//                         0xffF7F8F9) //Theme.of(context).colorScheme.background
//                 : Theme.of(context).colorScheme.background == Color(0xff000000)
//                     ? Color(0xff111C20)
//                     : Color(0xffE9ECEE)),
//         child: ListTile(
//             visualDensity: VisualDensity(horizontal: 0, vertical: 0),
//             title: Utility.textWidget(
//                 text: studentList[index]['profile']['name']['fullName'],
//                 context: context,
//                 textTheme: Theme.of(context).textTheme.headline2),
//             subtitle: Utility.textWidget(
//                 context: context,
//                 textTheme: Theme.of(context)
//                     .textTheme
//                     .subtitle2!
//                     .copyWith(color: Colors.grey.shade500),
//                 text: studentList[index]['profile']['emailAddress'])),
//       ),
//     );
//   }

//   Future refreshPage({required bool isFromPullToRefresh}) async {
//     refreshKey.currentState?.show(atTop: false);
//     await Future.delayed(Duration(seconds: 2));
//     if (isFromPullToRefresh == true) {
//       // listRefresh.value = '';
//       _googleClassroomBloc.add(GetClassroomCourses());
//     }
//   }

//   bool onNotification(ScrollNotification scrollNotification) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // print(scrollNotification.metrics.atEdge);
//       if (scrollNotification is ScrollUpdateNotification) {
//         isScrollingStop.value = false;
//       } else if (scrollNotification.metrics.pixels !=
//           scrollNotification.metrics.maxScrollExtent) {
//         isScrollingStop.value = true;
//       }
//     });

//     return true;
//   }

//   popupModal({required String message, required String? title}) {
//     return showDialog(
//         context: context,
//         builder: (context) =>
//             OrientationBuilder(builder: (context, orientation) {
//               return CommonPopupWidget(
//                   orientation: orientation,
//                   context: context,
//                   message: message,
//                   title: title!);
//             }));
//   }
// }
