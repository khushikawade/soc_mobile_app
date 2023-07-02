// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_genric_behaviour_modal.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_appbar.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_edit_skills_bottom_sheet.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
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
  // ValueNotifier<int> hoveredIconIndex = ValueNotifier<int>(-1);
  ValueNotifier<int> changedIndex = ValueNotifier<int>(-1);
  // ValueNotifier<bool> isEditMode = ValueNotifier<bool>(false);
  ValueNotifier<bool> isCustomBehaviour = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueChange = ValueNotifier<bool>(false);
  // bool tooglevalue = false;
  PBISPlusBloc pbisCustomBehaviourBloc = PBISPlusBloc();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PBISPlusBloc pbisPlusAdditionalBehaviourBloc = PBISPlusBloc();

  @override
  void initState() {
    super.initState();
    pbisPlusAdditionalBehaviourBloc.add(GetPBISPlusAdditionalBehaviour());
    pbisCustomBehaviourBloc.add(GetPBISPlusCustomBehaviour());
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

  void setToggleValue({bool? value}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool(Strings.isCustomBehaviour, value ?? isCustomBehaviour.value);
    } catch (e) {}
  }

  ValueNotifier<List<PBISPlusGenericBehaviourModal>> localskillsList =
      ValueNotifier<List<PBISPlusGenericBehaviourModal>>([]);

  Widget body(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpacerWidget(18),
          _buildIconBar(),
          buildTargetBehaviorWidget(),
          SpacerWidget(18),
          _buildAdditionalBehaviourWidget(),
          SpacerWidget(48)
        ]);
  }

  Widget _buildToggleButton() {
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
                    setToggleValue(value: value);
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

/*-------------------------------------------------------------------------------------------------------------- */
/*------------------------------------------------_buildIconBar------------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  Widget _buildIconBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildBackIcon(), _buildToggleButton()],
    );
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*------------------------------------------------_buildBackIcon------------------------------------------------ */
/*-------------------------------------------------------------------------------------------------------------- */
  Widget _buildBackIcon() {
    return IconButton(
        onPressed: () {
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
  Widget buildTargetBehaviorWidget() {
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
                      bloc: pbisCustomBehaviourBloc,
                      builder: (context, state) {
                        print(state);
                        if (state is PBISPlusLoading) {
                          return ShimmerLoading(
                              child: _buildCurrentBehaviourList(
                                  PBISPlusSkillsModalLocal
                                      .PBISPlusSkillLocalBehaviourlist,
                                  true),
                              isLoading: true);
                        }
                        //else if (state is PBISPlusSkillsUpdateLoading) {
                        //   return _buildCurrentBehaviourList(
                        //       state.skillsList, false);
                        // }
                        else if (state is PBISPlusDefaultBehaviourSucess) {
                          return _buildCurrentBehaviourList(
                              state.skillsList, false);
                        } else if (state is PBISPlusDefaultBehaviourError) {
                          return _noDataFoundWidget();
                        }
                        return Container();
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
        child: Text(
          "No Skills Found",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildCurrentBehaviourList(
      List<PBISPlusGenericBehaviourModal> skillsList, bool loading) {
    return DragTarget<PBISPlusGenericBehaviourModal>(
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
            return DragTarget<PBISPlusGenericBehaviourModal>(
                onWillAccept: (draggedData) {
              // hoveredIconIndex.value = index; // Update the hovered icon index
              // print(hoveredIconIndex);
              return true;
            }, onAccept: (draggedData) {
              //update behaviour in db
              ////TODO: API CALL PENDING
              pbisCustomBehaviourBloc.add(UpdatePBISBehavior(
                  index: index,
                  item: draggedData,
                  olditem: localskillsList.value));

              // hoveredIconIndex.value = -1;
              //Reset the update value if already any index value exist
              changedIndex.value = -1;
            }, builder: (context, candidateData, rejectedData) {
              return GestureDetector(
                  onTap: () {
                    if (skillsList[index].name != "Add Skill") {
                      // isEditMode.value = true;
                      changedIndex.value = index;
                    }
                  },
                  child: ValueListenableBuilder(
                      valueListenable: changedIndex,
                      builder: (context, value, _) => ValueListenableBuilder(
                          valueListenable: isCustomBehaviour,
                          builder: (context, value, _) => index ==
                                      changedIndex.value &&
                                  isCustomBehaviour.value
                              ?
                              //To show edit icon on selected behaviour
                              _buildEditWidget(
                                  item, index, pbisCustomBehaviourBloc)
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                      Draggable(
                                          data: item,
                                          child: Container(
                                              height: 40,
                                              width: 40,
                                              child:
                                                  _buildIcons(item.iconUrlC!)),
                                          feedback: Container(
                                              height: 40,
                                              width: 40,
                                              child:
                                                  _buildIcons(item.iconUrlC!)),
                                          childWhenDragging: Container(
                                              height: 40,
                                              width: 40,
                                              child:
                                                  _buildIcons(item.iconUrlC!))),
                                      SpacerWidget(4),
                                      Padding(
                                          padding: Globals.deviceType != 'phone'
                                              ? const EdgeInsets.only(
                                                  top: 10, left: 10)
                                              : EdgeInsets.zero,
                                          child: Utility.textWidget(
                                              text: item.name!,
                                              context: context,
                                              textTheme: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(fontSize: 12)))
                                    ]))));
            });
          });
    });
  }

  Widget _buildIcons(String assestPath) {
    return assestPath.contains('http://') || assestPath.contains('https://')
        ? Image.network(
            assestPath!,
            fit: BoxFit.contain,
          )
        : SvgPicture.asset(
            assestPath,
            fit: BoxFit.contain,
          );
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*---------------------------------------------------_buildEditWidget------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  Widget _buildEditWidget(PBISPlusGenericBehaviourModal item, int index,
      PBISPlusBloc pbisPlusClassroomBloc) {
    return GestureDetector(
      onTap: () async {
        await _modalBottomSheetMenu(item, index, pbisPlusClassroomBloc);

        // isEditMode.value = !isEditMode.value;
        changedIndex.value = -1;

        //COMMENTED BY JYOTSNA
        // pbisPlusClassroomBloc.add(
        //     GetPBISPlusDefaultBehaviour(isCustom: isCustomBehaviour.value));
        pbisCustomBehaviourBloc.add(GetPBISPlusCustomBehaviour());
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
  Widget _buildAdditionalBehaviourWidget() {
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
                          bloc: pbisPlusAdditionalBehaviourBloc,
                          builder: (context, state) {
                            if (state is PBISPlusLoading) {
                              return ShimmerLoading(
                                  isLoading: true,
                                  child: _buildAdditionalBehaviourList(
                                      PBISPlusSkillsModalLocal
                                          .PBISPlusSkillLocalBehaviourlist,
                                      true));
                            } else if (state
                                is PbisPlusAdditionalBehaviourSuccess) {
                              if (state.additionalBehaviourList.isNotEmpty) {
                                return _buildAdditionalBehaviourList(
                                    PBISPlusSkillsModalLocal
                                        .PBISPlusSkillLocalBehaviourlist,
                                    false);
                              } else {
                                return _noDataFoundWidget();
                              }
                            } else if (state
                                is PBISPlusAdditionalBehaviourError) {
                              return _noDataFoundWidget();
                            }
                            return Container();
                          },
                          listener: (context, state) async {}),
                      SpacerWidget(18),
                    ],
                  ),
                ),
              )
            : SizedBox.shrink());
  }

  Widget _buildAdditionalBehaviourList(
      List<PBISPlusGenericBehaviourModal> skillsList, bool loading) {
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
                      childAspectRatio: 0.9,
                      // Adjust this value to change item aspect ratio
                      crossAxisSpacing: 0.0,
                      // Adjust the spacing between items horizontally
                      mainAxisSpacing: 4.0,
                      // Adjust the spacing between items vertically
                    ),
                    itemCount: skillsList.length,
                    // 3 *
                    //     PBISPlusSkillsModalLocal
                    //         .PBISPlusSkillLocalBehaviourlist.length
                    //         .ceil(),
                    itemBuilder: (BuildContext context, int index) {
                      PBISPlusGenericBehaviourModal item =
                          skillsList[index % 6];
                      // PBISPlusSkillsModalLocal
                      //     .PBISPlusSkillLocalBehaviourlist[index % 6];
                      final isIconDisabled = IsItemExits(item);

                      return _buildAdditionalBehaviourIcon(
                          item, isIconDisabled);
                    }))));
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*------------------------------------------_buildAdditionalBehaviour------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
//Used to check IF additional icon is already in use or not
  bool IsItemExits(PBISPlusGenericBehaviourModal itemtoFind) {
    try {
      final res = localskillsList.value
          .where((item) => itemtoFind.id == item.id)
          .isNotEmpty;
      return res;
    } catch (e) {
      return false;
    }
  }

  // Widget _buildNonDraggbleIcon(
  //     PBISPlusGenericBehaviourModal item, isIconDisabled) {
  //   return Container(
  //     width: 40,
  //     height: 40,
  //     margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
  //     padding: EdgeInsets.all(8),
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).backgroundColor,
  //       borderRadius: BorderRadius.circular(8),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.4),
  //           spreadRadius: 0,
  //           blurRadius: 1,
  //           offset: Offset(0, 0),
  //         ),
  //       ],
  //     ),
  //     child: Center(
  //       child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Opacity(opacity: 0.1, child: _buildIcons(item.iconUrlC!))),
  //     ),
  //   );
  // }

  Widget _buildAdditionalBehaviourIcon(
      PBISPlusGenericBehaviourModal item, isIconDisabled) {
    return GestureDetector(
      onTap: () {
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
                    ? Opacity(opacity: 0.2, child: _buildIcons(item.iconUrlC!))
                    : _buildIcons(item.iconUrlC!),
              ),
            ),
          ),
          feedback:
              isIconDisabled ? SizedBox.shrink() : _buildIcons(item.iconUrlC!),
          childWhenDragging:
              isIconDisabled ? SizedBox.shrink() : _buildIcons(item.iconUrlC!)),
    );
  }

  _modalBottomSheetMenu(PBISPlusGenericBehaviourModal item, int index,
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
}
