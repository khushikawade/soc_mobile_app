// ignore_for_file: deprecated_member_use

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/services/user_profile.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_bottomnavbar.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
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
  PersistentTabController? pBISPlusPersistentTabController;
  final ValueNotifier<bool> _isFABVisible = ValueNotifier(true);

  List<PersistentBottomNavBarItem> PBISPlusPersistentBottomNavBarItems = [];
  GoogleDriveBloc googleDriveBloc = GoogleDriveBloc();

  @override
  void initState() {
    super.initState();
    pBISPlusPersistentTabController = PersistentTabController(initialIndex: 0);

    _checkDriveFolderExistsOrNot();
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose Pbis Plus Section");
    pBISPlusPersistentTabController!.dispose();
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
      controller: pBISPlusPersistentTabController,
      screens:
          PBISBottomNavBar.pbisBuildPersistentScreens(backOnTap: backOnTap),
      onItemSelected: (i) {
        switch (i) {
          case 1:
            _isFABVisible.value = false;
            break;
          case 3: //To go back to the staff screen of standard app
            backOnTap();
            break;
          default:
            _isFABVisible.value = true;
            break;
        }
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

//check drive folder exists or not if not exists create one
  void _checkDriveFolderExistsOrNot() async {
    //FOR PBIS PLUS

    final List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();
    final UserInformation userProfile = _profileData[0];

    googleDriveBloc.add(GetDriveFolderIdEvent(
        fromGradedPlusAssessmentSection: false,
        isReturnState: false,
        token: userProfile.authorizationToken,
        folderName: "SOLVED PBIS+",
        refreshToken: userProfile.refreshToken));
  }

  void backOnTap() {
    //To go back to the staff screen of standard app
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  //  void backOnTap() {
  //   //To go back to the staff screen of standard app
  //   final route = MaterialPageRoute(
  //     builder: (context) => HomePage(
  //       index: 4,
  //     ),
  //   );
  //   Navigator.pushAndRemoveUntil(context, route, (route) => false);
  // }
}
