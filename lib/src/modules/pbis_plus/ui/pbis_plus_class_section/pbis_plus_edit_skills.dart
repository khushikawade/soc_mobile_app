// ignore_for_file: must_be_immutable

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_student_dashbord.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../widgets/PBISPlus_action_interaction_button.dart';

class PBISPlusEditSkills extends StatefulWidget {
  // ValueNotifier<ClassroomStudents> studentValueNotifier;
  // final bool? isFromDashboardPage;
  // final bool?
  //     isFromStudentPlus; // to check it is from pbis plus or student plus
  // final bool? isLoading; // to maintain loading when user came from student plus
  // final String heroTag;
  // final Key? scaffoldKey;
  // String classroomCourseId;
  final double? constraint;
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

  @override
  State<PBISPlusEditSkills> createState() => _PBISPlusEditSkillsState();
}

class _PBISPlusEditSkillsState extends State<PBISPlusEditSkills> {
  ValueNotifier<bool> valueChange = ValueNotifier<bool>(false);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<bool> isEditMode = ValueNotifier<bool>(false);
  ValueNotifier<int> changedIndex = ValueNotifier<int>(-1);

  @override
  void initState() {
    super.initState();
    trackUserActivity();
    // widget.studentValueNotifier.value = widget.student!;
  }

  Widget _buildHeader() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05),
      color: Colors.white,
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
            // Set the background color for the heading
            padding: EdgeInsets.all(16),
            child: Text(
              "Edit Skills",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SpacerWidget(24),
          ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: (PBISPlusActionInteractionModal
                        .PBISPlusActionInteractionIcons.length /
                    2)
                .ceil(),
            itemBuilder: (BuildContext context, int rowIndex) {
              return Row(
                children: List.generate(
                  3,
                  (int columnIndex) {
                    final index = rowIndex * 3 + columnIndex;
                    if (index >=
                        PBISPlusActionInteractionModalNew
                            .PBISPlusActionInteractionIconsNew.length) {
                      return SizedBox(); // Return an empty SizedBox for excess cells
                    }
                    final item = PBISPlusActionInteractionModalNew
                        .PBISPlusActionInteractionIconsNew[index];
                    return Expanded(
                        child: GestureDetector(
                            onTap: () {
                              isEditMode.value = true;
                              print(isEditMode);
                              changedIndex.value = index;
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
                                              children: [
                                                index == changedIndex.value
                                                    ? Icon(
                                                        Icons.edit,
                                                        size:
                                                            Globals.deviceType ==
                                                                    'phone'
                                                                ? 30
                                                                : 40,
                                                        color: item.color,
                                                      )
                                                    : SvgPicture.asset(
                                                        item.imagePath,
                                                        // height: Globals.deviceType == 'phone' ? 64 : 74,
                                                        // width: Globals.deviceType == 'phone' ? 64 : 74,
                                                      ),
                                                SpacerWidget(4),
                                                Padding(
                                                  padding: Globals.deviceType !=
                                                          'phone'
                                                      ? const EdgeInsets.only(
                                                          top: 10, left: 10)
                                                      : EdgeInsets.zero,
                                                  child: Utility.textWidget(
                                                      text: item.title,
                                                      context: context,
                                                      textTheme: Theme.of(
                                                              context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .copyWith(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 12)),
                                                ),
                                                SpacerWidget(32),
                                              ],
                                            ),
                                    ))));
                  },
                ),
              );
            },
          ),
          // SpacerWidget(18),
        ],
      ),
    );
  }

  Widget _buildEditWidget(item) {
    return GestureDetector(
      onTap: () {
        _modalBottomSheetMenu();
        // PBISPlusEditSkillsBottomSheet();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 60,
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
              size: Globals.deviceType == 'phone' ? 32 : 42,
              color: Colors.white,
            ),
          ),
          SpacerWidget(32),
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
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 16),
              child: Text(
                "Additional Behaviors",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(color: Colors.black),
              ),
            ),
            SpacerWidget(16),
            ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: (PBISPlusActionInteractionModal
                          .PBISPlusActionInteractionIcons.length /
                      2)
                  .ceil(),
              itemBuilder: (BuildContext context, int rowIndex) {
                return Row(
                  children: List.generate(
                    3,
                    (int columnIndex) {
                      final index = (rowIndex * 3 + columnIndex);
                      if (index >=
                          PBISPlusActionInteractionModalNew
                              .PBISPlusActionInteractionIconsNew.length) {
                        return SizedBox
                            .shrink(); // Return an empty SizedBox for excess cells
                      }
                      final item = PBISPlusActionInteractionModalNew
                          .PBISPlusActionInteractionIconsNew[index];
                      return Expanded(
                        child: Container(
                          width: 40,
                          height: 80,
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 0,
                                blurRadius: 1,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                item.imagePath,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            SpacerWidget(18),
          ],
        ),
      ),
    );
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
        SpacerWidget(16),
        _buildAdditionalBehaviour(),
        SpacerWidget(16),
      ],
    );
  }

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

  void _modalBottomSheetMenu() => showModalBottomSheet(
        // useRootNavigator: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,

        // animationCurve: Curves.easeOutQuart,
        elevation: 10,
        context: context,
        builder: (BuildContext context) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return PBISPlusEditSkillsBottomSheet(
                // fromClassScreen: false,
                // scaffoldKey: _scaffoldKey,
                // screenshotController: screenshotController,
                // headerScreenshotController: headerScreenshotController,
                // googleClassroomCourseworkList: [], //No list is required since no list is used from this bottomsheet
                // content: false,
                height:
                    // constraints.maxHeight < 750 && Globals.deviceType == "phone"
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
}
