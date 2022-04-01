import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/about/ui/about.dart';
import 'package:Soc/src/modules/custom/ui/custom_app_section.dart';
import 'package:Soc/src/modules/custom/ui/custom_page.dart';
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
  List<Widget> _screens = [];
  String? _versionNumber;

  final ValueNotifier<String> languageChanged =
      ValueNotifier<String>("English");
  late PersistentTabController _controller;
  final NewsBloc _newsBloc = new NewsBloc();
  late AppLifecycleState _notification;
  int previousIndex = 0;

  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
    if (_notification == AppLifecycleState.resumed)
      _newsBloc.add(NewsCountLength());
  }

  void restart() {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      if (details.exception.toString().contains('RangeError')) {
        _controller.index = 0;
      }
    };
  }

  Widget callNotification() {
    return BlocListener<NewsBloc, NewsState>(
      bloc: _newsBloc,
      listener: (context, state) async {
        if (state is NewsCountLenghtSuccess) {
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // SharedPreferences intPrefs = await SharedPreferences.getInstance();
          String? _objectName = "${Strings.newsObjectName}";
          LocalDatabase<NotificationList> _localDb = LocalDatabase(_objectName);
          List<NotificationList> _localData = await _localDb.getData();

          if (_localData.length < state.obj!.length && _localData.isNotEmpty) {
            // intPrefs.setInt("totalCount", Globals.notiCount!);
            // prefs.setBool("enableIndicator", true);
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
    _versionNumber = packageInfo.version;
    final newVersion = NewVersion(
      iOSId: _packageName,
      androidId: _packageName,
    );
    _checkVersionUpdateStatus(newVersion);
  }

  @override
  void initState() {
    super.initState();
    _getNotificationIntance();
    _newsBloc.add(NewsCountLength());
    _bloc.initPushState(context);
    restart();
    _controller = PersistentTabController(initialIndex: Globals.homeIndex ?? 0);
    // initialIndex:
    //     Globals.isNewTap ? Globals.newsIndex ?? 1 : Globals.homeIndex ?? 0);
    WidgetsBinding.instance!.addObserver(this);
    _checkNewVersion();
  }

  _checkVersionUpdateStatus(NewVersion newVersion) async {
    // final VersionStatus? versionStatus = await getVersionStatus();
    newVersion.showAlertIfNecessary(context: context);

    // if (Globals.packageInfo!.version != _versionNumber) {
    //   _updateAlart();
    // }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  List<Widget> _buildScreens() {
    _screens.clear();

    Globals.appSetting.isCustomApp!
        ? addScreen()
        : Globals.appSetting.bottomNavigationC!
            .split(";")
            .forEach((String element) {
            element = element.toLowerCase();
            if (_screens.length <
                Globals.appSetting.bottomNavigationC!.split(";").length) {
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
            }
          });
    return _screens;
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    if (Globals.appSetting.isCustomApp!) {
      return Globals.customSetting!.map<PersistentBottomNavBarItem>(
        (item) {
          return PersistentBottomNavBarItem(
            icon: _bottomIcon(item.selectionTitleC, item.sectionIconC),
            activeColorPrimary: Theme.of(context).primaryColor,
            inactiveColorPrimary: CupertinoColors.systemGrey,
          );
        },
      ).toList();
    } else {
      return Globals.appSetting.bottomNavigationC!
          .split(";")
          .map<PersistentBottomNavBarItem>(
        (item) {
          if (item.split("_")[0].toString().toLowerCase().contains("news")) {
            Globals.newsIndex =
                Globals.appSetting.bottomNavigationC!.split(";").indexOf(item);
          }
          setState(() {});
          return PersistentBottomNavBarItem(
            icon: _bottomIcon(item.split("_")[0], item.split("_")[1]),
            activeColorPrimary: Theme.of(context).primaryColor,
            inactiveColorPrimary: CupertinoColors.systemGrey,
          );
        },
      ).toList();
    }
  }

  Widget _bottomIcon(title, iconData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ValueListenableBuilder(
                      builder:
                          (BuildContext context, dynamic value, Widget? child) {
                        return title == "News" &&
                                Globals.indicator.value == true
                            ? Wrap(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(bottom: 15, left: 50),
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
                      IconData(int.parse(iconData),
                          fontFamily: Overrides.kFontFam,
                          fontPackage: Overrides.kFontPkg),
                    ),
                  ],
                ),
                SpacerWidget(2),
                TranslationWidget(
                  shimmerHeight: 8,
                  message: title,
                  fromLanguage: "en",
                  toLanguage: Globals.selectedLanguage,
                  builder: (translatedMessage) => Expanded(
                    child: FittedBox(
                      child: Text(
                        translatedMessage.toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.headline4!,
                      ),
                    ),
                  ),
                ),
                callNotification()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _continueShowCaseInstructions(String text) => TranslationWidget(
      message: text,
      fromLanguage: "en",
      toLanguage: Globals.selectedLanguage,
      builder: (translatedMessage) => Text(
            '$translatedMessage',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 32, fontStyle: FontStyle.italic),
          ));

  Widget _tabBarBody() {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),

      // hideNavigationBar: true,
      onItemSelected: (i) {
        // _controller.index = i;
        setState(() {
          if (previousIndex == i && Globals.urlIndex == i) {
            Globals.webViewController1!.loadUrl(Globals.homeUrl!);
          }

          previousIndex = i;
          // Globals.controller.index = i;
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
              color:
                  Theme.of(context).colorScheme.primaryVariant.withOpacity(0.3),
              // Colors.grey,
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
        animateTabTransition: false,
        // curve: Curves.ease,
        // duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style6,
      navBarHeight: Globals.deviceType == "phone" ? 60 : 70,
    );
  }

  @override
  Widget build(BuildContext context) {
    return mainbody();
  }

  Widget mainbody() {
    return Scaffold(
      body: Stack(
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
  }

  // _updateAlart() {
  //   return showDialog(
  //       barrierColor: Color.fromARGB(96, 73, 73, 75),
  //       context: context,
  //       builder: (_) => updateDialog());
  // }

  _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) =>
            OrientationBuilder(builder: (context, orientation) {
              return AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.background,
                title: Container(
                  padding: Globals.deviceType == 'phone'
                      ? null
                      : const EdgeInsets.only(top: 10.0),
                  height: Globals.deviceType == 'phone'
                      ? null
                      : orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.height / 15
                          : MediaQuery.of(context).size.width / 15,
                  width: Globals.deviceType == 'phone'
                      ? null
                      : orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.width / 2
                          : MediaQuery.of(context).size.height / 2,
                  child: TranslationWidget(
                      message: "Do you want to exit the app?",
                      fromLanguage: "en",
                      toLanguage: Globals.selectedLanguage,
                      builder: (translatedMessage) {
                        return Text(translatedMessage.toString(),
                            style: Theme.of(context).textTheme.headline2!);
                      }),
                ),
                actions: <Widget>[
                  FlatButton(
                    padding: Globals.deviceType != 'phone'
                        ? EdgeInsets.only(bottom: 10.0, right: 10.0)
                        : EdgeInsets.all(0),
                    onPressed: () => Navigator.pop(context, false),
                    child: TranslationWidget(
                        message: "No",
                        fromLanguage: "en",
                        toLanguage: Globals.selectedLanguage,
                        builder: (translatedMessage) {
                          return Text(translatedMessage.toString(),
                              style: Theme.of(context).textTheme.headline2!);
                        }),
                  ),
                  FlatButton(
                      padding: Globals.deviceType != 'phone'
                          ? EdgeInsets.only(bottom: 10.0, right: 10.0)
                          : EdgeInsets.all(0.0),
                      onPressed: () => exit(0),
                      child: TranslationWidget(
                          message: "Yes",
                          fromLanguage: "en",
                          toLanguage: Globals.selectedLanguage,
                          builder: (translatedMessage) {
                            return Text(translatedMessage.toString(),
                                style: Theme.of(context).textTheme.headline2!);
                          }))
                ],
              );
            }));
  }

  // Widget updateDialog() {
  //   return OrientationBuilder(builder: (context, orientation) {
  //     return AlertDialog(
  //       backgroundColor: Colors.white,
  //       title: Column(
  //         children: [
  //           Container(
  //             padding: Globals.deviceType == 'phone'
  //                 ? null
  //                 : const EdgeInsets.only(top: 10.0),
  //             height: Globals.deviceType == 'phone'
  //                 ? null
  //                 : orientation == Orientation.portrait
  //                     ? MediaQuery.of(context).size.height / 15
  //                     : MediaQuery.of(context).size.width / 15,
  //             width: Globals.deviceType == 'phone'
  //                 ? null
  //                 : orientation == Orientation.portrait
  //                     ? MediaQuery.of(context).size.width / 2
  //                     : MediaQuery.of(context).size.height / 2,
  //             child: TranslationWidget(
  //                 message: "Update Available",
  //                 fromLanguage: "en",
  //                 toLanguage: Globals.selectedLanguage,
  //                 builder: (translatedMessage) {
  //                   return Text(translatedMessage.toString(),
  //                       style: Theme.of(context).textTheme.headline2!);
  //                 }),
  //           ),
  //           Container(
  //             padding: Globals.deviceType == 'phone'
  //                 ? null
  //                 : const EdgeInsets.only(top: 10.0),
  //             height: Globals.deviceType == 'phone'
  //                 ? null
  //                 : orientation == Orientation.portrait
  //                     ? MediaQuery.of(context).size.height / 15
  //                     : MediaQuery.of(context).size.width / 15,
  //             width: Globals.deviceType == 'phone'
  //                 ? null
  //                 : orientation == Orientation.portrait
  //                     ? MediaQuery.of(context).size.width / 2
  //                     : MediaQuery.of(context).size.height / 2,
  //             child: TranslationWidget(
  //                 message:
  //                     "You can now update this app from ${Globals.packageInfo!.version} to $_versionNumber",
  //                 fromLanguage: "en",
  //                 toLanguage: Globals.selectedLanguage,
  //                 builder: (translatedMessage) {
  //                   return Text(translatedMessage.toString(),
  //                       style: Theme.of(context).textTheme.headline2!);
  //                 }),
  //           ),
  //         ],
  //       ),
  //       actions: <Widget>[
  //         FlatButton(
  //           padding: Globals.deviceType != 'phone'
  //               ? EdgeInsets.only(bottom: 10.0, right: 10.0)
  //               : EdgeInsets.all(0),
  //           onPressed: () => Navigator.pop(context, false),
  //           child: TranslationWidget(
  //               message: "No",
  //               fromLanguage: "en",
  //               toLanguage: Globals.selectedLanguage,
  //               builder: (translatedMessage) {
  //                 return Text(translatedMessage.toString(),
  //                     style: Theme.of(context).textTheme.headline2!);
  //               }),
  //         ),
  //         FlatButton(
  //             padding: Globals.deviceType != 'phone'
  //                 ? EdgeInsets.only(bottom: 10.0, right: 10.0)
  //                 : EdgeInsets.all(0.0),
  //             onPressed: () => exit(0),
  //             child: TranslationWidget(
  //                 message: "Yes",
  //                 fromLanguage: "en",
  //                 toLanguage: Globals.selectedLanguage,
  //                 builder: (translatedMessage) {
  //                   return Text(translatedMessage.toString(),
  //                       style: Theme.of(context).textTheme.headline2!);
  //                 }))
  //       ],
  //     );
  //   });
  // }

  void addScreen() {
    for (var i = 0; i < Globals.customSetting!.length; i++) {
      if (Globals.customSetting![i].typeOfSectionC == 'Standard section') {
        if (Globals.customSetting![i].standardSectionC == 'News') {
          _screens.add(NewsPage());
        } else if (Globals.customSetting![i].standardSectionC == 'Social') {
          _screens.add(SocialPage());
        } else if (Globals.customSetting![i].standardSectionC == 'Student') {
          _screens.add(StudentPage());
        } else if (Globals.customSetting![i].standardSectionC == 'Staff') {
          _screens.add(StaffPage());
        } else if (Globals.customSetting![i].standardSectionC == 'Families') {
          _screens.add(FamilyPage());
        } else if (Globals.customSetting![i].standardSectionC ==
            'School Directory') {
          _screens.add(SchoolPage());
        } else if (Globals.customSetting![i].standardSectionC == 'About') {
          _screens.add(AboutPage());
        } else if (Globals.customSetting![i].standardSectionC == 'Resources') {
          _screens.add(ResourcesPage());
        }
      } else if (Globals.customSetting![i].typeOfSectionC == 'Custom section') {
        _screens.add(CustomAppSection(obj: Globals.customSetting![i]));
      } else if (Globals.customSetting![i].typeOfSectionC == 'Custom Type') {
        _screens.add(CustomPages(obj: Globals.customSetting![i]));

        if (Globals.customSetting![i].typeOfPageC == 'URL') {
          Globals.urlIndex = _screens.length - 1;
          Globals.homeUrl = Globals.customSetting![i].appUrlC;
        }
      } else {
        _screens.add(CustomAppSection(obj: Globals.customSetting![i]));
      }
    }
  }

  // Future<VersionStatus?> getVersionStatus() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   if (Platform.isIOS) {
  //     return _getiOSStoreVersion(packageInfo);
  //   } else if (Platform.isAndroid) {
  //     return _getAndroidStoreVersion(packageInfo);
  //   } else {
  //     debugPrint(
  //         'The target platform "${Platform.operatingSystem}" is not yet supported by this package.');
  //   }
  // }

  // Future<VersionStatus?> _getiOSStoreVersion(PackageInfo packageInfo) async {
  //   final id = packageInfo.packageName;
  //   DbServices _dbServices = DbServices();
  //   final parameters = {"bundleId": "$id"};
  //   if (iOSAppStoreCountry != null) {
  //     parameters.addAll({"country": iOSAppStoreCountry!});
  //   }
  //   var uri = Uri.https("itunes.apple.com", "/lookup", parameters);
  //   final response = await _dbServices.getapi(uri);
  //   // http.get(uri);
  //   if (response.statusCode != 200) {
  //     debugPrint('Failed to query iOS App Store');
  //     return null;
  //   }
  //   final jsonObj = json.decode(response.body);
  //   final List results = jsonObj['results'];
  //   if (results.isEmpty) {
  //     debugPrint('Can\'t find an app in the App Store with the id: $id');
  //     return null;
  //   }
  //   return VersionStatus._(
  //     localVersion: packageInfo.version,
  //     storeVersion: jsonObj['results'][0]['version'],
  //     appStoreLink: jsonObj['results'][0]['trackViewUrl'],
  //     releaseNotes: jsonObj['results'][0]['releaseNotes'],
  //   );
  // }

  // Future<String?> _getAndroidStoreVersion(
  //     PackageInfo packageInfo) async {
  //   final id = packageInfo.packageName;
  //   DbServices _dbServices = DbServices();
  //   final uri =
  //       Uri.https("play.google.com", "/store/apps/details", {"id": "$id"});
  //   final response = await _dbServices.getapi(uri);
  //   // http.get(uri);
  //   if (response.statusCode != 200) {
  //     debugPrint('Can\'t find an app in the Play Store with the id: $id');
  //     return null;
  //   }
  //   final document = parse(response.body);

  //   final additionalInfoElements = document.getElementsByClassName('hAyfc');
  //   final versionElement = additionalInfoElements.firstWhere(
  //     (elm) => elm.querySelector('.BgcNfc')!.text == 'Current Version',
  //   );
  //   final storeVersion = versionElement.querySelector('.htlgb')!.text;

  //   final sectionElements = document.getElementsByClassName('W4P4ne');
  //   final releaseNotesElement = sectionElements.firstWhereOrNull(
  //     (elm) => elm.querySelector('.wSaTQd')!.text == 'What\'s New',
  //   );
  //   final releaseNotes = releaseNotesElement
  //       ?.querySelector('.PHBdkd')
  //       ?.querySelector('.DWPxHb')
  //       ?.text;
  //     return
  //   //  return VersionStatus._(
  //   //   localVersion: packageInfo.version,
  //   //   storeVersion: storeVersion,
  //   //   appStoreLink: uri.toString(),
  //   //   releaseNotes: releaseNotes,
  //   // );
  // }

  // String? iOSAppStoreCountry;
}
