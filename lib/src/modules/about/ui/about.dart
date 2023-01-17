import 'package:Soc/src/modules/about/bloc/about_bloc.dart';
import 'package:Soc/src/modules/custom/model/custom_setting.dart';
import 'package:Soc/src/modules/shared/ui/common_list_widget.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
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
import 'package:Soc/src/modules/home/models/app_setting.dart';
import '../../home/ui/app_bar_widget.dart';
import '../../shared/ui/common_grid_widget.dart';

class AboutPage extends StatefulWidget {
  final CustomSetting? customObj;
  final bool? isCustomSection;
  final searchObj;
  AboutPage(
      {Key? key, this.customObj, this.searchObj, required this.isCustomSection})
      : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AboutBloc _bloc = AboutBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  HomeBloc _homeBloc = HomeBloc();
  bool? isErrorState = false;
  List<String?> department = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc.add(AboutStaffDirectoryEvent());

    FirebaseAnalyticsService.addCustomAnalyticsEvent("about_page");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'about_page', screenClass: 'AboutPage');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    _bloc.add(AboutStaffDirectoryEvent());
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
                  _bloc.add(AboutStaffDirectoryEvent());
                  isErrorState = false;
                }
              } else if (!connected) {
                isErrorState = true;
              }

              return ListView(
                //  mainAxisSize: MainAxisSize.max,
                children: [
                  BlocBuilder<AboutBloc, AboutState>(
                      bloc: _bloc,
                      builder: (BuildContext contxt, AboutState state) {
                        if (state is AboutInitial || state is AboutLoading) {
                          return Container(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryVariant,
                              ));
                        } else if (state is AboutDataSuccess) {
                          return widget.customObj != null &&
                                  widget.customObj!.sectionTemplate ==
                                      "Grid Menu"
                              ? CommonGridWidget(
                                  scrollController: _scrollController,
                                  scaffoldKey: _scaffoldKey,
                                  connected: connected,
                                  data: state.obj!,
                                  sectionName: "about")
                              : CommonListWidget(
                                  scrollController: _scrollController,
                                  key: ValueKey(key),
                                  scaffoldKey: _scaffoldKey,
                                  connected: connected,
                                  data: state.obj!,
                                  sectionName: 'about');
                        } else if (state is ErrorLoading) {
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
        body: Globals.appSetting.aboutBannerImageC != null &&
                Globals.appSetting.aboutBannerImageC != ""
            ? NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    BannerImageWidget(
                        imageUrl: Globals.appSetting.aboutBannerImageC!,
                        bgColor: Globals.appSetting.aboutBannerColorC != null
                            ? Utility.getColorFromHex(
                                Globals.appSetting.aboutBannerColorC!)
                            : Colors.transparent)
                  ];
                },
                body: _body('body1'))
            : _body('body2'));
  }
}
