import 'dart:io';

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/social/bloc/social_bloc.dart';

import 'package:Soc/src/modules/social/modal/item.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/action_interaction_button.dart';
import 'package:Soc/src/widgets/allCaughtUp_widget.dart';
import 'package:Soc/src/widgets/app_logo_widget.dart';
import 'package:Soc/src/widgets/common_feed_widget.dart';
import 'package:Soc/src/widgets/custom_icon_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/sliderpagewidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/cupertino.dart';
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
  bool? isErrorState = false;
  SocialBloc bloc = SocialBloc();
  bool? isCountLoading = true;
  final Globals globals = Globals();
  ScrollController _scrollController = ScrollController();

  List<Item> socialList = [];

  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    bloc.add(SocialPageEvent(action: "initial"));
    FirebaseAnalyticsService.addCustomAnalyticsEvent("social");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'social', screenClass: 'SocialPage');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    bloc.add(SocialPageEvent(action: "initial"));
    _homeBloc.add(FetchStandardNavigationBar());
  }

  _scrollListener() {
    //Used to fetch more records //pagination
    if (_scrollController.position.atEdge) {
      bloc.add(UpdateSocialList(list: socialList));
    }
  }

  Widget makeList(List<Item> obj, reLoad, {bool? isLoading}) {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount:
          obj.length + 1, //+1 to show loading indicator at end of the list
      padding: EdgeInsets.only(bottom: AppTheme.klistPadding),
      itemBuilder: (BuildContext context, int index) {
        return index == obj.length
            ? (isLoading == true
                ? Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Center(
                      child: Platform.isIOS
                          ? CupertinoActivityIndicator(
                              color: AppTheme.kButtonbackColor,
                            )
                          : Container(
                              margin: EdgeInsets.only(bottom: 15),
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                    ))
                : AllCaughtUpWidget(
                    title: 'All Notification Caught Up',
                    msg:
                        'You\'ve fetched all the available Social notification',
                    gradientColor: LinearGradient(colors: [
                      Theme.of(context).primaryColor,
                      AppTheme.kSelectedColor,
                    ]),
                  ))
            : _buildlist(obj[index], index, obj, reLoad);
        // return  _buildlist(obj[index], index, obj!, reLoad);
      },
    );
  }

  Widget _buildlist(Item obj, int index, mainObj, bool reLoad) {
    final document = obj.description != null && obj.description != ""
        ? parse(obj.description)
        : parse("");
    dom.Element? link = document.querySelector('img');
    String? imageLink = link != null ? link.attributes['src'] : '';

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: InkWell(
        onTap: () async {
          bool result = await await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SliderWidget(
                        // icons: Globals.icons,
                        obj: mainObj,
                        // iconsName: Globals.iconsName,
                        currentIndex: index,
                        isSocialPage: true,
                        isAboutSDPage: false,
                        isNewsPage: false,
                        // iseventpage: false,
                        date: '1',
                        isBottomSheet: true,
                        language: Globals.selectedLanguage,
                      )));
          if (result == true) {
            setState(() {});
          }
        },
        child: CommonFeedWidget(
          isSocial: true,
          title: '',
          description: obj.title! != null && obj.title!.length > 1
              ? "${obj.title!.toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("n.", " ").replaceAll("\nn", "\n").replaceAll('⁦', '').replaceAll('⁩', '')}"
              : '',
          actionIcon:
              Container(child: actionButton(mainObj, obj, index, reLoad)),
          url: (obj.mediaContent != null &&
                  obj.mediaContent != '' &&
                  obj.mediaContent != null &&
                  obj.mediaContent != "")
              ? obj.mediaContent
              : (imageLink != null && imageLink != "")
                  ? imageLink
                  : '',
          titleIcon: socialIconWidget(obj.link),
        ),
        //
      ),
    );
  }

  Widget actionButton(List<Item> list, obj, int index, bool reLoad) {
    // ignore: unnecessary_null_comparison
    return reLoad == false
        ? ActionInteractionButtonWidget(
            page: "social",
            obj: list[index],
            isLoading: false,
            title: list[index].title != "" && list[index].title != null
                ? list[index].title
                : "",
            description:
                list[index].description != "" && list[index].description != null
                    ? list[index].description
                    : "",
            imageUrl: list[index].mediaContent != "" &&
                    list[index].mediaContent != null
                ? list[index].mediaContent
                : "",
            imageExtType: list[index].mediaContent != "" &&
                    list[index].mediaContent != null
                ? list[index].mediaContent.toString().split(".").last
                : "",
          )
        : Container(
            alignment: Alignment.centerLeft,
            child: ShimmerLoading(
                isLoading: true,
                child: ActionInteractionButtonWidget(
                  title: list[index].title,
                  description: list[index].description,
                  imageUrl: list[index].mediaContent,
                  page: "social",
                  obj: list[index],
                  isLoading: true,
                )),
          );
  }

  Widget socialIconWidget(link) {
    if (link.contains('instagram')) {
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
    } else if (link.contains('twitter')) {
      return iconWidget(FontAwesomeIcons.twitter, Color(0xff1DA1F2));
    } else if (link.contains('facebook')) {
      return iconWidget(FontAwesomeIcons.facebook, Color(0xff4267B2));
    } else if (link.contains('youtube')) {
      return iconWidget(FontAwesomeIcons.youtube, Color(0xffFF0000));
    } else if (link.contains('pinterest')) {
      return iconWidget(FontAwesomeIcons.pinterest, Color(0xffFF0000));
    }

    return CustomIconWidget(
        darkModeIconUrl: null, iconUrl: Globals.appSetting.appLogoC);
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
          onTap: () {
            Utility.scrollToTop(scrollController: _scrollController);
          },
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
                  if (isErrorState == true) {
                    bloc.add(SocialPageEvent(action: "initial"));
                    isErrorState = false;
                  }
                } else if (connectivity == ConnectivityResult.none) {
                  isErrorState = true;
                }

                return
                    // connected ?
                    Column(
                  children: <Widget>[
                    BlocBuilder<SocialBloc, SocialState>(
                        bloc: bloc,
                        builder: (BuildContext context, SocialState state) {
                          if (state is SocialDataSuccess) {
                            // _countSocialBloc.add(FetchSocialActionCount());
                            socialList = [];
                            socialList.addAll(state.obj!);

                            return state.obj != null && state.obj!.length > 0
                                ? Expanded(
                                    child: makeList(state.obj!, false,
                                        isLoading: state.isLoading))
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
                                ? Expanded(child: makeList(state.obj!, true))
                                : Expanded(
                                    child: NoDataFoundErrorWidget(
                                      isResultNotFoundMsg: true,
                                      isNews: false,
                                      isEvents: false,
                                      connected: connected,
                                    ),
                                  );
                          }
                          //Commented due to double state found with same logic

                          // else if (state is SocialReload) {
                          //   socialList = [];
                          //   socialList.addAll(state.obj!);
                          //   return state.obj != null && state.obj!.length > 0
                          //       ? Expanded(
                          //           child: makeList(state.obj, false,
                          //               isLoading: state.isLoading))
                          //       : Expanded(
                          //           child: NoDataFoundErrorWidget(
                          //             isResultNotFoundMsg: true,
                          //             isNews: false,
                          //             isEvents: false,
                          //             connected: connected,
                          //           ),
                          //         );
                          // }
                          else if (state is Loading) {
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
