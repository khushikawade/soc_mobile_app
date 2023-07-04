// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_all_behaviour_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_genric_behaviour_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/hero_dialog_route.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_appbar.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_common_popup.dart';
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
  ValueNotifier<int> changedIndex = ValueNotifier<int>(-1);
  ValueNotifier<bool> isCustomBehaviour = ValueNotifier<bool>(false);
  bool tooglevalue = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PBISPlusBloc pbisPluBlocForDefaultSchoolBehvaiour = PBISPlusBloc();
  PBISPlusBloc pbisPluBlocForAdditionalBehaviour = PBISPlusBloc();
  PBISPlusBloc pbisPluBlocForTeacherCustomBehvaiour = PBISPlusBloc();

  ValueNotifier<List<PBISPlusALLBehaviourModal>> teacherCustomBehaviourList =
      ValueNotifier<List<PBISPlusALLBehaviourModal>>([]);
  ValueNotifier<List<PBISPlusALLBehaviourModal>> additionalbehaviourList =
      ValueNotifier<List<PBISPlusALLBehaviourModal>>([]);

  ValueNotifier<bool> updateBehaviourWidget = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    pbisPluBlocForDefaultSchoolBehvaiour
        .add(PBISPlusGetDefaultSchoolBehvaiour());
    pbisPluBlocForAdditionalBehaviour.add(PBISPlusGetAdditionalBehaviour());
    pbisPluBlocForTeacherCustomBehvaiour
        .add(PBISPlusGetTeacherCustomBehvaiour());
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
                    changedIndex.value = -1;
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
          //   updateTeacherCustomBehvaiour();

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
                          ? "Teacher Behavior"
                          : "School Behavior",
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
                          ? pbisPluBlocForTeacherCustomBehvaiour
                          : pbisPluBlocForDefaultSchoolBehvaiour,
                      builder: (context, state) {
                        print("state ------------- $state");
                        if (state is PBISPlusGetDefaultSchoolBehvaiourSuccess) {
                          return buldBehaviours(
                              state.defaultSchoolBehaviourList, false);
                        }

                        if (state is PBISPlusGetTeacherCustomBehvaiourSuccess) {
                          teacherCustomBehaviourList.value =
                              state.teacherCustomBehaviourList;
                          return ValueListenableBuilder(
                              valueListenable: updateBehaviourWidget,
                              builder: (context, value, _) {
                                return ValueListenableBuilder(
                                    valueListenable: teacherCustomBehaviourList,
                                    builder: (context, value, _) {
                                      return buldBehaviours(
                                          teacherCustomBehaviourList.value,
                                          false);
                                    });
                              });
                        }
                        if (state is PBISPlusBehvaiourLoading) {
                          return buldBehaviours(state.demoBehaviourData, true);
                        }

                        return _noDataFoundWidget();
                      },
                      listener: (context, state) async {}),
                ],
              ),
            ));
  }

  Widget _noDataFoundWidget() {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height / 5,
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

  Widget buldBehaviours(
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
              itemCount: 6,
              // itemCount: skillsList.length,
              itemBuilder: (BuildContext context, int index) {
                if (index < skillsList.length) {
                  final item = skillsList[index];
                  return behaviourBuider(index, skillsList, item, loading);
                } else {
                  return defaultAddBehaviourWidget();
                }
              });
        },
        onAccept: (PBISPlusALLBehaviourModal draggedData) {
          PBISPlusALLBehaviourModal onAccepttedObj = draggedData;
          onAccepttedObj.id = '';

          print("onAccept on GridView DragTarget widget");
          if (skillsList.length == 6) {
            return;
          }

          if (!IsBehaviourAleadyAvailable(onAccepttedObj, skillsList) &&
              skillsList.length < 6) {
            print("added new behaviour on GridView DragTarget widget");

            teacherCustomBehaviourList.value.add(onAccepttedObj);
            // print(additionalbehaviourList.value.length);
            // additionalbehaviourList.value.remove(draggedData);
            // print(additionalbehaviourList.value.length);
            pbisPluBlocForTeacherCustomBehvaiour
                .add(PBISPlusAddTeacherCustomBehvaiour(
              behvaiour: onAccepttedObj,
              // oldbehvaiour: localskillsList.value
            ));
          } else {
            print(
                "this behaviour is already exits  on GridView DragTarget widget");
          }
        },
      ),
    );
  }

  Widget _buildIcons({required PBISPlusALLBehaviourModal item}) {
    return item.behaviorTitleC == "Add Behavior"
        ? SvgPicture.asset(
            item.pBISBehaviorIconURLC!,
            fit: BoxFit.contain,
          )
        : CachedNetworkImage(
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

  Widget _buildEditWidget(
    PBISPlusALLBehaviourModal item,
    int index,
  ) {
    return GestureDetector(
      onTap: () async {
        await _modalBottomSheetMenu(
            item: item,
            index: index,
            onDelete: () {
              Navigator.pop(context);
              showPopup(
                  message: "Are you sure you want to delete this item",
                  title: "",
                  item: item);
            },
            onEditCallBack: (String? editedName) {
              Navigator.pop(context);
              if (editedName != null && editedName.isNotEmpty) {
                //update the current obj with new name
                item.behaviorTitleC = editedName;
                //update the the Ui list with new name
                teacherCustomBehaviourList.value[index] = item;
                updateBehaviourWidget.value = !updateBehaviourWidget.value;

                pbisPluBlocForTeacherCustomBehvaiour.add(
                    PBISPlusAddTeacherCustomBehvaiour(
                        behvaiour: item, index: index));
              }
            });

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
                          "Additional Behavior",
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.headline1!.copyWith(),
                        ),
                      ),
                      SpacerWidget(16),
                      BlocConsumer(
                          bloc: pbisPluBlocForAdditionalBehaviour,
                          builder: (context, state) {
                            print("additionalbehaviourList $state");

                            if (state
                                    is PBISPlusGetAdditionalBehaviourSuccess &&
                                state.additionalbehaviourList.isNotEmpty) {
                              additionalbehaviourList.value =
                                  state.additionalbehaviourList;
                              return ValueListenableBuilder(
                                  valueListenable: additionalbehaviourList,
                                  builder: (context, value, _) {
                                    return _buildAdditionalBehaviourList(
                                        additionalbehaviourList.value, false);
                                  });
                            }

                            if (state is PBISPlusBehvaiourLoading) {
                              return _buildAdditionalBehaviourList(
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

  Widget _buildAdditionalBehaviourList(
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
                      childAspectRatio: 0.9,
                      // Adjust this value to change item aspect ratio
                      crossAxisSpacing: 0.0,
                      // Adjust the spacing between items horizontally
                      mainAxisSpacing: 4.0,
                      // Adjust the spacing between items vertically
                    ),
                    itemCount: skillsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      PBISPlusALLBehaviourModal item = skillsList[index];
                      final isIconDisabled = IsItemExits(item);
                      return _buildEditSkillIcon(item, isIconDisabled);
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
        ));
  }

  _modalBottomSheetMenu(
          {required PBISPlusALLBehaviourModal item,
          required int index,
          // required PBISPlusBloc pbisPlusBloc,
          required final VoidCallback onDelete,
          required final void Function(String) onEditCallBack}) =>
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
                // pbisPlusBloc: pbisPlusBloc,
                index: index,
                constraints: constraints,
                // containerIcons: containerIcons,
                item: item,
                height: MediaQuery.of(context).size.height * 0.35,
                onDelete: onDelete,

                onEditCallBack: onEditCallBack,
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

  showPopup(
      {required String message,
      required String? title,
      PBISPlusALLBehaviourModal? item,
      PBISPlusBloc? pbisPlusClassroomBloc}) async {
    var isDeleteTapped = await Navigator.of(context).push(HeroDialogRoute(
        builder: (context) => PBISPlusDeleteBehaviorPopup(
              // pbisPlusBloc: pbisPlusClassroomBloc,
              item: item!,
              // containerIcons: widget.containerIcons,
              backgroundColor:
                  Theme.of(context).colorScheme.background == Color(0xff000000)
                      ? Color(0xff162429)
                      : null,
              orientation: MediaQuery.of(context).orientation,
              context: context,
              message: message,
              title: '',
              titleStyle: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(fontWeight: FontWeight.bold),
              onDelete: () {
                for (int i = 0;
                    i < teacherCustomBehaviourList.value.length;
                    i++) {
                  if (teacherCustomBehaviourList.value[i].id == item.id) {
                    print(
                        "---------behvaiour deleted from Teacher Custom Behaviour FROM LIST UI");
                    teacherCustomBehaviourList.value.removeAt(i);
                    break;
                  }
                }

                pbisPluBlocForTeacherCustomBehvaiour
                    .add(PBISPlusDeleteTeacherCustomBehvaiour(behvaiour: item));
                updateBehaviourWidget.value = !updateBehaviourWidget.value;
                Navigator.pop(context);
              },
            )));
  }

  Widget behaviourBuider(int index, List<PBISPlusALLBehaviourModal> skillsList,
      PBISPlusALLBehaviourModal item, loading) {
    return DragTarget<PBISPlusALLBehaviourModal>(onWillAccept: (draggedData) {
      if (skillsList.length != 6) {
        return true;
      }
      print("hover on ${index}");

      return true;
    }, onAccept: (PBISPlusALLBehaviourModal draggedData) {
      PBISPlusALLBehaviourModal onAccepttedObj = draggedData;

      print("onAccept on Single DragTarget widget");

      if (skillsList.length != 6) {
        return;
      }

      if (!IsBehaviourAleadyAvailable(onAccepttedObj, skillsList)) {
        print("added new behaviour on single DragTarget widget");

        // teacherCustomBehaviourList.value[index] = onAccepttedObj;

        PBISPlusALLBehaviourModal currentDraggedObj =
            teacherCustomBehaviourList.value[index];

        currentDraggedObj.behaviorTitleC = onAccepttedObj.behaviorTitleC;

        currentDraggedObj.pBISBehaviorIconURLC =
            onAccepttedObj.pBISBehaviorIconURLC;

        teacherCustomBehaviourList.value[index] = currentDraggedObj;

        updateBehaviourWidget.value = !updateBehaviourWidget.value;
        pbisPluBlocForTeacherCustomBehvaiour
            .add(PBISPlusAddTeacherCustomBehvaiour(
          index: index,
          behvaiour: currentDraggedObj,
          // oldbehvaiour: localskillsList.value
        ));
      } else {
        print("this behaviour is already exits on single DragTarget widget");
      }
    }, builder: (context, candidateData, rejectedData) {
      return GestureDetector(
          onTap: () {
            changedIndex.value = index;
          },
          child: ValueListenableBuilder(
              valueListenable: changedIndex,
              builder: (context, value, _) => ValueListenableBuilder(
                  valueListenable: changedIndex,
                  builder: (context, value, _) {
                    print("PRITING THE VALUE IN ${changedIndex.value}");

                    return index == changedIndex.value &&
                            isCustomBehaviour.value == true
                        ? _buildEditWidget(
                            item, index,
                            //  pbisPluBlocForDefaultSchoolBehvaiour
                          )
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
                                    padding: Globals.deviceType != 'phone'
                                        ? const EdgeInsets.only(
                                            top: 10, left: 10)
                                        : EdgeInsets.zero,
                                    child: Utility.textWidget(
                                        text: item.behaviorTitleC!,
                                        context: context,
                                        textTheme: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(fontSize: 12)),
                                  ),
                                )
                              ],
                            ),
                          );
                  })));
    });
  }

  Widget defaultAddBehaviourWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 40,
          width: 40,
          child: _buildIcons(
            item: PBISPlusALLBehaviourModal.defaultAddBehaviorItem,
          ),
        ),
        SpacerWidget(4),
        ShimmerLoading(
          isLoading: false,
          child: Padding(
            padding: Globals.deviceType != 'phone'
                ? const EdgeInsets.only(top: 10, left: 10)
                : EdgeInsets.zero,
            child: Utility.textWidget(
                text: PBISPlusALLBehaviourModal
                    .defaultAddBehaviorItem.behaviorTitleC!,
                context: context,
                textTheme: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 12)),
          ),
        )
      ],
    );
  }

  bool IsBehaviourAleadyAvailable(PBISPlusALLBehaviourModal draggedData,
      List<PBISPlusALLBehaviourModal> skillsList) {
    try {
      for (PBISPlusALLBehaviourModal behavioural in skillsList) {
        if (behavioural.pBISBehaviorIconURLC ==
            draggedData.pBISBehaviorIconURLC) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return true;
    }
  }
}
