import 'dart:async';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/shared_preference.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/error_icon_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/error_message_widget.dart';
import 'package:Soc/src/widgets/no_internet_icon.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../globals.dart';
import '../bloc/user_bloc.dart';

class StartupPage extends StatefulWidget {
  @override
  _StartupPageState createState() => new _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  bool flag = true;
  bool showlogin = true;
  final HomeBloc _bloc = new HomeBloc();
  UserBloc _loginBloc = new UserBloc();
  final NewsBloc _newsBloc = new NewsBloc();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  AndroidDeviceInfo? andorid;
  IosDeviceInfo? ios;
  bool? isnetworkisuue = false;
  final SharedPreferencesFn _sharedPref = SharedPreferencesFn();

  void initState() {
    super.initState();
    getindicatorValue();
    initPlatformState();
    _loginBloc.add(PerfomLogin());
    _newsBloc.add(FetchNotificationList());
    // timer =
    //     Timer.periodic(Duration(seconds: 5), (Timer t) => getindicatorValue());
  }

  @override
  void dispose() {
    _bloc.close();
    _loginBloc.close();

    super.dispose();
  }

  getindicatorValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getBool("enableIndicator") == null
        ? prefs.setBool("enableIndicator", false)
        : prefs.setBool("enableIndicator", prefs.getBool("enableIndicator")!);

    Globals.selectedLanguage = await _sharedPref.getString('selected_language');
  }

  Future<void> initPlatformState() async {
    try {
      if (Platform.isAndroid) {
        andorid = await deviceInfoPlugin.androidInfo;
        // final data =
        //     (MediaQueryData.fromWindow(WidgetsBinding.instance!.window));

        // Globals.phoneModel = andorid!.device;
        Globals.baseOS = andorid!.version.baseOS;
        // Globals.deviceType = data.size.shortestSide < 600 ? 'phone' : 'tablet';
        Globals.androidInfo = await DeviceInfoPlugin().androidInfo;

        // Globals.release = androidInfo.version.release;
        // // var sdkInt = androidInfo.version.sdkInt;
        // Globals.manufacturer = androidInfo.manufacturer;
        // Globals.model = androidInfo.model;
        // Globals.deviceToken = androidInfo.androidId;
        Globals.myLocale = Localizations.localeOf(context);
        // Globals.countrycode = Localizations.localeOf(context).countryCode!;
      } else if (Platform.isIOS) {
        ios = await deviceInfoPlugin.iosInfo;
        var iosInfo = await DeviceInfoPlugin().iosInfo;
        Globals.iosInfo = iosInfo;

        // Globals.manufacturer = iosInfo.systemName;
        // Globals.release = iosInfo.systemVersion;
        // Globals.name = iosInfo.name;
        // Globals.model = iosInfo.model;
      }
    } on PlatformException {
      // deviceData = <String, dynamic>{
      //   'Error:': 'Failed to get platform version.'
      // };
    }

    if (!mounted) return;
  }

  Widget _buildSplashScreen() {
    return Center(
      child: SizedBox(
        height: 200,
        width: 200,
        child:
            Image.asset('assets/images/splash_bear_icon.png', fit: BoxFit.fill),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          final call = connected ? _loginBloc.add(PerfomLogin()) : null;
          return new Stack(
            fit: StackFit.expand,
            children: [
              BlocBuilder<UserBloc, UserState>(
                  bloc: _loginBloc,
                  builder: (BuildContext contxt, UserState state) {
                    if (state is Loading) {
                      return _buildSplashScreen();
                    }

                    if (state is ErrorReceived) {
                      if (state.err == "NO_CONNECTION") {
                        isnetworkisuue = true;
                        return Stack(children: [
                          Positioned(
                            height: 20.0,
                            left: 0.0,
                            right: 0.0,
                            top: 25,
                            child: Container(
                              color: connected
                                  ? Color(0xFF00EE44)
                                  : Color(0xFFEE4400),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${connected ? 'ONLINE' : 'OFFLINE'}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    HorzitalSpacerWidget(16),
                                    connected
                                        ? Container(
                                            height: 0,
                                          )
                                        : SizedBox(
                                            height: 10,
                                            width: 10,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  child: NoInternetIconWidget(),
                                ),
                                SpacerWidget(12),
                                Text("No internet connection")
                              ]),
                        ]);
                      } else if (state.err == "Something went wrong") {
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ErrorMessageWidget(
                                imgURL: 'assets/images/no_data_icon.png',
                                msg: "No  data found",
                              ),
                              // SpacerWidget(12),
                              // Text("No  data found")
                            ]);
                      } else {
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(child: ErrorIconWidget()),
                              Text("Error")
                            ]);
                      }
                    }
                    return Container();
                  }),
              BlocListener<UserBloc, UserState>(
                bloc: _loginBloc,
                listener: (context, state) async {
                  if (state is LoginSuccess) {
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // setState(() {
                    //   _status = prefs.getBool("enableIndicator")!;
                    //   if (_status == true) {
                    //     indicator.value = true;
                    //   } else {
                    //     indicator.value = false;
                    //   }
                    // });
                    Globals.token != null && Globals.token != " "
                        ? _bloc.add(FetchBottomNavigationBar())
                        : Container(
                            child: Center(
                                child: Text("Please refresh your application")),
                          );
                  }
                },
                child: Container(),
              ),
              BlocListener<HomeBloc, HomeState>(
                bloc: _bloc,
                listener: (context, state) async {
                  if (state is BottomNavigationBarSuccess) {
                    AppTheme.setDynamicTheme(Globals.appSetting, context);
                    Globals.homeObjet = state.obj;
                    state.obj != null
                        ? Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                title: "SOC",
                                homeObj: state.obj,
                              ),
                            ))
                        : Center(child: Text("No data found"));
                  } else if (state is HomeErrorReceived) {
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Center(child: Text("Unable to load the data")),
                    );
                  }
                },
                child: Container(),
              ),
              BlocListener<NewsBloc, NewsState>(
                bloc: _newsBloc,
                listener: (context, state) async {
                  if (state is NewsLoaded) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    SharedPreferences intPrefs =
                        await SharedPreferences.getInstance();
                    intPrefs.getInt("totalCount") == null
                        ? intPrefs.setInt("totalCount", Globals.notiCount!)
                        : intPrefs.getInt("totalCount");
                    print(intPrefs.getInt("totalCount"));
                    if (Globals.notiCount! > intPrefs.getInt("totalCount")!) {
                      intPrefs.setInt("totalCount", Globals.notiCount!);
                      prefs.setBool("enableIndicator", true);
                    }
                  }
                },
                child: Container(),
              ),
            ],
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'There are no bottons to push :)',
            ),
            new Text(
              'Just turn off your internet.',
            ),
          ],
        ),
      ),
    );
  }
}
