// ignore_for_file: must_be_immutable

import 'package:Soc/src/modules/pbis_plus/modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_student_dashbord.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/custom_rect_tween.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/hero_dialog_route.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_circular_profile_name.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_student_profile_widget.dart';
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
  final Function(ValueNotifier<ClassroomStudents>) onValueUpdate;

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
      required this.onValueUpdate})
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

    Utility.updateLogs(
        activityType: widget.isFromStudentPlus == true ? 'STUDENT+' : 'PBIS+',
        activityId: '37',
        description:
            'Student ${widget.studentValueNotifier.value.profile!.name} Card View',
        operationResult: 'Success');
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
            // onTapCallback: (bool isLiked) async {
            //   _getKeys(index).currentState?.updateState(isLiked);
            //   if (index == 0) {
            //     widget.studentValueNotifier.value.profile!.like =
            //         widget.studentValueNotifier.value.profile!.like! + 1;
            //   } else if (index == 1) {
            //     widget.studentValueNotifier.value.profile!.thanks =
            //         widget.studentValueNotifier.value.profile!.thanks! + 1;
            //   } else {
            //     widget.studentValueNotifier.value.profile!.helpful =
            //         widget.studentValueNotifier.value.profile!.helpful! + 1;
            //   }
            //   setState(() {});
            //   return isLiked;
            // },
            // ),
          );
        },
      ),
    );

    final Column pbisStudentDetailWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SpacerWidget(MediaQuery.of(context).size.width * 0.10),
        Text(
          widget.studentValueNotifier.value.profile!.name!.fullName!,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        // SpacerWidget(MediaQuery.of(context).size.width * 0.07),
        Container(
            alignment: Alignment.center,
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.07),
            padding: EdgeInsets.symmetric(horizontal: 10),
            // height: 60,
            width: MediaQuery.of(context).size.width * 0.7,
            child: ActionInteractionButtons)
      ],
    );

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
                              scaffoldKey: widget.scaffoldKey!,
                              isValueChangeNotice: valueChange,
                              onValueUpdate: (updatedStudentValueNotifier) {
                                widget.studentValueNotifier =
                                    updatedStudentValueNotifier;
                              },
                              // StudentDetailWidget: StudentDetailWidget,
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
                    // border: Border.all(
                    //   color:
                    //       Color(0xff000000) == Theme.of(context).backgroundColor
                    //           ? Color(0xffF7F8F9)
                    //           : Color(0xff111C20),
                    //   width: 2,
                    // ),
                  ),
                  child: widget.studentValueNotifier.value.profile!.photoUrl!
                          .contains('default-user')
                      ? PBISCircularProfileName(
                          firstLetter: widget.studentValueNotifier.value
                              .profile!.name!.givenName!
                              .substring(0, 1),
                          lastLetter: (widget.studentValueNotifier.value
                                      .profile!.name!.familyName ??
                                  ' ')
                              .substring(0, 1),
                          profilePictureSize:
                              PBISPlusOverrides.profilePictureSize,
                        )
                      : PBISCommonProfileWidget(
                          profilePictureSize:
                              PBISPlusOverrides.profilePictureSize,
                          imageUrl: widget
                              .studentValueNotifier.value.profile!.photoUrl!),
                ),
              ),
            ),
            Positioned(
              top: widget.isFromDashboardPage == true
                  ? MediaQuery.of(context).size.height * 0.04
                  : MediaQuery.of(context).size.height * 0.05,
              right: widget.isFromDashboardPage == true //from PBIS
                  ? MediaQuery.of(context).size.width * 0.36
                  : MediaQuery.of(context).size.width * 0.21,
              child: Container(
                padding: EdgeInsets.all(5),
                width: PBISPlusOverrides.circleSize,
                height: PBISPlusOverrides.circleSize,
                decoration: BoxDecoration(
                  color: Color(0xff000000) != Theme.of(context).backgroundColor
                      ? Color(0xffF7F8F9)
                      : Color(0xff111C20),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: ValueListenableBuilder(
                          valueListenable: valueChange,
                          builder:
                              (BuildContext context, value, Widget? child) {
                            return ValueListenableBuilder<ClassroomStudents>(
                              valueListenable: widget.studentValueNotifier,
                              builder: (BuildContext context,
                                  ClassroomStudents value, Widget? child) {
                                return widget.isLoading == true
                                    ? ShimmerLoading(
                                        child: Container(
                                          height: 10,
                                          width: 10,
                                          color: Colors.black,
                                        ),
                                        isLoading: widget.isLoading)
                                    : Text(
                                        PBISPlusUtility
                                            .numberAbbreviationFormat(widget
                                                    .studentValueNotifier
                                                    .value
                                                    .profile!
                                                    .engaged! +
                                                widget.studentValueNotifier
                                                    .value.profile!.niceWork! +
                                                widget.studentValueNotifier
                                                    .value.profile!.helpful!),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      );
                              },
                            );
                          })),
                ),
              ),
            ),
          ],
        ));
  }
}
