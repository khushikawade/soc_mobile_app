// ignore_for_file: deprecated_member_use

import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/course_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_student_modal_card.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/custom_rect_tween.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/hero_dialog_route.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_appbar.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_background_img.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_bottom_sheet.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_fab.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_student_profile_widget.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class PBISPlusClass extends StatefulWidget {
  final IconData titleIconData;
  PBISPlusClass({Key? key, required this.titleIconData}) : super(key: key);

  @override
  State<PBISPlusClass> createState() => _PBISPlusClassState();
}

class _PBISPlusClassState extends State<PBISPlusClass> {
  PBISPlusBloc PBISPlusBlocInstance = PBISPlusBloc();
  final ValueNotifier<int> selectedValue = ValueNotifier<int>(0);
  final ItemScrollController _itemScrollController = ItemScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final double profilePictureSize = 30;
  static const double _KVertcalSpace = 60.0;

  @override
  void initState() {
    super.initState();
    PBISPlusBlocInstance.add(PBISPlusImportRoster());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CommonBackgroundImgWidget(),
      Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar: PBISPlusUtility.pbisAppBar(context, widget.titleIconData),
        floatingActionButton: saveAndShareFAB(
          context,
        ),
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
          SpacerWidget(_KVertcalSpace / 4),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Utility.textWidget(
              text: 'All Courses',
              context: context,
              textTheme: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SpacerWidget(_KVertcalSpace / 3),
          SpacerWidget(_KVertcalSpace / 5),
          Expanded(
              child: RefreshIndicator(
                  color: AppTheme.kButtonColor,
                  key: refreshKey,
                  onRefresh: () => refreshPage(isFromPullToRefresh: true),
                  child: BlocConsumer(
                      bloc: PBISPlusBlocInstance,
                      builder: (context, state) {
                        if (state is PBISPlusLoading) {
                          return Container(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryVariant,
                              ));
                        }
                        if (state is PBISPlusImportRosterSuccess &&
                            (state.googleClassroomCourseList.isNotEmpty ??
                                false)) {
                          return buildList(state.googleClassroomCourseList);
                        }

                        return NoDataFoundErrorWidget(
                            isResultNotFoundMsg: true,
                            isNews: false,
                            isEvents: false);
                      },
                      listener: (context, state) {}))),
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
    return Container(
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height * 0.70
            : MediaQuery.of(context).size.height * 0.45,
        child: ScrollablePositionedList.builder(
            padding: EdgeInsets.only(bottom: 30),
            shrinkWrap: true,
            itemScrollController: _itemScrollController,
            itemCount: googleClassroomCourseList.length,
            itemBuilder: (context, index) {
              return _buildCourseSeparationList(
                  googleClassroomCourseList, index);
            }));
  }

  Widget _buildCourseSeparationList(
      List<ClassroomCourse> googleClassroomCourseList, index) {
    return
        // courseListlist[index].studentList!.length > 0
        //     ?
        Column(children: [
      Container(
        // color: Theme.of(context).colorScheme.secondary,
        height: 6,
      ),
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
          ? renderStudents(googleClassroomCourseList[index].students!,
              googleClassroomCourseList[index].name!, index)
          : Container(
              height: 65,
              padding: EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              color:
                  Theme.of(context).colorScheme.background == Color(0xff000000)
                      ? Color(0xff162429)
                      : Color(0xffF7F8F9),
              child: Text('No student found'),
            )
    ]);
  }

  renderStudents(List<ClassroomStudents> studentList, String cLassName, i) {
    // return GridView.custom(
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 4,
    //     mainAxisSpacing: 10,
    //     crossAxisSpacing: 10,
    //     childAspectRatio: 1.0,
    //   ),
    //   childrenDelegate: SliverChildBuilderDelegate(
    //     (BuildContext context, int index) {
    //       return _buildStudent(
    //         ValueNotifier<Students>(studentList[index]),
    //         index,
    //         cLassName,
    //       );
    //     },
    //     childCount: studentList.length, // Set the number of items in the grid
    //   ),
    // );
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
          );
        }));
  }

  Widget _buildStudent(
    ValueNotifier<ClassroomStudents> studentValueNotifier,
    int index,
    String cLassName,
  ) {
    // String imageNum = generateRandomUniqueNumber().toString();
    // studentValueNotifier.value.profile!.photoUrl =
    //     'https://source.unsplash.com/random/200x200?sig=$imageNum';
    String heroTag = "HeroTag_${cLassName}_${index}";

    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          HeroDialogRoute(
            builder: (context) => Center(
              child: PBISPlusStudentCardModal(
                //count: index,
                // imageUrl: imageUrl,
                studentValueNotifier: studentValueNotifier,
                heroTag: heroTag,
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
                    CommonProfileWidget(
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
                        SizedBox(height: 2),
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
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: AppTheme.kButtonColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        PBISPlusUtility.numberAbbreviationFormat(
                            studentValueNotifier.value!.profile!.like! +
                                studentValueNotifier.value!.profile!.thanks! +
                                studentValueNotifier.value!.profile!.helpful!),
                        style: TextStyle(
                          color: Theme.of(context).backgroundColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
          _saveAndShareBottomSheetMenu();
        },
      );

  void _saveAndShareBottomSheetMenu() => showModalBottomSheet(
        clipBehavior: Clip.antiAliasWithSaveLayer, useRootNavigator: true,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        // animationCurve: Curves.easeOutQuart,
        elevation: 10,
        context: context,
        builder: (BuildContext context) {
          return PBISPlusBottomSheet(
            padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
            height: 250,
            title: 'Save and Share',
          );
        },
      );

  Future refreshPage(
      {required bool isFromPullToRefresh, int? delayInSeconds}) async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(
        Duration(seconds: delayInSeconds == null ? 2 : delayInSeconds));
    if (isFromPullToRefresh == true) {
      PBISPlusBlocInstance.add(PBISPlusImportRoster());
    }
  }
}
