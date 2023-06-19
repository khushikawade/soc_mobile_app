import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/ui/graded_standalone_landing_page.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/graded_plus/bloc/graded_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_home.dart';
import 'package:Soc/src/modules/plus_common_widgets/google_login.dart';
import 'package:Soc/src/modules/staff/bloc/staff_bloc.dart';
import 'package:Soc/src/modules/staff/models/staff_icons_List.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/ui/student_plus_search_page.dart';
import 'package:Soc/src/modules/students/bloc/student_bloc.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/google_authentication.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/startup.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/banner_image_widget.dart';
import 'package:Soc/src/modules/shared/ui/common_list_widget.dart';
import 'package:Soc/src/widgets/bouncing_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../custom/model/custom_setting.dart';
import '../../google_drive/bloc/google_drive_bloc.dart';
import '../../../services/user_profile.dart';
import '../../graded_plus/modal/user_info.dart';
import '../../shared/ui/common_grid_widget.dart';

class StaffPage extends StatefulWidget {
  StaffPage(
      {Key? key,
      this.title,
      this.language,
      this.customObj,
      required this.isCustomSection,
      required this.isFromOcr})
      : super(key: key);
  final bool? isCustomSection;
  final CustomSetting? customObj;
  final String? title;
  final String? language;
  final bool isFromOcr;

  @override
  _StaffPageState createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  double _width = 100;
  double _height = 100;
  FocusNode myFocusNode = new FocusNode();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  StaffBloc _bloc = StaffBloc();
  final HomeBloc _homeBloc = new HomeBloc();
  bool? isErrorState = false;
  OcrBloc ocrBloc = new OcrBloc();
  bool? authSuccess = false;
  dynamic userData;
  GoogleDriveBloc _googleDriveBloc = new GoogleDriveBloc();
  OcrBloc _ocrBloc = new OcrBloc();
  // ScrollController _scrollController = new ScrollController();
  final ValueNotifier<bool> isScrolling = ValueNotifier<bool>(true);
  // instance for maintaining logs
  final OcrBloc _ocrBlocLogs = new OcrBloc();
  DateTime currentDateTime = DateTime.now(); //DateTime
  int myTimeStamp = DateTime.now().microsecondsSinceEpoch; //To TimeStamp
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(99);
  final StudentPlusDetailsModel studentDetails = new StudentPlusDetailsModel();
  String? actionName;

  @override
  void initState() {
    super.initState();
    _height = 150;
    _bloc.add(StaffPageEvent());
    if (widget.isFromOcr) {
      _homeBloc.add(FetchStandardNavigationBar());
    }
    FirebaseAnalyticsService.addCustomAnalyticsEvent("staff");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'staff', screenClass: 'StaffPage');
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool onNotification(ScrollNotification t) {
    if (t.metrics.pixels < 150) {
      if (isScrolling.value == false) isScrolling.value = true;
    } else {
      if (isScrolling.value == true) isScrolling.value = false;
    }
    return true;
  }

  Future<void> saveUserProfile(String profileData) async {
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

  Widget _body(String key) => Stack(children: [
        OfflineBuilder(
            connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
            ) {
              final bool connected = connectivity != ConnectivityResult.none;
              if (connected) {
                if (isErrorState == true) {
                  isErrorState = false;
                  _bloc.add(StaffPageEvent());
                }
              } else if (!connected) {
                isErrorState = true;
              }

              return
                  // connected?
                  RefreshIndicator(
                      key: refreshKey,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: ListView(
                          children: [
                            //ActionButtonWidget(),
                            BlocBuilder<StaffBloc, StaffState>(
                                bloc: _bloc,
                                builder:
                                    (BuildContext contxt, StaffState state) {
                                  if (state is StaffInitial ||
                                      state is StaffLoading) {
                                    return Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.6,
                                        alignment: Alignment.center,
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryVariant,
                                        ));
                                  } else if (state is StaffDataSuccess) {
                                    return widget.customObj != null &&
                                            widget.customObj!.sectionTemplate ==
                                                "Grid Menu"
                                        ? CommonGridWidget(
                                            scrollController: _scrollController,
                                            scaffoldKey: _scaffoldKey,
                                            bottomPadding: 60,
                                            connected: connected,
                                            data: state.obj!,
                                            sectionName: "staff")
                                        : CommonListWidget(
                                            scrollController: _scrollController,
                                            bottomPadding: 80,
                                            key: ValueKey(key),
                                            scaffoldKey: _scaffoldKey,
                                            connected: connected,
                                            data: state.obj!,
                                            sectionName: "staff");
                                  } else if (state is ErrorInStaffLoading) {
                                    return ListView(
                                        children: [ErrorMsgWidget()]);
                                  } else {
                                    return ErrorMsgWidget();
                                  }
                                }),
                          ],
                        ),
                      ),
                      onRefresh: refreshPage);
            },
            child: Container()),
        Container(
          height: 0,
          width: 0,
          child: BlocListener<HomeBloc, HomeState>(
              bloc: _homeBloc,
              listener: (context, state) async {
                if (state is BottomNavigationBarSuccess) {
                  AppTheme.setDynamicTheme(Globals.appSetting, context);
                  Globals.appSetting = AppSetting.fromJson(state.obj);
                  setState(() {});
                }
              },
              child: EmptyContainer()),
        ),
        Container(
          height: 0,
          width: 0,
          child: BlocListener<OcrBloc, OcrState>(
            child: Container(),
            bloc: _ocrBloc,
            listener: (context, state) {
              if (state is AuthorizedUserSuccess) {
                Navigator.pop(context, false);
                navigatorToScreen(actionName: actionName ?? '');
              }
              if (state is AuthorizedUserLoading) {
                Utility.showLoadingDialog(
                    context: context, isOCR: true, msg: "Please Wait");
              }
              if (state is AuthorizedUserError) {
                Navigator.pop(context, false);
                Utility.currentScreenSnackBar(
                    'You Are Not Authorized To Access The Feature. Please Use The Authorized Account.',
                    null);
              }
            },
          ),
        )
        // Globals.appSetting.enableGraded == 'false'
        //     ? Container()
        //     : ocrSectionButton(),
      ]);

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
          },
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: onNotification,
          child: Globals.appSetting.staffBannerImageC != null &&
                  Globals.appSetting.staffBannerImageC != ''
              ? NestedScrollView(
                  controller: _scrollController,
                  // key: _scaffoldKey,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      BannerImageWidget(
                          isStaffPage: true,
                          staffActionHeight:
                              MediaQuery.of(context).size.height * 0.18,
                          staffActionWidget: topActionButtonWidget(
                            height: MediaQuery.of(context).size.height * 0.18,
                          ),
                          imageUrl: Globals.appSetting.staffBannerImageC!,
                          bgColor:
                              Globals.appSetting.studentBannerColorC != null
                                  ? Utility.getColorFromHex(
                                      Globals.appSetting.studentBannerColorC!)
                                  : Colors.transparent),
                    ];
                  },
                  body: _body('body1'),
                )
              : _body('body2'),
        ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    _bloc.add(StaffPageEvent());
    _homeBloc.add(FetchStandardNavigationBar());
  }

//--------------------------------------------------------------------------------------------------------
  staffActionIconsOnTap({required String actionName}) async {
    await Utility.clearStudentInfo(tableName: 'student_info');
    await Utility.clearStudentInfo(tableName: 'history_student_info');

    await FirebaseAnalyticsService.addCustomAnalyticsEvent("assignment");

    FirebaseAnalyticsService.logLogin();

    Globals.lastIndex = Globals.controller!.index;

    /* ---- Clear login local data base once because we added classroom scope --- */
    SharedPreferences clearGoogleLoginLocalDb =
        await SharedPreferences.getInstance();
    final clearCacheResult =
        await clearGoogleLoginLocalDb.getBool('delete_local_login_details1213');
    if (clearCacheResult != true) {
      await UserGoogleProfile.clearUserProfile();
      await clearGoogleLoginLocalDb.setBool(
          'delete_local_login_details1213', true);
    }
    /* ---- Clear login local data base once because we added classroom scope --- */

    List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();

    if (_profileData.isEmpty) {
      //   // await _launchURL('Google Authentication');
      //   //Google Manual Sign in
      if (Globals.appSetting.enableGoogleSSO != "true") {
        var value = await GoogleLogin.launchURL(
            'Google Authentication', context, _scaffoldKey, '', actionName);
        if (value == true) {
          navigatorToScreen(actionName: actionName);
        }
      }
      //Google Single Sign On
      else {
        User? user = await Authentication.signInWithGoogle();

        if (user != null) {
          if (user.email != null && user.email != '') {
            _ocrBloc.add(AuthorizedUserWithDatabase(email: user.email,isAuthorized: true));
            //navigatorToScreen(actionName: actionName);
          } else {
            Utility.currentScreenSnackBar(
                'You Are Not Authorized To Access The Feature. Please Use The Authorized Account.',
                null);
          }
        }
      }
    } else {
      GoogleLogin.verifyUserAndGetDriveFolder(_profileData);

      Globals.teacherEmailId = _profileData[0].userEmail!.split('@')[0];
      Globals.sessionId = "${Globals.teacherEmailId}_${myTimeStamp.toString()}";
      // DateTime currentDateTime = DateTime.now();

      //    await _getLocalDb();
      // _ocrBloc
      //     .add(AuthorizedUserWithDatabase(email: _profileData[0].userEmail));
      navigatorToScreen(actionName: actionName);
    }
  }

//--------------------------------------------------------------------------------------------------------
  navigatorToScreen({required String actionName}) {
    if (Overrides.STANDALONE_GRADED_APP == true) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => GradedLandingPage()));
    } else {
      if (actionName == 'GRADED+') {
        //Graded+ login activity
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

        pushNewScreen(
          context,
          screen: StartupPage(
            isOcrSection: true, //since always opens OCR
            isMultipleChoice: false,
          ),
          withNavBar: false,
        );
      } else if (actionName == 'PBIS+') {
        _ocrBlocLogs.add(LogUserActivityEvent(
            activityType: 'PBIS+',
            sessionId: Globals.sessionId,
            teacherId: Globals.teacherId,
            activityId: '2',
            accountId: Globals.appSetting.schoolNameC,
            accountType: "Premium",
            dateTime: currentDateTime.toString(),
            description: 'PBIS+ Accessed(Login)',
            operationResult: 'Success'));

        pushNewScreen(
          context,
          screen: PBISPlusHome(),
          withNavBar: false,
        );
      } else if (actionName == 'STUDENT+') {
        _ocrBlocLogs.add(LogUserActivityEvent(
            activityType: 'STUDENT+',
            sessionId: Globals.sessionId,
            teacherId: Globals.teacherId,
            activityId: '2',
            accountId: Globals.appSetting.schoolNameC,
            accountType: "Premium",
            dateTime: currentDateTime.toString(),
            description: 'STUDENT+ Accessed(Login)',
            operationResult: 'Success'));

        pushNewScreen(
          context,
          screen: StudentPlusSearchScreen(
              fromStudentPlusDetailPage: false,
              index: 0,
              studentDetails: studentDetails),
          withNavBar: false,
        );
      }
    }
  }

  Widget textwidget({required String text, required dynamic textTheme}) {
    return TranslationWidget(
      message: text,
      toLanguage: Globals.selectedLanguage,
      fromLanguage: "en",
      builder: (translatedMessage) => Text(
        translatedMessage.toString(),
        style: textTheme,
      ),
    );
  }

  Widget topActionButtonWidget({required double height}) {
    return ValueListenableBuilder(
        valueListenable: selectedIndex,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return Container(
              //alignment: AlignmentGeometry(),
              // padding: EdgeInsets.symmetric(horizontal: 36),
              height: height,
              width: MediaQuery.of(context).size.height * 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: StaffIconsList.staffIconsList
                    .map<Widget>((element) => GestureDetector(
                          onTap: () async {
                            selectedIndex.value =
                                StaffIconsList.staffIconsList.indexOf(element);
                            actionName = element.iconName;
                            staffActionIconsOnTap(actionName: element.iconName);
                          },
                          child: Bouncing(
                              child: AnimatedContainer(
                            padding: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              color: selectedIndex.value ==
                                      StaffIconsList.staffIconsList
                                          .indexOf(element)
                                  ? AppTheme.kSelectedColor
                                  : Colors.grey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            duration: Duration(microseconds: 100),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xff000000) !=
                                        Theme.of(context).backgroundColor
                                    ? Color(0xffF7F8F9)
                                    : Color(0xff111C20),
                                border: Border.all(
                                  color: selectedIndex.value ==
                                          StaffIconsList.staffIconsList
                                              .indexOf(element)
                                      ? AppTheme.kSelectedColor
                                      : Colors.grey,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Container(
                                height: height / 1.7,
                                width: height / 1.7,
                                decoration: BoxDecoration(
                                    //color: AppTheme.kButtonColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: element.iconUrl.contains('pbis')
                                          ? height / 4.3
                                          : height / 3,
                                      margin: EdgeInsets.all(6),
                                      child: Image(
                                        image:
                                            Image.asset(element.iconUrl).image,
                                      ),
                                    ),
                                    element.iconUrl
                                            .contains('landingPage_image')
                                        ? Container()
                                        : SpacerWidget(4),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: FittedBox(
                                        child: Utility.textWidget(
                                            text: element.iconName,
                                            textTheme: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                            context: context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                        ))
                    .toList(),
              ));
        });
  }
}
