import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/news/model/action_count_list.dart';
import 'package:Soc/src/modules/news/model/notification_list.dart';
import 'package:Soc/src/modules/news/ui/news_image.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/news_action.dart';
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
  NewsBloc _countBloc = new NewsBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  bool iserrorstate = false;
  List icons = [0xe823, 0xe824, 0xe825];
  final HomeBloc _homeBloc = new HomeBloc();
  var object;
  String newsTimeStamp = '';
  late AppLifecycleState _notification;
  List<ActionCountList> actionCountList = [];

  @override
  void initState() {
    super.initState();
    bloc.add(FetchNotificationList());
    _countBloc.add(FetchActionCountList());
    hideIndicator();
    WidgetsBinding.instance!.addObserver(this);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
    if (_notification == AppLifecycleState.resumed)
      bloc.add(FetchNotificationList());
    _countBloc.add(FetchActionCountList());
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
      bloc.add(FetchNotificationList());
      _countBloc.add(FetchActionCountList());
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
      children: [
        Container(
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
                              newsCountObj:
                                  obj.id == actionCountList[index].name
                                      ? actionCountList[index]
                                      : ActionCountList(),
                              icons: icons,
                              obj: object,
                              currentIndex: index,
                              issocialpage: false,
                              iseventpage: false,
                              date: "$newsTimeStamp",
                              isbuttomsheet: true,
                              language: Globals.selectedLanguage,
                            )));
              },
              child: ListTile(
                  leading: Container(
                    alignment: Alignment.center,
                    width: Globals.deviceType == "phone"
                        ? _kIconSize * 1.4
                        : _kIconSize * 2,
                    height: Globals.deviceType == "phone"
                        ? _kIconSize * 1.5
                        : _kIconSize * 2,
                    child: obj.image != null
                        ? ClipRRect(
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) =>
                                        NewsImagePage(imageURL: obj.image!));
                              },
                              child: CachedNetworkImage(
                                imageUrl: obj.image!,
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
                            ),
                          )
                        : Container(
                            width: Globals.deviceType == "phone"
                                ? _kIconSize * 1.4
                                : _kIconSize * 2,
                            height: Globals.deviceType == "phone"
                                ? _kIconSize * 1.5
                                : _kIconSize * 2,
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => NewsImagePage(
                                        imageURL:
                                            Globals.splashImageUrl != null &&
                                                    Globals.splashImageUrl != ""
                                                ? Globals.splashImageUrl
                                                : Globals
                                                    .homeObjet["App_Logo__c"]));
                              },
                              child: CachedNetworkImage(
                                imageUrl: Globals.splashImageUrl != null &&
                                        Globals.splashImageUrl != ""
                                    ? Globals.splashImageUrl
                                    : Globals.homeObjet["App_Logo__c"],
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
                            ),
                          ),
                  ),
                  title: _buildnewsHeading(obj),
                  subtitle: NewsActionButton(
                      newsObj: obj,
                      icons: icons) //countObj: actionCountList[index])
                  // NewsActionButton(newsObj: obj, icons: icons,)//

                  //NewActionButton(obj: obj, icons: icons), //_buildActionButton(),
                  )),
        ),
        // actionButton(list, obj, index),
      ],
    );
  }

  Widget actionButton(
      List<NotificationList> list, NotificationList obj, index) {
    return BlocListener(
        bloc: _countBloc,
        listener: (BuildContext context, NewsState state) {
          if (state is ActionCountSuccess) {
            for (int i = 0; i < list.length; i++) {
              for (int j = 0; j < state.obj!.length; j++) {
                if (list[i].id == state.obj[j].name) {
                  list.add(NotificationList(
                      likeCount: state.obj[j].likeCount,
                      thanksCount: state.obj[j].thanksCount,
                      helpfulCount: state.obj[j].helpfulCount,
                      shareCount: state.obj[j].shareCount));
                }
                setState(() {
                  
                });
              }
            }

             NewsActionButton(
              newsObj: obj,
              icons: icons,
              // countObj: obj.id == state.obj[index].name
              //     ? state.obj[index]
              //     : ActionCountList()
            );
          } else if (state is NewsLoading) {
             Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          } else if (state is NewsErrorReceived) {
             ListView(shrinkWrap: true, children: [ErrorMsgWidget()]);
          } else {
             Container();
          }
        },child: Container(),);
    // return BlocListener(
    //     bloc: _countBloc,
    //     listener: (BuildContext context, NewsState state) {
    //       if (state is ActionCountSuccess) {
    //         return NewsActionButton(
    //             newsObj: obj, icons: icons, countObj: state.obj);
    //       } else if (state is NewsLoading) {
    //         return Expanded(
    //           child: Container(
    //             height: MediaQuery.of(context).size.height * 0.8,
    //             child: Center(child: CircularProgressIndicator()),
    //           ),
    //         );
    //       } else if (state is NewsErrorReceived) {
    //         return ListView(shrinkWrap: true, children: [ErrorMsgWidget()]);
    //       } else {
    //         return Container();
    // }
    // });
  }

  Widget _buildnewsHeading(obj) {
    return Container(
        margin: EdgeInsets.only(
          left: 10,
        ),
        // color: Colors.red,
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
                  style: Theme.of(context).textTheme.bodyText2!,
                ),
              )
            : Text(
                obj.headings!.length > 0 &&
                        obj.headings != "" &&
                        obj.headings != null
                    ? obj.headings["en"].toString()
                    : obj.contents["en"] ?? '-',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.headline4!,
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

  Widget _buildList(List<NotificationList> obj) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 40),
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
                  _countBloc.add(FetchActionCountList());
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
                                object = state.obj;
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
                                  Globals.homeObjet = state.obj;
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
    _homeBloc.add(FetchBottomNavigationBar());
  }
}
