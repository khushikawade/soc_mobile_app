import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/bloc/google_classroom_bloc.dart';
import 'package:Soc/src/modules/google_classroom/modal/google_classroom_courses.dart';
import 'package:Soc/src/modules/google_classroom/modal/google_classroom_list.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/services/user_profile.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/assessment_history_screen.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/graded_plus/bloc/graded_plus_bloc.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';

import 'package:Soc/src/modules/plus_common_widgets/profile_page.dart';

import 'package:Soc/src/modules/graded_plus/new_ui/help.dart';
import 'package:Soc/src/modules/plus_common_widgets/google_login.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_version/new_version.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/bottom_navbar_home.dart';

class GradedLandingPage extends StatefulWidget {
  final bool? isFromLogoutPage;
  final bool? isMultipleChoice;
  const GradedLandingPage(
      {Key? key, this.isFromLogoutPage, this.isMultipleChoice})
      : super(key: key);

  @override
  State<GradedLandingPage> createState() => _GradedLandingPageState();
}

class _GradedLandingPageState extends State<GradedLandingPage> {
  final GoogleClassroomBloc _googleClassroomBloc = new GoogleClassroomBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<String?> rosterImport = ValueNotifier<String?>('');
  final ValueNotifier<bool?> refreshList = ValueNotifier<bool?>(false);
  final ValueNotifier<bool> updateAppBar = ValueNotifier<bool>(false);
  final ValueNotifier<List<GoogleClassroomCourses>> googleCourseList =
      ValueNotifier<List<GoogleClassroomCourses>>([]);
  GoogleDriveBloc _googleDriveBloc = new GoogleDriveBloc();
  bool? importRosterList =
      false; //to navigate on tap after fetching the list automatically
  // final OcrBloc _ocrBlocLogs = new OcrBloc();
  DateTime currentDateTime = DateTime.now(); //DateTime

  // String userName = ''; //T
  final ValueNotifier<String?> userName = ValueNotifier<String?>('');

  // @override
  void initState() {
    Utility.setLocked();
    _checkNewVersion();
    fetchLocalRoster();
    fetchProfileData();

    //Recreating sessionId by checking if required details
    if (Globals.sessionId != '' || Globals.teacherEmailId != '') {
      PlusUtility.updateUserLogsSessionId();
    }
    if (widget.isFromLogoutPage == true) {
      userName.value = '';
    }
    super.initState();
  }

  String? _versionNumber;

  void _checkNewVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String _packageName = packageInfo.packageName;
      _versionNumber = packageInfo.version;
      final newVersion = NewVersion(
        iOSId: _packageName,
        androidId: _packageName,
      );
      _checkVersionUpdateStatus(newVersion);
    } catch (e) {}
  }

  _checkVersionUpdateStatus(NewVersion newVersion) async {
    try {
      newVersion.showAlertIfNecessary(context: context);
    } catch (e) {}
  }

  fetchLocalRoster() async {
    //Used to update the valuelistener list
    List<GoogleClassroomCourses> gCoursesList =
        await GoogleClassroom.getGoogleClassroom();
    // LocalDatabase<GoogleClassroomCourses> _localDb =
    //     LocalDatabase(Strings.googleClassroomCoursesList);

    // List<GoogleClassroomCourses>? _localData = await _localDb.getData();
    googleCourseList.value.clear();
    googleCourseList.value.addAll(gCoursesList);
    refreshList.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: AppBarWidget(
            actionButton: Container(
              //   padding: EdgeInsets.only(right: 10),
              child: Row(
                children: [
                  IconButton(
                      iconSize: Globals.deviceType == "phone" ? 32 : 38,
                      onPressed: () async {
                        var result = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => CustomIntroWidget()),
                        );
                        //  Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.help,
                        // size: 30,
                        color: AppTheme.kButtonColor,
                      )),
                  ValueListenableBuilder(
                      valueListenable: updateAppBar,
                      child: Container(),
                      builder:
                          (BuildContext context, dynamic value, Widget? child) {
                        return //Container();
                            Container(
                          child: FutureBuilder(
                              future: getUserProfile(),
                              builder: (context,
                                  AsyncSnapshot<UserInformation> snapshot) {
                                if (snapshot.hasData) {
                                  return IconButton(
                                    icon: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                      child: CachedNetworkImage(
                                        height: Globals.deviceType == "phone"
                                            ? 28
                                            : 32,
                                        width: Globals.deviceType == "phone"
                                            ? 28
                                            : 32,
                                        imageUrl:
                                            snapshot.data!.profilePicture!,
                                        placeholder: (context, url) =>
                                            CupertinoActivityIndicator(
                                                animating: true, radius: 10),
                                      ),
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProfilePage(
                                                  plusAppName: 'Graded+',
                                                  fromGradedPlus: true,
                                                  profile: snapshot.data!,
                                                )),
                                      );
                                    },
                                  );
                                }
                                return Container();
                              }),
                        );
                      }),
                ],
              ),
            ),
            //  marginLeft: 30,
            refresh: (v) {
              setState(() {});
            },
          ),
          body: Container(
            height: MediaQuery.of(context).size.height * 0.63,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Expanded(
                  child: Image.asset("assets/images/landingPage_image.png")),
              ValueListenableBuilder(
                  builder:
                      (BuildContext context, dynamic value, Widget? child) {
                    return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: Text.rich(TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(fontWeight: FontWeight.bold),
                          text: 'Welcome ',
                          children: <InlineSpan>[
                            TextSpan(
                              text: userName.value,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.kButtonColor),
                            ),
                            TextSpan(
                              text: '!',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(fontWeight: FontWeight.bold),
                            )
                          ])),
                    );
                  },
                  valueListenable: userName,
                  child: Container()),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0.0, 25, 0),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    // height: 100,
                    // color: Colors.blue,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                        child: Utility.textWidget(
                            textAlign: TextAlign.center,
                            text:
                                'Scan your entire class and save results to your Google Drive within 3 minutes!',
                            context: context,
                            textTheme: Theme.of(context).textTheme.headline2!),

                        // Text('Flutter gives easy and simple methods',
                        //     style: Theme.of(context).textTheme.bodyMedium),
                      ),
                    )),
              ),
              BlocListener<GoogleClassroomBloc, GoogleClassroomState>(
                  bloc: _googleClassroomBloc,
                  child: Container(),
                  listener:
                      (BuildContext contxt, GoogleClassroomState state) async {
                    if (state is GoogleClassroomCourseListSuccess) {
                      // print('Courses list Fetched');

                      googleCourseList.value.clear();
                      Utility.currentScreenSnackBar(
                          'Roster Imported Successfully From Google Classroom',
                          null,
                          marginFromBottom: 90);
                      googleCourseList.value.addAll(state.obj!);
                      rosterImport.value = 'success';
                      if (importRosterList == true &&
                          rosterImport.value == 'success') {
                        importRosterList = false;
                      }
                    }
                    if (state is GoogleClassroomLoading) {
                      rosterImport.value = 'loading';
                    }
                    if (state is GoogleClassroomErrorState) {
                      rosterImport.value = '';
                      if (state.errorMsg == 'ReAuthentication is required') {
                        await Utility.refreshAuthenticationToken(
                            isNavigator: false,
                            errorMsg: state.errorMsg!,
                            context: context,
                            scaffoldKey: _scaffoldKey);

                        _googleClassroomBloc.add(GetClassroomCourses());
                      } else {
                        Navigator.of(context).pop();
                        Utility.currentScreenSnackBar(
                            "Something Went Wrong. Please Try Again.", null);
                      }
                    }
                  }),
            ]),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: fabButton(
            title: 'Go to Dashboard',
          ),
        )
      ],
    );
  }

  Future<UserInformation> getUserProfile() async {
    LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
    List<UserInformation> _userInformation = await _localDb.getData();

    if (_userInformation.isNotEmpty) {
      Globals.teacherEmailId = _userInformation[0].userEmail!;
    }

    return _userInformation[0];
  }

  fetchProfileData() async {
    List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();
    if (_profileData.isNotEmpty && widget.isFromLogoutPage != true) {
      userName.value = _profileData[0].userName!.replaceAll("%20", " ");
    }
  }

  Widget fabButton({required String title}) {
    return ValueListenableBuilder(
        valueListenable: updateAppBar,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return FutureBuilder(
              future: _checkUserAvailable(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return FloatingActionButton.extended(
                  heroTag: null,
                  backgroundColor: AppTheme.kButtonColor,
                  onPressed: () async {
                    DateTime currentDateTime = DateTime.now();
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return;
                    }

                    //Fresh Google Login
                    if (snapshot.data == false) {
                      var result = await GoogleLogin.launchURL(
                          'Google Authentication',
                          context,
                          _scaffoldKey,
                          title,
                          'GRADED+');

                      if (result == true) {
                        updateAppBar.value = !updateAppBar.value;

                        List<UserInformation> _profileData =
                            await UserGoogleProfile.getUserProfile();
                        Globals.teacherEmailId =
                            _profileData[0].userEmail!.split('@')[0];

                        PlusUtility.updateUserLogsSessionId();

                        PlusUtility.updateLogs(
                            activityType: 'GRADED+',
                            activityId: '2',
                            description:
                                'Graded+ Accessed(Login)/Google Authentication Success/Login Id: ',
                            operationResult: 'Success');

                        //  pushNewScreen(context, screen: GradedLandingPage());
                      }
                    }
                    //Already Logged in
                    else {
                      List<UserInformation> _userProfileLocalData =
                          await UserGoogleProfile.getUserProfile();
                      GoogleLogin.verifyUserAndGetDriveFolder(
                          _userProfileLocalData);
                      Globals.teacherEmailId =
                          _userProfileLocalData[0].userEmail!.split('@')[0];

                      PlusUtility.updateLogs(
                          activityType: 'GRADED+',
                          activityId: '2',
                          description:
                              'Graded+ Accessed(Login)/Already Logged In/Login Id: ',
                          operationResult: 'Success');

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => GradedPlusNavBarHome()));
                    }
                  },
                  label: _buildLabel(context, snapshot, title),
                );
              });
        });
  }

  Future<bool> _checkUserAvailable() async {
    List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();
    return _profileData?.isNotEmpty ?? false;
  }

  Widget _buildLabel(
      BuildContext context, AsyncSnapshot<bool> snapshot, String title) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: CircularProgressIndicator(
          color: Color(0xff000000) == Theme.of(context).backgroundColor
              ? Colors.black
              : Colors.white,
          strokeWidth: MediaQuery.of(context).size.shortestSide * 0.005,
        ),
      );
    }

    return Utility.textWidget(
      text: snapshot.data == true ? title! : 'Log In',
      context: context,
      textTheme: Theme.of(context)
          .textTheme
          .headline2!
          .copyWith(color: Theme.of(context).backgroundColor),
    );
  }
}
