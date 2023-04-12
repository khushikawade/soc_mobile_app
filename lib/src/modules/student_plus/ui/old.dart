// import 'package:Soc/src/globals.dart';
// import 'package:Soc/src/modules/student_plus/ui/student_plus_exams.dart';
// import 'package:Soc/src/modules/student_plus/ui/student_plus_grades.dart';
// import 'package:Soc/src/modules/student_plus/ui/student_plus_info.dart';
// import 'package:Soc/src/modules/student_plus/ui/student_plus_work.dart';
// import 'package:Soc/src/modules/student_plus/widgets/custom_nav_bar_widget.dart';
// import 'package:Soc/src/overrides.dart';
// import 'package:Soc/src/styles/theme.dart';
// import 'package:Soc/src/translator/translation_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

// class StudentPlusHome extends StatefulWidget {
//   const StudentPlusHome({Key? key}) : super(key: key);

//   @override
//   State<StudentPlusHome> createState() => _StudentPlusHomeState();
// }

// class _StudentPlusHomeState extends State<StudentPlusHome> {
//   static PersistentTabController controller =
//       PersistentTabController(initialIndex: 0);
//   List<PersistentBottomNavBarItem> persistentBottomNavBarItemList = [];
//   final ValueNotifier<int> indexNotifier = ValueNotifier<int>(0);
//   List<Widget> _screens = [];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: body(),
//     );
//   }

//   Widget body() {
//     return PersistentTabView.custom(
//       context,
//       controller: controller,
//       screens: _buildScreens(),

//       // bottomScreenMargin: 100,

// //#222222
//       customWidget: ValueListenableBuilder(
//           valueListenable: indexNotifier,
//           child: Container(),
//           builder: (BuildContext context, dynamic value, Widget? child) {
//             return CustomNavBarWidget(
//               iconColor: Theme.of(context).colorScheme.background,
//               selectedColor: AppTheme.kButtonColor,
//               unSelectedColor: Theme.of(context).colorScheme.background,
//               backgroundColor:
//                   Theme.of(context).colorScheme.background == Color(0xff000000)
//                       ? AppTheme.klistTilePrimaryLight
//                       : AppTheme.klistTilePrimaryDark,
//               items: _navBarsItems(),
//               onItemSelected: ((value) {
//                 controller.index = value;
//                 indexNotifier.value = value;
//               }),
//               selectedIndex: controller.index,
//             );
//           }),

//       itemCount: 4,

//       // hideNavigationBar: true,
//       // onItemSelected: (i) {
//       //   // _controller.index = i;

//       //   setState(() {
//       //     controller.index = i;
//       //     // if (previousIndex == i && Globals.urlIndex == i) {
//       //     //   Globals.webViewController1!.loadUrl(Globals.homeUrl!);
//       //     // }

//       //     // previousIndex = i;
//       //     // // Globals.controller.index = i;
//       //     // // To make sure if the ShowCase is in the progress and user taps on bottom nav bar items so the Showcase should not apear on other pages/
//       //     // Globals.hasShowcaseInitialised.value = true;
//       //     // // New news item indicator
//       //     // if (i == Globals.newsIndex) {
//       //     //   Globals.indicator.value = false;
//       //     // }
//       //   });
//       // },
//       // selectedTabScreenContext: (index){
//       //   Utility.setLocked();
//       // },
//       //   items: _navBarsItems(),

//       confineInSafeArea: true,
//       backgroundColor: Theme.of(context).backgroundColor,
//       handleAndroidBackButtonPress: true,
//       resizeToAvoidBottomInset:
//           true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
//       stateManagement: false, // Default is true.
//       hideNavigationBarWhenKeyboardShows:
//           true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
//       // decoration: NavBarDecoration(
//       //     borderRadius: BorderRadius.only(
//       //       topRight: Radius.circular(25),
//       //       topLeft: Radius.circular(25),
//       //     ),
//       //     // circular(25.0),
//       //     boxShadow: [
//       //       BoxShadow(
//       //         color:
//       //             Theme.of(context).colorScheme.primaryVariant.withOpacity(0.3),
//       //         // Colors.grey,
//       //         blurRadius: 10.0,
//       //       ),
//       //     ]),
//       onWillPop: (context) async {
//         await _onBackPressed();
//         return false;
//       },
//       // popAllScreensOnTapOfSelectedTab: true,

//       // popActionScreens: PopActionScreensType.all,
//       // itemAnimationProperties: ItemAnimationProperties(
//       //   duration: Duration(milliseconds: 200),
//       //   curve: Curves.ease,
//       // ),
//       screenTransitionAnimation: ScreenTransitionAnimation(
//         animateTabTransition: false,
//         curve: Curves.ease,
//         duration: Duration(milliseconds: 200),
//       ),
//       //  navBarStyle: NavBarStyle.,
//       // navBarHeight: Globals.deviceType == "phone" ? 60 : 70,
//     );
//   }

//   _onBackPressed() {
//     return showDialog(
//         context: context,
//         builder: (context) =>
//             OrientationBuilder(builder: (context, orientation) {
//               return AlertDialog(
//                 backgroundColor: Theme.of(context).colorScheme.background,
//                 title: Container(
//                   padding: Globals.deviceType == 'phone'
//                       ? null
//                       : const EdgeInsets.only(top: 10.0),
//                   height: Globals.deviceType == 'phone'
//                       ? null
//                       : orientation == Orientation.portrait
//                           ? MediaQuery.of(context).size.height / 15
//                           : MediaQuery.of(context).size.width / 15,
//                   width: Globals.deviceType == 'phone'
//                       ? null
//                       : orientation == Orientation.portrait
//                           ? MediaQuery.of(context).size.width / 2
//                           : MediaQuery.of(context).size.height / 2,
//                   child: TranslationWidget(
//                       message: "Do you want to exit the app?",
//                       fromLanguage: "en",
//                       toLanguage: Globals.selectedLanguage,
//                       builder: (translatedMessage) {
//                         return Text(translatedMessage.toString(),
//                             style: Theme.of(context).textTheme.headline2!);
//                       }),
//                 ),
//                 actions: <Widget>[
//                   TextButton(
//                       onPressed: () => Navigator.pop(context, false),
//                       child: Container(
//                         padding: Globals.deviceType != 'phone'
//                             ? EdgeInsets.only(bottom: 10.0, right: 10.0)
//                             : EdgeInsets.all(0),
//                         child: TranslationWidget(
//                             message: "No",
//                             fromLanguage: "en",
//                             toLanguage: Globals.selectedLanguage,
//                             builder: (translatedMessage) {
//                               return Text(translatedMessage.toString(),
//                                   style:
//                                       Theme.of(context).textTheme.headline2!);
//                             }),
//                       )),
//                   TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: Container(
//                           padding: Globals.deviceType != 'phone'
//                               ? EdgeInsets.only(bottom: 10.0, right: 10.0)
//                               : EdgeInsets.all(0.0),
//                           child: TranslationWidget(
//                               message: "Yes",
//                               fromLanguage: "en",
//                               toLanguage: Globals.selectedLanguage,
//                               builder: (translatedMessage) {
//                                 return Text(translatedMessage.toString(),
//                                     style:
//                                         Theme.of(context).textTheme.headline2!);
//                               })))
//                 ],
//               );
//             }));
//   }

//   List<PersistentBottomNavBarItem> _navBarsItems() {
//     persistentBottomNavBarItemList = [];
//     persistentBottomNavBarItemList.add(PersistentBottomNavBarItem(
//         icon: Icon(
//           const IconData(0xe804,
//               fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
//         ),
//         title: 'Info'));
//     persistentBottomNavBarItemList.add(PersistentBottomNavBarItem(
//         icon: Icon(
//           const IconData(0xe87c,
//               fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
//         ),
//         title: 'Exams'));
//     persistentBottomNavBarItemList.add(PersistentBottomNavBarItem(
//         icon: Icon(
//           const IconData(0xe862,
//               fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
//         ),
//         title: 'Grades'));
//     persistentBottomNavBarItemList.add(PersistentBottomNavBarItem(
//         icon: Icon(
//           const IconData(0xe827,
//               fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
//         ),
//         title: 'Work'));
//     return persistentBottomNavBarItemList;
//   }

//   List<Widget> _buildScreens() {
//     _screens = [];
//     _screens.add(StudentPlusInfoScreen());
//     _screens.add(StudentPlusExamsScreen());
//     _screens.add(StudentPlusGradesPage());
//     _screens.add(StudentPlusWorkScreen());
//     return _screens;
//   }
// }
