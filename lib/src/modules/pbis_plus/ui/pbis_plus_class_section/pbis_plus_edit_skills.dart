// ignore_for_file: must_be_immutable

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_student_dashbord.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/custom_rect_tween.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/hero_dialog_route.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_appbar.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_student_profile_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import '../../widgets/PBISPlus_action_interaction_button.dart';

class PBISPlusEditSkills extends StatefulWidget {
  // ValueNotifier<ClassroomStudents> studentValueNotifier;
  // final bool? isFromDashboardPage;
  // final bool?
  //     isFromStudentPlus; // to check it is from pbis plus or student plus
  // final bool? isLoading; // to maintain loading when user came from student plus
  // final String heroTag;
  // final Key? scaffoldKey;
  // String classroomCourseId;
  final double? constraint;
  // final Function(ValueNotifier<ClassroomStudents>) onValueUpdate;
  // final String? studentProfile;
  // bool? isFromEditSkills;
  //final Function(bool) onValueUpdate;

  PBISPlusEditSkills({
    Key? key,
    // this.isFromDashboardPage,
    // required this.studentValueNotifier,
    // required this.heroTag,
    // this.studentValueNotifier,
    // this.heroTag,
    // this.isFromStudentPlus,
    // this.isLoading,
    // required this.scaffoldKey,
    // required this.classroomCourseId,
    // required this.onValueUpdate,
    // required this.constraint,
    // this.scaffoldKey,
    // this.classroomCourseId,
    // this.onValueUpdate,
    this.constraint,
    // this.studentProfile,
    // isFromEditSkills,
  }) : super(key: key) {
    // this.isFromEditSkills = isFromEditSkills ?? true;
  }

  @override
  State<PBISPlusEditSkills> createState() => _PBISPlusStudentCardModalState();
}

class _PBISPlusStudentCardModalState extends State<PBISPlusEditSkills> {
  ValueNotifier<bool> valueChange = ValueNotifier<bool>(false);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<bool> isEditMode = ValueNotifier<bool>(false);
  ValueNotifier<int> changedIndex = ValueNotifier<int>(-1);
  // bool? isEditMode = false;
  // bool ChangedIndex = false;
  @override
  void initState() {
    super.initState();
    trackUserActivity();
    // widget.studentValueNotifier.value = widget.student!;
  }

  Widget _buildHeader() {
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.height * 0.80,
            color: AppTheme
                .kButtonColor, // Set the background color for the heading
            padding: EdgeInsets.all(16),
            child: Text(
              "Edit Skills",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SpacerWidget(18),
          ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: (PBISPlusActionInteractionModal
                        .PBISPlusActionInteractionIcons.length /
                    2)
                .ceil(),
            itemBuilder: (BuildContext context, int rowIndex) {
              return Row(
                children: List.generate(
                  3,
                  (int columnIndex) {
                    final index = rowIndex * 3 + columnIndex;
                    if (index >=
                        PBISPlusActionInteractionModal
                            .PBISPlusActionInteractionIcons.length) {
                      return SizedBox(); // Return an empty SizedBox for excess cells
                    }
                    final item = PBISPlusActionInteractionModal
                        .PBISPlusActionInteractionIcons[index];
                    return Expanded(
                        child: GestureDetector(
                            onTap: () {
                              isEditMode.value = true;
                              print(isEditMode);
                              changedIndex.value = index;
                            },
                            child: ValueListenableBuilder(
                                valueListenable: changedIndex,
                                builder: (context, value, _) =>
                                    ValueListenableBuilder(
                                      valueListenable: isEditMode,
                                      builder: (context, value, _) => index ==
                                              changedIndex.value
                                          ? _buildEditWidget(item)
                                          : Column(
                                              children: [
                                                Icon(
                                                  index == changedIndex.value
                                                      ? Icons.edit
                                                      : item.iconData,
                                                  size: Globals.deviceType ==
                                                          'phone'
                                                      ? 30
                                                      : 40,
                                                  color: item.color,
                                                ),
                                                SpacerWidget(4),
                                                Padding(
                                                  padding: Globals.deviceType !=
                                                          'phone'
                                                      ? const EdgeInsets.only(
                                                          top: 10, left: 10)
                                                      : EdgeInsets.zero,
                                                  child: Utility.textWidget(
                                                      text: item.title,
                                                      context: context,
                                                      textTheme: Theme.of(
                                                              context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .copyWith(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 12)),
                                                ),
                                                SpacerWidget(16),
                                              ],
                                            ),
                                    ))));
                  },
                ),
              );
            },
          ),
          SpacerWidget(18),
        ],
      ),
    );
  }

  Widget _buildEditWidget(item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 104,
          height: 64,
          decoration: BoxDecoration(
            color: AppTheme.kButtonColor,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.edit,
            size: Globals.deviceType == 'phone' ? 20 : 30,
            color: Colors.white,
          ),
        ),
        Text("w")
      ],
    );
  }

  Widget _buildAdditionalBehaviour() {
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Text(
              "Additional Behaviors",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          SpacerWidget(18),
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: (PBISPlusActionInteractionModal
                        .PBISPlusActionInteractionIcons.length /
                    2)
                .ceil(),
            itemBuilder: (BuildContext context, int rowIndex) {
              return Row(
                children: List.generate(
                  3,
                  (int columnIndex) {
                    final index = rowIndex * 3 + columnIndex;
                    if (index >=
                        PBISPlusActionInteractionModal
                            .PBISPlusActionInteractionIcons.length) {
                      return SizedBox
                          .shrink(); // Return an empty SizedBox for excess cells
                    }
                    final item = PBISPlusActionInteractionModal
                        .PBISPlusActionInteractionIcons[index];
                    return Expanded(
                      child: Container(
                        width: 40,
                        height: 80,
                        margin: EdgeInsets.all(16),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              item.iconData,
                              color: item.color,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          SpacerWidget(18),
        ],
      ),
    );
  }

  Widget body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
              IconData(0xe80d,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg),
              color: AppTheme.kButtonColor),
        ),
        SpacerWidget(18),
        _buildHeader(),
        SpacerWidget(64),
        _buildAdditionalBehaviour(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CommonBackgroundImgWidget(),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PBISPlusAppBar(
          title: "Dashboard",
          backButton: true,
          scaffoldKey: _scaffoldKey,
        ),
        body: body(context),
      )
    ]);

    //   final Row ActionInteractionButtons = Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       crossAxisAlignment: CrossAxisAlignment.end,
    //       children: [Container()]);
    //   //    List.generate(
    //   //     PBISPlusActionInteractionModal.PBISPlusActionInteractionIcons.length,
    //   //     (index) {
    //   //       final iconData = PBISPlusActionInteractionModal
    //   //           .PBISPlusActionInteractionIcons[index];
    //   //       return
    //   //           // Expanded(
    //   //           // child:
    //   //           PBISPlusActionInteractionButton(
    //   //         onValueUpdate: (updatedStudentValueNotifier) {
    //   //           widget.classroomCourseId = widget.classroomCourseId;
    //   //           widget.onValueUpdate(
    //   //               updatedStudentValueNotifier); //Return to class screen //Roster screen count update
    //   //           widget.studentValueNotifier =
    //   //               updatedStudentValueNotifier; //Used on current screen to update the value
    //   //           valueChange.value =
    //   //               !valueChange.value; //update the changes on bool change detect
    //   //         },
    //   //         isLoading: widget.isLoading,
    //   //         isFromStudentPlus: widget.isFromStudentPlus,
    //   //         studentValueNotifier: widget.studentValueNotifier,
    //   //         iconData: iconData,
    //   //         classroomCourseId: widget.classroomCourseId,
    //   //         scaffoldKey: widget.scaffoldKey,
    //   //       );
    //   //     },
    //   //   ),
    //   // );

    //   final pbisStudentDetailWidget = Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       Text(
    //         "Edit Skills",
    //         textAlign: TextAlign.center,
    //         style: Theme.of(context)
    //             .textTheme
    //             .headline6!
    //             .copyWith(fontWeight: FontWeight.bold),
    //       ),
    //       Container(
    //           alignment: Alignment.center,
    //           padding: EdgeInsets.only(
    //             left: 10,
    //             right: 10,
    //             top: 15,
    //           ),
    //           // (widget.isFromStudentPlus == true &&
    //           //         widget.constraint <= 552)
    //           //     ? 0
    //           //     : widget.constraint > 115
    //           //         ? 15
    //           //         : 0.0),
    //           width: MediaQuery.of(context).size.width * 0.1,
    //           child: ActionInteractionButtons)
    //     ],
    //   );

    //   final pbisBehaviourDetails;
    //   return Column(
    //     children: [
    //       Hero(
    //           // tag: widget.heroTag,
    //           tag: "heroTag",
    //           createRectTween: (begin, end) {
    //             return CustomRectTween(begin: begin!, end: end!);
    //           },
    //           child: Stack(
    //             alignment: Alignment.center,
    //             children: <Widget>[
    //               Container(
    //                   alignment: Alignment.center,
    //                   height: MediaQuery.of(context).size.height * 0.2,
    //                   // width: widget.isFromDashboardPage == true
    //                   //     ?
    //                   //     MediaQuery.of(context).size.width
    //                   //     : MediaQuery.of(context).size.width * 0.7,
    //                   // margin: widget.isFromDashboardPage == true
    //                   //     ? EdgeInsets.fromLTRB(16, 40, 16, 20)
    //                   //     : EdgeInsets.only(top: 45),

    //                   width: MediaQuery.of(context).size.width * 0.7,
    //                   margin: EdgeInsets.only(top: 45),
    //                   decoration: BoxDecoration(
    //                     shape: BoxShape.rectangle,
    //                     borderRadius: BorderRadius.circular(5),
    //                     boxShadow: [
    //                       BoxShadow(
    //                           color: Colors.black,
    //                           offset: Offset(0, 2),
    //                           blurRadius: 10),
    //                     ],
    //                     gradient: LinearGradient(
    //                       begin: Alignment.topCenter,
    //                       end: Alignment.bottomCenter,
    //                       colors: [
    //                         AppTheme.kButtonColor,
    //                         Color(0xff000000) != Theme.of(context).backgroundColor
    //                             ? Color(0xffF7F8F9)
    //                             : Color(0xff111C20),
    //                       ],
    //                       stops: [
    //                         0.6,
    //                         0.5,
    //                       ],
    //                     ),
    //                   ),
    //                   child: FittedBox(child: pbisStudentDetailWidget)),
    //               Positioned(
    //                 top: 0,
    //                 child: GestureDetector(
    //                   onTap: null,
    //                   // widget.isFromStudentPlus == true ||
    //                   //         widget.isFromDashboardPage == true
    //                   //     ? null
    //                   // : () async {
    //                   // Navigator.of(context).pushReplacement(
    //                   //   HeroDialogRoute(
    //                   //     builder: (context) => PBISPlusStudentDashBoard(
    //                   //       constraint: widget.constraint,
    //                   //       scaffoldKey: widget.scaffoldKey!,
    //                   //       isValueChangeNotice: valueChange,
    //                   //       onValueUpdate: (updatedStudentValueNotifier) {
    //                   //         widget.studentValueNotifier =
    //                   //             updatedStudentValueNotifier;
    //                   //       },
    //                   //       studentValueNotifier: widget.studentValueNotifier,
    //                   //       heroTag: widget.heroTag,
    //                   //       StudentDetailWidget: pbisStudentDetailWidget,
    //                   //       classroomCourseId: widget.classroomCourseId,
    //                   //     ),
    //                   //   ),
    //                   // );
    //                   // },
    //                   child: Container(
    //                       decoration: BoxDecoration(
    //                         shape: BoxShape.circle,
    //                       ),
    //                       child: Container()
    //                       // PBISCommonProfileWidget(
    //                       //     studentProfile: widget.studentProfile,
    //                       //     isFromStudentPlus: widget.isFromStudentPlus,
    //                       //     isLoading: widget.isLoading,
    //                       //     valueChange: valueChange,
    //                       //     countWidget: true,
    //                       //     studentValueNotifier: widget.studentValueNotifier,
    //                       //     profilePictureSize: PBISPlusOverrides.profilePictureSize,
    //                       //     imageUrl:
    //                       //         widget.studentValueNotifier.value.profile!.photoUrl!),
    //                       ),
    //                 ),
    //               ),
    //             ],
    //           )),
    //       _buildAdditionalBehaviour()
    //     ],
    //   );
    // }

    // Widget _buildAdditionalBehaviour() {
    //   return Hero(
    //       // tag: widget.heroTag,
    //       tag: "heroTag2",
    //       createRectTween: (begin, end) {
    //         return CustomRectTween(begin: begin!, end: end!);
    //       },
    //       child: Stack(
    //         alignment: Alignment.center,
    //         children: <Widget>[
    //           Container(
    //               alignment: Alignment.center,
    //               height: MediaQuery.of(context).size.height * 0.5,
    //               width: MediaQuery.of(context).size.width * 0.7,
    //               // margin: EdgeInsets.only(top: 14),
    //               decoration: BoxDecoration(
    //                 shape: BoxShape.rectangle,
    //                 borderRadius: BorderRadius.circular(5),
    //                 boxShadow: [
    //                   BoxShadow(
    //                       color: Colors.black,
    //                       offset: Offset(0, 2),
    //                       blurRadius: 10),
    //                 ],
    //                 gradient: LinearGradient(
    //                   begin: Alignment.topCenter,
    //                   end: Alignment.bottomCenter,
    //                   colors: [
    //                     Color(0xff000000) != Theme.of(context).backgroundColor
    //                         ? Color(0xffF7F8F9)
    //                         : Color(0xff111C20),
    //                     Color(0xff000000) != Theme.of(context).backgroundColor
    //                         ? Color(0xffF7F8F9)
    //                         : Color(0xff111C20),
    //                   ],
    //                   stops: [
    //                     0.6,
    //                     0.5,
    //                   ],
    //                 ),
    //               ),
    //               child: FittedBox(
    //                   child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: <Widget>[
    //                   Text(
    //                     "Additional Behaviors",
    //                     textAlign: TextAlign.center,
    //                     style: Theme.of(context)
    //                         .textTheme
    //                         .bodyText1!
    //                         .copyWith(fontWeight: FontWeight.bold),
    //                   ),
    //                   // Container(
    //                   //   alignment: Alignment.center,
    //                   //   padding: EdgeInsets.only(
    //                   //     left: 10,
    //                   //     right: 10,
    //                   //     top: 15,
    //                   //   ),
    //                   //   // (widget.isFromStudentPlus == true &&
    //                   //   //         widget.constraint <= 552)
    //                   //   //     ? 0
    //                   //   //     : widget.constraint > 115
    //                   //   //         ? 15
    //                   //   //         : 0.0),
    //                   //   width: MediaQuery.of(context).size.width * 0.1,
    //                   //   child: Card(child: Container()
    //                   //       // ListView.builder(
    //                   //       //   itemCount: 5,
    //                   //       //   itemBuilder: (BuildContext context, int index) {
    //                   //       //     return Text('Item $index');
    //                   //       //     // Add any other widget properties or customizations as ne;
    //                   //       //   },
    //                   //       // ),
    //                   //       ),
    //                   // )
    //                 ],
    //               ))),

    //           // Card(
    //           //   child: ListView.builder(
    //           //     itemCount: 50,
    //           //     itemBuilder: (BuildContext context, int index) {
    //           //       return ListTile(
    //           //         title: Text('Item $index'),
    //           //         // Add any other widget properties or customizations as needed
    //           //       );
    //           //     },
    //           //   ),
    //           // ),
    //         ],
    //       ));
  }

  void trackUserActivity() {
    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        "pbis_plus_student_card_modal_view");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'pbis_plus_student_card_modal_screen',
        screenClass: 'PBISPlusEditSkills');
    /*-------------------------------------------------------------------------------------*/
    // Utility.updateLogs(
    //     activityType: widget.isFromStudentPlus == true ? 'STUDENT+' : 'PBIS+',
    //     activityId: '37',
    //     description:
    //         'Student ${widget.studentValueNotifier.value.profile!.name} Card View',
    //     operationResult: 'Success');
  }
}
