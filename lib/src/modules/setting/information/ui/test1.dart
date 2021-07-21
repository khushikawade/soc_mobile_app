// import 'dart:async';
// import 'package:meta/meta.dart';
// import 'package:flutter/services.dart';

// typedef Future<dynamic> OnCancelHandler();
// typedef Future<dynamic> OnErrorHandler(String error);
// typedef Future<dynamic> OnSuccessHandler(String postId);

// class SocialSharePlugin {
//   static const MethodChannel _channel =
//       const MethodChannel('social_share_plugin');

//   static Future<String> get platformVersion async {
//     final String version = await _channel.invokeMethod('getPlatformVersion');
//     return version;
//   }

//   static Future<void> shareToFeedInstagram({
//     String type = 'image/*',
//     @required String? path,
//     OnSuccessHandler? onSuccess,
//     OnCancelHandler? onCancel,
//   }) async {
//     _channel.setMethodCallHandler((call) {
//       switch (call.method) {
//         case "onSuccess":
//           return onSuccess!(call.arguments);
//         case "onCancel":
//           return onCancel!();
//         default:
//           throw UnsupportedError("Unknown method called");
//       }
//     });
//     return _channel.invokeMethod('shareToFeedInstagram', <String, dynamic>{
//       'type': type,
//       'path': path,
//     });
//   }

//   static Future<void> shareToFeedFacebook({
//     String? caption,
//     @required String? path,
//     OnSuccessHandler? onSuccess,
//     OnCancelHandler? onCancel,
//     OnErrorHandler? onError,
//   }) async {
//     _channel.setMethodCallHandler((call) {
//       switch (call.method) {
//         case "onSuccess":
//           return onSuccess!(call.arguments);
//         case "onCancel":
//           return onCancel!();
//         case "onError":
//           return onError!(call.arguments);
//         default:
//           throw UnsupportedError("Unknown method called");
//       }
//     });
//     return _channel.invokeMethod('shareToFeedFacebook', <String, dynamic>{
//       'caption': caption,
//       'path': path,
//     });
//   }

//   static Future<dynamic> shareToFeedFacebookLink({
//     String? quote,
//     @required String? url,
//     OnSuccessHandler? onSuccess,
//     OnCancelHandler? onCancel,
//     OnErrorHandler? onError,
//   }) async {
//     _channel.setMethodCallHandler((call) {
//       switch (call.method) {
//         case "onSuccess":
//           return onSuccess!(call.arguments);
//         case "onCancel":
//           return onCancel!();
//         case "onError":
//           return onError!(call.arguments);
//         default:
//           throw UnsupportedError("Unknown method called");
//       }
//     });
//     return _channel.invokeMethod('shareToFeedFacebookLink', <String, dynamic>{
//       'quote': quote,
//       'url': url,
//     });
//   }

//   static Future<dynamic> shareToTwitterLink({
//     String? text,
//     @required String? url,
//     OnSuccessHandler? onSuccess,
//     OnCancelHandler? onCancel,
//   }) async {
//     _channel.setMethodCallHandler((call) {
//       switch (call.method) {
//         case "onSuccess":
//           return onSuccess!(call.arguments);
//         case "onCancel":
//           return onCancel!();
//         //  case "onError":
//         //    return onError(call.arguments);
//         default:
//           throw UnsupportedError("Unknown method called");
//       }
//     });
//     return _channel.invokeMethod('shareToTwitterLink', <String, dynamic>{
//       'text': text,
//       'url': url,
//     });
//   }
// }

// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/services.dart';
// import 'package:social_share_plugin/social_share_plugin.dart';
// import 'package:image_picker/image_picker.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String _platformVersion = 'Unknown';

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     String platformVersion;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       platformVersion = await SocialSharePlugin.platformVersion;
//     } on PlatformException {
//       platformVersion = 'Failed to get platform version.';
//     }

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     setState(() {
//       _platformVersion = platformVersion;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Column(
//           children: <Widget>[
//             Center(
//               child: Text('Running on: $_platformVersion\n'),
//             ),
//             RaisedButton(
//               child: Text('Share to Instagram'),
//               onPressed: () async {
//                 File file =
//                     await ImagePicker.pickImage(source: ImageSource.gallery);
//                 await SocialSharePlugin.shareToFeedInstagram(
//                     "image/*", file.path);
//               },
//             ),
//             RaisedButton(
//               child: Text('Share to Facebook'),
//               onPressed: () async {
//                 File file =
//                     await ImagePicker.pickImage(source: ImageSource.gallery);
//                 await SocialSharePlugin.shareToFeedFacebook('test', file.path);
//               },
//             ),
//             RaisedButton(
//               child: Text('Share to Facebook Link'),
//               onPressed: () async {
//                 String url = 'https://flutter.dev/';
//                 final quote =
//                     'Flutter is Google’s portable UI toolkit for building beautiful, natively-compiled applications for mobile, web, and desktop from a single codebase.';
//                 final result = await SocialSharePlugin.shareToFeedFacebookLink(
//                   quote: quote,
//                   url: url,
//                   onSuccess: (postId) {
//                     print('FACEBOOK SUCCESS $postId');
//                     return;
//                   },
//                   onCancel: () {
//                     print('FACEBOOK CANCELLED');
//                     return;
//                   },
//                   onError: (error) {
//                     print('FACEBOOK ERROR $error');
//                     return;
//                   },
//                 );

//                 print(result);
//               },
//             ),
//             RaisedButton(
//               child: Text('Share to Twitter'),
//               onPressed: () async {
//                 String url = 'https://flutter.dev/';
//                 final text =
//                     'Flutter is Google’s portable UI toolkit for building beautiful, natively-compiled applications for mobile, web, and desktop from a single codebase.';
//                 final result = await SocialSharePlugin.shareToTwitter(
//                     text: text,
//                     url: url,
//                     onSuccess: (_) {
//                       print('TWITTER SUCCESS');
//                       return;
//                     },
//                     onCancel: () {
//                       print('TWITTER CANCELLED');
//                       return;
//                     });
//                 print(result);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
