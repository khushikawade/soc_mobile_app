// // ignore_for_file: must_be_immutable

// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_plus_utilty.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_common_behavior_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_student_dashbord.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/widgets/circular_custom_button.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/custom_rect_tween.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/hero_dialog_route.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_student_profile_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/PBISPlus_action_interaction_button.dart';

class PBISPlusStudentCardModal extends StatefulWidget {
  ValueNotifier<ClassroomStudents> studentValueNotifier;
  final bool? isFromDashboardPage;
  bool? isFromStudentPlus;
  // to check it is from pbis plus or student plus
  final bool? isLoading; // to maintain loading when user came from student plus
  final String heroTag;
  final Key? scaffoldKey;
  String classroomCourseId;
  final double constraint;
  final Function(ValueNotifier<ClassroomStudents>) onValueUpdate;
  final String? studentProfile;
  final PBISPlusBloc?
      pBISPlusNotesBloc; //used to manage notes and its state at class screen
  PBISPlusStudentCardModal(
      {Key? key,
      required this.isFromDashboardPage,
      required this.studentValueNotifier,
      required this.heroTag,
      this.isFromStudentPlus = false,
      this.isLoading,
      required this.scaffoldKey,
      required this.classroomCourseId,
      required this.onValueUpdate,
      required this.constraint,
      this.studentProfile,
      this.pBISPlusNotesBloc})
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
  // PBISPlusBloc pBISPlusBloc = PBISPlusBloc();
  PBISPlusBloc pBISPlusNotesBloc = PBISPlusBloc();
  PBISPlusBloc pBISPlusBloc = PBISPlusBloc();
  // PBISPlusBloc pBISPlusNotesBloc = PBISPlusBloc();
  ValueNotifier<int> behvaiourIconListCount = ValueNotifier<int>(0);
  ValueNotifier<double> cardHeight = ValueNotifier<double>(1);
  // bool? isCustomBehavior = false;
  FocusNode _focusNode = FocusNode();

  PBISPlusBloc pbisPluDefaultBehaviorBloc = PBISPlusBloc();
  PBISPlusBloc pbisPluCustomBehaviorBloc = PBISPlusBloc();

  @override
  void initState() {
    super.initState();
    // getTeacherSelectedToggleValue();
    trackUserActivity();

    pbisPluCustomBehaviorBloc.add(PBISPlusGetTeacherCustomBehavior());
    pbisPluDefaultBehaviorBloc.add(PBISPlusGetDefaultSchoolBehavior());
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      // TextField is focused
      isNotesTextfieldEnable.value = true;
    }
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*--------------------------------------------getTeacherSelectedToggleValue------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  // void getTeacherSelectedToggleValue() async {
  //   try {
  //     SharedPreferences pref = await SharedPreferences.getInstance();
  //     isCustomBehavior = await pref.getBool(Strings.isCustomBehavior);
  //     PBISPlusEvent event;

  //     if (isCustomBehavior == true) {
  //       event = PBISPlusGetTeacherCustomBehavior();
  //     } else {
  //       event = PBISPlusGetDefaultSchoolBehavior();
  //     }
  //     pBISPlusBloc.add(event);
  //   } catch (e) {}
  // }

/*-------------------------------------------------------------------------------------------------------------- */
/*---------------------------------------------------------MAIN METHOD------------------------------------------ */
/*-------------------------------------------------------------------------------------------------------------- */
  @override
  Widget build(BuildContext context) {
    //----------------------------------------------NOTES TEXT FIELD-------------------------------------------//

    return SingleChildScrollView(
        reverse: true, // this is new
        physics: BouncingScrollPhysics(),
        child: Hero(
            tag: widget.heroTag,
            createRectTween: (begin, end) {
              return CustomRectTween(begin: begin!, end: end!);
            },
            child: widget.isFromStudentPlus == true
                ? BlocConsumer(
                    bloc: pbisPluCustomBehaviorBloc,
                    listener: (context, state) {},
                    builder: (context, state) {
                      return buildCard(
                        isBehaviorLoading: true,
                      );
                    })
                : buildCard(
                    isBehaviorLoading: false,
                  )));
  }

  Widget closeNotesIcon() {
    return isNotesTextfieldEnable.value == true
        ? Positioned(
            right: 8,
            top: MediaQuery.of(context).size.width * 0.2 / 1.30,
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Icon(Icons.clear,
                    color:
                        Color(0xff000000) == Theme.of(context).backgroundColor
                            ? Color(0xff111C20)
                            : Color(0xffF7F8F9),
                    size: Globals.deviceType == "phone" ? 22 : 30)))
        : SizedBox.shrink();
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*---------------------------------------------buildBehaviorGridView-------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  Widget buildBehaviorGridView(
      {required List<PBISPlusCommonBehaviorModal> behaviorList,
      bool loading = false,
      required bool isBehaviorLoading}) {
    return GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: widget.isFromDashboardPage == true ? 1.1 : 0.9,
            // Adjust this value to change item aspect ratio
            crossAxisSpacing: 4.0,
            // Adjust the spacing between items horizontally
            mainAxisSpacing: 4.0
            // Adjust the spacing between items vertically
            ),
        itemCount: behaviorList.length,
        itemBuilder: (BuildContext context, int index) {
          return FittedBox(
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ShimmerLoading(
                          isLoading: loading,
                          child: PBISPlusActionInteractionButton(
                              isBehaviorLoading: isBehaviorLoading,
                              index: index,
                              isCustomBehavior:
                                  PBISPlusOverrides.isCustomBehavior.value,
                              size: widget.isFromDashboardPage == true ||
                                      widget.studentProfile == true
                                  ? 48
                                  : 64,
                              isShowCircle: true,
                              onValueUpdate: (updatedStudentValueNotifier) {
                                widget.classroomCourseId =
                                    widget.classroomCourseId;
                                widget.onValueUpdate(
                                    updatedStudentValueNotifier); // Return to class screen // Roster screen count update
                                widget.studentValueNotifier =
                                    updatedStudentValueNotifier; // Used on current screen to update the value
                                valueChange.value = !valueChange
                                    .value; // Update the changes on bool change detect
                              },
                              isLoading: widget.isFromStudentPlus == true
                                  ? true
                                  : widget.isLoading,
                              isFromStudentPlus: widget.isFromStudentPlus,
                              studentValueNotifier: widget.studentValueNotifier,
                              iconData: behaviorList[index],
                              classroomCourseId: widget.classroomCourseId,
                              scaffoldKey: widget.scaffoldKey)))));
        });
  }

  dynamic getContainerHeight(
      bool? isFromDashboardPage, double? constraint, itemcount) {
    double spacing = // MediaQuery.of(context).size.width * 0.2;
        itemcount.value <= 3
            ? (widget.constraint <= 115)
                ? MediaQuery.of(context).size.width * 0.09
                : MediaQuery.of(context).size.width * 0.12
            // MediaQuery.of(context).size.width * 0.12
            : 0;

    double height = Platform.isAndroid
        ? (widget.isFromDashboardPage == true ||
                widget.isFromStudentPlus == true
            ? (widget.constraint <= 115)
                ? MediaQuery.of(context).size.height * 0.43 - spacing
                : MediaQuery.of(context).size.height * 0.40 - spacing
            : (widget.constraint <= 115)
                ? MediaQuery.of(context).size.height * 0.50 - spacing
                : MediaQuery.of(context).size.height * 0.49 - spacing)
        : widget.isFromDashboardPage == true || widget.isFromStudentPlus == true
            ? (widget.constraint <= 115)
                ? MediaQuery.of(context).size.height * 0.50 - spacing
                : MediaQuery.of(context).size.height * 0.48 - spacing
            : (widget.constraint <= 115)
                ? MediaQuery.of(context).size.height * 0.55 - spacing
                : MediaQuery.of(context).size.height * 0.55 - spacing;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cardHeight.value = height;
    });

    return height;
  }

  Widget _buildAddButton({bool isLoading = false}) {
    return ValueListenableBuilder(
      valueListenable: isNotesTextfieldEnable,
      builder: (context, value, _) => isNotesTextfieldEnable.value
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: FittedBox(
                  child: CustomCircularButton(
                      iconSize: Globals.deviceType == "phone" ? 20 : 28,
                      iconData: IconData(
                        0xe896,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg,
                      ),
                      size: Size(MediaQuery.of(context).size.width * 0.36,
                          MediaQuery.of(context).size.width / 10),
                      borderColor: AppTheme.kButtonColor,
                      textColor:
                          Color(0xff000000) == Theme.of(context).backgroundColor
                              ? Color(0xff111C20)
                              : Color(0xffF7F8F9),
                      text: "Add Note",
                      onClick: () async {
                        if (noteController.text.isNotEmpty) {
                          widget.pBISPlusNotesBloc!.add(AddPBISPlusStudentNotes(
                              studentId: widget
                                  .studentValueNotifier.value.profile?.id!,
                              studentName: widget.studentValueNotifier.value
                                  .profile?.name?.fullName,
                              studentEmail: widget.studentValueNotifier.value
                                  .profile?.emailAddress,
                              teacherId: await OcrUtility.getTeacherId(),
                              schoolId: Overrides.SCHOOL_ID,
                              schoolDbn: Globals.schoolDbnC,
                              notes: noteController.text));
                          Navigator.pop(context, true);
                        }
                      },
                      backgroundColor: AppTheme.kButtonColor,
                      isBusy: isLoading,
                      buttonRadius: 64)))
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

  Widget buildCard({required bool isBehaviorLoading}) {
    return ValueListenableBuilder(
        valueListenable: cardHeight,
        builder: (context, value, _) =>
            Stack(alignment: Alignment.center, children: <Widget>[
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
                                ? EdgeInsets.fromLTRB(
                                    16,
                                    MediaQuery.of(context).size.width *
                                        0.2 /
                                        1.5,
                                    16,
                                    20)
                                : EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width *
                                        0.2 /
                                        1.5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  Color(0xff000000) ==
                                          Theme.of(context).backgroundColor
                                      ? BoxShadow(
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
                                          : Color(0xff111C20)
                                    ],
                                    stops: [
                                      widget.isFromDashboardPage == true ||
                                              widget.isFromStudentPlus == true
                                          ? 0.3
                                          : 0.2,
                                      0.0
                                    ])),
                            child: pbisStudentProfileWidget(
                                isBehaviorLoading: isBehaviorLoading)),
                      )),

              //----------------------------------------------------NOTE TEXT FIELD -----------------------------------------------

              ValueListenableBuilder(
                  valueListenable: isNotesTextfieldEnable,
                  builder: (context, value, _) =>
                      isNotesTextfieldEnable.value == true
                          ? SizedBox.shrink()
                          : Positioned(
                              bottom: 5,
                              child: widget.isFromStudentPlus == true ||
                                      widget.isFromDashboardPage == true ||
                                      isNotesTextfieldEnable.value == true
                                  ? SizedBox.shrink()
                                  : Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                                      ),
                                      alignment: Alignment.bottomRight,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: addNotes()))),

              ///-------------------------------CLOSE BUTTON------------------------------------

              closeNotesIcon(),

              //----------------------------------------------------Profile Image-----------------------------------------------------
              closeNotesIcon(),
              Positioned(
                  top: 00,
                  child: GestureDetector(
                      onTap: widget.isFromStudentPlus == true ||
                              widget.isFromDashboardPage == true
                          ? () {}
                          //  null
                          : () async {
                              Navigator.of(context).pushReplacement(
                                  HeroDialogRoute(
                                      builder: (context) =>
                                          PBISPlusStudentDashBoard(
                                              pBISPlusBloc: PBISPlusOverrides
                                                          .isCustomBehavior
                                                          .value ==
                                                      true
                                                  ? pbisPluCustomBehaviorBloc
                                                  : pbisPluDefaultBehaviorBloc,
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
                                                  pbisStudentProfileWidget(
                                                          isBehaviorLoading:
                                                              false) ??
                                                      Container(),
                                              classroomCourseId:
                                                  widget.classroomCourseId)));
                            },
                      child: Column(children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: PBISCommonProfileWidget(
                              studentProfile: widget.studentProfile,
                              isFromStudentPlus: widget.isFromStudentPlus,
                              isLoading: isBehaviorLoading,
                              valueChange: valueChange,
                              countWidget: true,
                              studentValueNotifier: widget.studentValueNotifier,
                              profilePictureSize:
                                  MediaQuery.of(context).size.width * 0.1,
                              imageUrl: widget.studentValueNotifier.value
                                      .profile?.photoUrl ??
                                  ""),
                        ),
                        Container(
                            alignment: Alignment.topCenter,
                            height: MediaQuery.of(context).size.width * 0.1,
                            width: widget.isFromDashboardPage == true
                                ? MediaQuery.of(context).size.width
                                : MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                                color: widget.isFromDashboardPage == true ||
                                        widget.isFromStudentPlus == true
                                    ? Colors.transparent
                                    :
                                    // Colors.orangeAccent,
                                    AppTheme.kButtonColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12))),
                            child: Text(
                                widget.studentValueNotifier.value.profile?.name
                                        ?.fullName ??
                                    '',
                                textAlign: TextAlign.end,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)))
                      ])))
            ]));
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*------------------------------------------ActionInteractionButtonsRowWise------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  Widget? actionInteractionButtonsRowWise({required bool isBehaviorLoading}) {
    return ValueListenableBuilder(
        valueListenable: PBISPlusOverrides.isCustomBehavior,
        builder: (context, value, _) {
          return BlocConsumer(
              bloc: PBISPlusOverrides.isCustomBehavior.value == true
                  ? pbisPluCustomBehaviorBloc
                  : pbisPluDefaultBehaviorBloc,
              listener: (context, state) {
                if (state is PBISPlusGetTeacherCustomBehaviorSuccess) {
                  if (state.teacherCustomBehaviorList.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      behvaiourIconListCount.value =
                          state.teacherCustomBehaviorList.length;
                      PBISPlusOverrides.teacherCustomBehaviorList.value =
                          state.teacherCustomBehaviorList;
                    });
                  } else {
                    PBISPlusOverrides.isCustomBehavior.value = false;
                    pbisPluCustomBehaviorBloc
                        .add(PBISPlusGetDefaultSchoolBehavior());
                  }
                }
              },
              builder: (contxt, state) {
                if (state is PBISPlusGetDefaultSchoolBehaviorSuccess) {
                  return state.defaultSchoolBehaviorList.isNotEmpty
                      ? buildBehaviorGridView(
                          isBehaviorLoading: isBehaviorLoading,
                          behaviorList: state.defaultSchoolBehaviorList,
                          loading: false)
                      : NoDataFoundErrorWidget(
                          errorMessage: 'No Behaviors Found',
                          marginTop: MediaQuery.of(context).size.height * 0.06,
                          isResultNotFoundMsg: true,
                          isNews: false,
                          isEvents: false);
                }
                if (state is PBISPlusGetTeacherCustomBehaviorSuccess) {
                  if (state.teacherCustomBehaviorList.isNotEmpty) {
                    // WidgetsBinding.instance.addPostFrameCallback((_) {
                    //   behvaiourIconListCount.value =
                    //       state.teacherCustomBehaviorList.length;
                    //   PBISPlusOverrides.teacherCustomBehaviorList.value =
                    //       state.teacherCustomBehaviorList;
                    // });

                    return ValueListenableBuilder(
                        valueListenable:
                            PBISPlusOverrides.teacherCustomBehaviorList,
                        builder: (context, value, _) {
                          return buildBehaviorGridView(
                              isBehaviorLoading: isBehaviorLoading,
                              behaviorList: PBISPlusOverrides
                                  .teacherCustomBehaviorList.value,
                              loading: false);
                        });
                  } else {
                    return NoDataFoundErrorWidget(
                        marginTop: MediaQuery.of(context).size.height * 0.06,
                        isResultNotFoundMsg: true,
                        isNews: false,
                        isEvents: false);
                  }

                  // else {
                  //   // pbisPluCustomBehaviorBloc
                  //   //     .add(PBISPlusGetDefaultSchoolBehavior());
                  // }
                }

                if (state is PBISPlusBehaviorLoading) {
                  return buildBehaviorGridView(
                      isBehaviorLoading: isBehaviorLoading,
                      behaviorList: state.demoBehaviorData,
                      loading: true);
                }
                return Container();
              });
        });
  }

  Widget? pbisStudentProfileWidget({required bool isBehaviorLoading}) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            isNotesTextfieldEnable.value == true
                ? Expanded(
                    child: ValueListenableBuilder(
                        valueListenable: isNotesTextfieldEnable,
                        builder: (context, value, _) => Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12))),
                            alignment: Alignment.bottomRight,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: addNotes())),
                  )
                : Expanded(
                    child: ValueListenableBuilder(
                        valueListenable: isNotesTextfieldEnable,
                        builder: (context, value, _) => Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                                top: widget.isFromDashboardPage == true ||
                                        widget.isFromStudentPlus == true
                                    ? MediaQuery.of(context).size.height * 0.1
                                    : MediaQuery.of(context).size.width * 0.1),
                            padding: EdgeInsets.only(left: 10, right: 10),
                            width: MediaQuery.of(context).size.width * 1,
                            child: actionInteractionButtonsRowWise(
                                isBehaviorLoading: isBehaviorLoading))))
          ]);

  Column addNotes() => Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            isNotesTextfieldEnable.value == true
                ? SizedBox.shrink()
                : Container(
                    height: 0.1,
                    width: double.infinity,
                    color:
                        Color(0xff000000) != Theme.of(context).backgroundColor
                            ? Color(0xff111C20)
                            : Color(0xffF7F8F9)),
            ValueListenableBuilder(
                valueListenable: isNotesTextfieldEnable,
                builder: (context, value, _) => TextFormField(
                      minLines: isNotesTextfieldEnable.value == true ? null : 1,
                      maxLines: 12,
                      focusNode: _focusNode,
                      autofocus: isNotesTextfieldEnable.value,
                      textAlign: isNotesTextfieldEnable.value
                          ? TextAlign.start
                          : TextAlign.center,
                      controller: noteController,
                      onChanged: (value) {
                        isNotesTextfieldEnable.value = true;
                        // if (noteController.text.isEmpty) {
                        //   isNotesTextfieldEnable.value = false;
                        // }
                      },
                      cursorColor:
                          Color(0xff000000) != Theme.of(context).backgroundColor
                              ? Color(0xff111C20)
                              : Color(0xffF7F8F9),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xff000000) !=
                                Theme.of(context).backgroundColor
                            ? Color(0xffF7F8F9)
                            : Color(0xff111C20),
                        // Color(0xffF7F8F9),
                        hintText:
                            isNotesTextfieldEnable.value ? "" : "Add Note",
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
                bloc: widget.pBISPlusNotesBloc,
                builder: (context, state) {
                  if (state is PBISPlusLoading) {
                    return _buildAddButton(isLoading: true);
                  }
                  return _buildAddButton(isLoading: false);
                },
                listener: (context, state) async {
                  // if (state is PBISPlusAddNotesSucess) {
                  //   isNotesTextfieldEnable.value = false;
                  //   noteController.clear();
                  //   Utility.currentScreenSnackBar(
                  //       "Note added successfully", null);
                  //   Navigator.pop(context, true);
                  // } else if (state is PBISErrorState) {
                  //   isNotesTextfieldEnable.value = false;
                  //   noteController.clear();
                  //   Utility.currentScreenSnackBar(state.error.toString(), null);
                  //   Navigator.pop(context, true);
                  // }
                })
          ]);
}
