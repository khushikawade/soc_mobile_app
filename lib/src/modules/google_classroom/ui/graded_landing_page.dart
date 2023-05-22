import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/bloc/google_classroom_bloc.dart';
import 'package:Soc/src/modules/google_classroom/modal/google_classroom_courses.dart';
import 'package:Soc/src/modules/google_classroom/modal/google_classroom_list.dart';
import 'package:Soc/src/modules/google_classroom/ui/courses_list.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/google_drive/model/user_profile.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/graded_plus/bloc/graded_plus_bloc.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/graded_plus/ui/list_assessment_summary.dart';
import 'package:Soc/src/modules/plus_common_widgets/profile_page.dart';
import 'package:Soc/src/modules/graded_plus/ui/select_assessment_type.dart';
import 'package:Soc/src/modules/graded_plus/widgets/Common_popup.dart';
import 'package:Soc/src/modules/graded_plus/widgets/custom_intro_layout.dart';
import 'package:Soc/src/modules/plus_common_widgets/google_login.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:new_version/new_version.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:Soc/src/modules/graded_plus/ui/graded_plus_navbar_home.dart';

class GradedLandingPage extends StatefulWidget {
  final bool? isFromLogoutPage;
  final bool? isMultiplechoice;
  const GradedLandingPage(
      {Key? key, this.isFromLogoutPage, this.isMultiplechoice})
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
  final OcrBloc _ocrBlocLogs = new OcrBloc();
  DateTime currentDateTime = DateTime.now(); //DateTime
  int myTimeStamp = DateTime.now().microsecondsSinceEpoch;
  // String userName = ''; //T
  final ValueNotifier<String?> userName = ValueNotifier<String?>('');

  // @override
  void initState() {
    Utility.setLocked();
    _checkNewVersion();
    fetchLocalRoster();
    fatchProfileData();

    if (Overrides.STANDALONE_GRADED_APP) {
      Globals.isPremiumUser = true;
    }
    if (Globals.sessionId != '') {
      Globals.sessionId = "${Globals.teacherEmailId}_${myTimeStamp.toString()}";
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
                        //  sort();
                        // var res = await Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //         builder: (context) => CoursesListScreen(
                        //             googleClassroomCourseList:
                        //                 googleCourseList.value)));
                        // if (res == true) {
                        //   refreshList.value = !refreshList.value!;
                        // }
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
            title: 'Go to Dashbord',
          ),

          // floatingActionButton: Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     ValueListenableBuilder(
          //         builder:
          //             (BuildContext context, dynamic value, Widget? child) {
          //           return Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: button(googleCourseList.value.length > 0 &&
          //                       widget.isFromLogoutPage != true
          //                   ? 'View Imported Roster'
          //                   : 'Import Roster'));
          //         },
          //         valueListenable: refreshList,
          //         child: Container()),
          //     SpacerWidget(8),
          //     button(
          //       'Scan Assignment',
          //     ),
          //     OfflineBuilder(
          //         child: Container(),
          //         connectivityBuilder: (BuildContext context,
          //             ConnectivityResult connectivity, Widget child) {
          //           final bool connected =
          //               connectivity != ConnectivityResult.none;
          //           return ValueListenableBuilder(
          //               builder: (BuildContext context, dynamic value,
          //                   Widget? child) {
          //                 return userName.value == null ||
          //                         userName.value == ''
          //                     ? Container()
          //                     : Column(
          //                         children: [
          //                           GestureDetector(
          //                             onTap: () async {
          //                               if (!connected) {
          //                                 Utility.currentScreenSnackBar(
          //                                     "No Internet Connection", null);
          //                                 return;
          //                               }
          //                               if (Globals
          //                                   .googleDriveFolderId!.isEmpty) {
          //                                 _triggerDriveFolderEvent(true);
          //                               } else {
          //                                 _beforenavigateOnAssessmentSection();
          //                               }
          //                             },
          //                             child: Container(
          //                                 padding: EdgeInsets.only(top: 10),
          //                                 // color: Colors.red,
          //                                 child: Utility.textWidget(
          //                                     text: 'Assignment History',
          //                                     context: context,
          //                                     textTheme: Theme.of(context)
          //                                         .textTheme
          //                                         .headline2!
          //                                         .copyWith(
          //                                           decoration: TextDecoration
          //                                               .underline,
          //                                         ))),
          //                           ),
          //                           BlocListener<GoogleDriveBloc,
          //                                   GoogleDriveState>(
          //                               bloc: _googleDriveBloc,
          //                               child: Container(),
          //                               listener: (context, state) async {
          //                                 if (state is GoogleDriveLoading) {
          //                                   Utility.showLoadingDialog(
          //                                       context: context,
          //                                       isOCR: true);
          //                                 }
          //                                 if (state is GoogleSuccess) {
          //                                   Navigator.of(context).pop();
          //                                   _beforenavigateOnAssessmentSection();
          //                                 }
          //                                 if (state is ErrorState) {
          //                                   if (Globals.sessionId == '') {
          //                                     Globals.sessionId =
          //                                         "${Globals.teacherEmailId}_${myTimeStamp.toString()}";
          //                                   }
          //                                   _ocrBlocLogs.add(LogUserActivityEvent(
          //                                       activityType: 'GRADED+',
          //                                       sessionId: Globals.sessionId,
          //                                       teacherId: Globals.teacherId,
          //                                       activityId: '1',
          //                                       accountId: Globals
          //                                           .appSetting.schoolNameC,
          //                                       accountType:
          //                                           Globals.isPremiumUser ==
          //                                                   true
          //                                               ? "Premium"
          //                                               : "Free",
          //                                       dateTime: currentDateTime
          //                                           .toString(),
          //                                       description:
          //                                           'Start Scanning Failed',
          //                                       operationResult: 'Failed'));
          //                                   if (state.errorMsg ==
          //                                       'ReAuthentication is required') {
          //                                     await Utility
          //                                         .refreshAuthenticationToken(
          //                                             isNavigator: true,
          //                                             errorMsg:
          //                                                 state.errorMsg!,
          //                                             context: context,
          //                                             scaffoldKey:
          //                                                 _scaffoldKey);

          //                                     _triggerDriveFolderEvent(
          //                                         state.isAssessmentSection);
          //                                   } else {
          //                                     Navigator.of(context).pop();
          //                                     Utility.currentScreenSnackBar(
          //                                         "Something Went Wrong. Please Try Again.",
          //                                         null);
          //                                   }
          //                                 }
          //                               }),
          //                         ],
          //                       );
          //               },
          //               valueListenable: userName,
          //               child: Container());
          //         }),
          //   ],
          // )
        )
      ],
    );
  }

  void _beforenavigateOnAssessmentSection() {
    //updateLocalDb();
    if (Globals.sessionId == '') {
      Globals.sessionId = "${Globals.teacherEmailId}_${myTimeStamp.toString()}";
    }
    _ocrBlocLogs.add(LogUserActivityEvent(
        activityType: 'GRADED+',
        sessionId: Globals.sessionId,
        teacherId: Globals.teacherId,
        activityId: '4',
        accountId: Globals.appSetting.schoolNameC,
        accountType: Globals.isPremiumUser == true ? "Premium" : "Free",
        dateTime: currentDateTime.toString(),
        description: 'Assessment History page for home page',
        operationResult: 'Success'));
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AssessmentSummary(
                selectedFilterValue: "All",
                isFromHomeSection: true,
              )),
    );
  }

  void _triggerDriveFolderEvent(bool isTriggerdbyAssessmentSection) async {
    List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();

    _googleDriveBloc.add(GetDriveFolderIdEvent(
        fromGradedPlusAssessmentSection:
            isTriggerdbyAssessmentSection ? true : null,
        isReturnState: true,
        //  filePath: file,
        token: _profileData[0].authorizationToken,
        folderName: "SOLVED GRADED+",
        refreshToken: _profileData[0].refreshToken));
  }

  // Widget button(String? text) {
  //   return ValueListenableBuilder(
  //       builder: (BuildContext context, dynamic value, Widget? child) {
  //         return ValueListenableBuilder(
  //             builder: (BuildContext context, dynamic value, Widget? child) {
  //               return
  //               Container(
  //                   //  width: MediaQuery.of(context).size.width * 0.60,
  //                   child:
  //                    FloatingActionButton.extended(
  //                       heroTag: null,
  //                       // isExtended: isScrolling.value,
  //                       backgroundColor: AppTheme.kButtonColor,
  //                       onPressed: () async {
  //                         //
  //                         if (text == 'Scan Assignment' &&
  //                             googleCourseList.value.length == 0) {
  //                           popupModal(
  //                               title: 'Roster',
  //                               message: 'Please import the Roster first');
  //                         } else {
  //                           // await UserGoogleProfile.clearUserProfile();
  //                           List<UserInformation> _profileData =
  //                               await UserGoogleProfile.getUserProfile();
  //                           Utility.updateLogs(
  //                               activityType: 'GRADED+',
  //                               activityId: '1',
  //                               // sessionId: widget.assessmentDetailPage == true
  //                               //     ? widget.obj!.sessionId
  //                               //     : '',
  //                               description: 'user move to scan assessment',
  //                               operationResult: 'Success');
  //                           await Utility.clearStudentInfo(
  //                               tableName: 'student_info');
  //                           await Utility.clearStudentInfo(
  //                               tableName: 'history_student_info');
  //                           if (_profileData.isEmpty) {
  //                             var result = await GoogleLogin.launchURL(
  //                                 'Google Authentication',
  //                                 context,
  //                                 _scaffoldKey,
  //                                 text,
  //                                 'GRADED+');
  //                             if (result == true) {
  //                               updateAppBar.value = !updateAppBar.value;
  //                               List<UserInformation> _profileData =
  //                                   await UserGoogleProfile.getUserProfile();
  //                               Globals.teacherEmailId =
  //                                   _profileData[0].userEmail!.split('@')[0];
  //                               // Analytics start
  //                               //  Analytics.setUserId(Globals.teacherEmailId);

  //                               // Analytics end

  //                               Globals.sessionId =
  //                                   "${Globals.teacherEmailId}_${myTimeStamp.toString()}";
  //                               DateTime currentDateTime = DateTime.now();
  //                               _ocrBlocLogs.add(LogUserActivityEvent(
  //                                   activityType: 'GRADED+',
  //                                   sessionId: Globals.sessionId,
  //                                   teacherId: Globals.teacherId,
  //                                   activityId: '2',
  //                                   accountId: Globals.appSetting.schoolNameC,
  //                                   accountType: "Premium",
  //                                   dateTime: currentDateTime.toString(),
  //                                   description: 'Graded+ Accessed(Login)',
  //                                   operationResult: 'Success'));

  //                               pushNewScreen(context,
  //                                   screen: GradedLandingPage());
  //                             }
  //                           } else {
  //                             if (text == 'Import Roster') {
  //                               importRosterList = true;
  //                               if (rosterImport.value == 'loading') {
  //                                 Utility.currentScreenSnackBar(
  //                                   'Please Wait, Importing Is In Progress...',
  //                                   null,
  //                                 );
  //                               } else {
  //                                 _googleClassroomBloc
  //                                     .add(GetClassroomCourses());
  //                               }
  //                             } else if (text == 'View Imported Roster') {
  //                               Utility.updateLogs(
  //                                   activityType: 'GRADED+',
  //                                   activityId: '25',
  //                                   description:
  //                                       'User goes to View Imported Roster ',
  //                                   operationResult: 'Success');
  //                               // sort();
  //                               // Navigator.of(context).push(MaterialPageRoute(
  //                               //     builder: (context) => CoursesListScreen(
  //                               //         googleClassroomCourseList:
  //                               //             googleCourseList.value)));
  //                             } else {
  //                               List<UserInformation> _userProfileLocalData =
  //                                   await UserGoogleProfile.getUserProfile();
  //                               GoogleLogin.verifyUserAndGetDriveFolder(
  //                                   _userProfileLocalData);
  //                               Globals.teacherEmailId =
  //                                   _profileData[0].userEmail!.split('@')[0];

  //                               DateTime currentDateTime = DateTime.now();
  //                               _ocrBlocLogs.add(LogUserActivityEvent(
  //                                   activityType: 'GRADED+',
  //                                   sessionId: Globals.sessionId,
  //                                   teacherId: Globals.teacherId,
  //                                   activityId: '2',
  //                                   accountId: Globals.appSetting.schoolNameC,
  //                                   accountType: Globals.isPremiumUser == true
  //                                       ? "Premium"
  //                                       : "Free",
  //                                   dateTime: currentDateTime.toString(),
  //                                   description: 'Graded+ Accessed(Login)',
  //                                   operationResult: 'Success'));

  //                               Navigator.of(context).push(MaterialPageRoute(
  //                                       builder: (context) =>
  //                                           //SelectAssessmentType()
  //                                           GradedPlusNavBarHome())
  //                                   // widget.isMultiplechoice == true
  //                                   //     ? MultipleChoiceSection()
  //                                   //     :         OpticalCharacterRecognition()),
  //                                   );
  //                             }
  //                           }
  //                         }
  //                       },
  //                       label: Row(
  //                         children: [
  //                           text == 'Import Roster'
  //                               ? Padding(
  //                                   padding: const EdgeInsets.only(right: 10),
  //                                   child: Icon(
  //                                     IconData(
  //                                       0xe87b,
  //                                       fontFamily: Overrides.kFontFam,
  //                                       fontPackage: Overrides.kFontPkg,
  //                                     ),
  //                                     size: 20,
  //                                     color: Theme.of(context).backgroundColor,
  //                                   ))
  //                               : Container(),
  //                           Utility.textWidget(
  //                               text: text!,
  //                               context: context,
  //                               textTheme: Theme.of(context)
  //                                   .textTheme
  //                                   .headline2!
  //                                   .copyWith(
  //                                       color:
  //                                           Theme.of(context).backgroundColor)),
  //                           text == 'Import Roster' &&
  //                                   rosterImport.value == 'loading'
  //                               ? Container(
  //                                   margin: EdgeInsets.only(left: 10),
  //                                   height: MediaQuery.of(context)
  //                                           .size
  //                                           .shortestSide *
  //                                       0.04,
  //                                   width: MediaQuery.of(context)
  //                                           .size
  //                                           .shortestSide *
  //                                       0.04,
  //                                   alignment: Alignment.center,
  //                                   child: CircularProgressIndicator(
  //                                       color: Color(0xff000000) ==
  //                                               Theme.of(context)
  //                                                   .backgroundColor
  //                                           ? Colors.black
  //                                           : Colors.white,
  //                                       strokeWidth: MediaQuery.of(context)
  //                                               .size
  //                                               .shortestSide *
  //                                           0.005))
  //                               : Container()
  //                         ],
  //                       )
  //                       )
  //                       );
  //             },
  //             valueListenable: rosterImport,
  //             child: Container());
  //       },
  //       valueListenable: googleCourseList,
  //       child: Container());
  // }

  popupModal({required String message, required String? title}) {
    return showDialog(
        context: context,
        builder: (context) =>
            OrientationBuilder(builder: (context, orientation) {
              return CommonPopupWidget(
                  orientation: orientation,
                  context: context,
                  message: message,
                  title: title!);
            }));
  }

  Future<UserInformation> getUserProfile() async {
    LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
    List<UserInformation> _userInformation = await _localDb.getData();
    // if (_userInformation.isEmpty) {
    //   return _userInformation;
    // }
    if (_userInformation.isNotEmpty) {
      Globals.teacherEmailId = _userInformation[0].userEmail!;
    }

    //print("//printing _userInformation length : ${_userInformation[0]}");
    return _userInformation[0];
  }

  fatchProfileData() async {
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return;
                    }
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

                        Globals.sessionId =
                            "${Globals.teacherEmailId}_${myTimeStamp.toString()}";

                        DateTime currentDateTime = DateTime.now();
                        _ocrBlocLogs.add(LogUserActivityEvent(
                            activityType: 'GRADED+',
                            sessionId: Globals.sessionId,
                            teacherId: Globals.teacherId,
                            activityId: '2',
                            accountId: Globals.appSetting.schoolNameC,
                            accountType: "Premium",
                            dateTime: currentDateTime.toString(),
                            description: 'Graded+ Accessed(Login)',
                            operationResult: 'Success'));

                        //  pushNewScreen(context, screen: GradedLandingPage());
                      }
                    } else {
                      List<UserInformation> _userProfileLocalData =
                          await UserGoogleProfile.getUserProfile();
                      GoogleLogin.verifyUserAndGetDriveFolder(
                          _userProfileLocalData);
                      Globals.teacherEmailId =
                          _userProfileLocalData[0].userEmail!.split('@')[0];

                      DateTime currentDateTime = DateTime.now();
                      _ocrBlocLogs.add(LogUserActivityEvent(
                          activityType: 'GRADED+',
                          sessionId: Globals.sessionId,
                          teacherId: Globals.teacherId,
                          activityId: '2',
                          accountId: Globals.appSetting.schoolNameC,
                          accountType: Globals.isPremiumUser == true
                              ? "Premium"
                              : "Free",
                          dateTime: currentDateTime.toString(),
                          description: 'Graded+ Accessed(Login)',
                          operationResult: 'Success'));

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
