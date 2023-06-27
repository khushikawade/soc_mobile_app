import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
// import SwiftUI
// import GoogleSignIn

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyBg_c2zU4RdDOUtu6dbNhp8xIJvjy3r01g")
    GeneratedPluginRegistrant.register(with: self)

    // // Add the following line to configure Google Sign-In
    // GIDSignIn.sharedInstance().clientID = "YOUR_CLIENT_ID"

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
// class AppDelegate: NSObject, UIApplicationDelegate {
//   func application(_ application: UIApplication,
//                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//     FirebaseApp.configure()

//     return true
//   }
// }

// @main
// struct YourApp: App {
//   // register app delegate for Firebase setup
//   @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


//   var body: some Scene {
//     WindowGroup {
//       NavigationView {
//         ContentView()
//       }
//     }
//   }
// }