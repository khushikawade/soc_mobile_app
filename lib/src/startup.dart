import 'dart:io';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:Soc/src/modules/globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'globals.dart';

class StartupPage extends StatefulWidget {
  @override
  _StartupPageState createState() => new _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  bool flag = true;
  bool showlogin = true;
  final HomeBloc _bloc = new HomeBloc();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  AndroidDeviceInfo? andorid;
  IosDeviceInfo? ios;
  void initState() {
    super.initState();
    getDeviceType();
    // startTimer();
    _bloc.add(FetchBottomNavigationBar());
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        andorid = await deviceInfoPlugin.androidInfo;
        // deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        ios = await deviceInfoPlugin.iosInfo;
        // deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
      // ignore: nullable_type_in_catch_clause
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

  //  setState(() {
  //     _deviceData = deviceData;
  //   });
  // }

  getDeviceType() async {
    if (Platform.isAndroid) {
      // deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      final data = (MediaQueryData.fromWindow(WidgetsBinding.instance!.window));
      andorid = await deviceInfoPlugin.androidInfo;
      Globals.phoneModel = andorid!.device;
      Globals.baseOS = andorid!.version.baseOS;
      // globals.deviceType = data.size.shortestSide < 600 ? 'tablet' :'tablet';
      Globals.deviceType = data.size.shortestSide < 600 ? 'phone' : 'tablet';
      print("${Globals.deviceType}");
    } else {
      // var deviceType = await getDeviceInfo();
      // Globals.deviceType = deviceType == "ipad" ? "tablet" : "phone";
      print("else");
      print("${Globals.deviceType}");
    }
  }

  // Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  //   return <String, dynamic>{
  //     'version.securityPatch': build.version.securityPatch,
  //     'version.sdkInt': build.version.sdkInt,
  //     'version.release': build.version.release,
  //     'version.previewSdkInt': build.version.previewSdkInt,
  //     'version.incremental': build.version.incremental,
  //     'version.codename': build.version.codename,
  //     'version.baseOS': build.version.baseOS,
  //     'board': build.board,
  //     'bootloader': build.bootloader,
  //     'brand': build.brand,
  //     'device': build.device,
  //     'display': build.display,
  //     'fingerprint': build.fingerprint,
  //     'hardware': build.hardware,
  //     'host': build.host,
  //     'id': build.id,
  //     'manufacturer': build.manufacturer,
  //     'model': build.model,
  //     'product': build.product,
  //     'supported32BitAbis': build.supported32BitAbis,
  //     'supported64BitAbis': build.supported64BitAbis,
  //     'supportedAbis': build.supportedAbis,
  //     'tags': build.tags,
  //     'type': build.type,
  //     'isPhysicalDevice': build.isPhysicalDevice,
  //     'androidId': build.androidId,
  //     'systemFeatures': build.systemFeatures,
  //   };
  // }

  // Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  //   return <String, dynamic>{
  //     'name': data.name,
  //     'systemName': data.systemName,
  //     'systemVersion': data.systemVersion,
  //     'model': data.model,
  //     'localizedModel': data.localizedModel,
  //     'identifierForVendor': data.identifierForVendor,
  //     'isPhysicalDevice': data.isPhysicalDevice,
  //     'utsname.sysname:': data.utsname.sysname,
  //     'utsname.nodename:': data.utsname.nodename,
  //     'utsname.release:': data.utsname.release,
  //     'utsname.version:': data.utsname.version,
  //     'utsname.machine:': data.utsname.machine,
  //   };
  // }

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
              state.obj != null
                  ? Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          title: "SOC",
                          obj: state.obj,
                        ),
                      ))
                  : Text("No data found");
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
