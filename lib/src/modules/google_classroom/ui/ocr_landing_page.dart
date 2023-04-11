// import 'package:Soc/src/globals.dart';
// import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
// import 'package:Soc/src/modules/google_drive/model/user_profile.dart';
// import 'package:Soc/src/modules/graded_plus/bloc/ocr_bloc.dart';
// import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
// import 'package:Soc/src/modules/graded_plus/ui/ocr_home.dart';
// import 'package:Soc/src/services/local_database/local_db.dart';
// import 'package:Soc/src/services/utility.dart';
// import 'package:Soc/src/widgets/google_auth_webview.dart';
// import 'package:flutter/material.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

// class OcrLandingPage extends StatefulWidget {
//   @override
//   _OcrLandingPageState createState() => _OcrLandingPageState();
// }

// class _OcrLandingPageState extends State<OcrLandingPage> {
//   // Graded+ Initialization
//   GoogleDriveBloc _googleDriveBloc = new GoogleDriveBloc();
//   OcrBloc _ocrBloc = new OcrBloc();
//   verifyUserAndGetDriveFolder(
//       List<UserInformation> _userprofilelocalData) async {
//     //Verifying with Salesforce if user exist in contact
//     _ocrBloc
//         .add(VerifyUserWithDatabase(email: _userprofilelocalData[0].userEmail));

//     //Creating a assessment folder in users google drive to maintain all the assessments together at one place
//     Globals.googleDriveFolderId = '';
//     _googleDriveBloc.add(GetDriveFolderIdEvent(
//         isFromOcrHome: false,
//         //  filePath: file,
//         token: _userprofilelocalData[0].authorizationToken,
//         folderName: "SOLVED GRADED+",
//         refreshtoken: _userprofilelocalData[0].refreshToken));
//   }

//   Future<void> saveUserProfile(String profileData) async {
//     List<String> profile = profileData.split('+');
//     UserInformation _userInformation = UserInformation(
//         userName: profile[0].toString().split('=')[1],
//         userEmail: profile[1].toString().split('=')[1],
//         profilePicture: profile[2].toString().split('=')[1],
//         authorizationToken:
//             profile[3].toString().split('=')[1].replaceAll('#', ''),
//         refreshToken: profile[4].toString().split('=')[1].replaceAll('#', ''));

//     //Save user profile to locally
//     LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
//     await _localDb.addData(_userInformation);
//     await _localDb.close();
//   }

//   _launchURL(String? title) async {
//     var themeColor = Theme.of(context).backgroundColor == Color(0xff000000)
//         ? Color(0xff000000)
//         : Color(0xffFFFFFF);

//     var value = await pushNewScreen(
//       context,
//       screen: GoogleAuthWebview(
//         title: title!,
//         url: Globals.appSetting.authenticationURL ??
//             '' + //Overrides.secureLoginURL +
//                 '?' +
//                 Globals.appSetting.appLogoC +
//                 '?' +
//                 themeColor.toString().split('0xff')[1].split(')')[0],
//         isbuttomsheet: true,
//         language: Globals.selectedLanguage,
//         hideAppbar: false,
//         hideShare: true,
//         zoomEnabled: false,
//       ),
//       withNavBar: false,
//     );

//     if (value.toString().contains('authenticationfailure')) {
//       Navigator.pop(context, false);
//       // Utility.showSnackBar(
//       //     _scaffoldKey,
//       //     'You are not authorized to access the feature. Please use the authorized account.',
//       //     context,
//       //     50.0);
//     } else if (value.toString().contains('success')) {
//       value = value.split('?')[1] ?? '';
//       //Save user profile
//       await saveUserProfile(value);
//       List<UserInformation> _userprofilelocalData =
//           await UserGoogleProfile.getUserProfile();
//       verifyUserAndGetDriveFolder(_userprofilelocalData);
//       // Push to the grading system
//       Navigator.pushReplacement<void, void>(
//         context,
//         MaterialPageRoute<void>(
//           builder: (BuildContext context) =>
//               const OpticalCharacterRecognition(),
//         ),
//       );
//     }
//   }

//   _navigate() async {
//     List<UserInformation> _profileData =
//         await UserGoogleProfile.getUserProfile();
//     if (_profileData.isEmpty) {
//       await _launchURL('Google Authentication');
//     } else {
//       // await _launchURL('Google Authentication');
//       List<UserInformation> _userprofilelocalData =
//           await UserGoogleProfile.getUserProfile();
//       verifyUserAndGetDriveFolder(_profileData);

//       Navigator.pushReplacement<void, void>(
//         context,
//         MaterialPageRoute<void>(
//           builder: (BuildContext context) =>
//               const OpticalCharacterRecognition(),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('OcrLanding'),
//         ),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(
//               child: TextButton(
//                 child: Text("Scan Assessment"),
//                 onPressed: () {
//                   _navigate();
//                 },
//               ),
//             ),
//              Center(
//               child: TextButton(
//                 child: Text("Import Roster"),
//                 onPressed: () {
//                   // _navigate();
//                   Utility.showBottomSheet(Center(child: Text("Coming Soon"),), context);
//                 },
//               ),
//             ),
//           ],
//         ));
//   }
// }
