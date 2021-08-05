import 'dart:async';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/ui/family.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/news/ui/news.dart';
import 'package:Soc/src/modules/social/ui/soical.dart';
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
  String? language;
  HomePage({Key? key, this.title, this.homeObj, this.language})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // int _selectedIndex = 0;
  // static const double _kLabelSpacing = 16.0;
  // static const double _kIconSize = 35.0;
  final NewsBloc _bloc = new NewsBloc();
  String language1 = Translations.supportedLanguages.first;
  String language2 = Translations.supportedLanguages.last;

  bool _status = false;
  var item;
  var item2;
  // final ValueNotifier<bool> indicator = ValueNotifier<bool>(false);
  final ValueNotifier<String> languageChanged =
      ValueNotifier<String>("English");
  final SharedPreferencesFn _sharedPref = SharedPreferencesFn();
  Timer? timer;
  // String? selectedLanguage;

  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    getindicatorValue();
    _bloc.initPushState(context);
    // _selectedIndex = Globals.outerBottombarIndex ?? 0;
    // timer =
    //     Timer.periodic(Duration(seconds: 5), (Timer t) => getindicatorValue());
    _controller = PersistentTabController(initialIndex: 0);
  }

  getindicatorValue() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    Globals.selectedLanguage = await _sharedPref.getString('selected_language');
    // setState(() {
    //   _status = prefs.getBool("enableIndicator")!;
    //   if (_status == true) {
    //     Globals.indicator.value = true;
    //   } else {
    //     indicator.value = false;
    //   }

    //   if (Globals.selectedLanguage != null) {
    //     languageChanged.value = Globals.selectedLanguage!;
    //   }
    // });
  }

  // Widget _buildPopupMenuWidget() {
  //   return PopupMenuButton<IconMenu>(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(2),
  //     ),
  //     icon: Icon(
  //       const IconData(0xe806,
  //           fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
  //       color: AppTheme.kIconColor2,
  //       size: Globals.deviceType == "phone" ? 20 : 28,
  //     ),
  //     onSelected: (value) {
  //       switch (value) {
  //         case IconsMenu.Information:
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => InformationPage(
  //                         htmlText: Globals.homeObjet["App_Information__c"],
  //                         isbuttomsheet: true,
  //                         ishtml: true,
  //                         appbarTitle: "Information",
  //                         // language: selectedLanguage,
  //                       )));
  //           break;
  //         case IconsMenu.Setting:
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => SettingPage(
  //                         isbuttomsheet: true,
  //                         appbarTitle: "Setting",
  //                       )));
  //           break;
  //         case IconsMenu.Permissions:
  //           AppSettings.openAppSettings();
  //           break;
  //       }
  //     },
  //     itemBuilder: (context) => IconsMenu.items
  //         .map((item) => PopupMenuItem<IconMenu>(
  //             value: item,
  //             child: Padding(
  //               padding: const EdgeInsets.symmetric(
  //                   horizontal: _kLabelSpacing / 4, vertical: 0),
  //               child: Text(
  //                 item.text,
  //                 style: Theme.of(context)
  //                     .textTheme
  //                     .bodyText1!
  //                     .copyWith(color: Color(0xff474D55)),
  //               ),
  //             )))
  //         .toList(),
  //   );
  // }

  // hideIndicator() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool("enableIndicator", false);
  // }

  List<Widget> _buildScreens() {
    List<Widget> _screens = [];
    Globals.homeObjet["Bottom_Navigation__c"]
        .split(";")
        .forEach((String element) {
      element = element.toLowerCase();
      if (element.contains('news')) {
        // hideIndicator();

        _screens.add(
          NewsPage(),
        );
      } else if (element.contains('student')) {
        _screens.add(
          StudentPage(),
        );
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

  // selectedScreenBody(context, _selectedIndex, list) {
  //   if (list[_selectedIndex].split("_")[0].contains("Social")) {
  //     return SocialPage();
  //   } else if (list[_selectedIndex].split("_")[0].contains("News")) {
  //     hideIndicator();
  //     return NewsPage();
  //   } else if (list[_selectedIndex].split("_")[0].contains("Student")) {
  //     return StudentPage();
  //   } else if (list[_selectedIndex].split("_")[0].contains("Famil")) {
  //     return FamilyPage(
  //       obj: widget.homeObj,
  //     );
  //   } else if (list[_selectedIndex].split("_")[0].contains("Staff")) {
  //     return StaffPage();
  //   }
  // }

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
        return PersistentBottomNavBarItem(
          // contentPadding: 15,
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
    // return WillPopScope(
    //   onWillPop: () => _onBackPressed(),
    //   child: Scaffold(
    //     appBar: new AppBar(
    //         leadingWidth: _kIconSize,
    //         elevation: 0.0,
    //         leading:
    //             // _selectedIndex == 3
    //             //     ?
    //             GestureDetector(
    //           onTap: () {
    //             LanguageSelector(context, item, (language) {
    //               if (language != null) {
    //                 setState(() {
    //                   selectedLanguage = language;
    //                   langadded.value = language;
    //                 });
    //               }
    //             });
    //           },
    //           child: Padding(
    //             padding: const EdgeInsets.all(12.0),
    //             child: const Icon(IconData(0xe800,
    //                 fontFamily: Overrides.kFontFam,
    //                 fontPackage: Overrides.kFontPkg)),
    //           ),
    //         ),
    //         title: SizedBox(width: 100.0, height: 60.0, child: AppLogoWidget()),
    //         actions: <Widget>[
    //           SearchButtonWidget(),
    //           _buildPopupMenuWidget(),
    //         ]),
    //     body: selectedScreenBody(context, _selectedIndex,
    //         Globals.homeObjet["Bottom_Navigation__c"].split(";")),
    //     bottomNavigationBar: BottomNavigationBar(
    //       type: BottomNavigationBarType.fixed,
    //       currentIndex: _selectedIndex,
    //       items: Globals.homeObjet["Bottom_Navigation__c"]
    //           .split(";")
    //           .map<BottomNavigationBarItem>((e) => BottomNavigationBarItem(
    //                 icon: Column(children: [
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       ValueListenableBuilder(
    //                         builder: (BuildContext context, dynamic value,
    //                             Widget? child) {
    //                           return Expanded(
    //                             child: Text(
    //                               e.split("_")[0],
    //                               textAlign: TextAlign.center,
    //                               style: Theme.of(context).textTheme.subtitle2,
    //                             ),
    //                           );
    //                         },
    //                         valueListenable: langadded,
    //                         child: Container(),
    //                       ),
    //                       ValueListenableBuilder(
    //                         builder: (BuildContext context, dynamic value,
    //                             Widget? child) {
    //                           return e.split("_")[0] == "News" &&
    //                                   indicator.value == true
    //                               ? Container(
    //                                   height: 8,
    //                                   width: 8,
    //                                   margin: EdgeInsets.only(left: 3),
    //                                   decoration: BoxDecoration(
    //                                       color: Colors.red,
    //                                       shape: BoxShape.circle),
    //                                 )
    //                               : Container();
    //                         },
    //                         valueListenable: indicator,
    //                         child: Container(),
    //                       ),
    //                     ],
    //                   ),
    //                   Padding(
    //                     padding: const EdgeInsets.only(top: 5.0),
    //                     child: Icon(
    //                       IconData(int.parse(e.split("_")[1]),
    //                           fontFamily: Overrides.kFontFam,
    //                           fontPackage: Overrides.kFontPkg),
    //                       size: Globals.deviceType == "phone" ? 24 : 32,
    //                     ),
    //                   ),
    //                 ]),
    //                 label: '', //'${e.split("_")[0]}',
    //               ))
    //           .toList(),
    //       onTap: (index) {
    //         setState(() {
    //           _selectedIndex = index;
    //           Globals.internalBottombarIndex = index;
    //         });
    //       },
    //     ),
    //   ),
    // );

    return WillPopScope(
      onWillPop: () => _onBackPressed(),
      child: Scaffold(
          // appBar: new AppBar(
          //     backgroundColor: Colors.white,
          //     leadingWidth: _kIconSize,
          //     elevation: 0.0,
          //     leading:
          //         // _selectedIndex == 3
          //         //     ?
          //         GestureDetector(
          //       onTap: () {
          //         LanguageSelector(context, item, (language) {
          //           if (language != null) {
          //             setState(() {
          //               selectedLanguage = language;
          //               langadded.value = language;
          //             });
          //           }
          //         });
          //       },
          //       child: Padding(
          //         padding: const EdgeInsets.all(12.0),
          //         child: const Icon(IconData(0xe800,
          //             fontFamily: Overrides.kFontFam,
          //             fontPackage: Overrides.kFontPkg)),
          //       ),
          //     ),
          //     title: SizedBox(width: 100.0, height: 60.0, child: AppLogoWidget()),
          //     actions: <Widget>[
          //       SearchButtonWidget(),
          //       _buildPopupMenuWidget(),
          //     ]),
          body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
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
