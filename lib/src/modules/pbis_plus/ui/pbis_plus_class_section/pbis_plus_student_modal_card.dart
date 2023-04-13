import 'package:Soc/src/modules/pbis_plus/modal/course_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_student_dashbord.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/custom_rect_tween.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/hero_dialog_route.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_circular_profile_name.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_student_profile_widget.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import '../../widgets/PBISPlus_action_interaction_button.dart';

class PBISPlusStudentCardModal extends StatefulWidget {
  final ValueNotifier<ClassroomStudents> studentValueNotifier;
  final String heroTag;
  final Key? scaffoldKey;
  final String classroomCourseId;

  PBISPlusStudentCardModal(
      {Key? key,
      required this.studentValueNotifier,
      required this.heroTag,
      required this.scaffoldKey,
      required this.classroomCourseId})
      : super(key: key);

  @override
  State<PBISPlusStudentCardModal> createState() =>
      _PBISPlusStudentCardModalState();
}

class _PBISPlusStudentCardModalState extends State<PBISPlusStudentCardModal> {
  @override
  void initState() {
    super.initState();
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
          return Expanded(
            child: PBISPlusActionInteractionButton(
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
            ),
          );
        },
      ),
    );

    final Column pbisStudentDetailWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SpacerWidget(40),
        Text(
          widget.studentValueNotifier.value.profile!.name!.fullName!,
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SpacerWidget(20),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 60,
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
                width: MediaQuery.of(context).size.width * 0.7,
                margin: EdgeInsets.only(top: 45),
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   color:
                  //       Color(0xff000000) == Theme.of(context).backgroundColor
                  //           ? Color(0xffF7F8F9)
                  //           : Color(0xff111C20),
                  //   width: 0.2,
                  // ),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 10),
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
                child: SingleChildScrollView(child: pbisStudentDetailWidget)),
            Positioned(
              top: 0,
              child: GestureDetector(
                onTap: () async {
                  Navigator.of(context).pushReplacement(
                    HeroDialogRoute(
                      builder: (context) => PBISPlusStudentDashBoard(
                        // StudentDetailWidget: StudentDetailWidget,
                        studentValueNotifier: widget.studentValueNotifier,
                        heroTag: widget.heroTag,
                        StudentDetailWidget: pbisStudentDetailWidget,
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
                  child: widget.studentValueNotifier.value!.profile!.photoUrl!
                          .contains('default-user')
                      ? PBISCircularProfileName(
                          firstLetter: widget.studentValueNotifier.value
                              .profile!.name!.givenName!
                              .substring(0, 1),
                          lastLetter: widget.studentValueNotifier.value.profile!
                              .name!.familyName!
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
              top: MediaQuery.of(context).size.height * 0.03,
              right: MediaQuery.of(context).size.width * 0.22,
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
                    child: ValueListenableBuilder<ClassroomStudents>(
                      valueListenable: widget.studentValueNotifier,
                      builder: (BuildContext context, ClassroomStudents value,
                          Widget? child) {
                        return Text(
                          PBISPlusUtility.numberAbbreviationFormat(widget
                                  .studentValueNotifier
                                  .value!
                                  .profile!
                                  .engaged! +
                              widget.studentValueNotifier.value!.profile!
                                  .niceWork! +
                              widget.studentValueNotifier.value!.profile!
                                  .helpful!),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
