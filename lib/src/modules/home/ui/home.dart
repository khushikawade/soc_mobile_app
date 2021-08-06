import 'dart:async';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/ui/family.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/news/ui/news.dart';
import 'package:Soc/src/modules/social/ui/social.dart';
import 'package:Soc/src/modules/staff/ui/staff.dart';
import 'package:Soc/src/modules/students/ui/student.dart';
import 'package:Soc/src/services/shared_preference.dart';
import 'package:Soc/src/translator/language_list.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    getindicatorValue();
    _bloc.initPushState(context);
    _controller = PersistentTabController(initialIndex: 0);
  }

  getindicatorValue() async {
    Globals.selectedLanguage = await _sharedPref.getString('selected_language');
  }

  // hideIndicator() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   // prefs.setBool("enableIndicator", false);
  // }

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

  _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Theme.of(context).backgroundColor,
              title: ValueListenableBuilder(
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return Globals.languageChanged.value != "English" &&
                          Globals.selectedLanguage != null &&
                          Globals.selectedLanguage != "English"
                      ? TranslationWidget(
                          message: "Do you want to exit the app?",
                          fromLanguage: "en",
                          toLanguage: Globals.selectedLanguage,
                          builder: (translatedMessage) => Text(
                            translatedMessage.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        )
                      : Text(
                          "Do you want to exit the app?",
                          style: Theme.of(context).textTheme.headline2,
                        );
                },
                valueListenable: Globals.languageChanged,
                child: Container(),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    "No",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                TextButton(
                  onPressed: () => exit(0),
                  child: Text(
                    "Yes",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ));
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return Globals.homeObjet["Bottom_Navigation__c"]
        .split(";")
        .map<PersistentBottomNavBarItem>(
      (item) {
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
                // size: Globals.deviceType == "phone" ? 24 : 32,
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
      onWillPop: () => _onBackPressed(),
      child: Scaffold(
          body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        onItemSelected: (int i) {
          print('Changed...');
          setState(() {
            Globals.indicator.value = false;
          });
        },
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor:
            Theme.of(context).backgroundColor, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
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
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style6, // Choose the nav bar style with this property.
      )),
    );
  }
}
