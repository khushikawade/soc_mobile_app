// ignore_for_file: must_be_immutable, deprecated_member_use
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_common_behavior_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/hero_dialog_route.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_appbar.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_common_popup.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_edit_skills_bottom_sheet.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
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
  final IconData titleIconData;
  PBISPlusEditSkills({
    Key? key,
    this.constraint,
    required this.titleIconData,
  }) : super(key: key) {}
  final double? constraint;

  @override
  State<PBISPlusEditSkills> createState() => _PBISPlusEditSkillsState();
}

class _PBISPlusEditSkillsState extends State<PBISPlusEditSkills> {
  //changedIndex////Used to show edit icon on tap
  ValueNotifier<int> changedIndex = ValueNotifier<int>(-1);
  // ValueNotifier<bool> isCustomBehavior = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueChange = ValueNotifier<bool>(false);

  ValueNotifier<List<PBISPlusCommonBehaviorModal>> additionalBehaviorList =
      ValueNotifier<List<PBISPlusCommonBehaviorModal>>([]);
  ValueNotifier<bool> updateBehaviorWidget = ValueNotifier<bool>(false);

  ScrollController? _gridController;
  //-------------------------------------------------------------------------------------------------

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //-------------------------------------------------------------------------------------------------
  // PBISPlusBloc pbisPlusAdditionalBehaviorBloc = PBISPlusBloc();
  PBISPlusBloc pbisPluDefaultBehaviorBloc = PBISPlusBloc();
  PBISPlusBloc pbisPluAdditionalBehaviorBloc = PBISPlusBloc();
  PBISPlusBloc pbisPluCustomBehaviorBloc = PBISPlusBloc();

  //-------------------------------------------------------------------------------------------------
  ValueNotifier<bool> updateAdditionalBehaviorWidget =
      ValueNotifier<bool>(false);

  // ValueNotifier<bool> isWait = ValueNotifier<bool>(false);
  ValueNotifier<int> isWaitIndex = ValueNotifier<int>(-1);
  @override
  void initState() {
    super.initState();
    _gridController = ScrollController();
    pbisPluDefaultBehaviorBloc.add(PBISPlusGetDefaultSchoolBehavior());
    pbisPluAdditionalBehaviorBloc.add(PBISPlusGetAdditionalBehavior());
    pbisPluCustomBehaviorBloc.add(PBISPlusGetTeacherCustomBehavior());
    // _scrollController!.addListener();

    // PBISPlusUtility.getCustomValue();
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*-------------------------------------------------getCustomValue----------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  // void getCustomValue() async {
  //   try {
  //     SharedPreferences pref = await SharedPreferences.getInstance();
  //     final storedValue = pref.getBool(Strings.isCustomBehavior);
  //     if (storedValue != null) {
  //       isCustomBehavior.value = storedValue;
  //     }
  //   } catch (e) {}
  // }

/*-------------------------------------------------------------------------------------------------------------- */
/*-------------------------------------------------setToggleValue----------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */

  // void setToggleValue({bool? value}) async {
  //   try {
  //     SharedPreferences pref = await SharedPreferences.getInstance();
  //     pref.setBool(Strings.isCustomBehavior,
  //         value ?? PBISPlusOverrides.isCustomBehavior.value);
  //   } catch (e) {}
  // }

/*-------------------------------------------------------------------------------------------------------------- */
/*---------------------------------------------------BODY FRAME------------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */

  Widget body(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpacerWidget(StudentPlusOverrides.KVerticalSpace / 5),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: StudentPlusOverrides.kSymmetricPadding),
            child: PlusScreenTitleWidget(
                kLabelSpacing: StudentPlusOverrides.kLabelSpacing,
                text: 'Edit Behaviors'),
          ),
          SpacerWidget(StudentPlusOverrides.KVerticalSpace / 5),
          buildTargetBehaviorWidget(),
          SpacerWidget(StudentPlusOverrides.KVerticalSpace / 5),
          _buildAdditionalBehaviorWidget(),
          SpacerWidget(StudentPlusOverrides.KVerticalSpace / 2),
        ]);
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*----------------------------------------------_buildToggleButton---------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  Widget _buildToggleButton() {
    return Container(
      // color: Colors.red,
      // padding: EdgeInsets.only(right: 0),
      // padding: EdgeInsets.symmetric(
      //     horizontal: StudentPlusOverrides.kSymmetricPadding),
      child: ValueListenableBuilder(
          valueListenable: PBISPlusOverrides.isCustomBehavior,
          builder: (context, value, _) => Transform.scale(
                transformHitTests: false,
                scale: 0.8, // Adjust the scale factor as needed
                child: CupertinoSwitch(
                  value: PBISPlusOverrides.isCustomBehavior.value,
                  onChanged: (value) {
                    if (isWaitIndex.value != -1) {
                      notifyUser();
                      return;
                    }
                    changedIndex.value = -1;
                    PBISPlusOverrides.isCustomBehavior.value = value;
                    PBISPlusUtility.setToggleValue(value: value);
                  },
                  trackColor: Colors.grey,
                  thumbColor: PBISPlusOverrides.isCustomBehavior.value == true
                      ? AppTheme.GreenColor
                      : AppTheme.klistTilePrimaryLight,
                  activeColor: Theme.of(context).backgroundColor,
                ),
              )),
    );
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*------------------------------------------------_buildBackIcon------------------------------------------------ */
/*-------------------------------------------------------------------------------------------------------------- */
  // Widget _buildBackIcon() {
  //   return IconButton(
  //       onPressed: () {
  //         Navigator.pop(context);
  //       },
  //       icon: Icon(
  //           IconData(0xe80d,
  //               fontFamily: Overrides.kFontFam,
  //               fontPackage: Overrides.kFontPkg),
  //           size: Globals.deviceType == 'phone' ? 24 : 32,
  //           color: AppTheme.kButtonColor));
  // }

/*-------------------------------------------------------------------------------------------------------------- */
/*------------------------------------------------trackUserActivity--------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  void trackUserActivity() {
    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        "pbis_plus_edit_behavior_screen");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'pbis_plus_edit_behavior_screen',
        screenClass: 'PBISPlusEditSkills');
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*--------------------------------------------------_buildHeader------------------------------------------------ */
/*-------------------------------------------------------------------------------------------------------------- */
  Widget buildTargetBehaviorWidget() {
    return ValueListenableBuilder(
        valueListenable: PBISPlusOverrides.isCustomBehavior,
        builder: (context, value, _) => Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            color: Theme.of(context).backgroundColor,
            child: Column(children: [
              Container(
                  // width: MediaQuery.of(context).size.height * 0.80,
                  decoration: BoxDecoration(
                      color: AppTheme.kButtonColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0))),
                  padding:
                      EdgeInsets.only(left: 16, top: 16, bottom: 16, right: 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Utility.textWidget(
                            textAlign: TextAlign.center,
                            context: context,
                            text: PBISPlusOverrides.isCustomBehavior.value
                                ? "Teacher Behaviors"
                                : "School Behaviors",
                            textTheme: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(
                                    color: Color(0xff000000) ==
                                            Theme.of(context).backgroundColor
                                        ? Color(0xffFFFFFF)
                                        : Color(0xff000000),
                                    fontWeight: FontWeight.bold)),
                        _buildToggleButton()
                      ])),
              SpacerWidget(18),
              BlocConsumer<PBISPlusBloc, PBISPlusState>(
                  bloc: PBISPlusOverrides.isCustomBehavior.value
                      ? pbisPluCustomBehaviorBloc
                      : pbisPluDefaultBehaviorBloc,
                  builder: (context, state) {
                    if (state is PBISPlusGetDefaultSchoolBehaviorSuccess) {
                      return buildUsedBehaviors(
                          state.defaultSchoolBehaviorList, false);
                    }

                    if (state is PBISPlusGetTeacherCustomBehaviorSuccess) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        PBISPlusOverrides.teacherCustomBehaviorList.value =
                            state.teacherCustomBehaviorList;
                      });

                      return ValueListenableBuilder(
                          valueListenable: updateBehaviorWidget,
                          builder: (context, value, _) {
                            return ValueListenableBuilder(
                                valueListenable:
                                    PBISPlusOverrides.teacherCustomBehaviorList,
                                builder: (context, value, _) {
                                  return buildUsedBehaviors(
                                      PBISPlusOverrides
                                          .teacherCustomBehaviorList.value,
                                      false);
                                });
                          });
                    }

                    if (state is PBISPlusBehaviorLoading) {
                      return buildUsedBehaviors(state.demoBehaviorData, true);
                    }

                    return _noDataFoundWidget();
                  },
                  listener: (context, state) async {
                    if (state is PBISPlusGetTeacherCustomBehaviorSuccess) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        updateAdditionalBehaviorWidget.value =
                            !updateAdditionalBehaviorWidget.value;
                        isWaitIndex.value = -1;
                      });
                      if (state.caughtError != null) {
                        notifyUser(msg: state.caughtError);
                      }
                    }

                    if (state is PBISPlusGetDefaultSchoolBehaviorSuccess) {
                      if (state.caughtError != null) {
                        notifyUser(msg: state.caughtError);
                      }
                    }
                  })
            ])));
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*------------------------------------------------_noDataFoundWidget-------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  Widget _noDataFoundWidget() {
    return Container(
        height: MediaQuery.of(context).size.height / 5,
        margin: EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Utility.textWidget(
            text: 'Behavior Not Found',
            context: context,
            textAlign: TextAlign.center,
            textTheme:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16)));
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*--------------------------------------------------buildBehaviors---------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  Widget buildUsedBehaviors(
      List<PBISPlusCommonBehaviorModal> skillsList, bool loading) {
    return IgnorePointer(
      ignoring: !PBISPlusOverrides.isCustomBehavior.value,
      child: DragTarget<PBISPlusCommonBehaviorModal>(
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
                //Build behaviors from API
                if (index < skillsList.length) {
                  final item = skillsList[index];
                  return ValueListenableBuilder(
                      valueListenable: isWaitIndex,
                      builder: (context, value, _) {
                        var isWaitCurrentBehviour = isWaitIndex.value == index;

                        return individualBehaviorTargetBuilder(index,
                            skillsList, item, loading, isWaitCurrentBehviour);
                      });
                }
                //Build behaviors placeholder
                else {
                  return buildBehaviorPlaceholderWidget();
                }
              });
        },
        onWillAccept: (draggedData) {
          return !IsBehaviorAlreadyAvailable(draggedData!, skillsList);
        },
        onAccept: (PBISPlusCommonBehaviorModal draggedData) {
          if (skillsList.length == 6) {
            return;
          }
          PBISPlusCommonBehaviorModal onAcceptedObj =
              PBISPlusCommonBehaviorModal(
                  behaviorTitleC: draggedData.behaviorTitleC,
                  pBISBehaviorIconURLC: draggedData.pBISBehaviorIconURLC);

          if (skillsList.length < 6) {
            //To chekck the new adding place index for loading
            isWaitIndex.value = skillsList.length;
            PBISPlusOverrides.teacherCustomBehaviorList.value
                .add(onAcceptedObj);

            // updateAdditinalBehviour(isShow: false, item: onAcceptedObj);
            pbisPluCustomBehaviorBloc
                .add(PBISPlusAddAndUpdateTeacherCustomBehavior(
              behavior: onAcceptedObj,
            ));
          }
        },
      ),
    );
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*---------------------------------------------------_buildIcons------------------------------------------------ */
/*-------------------------------------------------------------------------------------------------------------- */
  Widget _buildIcons({required PBISPlusCommonBehaviorModal item}) {
    return item.behaviorTitleC == "Add behavior"
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
                  fit: BoxFit.contain,
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

  Widget _showEditIconWidget(
    PBISPlusCommonBehaviorModal item,
    int index,
  ) {
    return GestureDetector(
        onTap: () async {
          await _modalBottomSheetMenu(
              item: item,
              index: index,
              //  pbisPlusBloc: pbisPlusClassroomBloc,
              onDelete: () {
                // Navigator.pop(context);

                showDeletePopup(
                    message:
                        "You are about to delete the ${item.behaviorTitleC} behavior. Continue?",
                    title: "",
                    item: item);
              },
              onEditCallBack: (String? editedName) {
                // Navigator.pop(context);
                if (editedName != null && editedName.isNotEmpty) {
                  //update the current obj with new name
                  item.behaviorTitleC = editedName;
                  //update the the Ui list with new name
                  PBISPlusOverrides.teacherCustomBehaviorList.value[index] =
                      item;
                  updateBehaviorWidget.value = !updateBehaviorWidget.value;

                  pbisPluCustomBehaviorBloc.add(
                      PBISPlusAddAndUpdateTeacherCustomBehavior(
                          behavior: item, index: index));
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
                            offset: Offset(0, 3))
                      ]),
                  child: Icon(Icons.edit,
                      size: Globals.deviceType == 'phone' ? 24 : 32,
                      color: AppTheme.klistTileSecoandryDark)),
              SpacerWidget(16)
            ]));
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*------------------------------------------_buildAdditionalBehavior------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  Widget _buildAdditionalBehaviorWidget() {
    return ValueListenableBuilder(
        valueListenable: PBISPlusOverrides.isCustomBehavior,
        builder: (context, value, _) => PBISPlusOverrides.isCustomBehavior.value
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
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Utility.textWidget(
                                        text: 'Additional Behaviors',
                                        context: context,
                                        textAlign: TextAlign.center,
                                        textTheme: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .copyWith(
                                                fontWeight: FontWeight.bold)),
                                    Utility.textWidget(
                                        textAlign: TextAlign.left,
                                        text: 'Hold and drag',
                                        context: context,
                                        textTheme: Theme.of(context)
                                            .textTheme
                                            .bodySmall)
                                  ])),
                          SpacerWidget(16),
                          BlocConsumer(
                              bloc: pbisPluAdditionalBehaviorBloc,
                              builder: (context, state) {
                                if (state
                                        is PBISPlusAdditionalBehaviorSuccess &&
                                    state.additionalBehaviorList.isNotEmpty) {
                                  //Comparing the current behaviour list and additional list to show/hide the additional behavior icons
                                  for (PBISPlusCommonBehaviorModal customItem
                                      in PBISPlusOverrides
                                          .teacherCustomBehaviorList.value) {
                                    for (PBISPlusCommonBehaviorModal additionalItem
                                        in state.additionalBehaviorList) {
                                      if (customItem.pBISBehaviorIconURLC ==
                                          additionalItem.pBISBehaviorIconURLC) {
                                        additionalItem.activeStatusC = "false";
                                      }
                                    }
                                  }

                                  additionalBehaviorList.value =
                                      state.additionalBehaviorList;

                                  return ValueListenableBuilder(
                                      valueListenable:
                                          updateAdditionalBehaviorWidget,
                                      builder: (context, value, _) {
                                        return ValueListenableBuilder(
                                            valueListenable:
                                                additionalBehaviorList,
                                            builder: (context, value, _) {
                                              return _buildAdditionalBehaviorList(
                                                  additionalBehaviorList.value
                                                      .where((item) =>
                                                          item.activeStatusC !=
                                                          'false')
                                                      .toList(),
                                                  false);
                                            });
                                      });
                                }

                                if (state is PBISPlusBehaviorLoading) {
                                  return _buildAdditionalBehaviorList(
                                      state.demoBehaviorData, true);
                                }
                                return _noDataFoundWidget();
                              },
                              listener: (context, state) async {
                                // if (state
                                //         is PBISPlusAdditionalBehaviorSuccess &&
                                //     state.additionalBehaviorList.isNotEmpty) {

                                //   for (PBISPlusCommonBehaviorModal customItem
                                //       in teacherCustomBehaviorList.value) {
                                //     for (PBISPlusCommonBehaviorModal additionalItem
                                //         in state.additionalBehaviorList) {
                                //       if (customItem.pBISBehaviorIconURLC ==
                                //           additionalItem.pBISBehaviorIconURLC) {
                                //         additionalItem.activeStatusC = "false";
                                //       }
                                //     }
                                //   }

                                //   additionalBehaviorList.value =
                                //       state.additionalBehaviorList;
                                // }
                              }),
                          SpacerWidget(18)
                        ])))
            : SizedBox.shrink());
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*---------------------------------------------_buildAdditionalBehaviorList------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  Widget _buildAdditionalBehaviorList(
      List<PBISPlusCommonBehaviorModal> skillsList, bool loading) {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: ValueListenableBuilder(
                valueListenable: isWaitIndex,
                builder: (context, value, _) {
                  return IgnorePointer(
                      ignoring: isWaitIndex.value != -1,
                      child: RawScrollbar(
                          isAlwaysShown: true,
                          controller: _gridController,
                          // minThumbLength: 30,
                          thickness: 8,
                          padding: EdgeInsets.only(left: 32, right: 16),
                          radius: Radius.circular(8),
                          thumbColor: AppTheme.kButtonColor,
                          child: GridView.builder(
                              controller: _gridController,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(right: 32, left: 0),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 0.9,
                                  // Adjust this value to change item aspect ratio
                                  crossAxisSpacing: 0.0,
                                  // Adjust the spacing between items horizontally
                                  mainAxisSpacing: 4.0
                                  // Adjust the spacing between items vertically
                                  ),
                              itemCount: skillsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                PBISPlusCommonBehaviorModal item =
                                    skillsList[index];
                                // final isIconDisabled = IsItemExits(item);
                                return _buildEditSkillIcon(item, false);
                              })));
                })));
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*------------------------------------------------_buildEditSkillIcon------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  Widget _buildEditSkillIcon(
    PBISPlusCommonBehaviorModal item,
    isIconDisabled,
  ) {
    return Draggable(
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
                  padding: const EdgeInsets.all(2.0),
                  child: isIconDisabled
                      ? Opacity(opacity: 0.2, child: _buildIcons(item: item))
                      : _buildIcons(item: item)))),
      feedback:
          Container(width: 80, height: 80, child: _buildIcons(item: item)),
      childWhenDragging: Container(),
      onDragCompleted: () {
        //This call will hide the replaced icon from additional list
        updateAdditinalBehviourStatus(isShow: false, item: item);
      },
      onDragStarted: () {
        changedIndex.value = -1;
      },
    );
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*-----------------------------------------------_modalBottomSheetMenu------------------------------------------ */
/*-------------------------------------------------------------------------------------------------------------- */
  _modalBottomSheetMenu(
          {required PBISPlusCommonBehaviorModal item,
          required int index,
          // required PBISPlusBloc pbisPlusBloc,
          required final VoidCallback onDelete,
          required void Function(String) onEditCallBack}) =>
      showModalBottomSheet(
          useRootNavigator: true,
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
                  index: index,
                  constraints: constraints.maxHeight,
                  item: item,
                  height: MediaQuery.of(context).size.height * 0.35,
                  onDelete: onDelete,
                  onEditCallBack: onEditCallBack);
            });
          });

/*-------------------------------------------------------------------------------------------------------------- */
/*-----------------------------------------------Main Method---------------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Stack(children: [
          CommonBackgroundImgWidget(),
          Scaffold(
              backgroundColor: Colors.transparent,
              appBar: PBISPlusAppBar(
                  refresh: (v) {
                    setState(() {});
                  },
                  titleIconData: widget.titleIconData,
                  title: "",
                  backButton: true,
                  scaffoldKey: _scaffoldKey),
              body: body(context))
        ]));
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*---------------------------------------------showDeletePopup-------------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  showDeletePopup(
      {required String message,
      required String? title,
      PBISPlusCommonBehaviorModal? item,
      PBISPlusBloc? pbisPlusClassroomBloc}) async {
    var isDeleteTapped = await Navigator.of(context).push(HeroDialogRoute(
        builder: (context) => PBISPlusDeleteBehaviorPopup(
            constraint: widget.constraint ?? 0,
            item: item!,
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
              //Deleting the selected behavior from database
              for (int i = 0;
                  i < PBISPlusOverrides.teacherCustomBehaviorList.value.length;
                  i++) {
                if (PBISPlusOverrides.teacherCustomBehaviorList.value[i].id ==
                    item.id) {
                  PBISPlusOverrides.teacherCustomBehaviorList.value.removeAt(i);
                  break;
                }
              }
              //This call will show the replaced icon from additional list
              updateAdditinalBehviourStatus(isShow: true, item: item);

              //Updating the same deleted behavior API to the API
              pbisPluCustomBehaviorBloc
                  .add(PBISPlusDeleteTeacherCustomBehavior(behavior: item));
              updateBehaviorWidget.value = !updateBehaviorWidget.value;

              Navigator.pop(context);
            })));
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*--------------------------------------------------behaviorBuilder--------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */

  Widget individualBehaviorTargetBuilder(
      int index,
      List<PBISPlusCommonBehaviorModal> skillsList,
      PBISPlusCommonBehaviorModal item,
      loading,
      isWaitCurrentBehviour) {
    return skillsList.length >= 6
        ? DragTarget<PBISPlusCommonBehaviorModal>(onWillAccept: (draggedData) {
            return !IsBehaviorAlreadyAvailable(draggedData!, skillsList);
          }, onAccept: (PBISPlusCommonBehaviorModal draggedData) {
            if (skillsList.length != 6) {
              return;
            }
//To manage loading index at the time of replacing
            isWaitIndex.value = index;
            PBISPlusCommonBehaviorModal onAcceptedObj = draggedData;
            PBISPlusCommonBehaviorModal currentDraggedObj = item;
            //This call will show the existing icon from additional list which is replaced from the new icon
            updateAdditinalBehviourStatus(
              isShow: true,
              item: currentDraggedObj,
            );

            // currentDraggedObj.behaviorTitleC = onAcceptedObj.behaviorTitleC;

            currentDraggedObj.pBISBehaviorIconURLC =
                onAcceptedObj.pBISBehaviorIconURLC;

            pbisPluCustomBehaviorBloc.add(
                PBISPlusAddAndUpdateTeacherCustomBehavior(
                    index: index, behavior: currentDraggedObj));

            PBISPlusOverrides.teacherCustomBehaviorList.value[index] =
                currentDraggedObj;
            updateBehaviorWidget.value = !updateBehaviorWidget.value;
          }, builder: (context, candidateData, rejectedData) {
            //Targeting Icons
            return behaviourIconBuilder(
                index, skillsList, item, loading, isWaitCurrentBehviour);
          })
        //Targeting Card
        : behaviourIconBuilder(
            index, skillsList, item, loading, isWaitCurrentBehviour);
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*--------------------------------------------buildBehaviorPlaceholderWidget------------------------------------ */
/*-------------------------------------------------------------------------------------------------------------- */
  Widget buildBehaviorPlaceholderWidget() {
    final item = PBISPlusCommonBehaviorModal(
        behaviorTitleC: "Add behavior",
        pBISBehaviorIconURLC: "assets/Pbis_plus/add_icon.svg");
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Container(height: 40, width: 40, child: _buildIcons(item: item)),
      SpacerWidget(4),
      ShimmerLoading(
          isLoading: false,
          child: Padding(
              padding: Globals.deviceType != 'phone'
                  ? const EdgeInsets.only(top: 10, left: 10)
                  : EdgeInsets.zero,
              child: Utility.textWidget(
                  text: item.behaviorTitleC!,
                  context: context,
                  textTheme: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 12))))
    ]);
  }

/*-------------------------------------------------------------------------------------------------------------- */
/*----------------------------------------------IsBehaviorAlreadyAvailable-------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------- */
  bool IsBehaviorAlreadyAvailable(PBISPlusCommonBehaviorModal draggedData,
      List<PBISPlusCommonBehaviorModal> skillsList) {
    try {
      for (PBISPlusCommonBehaviorModal behavioural in skillsList) {
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
//-------------------------------------------

  void updateAdditinalBehviourStatus(
      {required bool isShow, required PBISPlusCommonBehaviorModal item}) {
    additionalBehaviorList.value.forEach((element) {
      if (element.pBISBehaviorIconURLC == item.pBISBehaviorIconURLC) {
        element.activeStatusC = isShow ? "" : "false";
      }
    });

    updateAdditionalBehaviorWidget.value =
        !updateAdditionalBehaviorWidget.value;
  }

//-------------------------------------------
  void notifyUser({String? msg}) {
    if (msg != null) {
      msg = 'something went wrong, Try again later';
    }

    Utility.currentScreenSnackBar(msg ?? 'Please Wait ...', null);
  }
  //-------------------------------------------

  Widget behaviourIconBuilder(
      int index,
      List<PBISPlusCommonBehaviorModal> skillsList,
      PBISPlusCommonBehaviorModal item,
      loading,
      isWaitCurrentBehviour) {
    return GestureDetector(
        onTap: () {
          if (isWaitIndex.value != -1) {
            notifyUser();
            return;
          }
          changedIndex.value = index;
        },
        child: ValueListenableBuilder(
            valueListenable: changedIndex,
            builder: (context, value, _) => ValueListenableBuilder(
                valueListenable: changedIndex,
                builder: (context, value, _) {
                  return index == changedIndex.value &&
                          PBISPlusOverrides.isCustomBehavior.value == true
                      ? _showEditIconWidget(item, index)
                      : ShimmerLoading(
                          isLoading: loading,
                          child: Opacity(
                            opacity: isWaitCurrentBehviour == true ? 0.3 : 1,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                          height: 40,
                                          width: 40,
                                          child: _buildIcons(item: item)),
                                      if (isWaitCurrentBehviour == true)
                                        Align(
                                            child: CircularProgressIndicator
                                                .adaptive(
                                          backgroundColor:
                                              AppTheme.kButtonColor,
                                        ))
                                    ],
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
                                                  .copyWith(fontSize: 12))))
                                ]),
                          ));
                })));
  }
}
