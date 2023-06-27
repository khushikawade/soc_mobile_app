// // ignore_for_file: must_be_immutable, deprecated_member_use

// import 'package:Soc/src/globals.dart';
// import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
// import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_appbar.dart';
// import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_edit_skills_bottom_sheet.dart';
// import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
// import 'package:Soc/src/overrides.dart';
// import 'package:Soc/src/services/analytics.dart';
// import 'package:Soc/src/services/utility.dart';
// import 'package:Soc/src/styles/theme.dart';
// import 'package:Soc/src/widgets/spacer_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class PBISPlusEditSkills extends StatefulWidget {
//   final double? constraint;
//   PBISPlusEditSkills({
//     Key? key,
//     this.constraint,
//   }) : super(key: key) {}

//   @override
//   State<PBISPlusEditSkills> createState() => _PBISPlusEditSkillsState();
// }

// class _PBISPlusEditSkillsState extends State<PBISPlusEditSkills> {
//   ValueNotifier<int> changedIndex = ValueNotifier<int>(-1);
//   ValueNotifier<bool> isEditMode = ValueNotifier<bool>(false);
//   ValueNotifier<bool> valueChange = ValueNotifier<bool>(false);
//   //For now dynamic type we changes

//   // List<PBISPlusActionInteractionModal> currentBehaviourList =
//   //     PBISPlusActionInteractionModal.pbisPlusActionInteractionIconsNew
//   //         .map((item) {
//   //   return item;
//   // }).toList();

//   static final addSkill = PBISPlusActionInteractionModal(
//     imagePath: "assets/Pbis_plus/add_icon.svg",
//     title: 'Add Skill',
//     color: Colors.red,
//   );

//   ValueNotifier<List<PBISPlusActionInteractionModal>> behaviourIcons =
//       ValueNotifier<List<PBISPlusActionInteractionModal>>([
//     PBISPlusActionInteractionModal.pbisPlusActionInteractionIconsNew[0],
//     PBISPlusActionInteractionModal.pbisPlusActionInteractionIconsNew[1],
//     addSkill,
//     addSkill,
//     addSkill,
//     addSkill
//   ]);

//   int nonAddSkillCount = -1;

//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     trackUserActivity();
//   }

// /*-------------------------------------------------------------------------------------------------------------- */
// /*------------------------------------------------trackUserActivity--------------------------------------------- */
// /*-------------------------------------------------------------------------------------------------------------- */
//   void trackUserActivity() {
//     FirebaseAnalyticsService.addCustomAnalyticsEvent(
//         "pbis_plus_edit_behaviour_screen");
//     FirebaseAnalyticsService.setCurrentScreen(
//         screenTitle: 'pbis_plus_edit_behaviour_screen',
//         screenClass: 'PBISPlusEditSkills');
//     /*-------------------------------------------------------------------------------------*/
//     // Utility.updateLogs(
//     //     activityType: widget.isFromStudentPlus == true ? 'STUDENT+' : 'PBIS+',
//     //     activityId: '37',
//     //     description:
//     //         'Student ${widget.studentValueNotifier.value.profile!.name} Card View',
//     //     operationResult: 'Success');
//   }

// /*-------------------------------------------------------------------------------------------------------------- */
// /*--------------------------------------------------_buildHeader------------------------------------------------ */
// /*-------------------------------------------------------------------------------------------------------------- */
//   Widget _buildHeader() {
//     return Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         margin: EdgeInsets.symmetric(
//             horizontal: MediaQuery.of(context).size.width * 0.05),
//         color: Theme.of(context).backgroundColor,
//         child: Column(children: [
//           Container(
//               width: MediaQuery.of(context).size.height * 0.80,
//               decoration: BoxDecoration(
//                 color: AppTheme.kButtonColor,
//                 borderRadius: BorderRadius.only(
//                   topRight: Radius.circular(8.0),
//                   topLeft: Radius.circular(8.0),
//                 ),
//               ),
//               padding: EdgeInsets.all(16),
//               child: Text("Edit Behaviours",
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context).textTheme.headline5!.copyWith(
//                       color:
//                           Color(0xff000000) == Theme.of(context).backgroundColor
//                               ? Color(0xffFFFFFF)
//                               : Color(0xff000000),
//                       fontWeight: FontWeight.bold))),
//           SpacerWidget(18),
//           additionalBehaviourList()
//         ]));
//   }

// /*-------------------------------------------------------------------------------------------------------------- */
// /*----------------------------------------------------BODY FRAME------------------------------------------------ */
// /*-------------------------------------------------------------------------------------------------------------- */
//   Widget body(BuildContext context) {
//     return Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(
//                 IconData(0xe80d,
//                     fontFamily: Overrides.kFontFam,
//                     fontPackage: Overrides.kFontPkg),
//                 size: Globals.deviceType == 'phone' ? 24 : 32,
//                 color: AppTheme.kButtonColor),
//           ),
//           SpacerWidget(18),
//           _buildHeader(),
//           SpacerWidget(18),
//           _buildAdditionalBehaviour(),
//           SpacerWidget(30)
//         ]);
//   }

// /*-------------------------------------------------------------------------------------------------------------- */
// /*------------------------------------------additionalBehaviourList--------------------------------------------- */
// /*-------------------------------------------------------------------------------------------------------------- */
//   Widget additionalBehaviourList() {
//     return Container(
//         child: DragTarget<PBISPlusActionInteractionModal>(
//             builder: (context, candidateData, rejectedData) {
//               return GridView.builder(
//                 shrinkWrap: true,
//                 padding: EdgeInsets.zero,
//                 physics: NeverScrollableScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   childAspectRatio: 1.5,
//                   // Adjust this value to change item aspect ratio
//                   crossAxisSpacing: 4.0,
//                   // Adjust the spacing between items horizontally
//                   mainAxisSpacing: 4.0,
//                   // Adjust the spacing between items vertically
//                 ),
//                 itemCount: (PBISPlusActionInteractionModal
//                     .pbisPlusActionInteractionIconsNew.length),
//                 itemBuilder: (BuildContext context, int index) {
//                   final item = behaviourIcons.value[index];
//                   nonAddSkillCount = index;
//                   return GestureDetector(
//                       onTap: () {
//                         isEditMode.value = true;
//                         changedIndex.value = index;
//                       },
//                       child: ValueListenableBuilder(
//                           valueListenable: changedIndex,
//                           builder: (context, value, _) =>
//                               ValueListenableBuilder(
//                                 valueListenable: isEditMode,
//                                 builder: (context, value, _) => index ==
//                                         changedIndex.value
//                                     ? _buildEditWidget(item)
//                                     : Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: <Widget>[
//                                           Draggable(
//                                               data: item,
//                                               child: Container(
//                                                   height: 40,
//                                                   width: 40,
//                                                   child: SvgPicture.asset(
//                                                       item.imagePath,
//                                                       fit: BoxFit.contain)),
//                                               feedback: Container(
//                                                   height: 40,
//                                                   width: 40,
//                                                   child: SvgPicture.asset(
//                                                       item.imagePath,
//                                                       fit: BoxFit.contain)),
//                                               childWhenDragging: Container(
//                                                   height: 40,
//                                                   width: 40,
//                                                   child: SvgPicture.asset(
//                                                       item.imagePath,
//                                                       fit: BoxFit.contain))),
//                                           SpacerWidget(4),
//                                           Padding(
//                                             padding:
//                                                 Globals.deviceType != 'phone'
//                                                     ? const EdgeInsets.only(
//                                                         top: 10, left: 10)
//                                                     : EdgeInsets.zero,
//                                             child: Utility.textWidget(
//                                                 text: item.title,
//                                                 context: context,
//                                                 textTheme: Theme.of(context)
//                                                     .textTheme
//                                                     .bodyText1!
//                                                     .copyWith(fontSize: 12)),
//                                           )
//                                         ],
//                                       ),
//                               )));
//                 },
//               );
//             },
//             onWillAccept: (PBISPlusActionInteractionModal? iconData) {
//               return true;
//             },
//             onAccept: (PBISPlusActionInteractionModal? iconData) {
//               print(iconData?.title);
//               if (behaviourIcons.value.contains(iconData)) {
//               } else {
//                 behaviourIcons.value[nonAddSkillCount!] = iconData!;
//                 changedIndex.value = -1;
//               }
//               setState(() {});
//             },
//             onAcceptWithDetails:
//                 (DragTargetDetails<PBISPlusActionInteractionModal> details) {
//               final item = details.data;
//             },
//             onMove: (details) {},
//             onLeave: (PBISPlusActionInteractionModal? iconData) {
//               print("INSIDE THE ON LEAVE ");
//             }));
//   }

// /*-------------------------------------------------------------------------------------------------------------- */
// /*---------------------------------------------_buildEditWidget------------------------------------------------- */
// /*-------------------------------------------------------------------------------------------------------------- */
// //Used to show edit icon on selecting any current behaviour
//   Widget _buildEditWidget(PBISPlusActionInteractionModal item) {
//     return GestureDetector(
//         onTap: () async {
//           changedIndex.value = -1;
//           await _modalBottomSheetMenu(item);
//         },
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                   width: 54,
//                   height: 54,
//                   decoration: BoxDecoration(
//                       color: AppTheme.kButtonColor,
//                       borderRadius: BorderRadius.circular(8.0),
//                       boxShadow: [
//                         BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 2,
//                             blurRadius: 5,
//                             offset: Offset(0, 3))
//                       ]),
//                   child: Icon(Icons.edit,
//                       size: Globals.deviceType == 'phone' ? 24 : 32,
//                       color: AppTheme.klistTileSecoandryDark))
//             ]));
//   }

// /*-------------------------------------------------------------------------------------------------------------- */
// /*------------------------------------------_buildAdditionalBehaviour------------------------------------------- */
// /*-------------------------------------------------------------------------------------------------------------- */
//   Widget _buildAdditionalBehaviour() {
//     return Expanded(
//         child: Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16.0),
//             ),
//             margin: EdgeInsets.symmetric(
//                 horizontal: MediaQuery.of(context).size.width * 0.05),
//             color: Theme.of(context).backgroundColor,
//             child: Column(
//                 // physics: NeverScrollableScrollPhysics(),
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 16, left: 16),
//                     child: Text(
//                       "Additional Behaviors",
//                       textAlign: TextAlign.center,
//                       style: Theme.of(context).textTheme.headline1!.copyWith(),
//                     ),
//                   ),
//                   SpacerWidget(16),
//                   Expanded(
//                       child: ValueListenableBuilder(
//                           valueListenable: behaviourIcons,
//                           builder: (context, value, _) => Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               child: GridView.builder(
//                                   shrinkWrap: true,
//                                   padding: EdgeInsets.zero,
//                                   physics: BouncingScrollPhysics(),
//                                   // physics: NeverScrollableScrollPhysics(),
//                                   gridDelegate:
//                                       SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 4,
//                                     childAspectRatio:
//                                         0.9, // Adjust this value to change item aspect ratio
//                                     crossAxisSpacing:
//                                         0.0, // Adjust the spacing between items horizontally
//                                     mainAxisSpacing:
//                                         4.0, // Adjust the spacing between items vertically
//                                   ),
//                                   itemCount: 3 *
//                                       PBISPlusActionInteractionModal
//                                           .pbisPlusActionInteractionIconsNew
//                                           .length
//                                           .ceil(),
//                                   itemBuilder:
//                                       (BuildContext context, int index) {
//                                     final item = PBISPlusActionInteractionModal
//                                             .pbisPlusActionInteractionIconsNew[
//                                         index % 6];
//                                     final isIconDisabled =
//                                         behaviourIcons.value.contains(item);
//                                     return isIconDisabled
//                                         ? _buildAdditionalBehaviourNonDraggableIcons(
//                                             item, isIconDisabled)
//                                         : _buildAdditionalBehaviourDraggableIcons(
//                                             item, isIconDisabled);
//                                   })))),
//                   SpacerWidget(18)
//                 ])));
//   }

// /*---------------------------------------------------------------------------------------------------------------*/
// /*------------------------------------_buildAdditionalBehaviourNonDraggableIcons---------------------------------*/
// /*---------------------------------------------------------------------------------------------------------------*/
//   Widget _buildAdditionalBehaviourNonDraggableIcons(item, isIconDisabled) {
//     return Container(
//         width: 40,
//         height: 40,
//         margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//             color: Theme.of(context).backgroundColor,
//             borderRadius: BorderRadius.circular(8),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.grey.withOpacity(0.4),
//                   spreadRadius: 0,
//                   blurRadius: 1,
//                   offset: Offset(0, 0))
//             ]),
//         child: Center(
//             child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Opacity(
//                     opacity: 0.2, child: SvgPicture.asset(item.imagePath)))));
//   }

// /*-------------------------------------------------------------------------------------------------------------- */
// /*----------------------------------------_buildAdditionalBehaviourIcons---------------------------------------- */
// /*-------------------------------------------------------------------------------------------------------------- */
//   Widget _buildAdditionalBehaviourDraggableIcons(item, isIconDisabled) {
//     return Draggable(
//       data: item,
//       ignoringFeedbackPointer: !isIconDisabled,
//       child: Container(
//           width: 40,
//           height: 40,
//           margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//           padding: EdgeInsets.all(8),
//           decoration: BoxDecoration(
//               color: Theme.of(context).backgroundColor,
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.grey.withOpacity(0.4),
//                     spreadRadius: 0,
//                     blurRadius: 1,
//                     offset: Offset(0, 0))
//               ]),
//           child: Center(
//               child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: isIconDisabled
//                       ? Opacity(
//                           opacity: 0.2, child: SvgPicture.asset(item.imagePath))
//                       : SvgPicture.asset(item.imagePath)))),
//       feedback:
//           isIconDisabled ? SizedBox.shrink() : SvgPicture.asset(item.imagePath),
//       childWhenDragging:
//           isIconDisabled ? SizedBox.shrink() : SvgPicture.asset(item.imagePath),
//     );
//   }

// /*-------------------------------------------------------------------------------------------------------------- */
// /*-------------------------------------------_modalBottomSheetMenu---------------------------------------------- */
// /*-------------------------------------------------------------------------------------------------------------- */
//   _modalBottomSheetMenu(PBISPlusActionInteractionModal item) =>
//       showModalBottomSheet(
//           clipBehavior: Clip.antiAliasWithSaveLayer,
//           isScrollControlled: true,
//           isDismissible: true,
//           enableDrag: true,
//           backgroundColor: Colors.transparent,
//           elevation: 10,
//           context: context,
//           builder: (BuildContext context) {
//             return LayoutBuilder(
//                 builder: (BuildContext context, BoxConstraints constraints) {
//               return PBISPlusEditSkillsBottomSheet(
//                 behaviourIcons: behaviourIcons,
//                 item: item,
//                 height: MediaQuery.of(context).size.height * 0.35,
//               );
//             });
//           });

// /*-------------------------------------------------------------------------------------------------------------- */
// /*-----------------------------------------------Main Method---------------------------------------------------- */
// /*-------------------------------------------------------------------------------------------------------------- */
//   @override
//   Widget build(BuildContext context) {
//     return Stack(children: [
//       CommonBackgroundImgWidget(),
//       Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: PBISPlusAppBar(
//               title: "", backButton: true, scaffoldKey: _scaffoldKey),
//           body: body(context))
//     ]);
//   }
// }
