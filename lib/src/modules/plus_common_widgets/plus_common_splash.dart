import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/modal/custom_intro_content_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/bottom_navbar_home.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_intro_tutorial_section.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_home.dart';
import 'package:Soc/src/modules/plus_common_widgets/google_login.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/ui/family_ui/student_plus_family_login.dart';
import 'package:Soc/src/modules/student_plus/ui/student_plus_ui/student_plus_home.dart';
import 'package:Soc/src/modules/student_plus/ui/student_plus_ui/student_plus_search_page.dart';
import 'package:Soc/src/services/google_authentication.dart';
import 'package:Soc/src/services/local_database/hive_db_services.dart';
import 'package:Soc/src/services/user_profile.dart';
import 'package:flutter/material.dart';

class PlusSplashScreen extends StatefulWidget {
  final String actionName;
  final String sectionType;
  final StudentPlusDetailsModel? studentDetail;
  const PlusSplashScreen(
      {Key? key,
      required this.actionName,
      required this.sectionType,
      this.studentDetail})
      : super(key: key);

  @override
  State<PlusSplashScreen> createState() => _PlusSplashScreenState();
}

class _PlusSplashScreenState extends State<PlusSplashScreen> {
  final StudentPlusDetailsModel studentDetails = new StudentPlusDetailsModel();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.sectionType == 'Family'
          ? delaySplash()
          : googleAutoLogin(), // delay in case of family
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            !snapshot.hasData) {
          return _buildSplashScreen();
        } else if (snapshot.hasData) {
          if (snapshot.data == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              navigateToPlusSection();
            });
          } else {
            Navigator.pop(context);
          }
          return _buildSplashScreen();
        } else {
          return Container();
        }
      },
    );
  }

  // delay in case of family
  Future<bool> delaySplash() async {
    final duration = Duration(seconds: 3);
    await Future.delayed(duration);
    return true;
  }

  // managed auto login and session id
  Future<bool> googleAutoLogin() async {
    try {
      List<UserInformation> _profileData =
          await UserGoogleProfile.getUserProfile();
      var result = await Authentication.refreshAuthenticationToken(
          refreshToken: _profileData[0].refreshToken);
      await GoogleLogin.verifyUserAndGetDriveFolder(_profileData);

      //Creating fresh sessionID
      Globals.sessionId = await PlusUtility.updateUserLogsSessionId();
      return true;
    } catch (e) {
      return false;
    }
  }

// navigation  as per the section
  navigateToPlusSection() async {
    if (widget.actionName == 'GRADED+') {
      //Graded+ login activity
      PlusUtility.updateLogs(
          activityType: 'GRADED+',
          userType: 'Teacher',
          activityId: '2',
          description: 'Graded+ Accessed(Login)/Login Id:',
          operationResult: 'Success');

      // Check User is First Time or old user
      HiveDbServices _hiveDbServices = HiveDbServices();
      var isOldUser =
          await _hiveDbServices.getSingleData('is_new_user', 'new_user');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => isOldUser == true
              ? GradedPlusNavBarHome()
              : CommonIntroSection(
                  isSkipAndStartButton: true,
                  onBoardingInfoList:
                      GradedIntroContentModal.onBoardingMainPagesInfoList,
                  isMcqSheet: false),
        ),
      );
    } else if (widget.actionName == 'PBIS+') {
      PlusUtility.updateLogs(
          activityType: 'PBIS+',
          userType: 'Teacher',
          activityId: '2',
          description: 'PBIS+ Accessed(Login)/Login Id: ',
          operationResult: 'Success');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => PBISPlusHome(),
        ),
      );
    } else if (widget.actionName == 'STUDENT+') {
      PlusUtility.updateLogs(
          activityType: 'STUDENT+',
          userType: widget.sectionType == 'Family'
              ? 'Parent'
              : widget.sectionType == 'Student'
                  ? 'Student'
                  : 'Teacher',
          activityId: '2',
          description: 'STUDENT+ Accessed(Login)/Login Id: ',
          operationResult: 'Success');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => widget.sectionType == 'Family'
              ? (widget.studentDetail == null
                  ? StudentPlusFamilyLogIn()
                  : StudentPlusHome(
                      sectionType: "Family",
                      studentPlusStudentInfo: widget.studentDetail!,
                      index: 0,
                      //   index: widget.index,
                    ))
              : widget.sectionType == 'Student'
                  ? StudentPlusHome(
                      sectionType: "Student",
                      studentPlusStudentInfo: StudentPlusDetailsModel(),
                      index: 0,
                    )
                  : StudentPlusSearchScreen(
                      fromStudentPlusDetailPage: false,
                      index: 0,
                      studentDetails: studentDetails),
        ),
      );
    }
  }

  Widget _buildSplashScreen() {
    return Center(
        child: Stack(
      children: [
        CommonBackgroundImgWidget(),
        Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            padding: const EdgeInsets.all(16),
            child: Image.asset(
              getSplashScreenUrl(),
              //  fit: BoxFit.cover,
              //    height: 50,
            )),
      ],
    ));
  }

  String getSplashScreenUrl() {
    String localImageUrl = Globals.themeType == 'Dark'
        ? 'assets/images/graded+_light.png'
        : 'assets/images/graded+_dark.png';

    switch (widget.actionName) {
      case 'GRADED+':
        localImageUrl = Globals.themeType == 'Dark'
            ? 'assets/images/graded_plus_dark.png'
            : 'assets/images/graded_plus_light.png';
        break;
      case 'PBIS+':
        localImageUrl = Globals.themeType == 'Dark'
            ? 'assets/images/pbis_plus_dark.png'
            : 'assets/images/pbis_plus_light.png';
        break;
      case 'STUDENT+':
        localImageUrl = Globals.themeType == 'Dark'
            ? 'assets/images/student_plus_dark.png'
            : 'assets/images/student_plus_light.png';
        break;
      default:
    }

    return localImageUrl;
  }
}
