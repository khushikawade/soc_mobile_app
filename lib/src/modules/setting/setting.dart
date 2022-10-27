import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/setting/licenceinfo.dart';
import 'package:Soc/src/overrides.dart';
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
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_store/open_store.dart';

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
    if (Overrides.STANDALONE_GRADED_APP != true) {
      OneSignal.shared
          .getDeviceState()
          .then((value) => {pushState(value!.pushDisabled)});
    }
    _homeBloc.add(FetchStandardNavigationBar());
    Globals.callsnackbar = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
            message: "Enable Notifications",
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
              message: "Open Source Licenses",
              fromLanguage: "en",
              toLanguage: Globals.selectedLanguage,
              builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                    style: Theme.of(context).textTheme.headline2!,
                  ))),
    );
  }

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
      Overrides.STANDALONE_GRADED_APP == true
          ? Container()
          : _buildHeading("Push Notifications"),
      Overrides.STANDALONE_GRADED_APP == true
          ? Container()
          : _buildNotification(),
      // _buildHeading('Display Setting'),
      // _buildSystemThemeMode(),
      // _buildThemeMode(),
      _buildHeading("Acknowledgements"),
      _buildLicence(),
      _buildHeading("App Version"),
      _appVersion(), _buildHeading("App Store"),
      _storOnTap('Go To Store'),
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
          appBarTitle: 'Settings',
          isSearch: false,
          isShare: false,
          sharedpopBodytext: '',
          sharedpopUpheaderText: '',
          language: Globals.selectedLanguage,
        ),
        body: RefreshIndicator(
          key: refreshKey,
          child: Container(
              child: Column(
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

                        Globals.appSetting = AppSetting.fromJson(state.obj);
                        isloadingstate = false;
                        setState(() {});
                      }
                    },
                    child: EmptyContainer()),
              ),
            ],
          )),
          onRefresh: refreshPage,
        ));
  }

  _appStoreOnTap() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print(packageInfo);
    OpenStore.instance.open(
      appStoreId: packageInfo.buildSignature, // AppStore id of your app for iOS

      androidAppBundleId:
          packageInfo.packageName, // Android app bundle package name
    );
  }

  Widget _storOnTap(String text) {
    return InkWell(
      onTap: _appStoreOnTap,
      child: Container(
          padding: EdgeInsets.all(16),
          child: Text(
            text,
            style: Theme.of(context).textTheme.headline2!,
          )),
    );
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    _homeBloc.add(FetchStandardNavigationBar());
  }
}
