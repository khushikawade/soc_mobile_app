import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/news/model/notification_list.dart';
import 'package:Soc/src/widgets/action_button_basic.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/widgets/calendra_icon_widget.dart';
import 'package:Soc/src/widgets/common_feed_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/sliderpagewidget.dart';
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
  // static const double _kLabelSpacing = 16.0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // static const double _kIconSize = 48.0;
  // static const double _kPhoneIcon = 36.0;
  // static const double _kTabletIcon = 55.0;

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
  bool? result;

  @override
  void initState() {
    super.initState();

    bloc.add(FetchNotificationList());
    _countBloc.add(FetchActionCountList(isDetailPage: false));
    hideIndicator();
    WidgetsBinding.instance!.addObserver(this);
    Globals.isNewTap = false;
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    // setState(() {
    //   _notification = state;
    // });
    if (state == AppLifecycleState.resumed) bloc.add(FetchNotificationList());
    isActionAPICalled = false;
    //  _countBloc.add(FetchActionCountList());
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
    return Container(
      // padding: EdgeInsets.symmetric(
      //   horizontal: _kLabelSpacing,
      //   vertical: _kLabelSpacing / 2,
      // ),
      // padding: EdgeInsets.symmetric(
      //   // horizontal: _kLabelSpacing,
      //   vertical: _kLabelSpacing / 1,
      // ),
      color: Theme.of(context).colorScheme.background,

      child: InkWell(
        onTap: () async {
          if (isCountLoading == true) {
            Utility.showSnackBar(
                _scaffoldKey, "Please wait while count is loading", context);
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
              _countBloc.add(FetchActionCountList(isDetailPage: true));
            }
          }
        },
        child: CommonFeedWidget(
          actionIcon: Container(child: actionButton(list, obj, index)),
          title: obj.headings!.length > 0 &&
                  obj.headings != "" &&
                  obj.headings != null
              ? '${obj.headings["en"].toString()}'
              : obj.contents["en"] ?? '-',
          description: '${obj.contents["en"].toString()}',
          titleIcon: CalendraIconWidget(dateTime: obj.completedAt),
          // calanderView(obj.completedAt),
          url: obj.image != '' && obj.image != null ? obj.image! : '',
          //  Globals.splashImageUrl != '' && Globals.splashImageUrl != null
          //     ? Globals.splashImageUrl
          //     : Globals.appSetting.appLogoC,
        ),
      ),
    );
  }

  Widget actionButton(
      List<NotificationList> list, NotificationList obj, int index) {
    return Column(
      children: [
        BlocListener<NewsBloc, NewsState>(
          bloc: _countBloc,
          listener: (context, state) async {
            if (state is ActionCountSuccess) {
              newsMainList.clear();
              newsMainList.addAll(state.obj);
              // print(newsMainList);
              isCountLoading = false;
              Container(
                alignment: Alignment.centerLeft,
                child: NewsActionBasic(
                    title: state.obj[index].headings['en'],
                    description: state.obj[index].contents['en'],
                    imageUrl: state.obj[index].image,
                    obj: state.obj[index],
                    page: "news",
                    isLoading: isCountLoading),
              );
            }
          },
          child: Container(),
        ),
        BlocBuilder(
            bloc: _countBloc,
            builder: (BuildContext context, NewsState state) {
              if (state is ActionCountSuccess) {
                newsMainList.clear();
                newsMainList.addAll(state.obj);
                isCountLoading = false;
                return Container(
                  alignment: Alignment.centerLeft,
                  child: state.obj[index] ==
                          null // To make it backward compatible:: If the local database has something different than the real data that has been fetched by the API.
                      ? Container()
                      : NewsActionBasic(
                          title: state.obj[index].headings['en'],
                          description: state.obj[index].contents['en'],
                          imageUrl: state.obj[index].image,
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
                          title: Globals.notificationList[index].headings['en'],
                          description:
                              Globals.notificationList[index].contents['en'],
                          imageUrl: Globals.notificationList[index].image,
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
                          title: Globals.notificationList[index].headings['en'],
                          description:
                              Globals.notificationList[index].contents['en'],
                          imageUrl: Globals.notificationList[index].image,
                          obj: Globals.notificationList[index],
                          page: "news",
                          isLoading: isCountLoading)),
                );
              }
            }),
      ],
    );
  }

  // marqueesText(String title) {
  //   return title.length < 50
  //       ? Text("$title",
  //           style: Theme.of(context).textTheme.headline2!.copyWith(
  //                 color: Theme.of(context).colorScheme.primaryVariant,
  //               ))
  //       : Marquee(
  //           text: "$title",
  //           style: Theme.of(context).textTheme.headline2!.copyWith(
  //                 color: Theme.of(context).colorScheme.primaryVariant,
  //               ),
  //           scrollAxis: Axis.horizontal,
  //           velocity: 30.0,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           blankSpace: //50,
  //               MediaQuery.of(context).size.width * 0.5,
  //           // velocity: 100.0,
  //           pauseAfterRound: Duration(seconds: 5),
  //           showFadingOnlyWhenScrolling: true,
  //           startPadding: 0.0,
  //           accelerationDuration: Duration(seconds: 1),
  //           accelerationCurve: Curves.linear,
  //           decelerationDuration: Duration(milliseconds: 500),
  //           decelerationCurve: Curves.easeOut,
  //         );
  // }

  Widget _buildList(List<NotificationList> obj) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
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
                  _countBloc.add(FetchActionCountList(isDetailPage: false));
                  iserrorstate = false;
                }
              } else if (!connected) {
                iserrorstate = true;
                _countBloc.add(FetchActionCountList(isDetailPage: false));
                // _countBloc.add(FetchActionCountList());
              }

              return
                  //  connected?
                  Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocListener<NewsBloc, NewsState>(
                    bloc: bloc,
                    listener: (context, state) async {
                      if (state is NewsLoaded) {
                        _countBloc
                            .add(FetchActionCountList(isDetailPage: false));
                        if (isActionAPICalled == false) {
                          _countBloc
                              .add(FetchActionCountList(isDetailPage: false));
                          isActionAPICalled = true;
                        }
                        // object = state.obj;
                        SharedPreferences intPrefs =
                            await SharedPreferences.getInstance();
                        intPrefs.getInt("totalCount") == null
                            ? intPrefs.setInt("totalCount", Globals.notiCount!)
                            : intPrefs.getInt("totalCount");
                        if (Globals.notiCount! >
                            intPrefs.getInt("totalCount")!) {
                          intPrefs.setInt("totalCount", Globals.notiCount!);
                        }
                      }
                    },
                    child: Container(),
                  ),
                  BlocListener<HomeBloc, HomeState>(
                      bloc: _homeBloc,
                      listener: (context, state) async {
                        if (state is BottomNavigationBarSuccess) {
                          AppTheme.setDynamicTheme(Globals.appSetting, context);
                          // Globals.homeObject = state.obj;
                          Globals.appSetting = AppSetting.fromJson(state.obj);

                          // setState(() {});
                        } else if (state is HomeErrorReceived) {
                          ErrorMsgWidget();
                        }
                      },
                      child: EmptyContainer()),
                  BlocBuilder(
                      bloc: bloc,
                      builder: (BuildContext context, NewsState state) {
                        if (state is NewsLoaded) {
                          Globals.notificationList.clear();
                          Globals.notificationList.addAll(state.obj!);
                          return state.obj != null && state.obj!.length > 0
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
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          );
                        } else if (state is NewsErrorReceived) {
                          return ListView(
                              shrinkWrap: true, children: [ErrorMsgWidget()]);
                        } else {
                          return Container();
                        }
                      }),

                  // actionButton(),
                ],
              );
              // : NoInternetErrorWidget(
              //     connected: connected, issplashscreen: false);
            },
            child: Container()),
        onRefresh: refreshPage,
      ),
    );
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
     await Future.delayed(Duration(seconds: 2));
    bloc.add(FetchNotificationList());
    isActionAPICalled = false;
    _homeBloc.add(FetchBottomNavigationBar());
  }
}
