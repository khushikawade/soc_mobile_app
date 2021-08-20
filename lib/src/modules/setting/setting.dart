import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/setting/licenceinfo.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/share_button.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  bool isbuttomsheet;
  String appbarTitle;
  SettingPage(
      {Key? key, required this.isbuttomsheet, required this.appbarTitle})
      : super(key: key);
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static const double _kLabelSpacing = 18.0;
  bool _lights = true;
  bool? push;
  UrlLauncherWidget urlobj = new UrlLauncherWidget();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final HomeBloc _homeBloc = new HomeBloc();
  bool? iserrorstate = false;
  bool? isloadingstate = false;

  @override
  void initState() {
    super.initState();
    OneSignal.shared
        .getDeviceState()
        .then((value) => {pushState(value!.pushDisabled)});
    _homeBloc.add(FetchBottomNavigationBar());
  }

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
            child: Globals.selectedLanguage != null &&
                    Globals.selectedLanguage != "English"
                ? TranslationWidget(
                    message: tittle,
                    fromLanguage: "en",
                    toLanguage: Globals.selectedLanguage,
                    builder: (translatedMessage) => Text(
                          translatedMessage.toString(),
                          style: Theme.of(context).textTheme.headline2!,
                        ))
                : Text(tittle, style: Theme.of(context).textTheme.headline2!),
          ),
        ),
      ],
    );
  }

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
        Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English"
            ? Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 0, vertical: _kLabelSpacing / 2),
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
              )
            : Padding(
                padding: const EdgeInsets.only(left: _kLabelSpacing),
                child: Text("Enable Notification",
                    style: Theme.of(context).textTheme.headline2!),
              ),
        _buildSwitch(),
      ],
    );
  }

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
          child: Globals.selectedLanguage != null &&
                  Globals.selectedLanguage != "English"
              ? TranslationWidget(
                  message: "Open Source licences",
                  fromLanguage: "en",
                  toLanguage: Globals.selectedLanguage,
                  builder: (translatedMessage) => Text(
                        translatedMessage.toString(),
                        style: Theme.of(context).textTheme.headline2!,
                      ))
              : Text(
                  "Open Source licences",
                  style: Theme.of(context).textTheme.headline2!,
                )),
    );
  }

  Widget _buildItem() {
    return ListView(padding: const EdgeInsets.only(bottom: 25.0), children: [
      _buildHeading("Push Notifcation"),
      _buildNotification(),
      _buildHeading("Acknowledgements"),
      _buildLicence(),
      HorzitalSpacerWidget(_kLabelSpacing * 20),
      SizedBox(
          width: MediaQuery.of(context).size.width * 1,
          height: 100.0,
          child: ShareButtonWidget(
            language: Globals.selectedLanguage,
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
              child: OfflineBuilder(
                  connectivityBuilder: (
                    BuildContext context,
                    ConnectivityResult connectivity,
                    Widget child,
                  ) {
                    final bool connected =
                        connectivity != ConnectivityResult.none;

                    if (connected) {
                      if (iserrorstate == true) {
                        _homeBloc.add(FetchBottomNavigationBar());
                        iserrorstate = false;
                      }
                    } else if (!connected) {
                      iserrorstate = true;
                    }

                    return new Stack(fit: StackFit.expand, children: [
                      connected
                          ? Column(
                              children: [
                                Expanded(
                                    child: isloadingstate!
                                        ? ShimmerLoading(
                                            isLoading: true,
                                            child: _buildItem())
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
                                        AppTheme.setDynamicTheme(
                                            Globals.appSetting, context);
                                        Globals.homeObjet = state.obj;
                                        isloadingstate = false;
                                        setState(() {});
                                      }
                                    },
                                    child: Container(
                                      height: 0,
                                      width: 0,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : NoInternetErrorWidget(
                              connected: connected, issplashscreen: false),
                    ]);

                    // onRefresh: refreshPage,
                  },
                  child: Container())),
          onRefresh: refreshPage,
        ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    // print("call refresh");
    _homeBloc.add(FetchBottomNavigationBar());
  }
}
