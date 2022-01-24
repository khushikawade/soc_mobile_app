import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/news/model/notification_list.dart';
import 'package:Soc/src/modules/news/ui/news_action_basic.dart';
import 'package:Soc/src/modules/news/ui/news_image.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/sliderpagewidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:marquee/marquee.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static const double _kIconSize = 48.0;
  // static const double _kLabelSpacing = 16.0;
  NewsBloc bloc = new NewsBloc();
  NewsBloc _countBloc = new NewsBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  bool iserrorstate = false;
  final HomeBloc _homeBloc = new HomeBloc();
  String newsTimeStamp = '';
  late AppLifecycleState _notification;
  List newsMainList = [];
  bool? isCountLoading = true;
  bool? isActionAPICalled = false;

  @override
  void initState() {
    super.initState();
    bloc.add(FetchNotificationList());
    // _countBloc.add(FetchActionCountList());
    hideIndicator();
    WidgetsBinding.instance!.addObserver(this);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
    if (_notification == AppLifecycleState.resumed)
      bloc.add(FetchNotificationList());
    isActionAPICalled = false;
    // _countBloc.add(FetchActionCountList());
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
      isActionAPICalled = false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  Widget _buildListItems(
      List<NotificationList> list, NotificationList obj, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // padding: EdgeInsets.symmetric(
          //   // horizontal: _kLabelSpacing,
          //   vertical: _kLabelSpacing / 1,
          // ),
          color: (index % 2 == 0)
              ? Theme.of(context).colorScheme.background
              : Theme.of(context).colorScheme.secondary,
          child: InkWell(
              onTap: () async {
                if (isCountLoading == true) {
                  Utility.showSnackBar(_scaffoldKey,
                      "Please wait while count is loading", context);
                } else {
                  bool result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SliderWidget(
                                obj: newsMainList.length > 0 &&
                                        newsMainList[index] != null
                                    ? newsMainList
                                    : list,
                                currentIndex: index,
                                issocialpage: false,
                                isAboutSDPage: false,
                                iseventpage: false,
                                date: "$newsTimeStamp",
                                isbuttomsheet: true,
                                language: Globals.selectedLanguage,
                              )));

                  if (result == true) {
                    _countBloc.add(FetchActionCountList());
                  }
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpacerWidget(20),
                  ListTile(
                    // contentPadding: EdgeInsets.only(),
                    leading: Container(
                        // color: Colors.green,
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width * 0.12,
                        height: MediaQuery.of(context).size.width * 0.5,
                        child:
                            //obj.image != null
                            //     ?
                            ClipRRect(
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
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        )),
                    title: Container(
                        padding: EdgeInsets.only(bottom: 7),
                        child: _buildnewsHeading(obj)),
                    subtitle: Container(
                        // padding: EdgeInsets.only(top: 10),
                        child: actionButton(list, obj, index)),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Widget actionButton(
      List<NotificationList> list, NotificationList obj, int index) {
    return BlocBuilder(
        bloc: _countBloc,
        builder: (BuildContext context, NewsState state) {
          if (state is ActionCountSuccess) {
            newsMainList.clear();
            newsMainList.addAll(state.obj);
            isCountLoading = false;
            return Container(
              // alignment: Alignment.centerLeft,
              child: NewsActionBasic(
                  obj: state.obj[index],
                  page: "news",
                  isLoading: isCountLoading),
            );
          } else if (state is NewsLoading) {
            return Container(
              alignment: Alignment.centerLeft,
              child: ShimmerLoading(
                  isLoading: true,
                  child: NewsActionBasic(
                      obj: Globals.notificationList[index],
                      page: "news",
                      isLoading: isCountLoading)),
            );
          } else if (state is NewsErrorReceived) {
            return ListView(shrinkWrap: true, children: [ErrorMsgWidget()]);
          } else {
            return Container(
              alignment: Alignment.centerLeft,
              child: ShimmerLoading(
                  isLoading: true,
                  child: NewsActionBasic(
                      obj: Globals.notificationList[index],
                      page: "news",
                      isLoading: isCountLoading)),
            );
          }
        });
  }

  Widget _buildnewsHeading(NotificationList obj) {
    return Container(
        // color: Colors.red,
        // height: 20,
        alignment: Alignment.centerLeft,
        child: Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English" &&
                Globals.selectedLanguage != ""
            ? TranslationWidget(
                message: obj.headings!.length > 0 &&
                        obj.headings != "" &&
                        obj.headings != null
                    ? obj.headings["en"].toString()
                    : obj.contents["en"] ?? '-',
                fromLanguage: "en",
                toLanguage: Globals.selectedLanguage,
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.headline4!,
                ),
              )
            : marqueesText(
                obj.headings!.length > 0 &&
                        obj.headings != "" &&
                        obj.headings != null
                    ? obj.headings["en"].toString()
                    : obj.contents["en"].toString().split("\n")[0],
              ));
  }

  marqueesText(String title) {
    return title.length < 45
        ? Text("$title", style: Theme.of(context).textTheme.headline4!)
        : Marquee(
            text: "$title",
            style: Theme.of(context).textTheme.headline4!,
            scrollAxis: Axis.horizontal,
            velocity: 30.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: //50,
                MediaQuery.of(context).size.width * 0.5,
            // velocity: 100.0,
            pauseAfterRound: Duration(seconds: 5),
            showFadingOnlyWhenScrolling: true,
            startPadding: 0.0,
            accelerationDuration: Duration(seconds: 1),
            accelerationCurve: Curves.linear,
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          );
  }

  Widget _buildList(List<NotificationList> obj) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: AppTheme.klistPadding),
        scrollDirection: Axis.vertical,
        itemCount: obj.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildListItems(obj, obj[index], index);
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                  isActionAPICalled = false;
                  // _countBloc.add(FetchActionCountList());
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
                                    ? _buildList(state.obj!)
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
                                if (isActionAPICalled == false) {
                                  _countBloc.add(FetchActionCountList());
                                  isActionAPICalled = true;
                                }
                                // object = state.obj;
                                SharedPreferences intPrefs =
                                    await SharedPreferences.getInstance();
                                intPrefs.getInt("totalCount") == null
                                    ? intPrefs.setInt(
                                        "totalCount", Globals.notiCount!)
                                    : intPrefs.getInt("totalCount");
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
                        // actionButton(),
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
    isActionAPICalled = false;
    _homeBloc.add(FetchBottomNavigationBar());
  }
}
