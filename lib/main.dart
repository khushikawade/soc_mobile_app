import 'dart:io';
import 'package:Soc/src/app.dart';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/model/recent.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive
    ..init(appDocumentDirectory.path)
    ..registerAdapter(RecentAdapter());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft
  ]).then((_) {
    runApp(App());
  });
  getDeviceType();
}

Future<String> getDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  return iosInfo.model.toLowerCase();
}

getDeviceType() async {
  if (Platform.isAndroid) {
    final data = (MediaQueryData.fromWindow(WidgetsBinding.instance!.window));
    Globals.deviceType = data.size.shortestSide < 600 ? 'phone' : 'tablet';
  } else if (Platform.isIOS) {
    final deviceType = await getDeviceInfo();
    Globals.deviceType = deviceType == "ipad" ? "tablet" : "phone";
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_offline/flutter_offline.dart';

// void main() async {
//   runApp(OffLineDemo());
// }

// class OffLineDemo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: new Scaffold(
//         appBar: new AppBar(
//           title: new Text("Offline Demo"),
//         ),
//         body: OfflineBuilder(
//           connectivityBuilder: (
//             BuildContext context,
//             ConnectivityResult connectivity,
//             Widget child,
//           ) {
//             final bool connected = connectivity != ConnectivityResult.none;
//             return new Stack(
//               fit: StackFit.expand,
//               children: [
//                 Positioned(
//                   height: 24.0,
//                   left: 0.0,
//                   right: 0.0,
//                   child: Container(
//                     color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
//                     child: Center(
//                       child: Text(
//                           "${connected ? 'Refresh the Page' : 'No Intenet'}"),
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: new Text(
//                     'Yay!',
//                   ),
//                 ),
//               ],
//             );
//           },
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               new Text(
//                 'There are no bottons to push :)',
//               ),
//               new Text(
//                 'Just turn off your internet.',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
