import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/setting/licenceinfo.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/share_button.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../globals.dart';


class SettingPage extends StatefulWidget {
  final bool isbuttomsheet;
  final String appbarTitle;
  SettingPage(
      {Key? key, required this.isbuttomsheet, required this.appbarTitle})
      : super(key: key);
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static const double _kLabelSpacing = 18.0;
  bool _lights = true;
  bool _theme = false;
  bool _themeSystem = false;
  bool? push;
  // PackageInfo? packageInfo;
  UrlLauncherWidget urlobj = new UrlLauncherWidget();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final HomeBloc _homeBloc = new HomeBloc();
  bool? iserrorstate = false;
  bool? isloadingstate = false;

  @override
  void initState() {
    super.initState();
    // appversion();
    OneSignal.shared
        .getDeviceState()
        .then((value) => {pushState(value!.pushDisabled)});
    _homeBloc.add(FetchBottomNavigationBar());
    Globals.callsnackbar = true;
    // if (Globals.darkTheme != null) {
    //   _theme = Globals.darkTheme!;
    // }
    // if (Globals.systemTheme != null) {
    //   _themeSystem = Globals.systemTheme!;
    // } else {
    //   Globals.systemTheme = false;
    // }
  }

  // void appversion() async {
  //   packageInfo = await PackageInfo.fromPlatform();
  // }

  pushState(data) async {
    SharedPreferences pushStatus = await SharedPreferences.getInstance();
    pushStatus.setBool("push", data);
    setState(() {
      push = pushStatus.getBool("push")!;
    });

    if (push == null) {
      push = false;
    }
  }

  Widget _buildHeading(String tittle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: _kLabelSpacing / 1.5),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: _kLabelSpacing),
            child: TranslationWidget(
                message: tittle,
                fromLanguage: "en",
                toLanguage: Globals.selectedLanguage,
                builder: (translatedMessage) => Text(
                      translatedMessage.toString(),
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    )),
          ),
        ),
      ],
    );
  }

  // Widget _buildSwitchTheme() {
  //   return Globals.systemTheme! == true
  //       ? Container()
  //       : Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           children: <Widget>[
  //               Transform.scale(
  //                 scale: 1.0,
  //                 child: Padding(
  //                   padding: const EdgeInsets.only(left: _kLabelSpacing * 1.5),
  //                   child: Switch(
  //                     value: push2 != null ? _theme = !push2! : _theme,
  //                     onChanged: (bool value) async {
  //                       setState(() {
  //                         _theme = value;
  //                         if (_theme == true) {
  //                           Globals.darkTheme = _theme;
  //                           AdaptiveTheme.of(context).setDark();
  //                         } else {
  //                           Globals.darkTheme = _theme;
  //                           AdaptiveTheme.of(context).setLight();
  //                         }
  //                       });
  //                       //
  //                     },
  //                     activeColor: AppTheme.kactivebackColor,
  //                     activeTrackColor: AppTheme.kactiveTrackColor,
  //                     inactiveThumbColor: AppTheme.kIndicatorColor,
  //                     inactiveTrackColor: AppTheme.kinactiveTrackColor,
  //                   ),
  //                 ),
  //               ),
  //             ]);
  // }

  // Widget _buildSwitchSystemTheme() {
  //   return Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.end,
  //       children: <Widget>[
  //         Transform.scale(
  //           scale: 1.0,
  //           child: Padding(
  //             padding: const EdgeInsets.only(left: _kLabelSpacing * 1.5),
  //             child: Switch(
  //               value: push3 != null ? _themeSystem = !push3! : _themeSystem,
  //               onChanged: (bool value) async {
  //                 setState(() {
  //                   _themeSystem = value;
  //                   if (_themeSystem == true) {
  //                     Globals.systemTheme = _themeSystem;
  //                     AdaptiveTheme.of(context).setSystem();
  //                   } else {
  //                     Globals.systemTheme = _themeSystem;
  //                     AdaptiveTheme.of(context).setLight();
  //                   }
  //                 });
  //                 //
  //               },
  //               activeColor: AppTheme.kactivebackColor,
  //               activeTrackColor: AppTheme.kactiveTrackColor,
  //               inactiveThumbColor: AppTheme.kIndicatorColor,
  //               inactiveTrackColor: AppTheme.kinactiveTrackColor,
  //             ),
  //           ),
  //         ),
  //       ]);
  // }

  Widget _buildSwitch() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Transform.scale(
            scale: 1.0,
            child: Padding(
              padding: const EdgeInsets.only(left: _kLabelSpacing * 1.5),
              child: Switch(
                value: push != null ? _lights = !push! : _lights,
                onChanged: (bool value) async {
                  setState(() {
                    _lights = value;

                    push = !push!;
                    OneSignal.shared.disablePush(push!);
                  });
                  //
                },
                activeColor: AppTheme.kactivebackColor,
                activeTrackColor: AppTheme.kactiveTrackColor,
                inactiveThumbColor: AppTheme.kIndicatorColor,
                inactiveTrackColor: AppTheme.kinactiveTrackColor,
              ),
            ),
          ),
        ]);
  }

  Widget _buildNotification() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding:
              EdgeInsets.symmetric(horizontal: 0, vertical: _kLabelSpacing / 2),
          child: TranslationWidget(
            message: "Enable Notification",
            fromLanguage: "en",
            toLanguage: Globals.selectedLanguage,
            builder: (translatedMessage) => Padding(
              padding: const EdgeInsets.only(left: _kLabelSpacing),
              child: Text(translatedMessage.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline2!),
            ),
          ),
        ),
        _buildSwitch(),
      ],
    );
  }

  // Widget _buildSystemThemeMode() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Container(
  //         padding:
  //             EdgeInsets.symmetric(horizontal: 0, vertical: _kLabelSpacing / 2),
  //         child: TranslationWidget(
  //           message: "Enable System Theme",
  //           fromLanguage: "en",
  //           toLanguage: Globals.selectedLanguage,
  //           builder: (translatedMessage) => Padding(
  //             padding: const EdgeInsets.only(left: _kLabelSpacing),
  //             child: Text(translatedMessage.toString(),
  //                 textAlign: TextAlign.center,
  //                 style: Theme.of(context).textTheme.headline2!),
  //           ),
  //         ),
  //       ),
  //       _buildSwitchSystemTheme(),
  //     ],
  //   );
  // }

  // Widget _buildThemeMode() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Container(
  //         padding:
  //             EdgeInsets.symmetric(horizontal: 0, vertical: _kLabelSpacing / 2),
  //         child: TranslationWidget(
  //           message: "Enable Dark Theme",
  //           fromLanguage: "en",
  //           toLanguage: Globals.selectedLanguage,
  //           builder: (translatedMessage) => Padding(
  //             padding: const EdgeInsets.only(left: _kLabelSpacing),
  //             child: Text(translatedMessage.toString(),
  //                 textAlign: TextAlign.center,
  //                 style: Theme.of(context).textTheme.headline2!),
  //           ),
  //         ),
  //       ),
  //       _buildSwitchTheme(),
  //     ],
  //   );
  // }

  Widget _buildLicence() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Licenceinfo()));
      },
      child: Container(
          padding: EdgeInsets.all(16),
          child: TranslationWidget(
              message: "Open Source licences",
              fromLanguage: "en",
              toLanguage: Globals.selectedLanguage,
              builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                    style: Theme.of(context).textTheme.headline2!,
                  ))),
    );
  }

  // Widget _buildThemeMode() {
  //   return InkWell(
  //     onTap: () {
  //       showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return SelectTheme();
  //           });
  //     },
  //     child: Container(
  //         padding: EdgeInsets.all(16),
  //         child: TranslationWidget(
  //             message: "Theme",
  //             fromLanguage: "en",
  //             toLanguage: Globals.selectedLanguage,
  //             builder: (translatedMessage) => Text(
  //                   translatedMessage.toString(),
  //                   style: Theme.of(context).textTheme.headline2!,
  //                 ))),
  //   );
  // }

  Widget _appVersion() {
    return Container(
        padding: EdgeInsets.all(16),
        child: Text(
         Globals.packageInfo!.version,
          style: Theme.of(context).textTheme.headline2!,
        ));
  }

  Widget _buildItem() {
    return ListView(padding: const EdgeInsets.only(bottom: 25.0), children: [
      _buildHeading("Push Notifcation"),
      _buildNotification(),
      // _buildHeading('Display Setting'),

      // _buildSystemThemeMode(),
      // _buildThemeMode(),
      _buildHeading("Acknowledgements"),
      _buildLicence(),
      _buildHeading("App Version"),
      _appVersion(),
      HorzitalSpacerWidget(_kLabelSpacing * 20),
      SizedBox(
          width: MediaQuery.of(context).size.width * 1,
          height: 100.0,
          child: ShareButtonWidget(
            isSettingPage: true,
          ))
    ]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          appBarTitle: 'Setting',
          isSearch: false,
          isShare: false,
          sharedpopBodytext: '',
          sharedpopUpheaderText: '',
          language: Globals.selectedLanguage,
        ),
        body: RefreshIndicator(
          key: refreshKey,
          child: Container(
              child:
                  // OfflineBuilder(
                  //     connectivityBuilder: (
                  //       BuildContext context,
                  //       ConnectivityResult connectivity,
                  //       Widget child,
                  //     ) {
                  //       final bool connected =
                  //           connectivity != ConnectivityResult.none;

                  //       if (connected) {
                  //         if (iserrorstate == true) {
                  //           _homeBloc.add(FetchBottomNavigationBar());
                  //           iserrorstate = false;
                  //         }
                  //       } else if (!connected) {
                  //         iserrorstate = true;
                  //       }

                  // return
                  //  connected
                  //     ?
                  Column(
            children: [
              Expanded(
                  child: isloadingstate!
                      ? ShimmerLoading(isLoading: true, child: _buildItem())
                      : _buildItem()),
              Container(
                height: 0,
                width: 0,
                child: BlocListener<HomeBloc, HomeState>(
                    bloc: _homeBloc,
                    listener: (context, state) async {
                      if (state is HomeLoading) {
                        isloadingstate = true;
                      }

                      if (state is BottomNavigationBarSuccess) {
                        AppTheme.setDynamicTheme(Globals.appSetting, context);
                        //Globals.homeObject = state.obj;
                          Globals.appSetting = AppSetting.fromJson(state.obj);
                        isloadingstate = false;
                        setState(() {});
                      }
                    },
                    child: EmptyContainer()),
              ),
            ],
          )),
          // : NoInternetErrorWidget(
          //     connected: connected, issplashscreen: false);
          // },
          // child: Container())),
          onRefresh: refreshPage,
        ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _homeBloc.add(FetchBottomNavigationBar());
  }
}
