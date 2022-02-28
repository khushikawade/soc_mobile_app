import 'package:Soc/src/modules/custom/bloc/custom_bloc.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_Bar_widget.dart';

import 'package:Soc/src/modules/shared/ui/common_list_widget.dart';

import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';

import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Soc/src/globals.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';

class CustomPage extends StatefulWidget {
  final id;
  final obj;
  final searchObj;
  CustomPage({
    Key? key,
    this.obj,
    required this.id,
    this.searchObj,
  }) : super(key: key);

  @override
  _CustomPageState createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  // static const double _kLabelSpacing = 10.0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  CustomBloc _bloc = CustomBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  HomeBloc _homeBloc = HomeBloc();
  bool? iserrorstate = false;

  @override
  void initState() {
    super.initState();
    _bloc.add(CustomsEvent(id: widget.id));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _bloc.add(CustomsEvent(id: widget.id));
    _homeBloc.add(FetchBottomNavigationBar());
  }

  Widget _body(state) => Container(
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
                    _bloc.add(CustomsEvent(id: widget.id));
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
                      child: CommonListWidget(
                          scaffoldKey: _scaffoldKey,
                          connected: connected,
                          data: state.obj!,
                          sectionName: "Custom"),
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
      body:
          // Globals.appSetting.CustomBannerImageC != null &&
          //          Globals.appSetting.CustomBannerImageC  != ''
          // // Globals.homeObject["Custom_Banner_Image__c"] != null &&
          // //         Globals.homeObject["Custom_Banner_Image__c"] != ''
          //     ? NestedScrollView(
          //         // controller: _scrollController,
          //         headerSliverBuilder:
          //             (BuildContext context, bool innerBoxIsScrolled) {
          //           return <Widget>[
          //             Globals.appSetting.CustomBannerImageC != null
          //             // Globals.homeObject["Custom_Banner_Image__c"] != null
          //                 ? BannerImageWidget(
          //                     imageUrl:
          //                     Globals.appSetting.CustomBannerImageC!,
          //                         // Globals.homeObject["Custom_Banner_Image__c"],
          //                     bgColor:
          //                     Globals.appSetting.CustomBannerColorC
          //                         // Globals.homeObject["Custom_Banner_Color__c"]
          //                          !=
          //                                 null
          //                             ? Utility.getColorFromHex(
          //                               Globals.appSetting.CustomBannerColorC!
          //                               // Globals.homeObject["Custom_Banner_Color__c"]
          //                                 )
          //                             : null,
          //                   )
          //                 : SliverAppBar(),
          //           ];
          //         },
          //         body: _body('body1'))
          //   :
          BlocBuilder<CustomBloc, CustomState>(
              bloc: _bloc,
              builder: (BuildContext contxt, CustomState state) {
                if (state is CustomInitial || state is CustomLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is CustomDataSucess) {
                  // print('List data......');
                  // print(state.obj);
                  return bannerWidget(state);
                } else if (state is ErrorLoading) {
                  return ListView(children: [ErrorMsgWidget()]);
                } else {
                  return Container();
                }
              }),
    );
  }

  Widget bannerWidget(state) {
    return NestedScrollView(
        // controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            // Globals.appSetting.CustomBannerImageC != null
            //     // Globals.homeObject["Custom_Banner_Image__c"] != null
            //     ? BannerImageWidget(
            //         imageUrl: Globals.appSetting.CustomBannerImageC!,
            //         // Globals.homeObject["Custom_Banner_Image__c"],
            //         bgColor: Globals.appSetting.CustomBannerColorC
            //                 // Globals.homeObject["Custom_Banner_Color__c"]
            //                 !=
            //                 null
            //             ? Utility.getColorFromHex(
            //                 Globals.appSetting.CustomBannerColorC!
            //                 // Globals.homeObject["Custom_Banner_Color__c"]
            //                 )
            //             : null,
            //       )
            //     :
            SliverAppBar(),
          ];
        },
        body: _body(state));
  }
}
