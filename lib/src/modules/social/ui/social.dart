import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/widgets/action_button_basic.dart';
import 'package:Soc/src/modules/social/bloc/social_bloc.dart';
import 'package:Soc/src/modules/social/modal/item.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/common_feed_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/sliderpagewidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  static const double _kSocialIconSize = 30.0;
  static const double _kIconSize = 48.0;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final HomeBloc _homeBloc = new HomeBloc();
  bool? iserrorstate = false;
  SocialBloc bloc = SocialBloc();
  bool? isCountLoading = true;
  SocialBloc _countSocialBloc = new SocialBloc();
  List socialMainList = [];
  // GlobalKey _imgkey = GlobalKey();

  void initState() {
    super.initState();
    bloc.add(SocialPageEvent());
    _countSocialBloc.add(FetchSocialActionCount());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    bloc.add(SocialPageEvent());
    _homeBloc.add(FetchBottomNavigationBar());
    _countSocialBloc.add(FetchSocialActionCount());
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
      // decoration: BoxDecoration(
      //   border: Border.all(

      //     color: AppTheme.kDividerColor2,
      //     width: 2,
      //   ),
      //   borderRadius: BorderRadius.circular(0.0),
        
           
      // ),
      color:  Theme.of(context).colorScheme.background,
      // height: MediaQuery.of(context).size.height * 0.4,
      // width: MediaQuery.of(context).size.width,
      // padding: EdgeInsets.symmetric(
      //   horizontal: _kLabelSpacing,
      //   vertical: _kLabelSpacing / 2,
      // ),
      // color: (index % 2 == 0)
      //     ? Theme.of(context).colorScheme.background
      //     : Theme.of(context).colorScheme.secondary,
      child: InkWell(
        onTap: () async {
          // print(index);
          // print(mainObj.length);
          bool result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SliderWidget(
                        // icons: Globals.icons,
                        obj: socialMainList.length > 0 &&
                                socialMainList[index] != null
                            ? socialMainList
                            : mainObj,
                        // iconsName: Globals.iconsName,
                        currentIndex: index,
                        issocialpage: true,
                        isAboutSDPage: false,
                        iseventpage: false,
                        date: '1',
                        isbuttomsheet: true,
                        language: Globals.selectedLanguage,
                      )));
          if (result == true) {
            _countSocialBloc.add(FetchSocialActionCount());
          }
        },
        child: CommonFeedWidget(
          title: obj.title!["__cdata"] != null &&
                  obj.title!["__cdata"].length > 1
              ? "${obj.title!["__cdata"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("n.", " ").replaceAll("\nn", "\n")}"
              : '',
          actionIcon: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.020),
              child: actionButton(mainObj, obj, index)),
          url: (obj.enclosure != null &&
                  obj.enclosure != '' &&
                  obj.enclosure['url'] != null &&
                  obj.enclosure['url'] != "")
              ? obj.enclosure['url']
              : (imageLink != null && imageLink != "")
                  ? imageLink
                  : Globals.splashImageUrl ??
                      // Globals.homeObject["App_Logo__c"],
                      Globals.appSetting.appLogoC,
          titleIcon: widgetIcon(obj.link),
        ),
        //
      ),
    );
  }
  // ListTile(
  //         contentPadding: EdgeInsets.only(left: 0),
  //         leading: Container(
  //             child: (CommonImageWidget(
  //           iconUrl: (obj.enclosure != null &&
  //                   obj.enclosure != '' &&
  //                   obj.enclosure['url'] != null &&
  //                   obj.enclosure['url'] != "")
  //               ? obj.enclosure['url']
  //               : (imageLink != null && imageLink != "")
  //                   ? imageLink
  //                   : Globals.splashImageUrl ??
  //                       // Globals.homeObject["App_Logo__c"],
  //                       Globals.appSetting.appLogoC,
  //           height: Globals.deviceType == "phone"
  //               ? _kIconSize * 1.4
  //               : _kIconSize * 2,
  //           width: Globals.deviceType == "phone"
  //               ? _kIconSize * 1.4
  //               : _kIconSize * 2,
  //           fitMethod: BoxFit.contain,
  //         ))),
  //         title: obj.title["__cdata"] != null && obj.title["__cdata"].length > 1
  //             ? Container(
  //                 height: MediaQuery.of(context).size.height * 0.02,
  //                 child: TranslationWidget(
  //                     message:
  //                         "${obj.title["__cdata"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("n.", " ").replaceAll("\nn", "\n")}",
  //                     fromLanguage: "en",
  //                     toLanguage: Globals.selectedLanguage,
  //                     builder: (translatedMessage) {
  //                       return marqueesText(translatedMessage.toString());
  //                     }))
  //             : Container(),
  //         subtitle: Container(
  //             padding: EdgeInsets.only(
  //                 top: MediaQuery.of(context).size.height * 0.020),
  //             child: actionButton(mainObj, obj, index)),
  //       ),

  // Widget _buildlist(obj, int index, mainObj) {
  //   final document = obj.description != null && obj.description != ""
  //       ? parse(obj.description["__cdata"])
  //       : parse("");
  //   dom.Element? link = document.querySelector('img');
  //   String? imageLink = link != null ? link.attributes['src'] : '';
  //   // print(index);
  //   // print(imageLink);

  //   return Container(
  //       padding: EdgeInsets.symmetric(
  //         horizontal: _kLabelSpacing,
  //         vertical: _kLabelSpacing / 2,
  //       ),
  //       color: (index % 2 == 0)
  //           ? Theme.of(context).colorScheme.background
  //           : Theme.of(context).colorScheme.secondary,
  //       child: InkWell(
  //           onTap: () async {
  //             // print(index);
  //             // print(mainObj.length);
  //             bool result = await Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) => SliderWidget(
  //                           // icons: Globals.icons,
  //                           obj: socialMainList.length > 0 &&
  //                                   socialMainList[index] != null
  //                               ? socialMainList
  //                               : mainObj,
  //                           // iconsName: Globals.iconsName,
  //                           currentIndex: index,
  //                           issocialpage: true,
  //                           isAboutSDPage: false,
  //                           iseventpage: false,
  //                           date: '1',
  //                           isbuttomsheet: true,
  //                           language: Globals.selectedLanguage,
  //                         )));
  //             if (result == true) {
  //               _countSocialBloc.add(FetchSocialActionCount());
  //             }
  //           },
  //           child: ListTile(
  //             contentPadding: EdgeInsets.only(left: 0),
  //             leading: Container(
  //                 child: (CommonImageWidget(
  //               iconUrl: (obj.enclosure != null &&
  //                       obj.enclosure != '' &&
  //                       obj.enclosure['url'] != null &&
  //                       obj.enclosure['url'] != "")
  //                   ? obj.enclosure['url']
  //                   : (imageLink != null && imageLink != "")
  //                       ? imageLink
  //                       : Globals.splashImageUrl ??
  //                           // Globals.homeObject["App_Logo__c"],
  //                           Globals.appSetting.appLogoC,
  //               height: Globals.deviceType == "phone"
  //                   ? _kIconSize * 1.4
  //                   : _kIconSize * 2,
  //               width: Globals.deviceType == "phone"
  //                   ? _kIconSize * 1.4
  //                   : _kIconSize * 2,
  //               fitMethod: BoxFit.contain,
  //             ))),
  //             title: obj.title["__cdata"] != null &&
  //                     obj.title["__cdata"].length > 1
  //                 ? Container(
  //                     height: MediaQuery.of(context).size.height * 0.02,
  //                     child: TranslationWidget(
  //                         message:
  //                             "${obj.title["__cdata"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("n.", " ").replaceAll("\nn", "\n")}",
  //                         fromLanguage: "en",
  //                         toLanguage: Globals.selectedLanguage,
  //                         builder: (translatedMessage) {
  //                           return marqueesText(translatedMessage.toString());
  //                         }))
  //                 : Container(),
  //             subtitle: Container(
  //                 padding: EdgeInsets.only(
  //                     top: MediaQuery.of(context).size.height * 0.020),
  //                 child: actionButton(mainObj, obj, index)),
  //           )));
  // }

  // marqueesText(String title) {
  //   return title.length < 45
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
                    _countSocialBloc.add(FetchSocialActionCount());
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
                                ? Expanded(child: makeList(state.obj))
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

  Widget actionButton(List<Item> list, obj, int index) {
    return BlocBuilder(
        bloc: _countSocialBloc,
        builder: (BuildContext context, SocialState state) {
          if (state is SocialActionCountSuccess) {
            socialMainList.clear();
            socialMainList.addAll(state.obj);
            isCountLoading = false;
            return Container(
              // alignment: Alignment.centerLeft,
              child: NewsActionBasic(
                  page: "social",
                  obj: state.obj[index],
                  isLoading: isCountLoading),
            );
          } else if (state is Loading) {
            return Container(
              alignment: Alignment.centerLeft,
              child: ShimmerLoading(
                  isLoading: true,
                  child: NewsActionBasic(
                      page: "social",
                      obj: Globals.socialList[index],
                      isLoading: isCountLoading)),
            );
          } else if (state is SocialErrorReceived) {
            return ListView(shrinkWrap: true, children: [ErrorMsgWidget()]);
          } else {
            return Container(
              alignment: Alignment.centerLeft,
              child: ShimmerLoading(
                  isLoading: true,
                  child: NewsActionBasic(
                      page: "social",
                      obj: Globals.socialList[index],
                      isLoading: isCountLoading)),
            );
          }
        });
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
            size: MediaQuery.of(context).size.width*0.07,
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
      size: MediaQuery.of(context).size.width*0.07,
    );
  }

  Widget iconWidget(icon, color) {
    return FaIcon(
      icon,
      size: MediaQuery.of(context).size.width*0.07,
      color: color,
    );
  }
}
