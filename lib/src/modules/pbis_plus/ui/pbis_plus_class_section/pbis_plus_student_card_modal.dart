// // ignore_for_file: must_be_immutable

import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_student_dashbord.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/circular_custom_button.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/custom_rect_tween.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/hero_dialog_route.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_student_profile_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/schedule/ui/week_view.dart';
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
  bool? isFromStudentPlus =
      false; // to check it is from pbis plus or student plus
  final bool? isLoading; // to maintain loading when user came from student plus
  final String heroTag;
  final Key? scaffoldKey;
  String classroomCourseId;
  final double constraint;
  final Function(ValueNotifier<ClassroomStudents>) onValueUpdate;
  final String? studentProfile;

  PBISPlusStudentCardModal({
    Key? key,
    required this.isFromDashboardPage,
    required this.studentValueNotifier,
    required this.heroTag,
    this.isFromStudentPlus,
    this.isLoading,
    required this.scaffoldKey,
    required this.classroomCourseId,
    required this.onValueUpdate,
    required this.constraint,
    this.studentProfile,
  }) : super(key: key);

  @override
  State<PBISPlusStudentCardModal> createState() =>
      _PBISPlusStudentCardNewState();
}

class _PBISPlusStudentCardNewState extends State<PBISPlusStudentCardModal> {
  ValueNotifier<bool> valueChange = ValueNotifier<bool>(false);
  ValueNotifier<int> maxLine = ValueNotifier<int>(1);
  final _noteFormKey = GlobalKey<FormState>();
  final TextEditingController noteController = TextEditingController();

  ValueNotifier<bool> isexpanded = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AddNotes = Container(
      color: Color(0xffF7F8F9),
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        ValueListenableBuilder(
            valueListenable: maxLine,
            builder: (context, value, _) => Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Padding(
                    padding: EdgeInsets.only(
                        left: 16, right: 16), // Adjust the padding as needed
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      controller: noteController,
                      onChanged: (value) {
                        isexpanded.value = true;
                        if (noteController.text.isEmpty) {
                          isexpanded.value = false;
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        filled: true,
                        fillColor: Color(0xffF7F8F9),
                        hintText: 'Add note',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(
                                fontSize: 14,
                                color: Color(0xff111C20),
                                fontWeight: FontWeight.w400),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffF7F8F9),
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffF7F8F9),
                          ),
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 14,
                          color: Color(0xff111C20),
                          fontWeight: FontWeight.w400),

                      // validator: (value) {
                      //   if (value == null || value == "")
                      //     return "Please enter event title.";
                      //   return null;
                      // },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    )))),
        ValueListenableBuilder(
          valueListenable: isexpanded,
          builder: (context, value, _) => isexpanded.value
              ?
              //  Container(
              //     margin: EdgeInsets .symmetric(horizontal: 12, vertical: 8),
              //     alignment: Alignment.bottomRight,
              //     child:
              Positioned(
                  right: 0,
                  child: CircularCustomButton(
                    size: Size(MediaQuery.of(context).size.width * 0.29,
                        MediaQuery.of(context).size.width / 10),
                    borderColor: AppTheme.kButtonColor,
                    textColor:
                        Color(0xff000000) != Theme.of(context).backgroundColor
                            ? Color(0xff111C20)
                            : Color(0xffF7F8F9),
                    text: "Done",
                    onClick: () {
                      isexpanded.value = false;
                      noteController.clear();
                      // Navigator.pop(context);
                    },
                    backgroundColor: AppTheme.kButtonColor,
                    isBusy: false,
                    buttonRadius: 64,
                  ),
                )
              : SizedBox.shrink(),
        )
      ]),
    );

    final ActionInteractionButtonsRowWise = GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: widget.isFromDashboardPage!
            ? 1.1
            : 0.9, // Adjust this value to change item aspect ratio
        crossAxisSpacing: 4.0, // Adjust the spacing between items horizontally
        mainAxisSpacing: 4.0, // Adjust the spacing between items vertically
      ),
      itemCount: PBISPlusActionInteractionModalNew
              .PBISPlusActionInteractionIconsNew.length -
          3,
      itemBuilder: (BuildContext context, int index) {
        final iconData = PBISPlusActionInteractionModalNew
            .PBISPlusActionInteractionIconsNew[index];
        return Container(
          height: 18,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: PBISPlusActionInteractionButton(
              size: widget.isFromDashboardPage! ? 36 : 64,
              isShowCircle: true,
              onValueUpdate: (updatedStudentValueNotifier) {
                widget.classroomCourseId = widget.classroomCourseId;
                widget.onValueUpdate(
                    updatedStudentValueNotifier); // Return to class screen // Roster screen count update
                widget.studentValueNotifier =
                    updatedStudentValueNotifier; // Used on current screen to update the value
                valueChange.value = !valueChange
                    .value; // Update the changes on bool change detect
              },
              isLoading: widget.isLoading,
              isFromStudentPlus: widget.isFromStudentPlus,
              studentValueNotifier: widget.studentValueNotifier,
              iconData: iconData,
              classroomCourseId: widget.classroomCourseId,
              scaffoldKey: widget.scaffoldKey,
            ),
          ),
        );
      },
    );

    final pbisStudentDetailWidget = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            color: AppTheme.kButtonColor,
            child: Column(
              children: [
                SpacerWidget((widget.isFromStudentPlus == true &&
                        widget.constraint <= 553)
                    ? MediaQuery.of(context).size.width * 0.11
                    : (widget.constraint <= 115)
                        ? widget.isFromDashboardPage!
                            ? MediaQuery.of(context).size.width * 0.18
                            : MediaQuery.of(context).size.width * 0.17
                        : widget.isFromDashboardPage!
                            ? MediaQuery.of(context).size.width * 0.13
                            : MediaQuery.of(context).size.width * 0.16),
                Text(
                  widget.studentValueNotifier.value.profile!.name!.fullName!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                widget.isFromDashboardPage!
                    ? SizedBox.shrink()
                    : SpacerWidget(14)
              ],
            ),
          ),

          // Row
          SpacerWidget(
              (widget.isFromStudentPlus == true && widget.constraint <= 553)
                  ? MediaQuery.of(context).size.width * 0.9
                  : (widget.constraint <= 115)
                      ? widget.isFromDashboardPage!
                          ? MediaQuery.of(context).size.width * 0.06
                          : MediaQuery.of(context).size.width * 0.11
                      : widget.isFromDashboardPage!
                          ? MediaQuery.of(context).size.width * 0.08
                          : MediaQuery.of(context).size.width * 0.05),

          Container(
              // color: Colors.red,
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              width: MediaQuery.of(context).size.width * 1,
              child: ActionInteractionButtonsRowWise),
        ],
      ),
    );

    return SingleChildScrollView(
        child: Hero(
            tag: widget.heroTag,
            createRectTween: (begin, end) {
              return CustomRectTween(begin: begin!, end: end!);
            },
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                ValueListenableBuilder(
                  valueListenable: isexpanded,
                  builder: (context, value, _) => Container(
                      alignment: Alignment.center,
                      height: widget.isFromDashboardPage!
                          ? (widget.constraint <= 115)
                              ? MediaQuery.of(context).size.height * 0.43
                              : MediaQuery.of(context).size.height * 0.4
                          : (widget.constraint <= 115)
                              ? isexpanded.value
                                  ? MediaQuery.of(context).size.height * 0.61
                                  : MediaQuery.of(context).size.height * 0.51
                              : isexpanded.value
                                  ? MediaQuery.of(context).size.height * 0.57
                                  : MediaQuery.of(context).size.height *
                                      0.45, //Row
                      //old
                      // height: widget.isFromDashboardPage!
                      //     ? (widget.constraint <= 115)
                      //         ? MediaQuery.of(context).size.height * 0.4
                      //         : MediaQuery.of(context).size.height * 0.4
                      //     : (widget.constraint <= 115)
                      //         ? MediaQuery.of(context).size.height * 0.48
                      //         : MediaQuery.of(context).size.height * 0.42, //Row
                      // height: MediaQuery.of(context).size.height * 0.6, //Coloumn
                      width: widget.isFromDashboardPage == true
                          ? MediaQuery.of(context).size.width
                          : MediaQuery.of(context).size.width * 0.8,
                      margin: widget.isFromDashboardPage == true
                          ? EdgeInsets.fromLTRB(16, 40, 16, 20)
                          : EdgeInsets.only(top: 45),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          Color(0xff000000) == Theme.of(context).backgroundColor
                              ? widget.isFromDashboardPage == false
                                  ? BoxShadow(
                                      color: AppTheme.kButtonColor
                                          .withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0,
                                          3), // changes the position of the shadow
                                    )
                                  : BoxShadow(
                                      color: Colors.black,
                                      offset: Offset(0, 2),
                                      blurRadius: 10)
                              : BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(0, 2),
                                  blurRadius: 10),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppTheme.kButtonColor,
                            Color(0xff000000) !=
                                    Theme.of(context).backgroundColor
                                ? Color(0xffF7F8F9)
                                : Color(0xff111C20),
                          ],
                          stops: [
                            widget.isFromDashboardPage! ? 0.3 : 0.2,
                            0.0,
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          FittedBox(child: pbisStudentDetailWidget),
                        ],
                      )),
                ),
                Positioned(
                    bottom: 0,
                    child: widget.isFromStudentPlus!
                        ? SizedBox.shrink()
                        : Container(
                            // color: Colors.red,
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.only(
                              top: (widget.isFromStudentPlus == true &&
                                      widget.constraint <= 552)
                                  ? 8
                                  : widget.constraint > 115
                                      ? 15
                                      : 0.0,
                            ),
                            width: MediaQuery.of(context).size.width * 1,
                            child: AddNotes)),
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
                                  studentValueNotifier:
                                      widget.studentValueNotifier,
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
                          studentProfile: widget.studentProfile,
                          isFromStudentPlus: widget.isFromStudentPlus,
                          isLoading: widget.isLoading,
                          valueChange: valueChange,
                          countWidget: true,
                          studentValueNotifier: widget.studentValueNotifier,
                          profilePictureSize:
                              PBISPlusOverrides.profilePictureSize,
                          imageUrl: widget
                              .studentValueNotifier.value.profile!.photoUrl!),
                    ),
                  ),
                ),
              ],
            )));
  }

//   // void trackUserActivity() {
//   //   FirebaseAnalyticsService.addCustomAnalyticsEvent(
//   //       "pbis_plus_student_card_modal_view");
//   //   FirebaseAnalyticsService.setCurrentScreen(
//   //       screenTitle: 'pbis_plus_student_card_modal_screen',
//   //       screenClass: 'PBISPlusStudentCardModal');
//   //   /*-------------------------------------------------------------------------------------*/
//   //   Utility.updateLogs(
//   //       activityType: widget.isFromStudentPlus == true ? 'STUDENT+' : 'PBIS+',
//   //       activityId: '37',
//   //       description:
//   //           'Student ${widget.studentValueNotifier.value.profile!.name} Card View',
//   //       operationResult: 'Success');
//   // }
// }
}
