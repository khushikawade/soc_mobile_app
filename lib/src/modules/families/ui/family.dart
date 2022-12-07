import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/widgets/banner_image_widget.dart';
import 'package:Soc/src/modules/shared/ui/common_list_widget.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Soc/src/globals.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import '../../../widgets/empty_container_widget.dart';
import '../../custom/model/custom_setting.dart';
import '../../home/ui/app_bar_widget.dart';
import '../../shared/ui/common_grid_widget.dart';

class FamilyPage extends StatefulWidget {
  final obj;
  final searchObj;
  final CustomSetting? customObj;
  final bool? isCustomSection;

  FamilyPage(
      {Key? key,
      this.obj,
      this.searchObj,
      this.customObj,
      required this.isCustomSection})
      : super(key: key);

  @override
  _FamilyPageState createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FamilyBloc _bloc = FamilyBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  HomeBloc _homeBloc = HomeBloc();
  bool? iserrorstate = false;
  bool? isCustomApp;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //lock screen orientation
    // Utility.setLocked();
    _bloc.add(FamiliesEvent());
    var brightness = SchedulerBinding.instance.window.platformBrightness;

    if (brightness == Brightness.dark && Globals.disableDarkMode != true) {
      Globals.themeType = 'Dark';
    }
    FirebaseAnalyticsService.addCustomAnalyticsEvent("families");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'family', screenClass: 'FamilyPage');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    _bloc.add(FamiliesEvent());
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
                    _bloc.add(FamiliesEvent());
                    iserrorstate = false;
                  }
                } else if (!connected) {
                  iserrorstate = true;
                }

                return
                    // connected?
                    ListView(
                  shrinkWrap: true,
                  //  mainAxisSize: MainAxisSize.max,
                  children: [
                    BlocBuilder<FamilyBloc, FamilyState>(
                        bloc: _bloc,
                        builder: (BuildContext contxt, FamilyState state) {
                          if (state is FamilyInitial ||
                              state is FamilyLoading) {
                            return Center(
                                child: CircularProgressIndicator(
                              color:
                                  Theme.of(context).colorScheme.primaryVariant,
                            ));
                          } else if (state is FamiliesDataSucess) {
                            return widget.customObj != null &&
                                    widget.customObj!.sectionTemplate ==
                                        "Grid Menu"
                                ? CommonGridWidget(
                                    scrollController: _scrollController,
                                    scaffoldKey: _scaffoldKey,
                                    connected: connected,
                                    data: state.obj!,
                                    sectionName: "family")
                                : CommonListWidget(
                                    scrollController: _scrollController,
                                    key: ValueKey(key),
                                    scaffoldKey: _scaffoldKey,
                                    connected: connected,
                                    data: state.obj!,
                                    sectionName: "family");
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
              },
              child: Container()),
          onRefresh: refreshPage,
        ),
      );

  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Theme.of(context).backgroundColor,
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
        body: Globals.appSetting.familyBannerImageC != null &&
                Globals.appSetting.familyBannerImageC != ''
            ? NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    Globals.appSetting.familyBannerImageC != null
                        ? BannerImageWidget(
                            imageUrl: Globals.appSetting.familyBannerImageC!,
                            bgColor:
                                Globals.appSetting.familyBannerColorC != null
                                    ? Utility.getColorFromHex(
                                        Globals.appSetting.familyBannerColorC!)
                                    : Colors.transparent)
                        : SliverAppBar(),
                  ];
                },
                body: _body('body1'))
            : _body('body2'));
  }
}
