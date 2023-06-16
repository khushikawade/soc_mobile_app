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
  PBISPlusEditSkills({
    Key? key,
    this.constraint,
  }) : super(key: key) {}

  final double? constraint;

  @override
  State<PBISPlusEditSkills> createState() => _PBISPlusEditSkillsState();
}

class _PBISPlusEditSkillsState extends State<PBISPlusEditSkills> {
  ValueNotifier<int> hoveredIconIndex = ValueNotifier<int>(-1);

  ValueNotifier<int> changedIndex = ValueNotifier<int>(-1);
  ValueNotifier<bool> isEditMode = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueChange = ValueNotifier<bool>(false);
  PBISPlusBloc pbisPlusClassroomBloc = PBISPlusBloc();
  static final addSkill = PBISPlusActionInteractionModalNew(
    imagePath: "assets/Pbis_plus/add_icon.svg",
    title: 'Add Skill',
    color: Colors.red,
  );
  ValueNotifier<List<PBISPlusActionInteractionModalNew>> containerIcons =
      ValueNotifier<List<PBISPlusActionInteractionModalNew>>([
    PBISPlusActionInteractionModalNew.PBISPlusActionInteractionIconsNew[0],
    PBISPlusActionInteractionModalNew.PBISPlusActionInteractionIconsNew[1],
    addSkill,
    addSkill,
    addSkill,
    addSkill
  ]);
  int nonAddSkillCount = -1;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    pbisPlusClassroomBloc.add(GetPBISPlusBehaviour());
    // widget.studentValueNotifier.value = widget.student!;
  }

  getcount() {
    nonAddSkillCount =
        containerIcons.value.where((item) => item.title != "Add Skill").length;
    return nonAddSkillCount;
  }

  bool isItemExist(data) {
    if (containerIcons.value.isNotEmpty) {
      final result =
          containerIcons.value.where((item) => item.title == data.title);
      return result.isNotEmpty;
    }
    return false;
  }

  Widget body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpacerWidget(18),
        _buildbackIcon(),
        _buildHeader(),
        SpacerWidget(18),
        _buildAdditionalBehaviour(),
        SpacerWidget(48),
      ],
    );
  }

  Widget _buildbackIcon() {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
          IconData(0xe80d,
              fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
          size: Globals.deviceType == 'phone' ? 24 : 32,
          color: AppTheme.kButtonColor),
    );
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
          DragTarget<PBISPlusActionInteractionModalNew>(
            builder: (context, candidateData, rejectedData) {
              return GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  final item = containerIcons.value[index];
                  return DragTarget<PBISPlusActionInteractionModalNew>(
                      onWillAccept: (draggedData) {
                    hoveredIconIndex.value =
                        index; // Update the hovered icon index
                    print(hoveredIconIndex);
                    return true;
                  }, onAccept: (draggedData) {
                    print(isItemExist(draggedData));
                    if (isItemExist(draggedData) == false) {
                      int count;
                      count = getcount();
                      if (count < 6) {
                        if (hoveredIconIndex.value < count) {
                          containerIcons.value[hoveredIconIndex.value] =
                              draggedData;
                        } else {
                          containerIcons.value[count] = draggedData;
                        }
                      } else {
                        containerIcons.value[hoveredIconIndex.value] =
                            draggedData; // Change the hovered icon
                      }

                      hoveredIconIndex.value = -1;
                      changedIndex.value = -1;
                    }
                    setState(() {});
                  }, builder: (context, candidateData, rejectedData) {
                    return GestureDetector(
                        onTap: () {
                          if (containerIcons.value[index].title !=
                              "Add Skill") {
                            isEditMode.value = true;
                            changedIndex.value = index;
                          }
                        },
                        child: ValueListenableBuilder(
                            valueListenable: changedIndex,
                            builder: (context, value, _) =>
                                ValueListenableBuilder(
                                  valueListenable: isEditMode,
                                  builder: (context, value, _) => index ==
                                          changedIndex.value
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
                                              padding:
                                                  Globals.deviceType != 'phone'
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
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildaddSkillsWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 40,
          width: 40,
          child: SvgPicture.asset(
            "assets/Pbis_plus/add_icon.svg",
            fit: BoxFit.contain,
          ),
        ),
        SpacerWidget(4),
        Padding(
          padding: Globals.deviceType != 'phone'
              ? const EdgeInsets.only(top: 10, left: 10)
              : EdgeInsets.zero,
          child: Utility.textWidget(
              text: "Add Skills",
              context: context,
              textTheme: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontSize: 12)),
        )
      ],
    );
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
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: containerIcons,
                  builder: (context, value, _) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio:
                                0.9, // Adjust this value to change item aspect ratio
                            crossAxisSpacing:
                                0.0, // Adjust the spacing between items horizontally
                            mainAxisSpacing:
                                4.0, // Adjust the spacing between items vertically
                          ),
                          itemCount: 3 *
                              PBISPlusAdditionalBehaviourModal
                                  .PBISPlusAdditionalBehaviourModalIcons.length
                                  .ceil(),
                          itemBuilder: (BuildContext context, int index) {
                            final item = PBISPlusActionInteractionModalNew
                                .PBISPlusActionInteractionIconsNew[index % 9];
                            final isIconDisabled =
                                containerIcons.value.contains(item);
                            return isIconDisabled
                                ? _buildNonDraggbleIcon(item, isIconDisabled)
                                : _buildEditSkillIcon(item, isIconDisabled);
                          },
                        ),
                      )),
            ),
            SpacerWidget(18),
          ],
        ),
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
                child: SvgPicture.asset(
                  item.imagePath,
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
            child: isIconDisabled
                ? Opacity(
                    opacity: 0.2,
                    child: SvgPicture.asset(
                      item.imagePath,
                    ))
                : SvgPicture.asset(
                    item.imagePath,
                  ),
          ),
        ),
      ),
      feedback: isIconDisabled
          ? SizedBox.shrink()
          : SvgPicture.asset(
              item.imagePath,
            ),
      childWhenDragging: isIconDisabled
          ? SizedBox.shrink()
          : SvgPicture.asset(
              item.imagePath,
            ),
    );
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
                constraints: constraints,
                containerIcons: containerIcons,
                item: item,
                height:
                    // constraints.maxHeight < 750 && Globals.deviceType == "phone"
                    //     ? MediaQuery.of(context).size.height * 0. //0.45
                    //     : Globals.deviceType == "phone"
                    //         ? MediaQuery.of(context).size.height * 0.19 //0.45
                    //         : MediaQuery.of(context).size.height * 0.15,
                    MediaQuery.of(context).size.height * 0.3,
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
