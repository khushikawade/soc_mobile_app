import 'package:Soc/src/modules/custom/ui/home_calendar.dart';
import 'package:Soc/src/modules/custom/ui/home_contect.dart';
import 'package:Soc/src/modules/families/ui/contact.dart';
import 'package:Soc/src/modules/families/ui/event.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_Bar_widget.dart';
import 'package:Soc/src/widgets/common_pdf_viewer_page.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/modules/custom/ui/home_html.dart';
import 'package:Soc/src/modules/custom/ui/home_inapp_url_launcher.dart';
import 'package:Soc/src/modules/custom/ui/home_pdf_viewer_pagr.dart';
import 'package:Soc/src/widgets/html_description.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Soc/src/globals.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';

class CustomUrlPage extends StatefulWidget {
  final obj;

  CustomUrlPage({
    Key? key,
    this.obj,
  }) : super(key: key);

  @override
  _CustomUrlPageState createState() => _CustomUrlPageState();
}

class _CustomUrlPageState extends State<CustomUrlPage> {
  // static const double _kLabelSpacing = 10.0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final refreshKey = GlobalKey<RefreshIndicatorState>();
  HomeBloc _homeBloc = HomeBloc();
  bool? iserrorstate = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);

    _homeBloc.add(FetchBottomNavigationBar());
  }

  Widget _body(String key) => Container(
        child: RefreshIndicator(
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
                    iserrorstate = false;
                  }
                } else if (!connected) {
                  iserrorstate = true;
                }

                return
                    // connected?
                    Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    buildPage(widget.obj),
                    // Expanded(
                    //   child: BlocBuilder<FamilyBloc, FamilyState>(
                    //       bloc: _bloc,
                    //       builder: (BuildContext contxt, FamilyState state) {
                    //         if (state is FamilyInitial ||
                    //             state is FamilyLoading) {
                    //           return Center(child: CircularProgressIndicator());
                    //         } else if (state is FamiliesDataSucess) {
                    //           // print('List data......');
                    //           // print(state.obj);
                    //           return buildPage(state.obj);
                    //         } else if (state is ErrorLoading) {
                    //           return ListView(children: [ErrorMsgWidget()]);
                    //         } else {
                    //           return Container();
                    //         }
                    //       }),
                    // ),
                    // Container(
                    //   height: 0,
                    //   width: 0,
                    //   child: BlocListener<FamilyBloc, FamilyState>(
                    //       bloc: _bloc,
                    //       listener: (context, state) async {
                    //         if (state is FamiliesDataSucess) {
                    //         //  if (state.obj.appUrlC.toString().split(":")[0] == 'http' || state.obj.deepLinkC == 'YES'){
                    //         //    await Utility.launchUrlOnExternalBrowser(state.obj.appUrlC);
                    //         //  }
                    //         }
                    //       },
                    //       child: EmptyContainer()),
                    // ),
                    Container(
                      height: 0,
                      width: 0,
                      child: BlocListener<HomeBloc, HomeState>(
                          bloc: _homeBloc,
                          listener: (context, state) async {
                            if (state is BottomNavigationBarSuccess) {
                              AppTheme.setDynamicTheme(
                                  Globals.appSetting, context);
                              // Globals.homeObject = state.obj;
                              Globals.appSetting =
                                  AppSetting.fromJson(state.obj);

                              setState(() {});
                            }
                          },
                          child: EmptyContainer()),
                    ),
                  ],
                );
                // : NoInternetErrorWidget(
                //     connected: connected, issplashscreen: false);
              },
              child: Container()),
          onRefresh: refreshPage,
        ),
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
        body: _body('body1'));
  }

  Widget buildPage(obj) {
    if (obj.typeOfSectionC == "URL") {
      return obj.appUrlC != null && obj.appUrlC != ""
          ? (obj.appUrlC.toString().split(":")[0] == 'http'
              // || obj.deepLinkC == 'YES'
              ? Container()
              : HomeInAppUrlLauncer(
                  url: obj.appUrlC,
                  language: Globals.selectedLanguage,
                ))
          : Container(
              child: NoDataFoundErrorWidget(
                  isResultNotFoundMsg: false,
                  isNews: false,
                  isEvents: false,
                  connected: true));
    } else if (obj.typeOfSectionC == "RTF_HTML" ||
        obj.typeOfSectionC == "RFT_HTML" ||
        obj.typeOfSectionC == "HTML/RTF" ||
        obj.typeOfSectionC == "RTF/HTML") {
      return obj.rtfHTMLC != null
          ? HomeHtml(
              htmlText: obj.rtfHTMLC.toString(),
              isbuttomsheet: true,
              ishtml: true,
              // appbarTitle: obj.titleC!,
              language: Globals.selectedLanguage,
            )
          : Expanded(
              child: Container(
                  child: NoDataFoundErrorWidget(
                      isResultNotFoundMsg: false,
                      isNews: false,
                      isEvents: false,
                      connected: true)),
            );
    } else if (obj.typeOfSectionC == "Embed iFrame") {
      return obj.rtfHTMLC != null
          ? Expanded(
              child: HomeInAppUrlLauncer(
                isiFrame: true,
                url: obj.rtfHTMLC.toString(),
                language: Globals.selectedLanguage,
              ),
            )
          : Expanded(
              child: Container(
                  child: NoDataFoundErrorWidget(
                      isResultNotFoundMsg: false,
                      isNews: false,
                      isEvents: false,
                      connected: true)),
            );
    } else if (obj.typeOfSectionC == "PDF URL" || obj.typeOfSectionC == "PDF") {
      return obj.pdfURL != null
          ? Expanded(
              child: HomePdfViewerPage(
                url: obj.pdfURL,
                isbuttomsheet: true,
                language: Globals.selectedLanguage,
              ),
            )
          : Expanded(
              child: Container(
                  child: NoDataFoundErrorWidget(
                      isResultNotFoundMsg: false,
                      isNews: false,
                      isEvents: false,
                      connected: true)),
            );
    } else if (obj.typeOfSectionC == "Contact") {
      return Expanded(
        child: HomeContactPage(
          obj: Globals.appSetting,
          //  Globals.homeObject,
          isbuttomsheet: true,

          language: Globals.selectedLanguage ?? "English",
        ),
      );
    } else if (obj.typeOfSectionC == "Calendar/Events") {
      return obj.calendarId != null && obj.calendarId != ""
          ? Expanded(
              child: HomeCalendar(
                isbuttomsheet: true,
                language: Globals.selectedLanguage,
                calendarId: obj.calendarId.toString(),
              ),
            )
          : Expanded(
              child: Container(
                  child: NoDataFoundErrorWidget(
                      isResultNotFoundMsg: false,
                      isNews: false,
                      isEvents: false,
                      connected: true)),
            );
    }
    return Expanded(
      child: Container(
          child: NoDataFoundErrorWidget(
              isResultNotFoundMsg: false,
              isNews: false,
              isEvents: false,
              connected: true)),
    );
  }

  // Widget _launchURL(obj) async {
  //   if (obj.appUrlC.toString().split(":")[0] == 'http' ||
  //       obj.deepLinkC == 'YES') {
  //     await Utility.launchUrlOnExternalBrowser(obj.appUrlC);
  //     return Container(
  //         child: NoDataFoundErrorWidget(
  //             isResultNotFoundMsg: false,
  //             isNews: false,
  //             isEvents: false,
  //             connected: true));
  //   } else {}
  // }
}
