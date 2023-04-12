import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_bottomnavbar.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_bottom_sheet.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_fab.dart';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class PBISPlusHome extends StatefulWidget {
  const PBISPlusHome({
    Key? key,
  }) : super(key: key);

  @override
  State<PBISPlusHome> createState() => _PBISPlusHomeState();
}

class _PBISPlusHomeState extends State<PBISPlusHome>
    with TickerProviderStateMixin {
  PersistentTabController? PBISPlusPersistentTabController;
  final ValueNotifier<bool> _isFABVisible = ValueNotifier(true);

  List<PersistentBottomNavBarItem> PBISPlusPersistentBottomNavBarItems = [];

  @override
  void initState() {
    super.initState();
    PBISPlusPersistentTabController = PersistentTabController(initialIndex: 0);
  }

  @override
  void dispose() {
    super.dispose();
    PBISPlusPersistentTabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
      // floatingActionButton:
      //     floatingActionButton(context, PBISPlusPersistentTabController),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  // widget show bottom navbar with different list
  Widget body() {
    return PersistentTabView(
      context,
      controller: PBISPlusPersistentTabController,
      screens: PBISBottomNavBar.pbisBuildPersistentScreens(),
      onItemSelected: (i) {
        if (i == 1) {
          _isFABVisible.value = false;
        } else {
          _isFABVisible.value = true;
        }
        if (i == 2) {
          pushNewScreen(context,
              screen: HomePage(
                index: 4,
              ),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino);
        }
        setState(() {});
      },
      items: PBISBottomNavBar.navBarsItems(context: context),
      confineInSafeArea: true,
      backgroundColor: Theme.of(context).backgroundColor,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: false, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color:
        //         Theme.of(context).colorScheme.primaryVariant.withOpacity(0.3),
        //     // Colors.grey,
        //     blurRadius: 10.0,
        //   ),
        // ]
      ),
      onWillPop: (context) async {
        return false; // disable back button on android
      },
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: false,
      ),
      navBarStyle: NavBarStyle.style6,
      navBarHeight: Globals.deviceType == "phone" ? 60 : 70,
    );
  }

  // Widget saveAndShareFAB(BuildContext context,
  //     PersistentTabController? PBISPlusPersistentTabController) {
  //   return ValueListenableBuilder<bool>(
  //       valueListenable: _isFABVisible,
  //       builder: (BuildContext context, bool value, Widget? child) {
  //         return Visibility(
  //           visible: _isFABVisible.value,
  //           child: CustomFloatingActionButton(
  //             onPressed: () {
  //               _modalBottomSheetMenu();
  //               // Navigator.of(context).push(HeroDialogRoute(builder: (context) {
  //               //   return Container();
  //               // }));
  //             },
  //           ),
  //         );
  //       });
  // }

  // void _modalBottomSheetMenu() {
  //   showModalBottomSheet(
  //     clipBehavior: Clip.antiAliasWithSaveLayer,
  //     isScrollControlled: true,
  //     isDismissible: true,
  //     enableDrag: true,
  //     backgroundColor: Colors.transparent,
  //     // animationCurve: Curves.easeOutQuart,
  //     elevation: 10,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return PBISPlusBottomSheet(
  //         height: 250,
  //         title: 'Save and Share',
  //       );
  //     },
  //   );
  // }
}