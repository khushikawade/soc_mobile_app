// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/modal/google_classroom_list.dart';
import 'package:Soc/src/modules/graded_plus/bloc/graded_plus_bloc.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/plus_common_widgets/google_login.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_common_splash.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/modules/schedule/bloc/calender_bloc.dart';
import 'package:Soc/src/modules/schedule/modal/schedule_modal.dart';
import 'package:Soc/src/modules/schedule/ui/day_view.dart';
import 'package:Soc/src/modules/students/bloc/student_bloc.dart';
import 'package:Soc/src/modules/students/models/student_app.dart';
import 'package:Soc/src/modules/students/ui/apps_folder.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/google_authentication.dart';
import 'package:Soc/src/services/user_profile.dart';
import 'package:Soc/src/styles/marquee.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/banner_image_widget.dart';
import 'package:Soc/src/widgets/custom_icon_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/google_auth_webview.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:app_links/app_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../services/local_database/local_db.dart';
import '../../schedule/modal/blackOutDate_modal.dart';

class StudentPage extends StatefulWidget {
  final homeObj;
  final bool? isCustomSection;
  CalenderBloc scheduleBloc;
  OcrBloc studentOcrBloc;

  StudentPage(
      {Key? key,
      this.homeObj,
      required this.isCustomSection,
      required this.scheduleBloc,
      required this.studentOcrBloc})
      : super(key: key);
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  static const double _kLableSpacing = 12.0;
  int? gridLength;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final HomeBloc _homeBloc = new HomeBloc();
  bool? isErrorState = false;
  // OcrBloc _ocrBloc = new OcrBloc();
  StudentBloc _bloc = StudentBloc();
  ScrollController _scrollController = ScrollController();
  // CalenderBloc _scheduleBloc = CalenderBloc();

  bool isCalenderEventCalledAlready = false;
  @override
  void initState() {
    super.initState();
    //_scrollController = ScrollController()..addListener(_scrollListener);
    _bloc.add(StudentPageEvent());
    FirebaseAnalyticsService.addCustomAnalyticsEvent("students");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'student', screenClass: 'StudentPage');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // _scrollListener() {
  //   ////print(_controller.position.extentAfter);
  //   if (_scrollController.position.hasPixels) {
  //     refreshPage();
  //   }
  // }

  _launchURL(StudentApp obj, subList) async {
    // Schedule Start
    // if (obj.titleC != null && obj.titleC!.toLowerCase().contains('schedule')) {
    if (obj.typeC != null && obj.typeC == 'Schedule') {
      await schedulerLogin();

      return;
    }

    /* --------------------------- START // Condition to check Student Plus Section -------------------------- */
    if (obj.typeC != null &&
        (obj.typeC == 'Student+' || obj.typeC == 'STUDENT+')) {
      studentPlusLogin();
      return;
    }
    /* --------------------------- END -------------------------- */

    // Schedule Ends

    if (obj.appUrlC != null) {
      if (obj.appUrlC == 'app_folder' || obj.isFolder == 'true') {
        showDialog(
          useRootNavigator: false,
          // barrierColor: Color.fromARGB(96, 73, 73, 75),
          context: context,
          builder: (_) => AppsFolderPage(
            scaffoldKey: _scaffoldKey,
            obj: subList,
            folderName: obj.titleC!,
          ),
        );
      } else {
        if (obj.deepLinkC == 'YES' ||
            obj.appUrlC.toString().split(":")[0] == 'http') {
          await Utility.launchUrlOnExternalBrowser(obj.appUrlC!);
        } else {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => InAppUrlLauncer(
                        title: obj.titleC!,
                        url: obj.appUrlC!,
                        isBottomSheet: true,
                        language: Globals.selectedLanguage,
                      )));
        }
      }
      //lock screen orientation
    } else {
      Utility.showSnackBar(_scaffoldKey, "No URL available", context, null);
    }
    //  Utility.setLocked();
  }

  Widget _buildGrid(
      List<StudentApp> list, List<StudentApp> subList, String key) {
    return BlocListener(
      bloc: widget.scheduleBloc,
      listener: (context, state) {
        // print(state);
        if (state is CalenderLoading) {
          Utility.showLoadingDialog(context: context, isOCR: false);
        }
        if (state is CalenderSuccess) {
          Navigator.pop(context, false);
          navigateToSchedule(
            blackoutDateList: state.blackoutDateobjList,
            schedulesList: state.scheduleObjList,
            studentProfile: state.studentProfile,
          );
        }
        if (state is CalenderError) {
          Navigator.pop(context, false);
          Utility.showSnackBar(
              _scaffoldKey, state.err.toString(), context, null);
        }
      },
      child: list.length > 0
          ? GridView.count(
              shrinkWrap: true,
              controller: _scrollController,
              key: ValueKey(key),
              padding: const EdgeInsets.only(
                  bottom: AppTheme.klistPadding, top: AppTheme.kBodyPadding),
              childAspectRatio:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 1
                      : 3 / 2,
              crossAxisCount:
                  MediaQuery.of(context).orientation == Orientation.portrait &&
                          Globals.deviceType == "phone"
                      ? 3
                      : (MediaQuery.of(context).orientation ==
                                  Orientation.landscape &&
                              Globals.deviceType == "phone")
                          ? 4
                          : MediaQuery.of(context).orientation ==
                                      Orientation.portrait &&
                                  Globals.deviceType != "phone"
                              ? 4
                              : MediaQuery.of(context).orientation ==
                                          Orientation.landscape &&
                                      Globals.deviceType != "phone"
                                  ? 5
                                  : 3,
              crossAxisSpacing: _kLableSpacing * 1.2,
              mainAxisSpacing: _kLableSpacing * 1.2,
              children: List.generate(
                list.length,
                (index) {
                  return Container(
                    padding: EdgeInsets.only(
                      top: Globals.deviceType == "phone"
                          ? MediaQuery.of(context).size.height * 0.001
                          : MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: GestureDetector(
                        onTap: () => _launchURL(list[index], subList),
                        child: Column(
                          // mainAxisAlignment:MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            list[index].appIconC != null &&
                                    list[index].appIconC != ''
                                ? Container(
                                    height: 80,
                                    width: 80,
                                    child: CustomIconWidget(
                                        darkModeIconUrl:
                                            list[index].darkModeIconC,
                                        iconUrl: list[index].appIconC ??
                                            Overrides.folderDefaultImage))
                                : EmptyContainer(),
                            Container(
                                child: TranslationWidget(
                              message: "${list[index].titleC}",
                              fromLanguage: "en",
                              toLanguage: Globals.selectedLanguage,
                              builder: (translatedMessage) => Container(
                                child: MediaQuery.of(context).orientation ==
                                            Orientation.portrait &&
                                        translatedMessage.toString().length > 11
                                    ? Expanded(
                                        child: MarqueeWidget(
                                        pauseDuration: Duration(seconds: 1),
                                        child: Text(
                                          translatedMessage.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                  fontSize:
                                                      Globals.deviceType ==
                                                              "phone"
                                                          ? 16
                                                          : 24),
                                        ),
                                      ))
                                    : MediaQuery.of(context).orientation ==
                                                Orientation.landscape &&
                                            translatedMessage
                                                    .toString()
                                                    .length >
                                                18
                                        ? Expanded(
                                            child: MarqueeWidget(
                                            pauseDuration: Duration(seconds: 3),
                                            child: Text(
                                              translatedMessage.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                      fontSize:
                                                          Globals.deviceType ==
                                                                  "phone"
                                                              ? 16
                                                              : 24),
                                            ),
                                          ))
                                        : SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                                translatedMessage.toString(),
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                        fontSize:
                                                            Globals.deviceType ==
                                                                    "phone"
                                                                ? 16
                                                                : 24)),
                                          ),
                              ),
                            )),
                          ],
                        )),
                  );
                },
              ),
            )
          : NoDataFoundErrorWidget(
              isResultNotFoundMsg: false,
              isNews: false,
              isEvents: false,
              // connected: connected,
            ),
    );
  }
  //sfjhjjsfdjkfjdjsdjdjjhksfdssfjkdjdjkjsdsjkdkdjsdjkjkjsdjhkjsdjkjsdjkjfjhfdhjhfjnbfjnnnmnccnmbxzfjksldaqpwoieruyt;adjkjhkhdfghvbsd

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    _bloc.add(StudentPageEvent());
    _homeBloc.add(FetchStandardNavigationBar());
  }

  Widget _body(String key) {
    return RefreshIndicator(
      key: refreshKey,
      child: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;

            if (connected) {
              if (isErrorState == true) {
                isErrorState = false;
                _bloc.add(StudentPageEvent());
              }
            } else if (!connected) {
              isErrorState = true;
            }

            return ListView(

                //fit: StackFit.expand,
                children: [
                  // connected
                  //     ?
                  BlocBuilder<StudentBloc, StudentState>(
                      bloc: _bloc,
                      builder: (BuildContext contxt, StudentState state) {
                        if (state is StudentInitial || state is Loading) {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryVariant,
                              ));
                        } else if (state is StudentDataSuccess) {
                          return state.obj != null && state.obj!.length > 0
                              ? Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: _buildGrid(
                                      state.obj!, state.subFolder!, key))
                              :
                              // ListView(children: [
                              NoDataFoundErrorWidget(
                                  isResultNotFoundMsg: false,
                                  isNews: false,
                                  isEvents: false,
                                  connected: connected,
                                );
                          // ]);
                        } else if (state is StudentError) {
                          return ListView(children: [ErrorMsgWidget()]);
                        }
                        return Container();
                      }),
                  Container(
                    child: BlocListener<HomeBloc, HomeState>(
                        bloc: _homeBloc,
                        listener: (context, state) async {
                          if (state is BottomNavigationBarSuccess) {
                            AppTheme.setDynamicTheme(
                                Globals.appSetting, context);

                            Globals.appSetting = AppSetting.fromJson(state.obj);
                            setState(() {});
                          } else if (state is HomeErrorReceived) {
                            Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: Center(
                                  child: Text("Unable to load the data")),
                            );
                          }
                        },
                        child: EmptyContainer()),
                  ),

                  /* --------------------------- BlocListener to verify user to database -------------------------- */
                  Container(
                    height: 0,
                    width: 0,
                    child: BlocListener<OcrBloc, OcrState>(
                      child: Container(),
                      bloc: widget.studentOcrBloc,
                      listener: (context, state) {
                        if (state is AuthorizedUserSuccess) {
                          Navigator.pop(context, false);
                          navigateToStudentPlus();
                        }
                        if (state is AuthorizedUserLoading) {
                          Utility.showLoadingDialog(
                              context: context,
                              isOCR: true,
                              msg: "Please Wait");
                        }
                        if (state is AuthorizedUserError) {
                          Navigator.pop(context, false);
                          if (Globals.appSetting.enableGoogleSSO == "true") {
                            Authentication.signOut(context: context);
                            UserGoogleProfile.clearUserProfile();
                          }
                          Utility.currentScreenSnackBar(
                              'You Are Not Authorized To Access The Feature. Please Use The Authorized Account.',
                              null);
                        }
                      },
                    ),
                  )
                ]);
          },
          child: Container()),
      onRefresh: refreshPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarWidget(
            onTap: () {
              Utility.scrollToTop(scrollController: _scrollController);
            },
            marginLeft: 30,
            refresh: (v) {
              setState(() {});
            }),
        body: //widget.isCustomSection == false &&
            Globals.appSetting.studentBannerImageC != null &&
                    Globals.appSetting.studentBannerImageC != ""
                ? NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        Globals.appSetting.studentBannerImageC != null
                            ? BannerImageWidget(
                                imageUrl:
                                    Globals.appSetting.studentBannerImageC!,
                                bgColor: Globals
                                            .appSetting.studentBannerColorC !=
                                        null
                                    ? Utility.getColorFromHex(
                                        Globals.appSetting.studentBannerColorC!)
                                    : null,
                              )
                            : SliverAppBar(),
                      ];
                    },
                    body: widget.isCustomSection == false
                        ? _body('body1')
                        : _body('body2'))
                : widget.isCustomSection == false
                    ? _body('body1')
                    : _body('body2'));
  }

  Future<UserInformation> _launchLoginUrl(String? title) async {
    var themeColor = Theme.of(context).backgroundColor == Color(0xff000000)
        ? Color(0xff000000)
        : Color(0xffFFFFFF);

    var value = await pushNewScreen(
      context,
      screen: GoogleAuthWebview(
        title: title!,
        url:
            'https://anl2h22jc4.execute-api.us-east-2.amazonaws.com/production/student-login/auth',
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
      Utility.showSnackBar(
          _scaffoldKey,
          'You are not authorized to access the feature. Please use the authorized account.',
          context,
          50.0);

      return UserInformation(userName: null);
    } else if (value.toString().contains('success')) {
      value = value.split('?')[1] ?? '';
      UserInformation _studentProfile = await saveUserProfile(value);
      return _studentProfile;
      // _calenderBloc.add(CalenderPageEvent(email: _studentProfile.userEmail!));
      // loggedIn = true;
    }
    return UserInformation(userName: null);
  }

  Future<UserInformation> saveUserProfile(String profileData) async {
    List<String> profile = profileData.split('+');
    UserInformation _userInformation = UserInformation(
        userName: profile[0].toString().split('=')[1],
        userEmail: profile[1].toString().split('=')[1],
        profilePicture: profile[2].toString().split('=')[1],
        authorizationToken:
            profile[3].toString().split('=')[1].replaceAll('#', ''),
        refreshToken: profile[4].toString().split('=')[1].replaceAll('#', ''));

    //Save user profile to locally
    LocalDatabase<UserInformation> _localDb = LocalDatabase('student_profile');
    // print(_userInformation);
    await _localDb.addData(_userInformation);
    await _localDb.close();
    return _userInformation;
  }

  void navigateToSchedule(
      {required UserInformation studentProfile,
      required List<Schedule> schedulesList,
      required List<BlackoutDate> blackoutDateList}) async {
    pushNewScreen(
      context,
      screen: DayViewPage(
        date: ValueNotifier(DateTime.now()),
        studentProfile: studentProfile,
        blackoutDateList: blackoutDateList ?? [],
        schedulesList: schedulesList ?? [],
      ),
      withNavBar: false,
    );
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => DayViewPage(
    //             date: ValueNotifier(DateTime.now()),
    //             studentProfile: studentProfile,
    //             blackoutDateList: blackoutDateList ?? [],
    //             schedulesList: schedulesList ?? [],
    //           )),
    // );

    isCalenderEventCalledAlready = false;
  }

  void _scheduleEvent(UserInformation studentProfile) {
    if (isCalenderEventCalledAlready) {
      Utility.currentScreenSnackBar('Please Wait..... ', null);
    } else {
      isCalenderEventCalledAlready = true;
      widget.scheduleBloc.add(CalenderPageEvent(
          studentProfile: studentProfile,
          pullToRefresh: false,
          isFromStudent: true));
    }
  }

  navigateToStudentPlus() async {
    // PlusUtility.updateLogs(
    //     activityType: 'GRADED+',
    //     userType: 'Student',
    //     activityId: '2',
    //     description: 'Student+ Accessed(Login)/Login Id:',
    //     operationResult: 'Success');

    pushNewScreen(
      context,
      screen: PlusSplashScreen(actionName: 'STUDENT+', sectionType: 'Student'),
      withNavBar: false,
    );
  }

  /* ---------------------------- Function call in case of student Plus --------------------------- */
  Future studentPlusLogin() async {
    Globals.lastIndex = Globals.controller!.index;

    /* ---- Clear login local data base once because we added classroom scope --- */
    SharedPreferences clearGoogleLoginLocalDb =
        await SharedPreferences.getInstance();
    final clearCacheResult = await clearGoogleLoginLocalDb
        .getBool('delete_local_login_details28JUNE');
    if (clearCacheResult != true) {
      await UserGoogleProfile.clearUserProfile();
      await clearGoogleLoginLocalDb.setBool(
          'delete_local_login_details28JUNE', true);
    }
    /* ---- Clear login local data base once because we added classroom scope --- */

    List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();

    if (_profileData.isEmpty ||
        _profileData[0].userType.toString().toLowerCase() == 'teacher') {
      // Condition to check SSO login enable or not
      if (Globals.appSetting.enablenycDocLogin == "true") {
        Globals.isStaffSection = false;
        Globals.isStudentScheduleApp = false;
        if (Platform.isIOS) {
          await launchUrl(
              Uri.parse(Globals.appSetting.nycDocLoginUrl != null
                  ? "${Globals.appSetting.nycDocLoginUrl}?schoolId=${Globals.appSetting.id}"
                  : "https://c2timoenib.execute-api.us-east-2.amazonaws.com/production/secure-login/auth?schoolId=${Globals.appSetting.id}"),
              mode: LaunchMode.externalApplication); //
        } else {
          var value = await GoogleLogin.launchURL(
              'Google Authentication', context, _scaffoldKey, '', "STUDENT+",
              userType: "Teacher");
          if (value == true) {
            navigateToStudentPlus();
          }
        }

        return;
      }

      if (Globals.appSetting.enableGoogleSSO != "true") {
        var value = await GoogleLogin.launchURL(
            'Google Authentication', context, _scaffoldKey, '', "STUDENT+",
            userType: 'Student');
        if (value == true) {
          navigateToStudentPlus();
        }
      } else {
        User? user = await Authentication.signInWithGoogle(
          userType: "Student",
        );
        if (user != null) {
          if (user.email != null && user.email != '') {
            widget.studentOcrBloc.add(
                AuthorizedUserWithDatabase(email: user.email, role: 'Student'));
            //navigatorToScreen(actionName: actionName);
          } else {
            Utility.currentScreenSnackBar(
                'You Are Not Authorized To Access The Feature. Please Use The Authorized Account.',
                null);
          }
        }
      }
    } else {
      // GoogleLogin.verifyUserAndGetDriveFolder(_profileData);
      //Creating fresh sessionID
      // Check user is login in other section or not
      if (_profileData[0].userType != "Student") {
        await FirebaseAnalyticsService.addCustomAnalyticsEvent("logout");
        await UserGoogleProfile.clearUserProfile();
        await GoogleClassroom.clearClassroomCourses();
        await Authentication.signOut(context: context);
        Utility.clearStudentInfo(tableName: 'student_info');
        Utility.clearStudentInfo(tableName: 'history_student_info');
        // Globals.googleDriveFolderId = null;
        PlusUtility.updateLogs(
            activityType: 'GRADED+',
            userType: 'Teacher',
            activityId: '3',
            description: 'User profile logout',
            operationResult: 'Success');

        studentPlusLogin();
        // popupModal(
        //     message:
        //         "You are already logged in as '${_profileData[0].userType}'. To access the STUDENT+ here, you will be logged out from the existing staff section. Do you still wants to continue?");
        return;
      }

      await Authentication.refreshAuthenticationToken(
          refreshToken: _profileData[0].refreshToken ?? '');
      Globals.sessionId = await PlusUtility.updateUserLogsSessionId();
      navigateToStudentPlus();
    }
  }

  /* ------------------------------ Function call at scheduler login ------------------------------ */
  Future schedulerLogin() async {
    /* ---- Clear login local data base once because we added classroom scope --- */
    SharedPreferences clearGoogleLoginLocalDb =
        await SharedPreferences.getInstance();
    final clearCacheResult = await clearGoogleLoginLocalDb
        .getBool('delete_local_login_details28JUNE');
    if (clearCacheResult != true) {
      await UserGoogleProfile.clearUserProfile();
      await clearGoogleLoginLocalDb.setBool(
          'delete_local_login_details28JUNE', true);
    }
    /* ---- Clear login local data base once because we added classroom scope --- */
    List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();

    //Allow login if profile is already empty or if teacher is currently logged in //clears the already saved profile and override the latest login details
    if (_profileData.isEmpty ||
        _profileData[0].userType.toString().toLowerCase() == 'teacher') {
      if (Globals.appSetting.enablenycDocLogin == "true") {
        Globals.isStaffSection = false;
        Globals.isStudentScheduleApp = true;

        if (Platform.isIOS) {
          //Launch Safari Browser on iOS
          await launchUrl(
              Uri.parse(Globals.appSetting.nycDocLoginUrl != null
                  ? "${Globals.appSetting.nycDocLoginUrl}?schoolId=${Globals.appSetting.id}"
                  : "https://c2timoenib.execute-api.us-east-2.amazonaws.com/production/secure-login/auth?schoolId=${Globals.appSetting.id}"),
              mode: LaunchMode.externalApplication); //
        } else {
          //Launch in App Browser on Android
          var value = await GoogleLogin.launchURL(
              'Google Authentication', context, _scaffoldKey, '', "STUDENT+",
              userType: "Teacher");
          if (value == true) {
            List<UserInformation> _userProfileData =
                await UserGoogleProfile.getUserProfile();
            _scheduleEvent(_userProfileData[0]);
          }
        }

        return;
      }
      // Condition to check SSO login enable or not
      if (Globals.appSetting.enableGoogleSSO != "true") {
        var value = await GoogleLogin.launchURL(
            'Google Authentication', context, _scaffoldKey, '', "STUDENT+",
            userType: 'Student');
        if (value == true) {
          List<UserInformation> _userProfileData =
              await UserGoogleProfile.getUserProfile();
          _scheduleEvent(_userProfileData[0]);
        }
      } else {
        User? user = await Authentication.signInWithGoogle(
          userType: "Student",
        );
        if (user != null) {
          if (user.email != null && user.email != '') {
            List<UserInformation> _userProfileData =
                await UserGoogleProfile.getUserProfile();
            _scheduleEvent(_userProfileData[0]);
          } else {
            Utility.currentScreenSnackBar(
                'You Are Not Authorized To Access The Feature. Please Use The Authorized Account.',
                null);
          }
        }
      }
    } else {
      _scheduleEvent(_profileData[0]);
    }
  }
}
