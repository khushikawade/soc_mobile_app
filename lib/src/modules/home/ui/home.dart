import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/about/ui/about.dart';
import 'package:Soc/src/modules/families/ui/family.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/news/model/notification_list.dart';
import 'package:Soc/src/modules/news/ui/news.dart';
import 'package:Soc/src/modules/resources/resources.dart';
import 'package:Soc/src/modules/schools/ui/schools.dart';
import 'package:Soc/src/modules/social/ui/social.dart';
import 'package:Soc/src/modules/staff/ui/staff.dart';
import 'package:Soc/src/modules/students/ui/student.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/translator/language_list.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_version/new_version.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../overrides.dart';

class HomePage extends StatefulWidget {
  final String? title;
  final homeObj;
  final String? language;
  final Widget Function(String translation)? builder;
  HomePage({Key? key, this.title, this.homeObj, this.language, this.builder})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final NewsBloc _bloc = new NewsBloc();
  String language1 = Translations.supportedLanguages.first;
  String language2 = Translations.supportedLanguages.last;
  var item;
  var item2;

  final ValueNotifier<String> languageChanged =
      ValueNotifier<String>("English");
  // final SharedPreferencesFn _sharedPref = SharedPreferencesFn();
  late PersistentTabController _controller;
  final NewsBloc _newsBloc = new NewsBloc();
  late AppLifecycleState _notification;
  

  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
    if (_notification == AppLifecycleState.resumed)
      _newsBloc.add(NewsCountLength());
  }

  Widget callNotification() {
    return BlocListener<NewsBloc, NewsState>(
      bloc: _newsBloc,
      listener: (context, state) async {
        if (state is NewsCountLenghtSuccess) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          SharedPreferences intPrefs = await SharedPreferences.getInstance();
          String? _objectName = "${Strings.newsObjectName}";
          LocalDatabase<NotificationList> _localDb = LocalDatabase(_objectName);
          List<NotificationList> _localData = await _localDb.getData();
          // print(intPrefs.getInt("totalCount"));
          if (_localData.length < state.obj!.length) {
            intPrefs.setInt("totalCount", Globals.notiCount!);
            prefs.setBool("enableIndicator", true);
            Globals.indicator.value = true;
          }
        }
      },
      child: Container(),
    );
  }

  void _getNotificationIntance() {
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent notification) async {
      notification.complete(notification.notification);
      Globals.indicator.value = true;
    });
  }

  void _checkNewVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String _packageName = packageInfo.packageName;
    final newVersion = NewVersion(
      iOSId: _packageName,
      androidId: _packageName,
    );
    // You can let the plugin handle fetching the status and showing a dialog,
    // or you can fetch the status and display your own dialog, or no dialog.
    _checkVersionUpdateStatus(newVersion);
  }

  @override
  void initState() {
    super.initState();
    _getNotificationIntance();
    _newsBloc.add(NewsCountLength());
    _bloc.initPushState(context);

    _controller = PersistentTabController(initialIndex: Globals.homeIndex ?? 0);
    WidgetsBinding.instance!.addObserver(this);
    _checkNewVersion();
  }

  _checkVersionUpdateStatus(NewVersion newVersion) async {
    newVersion.showAlertIfNecessary(context: context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  List<Widget> _buildScreens() {
    List<Widget> _screens = [];
    // Globals.homeObject["Bottom_Navigation__c"]
    Globals.appSetting.bottomNavigationC!.split(";").forEach((String element) {
      element = element.toLowerCase();
      if (element.contains('news')) {
        _screens.add(NewsPage());
      } else if (element.contains('student')) {
        _screens.add(StudentPage(
          homeObj: widget.homeObj,
        ));
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
      } else if (element.contains('about')) {
        _screens.add(
          AboutPage(),
        );
      } else if (element.contains('school')) {
        _screens.add(
          SchoolPage(),
        );
      } else if (element.contains('resource')) {
        _screens.add(
          ResourcesPage(),
        );
      }
    });
    return _screens;
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return Globals.appSetting.bottomNavigationC!
        // Globals.homeObject["Bottom_Navigation__c"]
        .split(";")
        .map<PersistentBottomNavBarItem>(
      (item) {
        if (item.split("_")[0].toString().toLowerCase().contains("news")) {
          Globals.newsIndex = Globals.appSetting.bottomNavigationC!
              // Globals.homeObject["Bottom_Navigation__c"]
              .split(";")
              .indexOf(item);
        }
        // print(Globals.newsIndex);
        setState(() {});
        return PersistentBottomNavBarItem(
          icon: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ValueListenableBuilder(
                            builder: (BuildContext context, dynamic value,
                                Widget? child) {
                              return item.split("_")[0] == "News" &&
                                      Globals.indicator.value == true
                                  ? Wrap(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 15, left: 50),
                                          // padding:EdgeInsets.only(bottom: 25,) ,
                                          height: 7,
                                          width: 7,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle),
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
                      SpacerWidget(2),
                      TranslationWidget(
                        shimmerHeight: 8,
                        message: item.split("_")[
                            0], //"${item.split("_")[0]=="Student"?"About":item.split("_")[0]=="Families"?"Schools":item.split("_")[0]=="Staff"?"Resources":item.split("_")[0]}",
                        fromLanguage: "en",
                        toLanguage: Globals.selectedLanguage,
                        builder: (translatedMessage) => Expanded(
                          child: Text(
                            translatedMessage.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.headline4!,
                          ),
                        ),
                      ),
                      callNotification()
                    ],
                  ),
                ),
              ),
            ],
          ),
          // title:(''), //("${item.split("_")[0]}"),
          activeColorPrimary: Theme.of(context).primaryColor,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        );
      },
    ).toList();
  }

  Widget _continueShowCaseInstructions(String text) => TranslationWidget(
      message: text,
      fromLanguage: "en",
      toLanguage: Globals.selectedLanguage,
      builder: (translatedMessage) => Text(
            '$translatedMessage',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline1!.copyWith(
                // color: Colors.red,
                color: Theme.of(context).backgroundColor,
                fontSize: 32,
                fontStyle: FontStyle.italic),
          ));

  Widget _tabBarBody() => PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        // hideNavigationBar: true,
        onItemSelected: (int i) {
          setState(() {
            // To make sure if the ShowCase is in the progress and user taps on bottom nav bar items so the Showcase should not apear on other pages/
            Globals.hasShowcaseInitialised.value = true;
            // New news item indicator
            if (i == Globals.newsIndex) {
              Globals.indicator.value = false;
            }
          });
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
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
            // circular(25.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10.0,
              ),
            ]),
        onWillPop: (context) async {
          await _onBackPressed();
          return false;
        },
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
        navBarHeight: Globals.deviceType == "phone" ? 60 : 70,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:

          //   UpgradeAlert(
          // // appcastConfig: cfg,

          // debugLogging: true,
          // child:

          Stack(
        children: [
          _tabBarBody(),
          ValueListenableBuilder<bool>(
              valueListenable: Globals.hasShowcaseInitialised,
              builder: (context, value, _) {
                if (Globals.hasShowcaseInitialised.value == true)
                  return Container();
                return Center(
                    child: _continueShowCaseInstructions(
                        'Tap anywhere on the screen to continue.'));
              }),
        ],
      ),
    );
    // );
  }

  _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text("Do you want to exit the app?",
                  style: Theme.of(context).textTheme.headline2!),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context, false),
                  child:
                      Text("No", style: Theme.of(context).textTheme.headline2!),
                ),
                FlatButton(
                  onPressed: () => exit(0),
                  child: Text("Yes",
                      style: Theme.of(context).textTheme.headline2!),
                ),
              ],
            ));
  }
}
