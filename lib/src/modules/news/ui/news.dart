import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/Strings.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_message_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/sliderpagewidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  static const double _kIconSize = 48.0;
  static const double _kLabelSpacing = 20.0;
  NewsBloc bloc = new NewsBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  bool iserrorstate = false;

  final HomeBloc _homeBloc = new HomeBloc();
  var object;
  String newsTimeStamp = '';

  @override
  void initState() {
    super.initState();
    bloc.add(FetchNotificationList());
    hideIndicator();
  }

  setindexvalue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(Strings.bottomNavigation, 0);
  }

  hideIndicator() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool("enableIndicator", false);
    });
  }

  @override
  void dispose() {
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
                        iseventpage: false,
                        date: "$newsTimeStamp",
                        isbuttomsheet: true,
                        language: Globals.selectedLanguage,
                      )));
        },
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: _kIconSize * 1.4,
              height: _kIconSize * 1.5,
              child: obj.image != null
                  ? ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: obj.image!,
                        fit: BoxFit.fill,
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
                    )
                  : Container(
                      width: _kIconSize * 1.4,
                      height: _kIconSize * 1.5,
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        child: CachedNetworkImage(
                          imageUrl: Globals.homeObjet["App_Logo__c"],
                          fit: BoxFit.fill,
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
            SizedBox(
              width: _kLabelSpacing / 2,
            ),
            Expanded(
              flex: 5,
              child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: _kLabelSpacing / 3, horizontal: _kLabelSpacing),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildnewsHeading(obj),
                      ])),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildnewsHeading(obj) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English"
            ? TranslationWidget(
                message: obj.contents["en"] ?? '-',
                fromLanguage: "en",
                toLanguage: Globals.selectedLanguage,
                builder: (translatedMessage) => Text(
                  // obj.titleC.toString(),
                  translatedMessage.toString(),
                  style: Theme.of(context).textTheme.bodyText2!,
                ),
              )
            : Text(
                obj.contents["en"] ?? '-',
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

  Widget _buildList(obj) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 40),
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

              return new Stack(fit: StackFit.expand, children: [
                connected
                    ? Column(
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
                                          child: ListView(children: [
                                            NoDataFoundErrorWidget()
                                          ]),
                                        );
                                } else if (state is NewsLoading) {
                                  return Expanded(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    ),
                                  );
                                } else if (state is NewsErrorReceived) {
                                  return Expanded(
                                    child: ListView(children: [
                                      ErrorMsgWidget(),
                                    ]),
                                  );
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
                        ],
                      )
                    : NoInternetErrorWidget(
                        connected: connected, issplashscreen: false),
              ]);
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
