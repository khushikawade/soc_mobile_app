import 'package:Soc/src/modules/about/bloc/about_bloc.dart';
import 'package:Soc/src/modules/shared/ui/common_list_widget.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_Bar_widget.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/banner_image_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Soc/src/globals.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';

class AboutPage extends StatefulWidget {
  final obj;
  final searchObj;
  AboutPage({
    Key? key,
    this.obj,
    this.searchObj,
  }) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AboutBloc _bloc = AboutBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  HomeBloc _homeBloc = HomeBloc();
  bool? iserrorstate = false;
  List<String?> department = [];

  @override
  void initState() {
    super.initState();
    _bloc.add(AboutStaffDirectoryEvent());
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _bloc.add(AboutStaffDirectoryEvent());
    _homeBloc.add(FetchBottomNavigationBar());
  }

  // Widget _buildLeading(obj) {
  //   if (obj.appIconUrlC != null) {
  //     return CustomIconWidget(
  //       iconUrl: obj.appIconUrlC ?? Overrides.defaultIconUrl,
  //     );
  //   } else {
  //     return CustomIconWidget(
  //       iconUrl: Overrides.defaultIconUrl,
  //     );
  //   }
  // }

  // _aboutPageRoute(SharedList obj, List<SharedList> list, index) {
  //   if (obj.typeC == "URL") {
  //     obj.appUrlC != null
  //         ? _launchURL(obj)
  //         : Utility.showSnackBar(_scaffoldKey, "No link available", context);
  //   } else if (obj.typeC == "Staff_Directory") {
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (BuildContext context) => StaffDirectory(
  //                   staffDirectoryCategoryId: obj.id,
  //                   appBarTitle: obj.titleC!,
  //                   obj: list,
  //                   isbuttomsheet: true,
  //                   isAbout: true,
  //                   language: Globals.selectedLanguage,
  //                 )));
  //   } else if (obj.typeC == "RTF_HTML" ||
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
  //                   module: "about",
  //                   isbuttomsheet: true,
  //                   language: Globals.selectedLanguage,
  //                 )));
  //   } else {
  //     Utility.showSnackBar(_scaffoldKey, "No data available", context);
  //   }
  // }

  // _launchURL(SharedList obj) async {
  //   if (obj.appUrlC.toString().split(":")[0] == 'http') {
  //     await Utility.launchUrlOnExternalBrowser(obj.appUrlC!);
  //   } else {
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (BuildContext context) => InAppUrlLauncer(
  //                   title: obj.titleC!,
  //                   url: obj.appUrlC!,
  //                   isbuttomsheet: true,
  //                   language: Globals.selectedLanguage,
  //                 )));
  //   }
  // }

  // Widget _buildList(SharedList listData, List<SharedList> obj, int index) {
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
  //         _aboutPageRoute(listData, obj, index);
  //         // Navigator.push(
  //         //     context,
  //         //     MaterialPageRoute(
  //         //         builder: (context) =>
  //         //         StaffDirectory(
  //         //               appBarTitle: listData.titleC??"-",
  //         //               isbuttomsheet: true,
  //         //               language: Globals.selectedLanguage,
  //         //               obj: newList,
  //         //             )));
  //       },
  //       visualDensity: VisualDensity(horizontal: 0, vertical: 0),
  //       leading: _buildLeading(listData),
  //       title: TranslationWidget(
  //           message: listData.titleC ?? "-",
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

  Widget _body(String key) => RefreshIndicator(
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
                  _bloc.add(AboutStaffDirectoryEvent());
                  iserrorstate = false;
                }
              } else if (!connected) {
                iserrorstate = true;
              }

              return 
              // connected ? 
                  Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: BlocBuilder<AboutBloc, AboutState>(
                              bloc: _bloc,
                              builder: (BuildContext contxt, AboutState state) {
                                if (state is AboutInitial ||
                                    state is AboutLoading) {
                                  return Container(
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context).colorScheme.primaryVariant,
                                      ));
                                } else if (state is AboutDataSucess) {
                                  return CommonListWidget(
                                     key: ValueKey(key),
                                     scaffoldKey: _scaffoldKey,
                                      connected: connected,
                                      data: state.obj!, sectionName: 'about');
                                  // return newList.length > 0
                                  //     ? ListView.builder(
                                  //         padding: EdgeInsets.only(
                                  //             bottom: AppTheme.klistPadding),
                                  //         scrollDirection: Axis.vertical,
                                  //         itemCount: newList.length,
                                  //         itemBuilder: (BuildContext context,
                                  //             int index) {
                                  //           return _buildList(state.obj![index],
                                  //               state.obj!, index);
                                  //         },
                                  //       )
                                  //     : NoDataFoundErrorWidget(
                                  //         isResultNotFoundMsg: false,
                                  //         isNews: false,
                                  //         isEvents: false,
                                  //       );
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
                                      Globals.appSetting = AppSetting.fromJson(state.obj);
                                  // Globals.homeObject = state.obj;
                                  setState(() {});
                                }
                              },
                              child: EmptyContainer()),
                        ),
                        // BlocListener<AboutBloc, AboutState>(
                        //     bloc: _bloc,
                        //     listener: (context, state) async {
                        //       if (state is AboutDataSucess) {
                        //         newList.clear();
                        //         for (int i = 0; i < state.obj!.length; i++) {
                        //           if (state.obj![i].status != "Hide") {
                        //             newList.add(state.obj![i]);
                        //           }
                        //         }
                        //       }
                        //     },
                        //     child: EmptyContainer()),
                      ],
                    );
                  // : NoInternetErrorWidget(
                  //     connected: connected, issplashscreen: false);
            },
            child: Container()),
        onRefresh: refreshPage,
      );

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarWidget(
          marginLeft: 30,
          refresh: (v) {
            setState(() {});
          },
        ),
        body:  Globals.appSetting.aboutBannerImageC != null &&
               Globals.appSetting.aboutBannerImageC != ""
        // Globals.homeObject["About_Banner_Image__c"] != null &&
        //         Globals.homeObject["About_Banner_Image__c"] != ""
            ? NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    BannerImageWidget(
                      imageUrl: Globals.appSetting.aboutBannerImageC!,
                      // Globals.homeObject["About_Banner_Image__c"],
                      bgColor:
                        Globals.appSetting.aboutBannerColorC != null
                          // Globals.homeObject["About_Banner_Color__c"] != null
                              ? Utility.getColorFromHex(
                                  // Globals.homeObject["About_Banner_Color__c"]
                                  Globals.appSetting.aboutBannerColorC!
                                  )
                              : null,
                    )
                  ];
                },
                body: _body('body1'))
            : _body('body2'));
  }
}
