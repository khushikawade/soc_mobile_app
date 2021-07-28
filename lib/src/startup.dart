import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'globals.dart' as globals;
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
    getDeviceType();

    _loginBloc.add(PerfomLogin());
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        andorid = await deviceInfoPlugin.androidInfo;
      } else if (Platform.isIOS) {
        ios = await deviceInfoPlugin.iosInfo;
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

  getDeviceType() async {
    if (Platform.isAndroid) {
      final data = (MediaQueryData.fromWindow(WidgetsBinding.instance!.window));
      andorid = await deviceInfoPlugin.androidInfo;
      Globals.phoneModel = andorid!.device;
      Globals.baseOS = andorid!.version.baseOS;
    } else {}
  }

  static Future<String> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

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
