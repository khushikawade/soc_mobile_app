import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_bottomnavbar.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class StudentPlusHome extends StatefulWidget {
  final StudentPlusDetailsModel studentPlusStudentInfo;
  final int index;
  const StudentPlusHome(
      {Key? key, required this.studentPlusStudentInfo, required this.index})
      : super(key: key);

  @override
  State<StudentPlusHome> createState() => _StudentPlusHomeState();
}

class _StudentPlusHomeState extends State<StudentPlusHome> {
  final ValueNotifier<int> refreshNavBar = ValueNotifier<int>(0);

  // persistent tab controller use for navigate
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  // final StudentPlusBloc _studentPlusBloc = StudentPlusBloc();

  // list of bottom navigation bar icons
  List<PersistentBottomNavBarItem> persistentBottomNavBarItemList = [];

  // list of screen on navigation
  List<Widget> _screens = [];
  @override
  void initState() {
    _controller.index = widget.index;
    //_studentPlusBloc.add(GetStudentPlusDetails(studentId: widget.studentId));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: body());
  }

  // widget  to show loader while fetching information
  Widget loaderWidget() {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        Center(
          child: CircularProgressIndicator.adaptive(
            backgroundColor: AppTheme.kButtonColor,
          ),
        )
      ],
    );
  }

  // widget show bottom navbar with different list
  Widget body() {
    return ValueListenableBuilder(
        valueListenable: refreshNavBar,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return PersistentTabView(
            context,
            controller: _controller,
            screens: StudentPlusBottomNavBar.buildScreens(
              studentInfo: widget.studentPlusStudentInfo,
              // index: widget.index
            ),

            onItemSelected: (i) {
              //To go back to the staff screen of standard app
              if (i == 5) {
                // Navigator.of(context).pushAndRemoveUntil(
                //     MaterialPageRoute(
                //         builder: (context) => HomePage(index: 4
                //             // widget.index,
                //             )),
                //     (_) => false);
                // pushNewScreen(context,
                //     screen: HomePage(
                //       index: 4,
                //     ),
                //     withNavBar: false,
                //     pageTransitionAnimation: PageTransitionAnimation.fade);
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
              // refreshNavBar.value = i;
            },
            items: StudentPlusBottomNavBar.navBarsItems(context: context),
            confineInSafeArea: true,
            backgroundColor: Theme.of(context).backgroundColor,
            handleAndroidBackButtonPress: true,
            // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            resizeToAvoidBottomInset: true,
            stateManagement: false, // Default is true.
            // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
            hideNavigationBarWhenKeyboardShows: true,
            decoration: NavBarDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryVariant
                        .withOpacity(0.3),
                    // Colors.grey,
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
        });
  }
}
