import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/resources/bloc/resources_bloc.dart';
import 'package:Soc/src/modules/shared/ui/common_list_widget.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/banner_image_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Soc/src/globals.dart';
import 'package:flutter_offline/flutter_offline.dart';

import '../custom/model/custom_setting.dart';
import '../home/ui/app_bar_widget.dart';
import '../shared/ui/common_grid_widget.dart';

class ResourcesPage extends StatefulWidget {
  final CustomSetting? customObj;
  final bool? isCustomSection;
  ResourcesPage({Key? key, this.customObj, required this.isCustomSection})
      : super(key: key);

  @override
  _ResourcesPageState createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ResourcesBloc _bloc = ResourcesBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  HomeBloc _homeBloc = HomeBloc();
  bool? isErrorState = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // Utility.setLocked();
    super.initState();
    _bloc.add(ResourcesListEvent());

    FirebaseAnalyticsService.addCustomAnalyticsEvent("resources_page");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'resources_page', screenClass: 'ResourcesPage');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    _bloc.add(ResourcesListEvent());
    _homeBloc.add(FetchStandardNavigationBar());
  }

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
                if (isErrorState == true) {
                  _bloc.add(ResourcesListEvent());
                  isErrorState = false;
                }
              } else if (!connected) {
                isErrorState = true;
              }

              return
                  // connected ?
                  ListView(
                // mainAxisSize: MainAxisSize.max,
                children: [
                  BlocBuilder<ResourcesBloc, ResourcesState>(
                      bloc: _bloc,
                      builder: (BuildContext contxt, ResourcesState state) {
                        if (state is ResourcesInitial ||
                            state is ResourcesLoading) {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryVariant,
                              ));
                        } else if (state is ResourcesDataSuccess) {
                          return widget.customObj != null &&
                                  widget.customObj!.sectionTemplate ==
                                      "Grid Menu"
                              ? CommonGridWidget(
                                  scrollController: _scrollController,
                                  scaffoldKey: _scaffoldKey,
                                  connected: connected,
                                  data: state.obj!,
                                  sectionName: "resources")
                              : CommonListWidget(
                                  scrollController: _scrollController,
                                  key: ValueKey(key),
                                  scaffoldKey: _scaffoldKey,
                                  data: state.obj!,
                                  connected: connected,
                                  sectionName: "resources");
                        } else if (state is ResourcesErrorLoading) {
                          return ListView(children: [ErrorMsgWidget()]);
                        } else {
                          return Container();
                        }
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

                            Globals.appSetting = AppSetting.fromJson(state.obj);
                            setState(() {});
                          }
                        },
                        child: EmptyContainer()),
                  ),
                ],
              );
            },
            child: Container()),
        onRefresh: refreshPage,
      );

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarWidget(
          onTap: () {
            Utility.scrollToTop(scrollController: _scrollController);
          },
          marginLeft: 30,
          refresh: (v) {
            setState(() {});
          },
        ),
        body: Globals.appSetting.resourcesBannerImageC != null &&
                Globals.appSetting.resourcesBannerImageC != ""
            ? NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    BannerImageWidget(
                        imageUrl: Globals.appSetting.resourcesBannerImageC!,
                        bgColor:
                            Globals.appSetting.resourcesBannerColorC != null
                                ? Utility.getColorFromHex(
                                    Globals.appSetting.resourcesBannerColorC!)
                                : Colors.transparent)
                  ];
                },
                body: _body('body1'))
            : _body('body2'));
  }
}
