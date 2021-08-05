import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  void initState() {
    super.initState();
    getindicatorValue();
    initPlatformState();
    _loginBloc.add(PerfomLogin());
    _newsBloc.add(FetchNotificationList());
  }

  getindicatorValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getBool("enableIndicator") == null
        ? prefs.setBool("enableIndicator", false)
        : prefs.setBool("enableIndicator", prefs.getBool("enableIndicator")!);
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
        body: Stack(
      children: [
        // Column(
        //   children: [
        //     Container(
        //       alignment: Alignment.center,
        //       height: MediaQuery.of(context).size.height * 0.8,
        //       child: Text("Please check internet connection"),
        //     ),
        //     ElevatedButton(
        //       onPressed: () {
        //         _loginBloc.add(PerfomLogin());
        //       },
        //       child: Text('Refresh'),
        //       style: ElevatedButton.styleFrom(
        //         padding: EdgeInsets.all(20),
        //         // primary:
        //         //     Theme.of(context).colorScheme.onPrimary, // <-- Button color
        //         // onPrimary:
        //         //     Theme.of(context).colorScheme.primary, // <-- Splash color
        //       ),
        //     )
        //   ],
        // ),
        _buildSplashScreen(),
        // Globals.isnetworkexception!
        //     ? Container(child: Text("error"))
        //     : _buildSplashScreen(),
        // Globals.isnetworkexception!
        //     ? Center(
        //         child: SizedBox(
        //           height: 200,
        //           width: 200,
        //           child: Text("Unable to load the data"),
        //         ),
        //       )
        //     :

        BlocBuilder<UserBloc, UserState>(
            bloc: _loginBloc,
            builder: (BuildContext contxt, UserState state) {
              if (state is ErrorReceived) {
                // if (state.err == "NO_CONNECTION") {

                return Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Text("Please check internet connection"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _loginBloc.add(PerfomLogin());
                      },
                      child: Text('Refresh'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        // primary:
                        //     Theme.of(context).colorScheme.onPrimary, // <-- Button color
                        // onPrimary:
                        //     Theme.of(context).colorScheme.primary, // <-- Splash color
                      ),
                    )
                  ],
                );
              }
              return Container();
            }),

        BlocListener<UserBloc, UserState>(
          bloc: _loginBloc,
          listener: (context, state) async {
            if (state is LoginSuccess) {
              Globals.token != null && Globals.token != " "
                  ? _bloc.add(FetchBottomNavigationBar())
                  : Container(
                      child: Text("Please refresh your application"),
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
                  : Text("No data found");
            } else if (state is HomeErrorReceived) {
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.8,
                child: Text("Unable to load the data"),
              );
            }
          },
          child: Container(),
        ),
        BlocListener<NewsBloc, NewsState>(
          bloc: _newsBloc,
          listener: (context, state) async {
            if (state is NewsLoaded) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
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
    ));
  }
}
