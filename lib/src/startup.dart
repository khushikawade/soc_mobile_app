import 'dart:async';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/ui/graded_landing_page.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/news/model/notification_list.dart';
import 'package:Soc/src/modules/ocr/ui/select_assessment_type.dart';
import 'package:Soc/src/modules/ocr/widgets/custom_intro_layout.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/local_database/hive_db_services.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/shared_preference.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/widgets/device_info_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartupPage extends StatefulWidget {
  // isOcrSection will be used by the School apps that are using the Graded+ feature. isOcrSection = true will display the splash screen of Graded+ instead of School logo.
  final bool? isOcrSection;
  final bool? isMultipleChoice;
  // skipAppSettingsFetch will be used by the School apps that are using the Graded+ feature. skipAppSettingsFetch = true will skip the AppSetting fetch from AWS/Salesforce.
  final bool? skipAppSettingsFetch;
  StartupPage(
      {required this.isOcrSection,
      this.skipAppSettingsFetch,
      this.isMultipleChoice});
  @override
  _StartupPageState createState() => new _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  bool flag = true;
  // bool showlogin = true;
  final HomeBloc _bloc = new HomeBloc();
  final NewsBloc _newsBloc = new NewsBloc();
  AndroidDeviceInfo? androidInfo;
  IosDeviceInfo? ios;
  // bool? isnetworkisuue = false;
  final SharedPreferencesFn _sharedPref = SharedPreferencesFn();

  void initState() {
    super.initState();

    if (widget.skipAppSettingsFetch != true) {
      //TODO replace with ==true
      _bloc.add(FetchStandardNavigationBar());

      {
        getIndicatorValue();
        appVersion();
        initPlatformState(context);
        _bloc.add(FetchStandardNavigationBar());
        _newsBloc.add(NewsCountLength());
        getIndexValue();
        _showcase();
        if (Platform.isAndroid) {
          Globals.isAndroid = true;
        } else if (Platform.isIOS) {
          Globals.isAndroid = false;
        }
      }
    }
  }

  Future<void> _showcase() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? _flag = preferences.getBool('hasShowcaseInitialised');
    if (_flag == true) {
      Globals.hasShowcaseInitialised.value = true;
    }
    preferences.setBool('hasShowcaseInitialised', true);
  }

  late AppLifecycleState _notification;

  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
  }

  void appVersion() async {
    Globals.packageInfo = await PackageInfo.fromPlatform();
  }

  getIndexValue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Globals.splashImageUrl = pref.getString(Strings.SplashUrl);
    Globals.homeIndex = pref.getInt(Strings.bottomNavigation);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  getIndicatorValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getBool("enableIndicator") == null
        ? prefs.setBool("enableIndicator", false)
        : prefs.setBool("enableIndicator", prefs.getBool("enableIndicator")!);

    Globals.selectedLanguage = await _sharedPref.getString('selected_language');
  }

  Widget _buildSplashScreen() {
    return Center(
        child: widget.isOcrSection!
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  Globals.themeType == 'Dark'
                      ? 'assets/images/graded+_light.png'
                      : 'assets/images/graded+_dark.png',
                  fit: BoxFit.cover,
                  //    height: 50,
                ))
            : Globals.splashImageUrl != null && Globals.splashImageUrl != ""
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: CachedNetworkImage(
                      imageUrl: Globals.splashImageUrl!,
                      placeholder: (context, url) => Container(
                          alignment: Alignment.center,
                          child: Text("Loading ...",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(
                                      fontSize: 24,
                                      color: Globals.themeType == 'Dark'
                                          ? Colors.white
                                          : Colors.black))),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Icon(
                        Icons.error,
                      ),
                    ),
                  )
                : Text("Loading ...",
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: 24,
                        color: Globals.themeType == 'Dark'
                            ? Colors.white
                            : Colors.black)));
  }

  Route _createRoute(obj) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HomePage(
        title: "SOC",
        homeObj: obj,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            Globals.themeType == 'Dark' ? Colors.black : Colors.white,
        //  backgroundColor: Colors.white,
        body: widget.skipAppSettingsFetch == true
            ? Stack(fit: StackFit.expand, children: [_buildSplashScreen()])
            : Stack(
                fit: StackFit.expand,
                children: [
                  BlocBuilder<HomeBloc, HomeState>(
                      bloc: _bloc,
                      builder: (BuildContext contxt, HomeState state) {
                        if (state is HomeLoading ||
                            state is BottomNavigationBarSuccess) {
                          return _buildSplashScreen();
                        } else if (state is HomeErrorReceived) {
                          return Container(
                            child: state.err != 'NO_CONNECTION'
                                ? ListView(
                                    children: [ErrorMsgWidget()],
                                  )
                                : SafeArea(
                                    child: NoInternetErrorWidget(
                                      connected: false,
                                      issplashscreen: false,
                                      onRefresh: () {
                                        _bloc.add(FetchStandardNavigationBar());
                                      },
                                    ),
                                  ),
                          );
                        } else {
                          return Container();
                        }
                      }),
                  BlocListener<HomeBloc, HomeState>(
                      bloc: _bloc,
                      child: Container(),
                      listener: (BuildContext contxt, HomeState state) {
                        if (state is HomeErrorReceived) {
                          setState(() {
                            flag = false;
                          });
                        }
                      }),
                  Container(
                    height: 0,
                    width: 0,
                    child: BlocListener<HomeBloc, HomeState>(
                      bloc: _bloc,
                      listener: (context, state) async {
                        if (state is BottomNavigationBarSuccess) {
                          AppTheme.setDynamicTheme(Globals.appSetting, context);

                          Globals.appSetting = AppSetting.fromJson(state.obj);
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString(
                              Strings.SplashUrl,
                              state.obj["Splash_Screen__c"] ??
                                  state.obj["App_Logo__c"]);
                          await Future.delayed(Duration(milliseconds: 200));
                          if (state.obj != null) {
                            if (widget.isOcrSection == true) {
                              // Navigator.of(context).pushReplacement(
                              //     _gotoOCRLandingPage(state.obj));
                              HiveDbServices _hiveDbServices = HiveDbServices();

                              var isOldUser = await _hiveDbServices
                                  .getSingleData('new_user', 'new_user');

                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => isOldUser == true
                                    ? Overrides.STANDALONE_GRADED_APP == true
                                        ? GradedLandingPage(
                                            isMultiplechoice:
                                                widget.isMultipleChoice)
                                        : SelectAssessmentType() // OpticalCharacterRecognition()
                                    : CustomIntroWidget(
                                        isMcqSheet: widget.isMultipleChoice),
                              ));
                              //         );
                            } else {
                              Navigator.of(context)
                                  .pushReplacement(_createRoute(state.obj));
                            }
                          } else {
                            NoDataFoundErrorWidget(
                              isResultNotFoundMsg: false,
                              isNews: false,
                              isEvents: false,
                            );
                          }
                        } else if (state is HomeErrorReceived) {
                          ErrorMsgWidget();
                        }
                      },
                      child: Container(),
                    ),
                  ),
                  Container(
                    height: 0,
                    width: 0,
                    child: BlocListener<NewsBloc, NewsState>(
                      bloc: _newsBloc,
                      listener: (context, state) async {
                        if (state is NewsCountLenghtSuccess) {
                          // SharedPreferences prefs =
                          //     await SharedPreferences.getInstance();
                          // SharedPreferences intPrefs =
                          //     await SharedPreferences.getInstance();
                          // String? _objectName = "${Strings.newsObjectName}";
                          // LocalDatabase<NotificationList> _localDb =
                          //     LocalDatabase(_objectName);
                          // List<NotificationList> _localData =
                          //     await _localDb.getData();

                          // if (_localData.length < state.obj!.length &&
                          //     _localData.isNotEmpty) {
                          //   // intPrefs.setInt("totalCount", Globals.notiCount!);
                          //   // prefs.setBool("enableIndicator", true);
                          //   Globals.indicator.value = true;
                          // }
                        }
                      },
                      child: Container(),
                    ),
                  ),
                ],
              ));
  }

  _navigateToOcrSection() async {
    HiveDbServices _hiveDbServices = HiveDbServices();

    var isOldUser = await _hiveDbServices.getSingleData('new_user', 'new_user');

    Timer(Duration(seconds: 1), () async {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => isOldUser == true
              ? SelectAssessmentType() //OpticalCharacterRecognition()
              : CustomIntroWidget(),
        ),
      );
    });
  }
}
