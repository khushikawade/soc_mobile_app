import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_Bar_widget.dart';
import 'package:Soc/src/modules/resources/bloc/resources_bloc.dart';
import 'package:Soc/src/modules/resources/modal/resources_list.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/common_pdf_viewer_page.dart';
import 'package:Soc/src/widgets/common_sublist.dart';
import 'package:Soc/src/widgets/custom_icon_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/html_description.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Soc/src/globals.dart';
import 'package:flutter_offline/flutter_offline.dart';

class ResourcesPage extends StatefulWidget {
  final obj;
  final searchObj;
  ResourcesPage({
    Key? key,
    this.obj,
    this.searchObj,
  }) : super(key: key);

  @override
  _ResourcesPageState createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ResourcesBloc _bloc = ResourcesBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  HomeBloc _homeBloc = HomeBloc();
  bool? iserrorstate = false;
  List<ResourcesList> newList = [];

  @override
  void initState() {
    super.initState();
    _bloc.add(ResourcesListEvent());
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _bloc.add(ResourcesListEvent());
    _homeBloc.add(FetchBottomNavigationBar());
  }

  Widget _buildLeading(obj) {
    if (obj.appIconURLC != null) {
      return CustomIconWidget(
        iconUrl: obj.appIconURLC ??
            "https://solved-consulting-images.s3.us-east-2.amazonaws.com/Miscellaneous/default_icon.png",
      );
    } else {
      return CustomIconWidget(
        iconUrl:
            "https://solved-consulting-images.s3.us-east-2.amazonaws.com/Miscellaneous/default_icon.png",
      );
    }
  }

  _resourceRoute(ResourcesList obj, index) {
    if (obj.typeC == "URL") {
      obj.urlC != null
          ? _launchURL(obj)
          : Utility.showSnackBar(_scaffoldKey, "No link available", context);
    } else if (obj.typeC == "RFT_HTML" ||
        obj.typeC == "HTML/RTF" ||
        obj.typeC == "RTF/HTML") {
      obj.rtfHTMLC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AboutusPage(
                        htmlText: obj.rtfHTMLC.toString(),
                        isbuttomsheet: true,
                        ishtml: true,
                        appbarTitle: obj.titleC!,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No data available", context);
    } else if (obj.typeC == "Embed iFrame") {
      obj.rtfHTMLC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => InAppUrlLauncer(
                        isiFrame: true,
                        title: obj.titleC!,
                        url: obj.rtfHTMLC.toString(),
                        isbuttomsheet: true,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No data available", context);
    } else if (obj.typeC == "PDF URL") {
      obj.pdfURL != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => CommonPdfViewerPage(
                        url: obj.pdfURL,
                        tittle: obj.titleC,
                        isbuttomsheet: true,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No pdf available", context);
    } else if (obj.typeC == "Sub-Menu") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SubListPage(
                    appBarTitle: obj.titleC!,
                    obj: obj,
                    module: "resources",
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                  )));
    } else {
      Utility.showSnackBar(_scaffoldKey, "No data available", context);
    }
  }

  _launchURL(obj) async {
    if (obj.urlC.toString().split(":")[0] == 'http') {
      await Utility.launchUrlOnExternalBrowser(obj.urlC);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => InAppUrlLauncer(
                    title: obj.titleC,
                    url: obj.urlC,
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                  )));
    }
  }

  Widget _buildList(ResourcesList obj, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.kDividerColor2,
          width: 0.65,
        ),
        borderRadius: BorderRadius.circular(0.0),
        color: (index % 2 == 0)
            ? Theme.of(context).colorScheme.background
            : Theme.of(context).colorScheme.secondary,
      ),
      child: ListTile(
        onTap: () {
          _resourceRoute(obj, index);
          //if (obj.urlC != null) _launchURL(obj);
        },
        visualDensity: VisualDensity(horizontal: 0, vertical: 0),
        leading: _buildLeading(obj),
        title: Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English" &&
                Globals.selectedLanguage != ""
            ? TranslationWidget(
                message: obj.titleC,
                fromLanguage: "en",
                toLanguage: Globals.selectedLanguage,
                builder: (translatedMessage) {
                  return Text(translatedMessage.toString(),
                      style: Theme.of(context).textTheme.bodyText2!);
                })
            : Text(obj.titleC.toString(),
                style: Theme.of(context).textTheme.bodyText1!),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: Globals.deviceType == "phone" ? 12 : 20,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

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
                  _bloc.add(ResourcesListEvent());
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
                          child: BlocBuilder<ResourcesBloc, ResourcesState>(
                              bloc: _bloc,
                              builder:
                                  (BuildContext contxt, ResourcesState state) {
                                if (state is ResourcesInitial ||
                                    state is ResourcesLoading) {
                                  return Container(
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator());
                                } else if (state is ResourcesDataSucess) {
                                  return newList.length > 0
                                      ? ListView.builder(
                                          padding: EdgeInsets.only(bottom: 45),
                                          scrollDirection: Axis.vertical,
                                          itemCount: newList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return _buildList(
                                                state.obj![index], index);
                                          },
                                        )
                                      : NoDataFoundErrorWidget(
                                          isResultNotFoundMsg: false,
                                          isNews: false,
                                          isEvents: false,
                                        );
                                } else if (state is ResourcesErrorLoading) {
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
                                  Globals.homeObjet = state.obj;
                                  setState(() {});
                                }
                              },
                              child: EmptyContainer()),
                        ),
                        BlocListener<ResourcesBloc, ResourcesState>(
                            bloc: _bloc,
                            listener: (context, state) async {
                              if (state is ResourcesDataSucess) {
                                newList.clear();
                                for (int i = 0; i < state.obj!.length; i++) {
                                  if (state.obj![i].statusc != "Hide") {
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

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarWidget(
          marginLeft: 30,
          refresh: (v) {
            setState(() {});
          },
        ),
        body: Globals.homeObjet["Resources_Banner_Image__c"] != null &&
                Globals.homeObjet["Resources_Banner_Image__c"] != ""
            ? NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: AppTheme.kBannerHeight,
                      floating: false,
                      // pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        background: Image.network(
                          Globals.homeObjet["Resources_Banner_Image__c"],
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  ];
                },
                body: _body())
            : _body());
  }
}