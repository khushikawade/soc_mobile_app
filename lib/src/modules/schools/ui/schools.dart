import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/schools/ui/school_details.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/sliderpagewidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchoolPage extends StatefulWidget {
  @override
  _SchoolPageState createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> {
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
    // bloc.add(FetchNotificationList());
  }

  Widget _buildListItems(int index) {
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
                  builder: (context) => SchoolDetailPage()
                  // SliderWidget(
                  //       obj: object,
                  //       currentIndex: index,
                  //       issocialpage: false,
                  //       iseventpage: true,
                  //       date: "$newsTimeStamp",
                  //       isbuttomsheet: true,
                  //       language: Globals.selectedLanguage,
                  //     )
                      ));
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
            // Container(
            //   alignment: Alignment.center,
            //   width: Globals.deviceType == "phone"
            //       ? _kIconSize * 1.4
            //       : _kIconSize * 2,
            //   height: Globals.deviceType == "phone"
            //       ? _kIconSize * 1.5
            //       : _kIconSize * 2,
            //   child: obj.image != null
            //       ? ClipRRect(
            //           child: GestureDetector(
            //             onTap: () {
            //               showDialog(
            //                   context: context,
            //                   builder: (_) =>
            //                       NewsImagePage(imageURL: obj.image!));
            //             },
            //             child: CachedNetworkImage(
            //               imageUrl: obj.image!,
            //               placeholder: (context, url) => Container(
            //                   alignment: Alignment.center,
            //                   child: ShimmerLoading(
            //                     isLoading: true,
            //                     child: Container(
            //                       width: _kIconSize * 1.4,
            //                       height: _kIconSize * 1.5,
            //                       color: Colors.white,
            //                     ),
            //                   )),
            //               errorWidget: (context, url, error) =>
            //                   Icon(Icons.error),
            //             ),
            //           ),
            //         )
            //       : Container(
            //           width: Globals.deviceType == "phone"
            //               ? _kIconSize * 1.4
            //               : _kIconSize * 2,
            //           height: Globals.deviceType == "phone"
            //               ? _kIconSize * 1.5
            //               : _kIconSize * 2,
            //           alignment: Alignment.centerLeft,
            //           child: GestureDetector(
            //             onTap: () {
            //               showDialog(
            //                   context: context,
            //                   builder: (_) => NewsImagePage(
            //                       imageURL: Globals.splashImageUrl != null &&
            //                               Globals.splashImageUrl != ""
            //                           ? Globals.splashImageUrl
            //                           : Globals.homeObjet["App_Logo__c"]));
            //             },
            //             child: CachedNetworkImage(
            //               imageUrl: Globals.splashImageUrl != null &&
            //                       Globals.splashImageUrl != ""
            //                   ? Globals.splashImageUrl
            //                   : Globals.homeObjet["App_Logo__c"],
            //               placeholder: (context, url) => Container(
            //                   alignment: Alignment.center,
            //                   child: ShimmerLoading(
            //                     isLoading: true,
            //                     child: Container(
            //                       width: _kIconSize * 1.4,
            //                       height: _kIconSize * 1.5,
            //                       color: Colors.white,
            //                     ),
            //                   )),
            //               errorWidget: (context, url, error) =>
            //                   Icon(Icons.error),
            //             ),
            //           ),
            //         ),
            // ),
            SizedBox(
              width: _kLabelSpacing / 2,
            ),
            Expanded(
              child: Container(
                child:
                    _buildnewsHeading(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildnewsHeading() {
    return Container(
        alignment: Alignment.centerLeft,
        child: Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English" &&
                Globals.selectedLanguage != ""
            ? TranslationWidget(
                message: "School list item",//obj.headings!.length > 0 &&  obj.headings != "" && obj.headings != null
                    // ? obj.headings["en"].toString()
                    // : obj.contents["en"] ?? '-',
                fromLanguage: "en",
                toLanguage: Globals.selectedLanguage,
                builder: (translatedMessage) => Text(
                  // obj.titleC.toString(),
                  translatedMessage.toString(),
                  style: Theme.of(context).textTheme.bodyText2!,
                ),
              )
            : Text("School list item",
                // obj.headings!.length > 0 && obj.headings != "" && obj.headings != null
                //     ? obj.headings["en"].toString()
                //     : obj.contents["en"] ?? '-',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.headline4!,
              ));
  }


  Widget _buildList() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 40),
        scrollDirection: Axis.vertical,
        itemCount: 10,//obj.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildListItems(index);
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
                        _buildList(),
                       
                        Container(
                          height: 0,
                          width: 0,
                          child: BlocListener<NewsBloc, NewsState>(
                            bloc: bloc,
                            listener: (context, state) async {
                              if (state is NewsLoaded) {
                                object = state.obj;
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
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
