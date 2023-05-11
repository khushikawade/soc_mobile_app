import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_plus_bottomnavbar.dart';
import 'package:Soc/src/overrides.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class GradedPlusNavBarHome extends StatefulWidget {
  const GradedPlusNavBarHome({
    Key? key,
  });

  @override
  State<GradedPlusNavBarHome> createState() => _GradedPlusNavBarHomeState();
}

class _GradedPlusNavBarHomeState extends State<GradedPlusNavBarHome> {
  PersistentTabController? gradedPlusPersistentTabController;

  @override
  void initState() {
    super.initState();
    gradedPlusPersistentTabController = PersistentTabController(
        initialIndex: Overrides.STANDALONE_GRADED_APP ? 1 : 2);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    gradedPlusPersistentTabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }

  Widget body() {
    return PersistentTabView(
      context,
      controller: gradedPlusPersistentTabController,
      screens: GradedBottomNavBar.gradedPlusBuildPersistentScreens(),
      onItemSelected: (i) =>
          GradedBottomNavBar.gradedPlusBuildPersistentScreens().length - 1 ==
                      i &&
                  !Overrides.STANDALONE_GRADED_APP
              ? Navigator.of(context).pop()
              : null,

      items: GradedBottomNavBar.gradedPlusnavBarsItems(context: context),
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
          boxShadow: [
            BoxShadow(
              color:
                  Theme.of(context).colorScheme.primaryVariant.withOpacity(0.3),
              blurRadius: 10.0,
            ),
          ]),
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
}
