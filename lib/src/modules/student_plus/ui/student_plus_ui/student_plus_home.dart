import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/student_plus/bloc/student_plus_bloc.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_bottomnavbar.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class StudentPlusHome extends StatefulWidget {
  final StudentPlusDetailsModel studentPlusStudentInfo;
  final int index;
  final String sectionType;
  const StudentPlusHome(
      {Key? key,
      required this.studentPlusStudentInfo,
      required this.index,
      required this.sectionType})
      : super(key: key);

  @override
  State<StudentPlusHome> createState() => _StudentPlusHomeState();
}

class _StudentPlusHomeState extends State<StudentPlusHome> {
  final ValueNotifier<int> refreshNavBar = ValueNotifier<int>(0);

  // persistent tab controller use for navigate
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  final StudentPlusBloc _studentPlusBloc = StudentPlusBloc();

  // list of bottom navigation bar icons
  List<PersistentBottomNavBarItem> persistentBottomNavBarItemList = [];

  @override
  void initState() {
    _controller.index = widget.index;

    // Only call in case of Student Section to fetch student details
    if (widget.sectionType == "Student") {
      _studentPlusBloc.add(StudentPlusSearchByEmail());
    } else if (widget.sectionType == "Family") {
      _studentPlusBloc.add(GetStudentPlusDetails(
          studentIdC: widget.studentPlusStudentInfo.studentIdC ?? ''));
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.sectionType == "Student" || widget.sectionType == "Family"
            ? BlocBuilder<StudentPlusBloc, StudentPlusState>(
                bloc: _studentPlusBloc,
                builder: (context, state) {
                  if (state is StudentPlusGetDetailsLoading) {
                    return loaderWidget();
                  } else if (state is StudentPlusSearchByEmailSuccess) {
                    return body(studentPlusDetailsModel: state.obj);
                  } else if (state is StudentPlusInfoSuccess) {
                    return body(studentPlusDetailsModel: state.obj);
                  }
                  return Container();
                },
              )
            : body());
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
  Widget body({StudentPlusDetailsModel? studentPlusDetailsModel}) {
    return ValueListenableBuilder(
        valueListenable: refreshNavBar,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return PersistentTabView(
            context,
            controller: _controller,
            screens: StudentPlusBottomNavBar.buildScreens(
                studentInfo: widget.sectionType == "Student" ||
                        widget.sectionType == "Family"
                    ? studentPlusDetailsModel! //Calling API in case of Student or Family section
                    : widget
                        .studentPlusStudentInfo, //Already having data so passing values directly
                sectionType: widget.sectionType),

            onItemSelected: (i) {
              //To go back to the staff screen of standard app
              if (i == 5) {
                if (widget.sectionType == 'Family') {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                index: 3,
                                isFromOcrSection: true,
                              )),
                      (_) => false);
                  return;
                }
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            items: StudentPlusBottomNavBar.navBarsItems(
                context: context, sectionType: widget.sectionType),
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
                        .withOpacity(0.2),
                    // Colors.grey,
                    blurRadius: 5.0,
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
            navBarHeight: Globals.deviceType == "phone" ? 55 : 65,
          );
        });
  }
}
