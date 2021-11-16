import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
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
import 'package:flutter_offline/flutter_offline.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../globals.dart';
import '../bloc/user_bloc.dart';

class StartupPage extends StatefulWidget {
  @override
  _StartupPageState createState() => new _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  bool flag = true;
  bool showlogin = true;
  final HomeBloc _bloc = new HomeBloc();
  UserBloc _loginBloc = new UserBloc();
  final NewsBloc _newsBloc = new NewsBloc();
  // static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  AndroidDeviceInfo? androidInfo;
  IosDeviceInfo? ios;
  bool? isnetworkisuue = false;
  final SharedPreferencesFn _sharedPref = SharedPreferencesFn();

  void initState() {
    super.initState();
    getindicatorValue();
    initPlatformState(context);
    _loginBloc.add(PerfomLogin());
    _newsBloc.add(FetchNotificationList());
    getindexvalue();
    _showcase();
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
    print(_notification);
  }

  getindexvalue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Globals.homeIndex = pref.getInt(Strings.bottomNavigation);
    Globals.splashImageUrl = pref.getString(Strings.SplashUrl);
  }

  @override
  void dispose() {
    _bloc.close();
    _loginBloc.close();
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
                  fit: BoxFit.fill,
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                  ),
                ),
              )
            : Text(
                "Loading ...",
                style: TextStyle(fontSize: 28, color: Colors.black),
              ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;
            // final call = connected ? _loginBloc.add(PerfomLogin()) : null;
            return new Stack(
              fit: StackFit.expand,
              children: [
                //Will show the splash screen while the auto login is in the progress
                connected
                    ? BlocBuilder<UserBloc, UserState>(
                        bloc: _loginBloc,
                        builder: (BuildContext contxt, UserState state) {
                          if (state is Loading) {
                            return _buildSplashScreen();
                          }
                          if (state is ErrorReceived) {
                            return ListView(children: [
                              ErrorMsgWidget(),
                            ]);
                          }
                          return Container();
                        })
                    : NoInternetErrorWidget(
                        connected: connected,
                        issplashscreen: true,
                      ),
                // Login End
                // Showing spash screen while fetching App Settings(Bottom Nav items, colors etc.)
                connected
                    ? BlocBuilder<HomeBloc, HomeState>(
                        bloc: _bloc,
                        builder: (BuildContext contxt, HomeState state) {
                          if (state is HomeLoading) {
                            return _buildSplashScreen();
                          }
                          if (state is ErrorReceived) {
                            return ListView(children: [
                              ErrorMsgWidget(),
                            ]);
                          }
                          return Container();
                        })
                    : NoInternetErrorWidget(
                        connected: connected,
                        issplashscreen: true,
                      ),
                // Fetching App Settings(Bottom Nav items, colors etc.) End.
                Container(
                  height: 0,
                  width: 0,
                  child: BlocListener<UserBloc, UserState>(
                    bloc: _loginBloc,
                    listener: (context, state) async {
                      if (state is LoginSuccess) {
                        Globals.token != null && Globals.token != " "
                            ? _bloc.add(FetchBottomNavigationBar())
                            : Container(
                                child: Center(
                                    child: Text(
                                        "Please refresh your application")),
                              );
                      }
                    },
                    child: Container(),
                  ),
                ),
                Container(
                  height: 0,
                  width: 0,
                  child: BlocListener<HomeBloc, HomeState>(
                    bloc: _bloc,
                    listener: (context, state) async {
                      if (state is BottomNavigationBarSuccess) {
                        AppTheme.setDynamicTheme(Globals.appSetting, context);
                        Globals.homeObjet = state.obj;
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString(
                            Strings.SplashUrl,
                            state.obj["Splash_Screen__c"] ??
                                state.obj["App_Logo__c"]);
                        state.obj != null
                            ? Navigator.of(context)
                                .pushReplacement(_createRoute(state))
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
                      if (state is NewsLoaded) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        SharedPreferences intPrefs =
                            await SharedPreferences.getInstance();
                        intPrefs.getInt("totalCount") == null
                            ? intPrefs.setInt("totalCount", Globals.notiCount!)
                            : intPrefs.getInt("totalCount");
                        // print(intPrefs.getInt("totalCount"));
                        if (Globals.notiCount! >
                            intPrefs.getInt("totalCount")!) {
                          intPrefs.setInt("totalCount", Globals.notiCount!);
                          prefs.setBool("enableIndicator", true);
                          Globals.indicator.value = true;
                        }
                      }
                    },
                    child: Container(),
                  ),
                ),
              ],
            );
          },
          child: Container()),
    );
  }

  Route _createRoute(state) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HomePage(
        title: "SOC",
        homeObj: state.obj,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }
}
