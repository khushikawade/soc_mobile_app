//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import connectivity_plus_macos
import firebase_analytics
import firebase_core
<<<<<<< HEAD
import geolocator_apple
import network_info_plus_macos
import package_info_plus_macos
import path_provider_macos
import shared_preferences_macos
=======
import firebase_crashlytics
import geolocator_apple
import network_info_plus_macos
import package_info_plus_macos
import path_provider_foundation
import shared_preferences_foundation
>>>>>>> c1fc0d1b72ada057fa87fe16a2d4e6fe1c10328c
import sqflite
import url_launcher_macos
import wakelock_macos

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  ConnectivityPlugin.register(with: registry.registrar(forPlugin: "ConnectivityPlugin"))
  FLTFirebaseAnalyticsPlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseAnalyticsPlugin"))
  FLTFirebaseCorePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseCorePlugin"))
<<<<<<< HEAD
=======
  FLTFirebaseCrashlyticsPlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseCrashlyticsPlugin"))
>>>>>>> c1fc0d1b72ada057fa87fe16a2d4e6fe1c10328c
  GeolocatorPlugin.register(with: registry.registrar(forPlugin: "GeolocatorPlugin"))
  NetworkInfoPlusPlugin.register(with: registry.registrar(forPlugin: "NetworkInfoPlusPlugin"))
  FLTPackageInfoPlusPlugin.register(with: registry.registrar(forPlugin: "FLTPackageInfoPlusPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
  UrlLauncherPlugin.register(with: registry.registrar(forPlugin: "UrlLauncherPlugin"))
  WakelockMacosPlugin.register(with: registry.registrar(forPlugin: "WakelockMacosPlugin"))
}
