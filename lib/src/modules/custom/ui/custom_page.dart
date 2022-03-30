import 'package:Soc/src/modules/families/ui/contact.dart';
import 'package:Soc/src/modules/families/ui/event.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_Bar_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/modules/custom/ui/home_inapp_url_launcher.dart';
import 'package:Soc/src/modules/custom/ui/home_pdf_viewer_page.dart';
import 'package:Soc/src/widgets/html_description.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Soc/src/globals.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';

class CustomPages extends StatefulWidget {
  final obj;

  CustomPages({
    Key? key,
    this.obj,
  }) : super(key: key);

  @override
  _CustomPagesState createState() => _CustomPagesState();
}

class _CustomPagesState extends State<CustomPages> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final refreshKey = GlobalKey<RefreshIndicatorState>();
  HomeBloc _homeBloc = HomeBloc();
  bool? iserrorstate = false;

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _homeBloc.add(FetchStandardNavigationBar());
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
                    Container(
                      height: 0,
                      width: 0,
                      child: BlocListener<HomeBloc, HomeState>(
                          bloc: _homeBloc,
                          listener: (context, state) async {
                            if (state is BottomNavigationBarSuccess) {
                              AppTheme.setDynamicTheme(
                                  Globals.appSetting, context);
                              Globals.appSetting =
                                  AppSetting.fromJson(state.obj);
                              // setState(() {});
                            }
                          },
                          child: EmptyContainer()),
                    ),
                  ],
                );
              },
              child: Container()),
          onRefresh: refreshPage,
        ),
      );

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
    if (obj.typeOfPageC == "URL") {
      return obj.appUrlC != null && obj.appUrlC != ""
          ? (obj.appUrlC.toString().split(":")[0] == 'http'
              // || obj.deepLinkC == 'YES'
              ? Container() // TODO: Add a proper message when links are unable to open
              : HomeInAppUrlLauncher(
                  url: obj.appUrlC,
                  language: Globals.selectedLanguage,
                ))
          : Expanded(
              child: Container(
                  child: NoDataFoundErrorWidget(
                      isResultNotFoundMsg: false,
                      isNews: false,
                      isEvents: false,
                      connected: true)),
            );
    } else if (obj.typeOfPageC == "RTF_HTML" ||
        obj.typeOfSectionC == "RFT_HTML" ||
        obj.typeOfSectionC == "HTML/RTF" ||
        obj.typeOfSectionC == "RTF/HTML") {
      return obj.rtfHTMLC != null && obj.rtfHTMLC != ""
          ? Expanded(
              child: AboutusPage(
                htmlText: obj.rtfHTMLC.toString(),
                isbuttomsheet: true,
                ishtml: true,
                isAppBar: false,
                language: Globals.selectedLanguage,
                appbarTitle: '',
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
    } else if (obj.typeOfPageC == "Embed iFrame") {
      return obj.rtfHTMLC != null && obj.rtfHTMLC != ""
          ? Expanded(
              child: HomeInAppUrlLauncher(
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
    } else if (obj.typeOfPageC == "PDF URL" || obj.typeOfSectionC == "PDF") {
      return obj.pdfURL != null && obj.pdfURL != ""
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
    } else if (obj.typeOfPageC == "Contact") {
      return Expanded(
        child: ContactPage(
          obj: Globals.appSetting,
          isbuttomsheet: true,
          isAppBar: false,
          language: Globals.selectedLanguage ?? "English",
          appBarTitle: '',
        ),
      );
    } else if (obj.typeOfPageC == "Calendar/Events") {
      return obj.calendarId != null && obj.calendarId != ""
          ? Expanded(
              child: EventPage(
                appBarTitle: '',
                isAppBar: false,
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
}
