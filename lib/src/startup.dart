import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart';
import 'modules/user/bloc/user_bloc.dart';

class StartupPage extends StatefulWidget {
  @override
  _StartupPageState createState() => new _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  bool flag = true;
  bool showlogin = true;
  final HomeBloc _bloc = new HomeBloc();
  UserBloc _loginBloc = new UserBloc();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  AndroidDeviceInfo? andorid;
  IosDeviceInfo? ios;
  void initState() {
    super.initState();
    // getDeviceType();
    getindicatorValue();
    initPlatformState();
    // getDeviceInfo();
    _loginBloc.add(PerfomLogin());
  }

  getindicatorValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getBool("enableIndicator") == null
        ? prefs.setBool("enableIndicator", false)
        : prefs.setBool("enableIndicator", prefs.getBool("enableIndicator")!);
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        andorid = await deviceInfoPlugin.androidInfo;
        final data =
            (MediaQueryData.fromWindow(WidgetsBinding.instance!.window));
        // andorid = await deviceInfoPlugin.androidInfo;
        Globals.phoneModel = andorid!.device;
        Globals.baseOS = andorid!.version.baseOS;
        Globals.deviceType = data.size.shortestSide < 600 ? 'phone' : 'tablet';
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        Globals.release = androidInfo.version.release;
        // var sdkInt = androidInfo.version.sdkInt;
        Globals.manufacturer = androidInfo.manufacturer;
        Globals.model = androidInfo.model;
        Globals.deviceToken = androidInfo.androidId;
        Globals.myLocale = Localizations.localeOf(context);
        Globals.countrycode = Localizations.localeOf(context).countryCode!;
      } else if (Platform.isIOS) {
        ios = await deviceInfoPlugin.iosInfo;
        var iosInfo = await DeviceInfoPlugin().iosInfo;
        Globals.manufacturer = iosInfo.systemName;
        Globals.release = iosInfo.systemVersion;
        Globals.name = iosInfo.name;
        Globals.model = iosInfo.model;
        // print('$systemName $version, $name $model');
        // iOS 13.1, iPhone 11 Pro Max iPhone
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  // getDeviceType() async {
  //   if (Platform.isAndroid) {
  //     final data = (MediaQueryData.fromWindow(WidgetsBinding.instance!.window));
  //     andorid = await deviceInfoPlugin.androidInfo;
  //     Globals.phoneModel = andorid!.device;
  //     Globals.baseOS = andorid!.version.baseOS;
  //     Globals.deviceType = data.size.shortestSide < 600 ? 'phone' : 'tablet';
  //     var androidInfo = await DeviceInfoPlugin().androidInfo;
  //     Globals.release = androidInfo.version.release;
  //     // var sdkInt = androidInfo.version.sdkInt;
  //     Globals.manufacturer = androidInfo.manufacturer;
  //     Globals.model = androidInfo.model;
  //     Globals.deviceToken = androidInfo.androidId;
  //     Globals.myLocale = Localizations.localeOf(context);
  //     Globals.countrycode = Localizations.localeOf(context).countryCode!;

  //     // print('Android $release (SDK $sdkInt), $manufacturer $model');
  //   }
  //   if (Platform.isIOS) {
  //     var iosInfo = await DeviceInfoPlugin().iosInfo;
  //     Globals.manufacturer = iosInfo.systemName;
  //     Globals.release = iosInfo.systemVersion;
  //     Globals.name = iosInfo.name;
  //     Globals.model = iosInfo.model;
  //     // print('$systemName $version, $name $model');
  //     // iOS 13.1, iPhone 11 Pro Max iPhone
  //   } else {}
  // }

  static Future<String> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    print(iosInfo.model.toLowerCase());
    return iosInfo.model.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Center(
          child: SizedBox(
            height: 200,
            width: 200,
            child: Image.asset('assets/images/splash_bear_icon.png',
                fit: BoxFit.fill),
          ),
        ),
        BlocListener<UserBloc, UserState>(
          bloc: _loginBloc,
          listener: (context, state) async {
            if (state is LoginSuccess) {
              Globals.token != null && Globals.token != " "
                  ? _bloc.add(FetchBottomNavigationBar())
                  : Container(
                      child: Text("Please refresh your application"),
                    );
            } else if (state is LoginError) {
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.8,
                child: Text("Unable to load the data"),
              );
            }
          },
          child: Container(),
        ),
        BlocListener<HomeBloc, HomeState>(
          bloc: _bloc,
          listener: (context, state) async {
            if (state is BottomNavigationBarSuccess) {
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
      ],
    ));
  }
}
