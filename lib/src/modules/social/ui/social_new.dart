import 'dart:convert';

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/social/bloc/social_bloc.dart';
import 'package:Soc/src/modules/social/modal/item.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/action_button_basic.dart';
import 'package:Soc/src/widgets/common_feed_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/sliderpagewidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;
import '../../home/ui/app_bar_widget.dart';

class SocialNewPage extends StatefulWidget {
  SocialNewPage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  State<SocialNewPage> createState() => _SocialNewPageState();
}

class _SocialNewPageState extends State<SocialNewPage> {
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final HomeBloc _homeBloc = new HomeBloc();
  bool? iserrorstate = false;
  SocialBloc bloc = SocialBloc();
  bool? isCountLoading = true;

  void initState() {
    super.initState();
    bloc.add(SocialPageEvent(action: "initial"));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    bloc.add(SocialPageEvent(action: "initial"));
    _homeBloc.add(FetchStandardNavigationBar());
  }

  Widget makeList(obj, reLoad) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: obj.length,
      padding: EdgeInsets.only(bottom: AppTheme.klistPadding),
      itemBuilder: (BuildContext context, int index) {
        return _buildlist(obj[index], index, obj!, reLoad);
      },
    );
  }

  Widget _buildlist(Item obj, int index, mainObj, bool reLoad) {
    final document = obj.description != null && obj.description != ""
        ? parse(obj.description["__cdata"])
        : parse("");
    dom.Element? link = document.querySelector('img');
    String? imageLink = link != null ? link.attributes['src'] : '';

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: InkWell(
        onTap: () async {
          bool result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SliderWidget(
                        // icons: Globals.icons,
                        obj: mainObj,
                        // iconsName: Globals.iconsName,
                        currentIndex: index,
                        issocialpage: true,
                        isAboutSDPage: false,
                        isNewsPage: false,
                        // iseventpage: false,
                        date: '1',
                        isbuttomsheet: true,
                        language: Globals.selectedLanguage,
                      )));
          if (result == true) {
            bloc.add(SocialPageEvent(action: "returnBack"));
          }
        },
        child: CommonFeedWidget(
          isSocial: true,
          title: '',
          description: obj.title!["__cdata"] != null &&
                  obj.title!["__cdata"].length > 1
              ? "${obj.title!["__cdata"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("n.", " ").replaceAll("\nn", "\n").replaceAll('⁦', '').replaceAll('⁩', '')}"
              : '',
          actionIcon: Container(
              // padding: EdgeInsets.only(
              //     top: MediaQuery.of(context).size.height * 0.030),
              child: actionButton(mainObj, obj, index, reLoad)),
          url: (obj.enclosure != null &&
                  obj.enclosure != '' &&
                  obj.enclosure['url'] != null &&
                  obj.enclosure['url'] != "")
              ? obj.enclosure['url']
              : (imageLink != null && imageLink != "")
                  ? imageLink
                  : '',
          // Globals.splashImageUrl ??
          //     // Globals.homeObject["App_Logo__c"],
          //     Globals.appSetting.appLogoC,
          titleIcon: widgetIcon(obj.link),
        ),
        //
      ),
    );
  }

  Widget actionButton(List<Item> list, obj, int index, bool reLoad) {
    // ignore: unnecessary_null_comparison
    return reLoad == false
        ? UserActionBasic(
            page: "social",
            obj: list[index],
            isLoading: false,
            title: list[index].title != "" && list[index].title != null
                ? list[index].title['__cdata']
                : "",
            description:
                list[index].description != "" && list[index].description != null
                    ? list[index].description['__cdata']
                    : "",
            imageUrl:
                list[index].enclosure != "" && list[index].enclosure != null
                    ? list[index].enclosure['url']
                    : "",
            imageExtType: list[index].enclosure != ""
                ? list[index].enclosure['type']
                : "",
          )
        : Container(
            alignment: Alignment.centerLeft,
            child: ShimmerLoading(
                isLoading: true,
                child: UserActionBasic(
                  title: list[index].title['__cdata'],
                  description: list[index].description['__cdata'],
                  imageUrl: list[index].enclosure,
                  page: "social",
                  obj: list[index],
                  isLoading: true,
                )),
          );
  }

  Widget widgetIcon(link) {
    if (link["\$t"].contains('instagram')) {
      return ShaderMask(
          shaderCallback: (bounds) => RadialGradient(
                center: Alignment.topRight,
                transform: GradientRotation(50),
                radius: 5,
                colors: [
                  Colors.deepPurpleAccent,
                  Colors.red,
                  Colors.yellow,
                  Color(0xffee2a7b),
                  Colors.red,
                ],
              ).createShader(bounds),
          child: FaIcon(
            FontAwesomeIcons.instagram,
            size: MediaQuery.of(context).size.width * 0.07,
            color: Colors.white,
          ));
    } else if (link["\$t"].contains('twitter')) {
      return iconWidget(FontAwesomeIcons.twitter, Color(0xff1DA1F2));
    } else if (link["\$t"].contains('facebook')) {
      return iconWidget(FontAwesomeIcons.facebook, Color(0xff4267B2));
    } else if (link["\$t"].contains('youtube')) {
      return iconWidget(FontAwesomeIcons.youtube, Color(0xffFF0000));
    }

    return Icon(
      Icons.ac_unit,
      size: MediaQuery.of(context).size.width * 0.07,
    );
  }

  Widget iconWidget(icon, color) {
    return FaIcon(
      icon,
      size: MediaQuery.of(context).size.width * 0.07,
      color: color,
    );
  }

  @override
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
                    bloc.add(SocialPageEvent(action: "inital"));
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
                            // _countSocialBloc.add(FetchSocialActionCount());
                            return state.obj != null && state.obj!.length > 0
                                ? Expanded(child: makeList(state.obj, false))
                                : Expanded(
                                    child: NoDataFoundErrorWidget(
                                      isResultNotFoundMsg: true,
                                      isNews: false,
                                      isEvents: false,
                                      connected: connected,
                                    ),
                                  );
                          } else if (state is SocialInitialState) {
                            return state.obj != null && state.obj!.length > 0
                                ? Expanded(child: makeList(state.obj, true))
                                : Expanded(
                                    child: NoDataFoundErrorWidget(
                                      isResultNotFoundMsg: true,
                                      isNews: false,
                                      isEvents: false,
                                      connected: connected,
                                    ),
                                  );
                          } else if (state is SocialReload) {
                            return state.obj != null && state.obj!.length > 0
                                ? Expanded(child: makeList(state.obj, true))
                                : Expanded(
                                    child: NoDataFoundErrorWidget(
                                      isResultNotFoundMsg: true,
                                      isNews: false,
                                      isEvents: false,
                                      connected: connected,
                                    ),
                                  );
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
                              // Globals.homeObject = state.obj;
                              Globals.appSetting =
                                  AppSetting.fromJson(state.obj);
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
