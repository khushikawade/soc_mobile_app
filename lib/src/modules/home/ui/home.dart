import 'dart:async';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/ui/family.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/news/ui/news.dart';
import 'package:Soc/src/modules/social/ui/social.dart';
import 'package:Soc/src/modules/staff/ui/staff.dart';
import 'package:Soc/src/modules/students/ui/student.dart';
import 'package:Soc/src/services/shared_preference.dart';
import 'package:Soc/src/translator/language_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../../../overrides.dart';

class HomePage extends StatefulWidget {
  final String? title;
  final homeObj;
  final String? language;
  HomePage({Key? key, this.title, this.homeObj, this.language})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NewsBloc _bloc = new NewsBloc();
  String language1 = Translations.supportedLanguages.first;
  String language2 = Translations.supportedLanguages.last;
  var item;
  var item2;

  final ValueNotifier<String> languageChanged =
      ValueNotifier<String>("English");
  final SharedPreferencesFn _sharedPref = SharedPreferencesFn();
  Timer? timer;
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _bloc.initPushState(context);
    _controller = PersistentTabController(initialIndex: Globals.homeIndex ?? 0);
  }

  getindicatorValue() async {
    Globals.selectedLanguage = await _sharedPref.getString('selected_language');
  }

  List<Widget> _buildScreens() {
    List<Widget> _screens = [];
    Globals.homeObjet["Bottom_Navigation__c"]
        .split(";")
        .forEach((String element) {
      element = element.toLowerCase();
      if (element.contains('news')) {
        _screens.add(NewsPage());
      } else if (element.contains('student')) {
        _screens.add(StudentPage());
      } else if (element.contains('families')) {
        _screens.add(
          FamilyPage(
            obj: widget.homeObj,
          ),
        );
      } else if (element.contains('staff')) {
        _screens.add(StaffPage());
      } else if (element.contains('social')) {
        _screens.add(
          SocialPage(),
        );
      }
    });
    return _screens;
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return Globals.homeObjet["Bottom_Navigation__c"]
        .split(";")
        .map<PersistentBottomNavBarItem>(
      (item) {
        if (item.split("_")[0].toString().toLowerCase().contains("news")) {
          Globals.newsIndex = Globals.homeObjet["Bottom_Navigation__c"]
              .split(";")
              .indexOf(item);
        }
        setState(() {});
        return PersistentBottomNavBarItem(
          icon: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return item.split("_")[0] == "News" &&
                          Globals.indicator.value == true
                      ? Wrap(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 8, right: 2),
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                            ),
                          ],
                        )
                      : Container();
                },
                valueListenable: Globals.indicator,
                child: Container(),
              ),
              Icon(
                IconData(int.parse(item.split("_")[1]),
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
              ),
            ],
          ),
          title: ("${item.split("_")[0]}"),
          activeColorPrimary: Theme.of(context).primaryColor,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        // hideNavigationBar: true,
        onItemSelected: (int i) {
          if (i == Globals.newsIndex) {
            setState(() {
              Globals.indicator.value = false;
            });
          } else {
            setState(() {});
          }
        },
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Theme.of(context).backgroundColor,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10.0,
              ),
            ]),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style6,
      )),
    );
  }
}
