// ignore_for_file: must_be_immutable

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_skill_list_modal.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_appbar.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_edit_skills_bottom_sheet.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

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
  ValueNotifier<bool> toogle = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueChange = ValueNotifier<bool>(false);
  bool tooglevalue = false;
  PBISPlusBloc pbisPlusClassroomBloc = PBISPlusBloc();
  static final addSkill = PBISPlusSkills(
    id: "5",
    activeStatusC: "Show",
    iconUrlC: "assets/Pbis_plus/add_icon.svg",
    name: 'Add Skill',
    sortOrderC: "5",
    counter: 0,
  );

  ValueNotifier<List<PBISPlusSkills>> containerIcons =
      ValueNotifier<List<PBISPlusSkills>>([
    PBISPlusSkillsModalLocal.PBISPlusSkillLocalModallist[0],
    PBISPlusSkillsModalLocal.PBISPlusSkillLocalModallist[1],
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
    // pbisPlusClassroomBloc.add(GetPBISPlusBehaviour());
    pbisPlusClassroomBloc.add(GetPBISSkills());
  }

  ValueNotifier<List<PBISPlusSkills>> localskillsList =
      ValueNotifier<List<PBISPlusSkills>>([]);

  // getcount() {
  //   nonAddSkillCount = 0;
  //   containerIcons.value.where((item) => item.name != "Add Skill").length;
  //   return nonAddSkillCount;
  // }

  // bool isItemExist(data) {
  //   if (containerIcons.value.isNotEmpty) {
  //     final result =
  //         containerIcons.value.where((item) => item.name == data.name);
  //     return result.isNotEmpty;
  //   }
  //   return false;
  // }

  Widget body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpacerWidget(18),
        _buildIconBar(),
        _buildHeader(),
        SpacerWidget(18),
        _buildAdditionalBehaviour(),
        SpacerWidget(48),
      ],
    );
  }

  Widget _buildToogleButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ValueListenableBuilder(
          valueListenable: toogle,
          builder: (context, value, _) => Transform.scale(
                transformHitTests: false,
                scale: 0.8, // Adjust the scale factor as needed
                child: CupertinoSwitch(
                  value: toogle.value,
                  onChanged: (value) {
                    toogle.value = value;
                  },
                  trackColor:
                      Color(0xff000000) == Theme.of(context).backgroundColor
                          ? AppTheme.klistTilePrimaryLight.withOpacity(0.1)
                          : Color(0xff000000).withOpacity(0.5),
                  thumbColor: toogle.value
                      ? AppTheme.GreenColor
                      : AppTheme.klistTilePrimaryLight,
                  activeColor:
                      Color(0xff000000) == Theme.of(context).backgroundColor
                          ? Color(0xff000000).withOpacity(0.8)
                          : Color(0xff000000).withOpacity(0.1),
                ),
              )),
    );
  }

  Widget _buildIconBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildbackIcon(), _buildToogleButton()],
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
    return ValueListenableBuilder(
        valueListenable: toogle,
        builder: (context, value, _) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              color: Theme.of(context).backgroundColor,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // changedIndex.value = -1;
                    },
                    child: Container(
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
                        toogle.value ? "Edit Behaviour" : "Default Behaviour",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Color(0xff000000) ==
                                    Theme.of(context).backgroundColor
                                ? Color(0xffFFFFFF)
                                : Color(0xff000000),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SpacerWidget(18),
                  BlocConsumer<PBISPlusBloc, PBISPlusState>(
                      bloc: pbisPlusClassroomBloc,
                      builder: (context, state) {
                        print(state);
                        if (state is PBISPlusSkillsLoading ||
                            state is PBISPlusSkillsUpdateLoading) {
                          return _buildEditItemList(
                              PBISPlusSkillsModalLocal
                                  .PBISPlusSkillLocalBehaviourlist,
                              false);
                        } else if (state is PBISPlusSkillsSucess) {
                          localskillsList.value = state.skillsList;
                          if (state.skillsList.isNotEmpty) {
                            return _buildEditItemList(state.skillsList, false);
                          } else {
                            return _noDataFoundWidget();
                          }
                        } else if (state is PBISErrorState)
                          return _noDataFoundWidget();
                        return _noDataFoundWidget();
                      },
                      listener: (context, state) async {}
                      //_buildEditSkillCards()
                      ),
                  // _buildEditItemList(containerIcons),
                ],
              ),
            ));
  }

  Widget _noDataFoundWidget() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Text("No Skills Found"),
      ),
    );
  }

  Widget _buildEditItemList(List<PBISPlusSkills> skillsList, bool loading) {
    return DragTarget<PBISPlusSkills>(
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
          // itemCount: 6,
          itemCount: skillsList.length,
          //  skillsList.length,
          itemBuilder: (BuildContext context, int index) {
            // final item = containerIcons.value[index];
            final item = skillsList[index];
            return DragTarget<PBISPlusSkills>(
                onWillAccept: (draggedData) {
                  print(
                      "-----------------INSIDE ON  onWillAccep---------------------------");
                  hoveredIconIndex.value =
                      index; // Update the hovered icon index
                  print(hoveredIconIndex);
                  return true;
                },
                onLeave: ((data) => print(
                    "-----------------INSIDE ON LEAVE---------------------------")),
                onAccept: (draggedData) {
                  print(
                      "-----------------INSIDE ON onAccept---------------------------");
                  pbisPlusClassroomBloc.add(GetPBISSkillsUpdateList(
                      index: hoveredIconIndex.value, item: draggedData));
                  // print(isItemExist(draggedData));
                  // if (isItemExist(draggedData) == false) {
                  //   int count;
                  //   count = getcount();
                  //   if (count < 6) {
                  //     if (hoveredIconIndex.value < count) {
                  //       pbisPlusClassroomBloc.add(GetPBISSkillsUpdateList(
                  //           index: hoveredIconIndex.value, item: draggedData));
                  //       // containerIcons.value[hoveredIconIndex.value] = draggedData;
                  //       // skillsList[hoveredIconIndex.value] = draggedData;
                  //     } else {
                  //       pbisPlusClassroomBloc.add(GetPBISSkillsUpdateList(
                  //           index: count, item: draggedData));
                  //       // containerIcons.value[count] = draggedData;
                  //       // skillsList[count] = draggedData;
                  //     }
                  //   } else {
                  //     pbisPlusClassroomBloc.add(GetPBISSkillsUpdateList(
                  //         index: count, item: draggedData));
                  //     // containerIcons.value[hoveredIconIndex.value] =
                  //     //     draggedData; // Change the hovered icon
                  //     // skillsList[hoveredIconIndex.value] = draggedData;
                  //   }

                  hoveredIconIndex.value = -1;
                  changedIndex.value = -1;
                  // }
                  // setState(() {
                  //   print("-------state state");
                  // });
                },
                builder: (context, candidateData, rejectedData) {
                  return GestureDetector(
                      onTap: () {
                        // print(skillsList[index].dataList[0].name);
                        // if (containerIcons.value[index].title != "Add Skill") {
                        //   isEditMode.value = true;
                        //   changedIndex.value = index;
                        // }
                        if (skillsList[index].name != "Add Skill") {
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
                                      ? _buildEditWidget(
                                          item, index, pbisPlusClassroomBloc)
                                      : ShimmerLoading(
                                          isLoading: loading,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Draggable(
                                                data: item,
                                                child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  child: SvgPicture.asset(
                                                    item.iconUrlC!,
                                                    // item.dataList[0].iconUrlC!,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                feedback: Container(
                                                  height: 40,
                                                  width: 40,
                                                  child: SvgPicture.asset(
                                                    item.iconUrlC!,
                                                    // item.dataList[0].iconUrlC!,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                childWhenDragging: Container(
                                                  height: 40,
                                                  width: 40,
                                                  child: SvgPicture.asset(
                                                    item.iconUrlC!,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              SpacerWidget(4),
                                              Padding(
                                                padding: Globals.deviceType !=
                                                        'phone'
                                                    ? const EdgeInsets.only(
                                                        top: 10, left: 10)
                                                    : EdgeInsets.zero,
                                                child: Utility.textWidget(
                                                    text: item.name!,
                                                    // item.dataList[0].name!,
                                                    context: context,
                                                    textTheme: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1!
                                                        .copyWith(
                                                            fontSize: 12)),
                                              )
                                            ],
                                          ),
                                        ))));
                });
          });
    });
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

  Widget _buildEditWidget(
      PBISPlusSkills item, int index, PBISPlusBloc pbisPlusClassroomBloc) {
    return GestureDetector(
      onTap: () async {
        print(item.runtimeType);
        await _modalBottomSheetMenu(item, index, pbisPlusClassroomBloc);

        print("----------botton sheet ======== close=======----------------");
        isEditMode.value = !isEditMode.value;
        changedIndex.value = -1;
        pbisPlusClassroomBloc.add(GetPBISSkills());
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
    return ValueListenableBuilder(
        valueListenable: toogle,
        builder: (context, value, _) => toogle.value
            ? Expanded(
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
                          style:
                              Theme.of(context).textTheme.headline1!.copyWith(),
                        ),
                      ),
                      SpacerWidget(16),
                      BlocConsumer(
                          bloc: pbisPlusClassroomBloc,
                          builder: (context, state) {
                            if (state is PBISPlusSkillsLoading) {
                              return Center(
                                child: Container(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator.adaptive(
                                      backgroundColor: AppTheme.kButtonColor,
                                    )),
                              );
                            } else if (state is PBISPlusSkillsSucess) {
                              if (state.skillsList.isNotEmpty) {
                                return _buildBehaviourList(
                                    PBISPlusSkillsModalLocal
                                        .PBISPlusSkillLocalBehaviourlist);
                              } else {
                                return _buildBehaviourList(
                                    PBISPlusSkillsModalLocal
                                        .PBISPlusSkillLocalBehaviourlist);
                              }
                            } else if (state is PBISErrorState)
                              return _noDataFoundWidget();
                            return _buildBehaviourList(PBISPlusSkillsModalLocal
                                .PBISPlusSkillLocalBehaviourlist);
                          },
                          listener: (context, state) async {}),
                      SpacerWidget(18),
                    ],
                  ),
                ),
              )
            : SizedBox.shrink());
  }

  Widget _buildBehaviourList(List<PBISPlusSkills> skillsList) {
    return Expanded(
        child: ValueListenableBuilder(
            valueListenable: localskillsList,
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
                    itemCount: 3 *
                        PBISPlusSkillsModalLocal
                            .PBISPlusSkillLocalBehaviourlist.length
                            .ceil(),
                    itemBuilder: (BuildContext context, int index) {
                      PBISPlusSkills item = PBISPlusSkillsModalLocal
                          .PBISPlusSkillLocalBehaviourlist[index % 6];
                      final isIconDisabled = IsItemExits(item);
                      print(
                          "-------isIconDisabled-------------${isIconDisabled}------------==${index}============------------");
                      return isIconDisabled
                          ? _buildNonDraggbleIcon(item, isIconDisabled)
                          : _buildEditSkillIcon(item, isIconDisabled);
                    },
                  ),
                )));
  }

  bool IsItemExits(PBISPlusSkills itemtoFind) {
    try {
      final res = localskillsList.value
          .where((item) => itemtoFind.id == item.id)
          .isNotEmpty;
      return res;
    } catch (e) {
      return false;
    }
  }

  Widget _buildNonDraggbleIcon(PBISPlusSkills item, isIconDisabled) {
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
                opacity: 0.1,
                child: SvgPicture.asset(
                  item.iconUrlC!,
                ))),
      ),
    );
  }

  Widget _buildEditSkillIcon(PBISPlusSkills item, isIconDisabled) {
    return GestureDetector(
      onTap: () {
        print(item.runtimeType);
        Utility.doVibration();
      },
      child: Draggable(
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
                        item.iconUrlC!,
                      ))
                  : SvgPicture.asset(
                      item.iconUrlC!,
                    ),
            ),
          ),
        ),
        feedback: isIconDisabled
            ? SizedBox.shrink()
            : SvgPicture.asset(
                item.iconUrlC!,
              ),
        childWhenDragging: isIconDisabled
            ? SizedBox.shrink()
            : SvgPicture.asset(
                item.iconUrlC!,
              ),
      ),
    );
  }

  _modalBottomSheetMenu(
          PBISPlusSkills item, int index, PBISPlusBloc pbisPlusClassroomBloc) =>
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
                pbisPlusClassroomBloc: pbisPlusClassroomBloc,
                index: index,
                constraints: constraints,
                // containerIcons: containerIcons,
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
