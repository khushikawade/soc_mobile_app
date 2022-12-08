import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/ocr/modal/user_info.dart';
import 'package:Soc/src/modules/schedule/bloc/calender_bloc.dart';
import 'package:Soc/src/modules/schedule/modal/schedule_modal.dart';
import 'package:Soc/src/modules/schedule/ui/day_view.dart';
import 'package:Soc/src/modules/students/bloc/student_bloc.dart';
import 'package:Soc/src/modules/students/models/student_app.dart';
import 'package:Soc/src/modules/students/ui/apps_folder.dart';
import 'package:Soc/src/services/analytics.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../../../services/local_database/local_db.dart';
import '../../schedule/modal/blackOutDate_modal.dart';

class StudentPage extends StatefulWidget {
  final homeObj;
  final bool? isCustomSection;

  StudentPage({Key? key, this.homeObj, required this.isCustomSection})
      : super(key: key);
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  static const double _kLableSpacing = 12.0;
  int? gridLength;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final HomeBloc _homeBloc = new HomeBloc();
  bool? iserrorstate = false;

  StudentBloc _bloc = StudentBloc();
  ScrollController _scrollController = ScrollController();
  CalenderBloc _scheduleBloc = CalenderBloc();

  bool isCalenderEentCalledaAready = false;
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
      LocalDatabase<UserInformation> _localDb =
          LocalDatabase('student_profile');

      List<UserInformation> _userInformation = await _localDb.getData();

      if (_userInformation.isEmpty) {
        UserInformation result = await _launchLoginUrl('Student Login');

        if (result.userEmail != null) {
          _scheduleEvent(result);
        }
      } else {
        _scheduleEvent(_userInformation[0]);
      }

      return;
    }
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
                        isbuttomsheet: true,
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
      bloc: _scheduleBloc,
      listener: (context, state) {
        print(state);
        if (state is CalenderLoading) {
          Utility.showLoadingDialog(context, false);
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
                                      )

                                        // child: Marquee(
                                        //   text: translatedMessage.toString(),
                                        //   style: Theme.of(context)
                                        //       .textTheme
                                        //       .bodyText1!
                                        //       .copyWith(
                                        //           fontSize: Globals.deviceType ==
                                        //                   "phone"
                                        //               ? 16
                                        //               : 24),
                                        //   scrollAxis: Axis.horizontal,
                                        //   velocity: 30.0,
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment.start,
                                        //   blankSpace: 50,
                                        //   //MediaQuery.of(context).size.width
                                        //   // velocity: 100.0,
                                        //   pauseAfterRound: Duration(seconds: 5),
                                        //   showFadingOnlyWhenScrolling: true,
                                        //   startPadding: 10.0,
                                        //   accelerationDuration:
                                        //       Duration(seconds: 1),
                                        //   accelerationCurve: Curves.linear,
                                        //   decelerationDuration:
                                        //       Duration(milliseconds: 500),
                                        //   decelerationCurve: Curves.bounceIn,
                                        //   numberOfRounds: 1,
                                        //   startAfter: Duration.zero,
                                        // ),
                                        )
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
                                          )

                                            //    Marquee(
                                            //   text: translatedMessage.toString(),
                                            //   style: Theme.of(context)
                                            //       .textTheme
                                            //       .bodyText1!
                                            //       .copyWith(
                                            //           fontSize:
                                            //               Globals.deviceType ==
                                            //                       "phone"
                                            //                   ? 16
                                            //                   : 24),
                                            //   scrollAxis: Axis.horizontal,
                                            //   velocity: 30.0,
                                            //   crossAxisAlignment:
                                            //       CrossAxisAlignment.start,

                                            //   blankSpace:
                                            //       50, //MediaQuery.of(context).size.width
                                            //   // velocity: 100.0,
                                            //   pauseAfterRound: Duration(seconds: 5),
                                            //   showFadingOnlyWhenScrolling: true,
                                            //   startPadding: 10.0,
                                            //   accelerationDuration:
                                            //       Duration(seconds: 1),
                                            //   accelerationCurve: Curves.linear,
                                            //   decelerationDuration:
                                            //       Duration(milliseconds: 500),
                                            //   decelerationCurve: Curves.easeOut,
                                            //   numberOfRounds: 1,
                                            // )

                                            )
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
              if (iserrorstate == true) {
                iserrorstate = false;
                _bloc.add(StudentPageEvent());
              }
            } else if (!connected) {
              iserrorstate = true;
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
                          return Center(
                              child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primaryVariant,
                          ));
                        } else if (state is StudentDataSucess) {
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
          },
        ),
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
        isbuttomsheet: true,
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
    print(_userInformation);
    await _localDb.addData(_userInformation);
    await _localDb.close();
    return _userInformation;
  }

  void navigateToSchedule(
      {required UserInformation studentProfile,
      required List<Schedule> schedulesList,
      required List<BlackoutDate> blackoutDateList}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DayViewPage(
                date: ValueNotifier(DateTime.now()),
                studentProfile: studentProfile,
                blackoutDateList: blackoutDateList ?? [],
                schedulesList: schedulesList ?? [],
              )),
    );

    isCalenderEentCalledaAready = false;
  }

  void _scheduleEvent(UserInformation studentProfile) {
    if (isCalenderEentCalledaAready) {
      Utility.currentScreenSnackBar('Please wait..... ', null);
    } else {
      isCalenderEentCalledaAready = true;
      _scheduleBloc.add(CalenderPageEvent(
          studentProfile: studentProfile,
          pullToRefresh: false,
          isFromStudent: true));
    }
  }
}
