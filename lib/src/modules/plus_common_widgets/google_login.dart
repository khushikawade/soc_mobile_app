// ignore_for_file: deprecated_member_use

import 'package:Soc/src/modules/graded_plus/helper/graded_overrides.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../../globals.dart';
import '../../services/Strings.dart';
import '../../services/local_database/local_db.dart';
import '../../services/utility.dart';
import '../../widgets/google_auth_webview.dart';
import '../google_classroom/modal/google_classroom_courses.dart';
import '../google_drive/bloc/google_drive_bloc.dart';
import '../../services/user_profile.dart';
import '../graded_plus/bloc/graded_plus_bloc.dart';

class GoogleLogin {
  //To authenticate the user via google
  static launchURL(String? title, context, _scaffoldKey, String? buttonPressed,
      String? activityType,
      {required String userType}) async {
    FirebaseAnalyticsService.addCustomAnalyticsEvent("google_login");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'google_login', screenClass: 'GoogleLogin');

    // final OcrBloc _ocrBlocLogs = new OcrBloc();
    // int myTimeStamp = DateTime.now().microsecondsSinceEpoch; //To TimeStamp
    var themeColor = Theme.of(context).backgroundColor == Color(0xff000000)
        ? Color(0xff000000)
        : Color(0xffFFFFFF);

    var value = await pushNewScreen(
      context,
      screen: GoogleAuthWebview(
        title: title!,
        url: (Globals.appSetting.authenticationURL != null ||
                Globals.appSetting.authenticationURL!.isNotEmpty)
            ? ("${Globals.appSetting.authenticationURL}" +
                '' + //Overrides.secureLoginURL +
                '?' +
                Globals.appSetting.appLogoC +
                '?' +
                themeColor.toString().split('0xff')[1].split(')')[0])
            : Overrides.STANDALONE_GRADED_APP
                ? OcrOverrides.googleClassroomAuthURL!
                : OcrOverrides.googleDriveAuthURL!,
        isBottomSheet: true,
        language: Globals.selectedLanguage,
        hideAppbar: false,
        hideShare: true,
        zoomEnabled: false,
      ),
      withNavBar: false,
    );

    if (value.toString().contains('authenticationfailure')) {
      Globals.sessionId = await PlusUtility.updateUserLogsSessionId();

      PlusUtility.updateLogs(
          activityType: 'GRADED+',
          userType: 'Teacher',
          activityId: '2',
          description: 'Authentication Failure',
          operationResult: 'Failure');

      Utility.currentScreenSnackBar(
          'You are not authorized to access the feature. Please use the authorized account.',
          null);

      return false;
    } else if (value.toString().contains('success')) {
      value = value.split('?')[1] ?? '';
      //Save user profile
      await saveUserProfile(value, userType);
      List<UserInformation> _userProfileLocalData =
          await UserGoogleProfile.getUserProfile();

      GoogleLogin.verifyUserAndGetDriveFolder(_userProfileLocalData, userType);

      Globals.sessionId = await PlusUtility.updateUserLogsSessionId();

      PlusUtility.updateLogs(
          activityType: 'GRADED+',
          userType: 'Teacher',
          activityId: '2',
          description: 'Google Authentication Success/Login Id:',
          operationResult: 'Success');

      // Log Firebase Event
      FirebaseAnalyticsService.setUserId(id: Globals.userEmailId);
      FirebaseAnalyticsService.logLogin(method: 'Google');
      FirebaseAnalyticsService.setUserProperty(
          key: 'email', value: Globals.userEmailId);
      // Log End

      // Push to the grading system
      if (Overrides.STANDALONE_GRADED_APP == true) {
        // clean imported roster on fresh login
        LocalDatabase<GoogleClassroomCourses> _localDb =
            LocalDatabase(Strings.googleClassroomCoursesList);

        _localDb.clear();
        _localDb.close();

        return true;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  static Future<void> saveUserProfile(
      String profileData, String userType) async {
    List<String> profile = profileData.split('+');
    UserInformation _userInformation = UserInformation(
        userName: profile[0].toString().split('=')[1],
        userEmail: profile[1].toString().split('=')[1],
        profilePicture: profile[2].toString().split('=')[1],
        userType: userType,
        authorizationToken:
            profile[3].toString().split('=')[1].replaceAll('#', ''),
        refreshToken: profile[4].toString().split('=')[1].replaceAll('#', ''));

    //Save user profile to locally
    //UPDATE CURRENT GOOGLE USER PROFILE
    await UserGoogleProfile.updateUserProfile(_userInformation);
  }

  static verifyUserAndGetDriveFolder(
      List<UserInformation> _userProfileLocalData, String role) async {
    OcrBloc _ocrBloc = new OcrBloc();
    GoogleDriveBloc _googleDriveBloc = new GoogleDriveBloc();
    //Verifying with Salesforce if user exist in contact
    _ocrBloc.add(AuthorizedUserWithDatabase(
        email: _userProfileLocalData[0].userEmail, role: role));

    // Creating a assessment folder in users google drive to maintain all the assessments together at one place
    _googleDriveBloc.add(GetDriveFolderIdEvent(
        isReturnState: false,
        //  filePath: file,
        token: _userProfileLocalData[0].authorizationToken,
        folderName: "SOLVED GRADED+",
        refreshToken: _userProfileLocalData[0].refreshToken));
  }
}
