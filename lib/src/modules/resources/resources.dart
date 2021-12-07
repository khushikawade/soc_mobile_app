import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_Bar_widget.dart';
import 'package:Soc/src/modules/resources/bloc/resources_bloc.dart';
import 'package:Soc/src/modules/shared/ui/common_list_widget.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/banner_image_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Soc/src/globals.dart';
import 'package:flutter_offline/flutter_offline.dart';

class ResourcesPage extends StatefulWidget {
  // final obj;
  // final searchObj;
  // ResourcesPage({
  //   Key? key,
  //   this.obj,
  //   this.searchObj,
  // }) : super(key: key);

  @override
  _ResourcesPageState createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ResourcesBloc _bloc = ResourcesBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  HomeBloc _homeBloc = HomeBloc();
  bool? iserrorstate = false;

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
                                  return CommonListWidget(
                                      data: state.obj!,
                                      sectionName: "resources");
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
                                  Globals.homeObject = state.obj;
                                  setState(() {});
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
        body: Globals.homeObject["Resources_Banner_Image__c"] != null &&
                Globals.homeObject["Resources_Banner_Image__c"] != ""
            ? NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    BannerImageWidget(
                      imageUrl: Globals.homeObject["Resources_Banner_Image__c"],
                      bgColor: Globals
                                  .homeObject["Resources_Banner_Color__c"] !=
                              null
                          ? Utility.getColorFromHex(
                              Globals.homeObject["Resources_Banner_Color__c"])
                          : null,
                    )
                  ];
                },
                body: _body())
            : _body());
  }
}
