import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/custom/model/custom_setting.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/news/model/notification_list.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/shared_preference.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/services/strings.dart';
import 'package:Soc/src/widgets/device_info_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../globals.dart';

class StartupPage extends StatefulWidget {
  @override
  _StartupPageState createState() => new _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  bool flag = true;
  bool showlogin = true;
  final HomeBloc _bloc = new HomeBloc();

  final NewsBloc _newsBloc = new NewsBloc();

  AndroidDeviceInfo? androidInfo;
  IosDeviceInfo? ios;
  bool? isnetworkisuue = false;
  final SharedPreferencesFn _sharedPref = SharedPreferencesFn();

  void initState() {
    super.initState();
    _onNotificationTap();

    getindicatorValue();
    appversion();
    initPlatformState(context);
    _bloc.add(FetchStandardNavigationBar());
    _newsBloc.add(NewsCountLength());
    getindexvalue();
    _showcase();
    if (Platform.isAndroid) {
      Globals.isAndroid = true;
    } else if (Platform.isIOS) {
      Globals.isAndroid = false;
    }
  }

  _onNotificationTap() {
    // OneSignal.shared
    //     .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    //   this.setState(() {
    //     Globals.isNewTap = true;
    //   });
    // });
    OneSignal.shared.setNotificationWillShowInForegroundHandler((event) {
      setState(() {
        Globals.indicator.value = true;
      });
    });
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

  void appversion() async {
    Globals.packageInfo = await PackageInfo.fromPlatform();
  }

  getindexvalue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Globals.homeIndex = pref.getInt(Strings.bottomNavigation);
    Globals.splashImageUrl = pref.getString(Strings.SplashUrl);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  getindicatorValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getBool("enableIndicator") == null
        ? prefs.setBool("enableIndicator", false)
        : prefs.setBool("enableIndicator", prefs.getBool("enableIndicator")!);

    Globals.selectedLanguage = await _sharedPref.getString('selected_language');
  }

  Widget _buildSplashScreen() {
    return Center(
        child: Globals.splashImageUrl != null && Globals.splashImageUrl != " "
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: CachedNetworkImage(
                  imageUrl: Globals.splashImageUrl!,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            Globals.themeType == 'Dark' ? Colors.black : Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [
            BlocBuilder<HomeBloc, HomeState>(
                bloc: _bloc,
                builder: (BuildContext contxt, HomeState state) {
                  if (state is HomeLoading) {
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
                    state.obj != null
                        ? Navigator.of(context)
                            .pushReplacement(_createRoute(state.obj))
                        : NoDataFoundErrorWidget(
                            isResultNotFoundMsg: false,
                            isNews: false,
                            isEvents: false,
                          );
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
                    String? _objectName = "${Strings.newsObjectName}";
                    LocalDatabase<NotificationList> _localDb =
                        LocalDatabase(_objectName);
                    List<NotificationList> _localData =
                        await _localDb.getData();

                    if (_localData.length < state.obj!.length &&
                        _localData.isNotEmpty) {
                      // intPrefs.setInt("totalCount", Globals.notiCount!);
                      // prefs.setBool("enableIndicator", true);
                      Globals.indicator.value = true;
                    }
                  }
                },
                child: Container(),
              ),
            ),
          ],
        ));
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
}
