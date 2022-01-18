import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/news/model/notification_list.dart';
import 'package:Soc/src/modules/news/ui/news_action_basic.dart';
import 'package:Soc/src/modules/social/bloc/social_bloc.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/common_image_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/sliderpagewidget.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

class SocialPage extends StatefulWidget {
  SocialPage({
    Key? key,
    this.title,
  }) : super(key: key);
  final String? title;

  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  static const double _kLabelSpacing = 16.0;
  static const double _kIconSize = 48.0;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final HomeBloc _homeBloc = new HomeBloc();
  bool? iserrorstate = false;
  SocialBloc bloc = SocialBloc();
  List newsMainList = [];
  bool? isCountLoading = true;
  NewsBloc _countBloc = new NewsBloc();
  NewsBloc _newsBloc = new NewsBloc();
  List icons = [0xe823, 0xe824, 0xe825, 0xe829];
  List iconsName = ["Like", "Thanks", "Helpful", "Share"];
  // GlobalKey _imgkey = GlobalKey();

  void initState() {
    super.initState();
    bloc.add(SocialPageEvent());
    _newsBloc.add(FetchNotificationList());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    bloc.add(SocialPageEvent());
    _homeBloc.add(FetchBottomNavigationBar());
  }

  Widget _buildlist(obj, int index, mainObj) {
    final document = obj.description != null && obj.description != ""
        ? parse(obj.description["__cdata"])
        : parse("");
    dom.Element? link = document.querySelector('img');
    String? imageLink = link != null ? link.attributes['src'] : '';
    // print(index);
    // print(imageLink);

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
              // print(index);
              // print(mainObj.length);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SliderWidget(
                            obj: mainObj,
                            iconsName: [],
                            currentIndex: index,
                            issocialpage: true,
                            isAboutSDPage: false,
                            iseventpage: false,
                            date: '1',
                            isbuttomsheet: true,
                            language: Globals.selectedLanguage,
                          )));
            },
            child: ListTile(
                contentPadding: EdgeInsets.only(left: 0),
                leading: Container(
                    child: (CommonImageWidget(
                  iconUrl: (obj.enclosure != null &&
                          obj.enclosure != '' &&
                          obj.enclosure['url'] != null &&
                          obj.enclosure['url'] != "")
                      ? obj.enclosure['url']
                      : (imageLink != null && imageLink != "")
                          ? imageLink
                          : Globals.splashImageUrl ??
                              Globals.homeObject["App_Logo__c"],
                  height: Globals.deviceType == "phone"
                      ? _kIconSize * 1.4
                      : _kIconSize * 2,
                  width: Globals.deviceType == "phone"
                      ? _kIconSize * 1.4
                      : _kIconSize * 2,
                  fitMethod: BoxFit.cover,
                ))),
                title: obj.title["__cdata"] != null &&
                        obj.title["__cdata"].length > 1
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.69,
                        child: TranslationWidget(
                            message:
                                "${obj.title["__cdata"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("n.", " ").replaceAll("\nn", "\n")}",
                            fromLanguage: "en",
                            toLanguage: Globals.selectedLanguage,
                            builder: (translatedMessage) {
                              return Text(translatedMessage.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryVariant,
                                      ));
                            }),
                      )
                    : Container(),
                subtitle: BlocListener<NewsBloc, NewsState>(
                    bloc: _newsBloc,
                    listener: (context, state) async {
                      if (state is NewsLoaded) {
                        isCountLoading = false;
                        newsMainList.clear();
                        // if (state.obj!.length == 0) {
                        newsMainList.addAll(state.obj!);
                        // setState(() {});
                        // } else {
                        for (int i = 0; i < state.obj!.length; i++) {
                          //   for (int j = 0; j < state.obj!.length; j++) {
                          //     if ("${list[i].id}${Overrides.SCHOOL_ID}" ==
                          //         state.obj[j].notificationId) {
                          newsMainList.add(NotificationList(
                              id: state.obj![0].id,
                              contents: state.obj![0].contents, //obj.contents,
                              headings: state.obj![0].headings, //obj.headings,
                              image: state.obj![0].image, //obj.image,
                              url: state.obj![0].url, //obj.url,
                              likeCount: 0, //state.obj[j].likeCount,
                              thanksCount: 0, //state.obj[j].thanksCount,
                              helpfulCount: 0, //state.obj[j].helpfulCount,
                              shareCount: 0)); //state.obj[j].shareCount));
                          setState(() {});
                        }
                      }
                    },
                    // }
                    child: Container(
                      padding: EdgeInsets.only(top: 16),
                      child: NewsActionBasic(
                          newsObj: newsMainList[index],
                          icons: icons,
                          iconsName: iconsName,
                          isLoading: isCountLoading),
                    )))));
  }

  Widget makeList(obj) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: obj.length,
      padding: EdgeInsets.only(bottom: AppTheme.klistPadding),
      itemBuilder: (BuildContext context, int index) {
        return _buildlist(obj[index], index, obj!);
      },
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

                if (connectivity != ConnectivityResult.none) {
                  if (iserrorstate == true) {
                    bloc.add(SocialPageEvent());
                    iserrorstate = false;
                  }
                } else if (connectivity == ConnectivityResult.none) {
                  iserrorstate = true;
                }

                return
                    // connected ?
                    Column(
                  children: <Widget>[
                    BlocBuilder<SocialBloc, SocialState>(
                        bloc: bloc,
                        builder: (BuildContext context, SocialState state) {
                          if (state is SocialDataSucess) {
                            return state.obj != null && state.obj!.length > 0
                                ? Expanded(child: makeList(state.obj))
                                : Expanded(
                                    child: NoDataFoundErrorWidget(
                                      isResultNotFoundMsg: true,
                                      isNews: false,
                                      isEvents: false,
                                      connected: connected,
                                    ),
                                  );
                            // Expanded(
                            //     child: ListView(
                            //       shrinkWrap: true,
                            //       children: [
                            //       NoDataFoundErrorWidget(
                            //         isResultNotFoundMsg: true,
                            //         isNews: false,
                            //         isEvents: false,
                            //       )
                            //     ]),
                            //   );
                          } else if (state is Loading) {
                            return Expanded(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ),
                            );
                          } else if (state is SocialError) {
                            return ListView(
                                shrinkWrap: true, children: [ErrorMsgWidget()]);
                          }
                          return Container();
                        }),
                    Container(
                      height: 0,
                      width: 0,
                      child: BlocListener<HomeBloc, HomeState>(
                        bloc: _homeBloc,
                        listener: (context, state) async {
                          if (state is BottomNavigationBarSuccess) {
                            AppTheme.setDynamicTheme(
                                Globals.appSetting, context);

                            setState(() {
                              Globals.homeObject = state.obj;
                            });
                          }
                        },
                        child: Container(
                          height: 0,
                          width: 0,
                        ),
                      ),
                    ),
                  ],
                );
                // : NoInternetErrorWidget(
                //     connected: connected, issplashscreen: false);
              },
              child: Container()),
          onRefresh: refreshPage,
        ));
  }
}
