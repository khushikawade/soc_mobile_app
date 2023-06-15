// ignore_for_file: must_be_immutable

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_behaviour_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_student_dashbord.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/common_cached_network_image.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/custom_rect_tween.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/hero_dialog_route.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_appbar.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_edit_skills_bottom_sheet.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_student_profile_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../widgets/PBISPlus_action_interaction_button.dart';

class PBISPlusEditSkills extends StatefulWidget {
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

  // ValueNotifier<ClassroomStudents> studentValueNotifier;
  // final bool? isFromDashboardPage;
  // final bool?
  //     isFromStudentPlus; // to check it is from pbis plus or student plus
  // final bool? isLoading; // to maintain loading when user came from student plus
  // final String heroTag;
  // final Key? scaffoldKey;
  // String classroomCourseId;
  final double? constraint;

  @override
  State<PBISPlusEditSkills> createState() => _PBISPlusEditSkillsState();
}

class _PBISPlusEditSkillsState extends State<PBISPlusEditSkills> {
  ValueNotifier<int> changedIndex = ValueNotifier<int>(-1);
  ValueNotifier<bool> isEditMode = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueChange = ValueNotifier<bool>(false);
  PBISPlusBloc pbisPlusClassroomBloc = PBISPlusBloc();

  //For now dynamic type we changes

  List<PBISPlusActionInteractionModalNew> currentBehaviourList =
      PBISPlusActionInteractionModalNew.PBISPlusActionInteractionIconsNew.map(
          (item) {
    return item;
  }).toList();

  ValueNotifier<List<PBISPlusActionInteractionModalNew>> containerIcons =
      ValueNotifier<List<PBISPlusActionInteractionModalNew>>([
    PBISPlusActionInteractionModalNew.PBISPlusActionInteractionIconsNew[0],
    PBISPlusActionInteractionModalNew.PBISPlusActionInteractionIconsNew[1],
    PBISPlusActionInteractionModalNew.PBISPlusActionInteractionIconsNew[2],
    PBISPlusActionInteractionModalNew.PBISPlusActionInteractionIconsNew[3],
    PBISPlusActionInteractionModalNew.PBISPlusActionInteractionIconsNew[4],
    PBISPlusActionInteractionModalNew(
      imagePath: "assets/Pbis_plus/add_icon.svg",
      title: 'Add Skill',
      color: Colors.red,
    ),
  ]);
  int? selectedIconIndex = -1;

  // void removeItems(String removedtitle) {
  //   containerIcons.value.removeWhere((item) => item.title == removedtitle);
  // }

  void replaceItems(String removedtitle) {
    int index =
        containerIcons.value.indexWhere((item) => item.title == removedtitle);
    if (index != -1) {
      containerIcons.value[index] = PBISPlusActionInteractionModalNew(
        imagePath: "assets/Pbis_plus/add_icon.svg",
        title: 'Add Skill',
        color: Colors.red,
      );
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // List<IconData> containerIcons = [];
  @override
  void initState() {
    super.initState();
    // trackUserActivity();
    pbisPlusClassroomBloc.add(GetPBISPlusBehaviour());
    // widget.studentValueNotifier.value = widget.student!;
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
              size: Globals.deviceType == 'phone' ? 24 : 32,
              color: AppTheme.kButtonColor),
        ),
        SpacerWidget(18),
        _buildHeader(),
        SpacerWidget(18),
        _buildAdditionalBehaviour(),
        SpacerWidget(48),
      ],
    );
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

  Widget _buildHeader() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05),
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.height * 0.80,
            decoration: BoxDecoration(
              color: AppTheme.kButtonColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8.0),
                topLeft: Radius.circular(8.0),
              ),
            ),
            padding: EdgeInsets.all(16),
            child: Text(
              "Edit Skills",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                  color: Color(0xff000000) == Theme.of(context).backgroundColor
                      ? Color(0xffFFFFFF)
                      : Color(0xff000000),
                  fontWeight: FontWeight.bold),
            ),
          ),
          SpacerWidget(18),
          BlocConsumer(
              bloc: pbisPlusClassroomBloc,
              builder: (context, state) {
                if (state is PBISPlusClassRoomShimmerLoading) {
                  return _buildEditSkillCards();
                  //  Container(
                  //     alignment: Alignment.center,
                  //     child: CircularProgressIndicator.adaptive(
                  //       backgroundColor: AppTheme.kButtonColor,
                  //     ));
                } else if (state is PBISPlusBehaviourSucess) {
                  if (state.behaviourList.isNotEmpty ?? false) {
                    return _buildEditSkillCards();
                  } else {
                    return _buildEditSkillCards();
                  }
                } else if (state is PBISErrorState)
                  return _buildEditSkillCards();
                return _buildEditSkillCards();
              },
              listener: (context, state) async {}
              //_buildEditSkillCards()
              )
        ],
      ),
    );
  }

  Widget _buildnoDataFound() {
    return Center(child: Text("No data Found"));
  }

  Widget _buildEditSkillCards() {
    return Container(
        // color: Colors.yellow,
        child: DragTarget<PBISPlusActionInteractionModalNew>(
            builder: (context, candidateData, rejectedData) {
      return GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio:
              1.5, // Adjust this value to change item aspect ratio
          crossAxisSpacing:
              4.0, // Adjust the spacing between items horizontally
          mainAxisSpacing: 4.0, // Adjust the spacing between items vertically
        ),
        itemCount: (PBISPlusActionInteractionModalNew
            .PBISPlusActionInteractionIconsNew.length),
        itemBuilder: (BuildContext context, int index) {
          final item = containerIcons.value[index];
          selectedIconIndex = index;
          return GestureDetector(
              onTap: () {
                isEditMode.value = true;
                changedIndex.value = index;
              },
              child: ValueListenableBuilder(
                  valueListenable: changedIndex,
                  builder: (context, value, _) => ValueListenableBuilder(
                        valueListenable: isEditMode,
                        builder: (context, value, _) =>
                            index == changedIndex.value
                                ? _buildEditWidget(item)
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Draggable(
                                        data: item,
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          child: SvgPicture.asset(
                                            item.imagePath,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        feedback: Container(
                                          height: 40,
                                          width: 40,
                                          child: SvgPicture.asset(
                                            item.imagePath,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        childWhenDragging: Container(
                                          height: 40,
                                          width: 40,
                                          child: SvgPicture.asset(
                                            item.imagePath,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      SpacerWidget(4),
                                      Padding(
                                        padding: Globals.deviceType != 'phone'
                                            ? const EdgeInsets.only(
                                                top: 10, left: 10)
                                            : EdgeInsets.zero,
                                        child: Utility.textWidget(
                                            text: item.title,
                                            context: context,
                                            textTheme: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(fontSize: 12)),
                                      )
                                    ],
                                  ),
                      )));
        },
      );
    }, onWillAccept: (PBISPlusActionInteractionModalNew? iconData) {
      // print("--------on will accept------");
      // print(iconData?.title);
      // print("--------on will accept------");
      return true;
    }, onAccept: (PBISPlusActionInteractionModalNew? iconData) {
      // print("inisde the on  acccept");
      //ADD SET STATE OR VALUE LISTNER
      // if (containerIcons.value.length < 3) {

      //   containerIcons.value.add(iconData!);
      // } else {
      //   containerIcons.value[selectedIconIndex!] = iconData!;
      // }
      print(iconData?.title);
      if (containerIcons.value.contains(iconData)) {
      } else {
        containerIcons.value[selectedIconIndex!] = iconData!;
        changedIndex.value = -1;
      }
      setState(() {});
    }, onAcceptWithDetails:
                (DragTargetDetails<PBISPlusActionInteractionModalNew> details) {
      final item = details.data;
      // final hoveredIndex = details.index;

      // Use the hoveredIndex and item as needed
      // ...

      print("Hovered Index: $item");
      print("Item Title: ${item?.title}");

      // print(
      //     "------onAcceptWithDetails-----------0N ACCEPT WITH DETAILS-------------");
      // print(details.data.color);
    }, onMove: (details) {
      // print("------onMove-----------details-------------");
      // print(details.data.title);
    }, onLeave: (PBISPlusActionInteractionModalNew? iconData) {
      print("INSIDE THE ON LEAVE ");
    }));
  }

  Widget _buildEditWidget(PBISPlusActionInteractionModalNew item) {
    return GestureDetector(
      onTap: () async {
        await _modalBottomSheetMenu(item);
        changedIndex.value = -1;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
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
              size: Globals.deviceType == 'phone' ? 24 : 32,
              color: AppTheme.klistTileSecoandryDark,
            ),
          ),
          SpacerWidget(16),
        ],
      ),
    );
  }

  Widget _buildAdditionalBehaviour() {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05),
        color: Theme.of(context).backgroundColor,
        child: Column(
          // physics: NeverScrollableScrollPhysics(),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16),
              child: Text(
                "Additional Behaviors",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1!.copyWith(),
              ),
            ),
            SpacerWidget(16),
            BlocConsumer(
                bloc: pbisPlusClassroomBloc,
                builder: (context, state) {
                  print(state);
                  if (state is PBISPlusClassRoomShimmerLoading ||
                      state is PBISPlusInitial) {
                    return _buildAdditionalBehaviourCard(
                        behaviourList: [], isShimmer: true);
                  } else if (state is PBISPlusBehaviourSucess) {
                    if (state.behaviourList.isNotEmpty) {
                      return _buildAdditionalBehaviourCard(
                          behaviourList: state.behaviourList, isShimmer: false);
                    } else {
                      return _buildnoDataFound();
                    }
                  } else if (state is PBISErrorState)
                    return _buildnoDataFound();
                  return _buildnoDataFound();
                },
                listener: (context, state) async {}),
            SpacerWidget(18),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalBehaviourCard(
      {List<PbisPlusBehaviourList>? behaviourList, bool? isShimmer}) {
    return Expanded(
      child: ValueListenableBuilder(
          valueListenable: containerIcons,
          builder: (context, value, _) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio:
                        0.9, // Adjust this value to change item aspect ratio
                    crossAxisSpacing:
                        0.0, // Adjust the spacing between items horizontally
                    mainAxisSpacing:
                        4.0, // Adjust the spacing between items vertically
                  ),
                  itemCount: isShimmer!
                      ? 3 *
                          PBISPlusAdditionalBehaviourModal
                              .PBISPlusAdditionalBehaviourModalIcons.length
                              .ceil()
                      : behaviourList!.length.ceil(),
                  itemBuilder: (BuildContext context, int index) {
                    final item = isShimmer
                        ? PBISPlusAdditionalBehaviourModal
                            .PBISPlusAdditionalBehaviourModalIcons[index % 6]
                        : behaviourList![index];
                    final isIconDisabled = isShimmer ? false : false;
                    return isShimmer
                        ? _buildShimmer()
                        : isIconDisabled
                            ? _buildNonDraggbleIcon(item, isIconDisabled)
                            : _buildEditSkillIcon(item, isIconDisabled);
                  },
                ),
              )),
    );
  }

  Widget _buildShimmer() {
    return ShimmerLoading(
      isLoading: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
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
              size: Globals.deviceType == 'phone' ? 24 : 32,
              color: Colors.transparent,
            ),
          ),
          SpacerWidget(16),
        ],
      ),
    );
  }

  Widget _buildNonDraggbleIcon(item, isIconDisabled) {
    return Container(
      width: 40,
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 1,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Center(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Opacity(
                opacity: 0.2,
                child: CommonCachedNetworkImage(
                  imagePath: item.iconUrlC,
                ))),
      ),
    );
  }

  Widget _buildEditSkillIcon(item, isIconDisabled) {
    return Draggable(
        data: item,
        ignoringFeedbackPointer: !isIconDisabled,
        child: Container(
          width: 40,
          height: 40,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 0,
                blurRadius: 1,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Center(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CommonCachedNetworkImage(
                  imagePath: item.iconUrlC,
                )),
          ),
        ),
        feedback: isIconDisabled
            ? SizedBox.shrink()
            : CommonCachedNetworkImage(
                imagePath: item.iconUrlC,
              ),
        childWhenDragging: isIconDisabled
            ? SizedBox.shrink()
            : CommonCachedNetworkImage(
                imagePath: item.iconUrlC,
              ));
  }

  _modalBottomSheetMenu(PBISPlusActionInteractionModalNew item) =>
      showModalBottomSheet(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        elevation: 10,
        context: context,
        builder: (BuildContext context) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return PBISPlusEditSkillsBottomSheet(
                containerIcons: containerIcons,
                item: item,
                constraints: constraints,
                // fromClassScreen: false,
                // scaffoldKey: _scaffoldKey,
                // screenshotController: screenshotController,
                // headerScreenshotController: headerScreenshotController,
                // googleClassroomCourseworkList: [], //No list is required since no list is used from this bottomsheet
                // content: false,
                height:
                    // constraintsp < 750 && Globals.deviceType == "phone"
                    //     ? MediaQuery.of(context).size.height * 0. //0.45
                    //     : Globals.deviceType == "phone"
                    //         ? MediaQuery.of(context).size.height * 0.19 //0.45
                    //         : MediaQuery.of(context).size.height * 0.15,
                    MediaQuery.of(context).size.height * 0.3,
                // title: '',
                // padding: EdgeInsets.fromLTRB(30, 10, 10, 10),
              );
            },
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CommonBackgroundImgWidget(),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PBISPlusAppBar(
          title: "",
          backButton: true,
          scaffoldKey: _scaffoldKey,
        ),
        body: body(context),
      )
    ]);
  }
}
