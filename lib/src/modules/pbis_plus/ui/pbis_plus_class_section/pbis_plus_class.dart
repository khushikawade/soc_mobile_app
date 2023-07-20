// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/widgets/spinning_icon.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_student_card_modal.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_setting_bottom_sheet.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/custom_rect_tween.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/hero_dialog_route.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_save_and_share_bottom_sheet.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_student_profile_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_fab.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/google_authentication.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:screenshot/screenshot.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class PBISPlusClass extends StatefulWidget {
  final IconData titleIconData;
  final VoidCallback backOnTap;
  final bool isGradedPlus;

  PBISPlusClass(
      {Key? key,
      required this.titleIconData,
      required this.backOnTap,
      required this.isGradedPlus})
      : super(key: key);

  @override
  State<PBISPlusClass> createState() => _PBISPlusClassState();
}

class _PBISPlusClassState extends State<PBISPlusClass>
    with SingleTickerProviderStateMixin {
  PBISPlusBloc pbisPlusClassroomBloc = PBISPlusBloc();
  PBISPlusBloc pbisPlusTotalInteractionBloc = PBISPlusBloc();
  final List<ClassroomCourse> googleClassroomCourseworkList =
      []; //Used to send the value in bottomsheet coursework list
  final ValueNotifier<int> selectedValue = ValueNotifier<int>(0);
  final ValueNotifier<int> courseLength = ValueNotifier<int>(0);
  final ValueNotifier<bool> screenShotNotifier = ValueNotifier<bool>(false);
  final ItemScrollController _itemScrollController = ItemScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PBISPlusBloc pBISPlusNotesBloc = PBISPlusBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final double profilePictureSize = 30;
  static const double _KVerticalSpace = 60.0;
  ScreenshotController headerScreenshotController =
      ScreenshotController(); // screenshot for header widget
  ScreenshotController screenshotController =
      ScreenshotController(); // screenshot of whole list
  PBISPlusBloc pbisBloc = PBISPlusBloc();
  AnimationController? _animationController;
  @override
  void initState() {
    super.initState();
    pbisPlusClassroomBloc
        .add(PBISPlusImportRoster(isGradedPlus: widget.isGradedPlus));

    FirebaseAnalyticsService.addCustomAnalyticsEvent("pbis_plus_class_screen");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'pbis_plus_class_screen', screenClass: 'PBISPlusClass');

    if (widget.isGradedPlus == true) {
      _animationController = AnimationController(
          vsync: this,
          duration: const Duration(seconds: 1),
          animationBehavior: AnimationBehavior.normal);
    }
  }

  @override
  void dispose() {
    if (widget.isGradedPlus == true) {
      _animationController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Stack(children: [
          CommonBackgroundImgWidget(),
          Scaffold(
            resizeToAvoidBottomInset: false,
            key: _scaffoldKey,
            extendBody: true,
            backgroundColor: Colors.transparent,
            appBar: PBISPlusUtility.pbisAppBar(
                refresh: (v) {
                  setState(() {});
                },
                context: context,
                titleIconData: widget.titleIconData,
                title: 'Class',
                scaffoldKey: _scaffoldKey,
                isGradedPlus: widget.isGradedPlus),
            floatingActionButton: widget.isGradedPlus == true
                ? null
                : ValueListenableBuilder(
                    valueListenable: courseLength,
                    child: Container(),
                    builder:
                        (BuildContext context, dynamic value, Widget? child) {
                      return courseLength.value > 0
                          ? saveAndShareFAB(
                              context,
                            )
                          : Container();
                    }),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniEndFloat,
            body: body(),
          )
        ]));
  }

  Widget headerListTile() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      title: PlusScreenTitleWidget(
        kLabelSpacing: StudentPlusOverrides.kLabelSpacing,
        text: 'All Classes',
        backButton: false,
        isTrailingIcon: true,
        // backButtonOnTap: () {
        //   widget.backOnTap();
        // },
      ),
      trailing: widget.isGradedPlus == true
          ? Container(
              height: MediaQuery.of(context).size.height * 0.036,
              child: FloatingActionButton.extended(
                  backgroundColor: AppTheme.kButtonColor,
                  onPressed: () {
                    if (_animationController!.isAnimating == true) {
                      Utility.currentScreenSnackBar(
                          'Please Wait, Sync Is In Progress', null,
                          marginFromBottom: 90);
                    } else {
                      _animationController!.repeat();
                      refreshPage();
                    }
                  },
                  label: Row(
                    children: [
                      Utility.textWidget(
                          text: 'Sync',
                          context: context,
                          textTheme: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(
                                  color: Theme.of(context).backgroundColor)),
                    ],
                  ),
                  icon: SpinningIconButton(
                    controller: _animationController,
                    iconData: Icons.sync,
                  )),
            )
          : ValueListenableBuilder(
              valueListenable: courseLength,
              child: Container(),
              builder: (BuildContext context, dynamic value, Widget? child) {
                return courseLength.value > 0
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          //----------setting bottom sheet funtion------------//

                          settingBottomSheet(
                              context, pbisBloc, googleClassroomCourseworkList);
                          // Navigator.of(context).pushReplacement(
                          //   MaterialPageRoute(
                          //       builder: (context) => PBISPlusEditSkills()),
                          // );
                        },
                        icon: Icon(
                          IconData(
                            0xe867,
                            fontFamily: Overrides.kFontFam,
                            fontPackage: Overrides.kFontPkg,
                          ),
                          color: AppTheme.kButtonColor,
                        ))
                    : SizedBox.shrink();
              }),
    );
  }

  Widget body() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: StudentPlusOverrides.kSymmetricPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.max,
        children: [
          // SpacerWidget(StudentPlusOverrides.KVerticalSpace / 10),
          ValueListenableBuilder(
            valueListenable: screenShotNotifier,
            builder: (context, value, child) {
              return screenShotNotifier.value ==
                      true //To manage the background color of title in the PDF
                  ? Screenshot(
                      controller: headerScreenshotController,
                      child: Container(child: headerListTile()),
                    )
                  : headerListTile();
            },
          ),
          SpacerWidget(_KVerticalSpace / 5),
          Expanded(
            child: BlocConsumer(
                bloc: pbisPlusClassroomBloc,
                builder: (context, state) {
                  if (state is PBISPlusInitial) {
                    Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: AppTheme.kButtonColor,
                        ));
                  }
                  if (state is PBISPlusClassRoomShimmerLoading) {
                    return (state!.shimmerCoursesList?.isNotEmpty ?? false)
                        ? buildList(
                            googleClassroomCourseList: state.shimmerCoursesList,
                            isStudentInteractionLoading: false,
                            isScreenShimmerLoading: true)
                        : Container(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: AppTheme.kButtonColor,
                            ));
                  }
                  if (state is PBISPlusImportRosterSuccess) {
                    if (state.googleClassroomCourseList.isNotEmpty ?? false) {
                      return buildList(
                          googleClassroomCourseList:
                              state.googleClassroomCourseList,
                          isStudentInteractionLoading: false,
                          isScreenShimmerLoading: false);
                    } else {
                      return noClassroomFound();
                    }
                  }
                  if (state is PBISPlusInitialImportRosterSuccess) {
                    if (state.googleClassroomCourseList.isNotEmpty ?? false) {
                      return buildList(
                          googleClassroomCourseList:
                              state.googleClassroomCourseList,
                          isStudentInteractionLoading: true,
                          isScreenShimmerLoading: false);
                    } else {
                      return noClassroomFound();
                    }
                  }
                  if (state is PBISErrorState) {
                    return noClassroomFound();
                  }
                  return Container();
                },
                listener: (context, state) async {
                  if (state is PBISPlusImportRosterSuccess) {
                    //To manage FAB and setting button
                    courseLength.value =
                        state?.googleClassroomCourseList?.length ?? 0;

                    if (state.googleClassroomCourseList.isNotEmpty ?? false) {
                      ///Used to send the list of courseWork to the bottomsheet list
                      /*----------------------START--------------------------*/
                      googleClassroomCourseworkList.clear();
                      // googleClassroomCourseworkList
                      //     .add(ClassroomCourse(name: 'All'));
                      googleClassroomCourseworkList
                          .addAll(state.googleClassroomCourseList);

                      /*----------------------END--------------------------*/
                    }
                    if (widget.isGradedPlus == true &&
                        _animationController!.isAnimating == true) {
                      Utility.currentScreenSnackBar(
                          'Classroom Synced Successfully', null,
                          marginFromBottom: 90);
                      _animationController!.stop();
                    }
                  }
                  if (state is PBISErrorState) {
                    if (state.error == 'ReAuthentication is required') {
                      // await Utility.refreshAuthenticationToken(
                      //     isNavigator: true,
                      //     errorMsg: state.error!,
                      //     context: context,
                      //     scaffoldKey: _scaffoldKey);
                      await Authentication.reAuthenticationRequired(
                          context: context,
                          errorMessage: state.error,
                          scaffoldKey: _scaffoldKey);
                      pbisPlusClassroomBloc.add(PBISPlusImportRoster(
                          isGradedPlus: widget.isGradedPlus));
                    } else {
                      Navigator.of(context).pop();
                      Utility.currentScreenSnackBar(
                          "Something Went Wrong. Please Try Again.", null);
                    }

                    // Navigator.of(context).pop();
                    // Utility.currentScreenSnackBar(
                    //     "Something Went Wrong. Please Try Again.");
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget buildList(
      {required List<ClassroomCourse> googleClassroomCourseList,
      required final bool isStudentInteractionLoading,
      required final bool isScreenShimmerLoading}) {
    return Container(
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Container(
              margin: EdgeInsets.all(10.0),
              height: 30,
              child: Container(
                child: ListView.builder(
                  controller: null,
                  itemBuilder: (BuildContext context, int index) {
                    return chipBuilder(googleClassroomCourseList, context,
                        index, isScreenShimmerLoading);
                  },
                  itemCount: googleClassroomCourseList.length,
                  scrollDirection: Axis.horizontal,
                ),
              )),
          studentListCourseWiseView(googleClassroomCourseList,
              isStudentInteractionLoading, isScreenShimmerLoading)
        ],
      ),
    );
  }

  Widget chipBuilder(List<ClassroomCourse> courseList, context, currentIndex,
      final bool isScreenShimmerLoading) {
    return ValueListenableBuilder(
        valueListenable: selectedValue,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return GestureDetector(
            onTap: () {
              if (isScreenShimmerLoading) {
                return;
              }
              selectedValue.value = currentIndex;
              _animateToIndex(
                currentIndex,
                courseList[currentIndex].students!.length,
              );

              FirebaseAnalyticsService.addCustomAnalyticsEvent(
                  'Course chip tap PBIS+'.toLowerCase().replaceAll(" ", "_"));
            },
            child: ShimmerLoading(
              isLoading: isScreenShimmerLoading,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                margin: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  boxShadow: [],
                  color: //Colors.transparent,
                      Color(0xff000000) != Theme.of(context).backgroundColor
                          ? Color(0xffF7F8F9)
                          : Color(0xff111C20),
                  border: Border.all(
                      color: selectedValue.value == currentIndex &&
                              !isScreenShimmerLoading
                          ? AppTheme.kSelectedColor
                          : Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      courseList[currentIndex].name!,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _animateToIndex(
    int index,
    int listLength,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _itemScrollController.scrollTo(
          index: index,
          duration: const Duration(seconds: 2),
          curve: Curves.linearToEaseOut);
    });
  }

  Widget studentListCourseWiseView(
      googleClassroomCourseList,
      final bool isStudentInteractionLoading,
      final bool isScreenShimmerLoading) {
    return ValueListenableBuilder(
      valueListenable: screenShotNotifier,
      builder: (context, value, child) {
        return RefreshIndicator(
            color: AppTheme.kButtonColor,
            key: refreshKey,
            onRefresh: refreshPage,
            child: Container(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.height * 0.68 //7
                        : MediaQuery.of(context).size.height * 0.45,
                child: screenShotNotifier.value == true
                    ? SingleChildScrollView(
                        child: Screenshot(
                            controller: screenshotController,
                            child: Container(
                                color: Color(0xff000000) !=
                                        Theme.of(context).backgroundColor
                                    ? Color(0xffF7F8F9)
                                    : Color(0xff111C20),
                                child: scrollableBuilder(
                                    googleClassroomCourseList,
                                    isStudentInteractionLoading,
                                    isScreenShimmerLoading))),
                      )
                    : scrollableBuilder(googleClassroomCourseList,
                        isStudentInteractionLoading, isScreenShimmerLoading)));
      },
    );
  }

  Widget scrollableBuilder(
      googleClassroomCourseList,
      final bool isStudentInteractionLoading,
      final bool isScreenShimmerLoading) {
    return ScrollablePositionedList.builder(
        physics: isScreenShimmerLoading ? NeverScrollableScrollPhysics() : null,
        padding: EdgeInsets.only(bottom: Platform.isIOS ? 60 : 30),
        shrinkWrap: true,
        itemScrollController: _itemScrollController,
        itemCount: googleClassroomCourseList.length,
        itemBuilder: (context, index) {
          return _buildCourseSeparationList(googleClassroomCourseList, index,
              isStudentInteractionLoading, isScreenShimmerLoading);
        });
  }

  Widget _buildCourseSeparationList(
      List<ClassroomCourse> googleClassroomCourseList,
      index,
      final bool isStudentInteractionLoading,
      final bool isScreenShimmerLoading) {
    return Column(children: [
      Container(
        key: ValueKey(googleClassroomCourseList[index]),
        color: Theme.of(context).colorScheme.secondary,
        child: ShimmerLoading(
          isLoading: isScreenShimmerLoading,
          child: Center(
              child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Text(
              googleClassroomCourseList[index].name!,
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(color: AppTheme.kButtonColor),
            ),
          )),
        ),
      ),
      googleClassroomCourseList[index].students!.length > 0
          ? renderStudents(
              googleClassroomCourseList[index].students!,
              index,
              googleClassroomCourseList[index].id!,
              isStudentInteractionLoading,
              isScreenShimmerLoading)
          : Container(
              height: 65,
              padding: EdgeInsets.only(left: 20),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              color:
                  Theme.of(context).colorScheme.background == Color(0xff000000)
                      ? Color(0xff162429)
                      : Color(0xffF7F8F9),
              child: Utility.textWidget(
                  textTheme: Theme.of(context).textTheme.bodyText1!,
                  textAlign: TextAlign.center,
                  text: 'No Student Found',
                  context: context))
    ]);
  }

  renderStudents(
      List<ClassroomStudents> studentList,
      i,
      String classroomCourseId,
      final bool isStudentInteractionLoading,
      final bool isScreenShimmerLoading) {
    return GridView.count(
        padding: EdgeInsets.all(10.0),
        childAspectRatio: 7.0 / 9.0,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        shrinkWrap: true,
        children: List.generate(studentList.length, (index) {
          return _buildStudent(
              ValueNotifier<ClassroomStudents>(studentList[index]),
              index,
              classroomCourseId,
              isStudentInteractionLoading,
              isScreenShimmerLoading);
        }));
  }

  Widget _buildStudent(
      ValueNotifier<ClassroomStudents> studentValueNotifier,
      int index,
      String classroomCourseId,
      final bool isStudentInteractionLoading,
      final bool isScreenShimmerLoading) {
    String heroTag = "HeroTag_${classroomCourseId}_${index}";

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      Container BuildStudentCountIndicator = Container(
        padding: EdgeInsets.all(2),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: AppTheme.kButtonColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: FittedBox(
              fit: BoxFit.scaleDown,
              child: ValueListenableBuilder<ClassroomStudents>(
                  valueListenable: studentValueNotifier,
                  builder: (BuildContext context, ClassroomStudents value,
                      Widget? child) {
                    return Text(
                      //TODOPBIS:
                      PBISPlusUtility.numberAbbreviationFormat(
                          // studentValueNotifier
                          //         .value.profile!.behavior1!.counter! +
                          //     studentValueNotifier
                          //         .value.profile!.behavior2!.counter! +
                          //     studentValueNotifier
                          //         .value.profile!.behavior2!.counter!
                          studentValueNotifier.value!.profile!.engaged! +
                              studentValueNotifier.value!.profile!.niceWork! +
                              studentValueNotifier.value!.profile!.helpful!),
                      style: TextStyle(
                        color: Theme.of(context).backgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  })),
        ),
      );
      return studentCardLayoutBuilder(
          isStudentInteractionLoading,
          isScreenShimmerLoading,
          constraints,
          studentValueNotifier,
          heroTag,
          classroomCourseId,
          BuildStudentCountIndicator);
    });
  }

  Widget studentCardLayoutBuilder(
      bool isStudentInteractionLoading,
      bool isScreenShimmerLoading,
      BoxConstraints constraints,
      ValueNotifier<ClassroomStudents> studentValueNotifier,
      String heroTag,
      String classroomCourseId,
      Container BuildStudentCountIndicator) {
    return GestureDetector(
      onTap: () async {
        if (isStudentInteractionLoading ||
            isScreenShimmerLoading ||
            widget.isGradedPlus == true) {
          return;
        }

        await Navigator.of(context).push(
          HeroDialogRoute(
            builder: (context) => Center(
                //--------------------------- START //OLD FLOW MAKE BY NIKHAR ------------------------
                // child: PBISPlusStudentCardModal(
                //   constraint: constraints.maxHeight,
                //   onValueUpdate: (updatedStudentValueNotifier) {
                //     studentValueNotifier = updatedStudentValueNotifier;
                //   },
                //   studentValueNotifier: studentValueNotifier,
                //   heroTag: heroTag,
                //   classroomCourseId: classroomCourseId,
                //   scaffoldKey: _scaffoldKey,
                // ),
                //--------------------------- END //OLD FLOW MAKE BY NIKHAR --------------------------

                // NEW FLOW
                child: PBISPlusStudentCardModal(
              constraint: constraints.maxHeight,
              isFromStudentPlus: false,
              isFromDashboardPage: false,
              onValueUpdate: (updatedStudentValueNotifier) {
                studentValueNotifier = updatedStudentValueNotifier;
              },
              studentValueNotifier: studentValueNotifier,
              heroTag: heroTag,
              classroomCourseId: classroomCourseId,
              scaffoldKey: _scaffoldKey,
              pBISPlusNotesBloc: pBISPlusNotesBloc,
            )),
          ),
        );
      },
      child: Hero(
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          tag: heroTag,
          child: Stack(
            // alignment: Alignment.bottomCenter,
            children: [
              ShimmerLoading(
                isLoading: isScreenShimmerLoading,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 5),
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          Color(0xff000000) == Theme.of(context).backgroundColor
                              ? Color(0xffF7F8F9)
                              : Color(0xff111C20),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Container(
                    child: Column(
                      //  mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PBISCommonProfileWidget(
                            studentValueNotifier: studentValueNotifier,
                            profilePictureSize: profilePictureSize,
                            imageUrl:
                                studentValueNotifier.value!.profile!.photoUrl!),
                        // SizedBox(height: 15),
                        Text(
                          studentValueNotifier.value.profile!.name!.fullName!
                              .replaceAll(' ', '\n'),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              BlocConsumer<PBISPlusBloc, PBISPlusState>(
                  bloc: pBISPlusNotesBloc,
                  builder: (context, state) {
                    return SizedBox.shrink();
                  },
                  listener: (context, state) async {
                    print(state);
                    if (state is PBISPlusAddNotesSucess) {
                      Utility.currentScreenSnackBar(
                          "Note added successfully", null);
                    } else if (state is PBISErrorState) {
                      Utility.currentScreenSnackBar(
                          state.error.toString(), null);
                    }
                  }),
              if (widget.isGradedPlus != true)
                Positioned(
                    top: 0,
                    right: 0,
                    child: ShimmerLoading(
                        isLoading: isStudentInteractionLoading ||
                            isScreenShimmerLoading,
                        child: BuildStudentCountIndicator)),
            ],
          )),
    );
  }

  Widget saveAndShareFAB(
    BuildContext context,
  ) =>
      PlusCustomFloatingActionButton(
        onPressed: () {
          /*-------------------------User Activity Track START----------------------------*/
          PlusUtility.updateLogs(
              activityType: 'PBIS+',
              userType: 'Teacher',
              activityId: '36',
              description: 'Save and Share button open from All Courses',
              operationResult: 'Success');

          FirebaseAnalyticsService.addCustomAnalyticsEvent(
              'save and share from class screen PBIS+'
                  .toLowerCase()
                  .replaceAll(" ", "_"));
          /*-------------------------User Activity Track END----------------------------*/
          screenShotNotifier.value =
              true; // To manage the course chip onTap animation
          _saveAndShareBottomSheetMenu(googleClassroomCourseworkList);
        },
      );

  Future<void> _saveAndShareBottomSheetMenu(
      List<ClassroomCourse> allClassroomCourses) async {
    PlusUtility.updateLogs(
        activityType: 'PBIS+',
        userType: 'Teacher',
        activityId: '36',
        description: 'Save and Share',
        operationResult: 'Success');
    //Check and add 'All' option in the course list in case of not exist
    if (!allClassroomCourses[0].name!.contains('All')) {
      allClassroomCourses.insert(
          0,
          ClassroomCourse(name: 'All', students: [
            ClassroomStudents(
                profile: ClassroomProfile(
                    name: ClassroomProfileName(fullName: 'All'), id: 'All'))
          ]));
    }

    var result = await showModalBottomSheet(
        // clipBehavior: Clip.antiAliasWithSaveLayer,
        useRootNavigator: true,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        // animationCurve: Curves.easeOutQuart,
        elevation: 10,
        context: context,
        builder: (BuildContext context) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              // Set the maximum height of the bottom sheet based on the screen size

              return PBISPlusBottomSheet(
                fromClassScreen: true,
                isClassPage: true,
                screenshotController: screenshotController,
                headerScreenshotController: headerScreenshotController,
                constraintDeviceHeight: constraints.maxHeight,
                scaffoldKey: _scaffoldKey,
                googleClassroomCourseworkList:
                    List<ClassroomCourse>.unmodifiable(
                        googleClassroomCourseworkList),
                padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
                height: constraints.maxHeight < 800
                    ? MediaQuery.of(context).size.height * 0.5
                    : MediaQuery.of(context).size.height * 0.43,
                // title: 'Save and Share',
                title: '',
              );
            },
          );
        });

    if (result == true) {
      refreshPage();
    }

    screenShotNotifier.value = false;
    // To manage the course chip onTap animation
  }

  Widget noClassroomFound() {
    return RefreshIndicator(
        color: AppTheme.kButtonColor,
        key: refreshKey,
        onRefresh: refreshPage,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: MediaQuery.of(context).size.height *
                      0.22), //Required to manage the ceneter alignment of listview
              Utility.textWidget(
                  text:
                      'Uh oh! Looks like we\'re unable to import your roster from Google Classroom.',
                  context: context,
                  textAlign: TextAlign.center,
                  textTheme: Theme.of(context).textTheme.headline2!),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: FloatingActionButton.extended(
                    backgroundColor: AppTheme.kButtonColor.withOpacity(1.0),
                    onPressed: () async {
                      FirebaseAnalyticsService.addCustomAnalyticsEvent(
                          'Contact solved button pressed class screen PBIS+'
                              .toLowerCase()
                              .replaceAll(" ", "_"));

                      Utility.launchMailto(
                          'PBIS+ | Google Classroom Import | ${Globals.appSetting.schoolNameC}',
                          '');
                    },
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Utility.textWidget(
                            text: 'Contact Solved',
                            context: context,
                            textTheme: Theme.of(context)
                                .textTheme
                                .headline2!
                                .copyWith(
                                    color: Theme.of(context).backgroundColor)),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    pbisPlusClassroomBloc
        .add(PBISPlusImportRoster(isGradedPlus: widget.isGradedPlus));

    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        'Sync Google Classroom Course List PBIS+'
            .toLowerCase()
            .replaceAll(" ", "_"));
  }

  //------------------------------for setting bottom sheet"-------------------//
  settingBottomSheet(context, PBISPlusBloc pbisBloc,
      List<ClassroomCourse> allClassroomCourses) async {
    //Check and add 'All' option in the course and student list in case of not exist
    if (!allClassroomCourses[0].name!.contains('All')) {
      allClassroomCourses.insert(
          0,
          ClassroomCourse(name: 'All', students: [
            ClassroomStudents(
                profile: ClassroomProfile(
                    name: ClassroomProfileName(fullName: 'All'), id: 'All'))
          ]));
    }
    var section = await showModalBottomSheet(
        useRootNavigator: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        elevation: 10,
        context: context,
        builder: (context) => LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // Set the maximum height of the bottom sheet based on the screen size
                return PBISPlusSettingBottomSheet(
                    scaffoldKey: _scaffoldKey,
                    pbisBloc: pbisBloc,
                    constraintDeviceHeight: constraints.maxHeight,
                    googleClassroomCourseworkList:
                        List<ClassroomCourse>.unmodifiable(allClassroomCourses),
                    height: constraints.maxHeight < 750
                        ? MediaQuery.of(context).size.height * 0.6
                        : MediaQuery.of(context).size.height * 0.48);
              },
            ));

    if (section?.isNotEmpty ?? false) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        refreshPage();
      });
    }
  }
}
