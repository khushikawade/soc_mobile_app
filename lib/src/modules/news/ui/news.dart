import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/news/ui/news_image.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/sliderpagewidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> with WidgetsBindingObserver {
  static const double _kIconSize = 48.0;
  static const double _kLabelSpacing = 16.0;
  NewsBloc bloc = new NewsBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  bool iserrorstate = false;

  final HomeBloc _homeBloc = new HomeBloc();
  var object;
  String newsTimeStamp = '';
  late AppLifecycleState _notification;

  @override
  void initState() {
    super.initState();
    bloc.add(FetchNotificationList());
    hideIndicator();
    WidgetsBinding.instance!.addObserver(this);
  }

  // setindexvalue() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   pref.setInt(Strings.bottomNavigation, 0);
  // }
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
    if (_notification == AppLifecycleState.resumed)
      bloc.add(FetchNotificationList());
  }

  hideIndicator() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      Globals.indicator.value = false;
      pref.setInt(Strings.bottomNavigation, 0);
      Globals.homeIndex = 0;
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent notification) async {
      notification.complete(notification.notification);
      Globals.indicator.value = true;
      await Future.delayed(Duration(milliseconds: 1500));
      bloc.add(FetchNotificationList());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  Widget _buildListItems(obj, int index) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _kLabelSpacing,
        vertical: _kLabelSpacing / 2,
      ),
      color: (index % 2 == 0)
          ? Theme.of(context).colorScheme.background
          : Theme.of(context).colorScheme.secondary,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SliderWidget(
                        obj: object,
                        currentIndex: index,
                        issocialpage: false,
                        isAboutSDPage: false,
                        isEvent: false,
                        date: "$newsTimeStamp",
                        isbuttomsheet: true,
                        language: Globals.selectedLanguage,
                      )));
        },
        child: Row(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                width: Globals.deviceType == "phone"
                    ? _kIconSize * 1.4
                    : _kIconSize * 2,
                height: Globals.deviceType == "phone"
                    ? _kIconSize * 1.5
                    : _kIconSize * 2,
                child: ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: obj.image ??
                        Globals.splashImageUrl ??
                        Globals.homeObject["App_Logo__c"],
                    placeholder: (context, url) => Container(
                        alignment: Alignment.center,
                        child: ShimmerLoading(
                          isLoading: true,
                          child: Container(
                            width: _kIconSize * 1.4,
                            height: _kIconSize * 1.5,
                            color: Colors.white,
                          ),
                        )),
                    errorWidget: (context, url, error) => CachedNetworkImage(
                      imageUrl: Globals.splashImageUrl ??
                          Globals.homeObject["App_Logo__c"],
                      placeholder: (context, url) => Container(
                          alignment: Alignment.center,
                          child: ShimmerLoading(
                            isLoading: true,
                            child: Container(
                              width: _kIconSize * 1.4,
                              height: _kIconSize * 1.5,
                              color: Colors.white,
                            ),
                          )),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                )),
            SizedBox(
              width: _kLabelSpacing / 2,
            ),
            Expanded(
              child: Container(
                child: _buildnewsHeading(obj),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildnewsHeading(obj) {
    return Container(
        alignment: Alignment.centerLeft,
        child: TranslationWidget(
          message: obj.headings!.length > 0 &&
                  obj.headings != "" &&
                  obj.headings != null
              ? obj.headings["en"].toString()
              : obj.contents["en"] ?? '-',
          fromLanguage: "en",
          toLanguage: Globals.selectedLanguage,
          builder: (translatedMessage) => Text(
            // obj.titleC.toString(),
            translatedMessage.toString(),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: Theme.of(context).textTheme.headline4!,
          ),
        ));
  }

  // Widget _buildTimeStamp(NotificationList obj) {
  //   DateTime now = DateTime.now(); //REPLACE WITH ACTUAL DATE
  //   newsTimeStamp = DateFormat('yyyy/MM/dd').format(now);
  //   return Container(
  //       child: Text(
  //     "${newsTimeStamp}",
  //     style: Theme.of(context).textTheme.subtitle1,
  //   ));
  // }

  Widget _buildList(obj) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: AppTheme.klistPadding),
        scrollDirection: Axis.vertical,
        itemCount: obj.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildListItems(obj[index], index);
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        marginLeft: 30,
        refresh: (v) {
          setState(() {});
        },
      ),
      body: RefreshIndicator(
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
                  bloc.add(FetchNotificationList());
                  iserrorstate = false;
                }
              } else if (!connected) {
                iserrorstate = true;
              }

              return connected
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder(
                            bloc: bloc,
                            builder: (BuildContext context, NewsState state) {
                              if (state is NewsLoaded) {
                                return state.obj != null &&
                                        state.obj!.length > 0
                                    ? _buildList(state.obj)
                                    : Expanded(
                                        child: NoDataFoundErrorWidget(
                                          isResultNotFoundMsg: false,
                                          isNews: true,
                                          isEvents: false,
                                        ),
                                      );
                              } else if (state is NewsLoading) {
                                return Expanded(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                );
                              } else if (state is NewsErrorReceived) {
                                return ListView(
                                    shrinkWrap: true,
                                    children: [ErrorMsgWidget()]);
                              } else {
                                return Container();
                              }
                            }),
                        Container(
                          height: 0,
                          width: 0,
                          child: BlocListener<NewsBloc, NewsState>(
                            bloc: bloc,
                            listener: (context, state) async {
                              if (state is NewsLoaded) {
                                object = state.obj;
                                // SharedPreferences prefs =
                                //     await SharedPreferences.getInstance();
                                SharedPreferences intPrefs =
                                    await SharedPreferences.getInstance();
                                intPrefs.getInt("totalCount") == null
                                    ? intPrefs.setInt(
                                        "totalCount", Globals.notiCount!)
                                    : intPrefs.getInt("totalCount");
                                // print(intPrefs.getInt("totalCount"));
                                if (Globals.notiCount! >
                                    intPrefs.getInt("totalCount")!) {
                                  intPrefs.setInt(
                                      "totalCount", Globals.notiCount!);
                                }
                              }
                            },
                            child: Container(),
                          ),
                        ),
                        Container(
                          height: 0,
                          width: 0,
                          child: BlocListener<HomeBloc, HomeState>(
                              bloc: _homeBloc,
                              listener: (context, state) async {
                                if (state is BottomNavigationBarSuccess) {
                                  AppTheme.setDynamicTheme(
                                      Globals.appSetting, context);
                                  Globals.homeObject = state.obj;
                                  setState(() {});
                                } else if (state is HomeErrorReceived) {
                                  ErrorMsgWidget();
                                }
                              },
                              child: EmptyContainer()),
                        ),
                      ],
                    )
                  : NoInternetErrorWidget(
                      connected: connected, issplashscreen: false);
            },
            child: Container()),
        onRefresh: refreshPage,
      ),
    );
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    bloc.add(FetchNotificationList());
    _homeBloc.add(FetchBottomNavigationBar());
  }
}
