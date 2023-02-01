import 'dart:async';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

AndroidDeviceInfo? androidInfo;
IosDeviceInfo? iosInfo;

Future<void> initPlatformState(BuildContext context) async {
  try {
    if (Platform.isAndroid) {
      androidInfo = await DeviceInfoPlugin().androidInfo;
      Globals.manufacturer = androidInfo!.manufacturer;
      Globals.systemVersion = androidInfo!.version.release;
      Globals.model = androidInfo!.model;
      Globals.baseOS =
          Platform.operatingSystem + " " + androidInfo!.version.release;

      Globals.release = androidInfo!.version.release;
      Globals.deviceToken = androidInfo!.androidId;
      Globals.versionRelease = androidInfo!.version.release;
      Globals.myLocale = Localizations.localeOf(context);
      Globals.countryCode = Localizations.localeOf(context).countryCode!;
    } else if (Platform.isIOS) {
      iosInfo = await DeviceInfoPlugin().iosInfo;
      Globals.iosInfo = iosInfo;
      Globals.manufacturer = iosInfo!.systemName;
      Globals.systemVersion = Globals.release = iosInfo!.systemVersion;
      Globals.model = iosInfo!.name + iosInfo!.model;
      Globals.myLocale = Localizations.localeOf(context);
      Globals.countryCode = Localizations.localeOf(context).countryCode!;
    }
  } on PlatformException {
    // deviceData = <String, dynamic>{
    //   'Error:': 'Failed to get platform version.'
    // };
  }

  // if (!mounted) return;
}
