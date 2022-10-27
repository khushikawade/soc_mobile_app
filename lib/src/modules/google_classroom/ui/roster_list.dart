// import 'package:Soc/src/modules/google_classroom/bloc/google_classroom_bloc.dart';
// import 'package:Soc/src/modules/google_classroom/modal/classroom_student_list.dart';
// import 'package:Soc/src/modules/ocr/widgets/common_ocr_appbar.dart';
// import 'package:Soc/src/modules/ocr/widgets/ocr_background_widget.dart';
// import 'package:Soc/src/services/utility.dart';
// import 'package:Soc/src/styles/theme.dart';
// import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
// import 'package:Soc/src/widgets/spacer_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class RosterListScreen extends StatefulWidget {
//   List<GoogleClassroomStudents> googleClassroomCourseList =
//       []; //Will get update on refresh
//   final String? courseId;
//   RosterListScreen({
//     required this.googleClassroomCourseList,
//     required this.courseId,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<RosterListScreen> createState() => _RosterListScreenState();
// }

// class _RosterListScreenState extends State<RosterListScreen> {
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   final refreshKey = GlobalKey<RefreshIndicatorState>();
//   static const double _KVertcalSpace = 60.0;
//   final GoogleClassroomBloc _googleClassroomBloc = new GoogleClassroomBloc();
//   final ValueNotifier<bool> listRefresh = ValueNotifier<bool>(false);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(children: [
//       CommonBackGroundImgWidget(),
//       Scaffold(
//         backgroundColor: Colors.transparent,
//         key: _scaffoldKey,
//         resizeToAvoidBottomInset: true,
//         appBar: CustomOcrAppBarWidget(
//           isSuccessState: ValueNotifier<bool>(true),
//           isbackOnSuccess: ValueNotifier<bool>(false),
//           key: GlobalKey(),
//           isBackButton: true,
//           assessmentDetailPage: true,
//           assessmentPage: false,
//           scaffoldKey: _scaffoldKey,
//           isFromResultSection: null,
//           navigateBack: true,
//           //widget.isFromHomeSection == false ? true : null,
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             SpacerWidget(_KVertcalSpace / 4),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Utility.textWidget(
//                 text: 'Rosters',
//                 context: context,
//                 textTheme: Theme.of(context)
//                     .textTheme
//                     .headline6!
//                     .copyWith(fontWeight: FontWeight.bold),
//               ),
//             ),
//             SpacerWidget(_KVertcalSpace / 3),
//             SpacerWidget(_KVertcalSpace / 5),
//             Expanded(
//                 child: RefreshIndicator(
//                     color: AppTheme.kButtonColor,
//                     key: refreshKey,
//                     onRefresh: () => refreshPage(isFromPullToRefresh: true),
//                     child: ValueListenableBuilder(
//                         builder: (BuildContext context, dynamic value,
//                             Widget? child) {
//                           return widget.googleClassroomCourseList.length > 0
//                               ? renderStudents(widget.googleClassroomCourseList)
//                               : NoDataFoundErrorWidget(
//                                   isResultNotFoundMsg: true,
//                                   isNews: false,
//                                   isEvents: false);
//                         },
//                         valueListenable: listRefresh,
//                         child: Container()))),
//             BlocListener<GoogleClassroomBloc, GoogleClassroomState>(
//                 bloc: _googleClassroomBloc,
//                 child: Container(),
//                 listener:
//                     (BuildContext contxt, GoogleClassroomState state) async {
//                   if (state is GoogleClassroomStudentListSuccess) {
//                     widget.googleClassroomCourseList.clear();
//                     widget.googleClassroomCourseList.addAll(state.obj!);
//                     listRefresh.value = true;
//                   }
//                 }),
//           ],
//         ),
//       )
//     ]);
//   }

//   renderStudents(List studentList) {
//     return ListView.builder(
//       shrinkWrap: true,
//       scrollDirection: Axis.vertical,
//       itemCount: studentList.length,
//       itemBuilder: (BuildContext context, int index) {
//         return _buildList(studentList, index);
//       },
//     );
//   }

//   Widget _buildList(List studentList, int index) {
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
//                 text: studentList[index].profile['name']['fullName'],
//                 context: context,
//                 textTheme: Theme.of(context).textTheme.headline2),
//             subtitle: Utility.textWidget(
//                 context: context,
//                 textTheme: Theme.of(context)
//                     .textTheme
//                     .subtitle2!
//                     .copyWith(color: Colors.grey.shade500),
//                 text: studentList[index].profile['emailAddress'])),
//       ),
//     );
//   }

//   Future refreshPage({required bool isFromPullToRefresh}) async {
//     refreshKey.currentState?.show(atTop: false);
//     await Future.delayed(Duration(seconds: 2));
//     if (isFromPullToRefresh == true) {
//       listRefresh.value = false;
//       _googleClassroomBloc
//           .add(GetClassroomStudentsByCourseId(courseId: widget.courseId));
//     }
//   }

//   // Widget listView(
//   //   List<GoogleClassroomCourses> _list,
//   // ) {
//   //   return Container(
//   //     height: MediaQuery.of(context).orientation == Orientation.portrait
//   //         ? MediaQuery.of(context).size.height * 0.792
//   //         : MediaQuery.of(context).size.height * 0.45,
//   //     child: ListView.builder(
//   //       // controller: _controller,
//   //       shrinkWrap: true,
//   //       // padding: EdgeInsets.only(bottom: AppTheme.klistPadding),
//   //       scrollDirection: Axis.vertical,
//   //       itemCount: _list.length,
//   //       itemBuilder: (BuildContext context, int index) {
//   //         return _buildListNew(_list, index);
//   //       },
//   //     ),
//   //   );
//   // }

//   // Widget _buildListNew(List<GoogleClassroomCourses> list, index) {
//   //   return list[index].studentList.length > 0
//   //       ? Column(
//   //           children: [
//   //             Column(
//   //               children: [
//   //                 Container(
//   //                   color: Theme.of(context).colorScheme.secondary,
//   //                   height: 6,
//   //                 ),
//   //                 Container(
//   //                   color: Theme.of(context).colorScheme.secondary,
//   //                   child: Center(
//   //                       child: Container(
//   //                     padding: EdgeInsets.only(
//   //                         left: 10, right: 10, top: 2, bottom: 2),
//   //                     // decoration: BoxDecoration(
//   //                     //   borderRadius: BorderRadius.all(Radius.circular(30)),
//   //                     // color: Theme.of(context).colorScheme.background,
//   //                     // ),
//   //                     child: Text(
//   //                       list[index].name!,
//   //                       style: Theme.of(context)
//   //                           .textTheme
//   //                           .headline2!
//   //                           .copyWith(color: AppTheme.kButtonColor),
//   //                     ),
//   //                   )),
//   //                 ),
//   //               ],
//   //             ),
//   //             list[index].studentList.length > 0
//   //                 ? renderStudents(list[index].studentList)
//   //                 : Container()
//   //           ],
//   //         )
//   //       : Container();
//   // }

// }
