import 'package:Soc/src/modules/graded_plus/helper/graded_overrides.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_plus_bottomnavbar.dart';
import 'package:Soc/src/modules/graded_plus/widgets/graded_plus_custom_nav_bar_widget.dart';
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
  final ValueNotifier<int> indexNotifier =
      ValueNotifier<int>(Overrides.STANDALONE_GRADED_APP ? 1 : 2);
  @override
  void initState() {
    super.initState();
    gradedPlusPersistentTabController = PersistentTabController(
        initialIndex: Overrides.STANDALONE_GRADED_APP ? 1 : 2);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    gradedPlusPersistentTabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: body(),
    );
  }

  Widget body() {
    return ValueListenableBuilder<bool>(
        valueListenable: OcrOverrides.gradedPlusNavBarIsHide,
        child: Container(),
        builder: (BuildContext context, bool value, Widget? child) {
          return PersistentTabView.custom(context,
              controller: gradedPlusPersistentTabController,
              screens: GradedPlusBottomNavBar.gradedPlusBuildPersistentScreens(
                  backOnTap: backOnTap),
              customWidget: ValueListenableBuilder(
                  valueListenable: indexNotifier,
                  child: Container(),
                  builder:
                      (BuildContext context, dynamic value, Widget? child) {
                    return GradedPlusCustomNavBarWidget(
                      backgroundColor: Theme.of(context).colorScheme.background,
                      items: GradedPlusBottomNavBar.gradedPlusNavbarItems(
                          context: context),
                      onItemSelected: ((value) {
                        gradedPlusPersistentTabController!.index = value;
                        indexNotifier.value = value;

                        if (GradedPlusBottomNavBar
                                            .gradedPlusBuildPersistentScreens(
                                                backOnTap: backOnTap)
                                        .length -
                                    1 ==
                                value &&
                            !Overrides.STANDALONE_GRADED_APP) {
                          backOnTap();
                        }
                      }),
                      selectedIndex: gradedPlusPersistentTabController!.index,
                    );
                  }),
              itemCount:
                  GradedPlusBottomNavBar.gradedPlusBuildPersistentScreens(
                          backOnTap: backOnTap)
                      .length,
              confineInSafeArea: true,
              backgroundColor: Theme.of(context).backgroundColor,
              handleAndroidBackButtonPress: true,
              resizeToAvoidBottomInset:
                  true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
              stateManagement: false, // Default is true.
              // hideNavigationBarWhenKeyboardShows: OcrOverrides
              //     .gradedPlusNavBarIsHide
              //     .value, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.

              onWillPop: (context) async {
            return false;
          },
              screenTransitionAnimation: ScreenTransitionAnimation(
                animateTabTransition: false,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              hideNavigationBar: OcrOverrides.gradedPlusNavBarIsHide.value);
        });
  }

  void backOnTap() {
    //To go back to the staff screen of standard app
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
