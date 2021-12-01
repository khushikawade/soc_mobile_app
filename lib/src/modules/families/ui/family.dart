import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_Bar_widget.dart';
import 'package:Soc/src/modules/shared/models/shared_list.dart';
import 'package:Soc/src/widgets/banner_image_widget.dart';
import 'package:Soc/src/modules/shared/ui/common_list_widget.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Soc/src/globals.dart';
import 'package:flutter_offline/flutter_offline.dart';

class FamilyPage extends StatefulWidget {
  final obj;
  final searchObj;
  FamilyPage({
    Key? key,
    this.obj,
    this.searchObj,
  }) : super(key: key);

  @override
  _FamilyPageState createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  // static const double _kLabelSpacing = 10.0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FamilyBloc _bloc = FamilyBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  HomeBloc _homeBloc = HomeBloc();
  bool? iserrorstate = false;
  List<SharedList> newList = [];
  // bool _atBottom = false;

  @override
  void initState() {
    super.initState();
    _bloc.add(FamiliesEvent());
    //   _scrollController.addListener(() {
    //     if (_scrollController.position.pixels < 50) {
    //       // You're at the top.
    //       setState(() {
    //          _atBottom = false;
    //       });
    //     } else {
    //        setState(() {
    //          _atBottom = true;
    //       });
    //     }
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _bloc.add(FamiliesEvent());
    _homeBloc.add(FetchBottomNavigationBar());
  }

  // _familiyPageRoute(FamiliesList obj, index) {
  //   if (obj.typeC == "Contact") {
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (BuildContext context) => ContactPage(
  //                   obj: widget.obj,
  //                   isbuttomsheet: true,
  //                   appBarTitle: obj.titleC!,
  //                   language: Globals.selectedLanguage ?? "English",
  //                 )));
  //   } else if (obj.typeC == "URL") {
  //     obj.appUrlC != null
  //         ? _launchURL(obj)
  //         : Utility.showSnackBar(_scaffoldKey, "No link available", context);
  //   } else if (obj.typeC == "Form") {
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (BuildContext context) => StaffDirectory(
  //                   staffDirectoryCategoryId: null,
  //                   isAbout: false,
  //                   appBarTitle: obj.titleC!,
  //                   obj: obj,
  //                   isbuttomsheet: true,
  //                   language: Globals.selectedLanguage,
  //                 )));
  //   } else if (obj.typeC == "Calendar/Events") {
  //     obj.calendarId != null && obj.calendarId != ""
  //         ? Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (BuildContext context) => EventPage(
  //                       isbuttomsheet: true,
  //                       appBarTitle: obj.titleC,
  //                       language: Globals.selectedLanguage,
  //                       // calendarId: obj.calendarId.toString(),
  //                     )))
  //         : Utility.showSnackBar(
  //             _scaffoldKey, "No calendar/events available", context);
  //   } else if (obj.typeC == "RFT_HTML" ||
  //       obj.typeC == "HTML/RTF" ||
  //       obj.typeC == "RTF/HTML") {
  //     obj.rtfHTMLC != null
  //         ? Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (BuildContext context) => AboutusPage(
  //                       htmlText: obj.rtfHTMLC.toString(),
  //                       isbuttomsheet: true,
  //                       ishtml: true,
  //                       appbarTitle: obj.titleC!,
  //                       language: Globals.selectedLanguage,
  //                     )))
  //         : Utility.showSnackBar(_scaffoldKey, "No data available", context);
  //   } else if (obj.typeC == "Embed iFrame") {
  //     obj.rtfHTMLC != null
  //         ? Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (BuildContext context) => InAppUrlLauncer(
  //                       isiFrame: true,
  //                       title: obj.titleC!,
  //                       url: obj.rtfHTMLC.toString(),
  //                       isbuttomsheet: true,
  //                       language: Globals.selectedLanguage,
  //                     )))
  //         : Utility.showSnackBar(_scaffoldKey, "No data available", context);
  //   } else if (obj.typeC == "PDF URL" || obj.typeC == "PDF") {
  //     obj.pdfURL != null
  //         ? Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (BuildContext context) => CommonPdfViewerPage(
  //                       url: obj.pdfURL,
  //                       tittle: obj.titleC,
  //                       isbuttomsheet: true,
  //                       language: Globals.selectedLanguage,
  //                     )))
  //         : Utility.showSnackBar(_scaffoldKey, "No pdf available", context);
  //   } else if (obj.typeC == "Sub-Menu") {
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (BuildContext context) => SubListPage(
  //                   appBarTitle: obj.titleC!,
  //                   obj: obj,
  //                   module: "family",
  //                   isbuttomsheet: true,
  //                   language: Globals.selectedLanguage,
  //                 )));
  //   } else {
  //     Utility.showSnackBar(_scaffoldKey, "No data available", context);
  //   }
  // }

  // Widget _buildLeading(FamiliesList obj) {
  //   if (obj.appIconUrlC != null) {
  //     return CustomIconWidget(
  //       iconUrl: obj.appIconUrlC ?? Overrides.defaultIconUrl,
  //     );
  //   } else if (obj.appIconC != null) {
  //     return Icon(
  //       IconData(
  //         int.parse('0x${obj.appIconC!}'),
  //         fontFamily: 'FontAwesomeSolid',
  //         fontPackage: 'font_awesome_flutter',
  //       ),
  //       color: Theme.of(context).colorScheme.primary,
  //       size: Globals.deviceType == "phone" ? 24 : 32,
  //     );
  //   } else {
  //     return CustomIconWidget(
  //       iconUrl: Overrides.defaultIconUrl,
  //     );
  //   }
  // }

  // _launchURL(obj) async {
  //   if (obj.appUrlC.toString().split(":")[0] == 'http') {
  //     // if (await canLaunch(obj.appUrlC)) {
  //     //   await launch(obj.appUrlC);
  //     // } else {
  //     //   throw 'Could not launch ${obj.appUrlC!}';
  //     // }
  //     await Utility.launchUrlOnExternalBrowser(obj.appUrlC);
  //   } else {
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (BuildContext context) => InAppUrlLauncer(
  //                   title: obj.titleC,
  //                   url: obj.appUrlC,
  //                   isbuttomsheet: true,
  //                   language: Globals.selectedLanguage,
  //                 )));
  //   }
  // }

  // Widget _buildList(FamiliesList obj, int index) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       border: Border.all(
  //         color: AppTheme.kDividerColor2,
  //         width: 0.65,
  //       ),
  //       borderRadius: BorderRadius.circular(0.0),
  //       color: (index % 2 == 0)
  //           ? Theme.of(context).colorScheme.background
  //           : Theme.of(context).colorScheme.secondary,
  //     ),
  //     child: ListTile(
  //       onTap: () {
  //         _familiyPageRoute(obj, index);
  //       },
  //       visualDensity: VisualDensity(horizontal: 0, vertical: 0),
  //       // contentPadding:
  //       //     EdgeInsets.only(left: _kLabelSpacing, right: _kLabelSpacing / 2),
  //       leading: _buildLeading(obj),
  //       title: TranslationWidget(
  //           message: obj.titleC ?? "No title",
  //           fromLanguage: "en",
  //           toLanguage: Globals.selectedLanguage,
  //           builder: (translatedMessage) {
  //             return Text(translatedMessage.toString(),
  //                 style: Theme.of(context).textTheme.bodyText1!);
  //           }),
  //       trailing: Icon(
  //         Icons.arrow_forward_ios_rounded,
  //         size: Globals.deviceType == "phone" ? 12 : 20,
  //         color: Theme.of(context).colorScheme.primary,
  //       ),
  //     ),
  //   );
  // }

  Widget _body() => RefreshIndicator(
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
                  _bloc.add(FamiliesEvent());
                  iserrorstate = false;
                }
              } else if (!connected) {
                iserrorstate = true;
              }

              return connected
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: BlocBuilder<FamilyBloc, FamilyState>(
                              bloc: _bloc,
                              builder:
                                  (BuildContext contxt, FamilyState state) {
                                if (state is FamilyInitial ||
                                    state is FamilyLoading) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (state is FamiliesDataSucess) {
                                  return CommonListWidget(
                                      data: newList, sectionName: "family");
                                  // return newList.length > 0
                                  //     ? ListView.builder(
                                  //         padding: EdgeInsets.only(
                                  //             bottom: AppTheme.klistPadding),
                                  //         scrollDirection: Axis.vertical,
                                  //         itemCount: newList.length,
                                  //         itemBuilder: (BuildContext context,
                                  //             int index) {
                                  //           return _buildList(
                                  //               newList[index], index);
                                  //         },
                                  //       )
                                  //     :
                                  //     // ListView(children: [
                                  //     NoDataFoundErrorWidget(
                                  //         isResultNotFoundMsg: false,
                                  //         isNews: false,
                                  //         isEvents: false,
                                  //       );

                                  // ]);
                                } else if (state is ErrorLoading) {
                                  return ListView(children: [ErrorMsgWidget()]);
                                } else {
                                  return Container();
                                }
                              }),
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
                                }
                              },
                              child: EmptyContainer()),
                        ),
                        BlocListener<FamilyBloc, FamilyState>(
                            bloc: _bloc,
                            listener: (context, state) async {
                              if (state is FamiliesDataSucess) {
                                newList.clear();
                                for (int i = 0; i < state.obj!.length; i++) {
                                  if (state.obj![i].status != "Hide") {
                                    newList.add(state.obj![i]);
                                  }
                                }
                              }
                            },
                            child: EmptyContainer()),
                      ],
                    )
                  : NoInternetErrorWidget(
                      connected: connected, issplashscreen: false);
            },
            child: Container()),
        onRefresh: refreshPage,
      );

  // var _scrollController = ScrollController();

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarWidget(
          marginLeft: 30,
          refresh: (v) {
            setState(() {});
          },
        ),
        body: Globals.homeObject["Family_Banner_Image__c"] != null &&
                Globals.homeObject["Family_Banner_Image__c"] != ''
            ? NestedScrollView(
                // controller: _scrollController,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    Globals.homeObject["Family_Banner_Image__c"] != null
                        ? BannerImageWidget(
                            imageUrl:
                                Globals.homeObject["Family_Banner_Image__c"],
                            bgColor:
                                Globals.homeObject["Family_Banner_Color__c"] !=
                                        null
                                    ? Utility.getColorFromHex(Globals
                                        .homeObject["Family_Banner_Color__c"])
                                    : null,
                          )
                        : SliverAppBar(),
                  ];
                },
                body: _body())
            : _body());
  }
}
