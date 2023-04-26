// ignore_for_file: deprecated_member_use

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_student_card_modal.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/custom_rect_tween.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/hero_dialog_route.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_save_and_share_bottom_sheet.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_fab.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_student_profile_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:screenshot/screenshot.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class PBISPlusClass extends StatefulWidget {
  final IconData titleIconData;
  PBISPlusClass({Key? key, required this.titleIconData}) : super(key: key);

  @override
  State<PBISPlusClass> createState() => _PBISPlusClassState();
}

class _PBISPlusClassState extends State<PBISPlusClass> {
  PBISPlusBloc pbisPlusClassroomBloc = PBISPlusBloc();
  PBISPlusBloc pbisPlusTotalInteractionBloc = PBISPlusBloc();
  final List<ClassroomCourse> googleClassroomCourseworkList =
      []; //Used to send the value in bottomsheet coursework list
  final ValueNotifier<int> selectedValue = ValueNotifier<int>(0);
  final ValueNotifier<int> courseLength = ValueNotifier<int>(0);
  final ItemScrollController _itemScrollController = ItemScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final double profilePictureSize = 30;
  static const double _KVerticalSpace = 60.0;
  ScreenshotController headerScreenshotController =
      ScreenshotController(); // screenshot for header widget
  ScreenshotController screenshotController =
      ScreenshotController(); // screenshot of whole list

  @override
  void initState() {
    super.initState();
    pbisPlusClassroomBloc.add(PBISPlusImportRoster());

    FirebaseAnalyticsService.addCustomAnalyticsEvent("pbis_plus_class_screen");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'pbis_plus_class_screen', screenClass: 'PBISPlusClass');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CommonBackgroundImgWidget(),
      Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar:
            PBISPlusUtility.pbisAppBar(context, widget.titleIconData, 'Class'),
        floatingActionButton: ValueListenableBuilder(
            valueListenable: courseLength,
            child: Container(),
            builder: (BuildContext context, dynamic value, Widget? child) {
              return courseLength.value > 0
                  ? saveAndShareFAB(
                      context,
                    )
                  : Container();
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        body: body(),
      )
    ]);
  }

  Widget body() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SpacerWidget(_KVerticalSpace / 4),
          Screenshot(
            controller: headerScreenshotController,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              // minLeadingWidth: 70,
              title: Utility.textWidget(
                text: 'All Courses',
                context: context,
                textTheme: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                onPressed: () {
                  pushNewScreen(context,
                      screen: HomePage(
                        index: 4,
                      ),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino);
                },
                icon: Icon(
                  IconData(0xe80d,
                      fontFamily: Overrides.kFontFam,
                      fontPackage: Overrides.kFontPkg),
                  color: AppTheme.kButtonColor,
                ),
              ),
            ),
          ),
          // SpacerWidget(_KVertcalSpace / 3),
          SpacerWidget(_KVerticalSpace / 5),
          Expanded(
            child: BlocConsumer(
                bloc: pbisPlusClassroomBloc,
                builder: (context, state) {
                  if (state is PBISPlusLoading) {
                    return Container(
                        alignment: Alignment.center,
                        child: Container(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: AppTheme.kButtonColor,
                            )));
                  }
                  if (state is PBISPlusImportRosterSuccess) {
                    if (state.googleClassroomCourseList.isNotEmpty ?? false) {
                      return buildList(state.googleClassroomCourseList);
                    } else {
                      return noClassroomFound();
                    }
                  }

                  return noClassroomFound();
                },
                listener: (context, state) async {
                  if (state is PBISPlusImportRosterSuccess) {
                    if (state.googleClassroomCourseList.isNotEmpty ?? false) {
                      //To manage FAB
                      courseLength.value =
                          state.googleClassroomCourseList.length;

                      ///Used to send the list of courseWork to the bottomsheet list
                      /*----------------------START--------------------------*/
                      googleClassroomCourseworkList.clear();
                      googleClassroomCourseworkList
                          .add(ClassroomCourse(name: 'All'));
                      googleClassroomCourseworkList
                          .addAll(state.googleClassroomCourseList);

                      /*----------------------END--------------------------*/

                    }
                  }
                  if (state is PBISErrorState) {
                    if (state.error == 'ReAuthentication is required') {
                      await Utility.refreshAuthenticationToken(
                          isNavigator: true,
                          errorMsg: state.error!,
                          context: context,
                          scaffoldKey: _scaffoldKey);

                      pbisPlusClassroomBloc.add(PBISPlusImportRoster());
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

  ListView buildList(List<ClassroomCourse> googleClassroomCourseList) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        Container(
            margin: EdgeInsets.all(10.0),
            height: 30,
            child: Container(
              child: ListView.builder(
                controller: null,
                itemBuilder: (BuildContext context, int index) {
                  return chipBuilder(googleClassroomCourseList, context, index);
                },
                itemCount: googleClassroomCourseList.length,
                scrollDirection: Axis.horizontal,
              ),
            )),
        studentListCourseWiseView(googleClassroomCourseList)
      ],
    );
  }

  Widget chipBuilder(
    List<ClassroomCourse> courseList,
    context,
    currentIndex,
  ) {
    return ValueListenableBuilder(
        valueListenable: selectedValue,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return GestureDetector(
            onTap: () {
              selectedValue.value = currentIndex;
              _animateToIndex(
                currentIndex,
                courseList[currentIndex].students!.length,
              );

              FirebaseAnalyticsService.addCustomAnalyticsEvent(
                  'Course chip tap PBIS+'.toLowerCase().replaceAll(" ", "_"));
            },
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
                    color: selectedValue.value == currentIndex
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

  Widget studentListCourseWiseView(googleClassroomCourseList) {
    return RefreshIndicator(
        key: refreshKey,
        onRefresh: refreshPage,
        child: Container(
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.60 //7
                : MediaQuery.of(context).size.height * 0.45,
            child: SingleChildScrollView(
              // SingleChildScrollView to take whole screen screenshot
              child: Screenshot(
                controller: screenshotController,
                child: ScrollablePositionedList.builder(
                    padding: EdgeInsets.only(bottom: 30),
                    shrinkWrap: true,
                    itemScrollController: _itemScrollController,
                    itemCount: googleClassroomCourseList.length,
                    itemBuilder: (context, index) {
                      return _buildCourseSeparationList(
                          googleClassroomCourseList, index);
                    }),
              ),
            )));
  }

  Widget _buildCourseSeparationList(
      List<ClassroomCourse> googleClassroomCourseList, index) {
    return
        // courseListlist[index].studentList!.length > 0
        //     ?
        Column(children: [
      // Container(
      //   // color: Theme.of(context).colorScheme.secondary,
      //   height: 6,
      // ),
      Container(
        key: ValueKey(googleClassroomCourseList[index]),
        color: Theme.of(context).colorScheme.secondary,
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
      googleClassroomCourseList[index].students!.length > 0
          ? renderStudents(
              googleClassroomCourseList[index].students!,
              googleClassroomCourseList[index].name!,
              index,
              googleClassroomCourseList[index].id!)
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

  renderStudents(List<ClassroomStudents> studentList, String cLassName, i,
      String classroomCourseId) {
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
              cLassName,
              classroomCourseId);
        }));
  }

  Widget _buildStudent(ValueNotifier<ClassroomStudents> studentValueNotifier,
      int index, String cLassName, String classroomCourseId) {
    String heroTag = "HeroTag_${cLassName}_${index}";

    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          HeroDialogRoute(
            builder: (context) => Center(
              child: PBISPlusStudentCardModal(
                //count: index,
                // imageUrl: imageUrl,
                onValueUpdate: (updatedStudentValueNotifier) {
                  studentValueNotifier = updatedStudentValueNotifier;
                },
                studentValueNotifier: studentValueNotifier,
                heroTag: heroTag,
                classroomCourseId: classroomCourseId,
                scaffoldKey: _scaffoldKey,
              ),
            ),
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
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                alignment: Alignment.center,
                margin: EdgeInsets.all(3),
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
                child: Column(
                  //  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PBISCommonProfileWidget(
                        studentValueNotifier: studentValueNotifier,
                        profilePictureSize: profilePictureSize,
                        imageUrl:
                            studentValueNotifier.value!.profile!.photoUrl!),
                    // SizedBox(height: 15),
                    Column(
                      children: [
                        Utility.textWidget(
                          maxLines: 1,
                          text: studentValueNotifier
                              .value.profile!.name!.givenName!,
                          context: context,
                          textTheme: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 1),
                        Utility.textWidget(
                          maxLines: 2,
                          text: studentValueNotifier
                              .value.profile!.name!.familyName!,
                          context: context,
                          textTheme: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppTheme.kButtonColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: ValueListenableBuilder<ClassroomStudents>(
                            valueListenable: studentValueNotifier,
                            builder: (BuildContext context,
                                ClassroomStudents value, Widget? child) {
                              return Text(
                                PBISPlusUtility.numberAbbreviationFormat(
                                    studentValueNotifier
                                            .value!.profile!.engaged! +
                                        studentValueNotifier
                                            .value!.profile!.niceWork! +
                                        studentValueNotifier
                                            .value!.profile!.helpful!),
                                style: TextStyle(
                                  color: Theme.of(context).backgroundColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            })),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget saveAndShareFAB(
    BuildContext context,
  ) =>
      PBISPlusCustomFloatingActionButton(
        onPressed: () {
          /*-------------------------User Activity Track START----------------------------*/
          Utility.updateLogs(
              activityType: 'PBIS+',
              activityId: '36',
              description: 'Save and Share button open from All Courses',
              operationResult: 'Success');

          FirebaseAnalyticsService.addCustomAnalyticsEvent(
              'save and share from class screen PBIS+'
                  .toLowerCase()
                  .replaceAll(" ", "_"));
          /*-------------------------User Activity Track END----------------------------*/

          _saveAndShareBottomSheetMenu();
        },
      );

  void _saveAndShareBottomSheetMenu() => showModalBottomSheet(
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
            print(constraints.maxHeight);
            return PBISPlusBottomSheet(
              isClassPage: true,
              screenshotController: screenshotController,
              headerScreenshotController: headerScreenshotController,
              constraintDeviceHeight: constraints.maxHeight,
              scaffoldKey: _scaffoldKey,
              googleClassroomCourseworkList: googleClassroomCourseworkList,
              padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
              height: constraints.maxHeight < 800
                  ? MediaQuery.of(context).size.height * 0.5
                  : MediaQuery.of(context).size.height * 0.43,
              title: 'Save and Share',
            );
          },
        );
      });

  Widget noClassroomFound() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
    );
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    pbisPlusClassroomBloc.add(PBISPlusImportRoster());

    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        'Sync Google Classroom Course List PBIS+'
            .toLowerCase()
            .replaceAll(" ", "_"));
  }
}
