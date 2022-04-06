import 'package:Soc/src/modules/custom/bloc/custom_bloc.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_Bar_widget.dart';
import 'package:Soc/src/modules/shared/ui/common_grid_widget.dart';
import 'package:Soc/src/modules/shared/ui/common_list_widget.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/banner_image_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Soc/src/globals.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import '../model/custom_setting.dart';

class CustomAppSection extends StatefulWidget {
  CustomAppSection({
    Key? key,
    required this.homeObj,
    this.id,
    this.searchObj,
  }) : super(key: key);

  final id;
  final CustomSetting homeObj;
  final searchObj;

  @override
  _CustomAppSectionState createState() => _CustomAppSectionState();
}

class _CustomAppSectionState extends State<CustomAppSection> {
  bool? iserrorstate = false;
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  CustomBloc _bloc = CustomBloc();
  HomeBloc _homeBloc = HomeBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _bloc.add(CustomEvents(id: widget.homeObj.id));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    _bloc.add(CustomEvents(id: widget.homeObj.id));
    _homeBloc.add(FetchStandardNavigationBar());
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarWidget(
        marginLeft: 30,
        refresh: (v) {
          setState(() {});
        },
      ),
      body: widget.homeObj.customBannerImageC != null &&
              widget.homeObj.customBannerImageC != ''
          ? NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  BannerImageWidget(
                    imageUrl: widget.homeObj.customBannerImageC!,
                    bgColor: widget.homeObj.customBannerImageC != null
                        ? Utility.getColorFromHex(
                            widget.homeObj.customBannerImageC!)
                        : null,
                  )
                ];
              },
              body: _body('body2'),
            )
          : _body('body1'),
    );
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
                    _bloc.add(CustomEvents(id: widget.homeObj.id));
                    iserrorstate = false;
                  }
                } else if (!connected) {
                  iserrorstate = true;
                }

                return
                    // connected?
                    Stack(
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    BlocBuilder<CustomBloc, CustomState>(
                        bloc: _bloc,
                        builder: (BuildContext contxt, CustomState state) {
                          if (state is CustomInitial ||
                              state is CustomLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is CustomDataSucess) {
                            return widget.homeObj.gridViewC == "true"
                                ? CommonGridWidget(
                                    scaffoldKey: _scaffoldKey,
                                    connected: connected,
                                    data: state.obj!,
                                    sectionName: "Custom")
                                : CommonListWidget(
                                    scaffoldKey: _scaffoldKey,
                                    connected: connected,
                                    data: state.obj!,
                                    sectionName: "Custom");
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
}
