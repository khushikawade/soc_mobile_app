import 'dart:async';
import 'dart:io';
import 'package:app/src/services/db_service.dart';
import 'package:app/src/services/shared_preference.dart';
import 'package:app/src/Globals.dart';
import 'package:app/src/modules/user/ui/login.dart';
import 'package:app/src/services/db_service_response.model.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:app/src/Globals.dart' as ;

class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() => new _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final DbServices _dbServices = DbServices();
  final SharedPreferencesFn _sharedPref = SharedPreferencesFn();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    initdynamiclink();
    // initDeviceId();
  }

  Future<void> initdynamiclink() async {
    // Timer timer = // UNCOMMENT
    //     new Timer(new Duration(seconds: Platform.isAndroid ? 2 : 3), () async {
    //   final PendingDynamicLinkData data =
    //       await FirebaseDynamicLinks.instance.getInitialLink();
    //   final Uri deepLink = data?.link;
    //   _retrieveDynamicLink(deepLink);
    //   // on opened state
    //   FirebaseDynamicLinks.instance.onLink(
    //       onSuccess: (PendingDynamicLinkData dynamicLink) async {
    //     final Uri _deepLink = dynamicLink?.link;
    //     if (_deepLink != null) {
    //       print("Opened link while RUNNING state");
    //       _retrieveDynamicLink(_deepLink);
    //     }
    //   }, onError: (OnLinkErrorException e) async {
    //     print('onLinkError');
    //     print(e.message);
    //   });
    // });
  }

  Future<void> _retrieveDynamicLink(deepLink) async {
    if (deepLink != null) {
      //   print("Opened by the link-----------");
      //   print(deepLink);
      //    if (deepLink.queryParameters["username"] != null &&
      //       deepLink.queryParameters["username"] != "") {
      //     Globals.linkUsername = deepLink.queryParameters["username"];
      //     Globals.linkPassword = deepLink.queryParameters["password"];
      //     Globals.isOpenByLink = true;
      //     print("Globals.isOpenByLink------------------------------");
      //     print(Globals.isOpenByLink);
      //     print("User credentials ${Globals.linkUsername} - ${Globals.linkPassword}");
      //   }
      // } else {
      //   print("Not opened by the link");
      // }

      if (deepLink.queryParameters["uname"] != null &&
          deepLink.queryParameters["uname"] != "") {
        //// FOr setting icon start
        String? _dbKey = deepLink.queryParameters["dbapikey"] != null
            ? deepLink.queryParameters["dbapikey"]
            : deepLink.queryParameters["dbApiKey"];
        // Setting icon end
        Globals.linkUsername = deepLink.queryParameters["uname"];
        Globals.linkPassword = deepLink.queryParameters["token"];
        Globals.isOpenByLink = true;
        await setDbKey(_dbKey);
      } else {
        String? _dbKey = deepLink.path.split("/").last;
        await setDbKey(_dbKey);
      }
    } else {
    }
  }

  setDbKey(key) async {
    if (key == null) return;
    await _sharedPref.setString("dbApiKey", key);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Container(
                    child: Image.asset('assets/images/splash.jpg',
                        fit: BoxFit.cover)))
          ]),
        ));
  }
}
