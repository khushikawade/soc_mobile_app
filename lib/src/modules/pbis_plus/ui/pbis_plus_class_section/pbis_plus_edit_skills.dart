// ignore_for_file: must_be_immutable

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_all_behaviour_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_genric_behaviour_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_appbar.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_edit_skills_bottom_sheet.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Soc/src/services/Strings.dart';

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
  ValueNotifier<bool> isCustomBehaviour = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueChange = ValueNotifier<bool>(false);
  bool tooglevalue = false;
  PBISPlusBloc pbisPlusClassroomBloc = PBISPlusBloc();
  // static final addSkill = PBISPlusGenricBehaviourModal(
  //   id: "5",
  //   activeStatusC: "Show",
  //   iconUrlC: "assets/Pbis_plus/add_icon.svg",
  //   name: 'Add Skill',
  //   sortOrderC: "5",
  //   counter: 0,
  // );

  // ValueNotifier<List<PBISPlusGenricBehaviourModal>> containerIcons =
  //     ValueNotifier<List<PBISPlusGenricBehaviourModal>>([
  //   PBISPlusSkillsModalLocal.PBISPlusSkillLocalModallist[0],
  //   PBISPlusSkillsModalLocal.PBISPlusSkillLocalModallist[1],
  //   addSkill,
  //   addSkill,
  //   addSkill,
  //   addSkill
  // ]);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // PBISPlusBloc pbisPlusAdditionalBehaviourBloc = PBISPlusBloc();
  PBISPlusBloc pbisPlusClassroomBloc2 = PBISPlusBloc();
  PBISPlusBloc pbisPlusClassroomBloc3 = PBISPlusBloc();

  // List<PBISPlusALLBehaviourModal> additionalbehaviourList = [];

  ValueNotifier<List<PBISPlusALLBehaviourModal>> teacherCustomBehaviourList =
      ValueNotifier<List<PBISPlusALLBehaviourModal>>([]);
  ValueNotifier<List<PBISPlusALLBehaviourModal>> additionalbehaviourList =
      ValueNotifier<List<PBISPlusALLBehaviourModal>>([]);
  @override
  void initState() {
    super.initState();

    // pbisPlusClassroomBloc
    //     .add(GetPBISPlusDefaultBehaviour(isCustom: isCustomBehaviour.value));

    pbisPlusClassroomBloc.add(PBISPlusGetDefaultSchoolBehvaiour());
    pbisPlusClassroomBloc2.add(PBISPlusGetPBISPlusAdditionalBehaviour());
    pbisPlusClassroomBloc3.add(PBISPlusGetTeacherCustomBehvaiour());
    getCustomValue();
  }

  void getCustomValue() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final storedValue = pref.getBool(Strings.isCustomBehaviour);
      if (storedValue != null) {
        isCustomBehaviour.value = storedValue;
      }
    } catch (e) {}
  }

  void settheValueofCustomer({bool? value}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool(Strings.isCustomBehaviour, value ?? isCustomBehaviour.value);
    } catch (e) {}
  }

  ValueNotifier<List<PBISPlusGenricBehaviourModal>> localskillsList =
      ValueNotifier<List<PBISPlusGenricBehaviourModal>>([]);

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
          valueListenable: isCustomBehaviour,
          builder: (context, value, _) => Transform.scale(
                transformHitTests: false,
                scale: 0.8, // Adjust the scale factor as needed
                child: CupertinoSwitch(
                  value: isCustomBehaviour.value,
                  onChanged: (value) {
                    isCustomBehaviour.value = value;
                    settheValueofCustomer(value: value);
                  },
                  trackColor:
                      Color(0xff000000) == Theme.of(context).backgroundColor
                          ? AppTheme.klistTilePrimaryLight.withOpacity(0.1)
                          : Color(0xff000000).withOpacity(0.5),
                  thumbColor: isCustomBehaviour.value
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
          updateTeacherCustomBehvaiour();

          Navigator.pop(context);
        },
        icon: Icon(
            IconData(0xe80d,
                fontFamily: Overrides.kFontFam,
                fontPackage: Overrides.kFontPkg),
            size: Globals.deviceType == 'phone' ? 24 : 32,
            color: AppTheme.kButtonColor));
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*------------------------------------------------trackUserActivity--------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  void trackUserActivity() {
    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        "pbis_plus_edit_behaviour_screen");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'pbis_plus_edit_behaviour_screen',
        screenClass: 'PBISPlusEditSkills');
    /*-------------------------------------------------------------------------------------*/
    // Utility.updateLogs(
    //     activityType: widget.isFromStudentPlus == true ? 'STUDENT+' : 'PBIS+',
    //     activityId: '37',
    //     description:
    //         'Student ${widget.studentValueNotifier.value.profile!.name} Card View',
    //     operationResult: 'Success');
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*--------------------------------------------------_buildHeader------------------------------------------------ */
/*-------------------------------------------------------------------------------------------------------------- */
  Widget _buildHeader() {
    return ValueListenableBuilder(
        valueListenable: isCustomBehaviour,
        builder: (context, value, _) => Card(
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
                      // toogle.value ? "Edit Behaviour" : "Default Behaviour",
                      isCustomBehaviour.value
                          ? "Teacher Behaviour"
                          : "School Behaviour",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: Color(0xff000000) ==
                                  Theme.of(context).backgroundColor
                              ? Color(0xffFFFFFF)
                              : Color(0xff000000),
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  SpacerWidget(18),

                  BlocConsumer<PBISPlusBloc, PBISPlusState>(
                      bloc: isCustomBehaviour.value
                          ? pbisPlusClassroomBloc3
                          : pbisPlusClassroomBloc,
                      builder: (context, state) {
                        // if (state is PBISPlusDefaultBehaviourLoading) {
                        //   print("-----------state is $state------------------");
                        //   return _buildEditItemList(
                        //       PBISPlusSkillsModalLocal
                        //           .PBISPlusSkillLocalBehaviourlist,
                        //       true);
                        // } else if (state is PBISPlusSkillsUpdateLoading) {
                        //   return _buildEditItemList(state.skillsList, false);
                        // } else if (state is PBISPlusDefaultBehaviourSucess) {
                        //   print("-----------state is $state------------------");
                        //   // localskillsList.value = state.skillsList;
                        //   if (state.skillsList.isNotEmpty) {
                        //     return _buildEditItemList(state.skillsList, false);
                        //   } else {
                        //     return _buildEditItemList(state.skillsList, false);
                        //   }
                        // } else if (state is PBISPlusDefaultBehaviourError) {
                        //   print("-----------state is $state------------------");
                        //   return _noDataFoundWidget();
                        // } else

                        print("state ------------- $state");
                        if (state is PBISPlusGetDefaultSchoolBehvaiourSuccess) {
                          return _buildEditItemList(
                              state.defaultSchoolBehaviourList, false);
                        }

                        if (state is PBISPlusGetTeacherCustomBehvaiourSuccess) {
                          teacherCustomBehaviourList.value =
                              state.teacherCustomBehaviourList;
                          return ValueListenableBuilder(
                              valueListenable: teacherCustomBehaviourList,
                              builder: (context, value, _) {
                                return _buildEditItemList(
                                    teacherCustomBehaviourList.value, false);
                              });
                        }
                        if (state is PBISPlusBehvaiourLoading) {
                          return _buildEditItemList(
                              state.demoBehaviourData, true);
                        }

                        return _noDataFoundWidget();
                      },
                      listener: (context, state) async {
                        //   if (state is PBISPlusGetTeacherCustomBehvaiourSuccess) {
                        //     teacherCustomBehaviourList.value =
                        //         state.teacherCustomBehaviourList;
                        //   }
                      }
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
        child: Text(
          "No Skills Found",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildEditItemList(
      List<PBISPlusALLBehaviourModal> skillsList, bool loading) {
    return IgnorePointer(
      ignoring: !isCustomBehaviour.value,
      child: DragTarget<PBISPlusALLBehaviourModal>(
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
              return DragTarget<PBISPlusALLBehaviourModal>(
                  onWillAccept: (draggedData) {
                    hoveredIconIndex.value =
                        index; // Update the hovered icon index
                    // print(hoveredIconIndex);
                    return true;
                  },
                  onLeave: ((data) => print(
                      "-----------------INSIDE ON LEAVE---------------------------")),
                  onAccept: (draggedData) {
                    print("-----------------onAccept-----------------");
                    print(teacherCustomBehaviourList.value.length < 6);
                    if (!skillsList.contains(draggedData) &&
                        teacherCustomBehaviourList.value.length < 6) {
                      print("added new skill");
                      setState(() {
                        teacherCustomBehaviourList.value.add(draggedData);
                        additionalbehaviourList.value.remove(draggedData);
                      });
                    } else {
                      print("already exists this skill");
                    }

                    // pbisPlusClassroomBloc.add(GetPBISSkillsUpdateList(
                    //     index: hoveredIconIndex.value,
                    //     item: draggedData,
                    //     olditem: localskillsList.value));

                    // hoveredIconIndex.value = -1;
                    // changedIndex.value = -1;
                  },
                  builder: (context, candidateData, rejectedData) {
                    return GestureDetector(
                        onTap: () {
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
                                                Container(
                                                  height: 40,
                                                  width: 40,
                                                  child: _buildIcons(
                                                    item: item,
                                                  ),
                                                ),
                                                SpacerWidget(4),
                                                ShimmerLoading(
                                                  isLoading: loading,
                                                  child: Padding(
                                                    padding: Globals
                                                                .deviceType !=
                                                            'phone'
                                                        ? const EdgeInsets.only(
                                                            top: 10, left: 10)
                                                        : EdgeInsets.zero,
                                                    child: Utility.textWidget(
                                                        text: item
                                                            .behaviorTitleC!,
                                                        context: context,
                                                        textTheme:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodyText1!
                                                                .copyWith(
                                                                    fontSize:
                                                                        12)),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ))));
                  });
            });
      }),
    );
  }

  // Widget _buildIcons(String assestPath) {
  //   return assestPath.contains('http://') || assestPath.contains('https://')
  //       ? Image.network(
  //           assestPath!,
  //           fit: BoxFit.contain,
  //         )
  //       : SvgPicture.asset(
  //           assestPath,
  //           fit: BoxFit.contain,
  //         );
  // }

  Widget _buildIcons({required PBISPlusALLBehaviourModal item}) {
    return CachedNetworkImage(
      imageUrl: item.pBISBehaviorIconURLC!,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => ShimmerLoading(
        isLoading: true,
        child: Container(),
      ),
      errorWidget: (context, url, error) => Icon(Icons.person),
    );
  }

  Widget _buildEditWidget(PBISPlusALLBehaviourModal item, int index,
      PBISPlusBloc pbisPlusClassroomBloc) {
    return GestureDetector(
      onTap: () async {
        await _modalBottomSheetMenu(item, index, pbisPlusClassroomBloc);

        // print("----------botton sheet ======== close=======----------------");
        isEditMode.value = !isEditMode.value;
        changedIndex.value = -1;
        pbisPlusClassroomBloc.add(
            GetPBISPlusDefaultBehaviour(isCustom: isCustomBehaviour.value));
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

/*-------------------------------------------------------------------------------------------------------------- */
/*------------------------------------------_buildAdditionalBehaviour------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  Widget _buildAdditionalBehaviour() {
    return ValueListenableBuilder(
        valueListenable: isCustomBehaviour,
        builder: (context, value, _) => isCustomBehaviour.value
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
                          bloc: pbisPlusClassroomBloc2,
                          builder: (context, state) {
                            print("additionalbehaviourList $state");
                            // print(
                            //     "-----------state is $state------------------");

                            // if (state
                            //     is GetPBISPlusAdditionalBehaviourLoading) {
                            //   print(
                            //       "-----------state is $state------------------");
                            //   return _buildBehaviourList(
                            //       PBISPlusSkillsModalLocal
                            //           .PBISPlusSkillLocalBehaviourlist,
                            //       true);
                            // } else if (state
                            //     is PbisPlusAdditionalBehaviourSuccess) {
                            //   print(
                            //       "-----------state is $state------------------");
                            //   if (state.additionalbehaviourList.isNotEmpty) {
                            //     return _buildBehaviourList(
                            //         PBISPlusSkillsModalLocal
                            //             .PBISPlusSkillLocalBehaviourlist,
                            //         false);
                            //   } else {
                            //     return _noDataFoundWidget();
                            //   }
                            // } else if (state
                            //     is PBISPlusAdditionalBehaviourError) {
                            //   print(
                            //       "-----------state is $state------------------");
                            //   return _noDataFoundWidget();
                            // }
                            // return _buildBehaviourList(
                            //     PBISPlusSkillsModalLocal
                            //         .PBISPlusSkillLocalBehaviourlist,
                            //     false);

                            if (state
                                    is PBISPlusGetPBISPlusAdditionalBehaviourSuccess &&
                                state.additionalbehaviourList.isNotEmpty) {
                              additionalbehaviourList.value =
                                  state.additionalbehaviourList;

                              return ValueListenableBuilder(
                                  valueListenable: additionalbehaviourList,
                                  builder: (context, value, _) {
                                    return _buildBehaviourList(
                                        additionalbehaviourList.value, false);
                                  });
                            }

                            if (state is PBISPlusBehvaiourLoading) {
                              return _buildBehaviourList(
                                  state.demoBehaviourData, true);
                            }
                            return _noDataFoundWidget();
                          },
                          listener: (context, state) async {}),
                      SpacerWidget(18),
                    ],
                  ),
                ),
              )
            : SizedBox.shrink());
  }

  Widget _buildBehaviourList(
      List<PBISPlusALLBehaviourModal> skillsList, bool loading) {
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
                    itemCount: skillsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      PBISPlusALLBehaviourModal item = skillsList[index];
                      final isIconDisabled = IsItemExits(item);
                      return _buildEditSkillIcon(item, isIconDisabled);
                      //  loading
                      //     ? ShimmerLoading(
                      //         isLoading: loading,
                      //         child: _buildNonDraggbleIcon(item, true))
                      //     : isIconDisabled
                      //         ?
                      //          _buildEditSkillIcon(item, isIconDisabled)
                      //         : _buildEditSkillIcon(item, isIconDisabled);
                    },
                  ),
                )));
  }

  bool IsItemExits(PBISPlusALLBehaviourModal itemtoFind) {
    try {
      final res = localskillsList.value
          .where((item) => itemtoFind.id == item.id)
          .isNotEmpty;
      return res;
    } catch (e) {
      return false;
    }
  }

  Widget _buildNonDraggbleIcon(PBISPlusALLBehaviourModal item, isIconDisabled) {
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
            child: Opacity(opacity: 0.1, child: _buildIcons(item: item))),
      ),
    );
  }

  Widget _buildEditSkillIcon(PBISPlusALLBehaviourModal item, isIconDisabled) {
    return GestureDetector(
        onTap: () {
          // print(item.runtimeType);
          // Utility.doVibration();
        },
        child: Draggable(
          data: item,
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
                    ? Opacity(opacity: 0.2, child: _buildIcons(item: item))
                    : _buildIcons(item: item),
              ),
            ),
          ),
          feedback:
              Container(width: 80, height: 80, child: _buildIcons(item: item)),
          childWhenDragging: Container(),
        )

        // Draggable<PBISPlusALLBehaviourModal>(
        //     data: item,
        //     ignoringFeedbackPointer: !isIconDisabled,
        //     child: Container(
        //       width: 40,
        //       height: 40,
        //       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        //       padding: EdgeInsets.all(8),
        //       decoration: BoxDecoration(
        //         color: Theme.of(context).backgroundColor,
        //         borderRadius: BorderRadius.circular(8),
        //         boxShadow: [
        //           BoxShadow(
        //             color: Colors.grey.withOpacity(0.4),
        //             spreadRadius: 0,
        //             blurRadius: 1,
        //             offset: Offset(0, 0),
        //           ),
        //         ],
        //       ),
        //       child: Center(
        //         child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: isIconDisabled
        //               ? Opacity(opacity: 0.2, child: _buildIcons(item: item))
        //               : _buildIcons(item: item),
        //         ),
        //       ),
        //     ),
        //     feedback:
        //         isIconDisabled ? SizedBox.shrink() : _buildIcons(item: item),
        //     childWhenDragging:
        //         isIconDisabled ? SizedBox.shrink() : _buildIcons(item: item)),
        );
  }

  _modalBottomSheetMenu(PBISPlusALLBehaviourModal item, int index,
          PBISPlusBloc pbisPlusClassroomBloc) =>
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
                height: MediaQuery.of(context).size.height * 0.35,
              );
            });
          });

/*-------------------------------------------------------------------------------------------------------------- */
/*-----------------------------------------------Main Method---------------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CommonBackgroundImgWidget(),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PBISPlusAppBar(
              title: "", backButton: true, scaffoldKey: _scaffoldKey),
          body: body(context))
    ]);
  }

  Future<void> updateTeacherCustomBehvaiour() async {
    LocalDatabase<PBISPlusALLBehaviourModal> teacherCustomBehaviourDb =
        LocalDatabase(
            PBISPlusOverrides.PbisPlusTeacherCustomBehaviourLocalDbTable);

    await teacherCustomBehaviourDb.clear();
    // teacherCustomBehaviourList.value.forEach((element) async {
    //   await teacherCustomBehaviourDb.addData(element);
    // });
  }
}
