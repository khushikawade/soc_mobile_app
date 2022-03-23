import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_Bar_widget.dart';
import 'package:Soc/src/widgets/banner_image_widget.dart';
import 'package:Soc/src/modules/shared/ui/common_list_widget.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Soc/src/globals.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';

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

  @override
  void initState() {
    super.initState();
    _bloc.add(FamiliesEvent());
    var brightness = SchedulerBinding.instance!.window.platformBrightness;

    if (brightness == Brightness.dark) {
      Globals.themeType = 'Dark';
    } else {
      
    }
    // bool isDarkMode = brightness == Brightness.dark;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
     await Future.delayed(Duration(seconds: 2));
    _bloc.add(FamiliesEvent());
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
                    _bloc.add(FamiliesEvent());
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
                    Expanded(
                      child: BlocBuilder<FamilyBloc, FamilyState>(
                          bloc: _bloc,
                          builder: (BuildContext contxt, FamilyState state) {
                            if (state is FamilyInitial ||
                                state is FamilyLoading) {
                              return Center(child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.primaryVariant,
                              ));
                            } else if (state is FamiliesDataSucess) {
                              // print('List data......');
                              // print(state.obj);
                              return CommonListWidget(
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
                              // Globals.homeObject = state.obj;
                               Globals.appSetting = AppSetting.fromJson(state.obj);

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
         //backgroundColor: Theme.of(context).backgroundColor,
        key: _scaffoldKey,
        appBar: AppBarWidget(
          marginLeft: 30,
          refresh: (v) {
            setState(() {});
          },
        ),
        body: 
        Globals.appSetting.familyBannerImageC != null &&
                 Globals.appSetting.familyBannerImageC  != ''
        // Globals.homeObject["Family_Banner_Image__c"] != null &&
        //         Globals.homeObject["Family_Banner_Image__c"] != ''
            ? NestedScrollView(
                // controll    er: _scrollController,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    Globals.appSetting.familyBannerImageC != null
                    // Globals.homeObject["Family_Banner_Image__c"] != null
                        ? BannerImageWidget(
                            imageUrl:
                            Globals.appSetting.familyBannerImageC!,
                                // Globals.homeObject["Family_Banner_Image__c"],
                            bgColor:
                            Globals.appSetting.familyBannerColorC
                                // Globals.homeObject["Family_Banner_Color__c"]
                                 !=
                                        null
                                    ? Utility.getColorFromHex(
                                      Globals.appSetting.familyBannerColorC!
                                      // Globals.homeObject["Family_Banner_Color__c"]
                                        )
                                    : null,
                          )
                        : SliverAppBar(),
                  ];
                },
                body: _body('body1'))
            : _body('body2'));
  }
}
