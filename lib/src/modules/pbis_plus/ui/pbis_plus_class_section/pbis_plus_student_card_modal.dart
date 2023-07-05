// // ignore_for_file: must_be_immutable

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_plus_utilty.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
// ignore_for_file: deprecated_member_use

import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_common_behavior_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_student_dashbord.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/circular_custom_button.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/custom_rect_tween.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/hero_dialog_route.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_student_profile_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/PBISPlus_action_interaction_button.dart';

class PBISPlusStudentCardModal extends StatefulWidget {
  ValueNotifier<ClassroomStudents> studentValueNotifier;
  final bool? isFromDashboardPage;
  bool? isFromStudentPlus = false;
  // to check it is from pbis plus or student plus
  final bool? isLoading; // to maintain loading when user came from student plus
  final String heroTag;
  final Key? scaffoldKey;
  String classroomCourseId;
  final double constraint;
  final Function(ValueNotifier<ClassroomStudents>) onValueUpdate;
  final String? studentProfile;

  PBISPlusStudentCardModal(
      {Key? key,
      required this.isFromDashboardPage,
      required this.studentValueNotifier,
      required this.heroTag,
      this.isFromStudentPlus,
      this.isLoading,
      required this.scaffoldKey,
      required this.classroomCourseId,
      required this.onValueUpdate,
      required this.constraint,
      this.studentProfile})
      : super(key: key);

  @override
  State<PBISPlusStudentCardModal> createState() =>
      _PBISPlusStudentCardNewState();
}

class _PBISPlusStudentCardNewState extends State<PBISPlusStudentCardModal> {
  ValueNotifier<bool> valueChange = ValueNotifier<bool>(false);
  ValueNotifier<int> maxLine = ValueNotifier<int>(1);
  ValueNotifier<bool> isNotesTextfieldEnable = ValueNotifier<bool>(false);
  //---------------------------------------------------------------------------------------------
  final TextEditingController noteController = TextEditingController();
  PBISPlusBloc pBISPlusBloc = PBISPlusBloc();
  PBISPlusBloc pBISPlusNotesBloc = PBISPlusBloc();
  ValueNotifier<int> behvaiourIconListCount = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    getTeacherSelectedToggleValue();
    trackUserActivity();
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*--------------------------------------------getTeacherSelectedToggleValue------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  void getTeacherSelectedToggleValue() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final storedValue = pref.getBool(Strings.isCustomBehavior);
      PBISPlusEvent event;

      if (storedValue == true) {
        event = PBISPlusGetTeacherCustomBehavior();
      } else {
        event = PBISPlusGetDefaultSchoolBehavior();
      }
      pBISPlusBloc.add(event);
    } catch (e) {}
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*---------------------------------------------------------MAIN METHOD------------------------------------------ */
/*-------------------------------------------------------------------------------------------------------------- */
  @override
  Widget build(BuildContext context) {
    final Column addNotes = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 0.1,
            width: double.infinity,
            color: Color(0xff000000) != Theme.of(context).backgroundColor
                ? Color(0xff111C20)
                : Color(0xffF7F8F9),
          ),
          ValueListenableBuilder(
              valueListenable: maxLine,
              builder: (context, value, _) => TextFormField(
                    minLines: 1,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    controller: noteController,
                    onChanged: (value) {
                      isNotesTextfieldEnable.value = true;
                      if (noteController.text.isEmpty) {
                        isNotesTextfieldEnable.value = false;
                      }
                    },
                    cursorColor:
                        Color(0xff000000) != Theme.of(context).backgroundColor
                            ? Color(0xff111C20)
                            : Color(0xffF7F8F9),
                    decoration: InputDecoration(
                      // contentPadding:
                      //     EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      filled: true,
                      fillColor:
                          Color(0xff000000) != Theme.of(context).backgroundColor
                              ? Color(0xffF7F8F9)
                              : Color(0xff111C20),
                      // Color(0xffF7F8F9),
                      hintText: 'Add Note',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(
                              fontSize: 14,
                              color: Color(0xff000000) !=
                                      Theme.of(context).backgroundColor
                                  ? Color(0xff111C20)
                                  : Color(0xffF7F8F9),
                              fontWeight: FontWeight.w400),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0.0, color: Colors.transparent),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0.0, color: Colors.transparent),
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 14,
                        color: Color(0xff000000) !=
                                Theme.of(context).backgroundColor
                            ? Color(0xff111C20)
                            : Color(0xffF7F8F9),
                        fontWeight: FontWeight.w400),
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.next,
                  )),
          //--------------------------------------BUTTON TO CALL THE ADD NOTE API---------------------------------------------------
          BlocConsumer<PBISPlusBloc, PBISPlusState>(
              bloc: pBISPlusNotesBloc,
              builder: (context, state) {
                print(state);
                if (state is PBISPlusLoading) {
                  return _buildAddButton(isLoading: true);
                }

                return _buildAddButton(isLoading: false);
              },
              listener: (context, state) async {
                if (state is PBISPlusAddNotesSucess) {
                  Utility.currentScreenSnackBar(
                      "Successfully Added Notes", null);
                  Navigator.pop(context, true);
                  isNotesTextfieldEnable.value = false;
                  noteController.clear();
                } else if (state is PBISPlusAddNotesError) {
                  Utility.currentScreenSnackBar(
                      "Please try again later. Unable Note was not  added  .",
                      null);
                  isNotesTextfieldEnable.value = false;
                  noteController.clear();
                  Navigator.pop(context, true);
                }
              }),
        ]);

/*-------------------------------------------------------------------------------------------------------------- */
/*------------------------------------------ActionInteractionButtonsRowWise------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
    Widget ActionInteractionButtonsRowWise = BlocBuilder(
        bloc: pBISPlusBloc,
        builder: (contxt, state) {
          if (state is PBISPlusGetDefaultSchoolBehaviorSuccess) {
            return buildBehaviorGridView(
                behaviorList: state.defaultSchoolBehaviorList, loading: false);
          }
          if (state is PBISPlusGetTeacherCustomBehaviorSuccess) {
            if (state.teacherCustomBehaviorList.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                behvaiourIconListCount.value =
                    state.teacherCustomBehaviorList.length;
              });

              return buildBehaviorGridView(
                  behaviorList: state.teacherCustomBehaviorList,
                  loading: false);
              //  buildBehaviorGridView(
              //   behaviorList: state.teacherCustomBehaviorList,
              // );
            } else {
              pBISPlusBloc.add(PBISPlusGetDefaultSchoolBehavior());
            }
          }

          if (state is PBISPlusBehaviorLoading) {
            return buildBehaviorGridView(
                behaviorList: state.demoBehaviorData, loading: true);
          }
          return Container();
        });

    final pbisStudentProfileWidget = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppTheme.kButtonColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // SpacerWidget((widget.isFromStudentPlus == true &&
                //         widget.constraint <= 553)
                //     ? MediaQuery.of(context).size.width * 0.11
                //     : (widget.constraint <= 115)
                //         ? widget.isFromDashboardPage == true
                //             ? MediaQuery.of(context).size.width * 0.18
                //             : MediaQuery.of(context).size.width * 0.17
                //         : widget.isFromDashboardPage == true
                //             ? MediaQuery.of(context).size.width * 0.13
                //             : MediaQuery.of(context).size.width * 0.16),
                Text(
                  widget.studentValueNotifier.value.profile?.name?.fullName ??
                      '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                widget.isFromDashboardPage == true
                    ? SizedBox.shrink()
                    : SpacerWidget(8)
              ],
            ),
          ),

          // Row
          // SpacerWidget(
          //     (widget.isFromStudentPlus == true && widget.constraint <= 553)
          //         ? MediaQuery.of(context).size.width * 0.9
          //         : (widget.constraint <= 115)
          //             ? widget.isFromDashboardPage == true
          //                 ? MediaQuery.of(context).size.width * 0.06
          //                 : MediaQuery.of(context).size.width * 0.08
          //             : widget.isFromDashboardPage == true
          //                 ? MediaQuery.of(context).size.width * 0.08
          //                 : MediaQuery.of(context).size.width * 0.04),

          Expanded(
            child: Container(
                // color: Colors.red,
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                width: MediaQuery.of(context).size.width * 1,
                child: ActionInteractionButtonsRowWise),
          ),
          widget.isFromDashboardPage == true
              ? SizedBox.shrink()
              : SpacerWidget(48)
        ],
      ),
    );

    return SingleChildScrollView(
        child: Hero(
            tag: widget.heroTag,
            createRectTween: (begin, end) {
              return CustomRectTween(begin: begin!, end: end!);
            },
            child: Stack(alignment: Alignment.center, children: <Widget>[
              ValueListenableBuilder(
                  valueListenable: isNotesTextfieldEnable,
                  builder: (context, value, _) => ValueListenableBuilder(
                        valueListenable: behvaiourIconListCount,
                        builder: (context, value, _) => Container(
                            alignment: Alignment.center,
                            height: getContainerHeight(
                                widget.isFromDashboardPage,
                                widget.constraint,
                                behvaiourIconListCount),
                            width: widget.isFromDashboardPage == true
                                ? MediaQuery.of(context).size.width
                                : MediaQuery.of(context).size.width * 0.8,
                            margin: widget.isFromDashboardPage == true
                                ? EdgeInsets.fromLTRB(16, 40, 16, 20)
                                : EdgeInsets.only(top: 45),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                Color(0xff000000) ==
                                        Theme.of(context).backgroundColor
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
                                        color: Colors.transparent,
                                        offset: Offset(0, 0),
                                        blurRadius: 0),
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
                            // child: FittedBox(child: pbisStudentProfileWidget)),
                            child: pbisStudentProfileWidget),
                      )),

              //----------------------------------------------------NOTE TEXT FIELD -----------------------------------------------
              Positioned(
                  bottom: 5,
                  child: widget.isFromStudentPlus == true ||
                          widget.isFromDashboardPage == true
                      ? SizedBox.shrink()
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          alignment: Alignment.bottomRight,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: addNotes)),

              //----------------------------------------------------Profile Image-----------------------------------------------------
              Positioned(
                  top: 0,
                  child: GestureDetector(
                      onTap: widget.isFromStudentPlus == true ||
                              widget.isFromDashboardPage == true
                          ? null
                          : () async {
                              Navigator.of(context).pushReplacement(
                                  HeroDialogRoute(
                                      builder: (context) =>
                                          PBISPlusStudentDashBoard(
                                              constraint: widget.constraint,
                                              scaffoldKey: widget.scaffoldKey!,
                                              isValueChangeNotice: valueChange,
                                              onValueUpdate:
                                                  (updatedStudentValueNotifier) {
                                                widget.studentValueNotifier =
                                                    updatedStudentValueNotifier;
                                              },
                                              studentValueNotifier:
                                                  widget.studentValueNotifier,
                                              heroTag: widget.heroTag,
                                              StudentDetailWidget:
                                                  pbisStudentProfileWidget,
                                              classroomCourseId:
                                                  widget.classroomCourseId)));
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
                              imageUrl: widget.studentValueNotifier.value
                                      .profile?.photoUrl ??
                                  ""))))
            ])));
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*---------------------------------------------buildBehaviorGridView-------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  Widget buildBehaviorGridView(
      {required List<PBISPlusCommonBehaviorModal> behaviorList,
      bool loading = false}) {
    return Center(
        child: GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: widget.isFromDashboardPage == true
            ? 1.1
            : 0.9, // Adjust this value to change item aspect ratio
        crossAxisSpacing: 4.0, // Adjust the spacing between items horizontally
        mainAxisSpacing: 4.0, // Adjust the spacing between items vertically
      ),
      itemCount: loading ? 6 : behaviorList.length,
      itemBuilder: (BuildContext context, int index) {
        return FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: loading == true
                ? Container(
                    decoration: BoxDecoration(
                      color: AppTheme.kShimmerHighlightColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 24,
                    width: 24,
                  )
                : PBISPlusActionInteractionButton(
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
                    iconData: behaviorList[index],
                    classroomCourseId: widget.classroomCourseId,
                    scaffoldKey: widget.scaffoldKey,
                  ),
          ),
        );
      },
    ));
  }

  dynamic getContainerHeight(
      bool? isFromDashboardPage, double? constraint, itemcount) {
    double spacing = itemcount.value <= 3
        ? isFromDashboardPage!
            ? MediaQuery.of(context).size.width * 0.1
            : MediaQuery.of(context).size.width * 0.1
        : 0;

    double height = widget.isFromDashboardPage == true
        ? (widget.constraint <= 115)
            ? MediaQuery.of(context).size.height * 0.43 - spacing
            : MediaQuery.of(context).size.height * 0.37 - spacing
        : (widget.constraint <= 115)
            ? isNotesTextfieldEnable.value
                ? MediaQuery.of(context).size.height * 0.58 - spacing
                : MediaQuery.of(context).size.height * 0.51 - spacing
            : isNotesTextfieldEnable.value
                ? MediaQuery.of(context).size.height * 0.57 - spacing
                : MediaQuery.of(context).size.height * 0.45 - spacing;

    return height;
  }

  Widget _buildAddButton({bool isLoading = false}) {
    return ValueListenableBuilder(
      valueListenable: isNotesTextfieldEnable,
      builder: (context, value, _) => isNotesTextfieldEnable.value
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FittedBox(
                child: CustomCircularButton(
                  size: Size(MediaQuery.of(context).size.width * 0.26,
                      MediaQuery.of(context).size.width / 10),
                  borderColor: AppTheme.kButtonColor,
                  textColor:
                      Color(0xff000000) != Theme.of(context).backgroundColor
                          ? Color(0xff111C20)
                          : Color(0xffF7F8F9),
                  text: "Add Note",
                  onClick: () async {
                    if (noteController.text.isNotEmpty) {
                      pBISPlusNotesBloc.add(AddPBISPlusStudentNotes(
                        studentId:
                            widget.studentValueNotifier.value.profile?.id!,
                        studentName: widget
                            .studentValueNotifier.value.profile?.name?.fullName,
                        studentEmail: widget
                            .studentValueNotifier.value.profile?.emailAddress,
                        teacherId: Globals.teacherId,
                        //  await OcrUtility.getTeacherId(),
                        schoolId: Overrides.SCHOOL_ID,
                        schoolDbn: Globals.schoolDbnC,
                        notes: noteController.text,
                      ));
                    } else {
                      // noteController.clear();
                      // Navigator.pop(context);
                    }
                  },
                  backgroundColor: AppTheme.kButtonColor,
                  isBusy: isLoading,
                  buttonRadius: 64,
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }

/*-------------------------------------------------------------------------------------------------------------- */

/*-------------------------------------------------trackUserActivity-------------------------------------------- */

/*-------------------------------------------------------------------------------------------------------------- */

  void trackUserActivity() {
    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        "pbis_plus_student_card_modal_view");

    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'pbis_plus_student_card_modal_screen',
        screenClass: 'PBISPlusStudentCardModal');

    /*-------------------------------------------------------------------------------------*/

    PlusUtility.updateLogs(
        userType: 'Teacher',
        activityType: widget.isFromStudentPlus == true ? 'STUDENT+' : 'PBIS+',
        activityId: '37',
        description:
            'Student ${widget.studentValueNotifier.value.profile!.name} Card View',
        operationResult: 'Success');
  }
}
