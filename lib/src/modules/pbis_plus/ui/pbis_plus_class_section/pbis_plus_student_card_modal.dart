// ignore_for_file: must_be_immutable

import 'package:Soc/src/modules/pbis_plus/modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_student_dashbord.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/custom_rect_tween.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/hero_dialog_route.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_student_profile_widget.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import '../../widgets/PBISPlus_action_interaction_button.dart';

class PBISPlusStudentCardModal extends StatefulWidget {
  ValueNotifier<ClassroomStudents> studentValueNotifier;
  final bool? isFromDashboardPage;
  final bool?
      isFromStudentPlus; // to check it is from pbis plus or student plus
  final bool? isLoading; // to maintain loading when user came from student plus
  final String heroTag;
  final Key? scaffoldKey;
  String classroomCourseId;
  final double constraint;
  final Function(ValueNotifier<ClassroomStudents>) onValueUpdate;
  final String? studentProfile;

  //final Function(bool) onValueUpdate;

  PBISPlusStudentCardModal(
      {Key? key,
      this.isFromDashboardPage,
      required this.studentValueNotifier,
      required this.heroTag,
      this.isFromStudentPlus,
      this.isLoading,
      required this.scaffoldKey,
      required this.classroomCourseId,
      required this.onValueUpdate,
      required this.constraint,this.studentProfile})
      : super(key: key);

  @override
  State<PBISPlusStudentCardModal> createState() =>
      _PBISPlusStudentCardModalState();
}

class _PBISPlusStudentCardModalState extends State<PBISPlusStudentCardModal> {
  ValueNotifier<bool> valueChange = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    trackUserActivity();
    // widget.studentValueNotifier.value = widget.student!;
  }

  @override
  Widget build(BuildContext context) {
    final Row ActionInteractionButtons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(
        PBISPlusActionInteractionModal.PBISPlusActionInteractionIcons.length,
        (index) {
          final iconData = PBISPlusActionInteractionModal
              .PBISPlusActionInteractionIcons[index];
          return
              // Expanded(
              // child:
              PBISPlusActionInteractionButton(
            onValueUpdate: (updatedStudentValueNotifier) {
              widget.classroomCourseId = widget.classroomCourseId;
              widget.onValueUpdate(
                  updatedStudentValueNotifier); //Return to class screen //Roster screen count update
              widget.studentValueNotifier =
                  updatedStudentValueNotifier; //Used on current screen to update the value
              valueChange.value =
                  !valueChange.value; //update the changes on bool change detect
            },
            isLoading: widget.isLoading,
            isFromStudentPlus: widget.isFromStudentPlus,
            studentValueNotifier: widget.studentValueNotifier,
            iconData: iconData,
            classroomCourseId: widget.classroomCourseId,
            scaffoldKey: widget.scaffoldKey,
          );
        },
      ),
    );

    final pbisStudentDetailWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SpacerWidget(
            (widget.isFromStudentPlus == true && widget.constraint <= 553)
                ? MediaQuery.of(context).size.width * 0.11
                : (widget.constraint <= 115)
                    ? MediaQuery.of(context).size.width * 0.12
                    : MediaQuery.of(context).size.width * 0.13),
        Text(
          widget.studentValueNotifier.value.profile!.name!.fullName!,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Container(
            alignment: Alignment.center,
            // margin:
            //     EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.07),

            padding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: (widget.isFromStudentPlus == true &&
                        widget.constraint <= 552)
                    ? 0
                    : widget.constraint > 115
                        ? 15
                        : 0.0),
            // height: 60,
            width: MediaQuery.of(context).size.width * 0.7,
            child: ActionInteractionButtons)
      ],
    );

    // final Column pbisStudentDetailWidget = Column(
    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   children: <Widget>[
    //     Expanded(
    //       child: SizedBox(
    //         height: PBISPlusOverrides.profilePictureSize,
    //       ),
    //     ),
    //     Expanded(
    //       child: Container(
    //         height: PBISPlusOverrides.profilePictureSize,
    //         child: Text(
    //           widget.studentValueNotifier.value.profile!.name!.fullName!,
    //           style: Theme.of(context)
    //               .textTheme
    //               .bodyText2!
    //               .copyWith(fontWeight: FontWeight.bold),
    //         ),
    //       ),
    //     ),
    //     Expanded(
    //       child: Container(
    //           height: PBISPlusOverrides.profilePictureSize,
    //           width: MediaQuery.of(context).size.width * 0.65,
    //           child: Center(child: ActionInteractionButtons)),
    //     )
    //   ],
    // );

    return Hero(
        tag: widget.heroTag,
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.2,
                width: widget.isFromDashboardPage == true
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width * 0.7,
                margin: widget.isFromDashboardPage == true
                    ? EdgeInsets.fromLTRB(16, 40, 16, 20)
                    : EdgeInsets.only(top: 45),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 2),
                        blurRadius: 10),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.kButtonColor,
                      Color(0xff000000) != Theme.of(context).backgroundColor
                          ? Color(0xffF7F8F9)
                          : Color(0xff111C20),
                    ],
                    stops: [
                      0.6,
                      0.5,
                    ],
                  ),
                ),
                child: FittedBox(child: pbisStudentDetailWidget)),
            Positioned(
              top: 0,
              child: GestureDetector(
                onTap: widget.isFromStudentPlus == true ||
                        widget.isFromDashboardPage == true
                    ? null
                    : () async {
                        Navigator.of(context).pushReplacement(
                          HeroDialogRoute(
                            builder: (context) => PBISPlusStudentDashBoard(
                              constraint: widget.constraint,
                              scaffoldKey: widget.scaffoldKey!,
                              isValueChangeNotice: valueChange,
                              onValueUpdate: (updatedStudentValueNotifier) {
                                widget.studentValueNotifier =
                                    updatedStudentValueNotifier;
                              },
                              studentValueNotifier: widget.studentValueNotifier,
                              heroTag: widget.heroTag,
                              StudentDetailWidget: pbisStudentDetailWidget,
                              classroomCourseId: widget.classroomCourseId,
                            ),
                          ),
                        );
                      },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: PBISCommonProfileWidget(
                      studentProfile:widget.studentProfile,
                      isFromStudentPlus: widget.isFromStudentPlus,
                      isLoading: widget.isLoading,
                      valueChange: valueChange,
                      countWidget: true,
                      studentValueNotifier: widget.studentValueNotifier,
                      profilePictureSize: PBISPlusOverrides.profilePictureSize,
                      imageUrl:
                          widget.studentValueNotifier.value.profile!.photoUrl!),
                ),
              ),
            ),
          ],
        ));
  }

  void trackUserActivity() {
    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        "pbis_plus_student_card_modal_view");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'pbis_plus_student_card_modal_screen',
        screenClass: 'PBISPlusStudentCardModal');
    /*-------------------------------------------------------------------------------------*/
    Utility.updateLogs(
        activityType: widget.isFromStudentPlus == true ? 'STUDENT+' : 'PBIS+',
        activityId: '37',
        description:
            'Student ${widget.studentValueNotifier.value.profile!.name} Card View',
        operationResult: 'Success');
  }
}
