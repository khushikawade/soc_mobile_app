// import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
// import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
// import 'package:Soc/src/modules/student_plus/bloc/student_plus_bloc.dart';
// import 'package:Soc/src/modules/student_plus/model/student_plus_search_model.dart';
// import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
// import 'package:Soc/src/modules/student_plus/ui/student_plus_ui/student_plus_home.dart';
// import 'package:Soc/src/modules/student_plus/widgets/student_plus_app_bar.dart';
// import 'package:Soc/src/services/utility.dart';
// import 'package:Soc/src/widgets/network_error_widget.dart';
// import 'package:Soc/src/widgets/spacer_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_offline/flutter_offline.dart';

// class FamilyStudentPlusList extends StatefulWidget {
//   final String token;
//   const FamilyStudentPlusList({Key? key, required this.token})
//       : super(key: key);

//   @override
//   State<FamilyStudentPlusList> createState() => _FamilyStudentPlusListState();
// }

// class _FamilyStudentPlusListState extends State<FamilyStudentPlusList> {
//   final StudentPlusBloc _studentPlusBloc = StudentPlusBloc();
//   static const double _kLabelSpacing = 20.0;

//   @override
//   void initState() {
//     // _studentPlusBloc
//     //     .add(GetStudentListFamilyLogin(familyAuthToken: widget.token));
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         CommonBackgroundImgWidget(),
//         Scaffold(
//           resizeToAvoidBottomInset: true,
//           appBar: StudentPlusAppBar(
//             sectionType: "Family",
//             refresh: (v) {
//               setState(() {});
//             },
//           ),
//           backgroundColor: Colors.transparent,
//           body: OfflineBuilder(
//               connectivityBuilder: (
//                 BuildContext context,
//                 ConnectivityResult connectivity,
//                 Widget child,
//               ) {
//                 final bool connected = connectivity != ConnectivityResult.none;
//                 return connected
//                     ? Container(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: StudentPlusOverrides.kSymmetricPadding),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SpacerWidget(
//                                 StudentPlusOverrides.KVerticalSpace / 4),
//                             PlusScreenTitleWidget(
//                                 kLabelSpacing: _kLabelSpacing,
//                                 text: "Student List"),
//                             SpacerWidget(
//                                 StudentPlusOverrides.kSymmetricPadding),
//                             blocBuilder(),
//                             blocListener(),
//                           ],
//                         ),
//                       )
//                     : NoInternetErrorWidget(
//                         connected: connected,
//                         isSplashScreen: false,
//                       );
//               },
//               child: Container()),
//         ),
//       ],
//     );
//   }

//   /* ---------------------------------- bloc builder to show list --------------------------------- */

//   Widget blocBuilder() {
//     return BlocBuilder<StudentPlusBloc, StudentPlusState>(
//       builder: (context, state) {
//         if (state is FamilyLoginLoading) {
//           return Center(child: CircularProgressIndicator.adaptive());
//         } else if (state is StudentPlusSearchSuccess) {
//           return studentList(list: state.obj);
//         } else {
//           return Container();
//         }
//       },
//       bloc: _studentPlusBloc,
//     );
//   }

//   /* ---------- Common list view widget to search and recent list ---------- */
//   Widget studentList({required List<StudentPlusSearchModel> list}) {
//     return Expanded(
//       child: ListView.builder(
//           shrinkWrap: true,
//           scrollDirection: Axis.vertical,
//           itemCount: list.length,
//           itemBuilder: (BuildContext context, int index) {
//             return Container(
//               margin: EdgeInsets.symmetric(horizontal: 10),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(0.0),
//                   color: (index % 2 == 0)
//                       ? Theme.of(context).colorScheme.background ==
//                               Color(0xff000000)
//                           ? Color(0xff162429)
//                           : Color(
//                               0xffF7F8F9) //Theme.of(context).colorScheme.background
//                       : Theme.of(context).colorScheme.background ==
//                               Color(0xff000000)
//                           ? Color(0xff111C20)
//                           : Color(0xffE9ECEE)),
//               child: ListTile(
//                 onTap: () {
//                   if (list[index].studentIDC == null ||
//                       list[index].studentIDC == '') {
//                     Utility.currentScreenSnackBar(
//                         'Unable to get details for ${list[index].firstNameC} ${list[index].lastNameC}',
//                         null);
//                   } else {
//                     // StudentPlusUtility.addStudentInfoToLocalDb(
//                     //     studentInfo: list[index]);
//                     _studentPlusBloc.add(GetStudentPlusDetails(
//                         studentIdC: list[index].studentIDC ?? ''));
//                   }
//                 },
//                 contentPadding: EdgeInsets.only(left: 20),
//                 title: Text(
//                   "${list[index].firstNameC ?? ''} ${list[index].lastNameC ?? ''}",
//                   // context: context,
//                   style: Theme.of(context).textTheme.headline5,
//                 ),
//                 trailing: Container(
//                   margin: EdgeInsets.only(right: 20),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Utility.textWidget(
//                           text: "${list[index].classC ?? 'NA'}",
//                           context: context,
//                           textTheme: Theme.of(context).textTheme.headline2),
//                       Utility.textWidget(
//                           text: StudentPlusOverrides.searchTileStaticWord,
//                           context: context,
//                           textTheme: Theme.of(context).textTheme.subtitle2)
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }),
//     );
//   }

//   /* ------------- widget to fetch student Detail and show loader ------------ */

//   Widget blocListener() {
//     return BlocListener<StudentPlusBloc, StudentPlusState>(
//       bloc: _studentPlusBloc,
//       listener: (context, state) async {
//         if (state is StudentPlusGetDetailsLoading) {
//           Utility.showLoadingDialog(
//             context: context,
//             isOCR: true,
//           );
//         } else if (state is StudentPlusInfoSuccess) {
//           // PlusUtility.updateLogs(
//           //     activityType: 'STUDENT+',
//           //     userType: 'Teacher',
//           //     activityId: '48',
//           //     description: 'Student Search Success',
//           //     operationResult: 'Success');

//           Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(
//                   builder: (context) => StudentPlusHome(
//                         sectionType: "Family",
//                         studentPlusStudentInfo: state.obj, index: 0,
//                         //   index: widget.index,
//                       )),
//               (_) => true);
//         }
//       },
//       child: Container(),
//     );
//   }
// }
