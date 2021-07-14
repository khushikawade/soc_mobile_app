import 'dart:io';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/modules/globals.dart' as globals;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartupPage extends StatefulWidget {
  @override
  _StartupPageState createState() => new _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  bool flag = true;
  bool showlogin = true;
  final HomeBloc _bloc = new HomeBloc();
  void initState() {
    super.initState();
    getDeviceType();
    // startTimer();
    _bloc.add(FetchBottomNavigationBar());
  }

  getDeviceType() async {
    if (Platform.isAndroid) {
      final data = (MediaQueryData.fromWindow(WidgetsBinding.instance!.window));
      // globals.deviceType = data.size.shortestSide < 600 ? 'tablet' :'tablet';
      globals.deviceType = data.size.shortestSide < 600 ? 'phone' : 'tablet';
      print("${globals.deviceType}");
    } else {
      var deviceType = await getDeviceInfo();
      globals.deviceType = deviceType == "ipad" ? "tablet" : "phone";
    }
  }

  static Future<String> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

    return iosInfo.model.toLowerCase();
  }

  // start splash screen timer
  // void startTimer() {
  //   Future.delayed(const Duration(seconds: 5), () {
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => HomePage(
  //             title: "SOC",
  //           ),
  //         ));
  //   });
  // }

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
        BlocListener<HomeBloc, HomeState>(
          bloc: _bloc,
          listener: (context, state) async {
            if (state is BottomNavigationBarSuccess) {
              print(
                  "Inside data +++++++++++++++++++++++++++++++++++++++++++ : ${state.obj}");
              // Future.delayed(const Duration(seconds: 5), () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      title: "SOC",
                      obj: state.obj,
                    ),
                  ));
              // });
            }
          },
          child: Container(
            height: 0,
            width: 0,
          ),
        )
      ],
    ));
  }
}
