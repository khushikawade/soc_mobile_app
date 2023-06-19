import 'package:Soc/src/modules/graded_plus/helper/graded_overrides.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../../globals.dart';
import '../../services/Strings.dart';
import '../../services/local_database/local_db.dart';
import '../../services/utility.dart';
import '../../startup.dart';
import '../../widgets/google_auth_webview.dart';
import '../google_classroom/modal/google_classroom_courses.dart';
import '../google_drive/bloc/google_drive_bloc.dart';
import '../../services/user_profile.dart';
import '../graded_plus/bloc/graded_plus_bloc.dart';

class GoogleLogin {
  //To authenticate the user via google
  static launchURL(String? title, context, _scaffoldKey, String? buttonPressed,
      String? activityType) async {
    FirebaseAnalyticsService.addCustomAnalyticsEvent("google_login");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'google_login', screenClass: 'GoogleLogin');

    final OcrBloc _ocrBlocLogs = new OcrBloc();
    int myTimeStamp = DateTime.now().microsecondsSinceEpoch; //To TimeStamp
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
      // Navigator.pop(context, false);
      // Globals.teacherEmailId = ;
      Globals.sessionId = "${Globals.teacherEmailId}_${myTimeStamp.toString()}";
      DateTime currentDateTime = DateTime.now();
      _ocrBlocLogs.add(LogUserActivityEvent(
          activityType: activityType,
          sessionId: '',
          teacherId: Globals.teacherId,
          activityId: '2',
          accountId: Globals.appSetting.schoolNameC,
          accountType: "Premium",
          dateTime: currentDateTime.toString(),
          description: 'Authentication Failure',
          operationResult: 'Failure'));
      Utility.currentScreenSnackBar(
          'You Are Not Authorized To Access The Feature. Please Use The Authorized Account.',
          null);
      // Utility.showSnackBar(
      //     _scaffoldKey,
      //     'You are not authorized to access the feature. Please use the authorized account.',
      //     context,
      //     50.0);
      return false;
    } else if (value.toString().contains('success')) {
      value = value.split('?')[1] ?? '';
      //Save user profile
      await saveUserProfile(value);
      List<UserInformation> _userProfileLocalData =
          await UserGoogleProfile.getUserProfile();

      verifyUserAndGetDriveFolder(_userProfileLocalData);

      Globals.teacherEmailId =
          _userProfileLocalData[0].userEmail!.split('@')[0];

      // Log Firebase Event
      FirebaseAnalyticsService.setUserId(id: Globals.teacherEmailId);
      FirebaseAnalyticsService.logLogin(method: 'Google');
      FirebaseAnalyticsService.setUserProperty(
          key: 'email', value: Globals.teacherEmailId);
      // Log End

      Globals.sessionId = "${Globals.teacherEmailId}_${myTimeStamp.toString()}";
      DateTime currentDateTime = DateTime.now();
      _ocrBlocLogs.add(LogUserActivityEvent(
          activityType: activityType,
          sessionId: Globals.sessionId,
          teacherId: Globals.teacherId,
          activityId: '2',
          accountId: Globals.appSetting.schoolNameC,
          accountType: "Premium",
          dateTime: currentDateTime.toString(),
          description: 'Google Authentication Success',
          operationResult: 'Success'));
      // Push to the grading system
      if (Overrides.STANDALONE_GRADED_APP == true) {
        print('local data base clear on login');
        // clean imported roster on fresh login
        LocalDatabase<GoogleClassroomCourses> _localDb =
            LocalDatabase(Strings.googleClassroomCoursesList);
        List<GoogleClassroomCourses>? _localData = await _localDb.getData();
        _localDb.clear();
        _localDb.close();

        return true;
        // pushNewScreen(context, screen: GradedLandingPage());
      } else {
        return true;
        // if (actionName == 'STUDENT+') {
        //   Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (context) => StudentPlusSearchPage(fromStudentPlus: false),
        //   ));
        //   // pushNewScreen(
        //   //   context,
        //   //   screen: StudentPlusSearchPage(
        //   //     fromStudentPlus: false,
        //       isOcrSection: Overrides.STANDALONE_GRADED_APP,
        //       skipAppSettingsFetch: true,
        //     ),
        //     withNavBar: false,
        //   );
        // }
        // pushNewScreen(
        //     context,
        //     screen: SelectAssessmentType(),
        //     withNavBar: false,
        //   );

      }
    } else {
      return false;
    }
  }

  static Future<void> saveUserProfile(String profileData) async {
    List<String> profile = profileData.split('+');
    UserInformation _userInformation = UserInformation(
        userName: profile[0].toString().split('=')[1],
        userEmail: profile[1].toString().split('=')[1],
        profilePicture: profile[2].toString().split('=')[1],
        authorizationToken:
            profile[3].toString().split('=')[1].replaceAll('#', ''),
        refreshToken: profile[4].toString().split('=')[1].replaceAll('#', ''));

    //Save user profile to locally
    LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
    await _localDb.addData(_userInformation);
    await _localDb.close();
  }

  static verifyUserAndGetDriveFolder(
      List<UserInformation> _userProfileLocalData) async {
    OcrBloc _ocrBloc = new OcrBloc();
    GoogleDriveBloc _googleDriveBloc = new GoogleDriveBloc();
    //Verifying with Salesforce if user exist in contact
    _ocrBloc
        .add(AuthorizedUserWithDatabase(email: _userProfileLocalData[0].userEmail,isAuthorized: false));

    // Creating a assessment folder in users google drive to maintain all the assessments together at one place
    Globals.googleDriveFolderId = '';
    _googleDriveBloc.add(GetDriveFolderIdEvent(
        isReturnState: false,
        //  filePath: file,
        token: _userProfileLocalData[0].authorizationToken,
        folderName: "SOLVED GRADED+",
        refreshToken: _userProfileLocalData[0].refreshToken));
  }
}
